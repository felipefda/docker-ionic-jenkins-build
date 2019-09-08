FROM xmartlabs/android AS android
FROM ubuntu:18.04
ENV ANDROID_HOME /opt/android-sdk-linux
COPY --from=android ${ANDROID_HOME} ${ANDROID_HOME}
COPY --from=android /usr/lib/jvm/java-8-oracle /usr/lib/jvm/java-8-oracle
COPY --from=android /usr/bin/gradle /usr/bin/gradle
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools
USER root
RUN apt update && apt install -y wget gnupg2 openjdk-11-jre-headless
RUN wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | apt-key add -
RUN echo 'deb http://pkg.jenkins.io/debian-stable binary/' > /etc/apt/sources.list.d/jenkins.list
RUN wget -q -O - https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -
RUN echo "deb https://deb.nodesource.com/node_12.x bionic main" > /etc/apt/sources.list.d/nodesource.list
RUN echo "deb-src https://deb.nodesource.com/node_12.x bionic main" >> /etc/apt/sources.list.d/nodesource.list
RUN apt update && apt install -y jenkins nodejs git
RUN chown -R jenkins:jenkins ${ANDROID_HOME}
RUN npm install --global cordova ionic
ENTRYPOINT ["java", "-jar", "/usr/share/jenkins/jenkins.war"]
EXPOSE 8080