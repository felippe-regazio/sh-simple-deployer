# SH Simple Deployer

Shell script simple para deployment de projetos widgrid.
Antes de utilizá-lo é estritamente necessario configurá-lo propriamente.

# First Things First

1. Baixe esse repositorio e mova a pasta /deploy para a raiz do seu projeto
2. Mova o arquivo ./deploy.sh para a raiz do seu projeto
3. Voce pode renomear o arquivo ./deploy.sh para algum nome que vc goste
4. Utilize como descrito a seguir:

# Definindo a estrategia

No arquivo ./deploy/\_hosts.sh existe a variavel DEPLOYMENT_TYPE

Esta variável define a estratégia utilizada no deployment. Pode ser:

"rsync" ou "git"

# Rsync como estratégia

Se você utilizar rsync, vc deve ler a documentação abaixo. O deployer utilizar
rsync para subir os arquivos da sua máquina local. O processo será muito parecido
com um processo de upload, porém mais sofisticado uma vez que utiliza rsync.

# Git como estratégia

Utilizando git como estratégia, vc deverá configurar a raiz do seu projeto como
um repositório --bare.

Va ate o server via ssh. Uma vez logado no servidor, você deve navegar até a pasta raiz do seu projeto (Document Root), 
no meu caso, está localizado em /var/www/html/exemplo/

```bash
sh user@server && cd /var/www/html/exemplo
```

Até o momento não tenho nada nesse diretório, ele está completamente vazio, nesse diretório eu vou criar uma pasta que eu gosto de nomear sempre como app.git, crie esse diretório e entre nele usando o comando:

```bash
mkdir app.git && cd app.git
```

Uma vez dentro do diretório app.git, executamos o comando git init — bare esse comando irá inicializar um repositório mínimo do Git, digo mínimo porque ele não possui todas as funcionalidades do Git, por exemplo, não será possível executar comandos como push e pull nele, a única e exclusiva funcionalidade desse repositório é receber os push do seu ambiente de desenvolvimento e manter sua aplicação atualizada com segurança no servidor.

```bash
git init --bare
```

Ok, até aqui já temos boa parte do trabalho pronta, o que vamos fazer agora é criar um arquivo chamado post-receive dentro do diretório hooks, então execute o comando 

```bash
vi hooks/post-receive.
```

exemplo do que deverá estar dentro de hooks/post-receive

```
#!/bin/sh
GIT_WORK_TREE=/var/www/html/exemplo git checkout -f
```

Veja no exemplo como fica o script, repare que o GIT_WORK_TREE é o local onde seu site/app ficará armazenado, seguido do comando git checkout -f

Um detalhe muito importante é que na primeira linha do post-receive deve ter o comentário #!/bin/sh para que esse arquivo seja executado corretamente. Ao preencher o post-receive como indica a imagem salve o documento com o atalho CTRL+o e em seguida para sair CTRL+x.
Antes de fechar essa parte no servidor precisamos dar permissão de execução para o hook que criamos, então fazemos isso usando o comando:

```bash
sudo chmod +x hook/post-receive.
```

OK, a acabamos a parte do servidor, agora vamos para nosso ambiente local na qual estamos desenvolvendo. Navegue até o diretório do seu projeto e caso ainda não tenha iniciado um repositório git nele faça (git init), uma vez já com o git iniciado no projeto precisamos adicionar uma indicação remote nele, para isso use o comando abaixo (tudo na mesma linha) como se faz quando vamos adicionar o origin (Github/Bitbucket).

# HOSTS

./deploy/\_hosts.sh

Neste arquivo devem ser configurados os hosts, credenciais e destinos
disponíveis para o deployer. Deve ser configurado no formato de bash3 array
para melhor compatibilidade com qualquer UNIX sys. Assim o padrao deve ser estritamente
seguido. 

O index "default" deve sempre existir. Ele é utilizado quando um index nao eh especificado.
Para criar um novo "dest host config", crie um novo array neste arquivo desta forma:


declare -a nome_referencial=(
	ssh_user@ssh_host
	/server/dest/path/abs
	https://myproject.url/
)

* nome_referencial é o nome do seu set de configurações. utilize o que desejar.
* a primeira linha deve conter a conexao ssh para o projeto
* a segunda linha deve conter o root path destino dos arquivos no server
* a terceira linha deve conter a url do projeto

após criar o seu hosts, vc pode chama-lo referenciando o nome dele ao executar o deployer.
exemplo: 

```bash
sh deploy.sh nome_referencial
```

# DIRETORIOS

./deploy/directories.txt

Este arquivo deve conter o caminho das pastas e arquivos que o deployer deverá subir.
Você pode passar diretorios no padrao lista para rync. Saiba mais lendo o manual
do parametro --files-from do comando rsync.

Basicamente trata-se de uma lista de diretorios separada por line breaks.
Todo caminho será relativo ao ROOT_PATH do projeto.

Coloque apenas "." (sem aspas) neste arquivo para subir o projeto inteiro.

# IGNORE

./deploy/ignore.txt

Segue o mesmo padrado que o directories.txt, porem tratam-se das pastas e arquivos
para serem ignorados. Padroes blob podem ser utilizados. Saiba mais lendo o manual
do parametro --exclude-from do comando rsync.

# Executando

```bash
sh deploy.sh
```

Após configurado, toda vez que o deployer eh configurado, ele synca o que foi modificado
no projeto local para o servidor, de forma rápida e simples.

O comando acima subirá todas as pastas/arquivos listados em ./deploy/directories.txt
ignorando as pastas/arquivos listados em ./deploy/ignore.txt utilizando a conexão
default declarada no arquivo ./deploy/\_hosts.sh. Todos os parametros sao opicionais.

# Parametros

```bash
sh deploy.sh {host_index} {rsync_params}
```

* host_index:   nome/index do host declarado em hosts
* rsync_params: set de parametros rsync para utilizar no upload (default: -vrzch)

os parametros rsync por default serão -vrzch:

(v) verbose 
(r) recursive
(z) compress 
(c) checksum 
(h) human readable

Os arquivos serão subidos ao serem diferenciados por checksum. Se forem diferentes, sobem.

# REMIND

./deploy/remind.txt

Pode conter uma mensagem para ser mostrada antes de iniciar o deploy. Pode ser vazio.

# LOGS

Para cada comando rodado um log eh salvo na pasta /deploy/log/. Deve ser aplicado uma
logica para limpar essa pasta de tempos em tempos. Fica a cargo da natureza do projeto.

# ABOUT

Sh Simple Deployer by Felippe Regazio under MIT LICENSE
https://github.com/felippe-regazio/sh-simple-deployer