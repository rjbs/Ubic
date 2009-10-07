#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 5;
use Test::Exception;

use lib 'lib';

use Ubic::Multiservice::Simple;
use Ubic::Service::SimpleDaemon;

my $s1 = Ubic::Service::SimpleDaemon->new({ name => 'sleep', bin => 'sleep 1000' });
my $s2 = Ubic::Service::SimpleDaemon->new({ name => 'sleep', bin => 'sleep 2000' });

my $ms = Ubic::Multiservice::Simple->new({
    s1 => $s1,
    s2 => $s2,
});

ok(scalar $ms->has_service('s1'), 'has_service returns true for existing service');
ok(not(scalar $ms->has_service('s3')), 'has_service returns false for non-existing service');
is_deeply([ sort $ms->services ], [ sort($s1, $s2) ], 'services() return both services');
is_deeply([ sort $ms->service_names ], [ sort('s1', 's2') ], 'service_names() return both service names');

dies_ok(sub {
    Ubic::Multiservice::Simple->new({
        s1 => $s1,
        s2 => 'non-service',
    });
}, 'new fails when non-service is specified as value');

