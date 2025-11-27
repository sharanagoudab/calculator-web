# -------------------------------
# 1. Build Stage
# -------------------------------
FROM node:18-alpine AS build

WORKDIR /app

# Copy package files first
COPY package*.json ./

# Install dependencies (auto handles lockfile)
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi

# Copy source code
COPY . .

# -------------------------------
# 2. Production Stage
# -------------------------------
FROM node:18-alpine

WORKDIR /app

# Copy everything from build stage
COPY --from=build /app .

# Remove dev dependencies
RUN npm prune --production

# App Port (if needed)
EXPOSE 3000

# Start application
CMD ["node", "app.js"]
