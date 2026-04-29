import numpy as np
import pandas as pd

df = pd.read_csv('./turtle1_cmd_vel.csv')

# print(df)

timestamp = df['timestamp'].to_numpy()
linear_x  = df['linear.x'].to_numpy()
linear_y  = df['linear.y'].to_numpy()
linear_z  = df['linear.z'].to_numpy()
angular_x = df['angular.x'].to_numpy()
angular_y = df['angular.y'].to_numpy()
angular_z = df['angular.z'].to_numpy()

# print(type(linear_x)) #numpy arrays

print(f"Recorded {len(timestamp)} messages")
print(f"Max linear speed:  {linear_x.max()}")
print(f"Max linear speed:  {linear_y.max()}")
print(f"Max angular speed: {angular_z.max()}")