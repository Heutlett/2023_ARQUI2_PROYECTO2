from shutil import copyfile
from src.ClassCompiler import Compiler


in_ = "program.asm"
out_ = "inst_mem_init.dat"
run_ = "..\\VECTOR_CPU\\MODULES\\inst_mem_init.dat"

compiler = Compiler(in_, out_)

copyfile("inst_mem_init.dat", run_)