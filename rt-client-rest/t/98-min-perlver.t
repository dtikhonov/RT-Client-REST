use Test::More;

BEGIN {
    unless ($ENV{RELEASE_TESTING}) {
        plan(skip_all => 'these tests are for release candidate testing');
    }
}

eval { require Test::MinimumVersion; Test::MinimumVersion->import };
if ($@) {
    plan skip_all => 'Test::MinimumVersion not installed; skipping'
}

all_minimum_version_from_metayml_ok({ paths => [ 'lib' ] });
