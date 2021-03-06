setwd('C:/Users/LVARGAS/Documents/CIMMYT/dataBase/2016/2016-09-15-calendarios/AnalisisR')

library(stringr) # para la funcion str_replace_all
library(sqldf)

##########################################################
##########################################################
#### Construir la funci�n para encontrar valores extremo superior y extremo inferior

extremos <- function(vectorDatos){ # Si es analisis de rendimiento, colocar SI al usar la funcion, para evitar obtener un valor minimo negativo
        
        q75 <- as.Date(quantile(as.numeric(vectorDatos), 0.75), origin = "1970-01-01")
        
        q25 <- as.Date(quantile(as.numeric(vectorDatos), 0.25), origin = "1970-01-01")
        
        ric <- q75 - q25
        
        valorMaximo <- as.Date(as.numeric(q75 + (ric * 1.5)), origin = "1970-01-01")
        
        valorMinimo <- as.Date(as.numeric(q25 - (ric * 1.5)), origin = "1970-01-01")
        
        valores <- c(valorMaximo, valorMinimo)
        
        print("Los valores maximo y minimo son..................")

        print(valores)
        
}

##########################################################
##########################################################

##### Obtener el archivo con los datos
datos <- read.table('./dataOutput3/calendariosCiclo.txt', header = TRUE, fileEncoding = 'UTF-8', as.is = T) ## Usar as.is = T para evirtar que los factores mantengan los niveles eliminados despues de un subset http://stackoverflow.com/questions/1195826/drop-factor-levels-in-a-subsetted-data-frame 
datos$Fecha.de.la.aplicaci�n <- as.Date(datos$Fecha.de.la.aplicaci�n)
datos$Fecha.de.la.aplicaci�n
str(datos)
# names(datos)

##### Crear un vector con los a�os registrados
vectorA�o <- unique(datos$A�o)

conteoParaArchivo <- 0

for(ao in vectorA�o){
        
        datosAo <- datos[datos$A�o == ao,]
        
        ##### Crear un vector con los ciclos registrados
        
        vectorCiclo <- unique(datosAo$Ciclo.agron�mico)
        
        for(ciclo in vectorCiclo){
                
                datosAoCiclo <- datosAo[datosAo$Ciclo.agron�mico == ciclo,]
                
                valoresExtremos <- extremos(datosAoCiclo$Fecha.de.la.aplicaci�n)
                
                ###########
                ###########
                
                leyenda <-  paste("Analizando los outiers de ", ao, " ", ciclo, "..........")
                print(leyenda)
                
                count = 0       
                
                for(i in datosAoCiclo$Fecha.de.la.aplicaci�n){
                        if(count == 0){
                                if(i > valoresExtremos[1] | i < valoresExtremos[2]){
                                        esOutlier = TRUE
                                        printEsOutlier = "VALOR ATIPICO"
                                }else{
                                        esOutlier = FALSE
                                        printEsOutlier = "No atipico" 
                                }
                                
                        }else{
                                if(i > valoresExtremos[1] | i < valoresExtremos[2]){
                                        esOutlier = c(esOutlier, TRUE)
                                        printEsOutlier = "VALOR ATIPICO"
                                }else{
                                        esOutlier = c(esOutlier, FALSE)
                                        printEsOutlier = "No atipico"
                                }
                                
                        }
                        count = count + 1
                        leyenada <- paste(i,"--", printEsOutlier)
                        print(leyenada)
                        
                }
                
                datosAoCiclo$fechaOutlier <- esOutlier
                
                datosAoCicloSinoutlier <- datosAoCiclo[datosAoCiclo$fechaOutlier == FALSE,]
                
                if(conteoParaArchivo == 0){
                        
                        unionDatos <- datosAoCicloSinoutlier
                        
                }else{
                        
                        unionDatos <- rbind(unionDatos, datosAoCicloSinoutlier)
                        
                }   
                
                conteoParaArchivo <- conteoParaArchivo + 1
                
                ###########
                ###########
                
        }
        
}

#Guardar el archivo
if(dir.exists('./dataOutput4')){
        print('El directorio existe...')
}else{
        dir.create('./dataOutput4')
        print('Se ha creado el directorio')
}

nombreArchivo <- paste('./dataOutput4/', 'calendariosAoCiclo','.txt')
nombreArchivo <- str_replace_all(nombreArchivo, pattern=" ", repl="")
write.table(unionDatos, file = nombreArchivo, row.names = FALSE, fileEncoding = 'UTF-8')


