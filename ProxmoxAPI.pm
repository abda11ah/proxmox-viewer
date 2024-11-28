#!/usr/bin/perl
package ProxmoxAPI;

use strict;
use warnings;
use LWP::UserAgent;
use JSON;
use HTTP::Request;
use URI::Escape;
use Config;

sub new {
    my $class = shift;
    my $self = {
        token => undef,
        ua => LWP::UserAgent->new(
            ssl_opts => { verify_hostname => 0, SSL_verify_mode => 0 }
        )
    };
    bless $self, $class;
    return $self;
}

sub login {
    my $self = shift;
    my $url = "https://$Config::PROXMOX_HOST:$Config::PROXMOX_PORT/api2/json/access/ticket";
    
    my $response = $self->{ua}->post($url, [
        username => $Config::PROXMOX_USER,
        password => $Config::PROXMOX_PASSWORD
    ]);
    
    if ($response->is_success) {
        my $data = decode_json($response->content);
        $self->{token} = $data->{data}{ticket};
        return 1;
    }
    return 0;
}

sub get_resources {
    my $self = shift;
    my $url = "https://$Config::PROXMOX_HOST:$Config::PROXMOX_PORT/api2/json/cluster/resources";
    
    my $request = HTTP::Request->new(GET => $url);
    $request->header('Cookie' => "PVEAuthCookie=" . $self->{token});
    
    my $response = $self->{ua}->request($request);
    
    if ($response->is_success) {
        return decode_json($response->content)->{data};
    }
    return [];
}

1;