# sensu_plugin_builder

RPM building container - current tag: ttarczynski/sensu_plugin_builder:0.6

Project: https://github.com/ttarczynski/sensu_plugin_builder

Docker image: https://hub.docker.com/r/ttarczynski/sensu_plugin_builder/

## Contents
- `sensu-plugins.list` - list of sensu plugins from which RPM packages will be built.
- `build_sensu_plugins.sh` - shell script for building sensu plugins

## Usage

The `build_sensu_plugins.sh` should be used inside a `sensu_plugin_builder` container:

```
# mkdir rpm
# chmod 777 rpm
# docker run -v $(pwd)/rpm/:/rpm/  ttarczynski/sensu_plugin_builder ./build_sensu_plugins.sh /rpm/ sensu-plugins-entropy-checks
```

After running this command you should find plugin RPMs in `./rpm/` directory.

## build_sensu_plugins.sh refference
```
./build_sensu_plugins.sh [rpm_dir [plugin]]
  rpm_dir    Directory to store RPMs in.
             Default: ./
  plugin     Plugin name to be built. Use all to build all plugins listed in ./sensu-plugins.list
             Default: all

Environment varialbes (e.g. when executed by Jenkins):
  PLUGIN        Plugin name to be built. Use insted of invocation argument.
  BUILD_NUMBER  Arbitrary number to be included in RPM release number.
                If not set a timestamp will be used.
```
