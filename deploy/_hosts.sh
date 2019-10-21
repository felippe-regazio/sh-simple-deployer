#!/usr/bin/env bash

# This file holds the host list, an array collection of possible hosts
# to perform a deploy on the current project.
#
# The deployer will look at this file to know where to send the files.
# If a name is not passed, will try to use the "default". Otherwise,
# you must pass a _hosts.sh index name like:
#
# sh deployer.sh {host_index}
#
# The array pattern must be always the same.
# 1. The 1st line must be a connection string like user@destination:port, 
# where port is optional.
# 2. The 2nd line must be the absolute path for the project root,
# this is where rsync will send the files.
# 3. The 3th line must be the project server IP or URL.

declare -a default=(
	root@127.0.0.0
	/path/to/project/root/on/server
	https://yourprojecturl.com
)

declare -a another=(
	another_root@127.0.0.0
	another/path/to/project/root/on/server
	https://anotherprojecturl.com
)