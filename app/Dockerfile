# ─── Stage 1: Build Stage ───────────────────────────────────────────
# Use a full Node image just to install dependencies
FROM node:18-alpine AS builder

# Set working directory inside the container
WORKDIR /app

# Copy package files first (Docker layer caching optimization)
# If package.json didn't change, Docker reuses the cached npm install layer
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production

# ─── Stage 2: Production Stage ──────────────────────────────────────
# Use a minimal image — less surface area = more secure
FROM node:18-alpine AS production

# Security: Don't run as root
# Create a non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

# Copy only what we need from builder stage (not the full build environment)
COPY --from=builder /app/node_modules ./node_modules
COPY --chown=appuser:appgroup app/src ./src
COPY --chown=appuser:appgroup package.json .

# Switch to non-root user
USER appuser

# Expose the port the app listens on
EXPOSE 3000

# Healthcheck — Kubernetes and Docker can use this
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD wget -qO- http://localhost:3000/health || exit 1

# Start the app
CMD ["node", "src/index.js"]