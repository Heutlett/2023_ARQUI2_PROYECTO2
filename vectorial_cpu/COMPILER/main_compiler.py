import math
from shutil import copyfile
from src.ClassCompiler import Compiler


in_ = "program.asm"
out_ = "inst_mem_init.dat"
run_ = "..\\VECTOR_CPU\\MODULES\\inst_mem_init.dat"

compiler = Compiler(in_, out_)

copyfile("inst_mem_init.dat", run_)

# Last address
data = 3
pixeles = math.ceil(256 * 256 / 6) + data
n = 0
while n <= pixeles:
    n += 16
    # print(n, hex(n))
print(
    "RAM last address: ",
    n,
    "\naddressing: bin - ",
    n * 4,
    " hex - ",
    hex(n * 4).upper(),
)
print("43712 mod 16: ", 43712 % 16)
