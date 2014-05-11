#!/usr/bin/env perl
#
# list_attachments.pl -- list attachments of a ticket

use strict;
use warnings;

use Error qw(:try);
use RT::Client::REST;
use RT::Client::REST::Attachment;
use RT::Client::REST::Ticket;
use Log::Log4perl qw(:easy);

my $log_conf =<<LOG_CONF;
log4perl.category.Foo.Bar        = DEBUG, Screen

log4perl.appender.Screen         = Log::Log4perl::Appender::Screen
log4perl.appender.Screen.stderr  = 1
log4perl.appender.Screen.layout  = PatternLayout
log4perl.appender.Screen.layout.ConversionPattern=[%r] %F %L %c - %m%n
LOG_CONF

Log::Log4perl->easy_init($DEBUG);

unless (@ARGV >= 3) {
    die "Usage: $0 username password ticket_id\n";
}

my $rt = RT::Client::REST->new(
    server  => ($ENV{RTSERVER} || 'http://rt.cpan.org'),
#    logger  => Log::Log4perl->get_logger,
);
$rt->login(
    username=> shift(@ARGV),
    password=> shift(@ARGV),
);

my $ticket = RT::Client::REST::Ticket->new(rt => $rt, id => shift(@ARGV));

my $results;
try {
    $results = $ticket->attachments;
} catch Exception::Class::Base with {
    my $e = shift;
    die ref($e), ": ", $e->message;
};

my $count = $results->count;
print "There are $count results that matched your query\n";

my $iterator = $results->get_iterator;
while (my $att = &$iterator) {
    print "Id: ", $att->id, "; Subject: ", $att->subject, "\n";
}
