# builder ####################################################################
ARG DEBIAN_VERSION=12

FROM debian:$DEBIAN_VERSION-slim as builder

ARG DEBIAN_CODENAME=bookworm

MAINTAINER Jonathan Dowland <jmtd@debian.org>
ENV LANG C.UTF-8

RUN echo deb-src [ signed-by=/usr/share/keyrings/debian-archive-keyring.gpg ] http://deb.debian.org/debian/ $DEBIAN_CODENAME main \
    | tee /etc/apt/sources.list.d/src.list

RUN apt-get update \
    && apt-get build-dep -y ikiwiki \
    && apt-get clean \
    && find /var/lib/apt/lists -type f -delete

WORKDIR /usr/src

# obtain the git source
RUN git clone https://github.com/jmtd/ikiwiki.git \
    && cd ikiwiki \
    && git checkout opinionated

# build and install ikiwiki
WORKDIR /usr/src/ikiwiki
RUN perl Makefile.PL \
    && make
RUN make pure_install

# Runner ####################################################################
FROM debian:$DEBIAN_VERSION-slim

MAINTAINER Jonathan Dowland <jmtd@debian.org>
ENV LANG C.UTF-8

# deps from Bundle::IkiWiki
# Date::Parse -> libtimedate-perl
# Data::Dumper - in perl package
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        git lighttpd \
        apache2-utils \
        gettext \
        tcc \
        libc6-dev \
        libtext-markdown-discount-perl \
        libhtml-scrubber-perl \
        libhtml-template-perl \
        libhtml-parser-perl \
        liburi-perl \
        libxml-simple-perl \
        libtimedate-perl \
        libcgi-formbuilder-perl \
        libcgi-session-perl \
        libmail-sendmail-perl \
        libcgi-pm-perl \
        libyaml-libyaml-perl \
        libjson-perl \
        librpc-xml-perl \
        graphviz \
        libimage-magick-perl \
        libtext-csv-perl \
        liblwpx-paranoidagent-perl \
        pwgen \
    && apt-get clean \
    && find /var/lib/apt/lists -type f -delete

COPY --from=builder /usr/local /usr/local

RUN adduser --gecos "ikiwiki user" --disabled-password ikiwiki
WORKDIR /home/ikiwiki
ENV USER ikiwiki

ADD \
    auto.setup \
    httpauth.conf \
    launch.sh \
    setup.sh \
    pre-receive \
    post-update \
    /home/ikiwiki/
RUN chown ikiwiki \
    auto.setup \
    httpauth.conf \
    launch.sh \
    setup.sh \
    pre-receive \
    post-update \
    /home/ikiwiki/

ADD ikiwiki.conf \
    git.conf \
    /etc/lighttpd/conf-enabled/

RUN chmod 777 /var/run \
    /var/cache/lighttpd/compress \
    /var/cache/lighttpd/uploads

RUN sed -i \
    -e 's/^server.port.*$/server.port = 8080/' \
    -e 's#^server.errorlog.*$#server.errorlog = "/dev/stderr"#' \
    -e 's#^server.document-root.*$#server.document-root = "/home/ikiwiki/public_html"#' \
    /etc/lighttpd/lighttpd.conf

# workaround for https://ikiwiki.info/bugs/inactive_python_plugins_cause_error_output_when_python_interpreter_is_missing/
RUN rm /usr/local/lib/ikiwiki/plugins/rst \
       /usr/local/lib/ikiwiki/plugins/proxy.py

USER ikiwiki
EXPOSE 8080
RUN /home/ikiwiki/setup.sh

CMD ["/home/ikiwiki/launch.sh"]
