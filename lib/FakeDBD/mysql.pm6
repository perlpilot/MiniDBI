# FakeDBD::mysql.pm

use NativeCall;  # from project 'zavolaj'
use FakeDBD;

class FakeDBD::mysql:auth<mberends>:ver<0.0.1> does FakeDBD {

    has $.Version = 0.01;
    has $!mysql_client;
    has $!mysql_error;
    has $!statement;

#------------------------- methods used by DBI -------------------------
    method connect( Str $user, Str $password, Str $params ) {
        # warn "entering FakeDBD::mysql.connect()";
        unless defined $!mysql_client {
            $!mysql_client = mysql_init( pir::null__P() );
            $!mysql_error  = mysql_error( $!mysql_client );
        }
        my @params = $params.split(';');
        my %params;
        for @params -> $p {
            my ( $key, $value ) = $p.split('=');
            %params{$key} = $value;
        }
        my $host     = %params<host> // 'localhost';
        my $port     = %params<port> // 0;
        my $database = %params<database> // 'mysql';
        my $socket       = Mu;
        my $flag         = Mu;
        mysql_real_connect( $!mysql_client, $host, $user, $password,
            $database, $port, pir::null__P(), 0 );
    }
    method prepare( Str $statement ) {
        $!statement = $statement;
    }

    method execute(Str $statement) {
        mysql_query( $!statement );
    }

#------------ mysql library functions in alphabetical order ------------

sub mysql_affected_rows( OpaquePointer $mysql_client )
    returns Int
    is native('libmysqlclient')
    { ... }

sub mysql_close( OpaquePointer $mysql_client )
    returns OpaquePointer
    is native('libmysqlclient')
    { ... }

sub mysql_data_seek( OpaquePointer $result_set, Int $row_number )
    returns OpaquePointer
    is native('libmysqlclient')
    { ... }

sub mysql_error( OpaquePointer $mysql_client)
    returns Str
    is native('libmysqlclient')
    { ... }

sub mysql_fetch_field( OpaquePointer $result_set )
    returns OpaquePointer
    is native('libmysqlclient')
    { ... }

sub mysql_fetch_lengths( OpaquePointer $result_set )
    returns Positional of Int
    is native('libmysqlclient')
    { ... }

sub mysql_fetch_row( OpaquePointer $result_set )
    returns Positional of Str
    is native('libmysqlclient')
    { ... }

sub mysql_field_count( OpaquePointer $mysql_client )
    returns Int
    is native('libmysqlclient')
    { ... }

sub mysql_free_result( OpaquePointer $result_set )
    returns OpaquePointer
    is native('libmysqlclient')
    { ... }

sub mysql_get_client_info( OpaquePointer $mysql_client)
    returns Str
    is native('libmysqlclient')
    { ... }

sub mysql_init( OpaquePointer $mysql_client )
    returns OpaquePointer
    is native('libmysqlclient')
    { ... }

sub mysql_library_init( Int $argc, OpaquePointer $argv,
    OpaquePointer $group )
    returns Int
    is native('libmysqlclient')
    { ... }

sub mysql_library_end()
    returns OpaquePointer # currently not working, should be void
    is native('libmysqlclient')
    { ... }

sub mysql_num_rows( OpaquePointer $result_set )
    returns Int
    is native('libmysqlclient')
    { ... }

sub mysql_query( OpaquePointer $mysql_client, Str $sql_command )
    returns Int
    is native('libmysqlclient')
    { ... }

sub mysql_real_connect( OpaquePointer $mysql_client, Str $host, Str $user,
    Str $password, Str $database, Int $port, Str $socket, Int $flag )
    returns OpaquePointer
    is native('libmysqlclient')
    { ... }

sub mysql_stat( OpaquePointer $mysql_client)
    returns Str
    is native('libmysqlclient')
    { ... }

sub mysql_store_result( OpaquePointer $mysql_client )
    returns OpaquePointer
    is native('libmysqlclient')
    { ... }

sub mysql_use_result( OpaquePointer $mysql_client )
    returns OpaquePointer
    is native('libmysqlclient')
    { ... }

}

# warn "module FakeDBD::mysql.pm has loaded";

# 'zavolaj' is a Native Call Interface for Rakudo/Parrot. 'FakeDBI' and
# 'FakeDBD::mysql' are Perl 6 modules that use 'zavolaj' to use the
# standard mysqlclient library.  There is a long term Parrot based
# project to develop a new, comprehensive DBI architecture for Parrot
# and Perl 6.  FakeDBI is not that, it is a naive rewrite of the
# similarly named Perl 5 modules.  Hence the 'Fake' part of the name.
