package OpusVL::FB11X::Preferences;

use Moose;
use CatalystX::InjectComponent;

our $VERSION = "0.001";

with "OpusVL::FB11::RolesFor::Plugin";

after setup_components => sub {
    my $class = shift;
    $class->add_paths(__PACKAGE__);

    CatalystX::InjectComponent->inject(
        into      => $class,
        component => 'OpusVL::FB11X::Model::PreferencesDB',
        as        => 'Model::PreferencesDB'
    );

};


1;
