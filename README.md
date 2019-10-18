# SH Simple Deployer

This is a tiny deployer written in shell script. 
It uses rsync to sync files between local machine and server.

You can save connections, add multiple hosts, include and ignore entire directories to deployment,
and sync. The rsync will always sync only modified files.

# Configuring

### 1. Copy the project folder content to your project root.

You must copy this project folder content to the root of your project.
The deployer basepath will be the same of the deploy.sh file, and will be from where
your files will be sync. So, keep the deploy.sh file and the deploy folder on the very
root of your project.

### 2. Configure the \_hosts.sh file on ./deploy folder

This file holds the host list, an array collection of possible hosts
to perform a deploy on the current project.

The deployer will look at this file to know where to send the files.
If a name is not passed, will try to use the "default". Otherwise,
you must pass a \_hosts.sh index name like:  

``` bash
sh deployer.sh {host_index}
```

The array pattern must be always the same.

- The 1st line must be a connection string like user@destination:port, 
where port is optional.

- The 2nd line must be the absolute path for the project root,
this is where rsync will send the files.

- The 3th line must be the project server IP or URL.

```bash
declare -a default=( 
	ssh_user@ssh_host:port   
	/server/dest/path/abs  
	https://myproject.url/  
)
```

### 3. Add the directories that you want to upload on the directories.txt 

The directories.txt lives inside the ./deploy folder. 
Add the paths or files relative to project root, separated by a blank line.
The default directory to sync is ".", or: the entire root folder.

### 4. Add the directories you want to ignore on the ignore.txt 

The ignore.txt file lives inside the ./deploy folder. 
Add paths in the same way you did with the directories.txt.
This paths, folder, rules or files will be ignored by rsync.

### 5. Add an optional message to appear on the console when running the deployer.

You can write something on the remind.txt file.
This will be showed everytime someone runs deploy.sh.

### 6. Execute. To do it, run:

Now, when you modify something on your project, just run de deployer and it will sync
your local project with the server, based on your configurations.

```bash
sh deploy.sh
```

or with a specific host configuration from \_hosts.sh:

```bash
sh deploy.sh host_array_name
```

# Rsync

This scripts need rsync to work. The default rsync params is `-vrzuh`.
You can pass a new set of rsync params to the deployer as the second arg:

```bash
sh deploy.sh {hosts_array_index} {rsync_params}
```

# ABOUT

Sh Simple Deployer by Felippe Regazio under MIT LICENSE