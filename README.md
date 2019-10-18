# SH Simple Deployer

This is a tiny deployer written in shell script. 
It uses rsync to sync files between local machine and server.

You can save connections, add multiple hosts, include and ignore entire directories to deployment,
and sync. The rsync will always sync only modified files.

# Configuring

1. Copy the project folder content to your project root.
2. Configure the \_hosts.sh file on ./deploy folder

This file holds the host list, an array collection of possible hosts
to perform a deploy on the current project.

The deployer will look at this file to know where to send the files.
If a name is not passed, will try to use the "default". Otherwise,
you must pass a \_hosts.sh index name like:  

sh deployer.sh {host_index}

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

3. Add the directories that you want to upload on the directores.txt file
inside the ./deploy folder. Add the paths relative to project root, separated
by a blank line.

4. Add the directories you want to ignore on the ignore.txt file, in the same
way you did with the directories.txt.

5. Add a optional message to appear on the console when running the deployer.

6. Execute. To do it, run:

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