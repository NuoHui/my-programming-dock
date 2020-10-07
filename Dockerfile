# 选择node镜像、基础镜像要小
FROM node:10-alpine

ENV PROJECT_ENV production
ENV NODE_ENV production

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
# 3. 删除工作目录下的文件 减少镜像体积
RUN npm run docs:build \
    && cp -r docs/.vuepress/dist/* /var/www/html \
    && rm -rf /app

# 启动nginx
CMD ["nginx", "-g", "daemon off;"]