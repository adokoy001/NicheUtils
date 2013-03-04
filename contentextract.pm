package contentextract;
use strict;
use LWP::UserAgent;
use Crypt::SSLeay;
use HTTP::Cookies; # for HTTP-Cookies simulation.
use HTTP::Request::Common qw(POST);

# content extraction from target_URL. GET command
sub ExtractContent{
  my ($tgturl) = @_;
  my ($ua, $req, $res, $cont);
  my $timename = (localtime(time()))[3];
  # cookie simulated.
  my $cookie_file = './cookies/cookiefile'.$timename.'.txt';
  my $cookie_jar = HTTP::Cookies->new(file => $cookie_file, autosave => 1, ignore_discard => 1);
  $ua = LWP::UserAgent->new;
  $ua->cookie_jar($cookie_jar);
  $ua->agent("MY-RBT/1.0 ");
  $req = HTTP::Request->new(GET => $tgturl);
  my $res = $ua->request($req);
  if($res->is_success){
    $cont = $res->content;
  }else{
    $cont = "WGET ERROR"; ### WGET error
  }
  return(\$cont);
}

# content extraction from target_URL by using POST parameter-values set.
sub ExtractContent_POST{
  # target_URL and form-values (hash ref).
  my ($tgturl,$form_addr) = @_;
  my %FORM = %$form_addr;
  my ($ua, $req, $res, $cont);
  my $timename = (localtime(time()))[3];
  # cookie simulated.
  my $cookie_file = './cookies/cookiefile'.$timename.'.txt';
  my $cookie_jar = HTTP::Cookies->new(file => $cookie_file, autosave => 1, ignore_discard => 1);
  $ua = LWP::UserAgent->new;
  $ua->cookie_jar($cookie_jar);
  $ua->agent("MY-RBT/1.0 ");
  $req = POST($tgturl,[%FORM]);
  my $res = $ua->request($req);
  if($res->is_success){
    $cont = $res->content;
  }else{
    $cont = "WGET ERROR"; ### WGET error
  }
  return(\$cont);
}

1;

