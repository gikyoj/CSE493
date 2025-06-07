#!/bin/bash 

output_file="./output/$name/output.txt"

mkdir ./output/$name
touch -a $output_file

echo "\$name=$name" 2>&1 | tee -a $output_file
echo $(date) 2>&1 | tee -a $output_file

echo "### python train.py $name ###" 2>&1 | tee -a $output_file
python train.py $name 

echo "### python rep_saver.py $name ###" 2>&1 | tee -a $output_file
python rep_saver.py $name 2>&1 | tee -a $output_file

echo "### julia --project=. run_filters.jl $name ###" 2>&1 | tee -a $output_file
julia --project=. run_filters.jl $name 2>&1 | tee -a $output_file

for mask_name in mask-rcov-target mask-pca-target mask-kmeans-target ;
    do 
        echo "### python train.py $name $mask_name ###" 2>&1 | tee -a $output_file
        python train.py $name $mask_name 2>&1 | tee -a $output_file
    done