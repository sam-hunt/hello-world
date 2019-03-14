FROM ubuntu:18.04

# Install wget to pull the hugo binary
RUN apt-get update && apt-get install -y wget

# Pull Hugo
RUN wget https://github.com/gohugoio/hugo/releases/download/v0.54.0/hugo_extended_0.54.0_Linux-64bit.deb

# Install Hugo
RUN dpkg -i hugo_extended_0.54.0_Linux-64bit.deb

# Map our source directory
COPY ./ /usr/share/hello-world
WORKDIR /usr/share/hello-world

# Ensure hugo required folders exist
RUN if [ -d "./content/" ]; then mkdir content fi
RUN if [ -d "./data/" ]; then mkdir data fi

# Run hugo in high performance web server mode
ENTRYPOINT [ "hugo", "server", "--bind=0.0.0.0", "--port=80"]