from enum import Enum


class Type(Enum):
  Stall = '00'
  Data    = '01'
  Memory  = '10'
  Control = '11'



types_dict =	{
  Type.Stall : ['nop', 'com', 'end'],  
  Type.Data : ['add', 'sub', 'mov','mul', 'cmp'],
  Type.Memory : ['ldr', 'str'],
  Type.Control : ['jmp', 'jeq', 'jlt']
}

opcode_dict =	{
    "nop" : '00',
    "com" : '01',
    "end" : '10',
    
    "add" : '000',
    "sub" : '001',
    "mov" : '010', 
    "mul" : '011',
    "cmp" : '100',
    
    "ldr" : '0',
    "str" : '1',
    
    "jmp" : '00',
    "jeq" : '01',
    "jlt" : '10'
  }

getbinary = lambda x, n: format(x, 'b').zfill(n)

regs_dict =	{
    "r0"  : '0000',
    "r1"  : '0001',
    "r2"  : '0010',
    "r3"  : '0011',
    "r4"  : '0100', 
    "r5"  : '0101',
    "r6"  : '0110', 
    "r7"  : '0111',
    "r8"  : '1000',
    "r9"  : '1001'
  }

class Binary:
  imm_size  = 18
  reg_size = 4
  Labels = []
  
  def __init__(self, Mnemonic, Rest, Line):
    self.Line = Line
    self.Mnemonic = Mnemonic
    self.Rest = Rest
    self.Bin = '0'*32

    self.analize()
    
  def __str__(self):
    self.__repr__()
    return ""
  
  def __repr__(self):
    print('\n➤ line :',self.Line,'\t',self.Mnemonic.upper(),self.Rest)
    
    try:
      
      match self.Type:
        case Type.Stall:
          print('  size :', len(self.Bin),'\t',self.Bin[0:2],self.Bin[2],self.Bin[3:])

        case Type.Data:
          if (self.I == '1'):
            print('  size :', len(self.Bin),'\t',self.Bin[0:2],self.Bin[2:5],self.Bin[5:6],self.Bin[6:10], self.Bin[10:14], self.Bin[14:])
          else:
            print('  size :', len(self.Bin),'\t',self.Bin[0:2],self.Bin[2:5],self.Bin[5:6],self.Bin[6:10], self.Bin[10:14], self.Bin[14:18], self.Bin[18:])
            
        case Type.Memory:
          print('  size :', len(self.Bin),'\t',self.Bin[0:2],self.Bin[2:3],self.Bin[3:6],self.Bin[6:10], self.Bin[10:14], self.Bin[14:]) 
                
        case Type.Control:
          print('  size :', len(self.Bin),'\t',self.Bin[0:2],self.Bin[2:4],self.Bin[4:6],self.Bin[6:14], self.Bin[14:])
          
      print('\t\t',self.getHex())
      return ""
    except:
      print('\t\tERROR')
      return ""
  
  def getHex(self):
    hstr = '%0*X' % ((len(self.Bin) + 3) // 4, int(self.Bin, 2))
    return hstr
  
  def analize(self):
    # Get Type
    for key in types_dict: # analizar en cada uno de los tipos.
      if self.Mnemonic in types_dict[key]: # si se encuentra dentro del array.
        self.Type = key
        break
    # Get Mnemonic
    self.Opcode = opcode_dict[self.Mnemonic]
    # Actuar de acuerdo con el tipo.
    try :
      match self.Type:
        case Type.Stall:
          self.stall()
        case Type.Data:
          self.data()
        case Type.Memory:
          self.memory()
        case Type.Control:
          self.control()
      return
    except:
      print('Error en linea {}: No se ha encontrado mnemonico \'{}\'.'.format(self.Line, self.Mnemonic.upper()))
      return
    
  def stall(self):
    self.Bin = self.Type.value + self.Opcode + '00' + ('0' * (25-0+1))

    
  def data(self):
    regs = self.Rest.split(',')
    
    # (dos registros)
    if (len(regs) == 2): # si es MOV o CMP: 
      return self.data_special_case_2reg(regs)

    # (tres registros)
    self.Rd  = regs_dict[regs[0]]
    self.Ra  = regs_dict[regs[1]]
    if ('#' in regs[2]): # Si el operando 3 es un inmediato.    
      self.I = '1'
      self.Imm = getbinary(int(regs[2][1:]), self.imm_size)
    else:
      self.I = '0'
      self.Rb  = regs_dict[regs[2]]

    # Si es inmediato se construye diferente.
    if (self.I == '1'):
      self.Bin = self.Type.value + self.Opcode + self.I + self.Rd + self.Ra + self.Imm
    else:
      self.Bin = self.Type.value + self.Opcode + self.I + self.Rd + self.Ra + self.Rb + ('0' * (13-0+1))
      
      
  def data_special_case_2reg(self, regs):
    self.Ra  = '0'*(self.reg_size)
    self.Rd  = '0'*(self.reg_size)
    
    if ('#' in regs[1]): # Si el operando 2 es un inmediato.    
      self.I = '1'
      self.Imm = getbinary(int(regs[1][1:]), self.imm_size)
      
      # Si es MOV, entonces RA es cero.
      if (self.Mnemonic == 'mov'):
        self.Rd  = regs_dict[regs[0]]
        
      # Si es CMP, entonces RD es cero.
      elif (self.Mnemonic == 'cmp'):
        self.Ra  = regs_dict[regs[0]]
        
      self.Bin = self.Type.value + self.Opcode + self.I + self.Rd + self.Ra + self.Imm
      
    else:
      self.I = '0'
      self.Rb  = regs_dict[regs[1]]
      # Si es MOV, entonces RA es cero.
      if (self.Mnemonic == 'mov'):
        self.Rd  = regs_dict[regs[0]]
        
      # Si es CMP, entonces RD es cero.
      elif (self.Mnemonic == 'cmp'):
        self.Ra  = regs_dict[regs[0]]

      self.Bin = self.Type.value + self.Opcode + self.I + self.Rd + self.Ra + self.Rb + ('0' * (13-0+1))

    
  def memory(self):
    regs = self.Rest.replace("[","").replace("]","").split(',')

    # (tres registros)
    self.Imm = getbinary(0, self.imm_size) if (len(regs) == 2) else getbinary(int(regs[2][1:]), self.imm_size)
    self.Ra  = regs_dict[regs[1]]
    self.Rd  = regs_dict[regs[0]]
    self.Bin = self.Type.value + self.Opcode + '000' + self.Rd + self.Ra + self.Imm 
  
  def control(self):
    result = [tup for tup in self.Labels if tup[0] == self.Rest]
    if (result == []):
      print('Error en linea {}: No se ha encontrado la etiqueta \'{}\'.'.format(self.Line, self.Rest))
    position = (result[0][1]*4) - 4
    self.Imm = getbinary(int(position), self.imm_size)
    self.Bin = self.Type.value + self.Opcode + '00' + ("0" * (25-18+1)) + self.Imm
    
    
  def priting(self):
    print(self.Opcode)
    print(self.Imm)
    print(self.Rd)
    print(self.Ra)
