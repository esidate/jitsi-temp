# use node alpine
FROM node:16-alpine as builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

FROM nginx

EXPOSE 80 443

COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./nginx/nginx-selfsigned.crt /etc/ssl/certs/nginx-selfsigned.crt
COPY ./nginx/nginx-selfsigned.key /etc/ssl/private/nginx-selfsigned.key
COPY ./nginx/self-signed.conf /etc/nginx/snippets/self-signed.conf
COPY ./nginx/ssl-params.conf /etc/nginx/snippets/ssl-params.conf
COPY ./nginx/dhparam.pem /etc/ssl/certs/dhparam.pem
COPY --from=builder /app/dist /usr/share/nginx/html