


$ArquivoSaida="C:\temp\resultado.txt"
#Cabeçalho do arquivo de saída
"Computador;Usuario" > $ArquivoSaida
$Computers = Get-ADComputer -filter * -SearchBase "OU=Servers,DC=meudominio,DC=corp"
foreach($Computer in $Computers){
$Usuario = "??????"
"Verificando "+$Computer.name
if (test-connection $Computer.name -count 1 -quiet){
$Usuario =(gwmi -computer $Computer.name -query "select * from Win32_ComputerSystem").UserName
$Resultado=$Computer.name+";"+$Usuario
}else{
$Resultado=$Computer.name+";Sem conexão"
}
#Imprime Resultado
" "+$Resultado
$Resultado >> $ArquivoSaida
}

#Onde:
#C:\temp\resultado.txt é o diretório onde o arquivo será criado;
#DC=meudominio,DC=com,DC=br é em qual estrutura de pastas a pesquisa será realizada.
#Usuario é o usuario do active directory que deseja buscar 