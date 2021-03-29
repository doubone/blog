#!/bin/bash
echo 'shell is starting!'

# step 1
# 添加 sub_tree 远程链接
# resource ="resource"
# resource_origin = ""

#step 2
# 判断sub_tree 文件目录是否已存在 && copy 同级目录下的src文件进入 sub_tree 文件

file_exist() {

    # if test -d $1; then
    #     echo '文件存在'
    # else
    #     echo '文件不存在'
    # fi
    return $(test -d $1)
    #如果存在，返回0；如果不存在返回1
}

# file_exist public
# echo $?

# if [ $? -eq 0 ]; then
#     cp ../start.sh ./public/     
# else
#     echo '复制文件出错'
#     # 打开readme文件
# fi



# cd ./
# if test -d ./shell
# then
#     echo '文件存在'
# else
#     echo '文件不存在'
# fi

# cp ../start.sh ./public/
# step 3
# 获取当前项目所需镜像 并启动项目

# npm install && npm run start
