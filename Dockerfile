FROM jenkins/jenkins:lts-jdk21@sha256:74401de6a6f92e1afe1b02d1c8e3d0c33f263bfb5275dd8813f9150355f2367b

USER jenkins
# Plugins land in /usr/share/jenkins/ref/plugins; jenkins.sh copies them into the
# volume on first boot, so the volume mount does not hide them.
RUN jenkins-plugin-cli --plugins \
    configuration-as-code \
    workflow-aggregator \
    git \
    github \
    github-branch-source \
    credentials-binding \
    ssh-credentials \
    plain-credentials \
    ws-cleanup \
    timestamper \
    build-timeout \
    antisamy-markup-formatter \
    pipeline-stage-view \
    ssh-slaves \
    matrix-auth

COPY --chown=jenkins:jenkins casc/jenkins.yaml /usr/share/jenkins/casc/jenkins.yaml
COPY --chown=jenkins:jenkins init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

USER root
COPY railway-entrypoint.sh /usr/local/bin/railway-entrypoint.sh
RUN chmod 0755 /usr/local/bin/railway-entrypoint.sh

ENV CASC_JENKINS_CONFIG=/usr/share/jenkins/casc \
    JAVA_OPTS="-Djenkins.install.runSetupWizard=false -Dhudson.model.UsageStatistics.disabled=true -XX:MaxRAMPercentage=60 -XX:ActiveProcessorCount=2"

EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/railway-entrypoint.sh"]
