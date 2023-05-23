import os
import re
from src.ClassBinary import Binary
from src.ClassBinary import opcode_dict


class Compiler:
    labels = []
    instructions = []
    error = False
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

        if not self.error:
            self.write()
            print(f"\33[32m" + " \n¡Compilación exitosa..!" + "\33[0m")
            print(f"\33[33m" + f"Instrucciones: {self.n}\n" + "\33[0m")

    def read(self):
        with open(self.i_file) as file:
            self.lines = file.readlines()

    def write(self):
        self.n = len(self.instructions)
        with open(self.o_file, "w") as file:
            for i in range(self.n - 1):
                file.write(self.instructions[i] + "\n")
            file.write(self.instructions[len(self.instructions) - 1])

        file.close()

    def run(self):
        self.remove_noise()
        labels, instr = self.extract_instr()

        if self.error:
            return
        Binary.Labels = labels
        self.instructions = []
        for i in instr:
            out = self.parse(i)

            if len(out) != 8:
                text = f"ERROR (linea {out.Line}): tamaño del binario incorrecto."
                print("\33[31m" + text + "\33[0m")
                self.error == True

            if self.error == True:
                break

            self.instructions.append(out)

    def parse(self, x):
        instr = Binary(Line=x["line"], Mnemonic=x["mnem"], Rest=x["body"])
        if instr.Error == True:
            self.error == True
            return
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
                    text = f"ERROR (linea {i+1}): formato incorrecto."
                    print("\33[31m" + text + "\33[0m")
                    self.error = True
                    break

                label = ln[:-1]
                if label in labels:
                    text = f"ERROR (linea {i+1}): etiqueta repetida."
                    print("\33[31m" + text + "\33[0m")
                    self.error = True
                    break

                labels[label] = (i + 1) - len(labels) - counter
                continue

            # Check if line is a valid instruction
            ln = ln.split(" ")
            for key in opcode_dict:
                if key.lower() == ln[0]:
                    if len(ln) == 2:
                        if ln[0] not in ["mov", "ldr"]:
                            if (
                                "rs" == ln[1][0:1]
                            ):  # Si RA es escalar y no es MOV o LDR, esta mal
                                text = f"ERROR (linea {i+1}): No se acepta RA escalar en {ln[0].upper()}."
                                print("\33[31m" + text + "\33[0m")
                                self.error = True
                                break

                        elif ln[0] == "mov":
                            ra, rb = ln[1].split(",")
                            if (
                                not ("rv" in ra and "rv" in rb)
                                and not ("rv" in ra and "ra" in rb)
                                and not ("ra" in ra and "rv" in rb)
                                and not ("ra" in ra and "ra" in rb)
                                and not ("rs" in ra and "rs" in rb)
                                and not ("rs" in ra and "#" in rb)
                            ):
                                text = f"ERROR (linea {i+1}): Las dimensiones de '{ra.upper()}' y '{rb.upper()}' no coincidir en el {ln[0].upper()}."
                                print("\33[31m" + text + "\33[0m")
                                self.error = True
                                break

                        x = {"line": i + 1, "mnem": ln[0], "body": ln[1]}
                    else:
                        x = {"line": i + 1, "mnem": ln[0], "body": False}

                    instr.append(x)

        labels = list(labels.items())
        return labels, instr
