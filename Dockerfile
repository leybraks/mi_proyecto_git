# Usa una imagen base de Python oficial
FROM python:3.9-slim

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos de dependencia e instálalos
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# Copia el código fuente de la aplicación
COPY . .

# Expone el puerto que la aplicación usará internamente
EXPOSE 5000

# Comando para ejecutar la aplicación cuando se inicia el contenedor
CMD ["python", "app.py"]
