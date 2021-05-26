#!/bin/bash

mil_run mil_code.mil
mil_run mil_code.mil < input.txt
# mil_run
cat fibonacci.min | my_compiler
echo 5 > input.txt
mil_run fibonacci.mil < input.txt