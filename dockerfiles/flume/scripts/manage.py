#!/usr/bin/env python
#
#   delpoy and run Flume agent
#
#

import os
import sys
import string
import tarfile
import subprocess


from pprint import pprint
from shutil import copyfile

FLUME_REQUIRED_FILES = ['conf/flume.properties', 'meta/component.json']


class FlumePackage(object):

    def __init__(self, package_path, deploy_path):

        if not os.path.exists(package_path):
            raise RuntimeError('[ERROR] Package does not exist')
        self._package_path = package_path


        if not os.path.exists(deploy_path):
            raise RuntimeError('[ERROR] The path for deployment does not exist')
        self._deploy_path = deploy_path


        if not tarfile.is_tarfile(package_path):
            raise RuntimeError('[ERROR] Package format is unknown. Only tar files are supported')

        self._agent = None
        self._temp_dir = None


    def validated(self):

        with tarfile.open(self._package_path, 'r:bz2') as _package:
            for path in _package.getnames():
                
                parts = path.split(os.sep)
                _name = parts[0]
                _file = os.path.join(*parts[1:])

                if _name not in self._agents:
                    self._agents[_name] = [_file, ]
                else:
                    self._agents[_name].append(_file)

        for _name in self._agents:
            if len(set(self._agents[_name]).intersection(set(FLUME_REQUIRED_FILES))) != len(FLUME_REQUIRED_FILES):
                raise RuntimeError('[ERROR] Required files are missed into the package: %s' % _name)

        if not self._agents:
            raise RuntimeError('[ERROR] No Flume agents found')

        return True

    def extract(self, path='/data/tmp/'):

        if not os.path.exists(path):
            raise RuntimeError('[ERROR] The path does not exist, %s' % path)
        self._temp_dir = path            

        with tarfile.open(self._package_path, 'r:bz2') as package:
            package.extractall(path)

            agent_names = set([n.split(os.sep)[0] for n in package.getnames()])
            if len(agent_names) != 1:
                print >> sys.stderr, \
                    '[WARNING] Only one Flume agent can be extracted: %s, founded: %d' % (agent_names[0], len(agent_names))
            self._agent = list(agent_names)[0]


    def deploy(self):

        print '[INFO] Copying files ...'
        for root, dirs, files in os.walk(os.path.join(self._temp_dir, self._agent)):
            
            if not files:
                continue

            path, _dir = os.path.split(root)
            for _file in files:
                source = os.path.join(root, _file)
                target = os.path.join(*[self._deploy_path, _dir, _file])
                print '[INFO]', source, '->', target

                if _dir == 'meta' and _file == 'component.json':
                    copyfile(source, target)
                elif _dir == 'conf' and _file == 'flume.properties':
                    copyfile(source, target)
                elif _dir == 'lib':
                    copyfile(source, target)
        print '[INFO] Copying was completed'


    def get_classpath(self):

        libs_path = os.path.join(self._deploy_path, 'lib')
        return ':'.join([os.path.join(libs_path, i) for i in os.listdir(libs_path)])


    def run(self, agent_name):

        print '[INFO] Starting Flume agent [%s] ...' % self._agent
        command = [
            'flume-ng', 'agent', 
                '-n', agent_name,
                '-f', os.path.join(self._deploy_path, 'conf', 'flume.properties'),
                '-c', '/data/conf/',
                '-C', '/data/lib/*:/data/conf/*',
                '-Dflume.root.logger=DEBUG,console',
        ]
        try:
            subprocess.call(command)
        except KeyboardInterrupt:
            print 'Interrupted by user'
        print '[INFO] Completed'


class Template(string.Template):

    pattern = r'''
        (?:
        (?P<escaped>\$) |                     # Escape sequence of two delimiters
        (?P<named>[_a-z][_a-z0-9\.\-]*) |       # delimiter and a Python identifier
        {{(?P<braced>[_a-z][_a-z0-9\.\-]*)}} |    # delimiter and a braced identifier
        (?P<invalid>)                         # Other ill-formed delimiter exprs
        )
        '''


class FlumeConfig(object):

    def __init__(self, path):

        if not os.path.exists(path):
            raise RuntimeError('[ERROR] The flume config file does not exist, %s' % path)

        self._path = path
        self._config = dict()
        self._params = dict()


    def parse(self):

        def append_path(root, value, paths):
            if paths:
                child = root.setdefault(paths[0], {})
                append_path(child, value, paths[1:])
            else:
                root['_v'] = value

        with open(self._path, 'r') as config:
            for line in config:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue
                try:
                    k,v = [i.strip() for i in line.split('=',1)]
                    append_path(self._config, v, k.split('.'))

                except ValueError:
                    print '[ERROR] Incorrect parameter, line: %s' % line
                    break


    def agent_names(self):

        return self._config.keys()


    def load_params(self, path):

        if not os.path.exists(path):
            raise RuntimeError('[ERROR] The path to parameters does not exist, %s' % path)

        params = dict()
        with open(path, 'r') as _file:
            for line in _file:
                line = line.strip()
                if not line or line.startswith('#'):
                    continue
                k,v = [i.strip() for i in line.split('=',1)]
                params[k] = v

        return params


    def update(self, params):

        template = Template(open(self._path).read())
        with open(self._path, 'w') as _file:
            _file.write(template.safe_substitute(params))

        self.parse()


if __name__ == '__main__':

    import optparse

    parser = optparse.OptionParser()
    parser.add_option('-p', '--package', help="Flume agent package, .tar.bz2")
    parser.add_option('-s', '--settings', help="Flume settings file")
    parser.add_option('-d', '--deploy-dir', default='/data/', help="The directory for deployment Flume agent")
    parser.add_option('-t', '--temp-dir', default='/data/tmp/', help="The directory for temporary files")
    (opts, args) = parser.parse_args()

    if not opts.package:
        print >> sys.stderr, '[ERROR] Flume package does not specified'
        sys.exit(1)

    pack = FlumePackage(opts.package, deploy_path=opts.deploy_dir)
    pack.extract(opts.temp_dir)
    pack.deploy()

    config = FlumeConfig(path='/data/conf/flume.properties')
    config.update(config.load_params(opts.settings))

    # config.parse()
    # pprint(config._config)

    pack.run(agent_name=config.agent_names()[0])

