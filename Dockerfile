FROM registry.access.redhat.com/ubi9/ubi:9.4-1181
RUN echo "hello first build stage from ubi9" >/hello.txt

FROM registry.access.redhat.com/ubi8/nodejs-20@sha256:357b35e91e14580b9583498ffdd3b08eb1ede1b9676f7bf566f66fb14d7e3a92 

COPY --from=0 /hello.txt /hello-world.txt

# Create and change to the app directory.
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
# A wildcard is used to ensure both package.json AND package-lock.json are copied.
# Copying this separately prevents re-running npm install on every code change.
COPY package*.json ./

# Install production dependencies.
RUN npm install --only=production

# Copy local code to the container image.
COPY . . 

# Configure and document the service HTTP port.
ENV PORT 8080
EXPOSE $PORT

# Run the web service on container startup.
CMD [ "node", "app.js" ]

