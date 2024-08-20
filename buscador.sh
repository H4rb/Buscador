#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# ---------------------------------------------
  function ctrl_c(){
    echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
    rm fylie0055500.txt 2>/dev/null; tput cnorm;  exit 1
  }

  trap ctrl_c INT
# ---------------------------------------------


function search(){

  declare -i counter=1
    
  clear
  
  echo -e "\n${greenColour}[+] BIENVENIDO${endColour}"
  echo -ne "\n${yellowColour}[+]${endColour}${grayColour} Cual archivo deseas buscar:${endColour} " && read busqueda
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Buscando y mostrando archivos...${endColour}\n"

  echo -e "${purpleColour}------------------------------------------------------------------------------------------------------------------------------------------------${endColour}"

  tput civis
  for i in $(find / -type f -iname "*$busqueda*" -not -path "*Trash*" -not -path "*undo*" 2>/dev/null); do
    (echo -e "[$counter] -> $i ") 2>/dev/null
    (echo -e "[$counter] -> $i " >> fylie0055500.txt) 2>/dev/null
    
    let counter+=1  
  done
  tput cnorm

  echo -e "${purpleColour}------------------------------------------------------------------------------------------------------------------------------------------------${endColour}"

  if [ -f "fylie0055500.txt" ]; then
    total_busquedas=$(cat fylie0055500.txt | wc -l)
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} En total se han encontrado${endColour}${blueColour} $total_busquedas${endColour}${grayColour} archivos${endColour}"

    echo -e "\n\t${yellowColour}[+]${endColour}${grayColour} Quieres ver algun archivo? -${endColour}${blueColour} PRESIONA v${endColour}"
    echo -e "\t${yellowColour}[+]${endColour}${grayColour} Quieres borrar algun archivo? -${endColour}${blueColour} PRESIONA b${endColour}"
    echo -e "\t${yellowColour}[+]${endColour}${grayColour} Quieres modificar algun archivo? -${endColour}${blueColour} PRESIONA m${endColour}"
    echo -e "\t${yellowColour}[!]${endColour}${redColour} Exit -${endColour}${blueColour} PRESIONA x${endColour}"
    echo -ne "\n\t${yellowColour}[+]${endColour}${grayColour} Cual opcion eliges:${endColour} " && read var

    var="$(echo $var | tr '[:upper:]' '[:lower:]')"

    if [ "$var" == "v" ]; then
      echo -ne "\n\t${yellowColour}[+]${endColour}${grayColour} Cual archivo quieres ver? Marca el numero:${endColour} " && read var2
      
      if [ ! $var2 -le 0 ]; then

        if [ $var2 -le $total_busquedas ]; then
          echo -e "\n${yellowColour}[+]${endColour}${grayColour} Has elegido la numero${endColour}${blueColour} $var2${endColour}${grayColour}, a continuacion veras que contiene el archivo:${endColour}\n" 

          valor=$(cat fylie0055500.txt | awk "NR==$var2" | awk '{print$3}')
          sleep 2
          cat $valor | bat -l bash
        else
          echo -e "${redColour}[!] Solo existen $total_busquedas archivos en tu busqueda, intentalo de nuevo${endColour}"
        fi

      else
        echo -e "\n${redColour}[!] No puedes elegir un numero menor o igual que cero${endColour}"
      fi     

    elif [ "$var" == "b" ]; then
      echo -ne "\n\t${yellowColour}[+]${endColour}${grayColour} Cual archivo quieres borrar? Marca el numero:${endColour} " && read var2

      if [ ! $var2 -le 0 ]; then

        if [ $var2 -le $total_busquedas ]; then
          echo -e "\n${yellowColour}[+]${endColour}${grayColour} Has elegido la numero${endColour}${blueColour} $var2${endColour}${grayColour}, a continuacion se borrara el archivo:${endColour}\n" 

          valor=$(cat fylie0055500.txt | awk "NR==$var2" | awk '{print$3}')
          sleep 2
          rm $valor
          echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listo!${endColour}"
        else
          echo -e "\n${redColour}[!] Solo existen $total_busquedas archivos en tu busqueda, intentalo de nuevo${endColour}"
        fi

      else
        echo -e "\n${redColour}[!] No puedes elegir un numero menor o igual que cero${endColour}"
      fi      

    elif [ "$var" == "m" ]; then
      echo -ne "\n\t${yellowColour}[+]${endColour}${grayColour} Cual archivo quieres modificar? Marca el numero:${endColour} " && read var2

      if [ ! $var2 -le 0 ]; then

        if [ $var2 -le $total_busquedas ]; then
          echo -e "\n${yellowColour}[+]${endColour}${grayColour} Has elegido la numero${endColour}${blueColour} $var2${endColour}${grayColour}, a continuacion veras que contiene el archivo:${endColour}\n" 

          valor=$(cat fylie0055500.txt | awk "NR==$var2" | awk '{print$3}')
          sleep 2

          nvim $valor 2>/dev/null
          if [ "$?" -ne "0" ]; then
            nano $valor 2>/dev/null
              if [ "$?" -ne "0" ]; then      
                echo -e "${redColour}[!] No posees 'nvim' ni tampoco 'nano' en tu sistema operativo!${endColour}"
                rm fylie0055500.txt 2>/dev/null; tput cnorm; exit 1
              fi
          fi

        else
          echo -e "${redColour}[!] Solo existen $total_busquedas archivos en tu busqueda, intentalo de nuevo${endColour}"
        fi

      else
        echo -e "\n${redColour}[!] No puedes elegir un numero menor o igual que cero${endColour}"
      fi

    elif [ "$var" == "x" ]; then      
      rm fylie0055500.txt; tput cnorm; exit 0

    else
      echo -e "\n${redColour}[!] Esa respuesta no existe! Intentalo de nuevo${endColour}"
      rm fylie0055500.txt; tput cnorm; exit 1
    fi 

    rm fylie0055500.txt

  else
    echo -e "\n${redColour}[!] No se han encontrado coincidencias!${endColour}"
  fi
}

search
