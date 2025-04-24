FROM node:18-alpine

# Install pnpm
RUN npm install -g pnpm

WORKDIR /app

# Copy package.json and package-lock.json first to leverage Docker caching
COPY package*.json ./

# Install dependencies
RUN pnpm install

# Copy the rest of the code
COPY . .

# Build TypeScript code
RUN pnpm build

# Expose ports
EXPOSE 3000 1935 8001

# Start the server
CMD ["pnpm", "start"] 