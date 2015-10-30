use inc::Module::Install;

name     'OpusVL-Preferences';
all_from 'lib/OpusVL/Preferences.pm';

requires 'DBIx::Class';
requires 'MooseX::NonMoose';

build_requires 'Test::Most';

resources (
    repository => {
        url => 'ssh://git/srv/git/OpusVL-Preferences',
        type => 'git',
    },
);

if ($Module::Install::AUTHOR) {
    system("pod2text lib/OpusVL/Preferences.pm > README")
        and die $!;
}

auto_install;

WriteAll;

