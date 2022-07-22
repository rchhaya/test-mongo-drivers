from email.mime import base
from os import remove
import numpy as np 
def remove_outliers(arr):
    #print(arr)
    q75, q50, q25 = np.percentile(arr, [75 , 50, 25])
    iqr = q75 - q25
    upper = q75 + 1.5 * iqr
    lower = q25 - 1.5 * iqr
    #print(upper)
    #arr = np.all([arr < upper and arr < lower]
    #arr = arr[arr > lower]
    for i in range(len(arr)): 
        if arr[i] > upper or arr[i] < lower: 
            arr[i] = q50
    #print(arr)
    return arr

langs = ["Swift-", "Node-", "Go-", "Csharp-", "Rust-", "Python-", "Java-"]
avg = []
stdev = []
for lang in langs: 
    watts = []
    for i in range(1, 6): 
        filename = "/Users/rohan.chhaya/Documents/driver-logs/" + lang + str(i) + ".csv"
        output = np.genfromtxt(filename,delimiter=',',dtype=np.float16)
        data = output[:, 3]
        data = data[1:]
        #First 6 and last 4-5 are not important 
        reimann = sum(data)
        baseline_data = np.append(data[1:4], data[-5: -1])
        baseline_data = baseline_data[baseline_data < 1]
        #print(baseline_data)
        baseline = np.mean(baseline_data)
        wattage = max(reimann - (baseline * np.size(data)), 0)
        watts.append(wattage)
        #print(watts[i-1])
    #print(watts)
    watts = np.array(watts)
    watts = remove_outliers(watts)
    print(watts)
    watts = watts[watts >= 0]
    avg.append(np.mean(watts))
    stdev.append(np.std(watts))


print("----")
print(avg)
print(stdev)