##################################################################################################
##### Unir fechas con datos generales de la bitacora

setwd('C:/Users/LVARGAS/Documents/CIMMYT/dataBase/2016/2016-09-15-calendarios/AnalisisR')

library(stringr) # para la funcion str_replace_all
library(sqldf)


#Obtener la tabla de fechas
fechas <- read.table('./dataOutput2/calendarios.txt', header = TRUE, sep = ",")
# Obtener la tabla de caracteristicas
caracteristicas <- read.table('./dataOutput/01_caracteristicasBitácora.txt', header = TRUE, fileEncoding = 'UTF-8')
head(caracteristicas)
names(fechas)
nrow(fechas)
names(caracteristicas)

## Eliminar los id tipo de bitacora repetidos, para evitar repetir las registros
caracteristicas <- sqldf('SELECT * FROM caracteristicas group by idBitacora')

#Unir los datos de las dos tablas
fechasCaracteristicas <- sqldf("select fechas.*, caracteristicas.Año, caracteristicas.'Ciclo.agronómico', caracteristicas.'ID.de.la.parcela..clave.foránea.' from fechas join caracteristicas on fechas.'ID.de.la.bitácora..clave.foránea.' = caracteristicas.idBitacora")
nrow(fechasCaracteristicas)
names(fechasCaracteristicas)

#write.table(fechasCaracteristicas, file = './dataOutput3/fechasCaracteristicas.txt', row.names = FALSE, sep = ",")

##################################################################################################
##### Unir fechas con datos generales de la parcela
#Obtener la tabla de fechas

parcelas <- read.table('./dataOutput/04_parcelas.txt', header = TRUE, fileEncoding = 'UTF-8')
head(parcelas)
names(parcelas)
nrow(parcelas)

fechasCaracteristicasParcelas <- sqldf("select fechasCaracteristicas.*, parcelas.'Nombre.del.Hub', parcelas.Estado, parcelas.Municipio, parcelas.Localidad FROM fechasCaracteristicas JOIN parcelas ON fechasCaracteristicas.'ID.de.la.parcela..clave.foránea.' = parcelas.idParcela")
nrow(fechasCaracteristicasParcelas)
head(fechasCaracteristicasParcelas)
names(fechasCaracteristicasParcelas)


###### convertir a formato de fecha

fechasCaracteristicasParcelas$Fecha.de.la.aplicación <- as.Date(fechasCaracteristicasParcelas$Fecha.de.la.aplicación, "%d/%m/%Y")

##################################################################################################
##### Agrupar las secciones

secciones <- read.csv('nombresSecciones.csv')
names(secciones)

fechasCaracteristicasParcelasSecciones <- sqldf("select fechasCaracteristicasParcelas.*, secciones.'Nombre.de.la.sección', secciones.Grupo FROM fechasCaracteristicasParcelas JOIN secciones ON fechasCaracteristicasParcelas.'Nombre.de.la.sección' = secciones.Seccion")
nrow(fechasCaracteristicasParcelasSecciones)
names(fechasCaracteristicasParcelasSecciones)

##################################################################################################

#Guardar el archivo
if(dir.exists('./dataOutput3')){
        print('El directorio existe...')
}else{
        dir.create('./dataOutput3')
        print('Se ha creado el directorio')
}

nombreArchivo <- paste('./dataOutput3/', 'calendariosCiclo','.txt')
nombreArchivo <- str_replace_all(nombreArchivo, pattern=" ", repl="")
write.table(fechasCaracteristicasParcelasSecciones, file = nombreArchivo, row.names = FALSE, fileEncoding = 'UTF-8')


