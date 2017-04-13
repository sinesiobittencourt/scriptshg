#!/bin/bash

printf 
"############################################################
#                                                          #
#              RESTAURAÇÃO DE BACKUP                       #
#                                                          #
############################################################\n"
echo -e "O processo será composto pelas etapas abaixo:\n"
echo -e "1) Gerar um backup de segurança da conta no /home/hgtrans/ com o número do ticket."
echo -e "2) Realizar a restauração total da conta."
echo -e "3) Mover o backup feito na primeira etapa para a home do cliente com o nome de backup_hg\n"
echo -e "Qual o número do ticket de restauração?\n"
read ticket
echo -e "Qual o usuário para restauração?\n"
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
				echo "Um problema ocorreu na criação do diretório, entre em contato com o administrador do script" 
			fi

		P|p) echo "Selecione o que deseja restaurar:" ;;
  	                      menu() {
			      cab
				echo -e "[ 1 ] Banco de dados"
				echo -e "[ 2 ] Diretório"
				echo -e "[ 3 ] Arquivo"
				read -n 1 -p "Opção: <ENTER=Retorna>" opc
				[ "x$opc" == "x" ] && echo -e "\nOpção Inválida!\n" && *) menu;;
				case $opc in
					1) banco;;
					2) diretorio;;
					3) arquivo;;
					*) menu;;
				esac
				}				     
 
				#BANCO DE DADOS
				banco() {
				echo -e "Cite o banco de dados que deseja restaurar ou digite 'all' para todos"
				leia restore_banco
				echo -e "A restauração está sendo iniciada..."
				if restore_banco=all then 
					/home/hgbackupdir/restore.pl.old $usuario mysql all
				else
					/home/hgbackupdir/restore.pl.old $usuario mysql $restorebanco
				fi
				echo -e "A restauração foi finalizada!\n"
				read -n 1 -p "Pressione qualquer tecla para finalizar!"
				}	
						


				#DIRETÓRIO
				diretorio() {
				echo -e "Digite o caminho completo do diretório que deseja restaurar:\n"
				read restore_diretorio
				echo -e "A restauração do diretório $restore_diretorio está sendo iniciada..."
				/home/hgbackupdir/restore.pl.old $usuario directory $restore_diretorio;
				echo -e "A restauração foi finalizada!\n"
				read -n 1 -p "Pressione qualquer tecla para finalizar!"
				}

				#ARQUIVO
				arquivo() {
				echo -e "Digite o caminho completo do arquivo que deseja restaurar:\n"
				read restore_arquivo
				echo -e "A restauração do arquivo $restore_arquivo está sendo iniciada..."			
				/home/hgbackupdir/restore.pl.old $usuario file $restore_arquivo;
				echo -e "A restauração foi finalizada!\n"
				read -n 1 -p "Pressione qualquer tecla para finalizar"
				}





	*) echo "Você tem de entrar com um parâmetro válido, utilize C/c ou P/p" ;;
	esac
