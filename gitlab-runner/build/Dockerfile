ARG GITLAB_RUNNER_VERSION=latest
FROM gitlab/gitlab-runner:${GITLAB_RUNNER_VERSION}

ADD bin/init.sh /init
RUN chmod +x /init

VOLUME ["/etc/gitlab-runner", "/home/gitlab-runner"]

ENTRYPOINT ["/init"]
CMD ["run", "--user=gitlab-runner", "--working-directory=/home/gitlab-runner"]
