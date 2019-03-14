FROM ubuntu:18.04 as build-stage

# Install Hugo
RUN apt-get update && apt-get install -y wget
RUN wget https://github.com/gohugoio/hugo/releases/download/v0.54.0/hugo_extended_0.54.0_Linux-64bit.deb
RUN dpkg -i hugo_extended_0.54.0_Linux-64bit.deb

# Map source directory
COPY ./ /usr/share/hello-world
WORKDIR /usr/share/hello-world

# Build the static site distribution
RUN hugo --minify --baseURL https://samhunt.dev/

# Host with nginx default configuration
FROM nginx
COPY --from=build-stage /usr/share/hello-world/public /usr/share/nginx/html