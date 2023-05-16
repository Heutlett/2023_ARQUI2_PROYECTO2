import os
import re
from src.ClassBinary import Binary
from src.ClassBinary import opcode_dict


class Compiler:
    labels = []
    instructions = []
    errors = []
    comment = "@"

    def __init__(self, in_file, out_file):
        self.i_file = self.get_path(in_file)
        self.o_file = self.get_path(out_file)
        self.compile()

    def get_path(self, relative_path):
        return os.path.join(os.getcwd(), relative_path)

    def __str__(self):
        return f"{self.i_file}({self.o_file})"

    def compile(self):
        self.read()
        self.run()
        # self.write()
        print(f"\33[32m" + "\nSe ha compilado el programa correctamente\n" + "\33[0m")

    def read(self):
        with open(self.i_file) as file:
            self.lines = file.readlines()

    def write(self):
        with open(self.o_file, "w") as file:
            for i in range(0, len(self.instructions) - 1):
                print(self.instructions[i])
                file.write(self.instructions[i] + "\n")
            file.write(self.instructions[len(self.instructions) - 1])

        file.close()

    def run(self):
        self.remove_noise()
        labels, instr = self.extract_instr()
        Binary.Labels = labels
        self.instructions = list(map(self.parse, instr))
        
    def parse(self, x):
        instr = Binary(Line=x["line"], Mnemonic=x["mnem"], Rest=x["body"])
        # print(instr)
        return instr.getHex()

    def remove_noise(self):
        tmp = []
        for ln in self.lines:
            ln = (
                ln.split(self.comment)[0]
                .replace("\t", " ")
                .replace("\n", " ")
                .strip()
                .lower()
            )
            ln = ln[: ln.find(" ") + 1] + ln[ln.find(" ") + 1 :].replace(" ", "")
            tmp.append(ln)
        self.lines = tmp

    def extract_instr(self):
        # Regular expression to verify labels
        start_with = "^[A-Za-z_][A-Za-z0-9_]*"
        end_with = ":\Z"

        # Variables
        counter = 0
        labels = {}
        instr = []

        for i in range(len(self.lines)):
            ln = self.lines[i]

            # Skip blank
            if not ln:
                counter += 1
                continue

            # Check if line is a valid label
            if re.findall(end_with, ln):  # Termina con ":"
                if not re.findall(start_with, ln):  # Todo antes de los ":"
                    print(f"Err (en {i+1}): formato incorrecto.")
                    break

                label = ln[:-1]
                if label in labels:
                    print(f"Err (en {i+1}): etiqueta repetida.")
                    break

                labels[label] = (i + 1) - len(labels) - counter
                continue

            # Check if line is a valid instruction
            ln = ln.split(" ")
            for key in opcode_dict:
                if key.lower() == ln[0]:
                    if len(ln) == 2:
                        x = {"line": i + 1, "mnem": ln[0], "body": ln[1]}
                    else:
                        x = {"line": i + 1, "mnem": ln[0], "body": False}
                    instr.append(x)

        labels = list(labels.items())
        return labels, instr


