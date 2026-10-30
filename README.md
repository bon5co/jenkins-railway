# jenkins-railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/deploy/jenkins-or-just-updated-cicd-server-gene?referralCode=Z1xivh&utm_medium=integration&utm_source=template&utm_campaign=generic)

**Deploy on Railway:** [Jenkins template](https://railway.com/deploy/jenkins-or-just-updated-cicd-server-gene?referralCode=Z1xivh&utm_medium=integration&utm_source=template&utm_campaign=generic)

Wrapper image for the Railway Jenkins template. It is the official `jenkins/jenkins:lts-jdk21`
image (pinned by digest) with:

- a plugin set baked in (Pipeline, Git, GitHub, Credentials, Configuration as Code, and friends),
- the setup wizard off and the admin user created by Configuration as Code from
  `JENKINS_ADMIN_PASSWORD` (anonymous read disabled, signup off),
- an API token installed for `admin` from `JENKINS_API_TOKEN` (`11` plus 32 lowercase hex characters),
- an entrypoint that chowns the root-owned Railway volume and drops to uid 1000.

Variables: `JENKINS_ADMIN_PASSWORD` (required, the entrypoint refuses to start without it),
`JENKINS_API_TOKEN` (optional), `RAILWAY_PUBLIC_DOMAIN` (sets the Jenkins URL).
