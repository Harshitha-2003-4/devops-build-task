# Use the official Nginx image as the base image
FROM nginx:latest

# Copy your application files to the Nginx HTML directory
COPY  build/ /usr/share/nginx/html

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start Nginx when the container runs
CMD ["nginx", "-g", "daemon off;"]