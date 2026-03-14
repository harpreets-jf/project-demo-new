FROM alpine:latest
RUN echo "Banking API v1.0" > /app_info.txt
CMD ["cat", "/app_info.txt"]
