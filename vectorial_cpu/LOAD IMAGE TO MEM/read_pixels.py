from PIL import Image

# Ruta de la imagen en escala de grises
imagen_path = "marilyn_gris.jpg"

# Ruta del archivo de salida
archivo_salida = "valores_pixeles_dec.txt"

# Abrir la imagen
imagen = Image.open(imagen_path)

# Obtener las dimensiones de la imagen
ancho, alto = imagen.size

# Convertir la imagen en una matriz de píxeles
matriz_pixeles = []
for y in range(alto):
    fila = []
    for x in range(ancho):
        valor_pixel = imagen.getpixel((x, y))
        fila.append(valor_pixel)
    matriz_pixeles.append(fila)

# Aplanar la matriz en un vector
vector_pixeles = []
for fila in matriz_pixeles:
    vector_pixeles.extend(fila)

# Guardar el valor de cada píxel en el archivo de salida
with open(archivo_salida, "w") as archivo:
    for valor_pixel in vector_pixeles:
        archivo.write(str(valor_pixel) + "\n")

print("Los valores de los píxeles se han guardado en el archivo:", archivo_salida)
