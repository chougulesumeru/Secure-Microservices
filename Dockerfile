# check=skip=FromAsCasing
# stage 1: build stage 
# use full node image to install dependencies 
FROM node:22-alpine AS builder 

# set working directory inside the container
WORKDIR /app

# copy package files first 
COPY package*.json ./

#install only production dependencies 
RUN npm ci --only=production


#stage 2: production stage 
FROM node:22-alpine AS builder 

#create a non-root user 
RUN addgroup -S appgroup && adduser -S appgroup 

# set working directory
WORKDIR /app

# copy only what you need from builder stage 
COPY --from=builder /app/node_modules ./node_modules
COPY --chown=appuser:appgroup app/src ./src
COPY --chown=appuser:appgroup package.json .

# switch to non-root user 
USER appuser 

#expose to the port the app listens on 
EXPOSE 3000

#start the app
CMD ["node", "src/index.js"]