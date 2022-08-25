# Updated as of Aug 16, 2017
# Install FROM UBUNTU IMAGE
FROM ubuntu:20.04

#Author of the Docker File
# MAINTAINER Pictolearn Note: MAINTAINER has been deprecated for LABEL,
# LABEL is a key value pair
LABEL "Maintainer"="Pictolearn"

# RUN COMMAND BASICALLY runs the command in the terminal and creates an image.
# Install all the updates for UBUNTU
# RUN apt-get update && apt-get install -y python-software-properties software-properties-common

# Install all the updates for UBUNTU
# RUN apt-get install -y iputils-ping

# Adds the repository where JDK 8 can be obtained for UBUNTU
# RUN add-apt-repository ppa:webupd8team/java #add-apt-repository ppa:openjdk-r/ppa

# Install Java 8


# RUN apt-get update && \
#    apt-get --yes --no-install-recommends install oracle-java8-installer

#RUN apt-get update && apt-get install -y \
#    software-properties-common
# Add the "JAVA" ppa
# RUN add-apt-repository -y \
#    ppa:webupd11team/java

# Install OpenJDK-8
# RUN apt-get update && \
#    apt-get install -y openjdk-8-jdk && \
#    apt-get install -y ant && \
#    apt-get clean;
#
## Fix certificate issues
#RUN apt-get update && \
#    apt-get install ca-certificates-java && \
#    apt-get clean && \
#    update-ca-certificates -f \
#    rm -rf /var/lib/apt/lists/* && \
#    rm -rf /var/cache/oracle-jdk8-installer
#
## Setup JAVA_HOME -- useful for docker commandline
#ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
#run apt install  -y default-jre \
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata curl ca-certificates fontconfig locales \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_VERSION jdk-11.0.11+9

RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
       aarch64|arm64) \
         ESUM='4966b0df9406b7041e14316e04c9579806832fafa02c5d3bd1842163b7f2353a'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.11%2B9/OpenJDK11U-jdk_aarch64_linux_hotspot_11.0.11_9.tar.gz'; \
         ;; \
       armhf|armv7l) \
         ESUM='2d7aba0b9ea287145ad437d4b3035fc84f7508e78c6fec99be4ff59fe1b6fc0d'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.11%2B9/OpenJDK11U-jdk_arm_linux_hotspot_11.0.11_9.tar.gz'; \
         ;; \
       ppc64el|ppc64le) \
         ESUM='945b114bd0a617d742653ac1ae89d35384bf89389046a44681109cf8e4f4af91'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.11%2B9/OpenJDK11U-jdk_ppc64le_linux_hotspot_11.0.11_9.tar.gz'; \
         ;; \
       s390x) \
         ESUM='5d81979d27d9d8b3ed5bca1a91fc899cbbfb3d907f445ee7329628105e92f52c'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.11%2B9/OpenJDK11U-jdk_s390x_linux_hotspot_11.0.11_9.tar.gz'; \
         ;; \
       amd64|x86_64) \
         ESUM='e99b98f851541202ab64401594901e583b764e368814320eba442095251e78cb'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.11%2B9/OpenJDK11U-jdk_x64_linux_hotspot_11.0.11_9.tar.gz'; \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
    curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
    echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz;

ENV JAVA_HOME=/opt/java/openjdk \
    PATH="/opt/java/openjdk/bin:$PATH"



# RUN #apt-get install --reinstall ca-certificates
# INSTALL THE VI EDITOR AND MYSQL-CLIENT
#RUN apt-get install -y vim
# RUN apt-get install -y mysql-client

# NOTE and WARNING: ORACLE JDK is no longer licensed. Please install default jdk or OPEN JDK.
# The initial set up was to get this working with JDK 7 but when the licensing terms for oracle changing we will install the default JDK
# INSTALL ORACLE JDK 8 BY ACCEPTING YES
# RUN echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections
#INSTALL ALL the updates again and install MAVEN and JDK 8
 # RUN apt-get update && apt-get install -y oracle-java8-installer maven
RUN apt-get update && apt-get install -y  maven


# ADD a directory called docker-git-hello-world inside the UBUNTU IMAGE where you will be moving all of these files under this
# DIRECTORY to
ADD . /usr/local/docker-git-hello-world

COPY . /usr/local/docker-git-hello-world

RUN cd /usr/local/docker-git-hello-world && dir -s

# AFTER YOU HAVE MOVED ALL THE FILES GO AHEAD CD into the directory and run mvn assembly.
# Maven assembly will package the project into a JAR FILE which can be executed
RUN cd /usr/local/docker-git-hello-world && mvn package

#THE CMD COMMAND tells docker the command to run when the container is started up from the image. In this case we are
# executing the java program as is to print Hello World.
CMD ["java", "-cp", "/usr/local/docker-git-hello-world/target/HelloWorldDocker-1.0-SNAPSHOT.jar", "com.iamatum.hello.HelloWorldPing"]