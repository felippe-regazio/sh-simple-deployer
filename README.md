# SH Simple Deployer

This is a tiny deployer written in shell script. 
It uses rsync to sync files between local machine and server.

You can save connections, add multiple hosts, include and ignore entire directories to deployment,
and sync. This script automates the a common environment to sync local/server files with rsync.

You can read this post if you prefer a quick and fast start  
https://dev.to/felipperegazio/a-tiny-deployer-made-with-shell-script-and-rsync-3djd

# Getting Started

### 📂 Copy this project folder content to your project root.

You must copy this project folder content to the root of your project.
The deployer basepath will be the same of the deploy.sh file, and will be from where
your files will be sync. So, keep the deploy.sh file and the deploy folder on the very
root of your project.

### 🔧 Configure the \_hosts.sh file on ./deploy folder

This file holds the host list, an array collection of possible hosts
to perform a deploy on the current project. The array pattern must be always the same.

- The 1st line must be a connection string like user@destination:port, 
where port is optional.

- The 2nd line must be the absolute path for the project root on the server,
this is where rsync will send the files.

- The 3th line must be the project server IP or URL.

```bash
declare -a default=( 
	ssh_user@ssh_host:port   
	/server/dest/path/abs  
	https://myproject.url/  
)
```

The deployer will look at this file to know where to send the files when you run the script. If a name is not passed, will try to use the "default". Otherwise, you must pass a \_hosts.sh index name like:  

``` bash
./deploy.sh {null || host_index}
```

The command below will use the default \_hosts entry

```
./deploy.sh
```

The command below will use a \_hosts entry named "myhost"

```
./deploy.sh myhost
```

```WARNING:```: To discover your project absolute root on the server, access your
server using ssh, navigate to your project root folder, and type `pwd`. Dont use
filezilla or GUI clients as reference to find the root path.

### ✏️ Add the directories that you want to upload on the directories.txt 

The `directories.txt` lives inside the ./deploy folder.  Add the paths or files relative to project root, separated by a blank line. The default directory to sync is ".", or: the entire root folder. An example to deploy a dist folder and a .htaccess file would be:

```
dist
.htaccess
```

### ✏️ Add the directories you want to ignore on the ignore.txt 

The ignore.txt file lives inside the ./deploy folder. 
Add paths in the same way you did with the directories.txt.
This paths, folder, rules or files will be ignored by rsync.

### ✏️ Add an optional message to appear on the console when running the deployer.

You can write something on the remind.txt file.
This will be showed everytime someone runs deploy.sh.

### 🚀 Execute! To do it, run:

```bash
./deploy.sh
```

When you run it for the first time, rsync will sync your local project with the server one.
Now, when you modify something on your project, just run de deployer and it will sync only the
modified files, based on your configuration. A log will be saved on ./deploy/logs.

You could run it using `sh deploy.sh`, but from a system perspective, you don't need to launch a new shell by using `sh`. If you need sudo you can use `su` as well.

# Requirements

1. \*Unix local system with rsync and git installed. 
2. \*Unix server with Rsync and SSH connection enabled.

Most of this requirements are just a default configuration for any \*Unix system.
Tested with Linux and Mac OS systems, and worked with no environment setup.

# Git ?

This script was made to work with git. But if your project are not using git, there is no problem. You will see an information telling you `not a git repository`, just ignore it.

# Rsync

The default rsync params used to sync files is `-vrzuh`. You can pass a new set of rsync params to the deployer as the second arg. When passing rsync params the hosts_array_index is mandatody even for default:

```bash
./deploy.sh {hosts_array_index} {rsync_params}
```

# ABOUT

Sh Simple Deployer by Felippe Regazio under MIT LICENSE.  
Thanks to Virgil (@virgilwashere) for helping make this script more portable.
