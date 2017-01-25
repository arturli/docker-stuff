FROM centos:7
MAINTAINER Artur <arturli@users.noreply.github.com>
ENV build_date 2016-05-16

ADD sensu.repo /etc/yum.repos.d/
ADD RHN-ORG-TRUSTED-SSL-CERT /usr/share/rhn/
ADD after_install.sh /tmp/

RUN yum -y install sensu gcc gcc-c++ make rpmdevtools xz-devel postgresql-devel rhnpush rpm-sign expect
RUN chmod 666 /var/log/up2date
RUN /opt/sensu/embedded/bin/gem install fpm
RUN rm -rf /var/lib/yum; rm -rf /var/cache/yum; rm -rf /usr/share/doc
RUN PATH=/opt/sensu/embedded/bin/:$PATH

CMD /bin/bash
