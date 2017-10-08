#
# This image is modified version of sequenceiq/hadoop-docker
#   * sequenceiq/hadoop-docker <https://github.com/sequenceiq/hadoop-docker>
#
# The modifications are
#   * Use local hadoop package
#   * Change template files to indicate docker master node
#   * Modify bootstrap script
#
# Author: Kai Sasaki
# Date:   2015 Sep,13
#
# Creates multi node hadoop cluster on Docker

FROM lewuathe/hadoop-base:latest
MAINTAINER lewuathe

COPY bootstrap.sh /etc/
RUN chown root:root /etc/bootstrap.sh && \
	chmod 700 /etc/bootstrap.sh

CMD /etc/bootstrap.sh -d
