# Base image
FROM node:14 as build-stage

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build the application
RUN npm run build

# Create a new image with only production dependencies
FROM node:14-alpine as production-stage
WORKDIR /app
COPY --from=build-stage /app/package*.json ./
RUN npm install --only=production

# Copy the built files from the build-stage
COPY --from=build-stage /app/dist ./dist

# Expose the application port
EXPOSE 3000

# Start the application
CMD ["npm", "run", "start"]
