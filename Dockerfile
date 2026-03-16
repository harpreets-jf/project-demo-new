# STAGE 1: Build Stage (Vulnerable Base Image)
# We intentionally use an older, well-known image (Nginx 1.19, released in 2020)
# This image is guaranteed to contain multiple High and Medium vulnerabilities.
FROM nginx:1.19 as builder

# Create a dummy "optimized configuration file" in this stage
RUN echo "Banking API v1.0 - High Performance Config" > /opt/optimized_app.conf

# ------------------------------------------------------------------

# STAGE 2: Production Stage (Clean Base Image)
# This is the final image that gets pushed to Artifactory. We use the latest,
# minimal Alpine image to keep it lean.
FROM alpine:3.23.0

# Copy the artifact generated in the vulnerable stage.
# This is the key: even though this final image is 'clean', Xray will trace
# that this file originated from the vulnerable Nginx stage.
COPY --from=builder /opt/optimized_app.conf /app/optimized_app.conf

# Existing command
RUN echo "Banking API v1.0" > /app_info.txt

# New command to verify the copied file exists
CMD ["cat", "/app/optimized_app.conf", "/app_info.txt"]
