#!/usr/bin/perl
package HTMLRenderer;

use strict;
use warnings;

sub render_header {
    return <<'END_HTML';
Content-Type: text/html

<!DOCTYPE html>
<html>
<head>
    <title>Proxmox Resources Monitor</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        .status-running { color: green; }
        .status-stopped { color: red; }
        h2 { color: #333; }
    </style>
</head>
<body>
END_HTML
}

sub render_resource_table {
    my ($title, $resources) = @_;
    my $html = "<h2>$title</h2>\n";
    $html .= <<'END_HTML';
<table>
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Status</th>
        <th>Memory (MB)</th>
        <th>CPU</th>
    </tr>
END_HTML

    foreach my $resource (@$resources) {
        my $status_class = $resource->{status} eq 'running' ? 'status-running' : 'status-stopped';
        $html .= sprintf(
            "<tr><td>%s</td><td>%s</td><td class='%s'>%s</td><td>%s</td><td>%s</td></tr>\n",
            $resource->{id},
            $resource->{name},
            $status_class,
            $resource->{status},
            int($resource->{memory} / (1024*1024)),
            $resource->{cpu}
        );
    }
    
    $html .= "</table>\n";
    return $html;
}

sub render_footer {
    return "</body></html>\n";
}

1;