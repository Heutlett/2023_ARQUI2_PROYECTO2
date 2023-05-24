from PIL import Image
import numpy as np

def guardar_pixeles_en_archivo(ruta_imagen, ruta_archivo):
    imagen = Image.open(ruta_imagen)  # Abrir la imagen en escala de grises
    pixeles = np.array(imagen)  # Convertir la imagen a un arreglo NumPy

    alto, ancho = pixeles.shape  # Obtener las dimensiones de la imagen

    pixeles_flattened = pixeles.flatten()  # Aplanar la matriz de píxeles a un vector

    with open(ruta_archivo, 'w') as archivo:
        for i in range(0, len(pixeles_flattened), 6):
            linea = pixeles_flattened[i:i+6][::-1]  # Obtener los 6 píxeles y revertir el orden
            linea_hex = [format(pixel, '02X') for pixel in linea]  # Convertir los valores de los píxeles a formato hexadecimal con 2 caracteres

            if len(linea_hex) < 6:  # Si la línea tiene menos de 6 píxeles
                linea_hex = ['00'] * (6 - len(linea_hex)) + linea_hex  # Rellenar con ceros a la izquierda

            archivo.write(''.join(linea_hex) + '\n')

    print(f"Los valores de los píxeles en formato hexadecimal se han guardado en: {ruta_archivo}")

# Ruta de la imagen en escala de grises
ruta_imagen_gris = 'carrera_gris.jpg'

# Ruta del archivo para guardar los valores de los píxeles en formato hexadecimal
ruta_archivo = 'data_mem_init.dat'

# Llamar a la función para guardar los valores de los píxeles en formato hexadecimal en un archivo
guardar_pixeles_en_archivo(ruta_imagen_gris, ruta_archivo)
