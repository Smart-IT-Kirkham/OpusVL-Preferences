
use strict;
use Test::Most;
use FindBin;
use lib "$FindBin::Bin/lib";

use Test::DBIx::Class
{
    schema_class => 'OpusVL::Preferences::Schema',
    connect_info =>
    [
        'dbi:SQLite:dbname=:memory:','','', 
        {
            quote_char => '"',
            name_sep   => '.',
        }
    ],
};

my $rs = ResultSet ('TestOwner');

my $defaults = $rs->prf_defaults;

$defaults->populate
([
	{ name => 'test1', default_value => '111' },
]);


my $owner = $rs->create ({ name => 'test' });

ok !defined $owner->prf_get ('blah')   => 'Non existant preference';
is $owner->prf_get ('test1'), '111'    => 'Preference uses the default';

$owner->prf_set ('test1' => '222');
is $owner->prf_get ('test1'), '222'    => 'Preference can be overridden';

$owner->prf_reset ('test1');
is $owner->prf_get ('test1'), '111'    => 'Preference reset back to default';

is_fields [qw/name default_value/] => $defaults,
[
	[qw/test1 111/]
], 'Check final fields are sensible';

 




done_testing;
