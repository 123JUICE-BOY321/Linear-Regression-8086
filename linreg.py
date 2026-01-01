import numpy as np

x = np.array([2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024])
y = np.array([76, 80, 83, 92, 101, 91, 111, 132, 136, 137])
# y = np.array([7664, 8014, 8398, 9251, 10131, 9119, 11115, 13221, 13663, 13752])

x_mean = np.mean(x)
y_mean = np.mean(y)
num = np.sum((x - x_mean) * (y - y_mean))
den = np.sum((x - x_mean) ** 2)
slope = num / den
intercept = y_mean - slope * x_mean

print("Ferrari Data Linear Regression")
print("------------------------------")
print("Mean of X:", x_mean)
print("Mean of Y:", y_mean)
print(f"Slope (m): {slope:.2f}")
print(f"Intercept (c): {intercept:.2f}")
x_pred = input("Enter a year to predict Ferrari sales: ")
y_pred = slope * x_pred + intercept
print(f"Predicted Ferrari sales (in hundreds) = {y_pred:.2f}")