setwd('C:/Users/LVARGAS/Documents/CIMMYT/dataBase/2016/2016-09-15-calendarios/AnalisisR')

#install.packages('readxl')
#install.packages('sqldf')
#install.packages('stringr')

library(readxl)
library(sqldf)
library(stringr) 

dataSubset <- function(archivoSeleccionadas, numHojaSeleccionadas, achivoSubset, numeroHojaSubset, nombreHoja){

        ###Construir la función para leer un libro de Excel y obtener los datos de una hoja determinada
        abrirExcel <- function(nombreArchivo, numeroHoja){
                
                numeroHoja = as.numeric(numeroHoja)
                
                extensionArchivo = '.xlsx'
                archivo <-c('./',nombreArchivo,extensionArchivo)
                nombreArchivo <- paste(archivo,collapse="")
                
                library(readxl)
                read_excel(nombreArchivo, sheet = numeroHoja)
                
        }
        
        if(nombreHoja == '04_parcelas'){
                
                #############################
                
                ## Obtener el id de las bitacoras de interés (para hacer el subset de datos)
                bitacoras1 <- abrirExcel('bitacorasTrigo', 1)
                names(bitacoras1)[1] <- "idBitacora"
                
                ## Obtener el id de las bitacoras del primer subset a construir
                caracteristicas <- abrirExcel('EXPORTAR', 2)
                names(caracteristicas)[1] <- "idBitacora2"
                
                ## Eliminar los id tipo de bitacora repetidos, para evitar repetir las registros
                bitacoras <- sqldf('SELECT * FROM bitacoras1 group by idBitacora')
                
                ## Hacer el subset de datos de la hoja seleccionada
                subsetDatos <- sqldf("select bitacoras.idBitacora, caracteristicas.* from caracteristicas join bitacoras on bitacoras.idBitacora = caracteristicas.idBitacora2")
                
                #############################
                ## Obtener el id de las bitacoras de interés (para hacer el subset de datos)
                names(subsetDatos)[7] <- "idParcela"
                
                caracteristicas <- abrirExcel(achivoSubset, numeroHojaSubset)
                names(caracteristicas)[1] <- "idParcela2"
                
                ## Eliminar los id tipo de bitacora repetidos, para evitar repetir las registros
                bitacoras <- sqldf('SELECT * FROM subsetDatos group by idParcela')
                
                ## Hacer el subset de datos de la hoja seleccionada
                subsetDatos <- sqldf("select bitacoras.idParcela, caracteristicas.* from caracteristicas join bitacoras on bitacoras.idParcela = caracteristicas.idParcela2")
                
                subsetDatos <- sqldf('SELECT * FROM subsetDatos group by idParcela')
                
                
                
                
        }else{
                
                if(numeroHojaSubset == 2){
                        
                        ## Obtener el id de las bitacoras de interés (para hacer el subset de datos)
                        bitacoras1 <- abrirExcel(archivoSeleccionadas, numHojaSeleccionadas)
                        names(bitacoras1)[1] <- "idBitacora"
                        
                        ## Obtener el id de las bitacoras del primer subset a construir
                        caracteristicas <- abrirExcel(achivoSubset, numeroHojaSubset)
                        names(caracteristicas)[1] <- "idBitacora2"
                        
                        ## Eliminar los id tipo de bitacora repetidos, para evitar repetir las registros
                        bitacoras <- sqldf('SELECT * FROM bitacoras1 group by idBitacora')
                        
                        ## Hacer el subset de datos de la hoja seleccionada
                        subsetDatos <- sqldf("select bitacoras.idBitacora, caracteristicas.* from caracteristicas join bitacoras on bitacoras.idBitacora = caracteristicas.idBitacora2")
                        
                }else{
                        ## Obtener el id de las bitacoras de interés (para hacer el subset de datos)
                        bitacoras1 <- abrirExcel(archivoSeleccionadas, numHojaSeleccionadas)
                        names(bitacoras1)[2] <- "idTipoBitacora"
                        
                        caracteristicas <- abrirExcel(achivoSubset, numeroHojaSubset)
                        names(caracteristicas)[2] <- "idTipoBitacora2"
                        
                        ## Eliminar los id tipo de bitacora repetidos, para evitar repetir las registros
                        bitacoras <- sqldf('SELECT * FROM bitacoras1 group by idTipoBitacora')
                        
                        subsetDatos <- sqldf("select bitacoras.idTipoBitacora, caracteristicas.* FROM caracteristicas INNER JOIN bitacoras on caracteristicas.idTipoBitacora2 = bitacoras.idTipoBitacora")
                        
                }
        }
        
        ################################
        
        if(dir.exists('./dataOutput')){
                print('El directorio existe...')
        }else{
                dir.create('./dataOutput')
                print('Se ha creado el directorio')
        }
        
        
        nombreArchivo <- paste('./dataOutput/', nombreHoja,'.txt')
        nombreArchivo <- str_replace_all(nombreArchivo, pattern=" ", repl="")
        
        write.table(subsetDatos, file = nombreArchivo, row.names = FALSE)
        print('Operación completada')

}

### Ejecutar la funcion para extraer los datos

dataSubset('bitacorasTrigo', 1, 'EXPORTAR', 2, '01_caracteristicas Bitácora')
dataSubset('bitacorasTrigo', 1, 'EXPORTAR', 3, '04_parcelas')
dataSubset('bitacorasTrigo', 1, 'EXPORTAR', 4, '08_aplicacion Insumos_descripci')
dataSubset('bitacorasTrigo', 1, 'EXPORTAR', 5, '09_aplicacion Insumos _producto')
dataSubset('bitacorasTrigo', 1, 'EXPORTAR', 6, '10_aplicacion Insumos _pH')
dataSubset('bitacorasTrigo', 1, 'EXPORTAR', 7, '11_labores Culturales&Cosecha')
dataSubset('bitacorasTrigo', 1, 'EXPORTAR', 8, '12_siembra Resiembra_general')
dataSubset('bitacorasTrigo', 1, 'EXPORTAR', 9, '13_siembra Resiembra_descripcio')
dataSubset('bitacorasTrigo', 1, 'EXPORTAR', 10, '14_siembra Resiembra_Productos')
dataSubset('bitacorasTrigo', 1, 'EXPORTAR', 11, '15_analisis Suelo_Descripcion')
dataSubset('bitacorasTrigo', 1, 'EXPORTAR', 12, '16_analisis Suelo_Resultado ')
dataSubset('bitacorasTrigo', 1, 'EXPORTAR', 13, '17_sensor Greenseeker')
dataSubset('bitacorasTrigo', 1, 'EXPORTAR', 14, '18_fertilizante Organico')
dataSubset('bitacorasTrigo', 1, 'EXPORTAR', 15, '19_riegos_Limitantes Desarrollo')
dataSubset('bitacorasTrigo', 1, 'EXPORTAR', 16, '20_riegos_Descripcion')

