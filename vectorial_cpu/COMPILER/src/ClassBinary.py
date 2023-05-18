from enum import Enum


class Type(Enum):
    SYSTEM = "00"
    DATA = "01"
    MEMORY = "10"
    CONTROL = "11"


types_dict = {
    Type.SYSTEM: ["nop", "com", "end"],
    Type.DATA: [
        "addv",
        "adds",
        "movv",
        "movs",
        "xorv",
        "xors",
        "orv",
        "ors",
        "shrv",
        "shrs",
        "shlv",
        "shls",
        "cmpv",
        "cmps",
        "subs",
        "subv",
    ],
    Type.MEMORY: ["ldr", "str"],
    Type.CONTROL: ["jmp", "jeq", "jlt"],
}

opcode_dict = {
    # System
    "nop": "00",
    "com": "01",
    "end": "10",
    # Data
    "addv": "000",
    "adds": "000",
    "movv": "001",
    "movs": "001",
    "xorv": "010",
    "xors": "010",
    "orv": "011",
    "ors": "011",
    "shrv": "100",
    "shrs": "100",
    "shlv": "101",
    "shls": "101",
    "cmps": "110",
    "cmpv": "110",
    "subs": "111",
    "subv": "111",
    # Memory
    "ldr": "0",
    "str": "1",
    # Control
    "jmp": "00",
    "jeq": "01",
    "jlt": "10",
}

getbinary = lambda x, n: format(x, "b").zfill(n)

regs_dict = {
    # Scalar
    "rs1": "0000",
    "rs2": "0001",
    "rs3": "0010",
    "rs4": "0011",
    "rs5": "0100",
    "rs6": "0101",
    # Vectorial
    "rv1": "0001",
    "rv2": "0010",
    "rv3": "0011",
    "rv4": "0100",
    "rv5": "0101",
    "rv6": "0110",
    "rv7": "0111",
    "rv8": "1000",
    "rv9": "1001",
    "rv10": "1010",
    # Address
    "ra1": "1011",
    "ra2": "1100",
    "ra3": "1101",
    "ra4": "1110",
    "ra5": "1111",
}


class Binary:
    IMM_SIZE = 8
    REG_SIZE = 4
    Labels = []

    color_system = "33"
    color_memory = "34"
    color_data3 = "35"
    color_data2 = "36"
    color_control = "31"

    def __init__(self, Mnemonic, Rest, Line):
        self.Line = Line
        self.Mnemonic = Mnemonic
        self.Rest = Rest
        self.Bin = "0" * 32

        # Diccionario para asociar cada tipo de instrucción con su método correspondiente
        self.type_to_method = {
            Type.SYSTEM: self.system,
            Type.DATA: self.data,
            Type.MEMORY: self.memory,
            Type.CONTROL: self.control,
        }

        self.process()

    def __str__(self):
        return self.Bin

    def getHex(self):
        hstr = "%0*X" % ((len(self.Bin) + 3) // 4, int(self.Bin, 2))
        return hstr

    # Funcion para procesar las instrucciones
    def process(self):
        # Get Type
        self.Type = "UNDEFINED"
        for key, values in types_dict.items():  # analizar en cada uno de los tipos
            if self.Mnemonic in values:  # si se encuentra dentro del array.
                self.Type = key
                break

        # Get Mnemonic
        self.Opcode = opcode_dict[self.Mnemonic]

        # Actuar de acuerdo con el tipo.
        method = self.type_to_method.get(self.Type)
        if method:
            method()
        else:
            print(f"Err[ln {self.Line}]: No se ha encontrado '{self.Mnemonic.upper()}'")

    # Funcion para instrucciones del sistema
    def system(self):
        # Get String
        str = f"{self.Type.value} {self.Opcode} 000 {0:025b}"
        self.Bin = str.replace(" ", "")

        # Prints
        line = f"\n➤  line : {self.Line}"
        instr = f"  {self.Mnemonic.upper()}"
        binary = f"  {str}"

        print(f"\33[32m" + line + "\33[0m")
        print(f"\33[{self.color_system}m" + instr + "\33[0m")
        print(f"\33[{self.color_system}m" + binary + "\33[0m")
        print(f"\33[{self.color_system}m  " + self.getHex() + "\33[0m")

    # Funcion para instrucciones de memoria
    def memory(self):
        # Get Registers
        regs = self.Rest.replace("[", "").replace("]", "").split(",")
        regs = regs if "#" in self.Rest else regs + ["#0"]
        RD = regs_dict[regs[0]]
        RA = regs_dict[regs[1]]
        IMM = getbinary(int(regs[2][1:]), self.IMM_SIZE)

        # Get IS
        IS = "01" if "s" in regs[0] else "00"

        # Get String
        str = f"{self.Type.value} {self.Opcode} 00 {IS} {RD} {RA} {IMM} {0:09b}"
        self.Bin = str.replace(" ", "")

        # Prints
        line = f"\n➤  line : {self.Line}"
        instr = f"  {self.Mnemonic.upper()} {self.Rest.upper()}"
        binary = f"  {str}"

        print(f"\33[32m" + line + "\33[0m")
        print(f"\33[{self.color_memory}m" + instr + "\33[0m")
        print(f"\33[{self.color_memory}m" + binary + "\33[0m")
        print(f"\33[{self.color_memory}m  " + self.getHex() + "\33[0m")

    # Funcion para JUMPS
    def control(self):
        # Obtener la etiqueta

        result = [tup for tup in self.Labels if tup[0] == self.Rest]
        if result == []:
            text = (
                f"Err[ln {self.Line}): No se ha encontrado la etiqueta '{self.Rest}'."
            )
            print("\33[31m" + text + "\33[0m")
        """
        Si se quiere la instruccion 3
        4*3 - 4 = 8
        1  :  0 - 3
        2  :  4 - 7
        3  :  (8)
        """
        position = (result[0][1] * 4) - 4

        IMM = getbinary(int(position), self.IMM_SIZE)

        # Get String
        str = f"{self.Type.value} {self.Opcode} {0:03b} {0:08b} {IMM} {0:09b}"
        self.Bin = str.replace(" ", "")

        # Prints
        line = f"\n➤  line : {self.Line}"
        instr = f"  {self.Mnemonic.upper()} {self.Rest.upper()}"
        binary = f"  {str}"

        print(f"\33[32m" + line + "\33[0m")
        print(f"\33[{self.color_control}m" + instr + "\33[0m")
        print(f"\33[{self.color_control}m" + binary + "\33[0m")
        print(f"\33[{self.color_control}m  " + self.getHex() + "\33[0m")

    # Funcion para DATOS
    def data(self):
        # Get Registers
        regs = self.Rest.replace("[", "").replace("]", "").split(",")

        # if CMP or MOV
        if len(regs) == 2:
            return self.data_2regs(regs)

        RD = regs_dict[regs[0]]
        RA = regs_dict[regs[1]]

        # Get IS
        IS = ""
        RB_or_IMM = ""
        str = ""

        # If immediate
        if "#" in regs[2]:
            IS = "11"
            RB_or_IMM = getbinary(int(regs[2][1:]), self.IMM_SIZE)
            str = f"{self.Type.value} {self.Opcode} {IS} {RD} {RA} {RB_or_IMM} {0:09b}"
        else:
            RB_or_IMM = regs_dict[regs[2]]
            IS = "01" if "s" in regs[2] else "00"
            str = f"{self.Type.value} {self.Opcode} {IS} {RD} {RA} {RB_or_IMM} {0:013b}"

        # Get String
        self.Bin = str.replace(" ", "")

        # Prints
        line = f"\n➤  line : {self.Line}"
        instr = f"  {self.Mnemonic.upper()} {self.Rest.upper()}"
        binary = f"  {str}"

        print(f"\33[32m" + line + "\33[0m")
        print(f"\33[{self.color_data3}m" + instr + "\33[0m")
        print(f"\33[{self.color_data3}m" + binary + "\33[0m")
        print(f"\33[{self.color_data3}m  " + self.getHex() + "\33[0m")

    def data_2regs(self, regs):
        # Get Registers
        RA = "0" * (self.REG_SIZE)
        RD = "0" * (self.REG_SIZE)

        # Si es MOV, entonces RA es cero.
        if "mov" in self.Mnemonic:
            RD = regs_dict[regs[0]]

        # Si es CMP, entonces RD es cero.
        elif "cmp" in self.Mnemonic:
            RA = regs_dict[regs[0]]

        # Get IS and RB or IMM

        # Get IS
        IS = ""
        RB_or_IMM = ""
        str = ""

        # If immediate
        if "#" in regs[1]:
            IS = "11"
            RB_or_IMM = getbinary(int(regs[1][1:]), self.IMM_SIZE)
            str = f"{self.Type.value} {self.Opcode} {IS} {RD} {RA} {RB_or_IMM} {0:09b}"
        else:
            RB_or_IMM = regs_dict[regs[1]]
            IS = "01" if "s" in regs[1] else "00"
            str = f"{self.Type.value} {self.Opcode} {IS} {RD} {RA} {RB_or_IMM} {0:013b}"

        # Get String
        self.Bin = str.replace(" ", "")

        # Prints
        line = f"\n➤  line : {self.Line}"
        instr = f"  {self.Mnemonic.upper()} {self.Rest.upper()}"
        binary = f"  {str}"

        print(f"\33[32m" + line + "\33[0m")
        print(f"\33[{self.color_data2}m" + instr + "\33[0m")
        print(f"\33[{self.color_data2}m" + binary + "\33[0m")
        print(f"\33[{self.color_data2}m  " + self.getHex() + "\33[0m")
