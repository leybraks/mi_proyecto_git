#!/bin/bash
echo "-> 0.- Liberando el puerto 80 de cualquier proceso del sistema"
PID_80=$(sudo lsof -i :80 -t)
if [ ! -z "$PID_80" ]; then 
	sudo kill -9"$PID_80"
	echo "Proceso antiguo detenido"
else
	echo "Puerto 80 libre, continuando"
fi

RUTA_APP="/home/ubuntu/app-completa"
REPOSITORIO="master"


echo "******************************************"
echo "INICIANDO DESPLIEGUE CONTINUO"
echo "******************************************"

# 1. Actualizar codigo fuente
echo "-> 1.- Descargando la ultima version del codigo fuente de github"
git pull origin "$REPOSITORIO"

if [ $? -ne 0 ]; then
	echo "ERROR: Fallo la descarga del codigo. Revisar la conexion o rama"
	exit 1
fi
echo "Codigo actualizado con exito"

# 2. Detener y eliminar contenedores antiguos
echo "-> 2.- Detenido y eliminado la aplicacion anterior (en caso de existir)"

# Usamos 'docker-compose down' para detener y eliminar contenedores, redes y volumenes
# La opcion '-v' elimina volumenes (en caso de existir)
# La opcion '--rmi all' elimina imagenes, pero la omitimos para ser mas rapidos

docker-compose down

echo "Contenedores antiguos eliminados"

# 3. Construir y levantar la nueva version
echo "-> 3.- Levantando la nueva infraestructura con docker compose"

docker-compose up -d --build

if [ $? -eq 0 ]; then
	echo "Despliegue finalizado con exito. servicios en linea"
else
	echo "Fallo critico: El despliegue fallo al levantar contenedores"
fi 

