FROM node:20-slim AS builder
WORKDIR /app
COPY package*.json ./
RUN npm pkg delete type && npm install --omit=dev

FROM node:20-slim
WORKDIR /app
RUN addgroup --system appgroup && adduser --system --ingroup appgroup --no-create-home appuser
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json
COPY app.js views/ ./
RUN chown -R appuser:appgroup /app
USER appuser
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (r) => process.exit(r.statusCode === 200 ? 0 : 1))" || exit 1
EXPOSE 3000
CMD ["node", "app.js"]
