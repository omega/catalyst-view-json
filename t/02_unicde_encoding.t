use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/lib";

use Encode;
use Test::More;
eval "use Catalyst::Plugin::Unicode::Encoding";
if ($@) {
    plan skip_all => "Catalyst::Plugin::Unicode::Encoding needed for this test";
}
eval "use JSON 2.04";
if ($@) {
    plan skip_all => "JSON 2.04 is needed for testing";
}

use Catalyst::Test 'TestAppUnicodeEncoding';


my $entrypoint = "http://localhost/foo";


{
    my $request = HTTP::Request->new( GET => $entrypoint );

    ok( my $response = request($request), 'Request' );
    ok( $response->is_success, 'Response Successful 2xx' );
    is( $response->code, 200, 'Response Code' );
    is_deeply( [ $response->content_type ], [ 'application/json', 'charset=utf-8' ] );

    my $data = JSON::from_json(Encode::decode_utf8($response->content));

    is($data->{foo}, "\x{30c6}\x{30b9}\x{30c8}")
}
{
    my $request = HTTP::Request->new( GET => $entrypoint );
    $request->header("User-Agent", "Opera");

    ok( my $response = request($request), 'Request' );
    ok( $response->is_success, 'Response Successful 2xx' );
    is( $response->code, 200, 'Response Code' );
    is_deeply( [ $response->content_type ], [ 'application/json', 'charset=utf-8' ] );

    my $data = JSON::from_json(Encode::decode_utf8($response->content));
    is($data->{foo}, "\x{30c6}\x{30b9}\x{30c8}")
}

done_testing();
