# sensu_plugin_builder
#
# VERSION 0.3

FROM centos:7
LABEL maintainer "Artur Lisiecki <artur.lisiecki@gigaset.com>"
LABEL version="0.6"
ENV build_date 2017-01-24

ADD sensu.repo /etc/yum.repos.d/

RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install gcc gcc-c++ make rpmdevtools xz-devel postgresql-devel git
RUN yum -y install sensu-0.26.5-2.x86_64
RUN /opt/sensu/embedded/bin/gem install fpm
RUN chmod 777 /opt/sensu/embedded/lib/ruby/gems/2.3.0/extensions/x86_64-linux/2.3.0
RUN rm -rf /var/lib/yum; rm -rf /var/cache/yum; rm -rf /usr/share/doc; rm -rf /usr/share/locale
RUN PATH=/opt/sensu/embedded/bin/:$PATH
RUN useradd -ms /bin/bash sensu_plugin_builder
ADD build_sensu_plugins.sh README.md sensu-plugins.list /home/sensu_plugin_builder/
RUN mkdir /home/sensu_plugin_builder/rpm/
RUN chown -R sensu_plugin_builder.sensu_plugin_builder /home/sensu_plugin_builder

ADD Dockerfile /

USER sensu_plugin_builder
WORKDIR /home/sensu_plugin_builder
CMD /bin/bash

