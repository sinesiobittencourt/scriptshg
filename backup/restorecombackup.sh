#!bash


echo "############################################################"
echo "#                                                          #"
echo "#              RESTAURAÇÃO DE BACKUP                       #"
echo "#                                                          #" 
echo "############################################################"
echo "O processo será composto pelas etapas abaixo:"
echo "1) Gerar um backup de segurança da conta no /home/hgtrans/ com o número do ticket."
echo "2) Realizar a restauração total da conta."
echo "3) Mover o backup feito na primeira etapa para a home do cliente com o nome de backup_hg"
echo "Qual o número do ticket de restauração?"
read ticket
echo "Qual o usuário para restauração?"
read usuario
echo "Desejar realizar a restauração completa da conta ou parcial? (C ou P)"
read decisao
        case $decisao in
                C|c) echo "Iniciando a cópia da cópia por segurança";;
                        mkdir /home/hgtrans/$ticket;
                        if [-d /home/hgtrans/$ticket] then
                                /scripts/pkgacct $usuario /home/hgtrans/$ticket;
                                clear
                                echo "O backup foi concluído neste momento, iniciando agora a restauração do NAS"
                                sleep 5
                                /home/hgbackup/restore.pl.old $usuario full;
                                cd ~$usuario; mv /home/hgtrans/$ticket backup_hg;
                                perms
                                echo -e "A restauração foi finalizada"

                        else
                                echo "Um problema ocorreu, entre em contato com o administrador do script"
                        fi

                P|p) echo "Selecione o que deseja restaurar:" ;;
                                echo -e "1) Banco de dados"
                                echo    "2) Diretório"
                                echo    "3) Arquivo"
                                read parcial
                                case $parcial in
                                        1) echo "Digite o banco que deseja restaurar? Se for todos digite all!"
                                                read restore_banco
                                                case $restore_banco in
                                                        all|ALL) /home/hgbackup/restore.pl.old $usuario mysql all;
                                                        clear
                                                echo "A restauração de todos os bancos foi concluída, pode ser que alguns tenham que ser restaurados manualmente. Verifique!"

https://github.com/edestark/public/blob/master/cdtip
