import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist
import serial
import math

# ── Sensor physical positions (metres) ──────────────────────────
# Matching control.c coordinate definitions:
#   F1 = front-left  (-x, +y)
#   F2 = front-right (+x, +y)
#   F3 = back-left   (-x, -y)
#   F4 = back-right  (+x, -y)
#
# STM32 serial order (tokens 5-8): [0, 1, 2, 3]
#   0 = front-right → F2
#   1 = back-right  → F4
#   2 = front-left  → F1
#   3 = back-left   → F3
#
# VERIFY THIS MAPPING WITH YOUR TEAMMATE before trusting the direction output.

SENSOR_X = [-2.0, 2.0, -2.0, 2.0]   # F1, F2, F3, F4
SENSOR_Y = [ 2.0, 2.0, -2.0,-2.0]   # F1, F2, F3, F4

KV = 2.0    # velocity gain  (from control.c)
KW = 1.5    # angular gain   (from control.c)
DT = 0.05   # matches timer period (50 ms)

class WeightToCmdVel(Node):
    def __init__(self):
        super().__init__('weight_to_cmd_vel')

        self.publisher_ = self.create_publisher(Twist, '/cmd_vel', 10)
        self.serial_port = serial.Serial('/dev/ttyACM0', 115200, timeout=0.1)

        # Control algorithm state
        self.initial_cop_x = None   # set from first valid reading
        self.initial_cop_y = None
        self.prev_theta    = 0.0

        self.timer = self.create_timer(DT, self.timer_callback)
        self.get_logger().info("WeightToCmdVel started — reading /dev/ttyACM0")

    def parse_sensors(self, line):
        """
        Parse a line like: C 21182 6185 23027 -3569 22477 7223 20714 -3771
        Returns (F1, F2, F3, F4) remapped from STM32 serial order, or None on failure.
        """
        parts = line.split()

        # Expect 9 tokens: 'C' + 8 numbers
        if len(parts) != 9 or parts[0] != 'C':
            return None

        try:
            raw = [float(p) for p in parts[1:]]  # 8 numbers
        except ValueError:
            return None

        # Last 4 are the filtered readings in STM32 order: [0, 1, 2, 3]
        s0, s1, s2, s3 = raw[4], raw[5], raw[6], raw[7]
        #  0=front-right, 1=back-right, 2=front-left, 3=back-left

        # Remap to F1..F4 order expected by the CoP algorithm
        F1 = s2   # front-left
        F2 = s0   # front-right
        F3 = s3   # back-left
        F4 = s1   # back-right

        return F1, F2, F3, F4

    def compute_cop(self, F1, F2, F3, F4):
        """Compute centre of pressure from four corner forces."""
        forces = [F1, F2, F3, F4]
        sumF   = sum(forces) + 1e-6
        cop_x  = sum(f * SENSOR_X[i] for i, f in enumerate(forces)) / sumF
        cop_y  = sum(f * SENSOR_Y[i] for i, f in enumerate(forces)) / sumF
        return cop_x, cop_y

    def timer_callback(self):
        if self.serial_port.in_waiting == 0:
            return

        line = self.serial_port.readline().decode('utf-8', errors='replace').strip()
        sensors = self.parse_sensors(line)

        if sensors is None:
            self.get_logger().warn(f"Skipping unrecognised line: {line}")
            return

        F1, F2, F3, F4 = sensors
        cop_x, cop_y   = self.compute_cop(F1, F2, F3, F4)

        # ── Initialise baseline on first valid reading ───────────
        if self.initial_cop_x is None:
            self.initial_cop_x = cop_x
            self.initial_cop_y = cop_y
            self.get_logger().info(
                f"Baseline CoP set: ({cop_x:.3f}, {cop_y:.3f})")
            return  # skip publishing on the calibration frame

        # ── Polar conversion (displacement from baseline) ────────
        dx    = cop_x - self.initial_cop_x
        dy    = cop_y - self.initial_cop_y
        r     = math.hypot(dx, dy)
        theta = math.atan2(dy, dx)

        # ── Control outputs (matching control.c) ────────────────
        v     = KV * r
        omega = KW * (theta - self.prev_theta) / DT
        self.prev_theta = theta

        # ── Publish ──────────────────────────────────────────────
        msg             = Twist()
        msg.linear.x    = v
        msg.linear.y    = 0.0   # differential drive — always 0
        msg.angular.z   = omega
        self.publisher_.publish(msg)

        self.get_logger().info(
            f"CoP=({cop_x:.3f},{cop_y:.3f})  r={r:.3f}  θ={theta:.3f}  "
            f"v={v:.3f}  ω={omega:.3f}")


def main(args=None):
    rclpy.init(args=args)
    node = WeightToCmdVel()
    try:
        rclpy.spin(node)
    except KeyboardInterrupt:
        pass
    finally:
        node.serial_port.close()
        node.destroy_node()
        rclpy.shutdown()

if __name__ == '__main__':
    main()