# Use an official Node.js runtime as a base image
FROM node:14

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Copy the application code to the container
COPY . .

# Install dependencies
RUN npm install

# Build the React application
RUN npm run build

# Expose the port on which the app runs
EXPOSE 80

# Define the command to run your application
CMD ["npm", "start"]
