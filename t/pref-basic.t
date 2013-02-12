
use strict;
use Test::Most;
use FindBin;
use lib "$FindBin::Bin/lib";

use Test::DBIx::Class
{
    schema_class => 'OpusVL::Preferences::Schema',
	traits       => 'Testpostgresql',
}, 'TestOwner';

my $rs = ResultSet ('TestOwner');

my $defaults = $rs->prf_defaults;

is_resultset ($defaults); #  'Resultset sanity check'

$defaults->populate
([
	[qw/ name    default_value      /],
	[qw/ test1   111                /],
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

my $default = $defaults->first; 
$default->create_related('values', { value => 'test' });
$default->create_related('values', { value => 'test2' });
eq_or_diff $default->form_options, [[ 'test', 'test' ], ['test2', 'test2']];

$defaults->create({
    name => 'another',
    data_type => 'text',
    comment => 'blah',
    default_value => '',
});

ok my $results = TestOwner->with_fields({
    test1 => '222',
    name => 'again',
});
is $results->count, 0;

ok my $test = TestOwner->join_by_name('test1');
is $test->count, 1;

ok my $s = TestOwner->select_extra_fields('test1', 'name');
is $s->{rs}->count, 1;

done_testing;
