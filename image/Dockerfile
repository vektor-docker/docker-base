ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION} as BASE

COPY src/main/docker /

ENV PUID=911 \
    BASE_APTLIST="syslog-ng inotify-tools zip unzip wget less psmisc iproute2 runit locales" \
    LOG_LEVEL="INFO" \
    DEBIAN_FRONTEND="noninteractive"

RUN echo '*** Set permissions for the support tools' && \
    chmod --recursive +x /etc/my_init.d/*.sh /etc/service /usr/local/bin/* && \
    sync && \
    echo '*** Update all deb packages' && \
    apt update && \
    apt upgrade && \
    echo '*** Install additional softvare' && \
    apt -o Dpkg::Options::="--force-confdef" install --yes ${BASE_APTLIST} && \
#    apt -o Dpkg::Options::="--force-confnew" install --yes ${BASE_APTLIST} && \
    echo '*** Add user "system"' && \
    useradd -u ${PUID} -U -d /config -s /bin/false system && \
    usermod -G users system && \
    echo '*** Prepare application rirectories' && \
    mkdir -p /app /config /defaults && \
    echo '*** Install init process.' && \
    mkdir -p /etc/my_init.d && \
    mkdir -p /etc/container_environment && \
    touch /etc/container_environment.sh && \
    touch /etc/container_environment.json && \
    chmod 700 /etc/container_environment /etc/container_environment.sh /etc/container_environment.json && \
    ln -s /etc/container_environment.sh /etc/profile.d/ && \
    rm -f /tmp/* && \
    echo '*** Configure a syslog daemon and logrotate.' && \
    touch /var/log/syslog && \
    mknod -m 640 /dev/xconsole p && \
    chmod u=rw,g=r,o= /var/log/syslog && \
    echo '*** Configure locale.' && \
    sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen && \
    echo '*** Configure cron daemon.' && \
    chmod 600 /etc/crontab && \
    sed -i 's/^\s*session\s\+required\s\+pam_loginuid.so/# &/' /etc/pam.d/cron && \
    chown system:system /app /config /defaults && \
    echo '*** Clean up system' && \
    rm -rf /var/log/anaconda && \
    echo '*** Clean up yum caches' && \
    apt-clean

FROM scratch
MAINTAINER Viktor Verbitsky <vektory79@gmail.com>

LABEL \
    os.vendor="Ubuntu" \
    os.version="${UBUNTU_VERSION}" \
    os.license="GPLv2" \
    image.vendor="vektory79"

COPY --from=BASE / /

ENV PUID=911 \
    PGID=911 \
    PUSER=system \
    TERM="xterm" \
    LANG="ru_RU.UTF-8" \
    TZ="Europe/Moscow" \
    KILL_PROCESS_TIMEOUT=5 \
    KILL_ALL_PROCESSES_TIMEOUT=5 \
    APTLIST="" \
    BUILD_RPMLIST="" \
    BASE_APTLIST="syslog-ng inotify-tools zip unzip wget less psmisc iproute2 runit locales" \
    LOG_LEVEL="INFO"

CMD ["/usr/local/bin/my_init"]
