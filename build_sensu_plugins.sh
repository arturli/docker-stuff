#!/bin/bash
# Usage:
#  ./build_sensu_plugins.sh [rpm_dir [plugin]]
#    rpm_dir    Directory to store RPMs in.
#               Default: ./
#    plugin     Plugin name to be built. Use all to build all plugins listed in ./sensu-plugins.list
#               Default: all
#
# Environment varialbes (e.g. when executed by Jenkins):
#  PLUGIN        Plugin name to be built. Use insted of invocation argument.
#  BUILD_NUMBER  Arbitrary number to be included in RPM release number.
#                If not set a timestamp will be used.
#

set -x

if [ -n "${1}" ]; then
  rpm_dir=$1
else
  rpm_dir=./
fi
if [ -n "${2}" ]; then
  plugin=$2
else
  plugin=${PLUGIN-all}
fi

src_dir="$( dirname "${BASH_SOURCE[0]}" )"
work_dir="./"
available_plugins="$(cat "${src_dir}/sensu-plugins.list")"
start_time=$(date '+%Y%m%d%H%M%S')
build_number=${BUILD_NUMBER-${start_time}}

export PATH=/opt/sensu/embedded/bin/:$PATH
embedded_ruby_version="$(/opt/sensu/embedded/bin/ruby -e 'puts RUBY_VERSION')"
fpm_options="--gem-package-name-prefix sensu_rubygem --iteration "${embedded_ruby_version}_${build_number}" \
  --exclude *opt/sensu/embedded/lib/ruby/gems/*/build_info \
  --exclude *opt/sensu/embedded/lib/ruby/gems/*/doc \
  --exclude *opt/sensu/embedded/lib/ruby/gems/*/extensions \
  --gem-disable-dependency docker-api \
  --gem-disable-dependency ffi \
  --gem-disable-dependency json \
  --gem-disable-dependency mixlib-cli \
  --gem-disable-dependency sensu-plugin \
  --no-gem-env-shebang"
gem_cache_dir=~/.gem/ruby/${embedded_ruby_version}/cache/

if [ "$plugin" == "all" ]; then
    plugins=$available_plugins
else
    plugins=$plugin
fi

for p in $plugins; do
    echo "[-] Building plugin: $p ..."
    /opt/sensu/embedded/bin/gem install --no-ri --no-rdoc --build-root "$work_dir" $p
done

pushd "${rpm_dir}"
find "$gem_cache_dir" -name '*.gem' | xargs -rn1 /opt/sensu/embedded/bin/fpm -s gem -t rpm ${fpm_options}
popd

echo "Generated RPMs of sensu plugins and dependencies:"
find "$rpm_dir" -name "*.rpm" | sort
