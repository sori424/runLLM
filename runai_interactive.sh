#!/bin/bash
# Running
#	bash runai_interactive.sh
# will create a job yourname-inter which 
# * has "interactive priority"
# * uses 0.5 GPU (customizable)
# * starts a jupyter server at port 8888 with default password "hello"
# * runs for 8 hours
#
# Optionally you can give the name a suffix:
#	bash runai_interactive.sh 1
# will create yourname-inter1
#
# Before starting a new interactive job, delete the previous one:
#	runai delete yourname-inter

# Customize before using:
# * CLUSTER_USER and CLUSTER_USER_ID
# * MY_WORK_DIR
# * MY_GPU_AMOUNT - fraction of GPU memory to allocate. Our GPUs usually have 32GB, so 0.25 means 8GB and 0.5 means 16GB.
# * JUPYTER_CONFIG_DIR if you want to configure jupyter (for example change password)


# all these infos can be accessed by `id` on your lab cluster
CLUSTER_USER= # find this by running `id -un` on nlplabsrv
CLUSTER_USER_ID= # find this by running `id -u` on nlplabsrv
CLUSTER_GROUP_NAME= # find this by running `id -gn` on nlplabsrv
CLUSTER_GROUP_ID= # find this by running `id -g` on nlplabsrv


MY_IMAGE="ic-registry.epfl.ch/....."

# If you want to use jupyter notebook
# JUPYTER_CONFIG_DIR="/cvlabdata2/home/lis/kubernetes_example/.jupyter"
# MY_CMD="cd $MY_WORK_DIR && timeout --preserve-status --kill-after=1m 8h jupyter lab --ip=0.0.0.0 --no-browser"

arg_job_suffix=$1
arg_job_name="$CLUSTER_USER-inter$arg_job_suffix"

echo "Job [$arg_job_name]"

runai submit $arg_job_name \
	-i $MY_IMAGE \
	--interactive \
	--gpu 1 \
    --cpu 3 \
	--pvc runai-nlp-sooh-nlpdata1:/nlpdata1 \
	--large-shm \
	-e USER=$CLUSTER_USER \
	-e USER_ID=$CLUSTER_USER_ID \
    --service-type=nodeport \
    --port 30011:22


# check if succeeded
if [ $? -eq 0 ]; then
	runai describe job $arg_job_name

	echo ""
	echo "Connect - terminal:"
	echo "	runai bash $arg_job_name"
	# echo "Connect - jupyter:"
	# echo "	kubectl port-forward $arg_job_name-0-0 8888:8888"
	# echo "	open in browser: http://localhost:8888 , default password 'hello'"
fi
