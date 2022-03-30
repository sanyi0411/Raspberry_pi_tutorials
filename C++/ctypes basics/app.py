import sys
import ctypes
from ctypes import *

if sys.platform == "win32":
    lib = cdll.LoadLibrary("./build/Debug/CtypesBasics.dll")
elif sys.platform == "linux":
    lib = cdll.LoadLibrary("./build/libCtypesBasics.so")

# By default ctypes assumes that every parameter and return value is an integer
# So we have to expicitly tell it if it is something different:

# Here we specify the return types for every function that returns something other than an int:
lib.Test_multiply.restype = ctypes.c_float
lib.Test_divide.restype = ctypes.c_longdouble
lib.Test_returnCharPtr.restype = ctypes.c_char_p
lib.Test_takeCharPtr.restype = ctypes.c_float
lib.Test_takeAndReturnCharPtr.restype = ctypes.c_char_p

# You can also specify the types of the arguments
# But in this case we will not use them because we explicitly convert them when we pass the parameters (see below)
# lib.Test_divide.argtypes = [ctypes.c_float, ctypes.c_float]

class Test(object):
    def __init__(self):
        self.obj = lib.Test_new()

    def add(self, a, b):
        return lib.Test_add(self.obj, a, b)

    def multiply(self, a, b):
        return lib.Test_multiply(self.obj, a, b)

    def divide(self, a ,b):
        return lib.Test_divide(self.obj, a, b)

    def returnCharPtr(self, num):
        return lib.Test_returnCharPtr(self.obj, num)

    def takeCharPtr(self, inp):
        return lib.Test_takeCharPtr(self.obj, inp)

    def takeAndReturnCharPtr(self, inp, num):
        return lib.Test_takeAndReturnCharPtr(self.obj, inp, num)


# Initialization
test = Test()

# Note the different outputs
dnum = 3.1415926535
print("num: ", dnum)
c_dnum = ctypes.c_double(dnum)
print("c_num: ", c_dnum)
print("c_num.value", c_dnum.value)
print("")

# Calling all the member functions
print("add: ", test.add(5, 3))
print("multiply: ", test.multiply(4, ctypes.c_float(3.125)))
print("divide: ", test.divide(ctypes.c_float(4.5), ctypes.c_float(1.5)))
print("")

# Note the loss of precision compared to dnum
# TODO: Why is that? Let me know if you have an answer
ret = test.returnCharPtr(c_dnum)
print("returnCharPtr: ", ret)

str = create_string_buffer(b"Hello World")
print("takeCharPtr: ", test.takeCharPtr(str))

str2 = create_string_buffer(b"Hello ctypes")
ret = test.takeAndReturnCharPtr(str2, ctypes.c_float(1234))
print("takeAndReturnCharPtr: ", ret)