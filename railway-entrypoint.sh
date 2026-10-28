#!/bin/bash
# Railway mounts the volume root-owned and runs this as root (RAILWAY_RUN_UID=0).
# Chown the mount, then drop to the jenkins user and hand over to the stock entrypoint.
set -e
H="${JENKINS_HOME:-/var/jenkins_home}"
JUID=1000

if [ -z "${JENKINS_ADMIN_PASSWORD:-}" ]; then
  echo "railway-entrypoint: JENKINS_ADMIN_PASSWORD is not set; refusing to start an open Jenkins" >&2
  exit 1
fi

mkdir -p "$H"
if [ "$(stat -c %u "$H")" != "$JUID" ]; then
  chown -R "$JUID:$JUID" "$H"
fi
echo "railway-entrypoint: jenkins home $H owner=$(stat -c %u:%g "$H") writable_as_jenkins=$(setpriv --reuid=$JUID --regid=$JUID --clear-groups test -w "$H" && echo yes || echo no)"

export JENKINS_URL="https://${RAILWAY_PUBLIC_DOMAIN:-localhost}/"
export HOME="$H"
exec setpriv --reuid=$JUID --regid=$JUID --clear-groups /usr/bin/tini -- /usr/local/bin/jenkins.sh
