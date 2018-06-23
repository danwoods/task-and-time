# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Run updates
RUN apt-get update

# Install Timewarrior
RUN sudo apt-get install timewarrior

#RUN apt-get install -y nodejs
#RUN apt-get install -y npm
#RUN ln -s /usr/bin/nodejs /usr/bin/node

# Install any needed packages specified in requirements.txt
#RUN npm i && npm run build && npm i -g http-server

# Healthcheck
HEALTHCHECK --start-period=600s CMD curl --fail http://localhost:3000/ || exit 1

# Make port 80 available to the world outside this container
#EXPOSE 80

# Define environment variable
# ENV NAME World

# Run app.py when the container launches
#CMD ["http-server", "-p 8080"]
