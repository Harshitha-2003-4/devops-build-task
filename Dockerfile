# Use official Nginx base image
FROM nginx:latest

# Copy the build files from React into Nginx default path
COPY build/ /usr/share/nginx/html

# Expose default HTTP port
EXPOSE 80

# Run Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]

