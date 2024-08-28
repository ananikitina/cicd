# Use a multi-stage build to keep the final image lightweight
FROM golang:1.22.1-alpine AS builder

# Create a working directory
WORKDIR /app

# Copy dependency files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN go build -o my_app .

# Final image
FROM alpine:latest

# Create a working directory
WORKDIR /app

# Copy the compiled binary from the builder stage
COPY --from=builder /app/my_app .

# Copy the database file 
COPY tracker.db ./

# Open the port for the application
EXPOSE 8080

# Run the application
CMD ["./my_app"]
