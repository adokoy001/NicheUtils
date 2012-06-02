package mytimer;

use Carp qw(croak);
use strict;
use Time::HiRes;
use Time::Local;

sub new{
  my $pkg = shift;
  bless{
    sec => undef,
    min => undef,
    hour => undef,
    day => undef,
    month => undef,
    year => undef,
    hires01 => undef,
    proct => undef,
    totalsec => undef
  },$pkg;
}

sub set_timestamp{
  my $self = shift;
  my $totalsec = time;
  ($self->{sec},$self->{min},$self->{hour},$self->{day},$self->{month},$self->{year}) = (localtime($totalsec))[0,1,2,3,4,5];
  $self->{year} += 1900;
  $self->{month}++;
  $self->{totalsec} = $totalsec;
}
sub start_watch{
  my $self = shift;
  $self->{hires01} = (Time::HiRes::time)[0];
}

sub get_date{
  my $self = shift;
  return($self->{year},$self->{month},$self->{day});
}

sub get_time{
  my $self = shift;
  return($self->{hour},$self->{min},$self->{sec});
}

sub get_timestamp{
  my $self = shift;
  return($self->{year},$self->{month},$self->{day},$self->{hour},$self->{min},$self->{sec});
}

sub stop_watch{
  my $self = shift;
  my $t = (Time::HiRes::time)[0];
  $self->{proct} = ($t - $self->{hires01});
}

sub get_timestamp_str{
  my $self = shift;
  my $str = sprintf("%04d-%02d-%02d %02d:%02d:%02d",$self->{year},$self->{month},$self->{day},$self->{hour},$self->{min},$self->{sec});
  return($str);
}

sub get_timestamp_str_J{
  my $self = shift;
  my $str = sprintf("%04d年%02d月%02d日 %02d:%02d:%02d",$self->{year},$self->{month},$self->{day},$self->{hour},$self->{min},$self->{sec});
  return($str);
}

sub get_date_str{
  my $self = shift;
  my $str = sprintf("%04d-%02d-%02d",$self->{year},$self->{month},$self->{day});
  return($str);
}

sub get_date_str_J{
  my $self = shift;
  my $str = sprintf("%04d年%02d月%02d日",$self->{year},$self->{month},$self->{day});
  return($str);
}

sub get_time_str{
  my $self = shift;
  my $str = sprintf("%02d:%02d:%02d",$self->{hour},$self->{min},$self->{sec});
  return($str);
}

sub get_datetoweek{
  my $self = shift;
  my $str = shift;
  my @weeks = ('SUN','MON','TUE','WED','THU','FRI','SAT');
  my ($year,$month,$day) = split('-',$str);
  if($month == 1 or $month == 2){
    $year--;
    $month += 12;
  }
  my $ind =  ($year + int($year / 4) - int($year/100) + int($year / 400) + int((13 * $month + 8) / 5) + $day) % 7;
  return($weeks[$ind]);
}

sub get_datetoweek_S{
  my $self = shift;
  my $str = shift;
  my @weeks = ('sun','mon','tue','wed','thu','fri','sat');
  my ($year,$month,$day) = split('-',$str);
  if($month == 1 or $month == 2){
    $year--;
    $month += 12;
  }
  my $ind =  ($year + int($year / 4) - int($year/100) + int($year / 400) + int((13 * $month + 8) / 5) + $day) % 7;
  return($weeks[$ind]);
}


sub get_datetoweek_J{
  my $self = shift;
  my $str = shift;
  my @weeks = ('日','月','火','水','木','金','土');
  my ($year,$month,$day) = split('-',$str);
  if($month == 1 or $month == 2){
    $year--;
    $month += 12;
  }
  my $ind =  ($year + int($year / 4) - int($year/100) + int($year / 400) + int((13 * $month + 8) / 5) + $day) % 7;
  return($weeks[$ind]);
}


sub get_proctime{
  my $self = shift;
  return($self->{proct});
}

sub get_add_date{
  my $self = shift;
  my $base_year = shift;
  my $base_month = shift;
  my $base_day = shift;
  my $add_day = shift;
  my $insec = timelocal(1,0,0,$base_day,$base_month - 1,$base_year) + (60*60*24)*$add_day;
  my ($out_day,$out_month,$out_year) = (localtime($insec))[3,4,5];
  return($out_year+1900,$out_month+1,$out_day);
}

sub get_add_date_fmt{
  my $self = shift;
  my $base_year = shift;
  my $base_month = shift;
  my $base_day = shift;
  my $add_day = shift;
  my $insec = timelocal(1,0,0,$base_day,$base_month - 1,$base_year) + (60*60*24)*$add_day;
  my ($day,$month,$year) = (localtime($insec))[3,4,5];
  my $out_day = sprintf("%02d",$day);
  my $out_month = sprintf("%02d",$month+1);
  my $out_year = sprintf("%04d",$year+1900);
  return($out_year,$out_month,$out_day);
}

sub ts_to_sec{
  my ($input) = @_;
  my ($date,$times) = split(' ',$input);
  my ($year,$month,$day) = split('-',$date);
  my ($hour,$min,$sec) = split(':',$times);
  return(timelocal($sec,$min,$hour,$day,$month - 1,$year));
}

sub get_diff_date{
    my $self = shift;
    my $date01 = shift;
    my $date02 = shift;
    my @date01array = split('-',$date01);
    my @date02array = split('-',$date02);
    my $secdate01 = timelocal(1,0,0,$date01array[2],$date01array[1] - 1,$date01array[0]);
    my $secdate02 = timelocal(1,0,0,$date02array[2],$date02array[1] - 1,$date02array[0]);
    my $diffday = int(($secdate02 - $secdate01)/(3600*24));
    return($diffday);
}

sub add_day{
    my $self = shift;
    $self->{totalsec} += 24*60*60;
    my ($sec,$min,$hour,$day,$month,$year) = (localtime($self->{totalsec}))[0,1,2,3,4,5];
    $month++;
    $year += 1900;
    $self->{sec} = $sec;
    $self->{min} = $min;
    $self->{hour} = $hour;
    $self->{day} = $day;
    $self->{month} = $month;
    $self->{year} = $year;
}


1;
