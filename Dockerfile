ARG DOTNET_VERSION="latest"

FROM mcr.microsoft.com/dotnet/sdk:${DOTNET_VERSION}

LABEL maintainer="Andy Deng <andy.z.deng@gmail.com>"

COPY wait_to_run.sh /opt

RUN chmod 644 /opt/wait_to_run.sh && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        gnupg2 \
        iputils-ping \
        lsof \
        netcat \
        net-tools \
        openssh-client \
        psmisc \
        sudo \
        telnet \
        vim \
        unzip \
        tzdata \
        && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/11/prod.list | tee /etc/apt/sources.list.d/msprod.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y \
        mssql-tools \
        && \
    apt-get autoclean && \
    ln -s /opt/mssql-tools/bin/* /usr/local/bin/ && \
    useradd user -m -s /bin/bash && \
    mkdir -p /opt/workspace && \
    chown user:user /opt/workspace && \
    chmod u+w /etc/sudoers && \
    echo 'user    ALL=(ALL)    NOPASSWD:ALL' > /etc/sudoers && \
    chmod u-w /etc/sudoers

ENV PROJECT_PATH= \
    RUN_CMD= \
    INIT_FILE= \
    WAIT_SEC=0 \
    WAIT_HOST= \
    WAIT_PORT=

USER user

VOLUME [ "/home/user" ]

WORKDIR /opt/workspace

CMD sh /opt/wait_to_run.sh /opt/workspace/${PROJECT_PATH} ${WAIT_SEC} ${WAIT_HOST} ${WAIT_PORT}
