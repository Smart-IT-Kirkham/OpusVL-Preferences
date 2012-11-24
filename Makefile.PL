use inc::Module::Install;

name     'OpusVL-Preferences';
all_from 'lib/OpusVL/Preferences.pm';
author   q{Rich Doughty <rich@opusvl.com>};
license  'perl';

build_requires 'Test::More';

auto_install;
resources (
    repository => {
        url => 'ssh://git.rug-01.opusvl.net/srv/git/OpusVL-Preferences',
        type => 'git',
    },
);


WriteAll;

