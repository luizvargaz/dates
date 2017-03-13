setwd('C:/Users/LVARGAS/Documents/CIMMYT/dataBase/2016/2016-09-15-calendarios/AnalisisR')

library(stringr) # para la funcion str_replace_all

formulas <- read.table('./dataImput/archivosDatosFechas.txt', header = FALSE)
hojas <- formulas$V1

fila = 1

for(hoja in hojas){
                
        print(fila)
        print(hoja)
        nombreArchivo <- paste('./dataOutput/', hoja,'.txt')
        nombreArchivo <- str_replace_all(nombreArchivo, pattern=" ", repl="")
               
        #######################################
        
        aplicaciones <- read.table(nombreArchivo, header = TRUE, fileEncoding='UTF-8')
        
        uno <- formulas$V2[fila]
        dos <- formulas$V3[fila]
        tres <- formulas$V4[fila] 
        cuatro <- formulas$V5[fila]
        cinco  <- formulas$V6[fila]
        seis <- formulas$V7[fila]
        siete <- formulas$V8[fila]
        ocho <- formulas$V9[fila]
        
        #######################################
                
        # Almacenar los subset de datos sin outliers para que al final se escriban en un archivo
        if(fila == 1){
                subAplicaciones <- aplicaciones[,c(uno, dos, tres, cuatro, cinco, seis, siete, ocho)]
                nombresVariables <- names(subAplicaciones)
                print(nombresVariables)
                unionDatos <- subAplicaciones
                        
        }else{
                
                subAplicaciones <- aplicaciones[,c(uno, dos, tres, cuatro, cinco, seis, siete, ocho)]
                names(subAplicaciones) <- nombresVariables 
                unionDatos <- rbind(unionDatos, subAplicaciones)
                head(unionDatos)
                        
        } 
        
        fila = fila + 1
                
}

datos <- unionDatos[unionDatos$Tipo.de.parcela..testigo.o.innovación. != 'Parcela Área de Impacto',]

if(dir.exists('./dataOutput2')){
        print('El directorio existe...')
}else{
        dir.create('./dataOutput2')
        print('Se ha creado el directorio')
}

nombreArchivo <- paste('./dataOutput2/', 'calendarios','.txt')
nombreArchivo <- str_replace_all(nombreArchivo, pattern=" ", repl="")

write.table(datos, file = nombreArchivo, row.names = FALSE, sep = ",")