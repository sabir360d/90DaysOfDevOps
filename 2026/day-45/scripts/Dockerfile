# Use official Nginx image
FROM nginx:alpine

# Remove default Nginx page
RUN rm /usr/share/nginx/html/*

# Copy your static HTML
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
