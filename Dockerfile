# Stage 0, "build-stage", based on Node.js, to build and compile the frontend
FROM node:10.15-alpine as build-stage
WORKDIR /app
COPY package.json /app/
COPY src/ /app/src
COPY static/ /app/static
COPY public/ /app/public
COPY manifest.json /app
RUN npm install
RUN npm run build

# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx:1.16-alpine
COPY --from=build-stage /app/build/ /usr/share/nginx/html
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 3000
CMD ["nginx","-g","daemon off;"]