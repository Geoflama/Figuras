#!/bin/bash
clear

#	Define map
# 	-----------------------------------------------------------------------------------------------------------
#	Titulo del mapa
	title=Perfil_Marco
	echo $title
	
#	Dimensiones del Grafico: Longitud (L), Altura (H). Sin unidad!!
	L=15
	H=5
    imagen=145.png

#	Datos de la seccion sismicas. Longitud (km) y profundidad (en tiempos dobles)
	KM0=0	  # Posicion Inicial (en km)
	KM=13.9   # Posicion Final (en km)
	Min=0.1   # s TWT
	Max=0.40   # s TWT 
    Vel=1500   # Velocidad (en m/s) para estimar la profundidad en metros.

#	Hacer Grafico a partir de Segy
#	-----------------------------------------------------------------------------------------------------------
#	Iniciar sesion y tipo de figura
gmt begin $title png

#	Setear el dominio y proyeccion
	gmt basemap -R$KM0/$KM/$Min/$Max -JX$L/-$H -B+n
	
#	Agregar figura sismica
	gmt image $imagen -Dx0/0+w$L/$H

#	Dibujar Eje X (S = Abajo, N = Arriba)
	gmt basemap -BNs -Bxaf+l"Distance (km)" 

#	Dibujar Eje Y (W = Izquierda, E = Derecha).
	gmt basemap -BE -Byaf+l"TWT (s)"

#   Dibujar Eje Izquierdo con profundidades
#   -------------------------------------------------------
    # A. Convertir profundidades a m
    Z_Min=$(gmt math -Q $Min 2 DIV $Vel MUL =)
    Z_Max=$(gmt math -Q $Max 2 DIV $Vel MUL =)
	
	# B. Dibujar Eje
    gmt basemap -R0/$KM/${Z_Min}/${Z_Max}  -BW -Byafg+l"Depth (m)"
#   ------------------------------------------------

#	Coordenadas Perfil (E, O)
	echo O | gmt text -F+cTL+f14p -Gwhite -W1
	echo E | gmt text -F+cTR+f14p -Gwhite -W1

#	Calcula Exageracion Vertical (VE)
#   -------------------------------------------------------
# 	A. Calcular distancia del perfil en m
	M=$(gmt math -Q $KM $KM0 SUB 1000 MUL =)

#	B. Calcular VE
    VE=$(gmt math -Q $M $H MUL $L DIV $Z_Max $Z_Min SUB DIV = --FORMAT_FLOAT_OUT=%.2g)
	
#	Agregar VE en la figura
    echo V.E.: $VE | gmt text -F+cBR+f10p -Gwhite -W1

gmt end