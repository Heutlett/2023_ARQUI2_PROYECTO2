from enum import Enum


class Type(Enum):
    SYSTEM = "00"
    DATA = "01"
    MEMORY = "10"
    CONTROL = "11"


types_dict = {
    Type.SYSTEM: ["nop", "pse", "end", "sel"],
    Type.DATA: [
        "add",
        "mov",
        "xor",
        "or",
        "shr",
        "shl",
        "cmp",
        "sub",
    ],
    Type.MEMORY: ["ldr", "str"],
    Type.CONTROL: ["jmp", "jeq", "jlt"],
}

opcode_dict = {
    # System
    "nop": "00",
    "pse": "01",
    "sel": "10",
    "end": "11",
    # Data
    "add": "000",
    "mov": "001",
    "xor": "010",
    "or": "011",
    "shr": "100",
    "shl": "101",
    "cmp": "110",
    "sub": "111",
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
        self.Error = False

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
            self.Error = True

    # Funcion para instrucciones del sistema
    def system(self):
        # Get NOP, COM, END
        str = f"{self.Type.value} {self.Opcode} 000 {0:025b}"
        self.Bin = str.replace(" ", "")

        # Get SEL
        if self.Mnemonic in ["sel", "pse"]:
            # Obtener la etiqueta  
            n, label = self.Rest.split(",")
            label_position = self.get_label(label)
            IMM = getbinary(int(n[1:]), 2)
            address = getbinary(int(label_position), 26)
            str = f"{self.Type.value} {self.Opcode} {IMM} {address}"
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
        str = f"{self.Type.value} {self.Opcode}  00   {IS} {RD} {RA} {IMM} {0:09b}"
        self.Bin = str.replace(" ", "")

        # Prints
        line = f"\n➤  line : {self.Line}"
        instr = f"  {self.Mnemonic.upper()} {self.Rest.upper()}"
        header = "  TP OP NULL IS RD   RA   IMM      NULL"
        binary = f"  {str}"

        print(f"\33[32m" + line + "\33[0m")
        print(f"\33[{self.color_memory}m" + instr + "\33[0m")
        print(f"\33[37m" + header + "\33[0m")
        print(f"\33[{self.color_memory}m" + binary + "\33[0m")
        print(f"\33[{self.color_memory}m  " + self.getHex() + "\33[0m")

    # Funcion para JUMPS
    def control(self):
        # Obtener la etiqueta
        label_position = self.get_label(self.Rest)
        try:
            address_size = 28
            IMM = getbinary(int(label_position), address_size)
            # Get String
            str = f"{self.Type.value} {self.Opcode} {IMM}"
            self.Bin = str.replace(" ", "")

            # Prints
            line = f"\n➤  line : {self.Line}"
            instr = f"  {self.Mnemonic.upper()} {self.Rest.upper()}"
            binary = f"  {str}"

            print(f"\33[32m" + line + "\33[0m")
            print(f"\33[{self.color_control}m" + instr + "\33[0m")
            print(f"\33[{self.color_control}m" + binary + "\33[0m")
            print(f"\33[{self.color_control}m  " + self.getHex() + "\33[0m")
        except:
            print(f"Error en linea {self.Line}")

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
            self.Bin = str.replace(" ", "")

            # Prints
            line = f"\n➤  line : {self.Line}"
            header = "  TP OP  IS RD   RA   IMM      NULL"
            instr = f"  {self.Mnemonic.upper()} {self.Rest.upper()}"
            binary = f"  {str}"

            print(f"\33[32m" + line + "\33[0m")
            print(f"\33[{self.color_data3}m" + instr + "\33[0m")
            print(f"\33[37m" + header + "\33[0m")
            print(f"\33[{self.color_data3}m" + binary + "\33[0m")
            print(f"\33[{self.color_data3}m  " + self.getHex() + "\33[0m")

        else:
            IS = "01" if "s" in regs[2] else "00"
            RB_or_IMM = regs_dict[regs[2]]
            str = f"{self.Type.value} {self.Opcode} {IS} {RD} {RA} {RB_or_IMM} {0:013b}"

            # Get String
            self.Bin = str.replace(" ", "")

            # Prints
            line = f"\n➤  line : {self.Line}"
            header = "  TP OP  IS RD   RA   RB   NULL"
            instr = f"  {self.Mnemonic.upper()} {self.Rest.upper()}"
            binary = f"  {str}"

            print(f"\33[32m" + line + "\33[0m")
            print(f"\33[{self.color_data3}m" + instr + "\33[0m")
            print(f"\33[37m" + header + "\33[0m")
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

        # Get IS
        IS = ""
        RB_or_IMM = ""
        str = ""

        # If immediate
        if "#" in regs[1]:
            IS = "11"
            RB_or_IMM = getbinary(int(regs[1][1:]), self.IMM_SIZE)
            str = f"{self.Type.value} {self.Opcode} {IS} {RD} {RA} {RB_or_IMM} {0:09b}"
            # Get String
            self.Bin = str.replace(" ", "")

            # Prints
            line = f"\n➤  line : {self.Line}"
            header = "  TP OP  IS RD   RA   IMM      NULL"
            instr = f"  {self.Mnemonic.upper()} {self.Rest.upper()}"
            binary = f"  {str}"

            print(f"\33[32m" + line + "\33[0m")
            print(f"\33[{self.color_data2}m" + instr + "\33[0m")
            print(f"\33[37m" + header + "\33[0m")
            print(f"\33[{self.color_data2}m" + binary + "\33[0m")
            print(f"\33[{self.color_data2}m  " + self.getHex() + "\33[0m")
        else:
            IS = "01" if "s" in regs[1] else "00"
            RB_or_IMM = regs_dict[regs[1]]
            str = f"{self.Type.value} {self.Opcode} {IS} {RD} {RA} {RB_or_IMM} {0:013b}"

            # Get String
            self.Bin = str.replace(" ", "")

            # Prints
            line = f"\n➤  line : {self.Line}"
            header = "  TP OP  IS RD   RA   RB   NULL"
            instr = f"  {self.Mnemonic.upper()} {self.Rest.upper()}"
            binary = f"  {str}"

            print(f"\33[32m" + line + "\33[0m")
            print(f"\33[{self.color_data2}m" + instr + "\33[0m")
            print(f"\33[37m" + header + "\33[0m")
            print(f"\33[{self.color_data2}m" + binary + "\33[0m")
            print(f"\33[{self.color_data2}m  " + self.getHex() + "\33[0m")

    def get_label(self, label):
        result = [tup for tup in self.Labels if tup[0] == label]
        if result == []:
            text = f"Err[ln {self.Line}): No existe la etiqueta '{self.Rest}'."
            print("\33[31m" + text + "\33[0m")
            self.Error = True
        """
        Si se quiere la instruccion 3
        4*3 - 4 = 8
        1  :  0 - 3
        2  :  4 - 7
        3  :  (8)
        """
        position = (result[0][1] * 4) - 4

        return position
