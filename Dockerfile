FROM ubuntu:focal AS build

RUN apt-get update && apt-get install -y curl

RUN curl https://packages.microsoft.com/keys/microsoft.asc -o /etc/apt/trusted.gpg.d/microsoft.asc

RUN curl https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2022.list -o /etc/apt/sources.list.d/mssql-server.list

RUN apt-get update && apt-get install -y mssql-server-is libnuma-dev libatomic1

RUN cat <<'EOF' > /var/opt/ssis/ssis.conf
[LICENSE]
registered = Y
pid = developer
[EULA]
accepteula = Y
[TELEMETRY]
enabled = Y
[language]
lcid = 2052
EOF

RUN /opt/ssis/bin/ssis-conf -n setup

ENV PATH="$PATH:/opt/ssis/bin"

ENTRYPOINT ["/opt/ssis/bin/dtexec"]

CMD ["dt.dtsx"]



