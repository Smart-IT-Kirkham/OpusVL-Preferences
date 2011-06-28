use inc::Module::Install;

name     'OpusVL-Preferences';
all_from 'lib/OpusVL/Preferences.pm';
author   q{Rich Doughty <rich@opusvl.com>};
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

