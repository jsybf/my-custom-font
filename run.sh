#!/bin/bash

stack_name="iosevka-builder-1"
pem_file="~/.ssh/pem/foo_key_pair.pem"
font_build_path="/home/ec2-user/font_build"

function create_ec2() {
    local stack_name=$1

    # create ec2 stack
    aws cloudformation create-stack \
        --stack-name ${stack_name} \
        --no-cli-pager \
        --template-body file://ec2-cfn.yml \
        --capabilities CAPABILITY_IAM > /dev/null

    # wait until ec2 stack resouces create complete
    while :
    do
        local stack_status=$(aws cloudformation describe-stacks \
            --stack-name ${stack_name} \
            --no-cli-pager \
            --output text \
            --query 'Stacks[0].StackStatus'
        )

        if [ ${stack_status} == "CREATE_COMPLETE" ]; then
            break
        fi
        echo ${stack_status} >&2
        sleep 1
    done

    # get public ip of ec2
    local public_ip=$(aws cloudformation describe-stacks \
        --stack-name ${stack_name} \
        --no-cli-pager \
        --output text \
        --query "Stacks[0].Outputs[?OutputKey=='Ec2PublicIp'].OutputValue | [0]")
    echo "${public_ip}"
}


function process() {
    local pem_path=$1
    local font_build_path=$2
    local public_ip=$3


    ssh -o StrictHostKeyChecking=no -i ${pem_path} ec2-user@${public_ip} "mkdir -p ${font_build_path}"
    scp -i ${pem_path} private-build-plans.toml ec2-user@${public_ip}:${font_build_path}/

    # execute script 
    ssh -i ${pem_path} ec2-user@${public_ip} 'bash -s' < provision.sh >&2
}

function delete_ec2() {
    local stack_name=$1

    aws cloudformation delete-stack \
        --stack-name ${stack_name}
}

public_ip=$(create_ec2 ${stack_name})
process ${pem_file} ${font_build_path} ${public_ip}
delete_ec2 ${stack_name}

# # send iosevka font build plan
# ssh -o StrictHostKeyChecking=no -i ${pem_file} ec2-user@${public_ip} "mkdir -p ${font_build_path}"
# scp -i ${pem_file} private-build-plans.toml ec2-user@${public_ip}:${font_build_path}/
#
#
# # execute script 
# ssh -i ${pem_file} ec2-user@${public_ip} 'bash -s' < provision.sh


