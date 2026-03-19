#!/usr/bin/bash 
#Mostrar la interfaces de red disponibles y su estado 
#cambiar el estado de la interfaz (up o down) 
#conectate a la red con la interfaz cableada o inalambrica 
#seleccionar si la configuracion de la red sera estatica o dinamica 
#gauardar la configuracion y hacerla permanente 
#en el caso de redes inalambricas muestre las redes disponibles y conectarse sin importar el tipo de cfrado que use la red 


Mostrar_interfaces(){
   mostrar=$(ip addr | grep "state UP")
   echo $mostrar
   
   if ! test "$mostrar"; then 
   echo "No hay interfaces de red disponibles" 
   ip addr | grep  "state DOWN"
   fi 
}

Cambiar_estado(){
   local interfaz
   local estado
   echo "----Cambiar estado de la interfaz (up o down)----"
   read -p "Nombre interfaz: " interfaz
   read -p "Estado up o down: " estado
   
   ip link set dev "$interfaz" "$estado"
}

Alambrica_manual(){
    #para verificar las conexiones existente comando nmcli connectionn show
    local conexion
    local direccion
    local direccion_red
    local gateway 
    echo "------------------------------------------------------------------"
    echo "En base a las siguientes conexiones, ingresa lo que se te solicita"
    nmcli connection show 
    echo "--------------------------Conectate-------------------------------"
	read -p "Nombre o UUID de conexion: " conexion
	read -p "Direccion ipv4: " direccion
	read -p "DIreccion de red---Escribir en notacion CIDR ejem: 24: " direccion_red
	read -p "Direccion gateway: " gateway
	    #editamos el archivo de conexion de red de esa misma
		 nmcli connection modify "$conexion" ipv4.addresses "$direccion"/"$direccion_red"
		 nmcli connection modify "$conexion" ipv4.gateway "$gateway"
		 nmcli connection modify "$conexion" ipv4.method manual
		#aplicamos los cambios
		 nmcli connection up "$conexion"
		 
}

Alambrica_dinamica(){
	local conexion
	echo "------------------------------------------------------------------"
	echo "En base a las siguientes conexiones, ingresa lo que se te solicita"
	    nmcli connection show 
	echo "--------------------------Conectate-------------------------------"
	read -p "Nombre o UUID de conexion: " conexion
    # . Cambiar a DHCP
	nmcli connection modify "$conexion" ipv4.method auto
	# . Opcional limpiar IP y gateway como quiera se asignara automaticamente
		nmcli connection modify "$conexion" ipv4.addresses ""
	    nmcli connection modify "$conexion" ipv4.gateway ""
    #aplicamos los cambios
		 nmcli connection up "$conexion"

}

Redes_disponibles(){
	echo "-------Mostrando redes disponibles-------"
	     nmcli device wifi list 
	echo "----------------------------------------"
}
inalambrica_dinamica(){
     Redes_disponibles
     local SSID
     echo "--------conectate---------"
     read -p  "Ingresa el SSID: " SSID
     nmcli device wifi connect "$SSID" --ask
     nmcli connection show --active   
}

inalambrica_dinamica2(){
      #Esta es para en casos de caracteres especiales, por ejemplo emojis y cosas raras que les ponen a los nombres de las redes
      local interfaz
      read -p  "Ingresa la interfaz de red inalambrica: " interfaz 
      echo "-------Mostrando redes disponibles-------"
      iwlist "$interfaz"  scan | grep "ESSID"
           local ESSID
           echo "--------conectate---------"
           read -p  "Ingresa el ESSID: " ESSID
           nmcli device wifi connect "$ESSID" --ask
           nmcli connection show --active  
}

inalambrica_after(){
	local conexion
	echo "------------------------------------------------------------------"
	echo "En base a las siguientes conexiones, ingresa lo que se te solicita"
	    nmcli connection show 
	echo "--------------------------Conectate-------------------------------"
	read -p "Nombre o UUID de conexion: " conexion
    # . Cambiar a DHCP
	nmcli connection modify "$conexion" ipv4.method auto
	# . Opcional limpiar IP y gateway como quiera se asignara automaticamente
		nmcli connection modify "$conexion" ipv4.addresses ""
	    nmcli connection modify "$conexion" ipv4.gateway ""
    #aplicamos los cambios
		 nmcli --ask  connection up "$conexion"

}



inalambrica_manual(){
    #para verificar las conexiones existente comando nmcli connectionn show
    local conexion
    local direccion
    local direccion_red
    local gateway 
    echo "------------------------------------------------------------------"
    echo "En base a las siguientes conexiones, ingresa lo que se te solicita"
    nmcli connection show 
    echo "--------------------------Conectate-------------------------------"
	read -p "Nombre o UUID de conexion: " conexion
	read -p "Direccion ipv4: " direccion
	read -p "DIreccion de red---Escribir en notacion CIDR ejem: 24: " direccion_red
	read -p "Direccion gateway: " gateway
	    #editamos el archivo de conexion de red de esa misma
		 nmcli connection modify "$conexion" ipv4.addresses "$direccion"/"$direccion_red"
		 nmcli connection modify "$conexion" ipv4.gateway "$gateway"
		 nmcli connection modify "$conexion" ipv4.method manual
		#aplicamos los cambios
		 nmcli --ask connection up "$conexion"
		 
}

OPTIONS="Mostrar_interfaces Cambiar_estado_de_interfaces Conectarse_Alambricamente Conectarse_Inalambrica Salir"

select opc in $OPTIONS; do
    if test "$opc" = "Mostrar_interfaces"; then 
        Mostrar_interfaces
        
    elif test "$opc" = "Cambiar_estado_de_interfaces"; then 
        Cambiar_estado
        
    elif test "$opc" = "Conectarse_Alambricamente"; then
         echo "-------------------------------------------------" 
         read -p  "------Conectar de forma manual o automatico--" seleccion
         
         if test "$seleccion" = "manual"; then
         Alambrica_manual
         elif test  "$seleccion" = "automatico"; then 
         Alambrica_dinamica
         else
            echo "opcion invalida"
         fi
         
    elif test "$opc" = "Conectarse_Inalambrica"; then 
         echo "-------------------------------------------------" 
         read -p  "------Conectar de forma manual o automatico--" seleccion
                         
         if test "$seleccion" = "manual"; then
             inalambrica_manual
         elif test "$seleccion" = "automatico"; then 
             inalambrica_dinamica
         else
              echo "opcion invalida"
          fi   
          
    elif test "$opc" = "Salir"; then 
        echo "Saliendo..."
        exit 0          
    else
        echo "Opción inválida. Intenta de nuevo."
    fi
done

