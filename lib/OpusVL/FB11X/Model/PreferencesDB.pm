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
    qw/parameters dbic_schema::is_brain/
}

with "OpusVL::FB11::Brain";

around hat => sub {
    my $orig = shift;
    my $self = shift;
    my $hat_name = shift;

    if ($hat_name eq 'parameters') {
        $hat_name = '+OpusVL::Preferences::Hat::preferences'
    }

    $self->$orig($hat_name);
};


1;

