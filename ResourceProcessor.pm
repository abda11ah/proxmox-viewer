#!/usr/bin/perl
package ResourceProcessor;

use strict;
use warnings;

sub process_resources {
    my ($resources) = @_;
    my @vms;
    my @containers;
    
    foreach my $resource (@$resources) {
        if ($resource->{type} eq 'qemu') {
            push @vms, {
                id => $resource->{vmid},
                name => $resource->{name},
                status => $resource->{status},
                memory => $resource->{maxmem},
                cpu => $resource->{maxcpu}
            };
        }
        elsif ($resource->{type} eq 'lxc') {
            push @containers, {
                id => $resource->{vmid},
                name => $resource->{name},
                status => $resource->{status},
                memory => $resource->{maxmem},
                cpu => $resource->{maxcpu}
            };
        }
    }
    
    return {
        vms => \@vms,
        containers => \@containers
    };
}

1;