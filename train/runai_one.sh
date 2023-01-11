#!/bin/bash
# Usage
# bash runai_one.sh job_name num_gpu "command"
# Examples:
#	`bash runai_one.sh name-hello-1 1 "python hello.py"`
#	- creates a job names `name-hello-1`
#	- uses 1 GPU
#	- enters MY_WORK_DIR directory (set below) and runs `python hello.py`
#
#	`bash runai_one.sh name-hello-2 0.5 "python hello_half.py"`
#	- creates a job names `name-hello-2`
#	- receives half of a GPUs memory, 2 such jobs can fit on one GPU!
#	- enters MY_WORK_DIR directory (set below) and runs `python hello_half.py`


CLUSTER_USER= # find this by running `id -un` on iccvlabsrv
CLUSTER_USER_ID= # find this by running `id -u` on iccvlabsrv
CLUSTER_GROUP_NAME=NLP-StaffU # find this by running `id -gn` on iccvlabsrv
CLUSTER_GROUP_ID=11131 # find this by running `id -g` on iccvlabsrv


MY_IMAGE="ic-registry.epfl.ch/nlp/sooh/ubuntu"
# JUPYTER_CONFIG_DIR="/cvlabdata2/home/lis/kubernetes_example/.jupyter"
# MY_CMD="cd $MY_WORK_DIR && timeout --preserve-status --kill-after=1m 8h jupyter lab --ip=0.0.0.0 --no-browser"

arg_job_suffix=$2
arg_job_name="$CLUSTER_USER-train"
arg_cmd=`echo $3 | tr '\n' ' '`

echo "Job [$arg_job_name]"

runai submit $arg_job_name \
	-i $MY_IMAGE \
	--gpu 1 \
	--pvc runai-nlp-$CLUSTER_USER-nlpdata1:/nlpdata1 


# --command -- "/scratch/sooh/entrypoint.sh"
# check if succeeded
# \
# 	-e USER=$CLUSTER_USER \
# 	-e USER_ID=$CLUSTER_USER_ID \
# 	-- /entrypoint.sh
if [ $? -eq 0 ]; then
	runai describe job $arg_job_name

	echo ""
	echo "Connect - terminal:"
	echo "	runai bash $arg_job_name"
	# echo "Connect - jupyter:"
	# echo "	kubectl port-forward $arg_job_name-0-0 8888:8888"
	# echo "	open in browser: http://localhost:8888 , default password 'hello'"
fi
