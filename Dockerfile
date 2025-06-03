# Stage 1: Build the Go app
FROM golang:1.22 as builder

WORKDIR /app

# Copy go.mod and go.sum first to cache dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the source code into the container
COPY . .

# Force GOOS=linux and GOARCH=amd64 to produce a Linux-compatible binary
RUN GOOS=linux GOARCH=amd64 go build -o main ./cmd/main.go

# Stage 2: Run the application
FROM debian:bookworm-slim

WORKDIR /app

# Copy the built Go binary
COPY --from=builder /app/main .

# Copy views and css (used in templates and web)
COPY --from=builder /app/views ./views
COPY --from=builder /app/css ./css

# Expose the port the app listens on
EXPOSE 3030

# Set environment variable for database URI (optional here, mainly in compose)
ENV DATABASE_URI="mongodb://bookuser:bookpass@mongo:27017/exercise-2?authSource=exercise-2"

# Run the binary
ENTRYPOINT ["./main"]
