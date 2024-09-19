# Use the official Nginx image with Perl support based on Alpine 3.20
FROM nginx:stable-alpine3.20-perl

# Copy your Nginx configuration file
# Ensure you have a custom nginx.conf file in the same directory as your Dockerfile
COPY nginx.conf /etc/nginx/nginx.conf

COPY index.html /usr/share/nginx/html/
COPY images /usr/share/nginx/html/images
# Copy any static files or application files if needed
# Example: Copy HTML files to the Nginx html directory
# COPY html/ /usr/share/nginx/html/

# Expose port 80 for the web server
EXPOSE 80

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]

