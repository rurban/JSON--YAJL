#! perl
use strict;
use warnings;
use Test::More;

use JSON::YAJL;

my $text;
my $parser = JSON::YAJL::Parser->new(
    0, 0,
    [   sub { $text .= " null" },
        sub { $text .= " bool: @_" },
        undef,
        undef,           
        sub { $text .= " number: @_" },
        sub { $text .= " string: \"@_\"" },
        sub { $text .= " map_open" },
        sub { $text .= " map_key: @_" },
        sub { $text .= " map_close" },
        sub { $text .= " array_open" },
        sub { $text .= " array_close" },
    ]
);
while (<DATA>) {
    $parser->parse($_);
}
$parser->parse_complete();

# local $TODO = "RT# 90125"; # fixed with newSVpvn
is($text, qq( map_open map_key: foo string: "" map_key: bar string: "baz" map_close),
   "empty strings");
done_testing();

__DATA__
{ "foo": "", "bar": "baz" }
