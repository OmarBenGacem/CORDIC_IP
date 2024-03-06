import math
import struct
import numpy as np
import matplotlib.pyplot as plt
from binary_fractions import TwosComplement, Binary
import random
import json as j
import bin_cordic

def accuracy_testbench(model, min_bits=8, max_bits=80, min_depth=4, max_depth=len(angles_degrees), num_trials = 200):
    
    experiments = []
    if 1:
        for dep in range(min_depth, max_depth):
            for bitz in range(min_bits, max_bits):
                #def bin_cordic(target_decimal, IB=INT_BITS, FB=FRAC_BITS, mode="debug"):
                ave = 0
                test = []
                for i in range(num_trials):
                    random_number = random.uniform(0, 1)
                    sample = float(model(random_number, FB=bitz, depth=dep, mode="return_actual_error"))
                    ave += sample
                    test.append(sample)
                    
                print(f"for {bitz} fractional bits, the error is: {ave/num_trials}")
                experiments.append({"depth": dep, "bits": bitz, "error": ave/num_trials, "trials": test})

    
    
    def write_list_to_json(data_list, file_path):
        with open(file_path, 'w') as json_file:
            j.dump(data_list, json_file)


    file_path = 'data.json'  # Path to the JSON file
    write_list_to_json(experiments, file_path)

accuracy_testbench(bin_cordic)
    