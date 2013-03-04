# User Agent for Japan Meteorological Agency
# 
# Sample code

use strict;
use warnings;
use Parallel::ForkManager; # Please install.
use contentextract;
use mytimer;


my $timer = mytimer->new;

### Configure

my $cookie_file = 'cookie.txt';
my $span = 30; # Length of day


# Start Date of Extraction.
my $tgtyear = '2010';
my $tgtmonth = '1';
my $tgtday = '1';


# Prefecture and Block
# This sample with Okinawa,Japan.
my $prec_no = '91';
my $block_no = '47936';

# Multi-Process
# This sample will run under 50 process.
my $maxprocess = 50;

# format
my $header = 'TIME,PRESS_ACT,PRESS_SS,RAIN,TEMP,HYDRO,WIND_AVG,WIND_AVG_DIR,WIND_MAX,WIND_MAX_DIR,SUNLIGHT'."\n";

my $pmdate = Parallel::ForkManager->new($maxprocess);

for(my $counter=0;$counter<$span;$counter++){
    $pmdate->start and next;

    my ($year,$month,$day) = $timer->get_add_date($tgtyear,$tgtmonth,$tgtday,$counter);
    my $filename = 'data/'.(sprintf("%04d-%02d-%02d",$year,$month,$day)).'.csv';
    my $tgturl = &make_url($year,$month,$day,$prec_no,$block_no);
    my $cont_ref = &contentextract::ExtractContent($tgturl);
    my $content = $$cont_ref;
    $content =~ /\<table class="data2_s" summary="(.*?)"\>.*?caption\>(.*?)\<\/table\>/imsg;
    
    my $summary = $1;
    my $tablecont = $2;
    
    
    my @datalisttemp = split('<tr class="mtx" style="text-align:right;">',$tablecont);
    
    my @datalist;
    
    for (my $k=1;$k<=$#datalisttemp;$k++){
	push(@datalist,$datalisttemp[$k]);
    }


    my @forcsv;
    push(@forcsv,$header);
    
    foreach my $line (@datalist){
	
	$line =~ /\<td style="white-space:nowrap"\>(.*?)\<\/td\>\<td class="data_0_0"\>(.*?)\<\/td\>\<td class="data_0_0"\>(.*?)\<\/td\>\<td class="data_0_0"\>(.*?)\<\/td\>\<td class="data_0_0"\>(.*?)\<\/td\>\<td class="data_0_0"\>(.*?)\<\/td\>\<td class="data_0_0"\>(.*?)\<\/td\>\<td class="data_0_0" style="text-align:center"\>(.*?)\<\/td\>\<td class="data_0_0"\>(.*?)\<\/td\>\<td class="data_0_0" style="text-align:center"\>(.*?)\<\/td\>\<td class="data_0_0"\>(.*?)\<\/td\>/imsg;
	
	my $time = $1;
	my $press_actual = $2;
	my $press_ss = $3;
	my $rains = $4;
	my $temper = $5;
	my $hydro = $6;
	my $wind_avg = $7;
	my $wind_dir = $8;
	my $wind_max = $9;
	
	my $wind_dir2 = $10;
	my $sunlight = $11;
	
	my $csvline = $time.','.$press_actual.','.$press_ss.','.$rains.','.$temper.','.$hydro.','.$wind_avg.','.$wind_dir.','.$wind_max.',';
	$csvline .= $wind_dir2.','.$sunlight."\n";
	push(@forcsv,$csvline);
	
    }
    
    open(FILE,">$filename");
    print FILE @forcsv;
    close(FILE);
    print sprintf("%04d-%02d-%02d",$year,$month,$day);
    print " : FINISHED";
    print "\n";
    $pmdate->finish;

}
# Wait child process.(required)
$pmdate->wait_all_children;

print "$span processes FINISHED\n";

sub make_url{
    my ($year,$month,$day,$prec_no,$block_no) = @_;

    my $url = 'http://www.data.jma.go.jp/obd/stats/etrn/view/10min_s1.php?prec_no='.$prec_no.'&block_no='.$block_no.'&year='.$year.'&month='.$month.'&day='.$day.'&elm=minutes&view=';

    return($url);
}
