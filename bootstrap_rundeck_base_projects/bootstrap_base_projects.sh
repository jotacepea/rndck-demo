#!/bin/bash

export RD_URL="http://localhost:4440/api/28"
export RD_INSECURE_SSL=true

export RD_DEBUG=3

export RD_USER=admin
export RD_PASSWORD=admin

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
cd ${SCRIPTPATH}

for R_PROJ_NAME in $(grep -v "#" ./rundeck_proj_list.txt); do

  echo ${R_PROJ_NAME}

  export R_PROJ_PATH="/var/rundeck/projects/${R_PROJ_NAME}"

  sed "s,THEPROJECTBASEDIRNAME,${R_PROJ_PATH},g" rundeck_default_project_scm.json | \
  sed -e "s,THEPROJECTNAME,${R_PROJ_NAME},g" > rundeck_default_project_scm_${R_PROJ_NAME}.json

  rd projects create -p ${R_PROJ_NAME}
  rd projects configure update -f rundeck_default_project_conf.properties -p ${R_PROJ_NAME}
  rd projects scm setup -f rundeck_default_project_scm_${R_PROJ_NAME}.json -i import -t git-import -p ${R_PROJ_NAME}

done
