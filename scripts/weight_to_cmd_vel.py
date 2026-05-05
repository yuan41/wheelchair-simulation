import rclpy
from rclpy.node import Node
from geometry_msgs.msg import Twist
import serial

class WeightToCmdVel(Node):
    def __init__(self):
        super().__init__('weight_to_cmd_vel')
        
        # Create a publisher on the ROS 2 /cmd_vel topic
        self.publisher_ = self.create_publisher(Twist, '/cmd_vel', 10)
        
        # Connect to "Side B" of our virtual serial cable
        # for real hardware, change to '/dev/ttyUSB0' or '/dev/ttyACM0'
        # for fake serial, change to '/tmp/ttyV1'
        # self.serial_port = serial.Serial('/dev/ttyUSB0', 115200, timeout=0.1)  
        self.serial_port = serial.Serial('/dev/ttyACM0', 115200, timeout=0.1)  
        #self.serial_port = serial.Serial('/tmp/ttyV1', 115200, timeout=0.1)
        # Timer to check the serial port 20 times a second (50ms)
        self.timer = self.create_timer(0.05, self.timer_callback)
        self.get_logger().info("Weight to CmdVel Node Started. Listening to /tmp/ttyV1 or /dev/ttyUSB0...")

    def timer_callback(self):
        if self.serial_port.in_waiting > 0:
            # Read line and clean whitespace
            line = self.serial_port.readline().decode('utf-8').strip()
            
            # Split the string into a list of strings: ['1.0', '0.0', '1.0', '0.0']
            parts = line.split() 
            
            if len(parts) == 3:  # changed to 3
                try:
                    # Convert to floats
                    num1 = float(parts[0])
                    num2 = float(parts[1])
                    num3 = float(parts[2])

                    # ==========================================
                    # INSERT YOUR CUSTOM CALCULATIONS HERE
                    # For testing, we just output arbitrary speeds
                    calculated_linear_x = num1 
                    calculated_linear_y = num2  
                    calculated_angular_z = num3 
                    # ==========================================

                    # Create the ROS message
                    msg = Twist()
                    msg.linear.x = calculated_linear_x
                    msg.linear.y = calculated_linear_y
                    msg.angular.z = calculated_angular_z
                    
                    # Publish the command
                    self.publisher_.publish(msg)
                    self.get_logger().info(f"Published: linear={msg.linear.x}, linear={msg.linear.y}, angular={msg.angular.z}")
                    
                except ValueError:
                    self.get_logger().error("Received bad data (not numbers)")

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