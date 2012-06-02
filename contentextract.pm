package contentextract;
use strict;
use LWP::UserAgent;
use Crypt::SSLeay;
use HTTP::Cookies;
use HTTP::Request::Common qw(POST);

sub ExtractContent{
  my ($tgturl) = @_;
  my ($ua, $req, $res, $cont);
  my $timename = (localtime(time()))[3];
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

sub ExtractContent_POST{
  my ($tgturl,$form_addr) = @_;
  my %FORM = %$form_addr;
  my ($ua, $req, $res, $cont);
  my $timename = (localtime(time()))[3];
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

