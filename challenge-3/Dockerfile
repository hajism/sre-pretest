FROM nginx:alpine

# Copy index.html and nginx.conf
COPY index.html /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

# Update alpine
RUN apk update && apk add bash