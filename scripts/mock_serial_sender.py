import serial
import time

# Connect to "Side A" of our virtual serial cable
# 9600 is standard baud rate, adjust later if your hardware differs
port = '/tmp/ttyV0' 

try:
    ser = serial.Serial(port, 9600)
    print(f"Mock Serial Sender started on {port}...")
    
    while True:
        # Sending 4 space-separated numbers followed by a newline
        data_string = "0.0 0.1 0.5\n"   # changed fake data to be 3 values, vx vy omegaz
        ser.write(data_string.encode('utf-8'))
        
        # Send 10 times a second (10Hz)
        time.sleep(0.1)
        
except Exception as e:
    print(f"Error: {e}")
    print("Did you run the socat command to create the virtual ports?")