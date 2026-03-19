#!/bin/bash
#Otro Script que permita recuperar el archivo elimanado 

echo "Hola bienvenido"
echo "----Script que recupera un archivo-----"
read -p "Hola, ingresa un archivo (Especifica la ruta)" archivo 


if ! test "$archivo"; then 
   echo "Ingresa un parametro"
   exit 1 
fi

if ! test -f "$archivo"; then 
	echo "test: $archivo"
   echo "No existe el archivo"
   exit 1
fi 

if !  test -d ~/.papelera ; then 
   echo "NO existe el directorio .papelera"
   echo "Utiliza el Script Borrar.sh"
   exit 1
fi 

read -p "Directorio en donde aparecera el archivo (Especifica la ruta)" directorio


mv "$archivo" /"$directorio"

   


