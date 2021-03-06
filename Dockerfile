# Use an official Ubuntu as a parent image
FROM ubuntu:16.04

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Run updates
RUN apt-get update

# Install curl
RUN apt-get install -y curl cmake g++ libgnutls-dev uuid-dev

# Install Taskwarrior
RUN apt-get install -y taskwarrior

# Install Timewarrior
#RUN apt-get install -y timewarrior

# Install Timewarrior sync server
RUN curl -LO https://taskwarrior.org/download/taskd-1.1.0.tar.gz
RUN tar xzf taskd-1.1.0.tar.gz
RUN cd taskd-1.1.0 && ls && cmake -DCMAKE_BUILD_TYPE=release . &&  ls && make && make install

# Setup Timewarrior sync server
## Setup location to store data
ENV TASKDDATA=/var/taskd
RUN export TASKDDATA=/var/taskd && mkdir -p $TASKDDATA && taskd init
RUN echo "client.cert=/etc/taskd/pki/client.cert.pem" >> /var/taskd/config && \
echo "client.key=/etc/taskd/pki/client.key.pem" >> /var/taskd/config && \
echo "server.cert=/etc/taskd/pki/server.cert.pem" >> /var/taskd/config && \
echo "server.key=/etc/taskd/pki/server.key.pem" >> /var/taskd/config && \
echo "server.crl=/etc/taskd/pki/server.crl.pem" >> /var/taskd/config && \
echo "ca.cert=/etc/taskd/pki/ca.cert.pem" >> /var/taskd/config

# Setup Organization
Run taskd add org Woodson

# Add me as user
RUN taskd add user 'Woodson' 'Dan Woodson'

# Create certs
RUN cd taskd-1.1.0/pki && cat vars && ./generate.client me

# Keep container running
CMD ["tail", "-f /dev/null"]

#RUN apt-get install -y nodejs
#RUN apt-get install -y npm
#RUN ln -s /usr/bin/nodejs /usr/bin/node

# Install any needed packages specified in requirements.txt
#RUN npm i && npm run build && npm i -g http-server

# Healthcheck
#HEALTHCHECK --start-period=600s CMD curl --fail http://localhost:3000/ || exit 1

# Make port 80 available to the world outside this container
#EXPOSE 80

# Define environment variable
# ENV NAME World

# Run app.py when the container launches
#CMD ["http-server", "-p 8080"]
