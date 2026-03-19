#!/bin/bash 
#Crea un Script que borre un archivo de forma que pueda ser recuperado. Crea otro Script que permita recuperar el archivo elimiando 
#No subas los progrmas, sube la liga a un repositorio git donde coloques los scripts 
echo "-------Bienvenido-------"
echo "--Script  que borra un archivo--"
read -p "Hola, ingresa tu archivo (Especifica la ruta): " archivo

if ! test "$archivo"; then 
   echo "Ingresa un parametro"
   exit 1 
fi

if ! test -f "$archivo"; then 
   echo "No existe el archivo"
   exit 1
fi 

if ! test -d ~/.papelera ; then 
     mkdir ~/.papelera
fi 

mv "$archivo" ~/.papelera
