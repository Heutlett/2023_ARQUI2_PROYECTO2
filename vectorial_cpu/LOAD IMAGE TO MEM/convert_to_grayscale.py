from PIL import Image

def convertir_a_escala_de_grises(ruta_imagen):
    imagen = Image.open(ruta_imagen).convert('L')  # Abrir la imagen y convertirla a escala de grises
    nueva_ruta = ruta_imagen.replace('.jpg', '_gris.jpg')  # Generar la nueva ruta para guardar la imagen en escala de grises
    imagen.save(nueva_ruta)  # Guardar la imagen en escala de grises
    print(f"La imagen se ha convertido a escala de grises y se ha guardado en: {nueva_ruta}")

# Ruta de la imagen de entrada
ruta_imagen = 'marilyn.jpg'

# Llamar a la función para convertir la imagen a escala de grises
convertir_a_escala_de_grises(ruta_imagen)
