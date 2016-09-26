AVAILABLE_PLUGINS="""
sensu-plugins-ntp
sensu-plugins-process-checks
sensu-plugins-elasticsearch
sensu-plugins-postgres
sensu-plugins-redis
sensu-plugins-rabbitmq
sensu-plugins-haproxy
sensu-plugins-nginx
sensu-plugins-docker
sensu-plugins-entropy-checks
sensu-plugins-dns
sensu-plugins-postfix"""


export PATH=/opt/sensu/embedded/bin/:$PATH
ps aux

mkdir rpms_of__sensu-plugins

if [ "$plugin" == "all" ]; then
    PLUGINS=$AVAILABLE_PLUGINS
else
    PLUGINS=$plugin
fi

for plugin in $PLUGINS; do
    echo "[-] Building $plugin ..."
    /opt/sensu/embedded/bin/gem install --no-ri --no-rdoc --install-dir . $plugin

    # searching for gems
    plugin_match=`find ./cache/ -name "$plugin*.gem"`
    # generating RPM packages
    echo "$plugin_match" | xargs -rn1  /opt/sensu/embedded/bin/fpm -s gem -t rpm --gem-package-name-prefix sensu_rubygem --iteration $EMBEDDED_RUBY_VERSION --after-install=/tmp/after_install.sh
    # removing matched gems
    echo "$plugin_match" | xargs -rn 1 rm
    mv *.rpm rpms_of__sensu-plugins/
    
    
done
# generating the rest of RPM packages
find ./cache -name '*.gem' | xargs -rn1 /opt/sensu/embedded/bin/fpm -s gem -t rpm --gem-package-name-prefix sensu_rubygem --iteration $EMBEDDED_RUBY_VERSION

# listing generated plugins
find /home -iname "*.rpm"
