package OpusVL::FB11X::Model::PreferencesDB;

# ABSTRACT: FB11 model for preferences DB

use Moose;
use Switch::Plain;

BEGIN {
    extends 'Catalyst::Model::DBIC::Schema';
}

__PACKAGE__->config(
    schema_class => 'OpusVL::Preferences::Schema',
    traits => 'SchemaProxy',
);

has short_name => (
    is => "rw",
    lazy => 1,
    default => "preferences"
);

sub hats {
    (
        parameters => {
            class =>  '+OpusVL::Preferences::Hat::preferences'
        },
        dbic_schema => {
            class => 'dbic_schema::is_brain'
        },
    )
}

with "OpusVL::FB11::Role::Brain";

1;

