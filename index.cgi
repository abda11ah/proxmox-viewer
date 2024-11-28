#!/usr/bin/perl

use strict;
use warnings;
use lib '.';
use ProxmoxAPI;
use ResourceProcessor;
use HTMLRenderer;

my $api = ProxmoxAPI->new();

print HTMLRenderer::render_header();

if ($api->login()) {
    my $resources = $api->get_resources();
    my $processed = ResourceProcessor::process_resources($resources);
    
    print HTMLRenderer::render_resource_table("Virtual Machines", $processed->{vms});
    print HTMLRenderer::render_resource_table("Containers", $processed->{containers});
} else {
    print "<h2>Error: Could not connect to Proxmox API</h2>\n";
}

print HTMLRenderer::render_footer();