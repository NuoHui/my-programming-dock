# 选择node镜像
FROM node:12.6.0-buster-slim

# 安装nginx
RUN apt-get update \
    && apt-get install -y nginx

# 指定工作目录
WORKDIR /app

# 隔开写入镜像
ADD package.json /app

# 1. 安装依赖
RUN npm install --production --registry=https://registry.npm.taobao.org

# 把当前所有目录下文件拷贝到工作目录
COPY . /app/

# 运行时容器提供服务端口
EXPOSE 80

# 1. 打包
# 2. 把dist目录下文件拷贝到 nginx目录下
RUN npm run docs:build \
    && cp -r docs/.vuepress/dist/* /var/www/html
# 启动nginx
CMD ["nginx", "-g", "daemon off;"]