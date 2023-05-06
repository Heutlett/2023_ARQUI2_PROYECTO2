import os
from pathlib import Path

text = "The idea that we control the dragons is an illusion, they're a power man should never have trifled w"

# Key values
crypt = 2371
mod = 2747
decrypt = 1531

ascii_values = []
for character in text:
    ascii_values.append(ord(character))


crypted = []
for letter in ascii_values:
    crypted.append(letter ** crypt % mod)


save_location = Path(__file__).resolve().parent.parent / "RSA_PIPELINE_CPU" / "data_mem_init.dat"

def dec_hex (ascii_val):
    hex_str = str(hex(ascii_val)).split("0x")[1].upper()
    zero_values = (8 - len(hex_str)) * '0'
    return f"{zero_values}{hex_str}"
    

with open(save_location, "w") as file:

    # key write
    file.write(dec_hex(decrypt) + "\n")
    file.write(dec_hex(mod) + "\n")

    # Text write
    for crypt_char in crypted: 
        file.write(dec_hex(crypt_char) + "\n")
    
    