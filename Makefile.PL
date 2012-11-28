use inc::Module::Install;

name     'OpusVL-Preferences';
all_from 'lib/OpusVL/Preferences.pm';

requires 'DBIx::Class';

build_requires 'Test::More';

resources (
    repository => {
        url => 'ssh://git/srv/git/OpusVL-Preferences',
        type => 'git',
    },
);


auto_install;

WriteAll;

