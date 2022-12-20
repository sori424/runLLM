#!/usr/bin/env bash


N_GPU=1
BATCH=8
MODEL='bigscience/bloom-560m'


deepspeed \
    --num_gpus ${N_GPU} \
    /home/sooh/bloom-ds-zero-inference.py \
    --name ${MODEL} \
    --batch_size ${BATCH} \
    --cpu_offload \
    --benchmark
