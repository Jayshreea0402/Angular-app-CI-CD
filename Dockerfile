# syntax=docker/dockerfile:1

# STAGE 1: Build the Angular project
FROM node:12 AS builder 
#builder is just a name

# Install Angular CLI
RUN npm install -g @angular/cli@9.0.6
#installing cli so we dont need any dependancy 

# Change my working directory to a custom folder created for the project
WORKDIR /my-project

# Copy everything from the current folder (except the ones in .dockerignore) 
# into my working directory on the image
COPY . .

# Install dependencies and build my Angular project
RUN npm install && ng build --prod


# STAGE 2: Build the final deployable image
FROM nginx:1.21

# Allow the HTTP port needed by the Nginx server for connections
EXPOSE 80

# Copy the generated static files from the builder stage
# to the Nginx server's default folder on the image
COPY --from=builder /my-project/dist/my-angular-project /usr/share/nginx/html
#here, we are refencing builder as a first build stage  
#angular project creates the deployable files in the dist/* dir
#all static files which are build in the build stage will be deployed in the html folder 