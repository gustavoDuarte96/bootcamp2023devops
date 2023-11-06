#!/bin/bash

######################## CONSTANTES ########################

REPOSITORIO="bootcamp-devops-2023"
PROYECTO="app-295devops-travel"
LRED='\033[1;31m'
LGREEN='\033[1;32m'
LYELLOW='\033[1;33m'
LBLUE='\033[1;34m'
NC='\033[0m'
LISTA_DE_PAQUETES=("git" "mariadb-server" "apache2" "php" "libapache2-mod-php" "php-mysql" "php-mbstring" "php-zip" "php-gd" "php-json" "php-curl")

######################## VARIABLES ########################

USERID=$(id -u)

######################### LOGICA #########################

if [ "${USERID}" -ne 0 ]; then
    echo -e "\n${LRED}Correr con usuario ROOT${NC}"
    exit
fi

echo "============================"

# Stage 1 - INIT

sudo apt-get update

for paquete in "${LISTA_DE_PAQUETES[@]}"; do
    if dpkg -l | grep -q $paquete; then
	   git pull
        echo -e "\n${LGREEN}${paquete} ya se encuentra instalado y actualizado${NC}"
    else
        echo -e "\n${LYELLOW}Instalando ${paquete}${NC}"
        sudo apt install $paquete -y
        if [ "$paquete" == "mariadb-server" ]; then
            sudo systemctl start mariadb
            sudo systemctl enable mariadb
            sudo systemctl status mariadb            
        fi
        if [ "$paquete" == "apache2" ]; then
            sudo systemctl start apache2 
            sudo systemctl enable apache2 
            sudo systemctl status apache2 
        fi
        echo -e "\n${LGREEN}Se instalo ${paquete} correctamente${NC}"
    fi
done

#Stage 2 - BUILD

if [ -d "$REPOSITORIO/$PROYECTO" ]; then
	
    echo -e "\n${LGREEN}El proyecto ya esta descargado${NC}"
else
    git clone -b clase2-linux-bash https://github.com/roxsross/$REPOSITORIO.git
fi


