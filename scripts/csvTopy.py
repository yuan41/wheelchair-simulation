<<<<<<< HEAD
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv('./turtle1_cmd_vel.csv')

# print(df)

timestamp = df['timestamp'].to_numpy()
linear_x  = df['linear.x'].to_numpy()
linear_y  = df['linear.y'].to_numpy()
linear_z  = df['linear.z'].to_numpy()
angular_x = df['angular.x'].to_numpy()
angular_y = df['angular.y'].to_numpy()
angular_z = df['angular.z'].to_numpy()

dt = 0.01 #Step Size
t = np.linspace(start = 0, stop = dt*timestamp.shape, num= timestamp.shape, endpoint=True )
    
fig, axs = plt.subplots(3)
fig.suptitle('Plots')
axs[0].plot(t, linear_x)
axs[0].set_title('Vx')
axs[1].plot(t, linear_y)
axs[1].set_title('Vy')
axs[2].plot(t, angular_z)
axs[2].set_title('Wz')

# print(type(linear_x)) #numpy arrays

print(f"Recorded {len(timestamp)} messages")
print(f"Max linear speed:  {linear_x.max()}")
print(f"Max linear speed:  {linear_y.max()}")
print(f"Max angular speed: {angular_z.max()}")
=======
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
>>>>>>> 656666fde0b5981c34dc1cc26169f2c415407b9a
