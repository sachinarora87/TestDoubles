FROM node:0.12.7-slim
MAINTAINER Rajesh Raheja "rajesh.raheja@ca.com"
LABEL Description="Docker container for the TestDoubles app. Includes CLI, REST APIs, Engine, NodeJS and Mountebank."

# Setup TestDoubles environment
ENV TD_USER td
ENV TD_HOME /opt/testdoubles
ENV PATH ${TD_HOME}/bin:$PATH
ENV TD_HOST http://localhost:5050
ENV TD_PORT 5050
ENV NODE_ENV production
# ENV TD_MIN_PORT 5051
# ENV TD_MAX_PORT 5055

# Install TestDoubles from source -- this requires the Dockerfile at the root of the project folder
COPY . ${TD_HOME}
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -r ${TD_USER} && \
    useradd -r -m -g ${TD_USER} ${TD_USER} && \
    chown -R ${TD_USER} ${TD_HOME} && \
    chgrp -R ${TD_USER} ${TD_HOME} && \
    chmod 777 ${TD_HOME}/testdoubles && \
    chmod 777 ${TD_HOME}/logs

# Start the processes
EXPOSE 2525 5050 5051 5052 5053 5054 5055
USER ${TD_USER}
WORKDIR ${TD_HOME}
RUN npm install --production && npm prune --production
CMD ["tdctl", "start"]
