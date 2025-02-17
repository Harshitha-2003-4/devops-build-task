# Use an official Node.js runtime as a parent image
FROM node:14 AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React application
RUN npm run build

# Use a lightweight static server to serve the React app
FROM node:14-alpine

# Set the working directory
WORKDIR /app

# Install serve globally
RUN npm install -g serve

# Copy the built files from the build stage
COPY --from=build /app/build /app/build

# Expose port 80
EXPOSE 80

# Command to serve the React application
CMD ["serve", "-s", "build", "-l", "80"]