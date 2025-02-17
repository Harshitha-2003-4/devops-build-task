# Use an official Node.js runtime as a parent image
FROM node:14

WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Explicitly copy server.js
COPY server.js /app/

# Copy the rest of the application code
COPY . .

# Expose port 80
EXPOSE 80

# Command to run the application
CMD ["npm", "start"]
