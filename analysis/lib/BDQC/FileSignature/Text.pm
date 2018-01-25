package BDQC::FileSignature::Text;

###############################################################################
# Class       : BDQC::FileSignature::Text
#
# Description : This class is autogenerated via generatePerlClasses.pl and
#
###############################################################################

use strict;
use warnings;

use BDQC::Response qw(processParameters);

my $CLASS = 'BDQC::FileSignature::Text';
my $DEBUG = 0;
my $VERBOSE = 0;
my $TESTONLY = 0;

my $VERSION = '0.0.1';

#### BEGIN CUSTOMIZED CLASS-LEVEL VARIABLES AND CODE




#### END CUSTOMIZED CLASS-LEVEL VARIABLES AND CODE


sub new {
###############################################################################
# Constructor
###############################################################################
  my $METHOD = 'new';
  print "DEBUG: Entering $CLASS.$METHOD\n" if ( $DEBUG );
  my $self = shift;
  my %parameters = @_;
  my $class = ref($self) || $self;

  #### Create the object with any default attributes
  $self = {
  };
  bless $self => $class;

  #### Process constructor object parameters
  my $filePath = processParameters( name=>'filePath', required=>0, allowUndef=>0, parameters=>\%parameters, caller=>$METHOD );
  $self->{_filePath} = $filePath;

  #### BEGIN CUSTOMIZATION. DO NOT EDIT MANUALLY ABOVE THIS. EDIT MANUALLY ONLY BELOW THIS.


  #### END CUSTOMIZATION. DO NOT EDIT MANUALLY BELOW THIS. EDIT MANUALLY ONLY ABOVE THIS.

  #### Complain about any unexpected parameters
  my $unexpectedParameters = '';
  foreach my $parameter ( keys(%parameters) ) { $unexpectedParameters .= "ERROR: unexpected parameter '$parameter'\n"; }
  die("CALLING ERROR [$METHOD]: $unexpectedParameters") if ($unexpectedParameters);

  print "DEBUG: Exiting $CLASS.$METHOD\n" if ( $DEBUG );
  return($self);
}


sub getFilePath {
###############################################################################
# getFilePath
###############################################################################
  my $METHOD = 'getFilePath';
  print "DEBUG: Entering $CLASS.$METHOD\n" if ( $DEBUG );
  my $self = shift || die("parameter self not passed");

  print "DEBUG: Exiting $CLASS.$METHOD\n" if ( $DEBUG );
  return($self->{_filePath});
}


sub setFilePath {
###############################################################################
# setFilePath
###############################################################################
  my $METHOD = 'setFilePath';
  print "DEBUG: Entering $CLASS.$METHOD\n" if ( $DEBUG );
  my $self = shift || die("parameter self not passed");
  my $value = shift;


  $self->{_filePath} = $value;
  print "DEBUG: Exiting $CLASS.$METHOD\n" if ( $DEBUG );
  return 1;
}


sub calcSignature {
###############################################################################
# calcSignature
###############################################################################
  my $METHOD = 'calcSignature';
  print "DEBUG: Entering $CLASS.$METHOD\n" if ( $DEBUG );
  my $self = shift || die ("self not passed");
  my %parameters = @_;

  #### Define standard parameters
  my ( $response, $debug, $verbose, $quiet, $testonly, $outputDestination, $rmiServer );

  {
  #### Set up a response object
  $response = BDQC::Response->new();
  $response->setState( status=>'NOTSET', message=>"Status not set in method $METHOD");

  #### Process standard parameters
  $debug = processParameters( name=>'debug', required=>0, allowUndef=>0, default=>0, overrideIfFalse=>$DEBUG, parameters=>\%parameters, caller=>$METHOD, response=>$response );
  $verbose = processParameters( name=>'verbose', required=>0, allowUndef=>0, default=>0, overrideIfFalse=>$VERBOSE, parameters=>\%parameters, caller=>$METHOD, response=>$response );
  $quiet = processParameters( name=>'quiet', required=>0, allowUndef=>0, default=>0, parameters=>\%parameters, caller=>$METHOD, response=>$response );
  $testonly = processParameters( name=>'testonly', required=>0, allowUndef=>0, default=>0, parameters=>\%parameters, caller=>$METHOD, response=>$response );
  $outputDestination = processParameters( name=>'outputDestination', required=>0, allowUndef=>0, default=>'STDERR', parameters=>\%parameters, caller=>$METHOD, response=>$response );
  $rmiServer = processParameters( name=>'rmiServer', required=>0, allowUndef=>0, parameters=>\%parameters, caller=>$METHOD, response=>$response );
  print "DEBUG: Entering $CLASS.$METHOD\n" if ( $debug && !$DEBUG );
  }
  #### Process specific parameters
  my $filePath = processParameters( name=>'filePath', required=>0, allowUndef=>0, parameters=>\%parameters, caller=>$METHOD, response=>$response );
  if ( ! defined($filePath) ) {
    $filePath = $self->getFilePath();
  } else {
    $self->setFilePath($filePath);
  }

  #### Die if any unexpected parameters are passed
  my $unexpectedParameters = '';
  foreach my $parameter ( keys(%parameters) ) { $unexpectedParameters .= "ERROR: unexpected parameter '$parameter'\n"; }
  die("CALLING ERROR [$METHOD]: $unexpectedParameters") if ($unexpectedParameters);

  #### Return if there was a problem with the required parameters
  return $response if ( $response->{errorCode} =~ /MissingParameter/i );

  #### Set the default state to not implemented. Do not change this. Override later
  my $isImplemented = 0;

  #### BEGIN CUSTOMIZATION. DO NOT EDIT MANUALLY ABOVE THIS. EDIT MANUALLY ONLY BELOW THIS.

  $isImplemented = 1;
  my $lineEndings = { CR=>0, LF=>0, CRLF=>0, LFCR=>0 };
  my $signature = { nLines=>0, lineEndings=>$lineEndings, averageLineLength=>0, averageWordsPerLine=>0 };

  if ( $filePath =~ /\.gz$/ ) {
    use IO::Zlib;
    my $error;
    tie(*INFILE, 'IO::Zlib', $filePath, 'r') or $error = 1;
    if ( $error ) {
      $response->logEvent( status=>'ERROR', level=>'ERROR', errorCode=>"UnableToOpenFile", verbose=>$verbose, debug=>$debug, quiet=>$quiet, outputDestination=>$outputDestination, 
        message=>"Unable to open '$filePath': $@");
      return $response;
    }
  } else {
    unless ( open(INFILE,$filePath) ) {
      $response->logEvent( status=>'ERROR', level=>'ERROR', errorCode=>"UnableToOpenFile", verbose=>$verbose, debug=>$debug, quiet=>$quiet, outputDestination=>$outputDestination, 
        message=>"Unable to open file '$filePath': $@");
      return $response;
    }
  }

  my $line;
  while ( $line = <INFILE> ) {
    $signature->{nLines}++;

    #### Record the line endings
    if ( $line =~ /\n\r/ ) { $lineEndings->{LFCR}++; }
    elsif ( $line =~ /\r\n/ ) { $lineEndings->{CRLF}++; }
    elsif ( $line =~ /\n/ ) { $lineEndings->{LF}++; }
    else { $lineEndings->{CR}++; }

    $line =~ s/[\n\r]//g;
    $signature->{averageLineLength} += length($line);
    $line =~ s/^\s+//;
    $line =~ s/\s+$//;
    my @words = split(/\s+/,$line);
    $signature->{averageWordsPerLine} += scalar(@words);
  }

  close(INFILE);

  if ( $signature->{nLines} ) {
    $signature->{averageLineLength} /= $signature->{nLines};
    $signature->{averageWordsPerLine} /= $signature->{nLines};
  }

  $response->{signature} = $signature;

  #### END CUSTOMIZATION. DO NOT EDIT MANUALLY BELOW THIS. EDIT MANUALLY ONLY ABOVE THIS.
  {
  if ( ! $isImplemented ) {
    $response->logEvent( status=>'ERROR', level=>'ERROR', errorCode=>"Method${METHOD}NotImplemented", message=>"Method $METHOD has not yet be implemented", verbose=>$verbose, debug=>$debug, quiet=>$quiet, outputDestination=>$outputDestination );
  }

  #### Update the status codes and return
  $response->setState( status=>'OK', message=>"Method $METHOD completed normally") if ( $response->{status} eq 'NOTSET' );
  print "DEBUG: Exiting $CLASS.$METHOD\n" if ( $debug );
  }
  return $response;
}


sub show {
###############################################################################
# show
###############################################################################
  my $METHOD = 'show';
  print "DEBUG: Entering $CLASS.$METHOD\n" if ( $DEBUG );
  my $self = shift || die ("self not passed");
  my %parameters = @_;

  #### Create a simple text representation of the data in the object
  my $buffer = '';
  $buffer .= "$self\n";
  my $filePath = $self->getFilePath() || '';
  $buffer .= "  filePath=$filePath\n";

  print "DEBUG: Exiting $CLASS.$METHOD\n" if ( $DEBUG );
  return $buffer;
}


sub setSignatureAttributeDescriptions {
###############################################################################
# setSignatureAttributeDescriptions
###############################################################################
  my $METHOD = 'setSignatureAttributeDescriptions';
  print "DEBUG: Entering $CLASS.$METHOD\n" if ( $DEBUG );
  my $self = shift || die ("self not passed");
  my $qckb = shift || die ("qckb not passed");

  return if ( exists($qckb->{signatureInfo}->{"FileSignature::Text.nLines"}->{friendlyName}) );

  my $info = $qckb->{signatureInfo};

  $info->{"FileSignature::Text.nLines"}->{friendlyName} = "number of lines";
  $info->{"FileSignature::Text.nLines"}->{sideName}->{upper} = "larger";
  $info->{"FileSignature::Text.nLines"}->{sideName}->{lower} = "smaller";

  $info->{"FileSignature::Text.lineEndings"}->{friendlyName} = "pattern of line endings";
  $info->{"FileSignature::Text.lineEndings"}->{sideName}->{upper} = "different";
  $info->{"FileSignature::Text.lineEndings"}->{sideName}->{lower} = "different";

  $info->{"FileSignature::Text.averageLineLength"}->{friendlyName} = "average length of each line";
  $info->{"FileSignature::Text.averageLineLength"}->{sideName}->{upper} = "longer";
  $info->{"FileSignature::Text.averageLineLength"}->{sideName}->{lower} = "shorter";

  $info->{"FileSignature::Text.averageWordsPerLine"}->{friendlyName} = "average number of words per line";
  $info->{"FileSignature::Text.averageWordsPerLine"}->{sideName}->{upper} = "larger";
  $info->{"FileSignature::Text.averageWordsPerLine"}->{sideName}->{lower} = "shorter";

  return;
}


###############################################################################
1;
