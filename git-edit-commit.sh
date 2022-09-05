#!/bin/bash
# ###################################
# Author      : gaoyang
# Url         : https://github.com/gaoyang/tool-shells
# Description : 修改git提交历史
# ###################################

cd $1

read -r -p "输入要修改的邮箱地址:" email
read -r -p "新的邮箱:" new_email
read -r -p "新的名称:" new_name

git filter-branch -f --env-filter '
if [ "$GIT_COMMITTER_EMAIL" = "'${email}'" ]
then
    export GIT_COMMITTER_NAME="'${new_name}'"
    export GIT_COMMITTER_EMAIL="'${new_email}'"
fi
if [ "$GIT_AUTHOR_EMAIL" = "'${email}'" ]
then
    export GIT_AUTHOR_NAME="'${new_name}'"
    export GIT_AUTHOR_EMAIL="'${new_email}'"
fi
' --tag-name-filter cat -- --branches --tags

read -r -p "是否强制推送至服务器？(Y/n)" response

if [[ "$response" =~ ^([yY])$ ]]; then
    git push --force --tags origin 'refs/heads/*'
fi
