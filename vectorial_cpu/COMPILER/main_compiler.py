
from shutil import copyfile
from src.ClassCompiler import Compiler


in_ = "program.asm"
out_ = "../VECTOR_CPU/inst_mem_init.dat"
compiler = Compiler(in_, out_)

copyfile("inst_mem_init.dat", out_)