#! /usr/bin/env bash

# add ancillary sites here. no quotes or commas, please.
# the name of the ancillary sites should match the acutal
# repository name without .git from the git repository url
# 
# ex: git@s4mh.git.beanstalkapp.com:/s4mh/screening-ee.git
#                                        |<-- this -->|
# 
# ex: ancillary_sites=(
# 		screening-ee
# 		site2
# 		)
ancillary_sites=(
	)

# the repository url without the actual repository name
# (include the trailing slash)
# 
# ex: git@s4mh.git.beanstalkapp.com:/s4mh/
GIT_REPO_URL=

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for i in "${ancillary_sites[@]}"
do
	if [ ! -d "$BASE_DIR/../$i" ]
	then
		echo ">>> The ancillary site, $i, does not exist."
		echo ">>> Cloning the repo one level up..."
		cd $BASE_DIR/..
		git clone $GIT_REPO_URL$i.git
	fi	
done