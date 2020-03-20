FROM registry.access.redhat.com/ubi8/ubi

ENV GOGS_VERSION 0.11.91
ENV GOGS_USER gogs
ENV GOGS_PORT 3000
ENV GOGS_BASEDIR /opt
ENV GOGS_WORKDIR ${GOGS_BASEDIR}/gogs
ENV GOGS_DATADIR ${GOGS_WORKDIR}/data
ENV GOGS_HOMEDIR /home/${GOGS_USER}

ADD helpers ${GOGS_WORKDIR}/helpers

RUN yum -y install git nss_wrapper gettext && \
    yum -y clean all && \
    cd ${GOGS_BASEDIR} && \
    curl -L https://dl.gogs.io/${GOGS_VERSION}/gogs_${GOGS_VERSION}_linux_amd64.tar.gz | tar -xz && \
    useradd -m -u 1000 -g 0 ${GOGS_USER} && \
    mkdir ${GOGS_DATADIR} && \
    chgrp -R 0 ${GOGS_HOMEDIR} ${GOGS_WORKDIR} ${GOGS_DATADIR} && \
    chmod -R g+rwX ${GOGS_HOMEDIR} ${GOGS_WORKDIR} ${GOGS_DATADIR} && \
    cd ${GOGS_WORKDIR}

EXPOSE ${GOGS_PORT}

USER ${GOGS_USER}
WORKDIR ${GOGS_WORKDIR}

CMD ["sh", "-c", "${GOGS_WORKDIR}/helpers/run-gogs.sh"]
