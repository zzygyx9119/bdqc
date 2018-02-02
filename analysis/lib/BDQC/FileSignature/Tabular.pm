package BDQC::FileSignature::Tabular;

###############################################################################
# Class       : BDQC::FileSignature::Tabular
#
# Description : This class is autogenerated via generatePerlClasses.pl and
#
###############################################################################

use strict;
use warnings;

use BDQC::Response qw(processParameters);

my $CLASS = 'BDQC::FileSignature::Tabular';
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

  $isImplemented++;

  #### Set up an empty signature}
  my $signature = { nRows=>0, commentCharacter=>'', nCommentLines=>0, hasColumnNames=>0, nColumns=>0, blankLines=>0 };

  if ( $filePath =~ /\.gz$/ ) {
    use IO::Zlib;
    my $error;
    tie(*INFILE, 'IO::Zlib', $filePath, 'rb') or $error = 1;
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

  my $iLine=0;
  my %columnCounts;
  my @columnCounts;
  my $separator = "\t";
  #$separator = ",";
  my @lines;
  my @nNumerals;
  my $columnHeaderRow = -1;

  #### Loop through file, trying to interpret it as delimited data
  while ( my $line = <INFILE> ) {
    $line =~ s/[\r\n]+$//;
    push(@lines,$line);

    #### If this is an empty line, just record it as such and move on
    if ( $line eq '' || $line =~ /^\s+$/ ) {
      $signature->{blankLines}++;
      push(@nNumerals,0);
      push(@columnCounts,0);
      $columnCounts{0}++;
      $iLine++;
      next;
    }

    #### Split the line
    my @columns = split( /$separator/, $line, -1 );
    my $nColumns = scalar(@columns);
    push(@columnCounts,$nColumns);
    $columnCounts{$nColumns}++;

    #### Count the number of columns that are numerals
    $nNumerals[$iLine] = 0;
    foreach my $value ( @columns ) {
      $nNumerals[$iLine]++ if ( $value =~ /^\s*[\d\.\+\-eE]+\s*$/ );
    }

    $iLine++;
    last if ( $iLine >= 50 );
  }

  #### Diagnostic
  #for ( my $i=0; $i<10; $i++ ) {
  #  print "    $columnCounts[$i]\t$nNumerals[$i]\n";
  #}

  #### Determine what the most common number of columns is here at the beginning of the file
  my @mostCommonNColumns;
  foreach my $nColumns ( keys(%columnCounts) ) {
    push(@mostCommonNColumns,[$nColumns,$columnCounts{$nColumns}]);
    #print "INFO: columnCounts: $nColumns,$columnCounts{$nColumns}\n";
  }
  my @sortedMostCommonNColumns = reverse sort numericallyBySecondValue @mostCommonNColumns;
  my $mostCommonNColumns = $sortedMostCommonNColumns[0]->[0];
  #print "INFO: The most common number of columns is $mostCommonNColumns\n";

  #### Find the first data row as the first one with the most common number of columns
  my $firstDataRow = 0;
  foreach my $columnCount ( @columnCounts ) {
    #print "$firstDataRow\t$columnCount\n";
    last if ( $columnCount == $mostCommonNColumns );
    $firstDataRow++;
  }
  $signature->{nCommentLines} = $firstDataRow;

  #### If the first row has fewer numerals than the next data row, assume it is a header line. Crude. FIXME
  if ( ($nNumerals[$firstDataRow]||0) < ($nNumerals[$firstDataRow+1]||0) ) {
    $columnHeaderRow = $firstDataRow;
    $firstDataRow++;
    $signature->{hasColumnNames} = 1;
    $signature->{nCommentLines} = $columnHeaderRow-1;
  }

  #print "INFO: firstDataRow=$firstDataRow, columnHeaderRow=$columnHeaderRow\n";
  $signature->{nColumns} = $mostCommonNColumns;

  #### Determine the comment character
  $signature->{nCommentLines} = 0 if ( $signature->{nCommentLines} < 0 );

  if ( $signature->{nCommentLines} > 0 ) {
    $signature->{commentCharacter} = substr($lines[0],0,1);
  }

  #### Now that we've figured all this out, return to the beginning of the file and parse the data

  # Since seek won't work on a gzipped file, replay the first 50 lines from memory and then continue reading
  #seek(INFILE,0,0);

  $signature->{blankLines} = 0;
  $signature->{separator} = $separator;
  $iLine = 0;
  my $maxDiscreteValues = 50;
  my $columnNumericalArrays;

  #### Loop through file, collecting data on each column and row
  my $done = 0;
  my $line;
  while ( ! $done ) {

    #### Replay the first 50 lines from memory and then continue reading the file
    if ( $iLine < 50 ) {
      $line = $lines[$iLine];
      last unless ( $line );
    } else {
      $line = <INFILE>;
      last unless ( $line );
      $line =~ s/[\r\n]//g;
    }

    #### If this is an empty line, just record it as such and move on
    if ( $line eq '' || $line =~ /^\s+$/ ) {
      $signature->{blankLines}++;
      $iLine++;
      next;
    }

    #### Split the line
    my @columns = split( /$separator/, $line, -1 );
    my $nColumns = scalar(@columns);

    #### If the row is the column name row, then store that
    if ( $iLine == $columnHeaderRow ) {
      my $iColumn = 0;
      foreach my $value ( @columns ) {
        $signature->{"columns.$iColumn.columnName"} = $value;
        $iColumn++;
      }
    }

    #### If this is a data row, process it
    if ( $iLine >= $firstDataRow ) {
      $signature->{nRows}++;
      $signature->{columnsPerRow}->{$nColumns}++;
      my $iColumn = 0;
      foreach my $value ( @columns ) {
        if ( exists($signature->{"columns.$iColumn.discreteValues"}->{$value}) ) {
          $signature->{"columns.$iColumn.discreteValues"}->{$value}++;
        } else {
          unless ( $signature->{"columns.$iColumn.nDiscreteValues"} ) {
            $signature->{"columns.$iColumn.nDiscreteValues"} = 0;
            $signature->{"columns.$iColumn.discreteValueCountExceedsLimit"} = 0;
          }
          if ( $signature->{"columns.$iColumn.nDiscreteValues"} >= $maxDiscreteValues ) {
            $signature->{"columns.$iColumn.discreteValueCountExceedsLimit"} = 1;
          } else {
            $signature->{"columns.$iColumn.discreteValues"}->{$value}++;
            $signature->{"columns.$iColumn.nDiscreteValues"}++;
          }
        }

        #### Interpret the value to a data type
        my $datum = $value;
        my $dataType = '?';
        if ( ! defined($datum) ) { $dataType = 'undefined'; }
        elsif ( $datum =~ /^\s*NaN\s*$/ ) { $dataType = 'undefined'; }
        elsif ( $datum =~ /^\s*\-*Inf\s*$/ ) { $dataType = 'undefined'; }
        elsif ( $datum =~ /^\s*null\s*$/i ) { $dataType = 'undefined'; }
        elsif ( $datum =~ /^\s*undef\s*$/ ) { $dataType = 'undefined'; }
        elsif ( $datum =~ /^\s*None\s*$/ ) { $dataType = 'undefined'; }
        elsif ( $datum =~ /^\s*$/ ) { $dataType = 'empty'; }
        elsif ( $datum =~ /^\s*[\+\-]*\d+\s*$/ ) { $dataType = 'integer'; }
        elsif ( $datum =~ /^\s*[\+\-]*\d+\.[\d]*\s*$/ ) { $dataType = 'float'; }
        elsif ( $datum =~ /^\s*[\+\-]*\.[\d]+\s*$/ ) { $dataType = 'float'; }
        elsif ( $datum =~ /^\s*[\+\-]*\d+\.[\d]*[ed][\+\-]*\d+\s*$/ ) { $dataType = 'float'; }
        elsif ( $datum =~ /^\s*[\+\-]*\.[\d]+[ed][\+\-]*\d+\s*$/ ) { $dataType = 'float'; }
        elsif ( $datum =~ /^\s*true\s*$/i || $datum =~ /^\s*false\s*$/i || $datum =~ /^\s*t\s*$/i || $datum =~ /^\s*f\s*$/i ) { $dataType = 'boolean'; }
        else { $dataType = 'string'; }
        $signature->{"columns.$iColumn.dataType"}->{$dataType}++;

        #### If this is a number, keep it in an array for mean and median calculation
        if ( $dataType eq 'integer' || $dataType eq 'float' ) {
          $columnNumericalArrays->[$iColumn]->{array} = [] unless ($columnNumericalArrays->[$iColumn]->{array});
          push(@{$columnNumericalArrays->[$iColumn]->{array}},$datum);
          $columnNumericalArrays->[$iColumn]->{nNonNullElements}++;
        }

        #### Increment and continue
        $iColumn++;
      }
    }

    $iLine++;
  }

  close(INFILE);
  untie(*INFILE);

  #### For each column, calculate a median and SIQR
  my $iColumn = 0;
  foreach my $column ( @{$columnNumericalArrays} ) {
    if ( $column ) {
      my @sortedNumbers = sort numerically @{$column->{array}};
      my $nElements = $column->{nNonNullElements};
      $signature->{"columns.$iColumn.median"} = $sortedNumbers[$nElements/2];
      $signature->{"columns.$iColumn.siqr"} = ( $sortedNumbers[$nElements*3/4] - $sortedNumbers[$nElements*1/4] ) / 2;
    }
    $iColumn++;
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

sub numerically {
###############################################################################
# numerically
# sorting routine to sort numbers as numbers instead of strings
###############################################################################
  return $a <=> $b;
}


sub numericallyBySecondValue {
###############################################################################
# numericallyBySecondValue
# sorting routine to sort numbers in the value part of a has turned into an array
###############################################################################
  return $a->[1] <=> $b->[1];
}



sub setSignatureAttributeDescriptions {
###############################################################################
# setSignatureAttributeDescriptions
###############################################################################
  my $METHOD = 'setSignatureAttributeDescriptions';
  print "DEBUG: Entering $CLASS.$METHOD\n" if ( $DEBUG );
  my $self = shift || die ("self not passed");
  my $qckb = shift || die ("qckb not passed");

  return if ( exists($qckb->{signatureInfo}->{"FileSignature::Tabular.nRows"}->{friendlyName}) );

  my $info = $qckb->{signatureInfo};

  $info->{"FileSignature::Tabular.nRows"}->{friendlyName} = "number of data rows";
  $info->{"FileSignature::Tabular.nRows"}->{sideName}->{upper} = "greater than";
  $info->{"FileSignature::Tabular.nRows"}->{sideName}->{lower} = "less than";

  $info->{"FileSignature::Tabular.commentCharacter"}->{friendlyName} = "comment character";
  $info->{"FileSignature::Tabular.commentCharacter"}->{sideName}->{upper} = "different from";
  $info->{"FileSignature::Tabular.commentCharacter"}->{sideName}->{lower} = "different from";

  $info->{"FileSignature::Tabular.nCommentLines"}->{friendlyName} = "number of comment lines";
  $info->{"FileSignature::Tabular.nCommentLines"}->{sideName}->{upper} = "greater than";
  $info->{"FileSignature::Tabular.nCommentLines"}->{sideName}->{lower} = "less than";

  $info->{"FileSignature::Tabular.hasColumnNames"}->{friendlyName} = "presence of column names";
  $info->{"FileSignature::Tabular.hasColumnNames"}->{sideName}->{upper} = "different from";
  $info->{"FileSignature::Tabular.hasColumnNames"}->{sideName}->{lower} = "different from";

  $info->{"FileSignature::Tabular.nColumns"}->{friendlyName} = "number of columns";
  $info->{"FileSignature::Tabular.nColumns"}->{sideName}->{upper} = "greater than";
  $info->{"FileSignature::Tabular.nColumns"}->{sideName}->{lower} = "less than";

  $info->{"FileSignature::Tabular.blankLines"}->{friendlyName} = "number of blank lines";
  $info->{"FileSignature::Tabular.blankLines"}->{sideName}->{upper} = "greater than";
  $info->{"FileSignature::Tabular.blankLines"}->{sideName}->{lower} = "less than";

  $info->{"FileSignature::Tabular.columnsPerRow"}->{friendlyName} = "histogram of number of columns per row";
  $info->{"FileSignature::Tabular.columnsPerRow"}->{sideName}->{upper} = "different from";
  $info->{"FileSignature::Tabular.columnsPerRow"}->{sideName}->{lower} = "different from";

  for ( my $i=0; $i < 50; $i++ ) {
    $info->{"FileSignature::Tabular.columns.$i.discreteValues"}->{friendlyName} = "histogram of discrete values in column $i";
    $info->{"FileSignature::Tabular.columns.$i.discreteValues"}->{sideName}->{upper} = "different from";
    $info->{"FileSignature::Tabular.columns.$i.discreteValues"}->{sideName}->{lower} = "different from";

    $info->{"FileSignature::Tabular.columns.$i.nDiscreteValues"}->{friendlyName} = "number of discrete values in column $i";
    $info->{"FileSignature::Tabular.columns.$i.nDiscreteValues"}->{sideName}->{upper} = "greater than";
    $info->{"FileSignature::Tabular.columns.$i.nDiscreteValues"}->{sideName}->{lower} = "less than";

    $info->{"FileSignature::Tabular.columns.$i.discreteValueCountExceedsLimit"}->{friendlyName} = "flag for exceeding the maximum number of discrete values in column $i";
    $info->{"FileSignature::Tabular.columns.$i.discreteValueCountExceedsLimit"}->{sideName}->{upper} = "different from";
    $info->{"FileSignature::Tabular.columns.$i.discreteValueCountExceedsLimit"}->{sideName}->{lower} = "different from";

    $info->{"FileSignature::Tabular.columns.$i.dataType"}->{friendlyName} = "histogram of data types for column $i";
    $info->{"FileSignature::Tabular.columns.$i.dataType"}->{sideName}->{upper} = "different from";
    $info->{"FileSignature::Tabular.columns.$i.dataType"}->{sideName}->{lower} = "different from";

    $info->{"FileSignature::Tabular.columns.$i.median"}->{friendlyName} = "median numerical value for column $i";
    $info->{"FileSignature::Tabular.columns.$i.median"}->{sideName}->{upper} = "greater than";
    $info->{"FileSignature::Tabular.columns.$i.median"}->{sideName}->{lower} = "less than";

    $info->{"FileSignature::Tabular.columns.$i.siqr"}->{friendlyName} = "spread (SIQR) of numerical values for column $i";
    $info->{"FileSignature::Tabular.columns.$i.siqr"}->{sideName}->{upper} = "greater than";
    $info->{"FileSignature::Tabular.columns.$i.siqr"}->{sideName}->{lower} = "less than";

    $info->{"FileSignature::Tabular.columns.$i.columnName"}->{friendlyName} = "column title for column $i";
    $info->{"FileSignature::Tabular.columns.$i.columnName"}->{sideName}->{upper} = "different from";
    $info->{"FileSignature::Tabular.columns.$i.columnName"}->{sideName}->{lower} = "different from";
  }

  return;
}


###############################################################################
1;
