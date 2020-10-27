#!/bin/bash
# @sdttttt
######################################################################################
# Hugo 部署脚本 on Github Pages
# 基本是通用的
# 在用之前注意一些事项
######################################################################################
# TODO: Git config 中的全局用户名和邮箱已经配置完毕
# TODO: Hugo 已经安装，在当前环境变量下可以使用
# TODO: code_address仓库,确保配置成自己的
# TODO: 确认这个仓库在Github上已经创建了
######################################################################################
# 如果你是Linux, Mac OS平台，直接运行
# 如果你是 Windows 平台, 请使用make
######################################################################################
# 该脚本会将生成完成的静态文件放入docs文件夹中
# 请配置仓库GitHub Page的Source为Master分支下的docs文件夹
######################################################################################

starttime=`date +'%Y-%m-%d %H:%M:%S'`

code_address="https://github.com/adminwbb/adminwbb.github.io.git" # Hugo 项目地址# 
commit_message="docs: ☣ Update Blog."

dir=$(pwd)

function envClean(){
    if [ -d "./public" ];
    then
        rm -rf ./public
    fi

    if [ -d "../public" ];
    then
        rm -rf ../public
    fi

    if [ -d "./docs" ];
    then
        rm -rf ./docs
    fi
}

function cleanWork(){

    echo -e "\033[32m[Clean]\033[0m 🧹 Running..."

    cd $dir
    cd ..

    rm -rf ./public
}


function syncSourceCode(){

    echo -e "\033[32m[Pull]\033[0m 👀 Compare code ... "

    git pull $code_address master

    echo -e "\033[32m[Deploying]\033[0m 🚀 Push Running... "

    git add --ignore-errors .
    git commit -q -m "${commit_message}"

    set -e

    push_starttime=`date +'%Y-%m-%d %H:%M:%S'`

    if [ -n  $code_address_gitee ];
    then
        echo -e "\033[32m[Synchronizing]\033[0m 🚀 Source code to Github..."
        git push -q --progress --atomic $code_address master
    else
        git push --progress --atomic $code_address master
    fi

    local push_endtime=`date +'%Y-%m-%d %H:%M:%S'`
    local start_seconds=$(date --date="$push_starttime" +%s);
    local end_seconds=$(date --date="$push_endtime" +%s);

    echo -e "Total in "$((end_seconds-start_seconds))" s"
}

function generateSite(){
    echo -e "\033[32m[HugoGenerator]\033[0m 🚚 Hugo Building..."
    hugo

    if [ -d "./public" ];
    then
        mv ./public ./docs
    fi
}

function checkEnv() {
    echo -e "\033[34m[Monitor]\033[0m 🤔 Check Status..."

    if [ $? -eq 0 ];
    then
        if [ -d "./docs" ];
        then    
            return 0
        else
            echo -e "\033[31m[Error]\033[0m 💥 Oh! 没有找到docs目录."
        fi
    else
        echo -e "\033[31m[Error]\033[0m 💥 环境变量中不存在 hugo: 请安装它"
    fi

    return 1
}

function deploy(){

    checkEnv
    if [ $? -eq 0 ];
    then
        syncSourceCode
        cleanWork

        local endtime=`date +'%Y-%m-%d %H:%M:%S'`
        local start_seconds=$(date --date="$starttime" +%s);
        local end_seconds=$(date --date="$endtime" +%s);

        echo -e "\033[32m[Successful]\033[0m 🎉 We did it! 🕒 Total Time: "$((end_seconds-start_seconds))"s"
    else
        cleanWork
    fi
}

envClean
generateSite
deploy

cd $dir
