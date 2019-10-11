# SH Simple Deployer

Shell script simple deployment with RSYNC.

# Getting started

Add this folder content to your project root.
Configure the following things inside ./deployer directory:

### \_hosts.sh 

A bash array containing your host information.
Every host must follow this pattern. The default
host must always exist.

```bash
declare -a default=( 
	ssh_user@ssh_host:port   
	/server/dest/path/abs  
	https://myproject.url/  
)

declare -a another=( 
	another@ssh_another_host:port
	/server/dest/path/another_abs  
	https://another_project.url/  
)
```

The array order is:

- SSH connection with optional port.
- Abs path on the server to where upload files
- Project URL or IP

### directories.txt

Add the directories that you want to upload.
Path notation must be relative to the project root.

### ignore.txt

Same as directories.txt, but refer to dirs to ignore.

### remind.txt

A message to appear always when executing the deploy.sh.

### Exec

Now run

```bash
sh deploy.sh
```

or with a specific host configuration from \_hosts.sh:

```bash
sh deploy.sh host_array_name
```

# Params

```bash
sh deploy.sh {host_index} {rsync_params}
```

# ABOUT

Sh Simple Deployer by Felippe Regazio under MIT LICENSE