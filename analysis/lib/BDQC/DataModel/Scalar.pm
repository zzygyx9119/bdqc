package BDQC::DataModel::Scalar;

###############################################################################
# Class       : BDQC::DataModel::Scalar
#
# Description : This class is autogenerated via generatePerlClasses.pl and
#
###############################################################################

use strict;
use warnings;

use BDQC::Response qw(processParameters);

my $CLASS = 'BDQC::DataModel::Scalar';
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
  my $vector = processParameters( name=>'vector', required=>0, allowUndef=>0, parameters=>\%parameters, caller=>$METHOD );
  $self->{_vector} = $vector;

  #### BEGIN CUSTOMIZATION. DO NOT EDIT MANUALLY ABOVE THIS. EDIT MANUALLY ONLY BELOW THIS.




  #### END CUSTOMIZATION. DO NOT EDIT MANUALLY BELOW THIS. EDIT MANUALLY ONLY ABOVE THIS.

  #### Complain about any unexpected parameters
  my $unexpectedParameters = '';
  foreach my $parameter ( keys(%parameters) ) { $unexpectedParameters .= "ERROR: unexpected parameter '$parameter'\n"; }
  die("CALLING ERROR [$METHOD]: $unexpectedParameters") if ($unexpectedParameters);

  print "DEBUG: Exiting $CLASS.$METHOD\n" if ( $DEBUG );
  return($self);
}


sub getVector {
###############################################################################
# getVector
###############################################################################
  my $METHOD = 'getVector';
  print "DEBUG: Entering $CLASS.$METHOD\n" if ( $DEBUG );
  my $self = shift || die("parameter self not passed");

  print "DEBUG: Exiting $CLASS.$METHOD\n" if ( $DEBUG );
  return($self->{_vector});
}


sub setVector {
###############################################################################
# setVector
###############################################################################
  my $METHOD = 'setVector';
  print "DEBUG: Entering $CLASS.$METHOD\n" if ( $DEBUG );
  my $self = shift || die("parameter self not passed");
  my $value = shift;


  $self->{_vector} = $value;
  print "DEBUG: Exiting $CLASS.$METHOD\n" if ( $DEBUG );
  return 1;
}


sub create {
###############################################################################
# create
###############################################################################
  my $METHOD = 'create';
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
  my $vector = processParameters( name=>'vector', required=>0, allowUndef=>0, parameters=>\%parameters, caller=>$METHOD, response=>$response );
  if ( ! defined($vector) ) {
    $vector = $self->getVector();
  } else {
    $self->setVector($vector);
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

  ## Need some better sanity checking here?

  my $nElements = 0;
  my %typeCounts = ( undefined=>0, empty=>0, integer=>0, float=>0, boolean=>0, string=>0 );
  my $stats = { sum=>0, mean=>0, nonNullElements=>0, minimum=>undef, maximum=>undef, median=>0, siqr=>0 };
  my %observedValues = ();

  #### Scan through the vector compiling the number of each type of value
  my @deviations = ();
  my @cleanedVector = ();
  foreach my $datum ( @{$vector} ) {
    $nElements++;
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
    $typeCounts{$dataType}++;

    #### Add to the hash of all the observed values, although undef becomes null
    my $datumOrNull = $datum;
    $datumOrNull = 'null' if ( ! defined($datum) );
    $observedValues{$datumOrNull}++;

    #### For a datatype of string, convert the string to a number for calculation of distributions
    my $value = $datum;
    if ( $dataType eq 'string' ) {
      my $asciiAverage;
      for (my $i=0; $i<length($datum); $i++) {
        $asciiAverage += ord(substr($datum,$i,1));
      }
      my $datumLength = length($datum) || 1;
      $asciiAverage /= $datumLength;
      $value = length($datum) + $asciiAverage;
    }
    #print "** datum=$datum, value=$value, dataType=$dataType\n";

    #### Keep some stats to calculate a mean and standard deviation
    if ( $dataType eq 'integer' || $dataType eq 'float' || $dataType eq 'string' ) {
      $stats->{sum} += $value;
      $stats->{nonNullElements}++;
      if ( ! defined($stats->{minimum}) ) {
        $stats->{minimum} = $value;
	$stats->{maximum} = $value;
      } else {
	$stats->{minimum} = $value if ( $value < $stats->{minimum} );
	$stats->{maximum} = $value if ( $value > $stats->{maximum} );
      }
    }

    #### Add this datum to the deviations vector
    push(@deviations, { dataType=>$dataType, datum=>$datum, value=>$value, deviation=>0, deviationFlag=>'normal' } );
    if ( $dataType ne 'undefined' && $dataType ne 'empty' ) {
      push(@cleanedVector,$value);
    }

  } # end foreach $datum


  #### Set up rules for dealing with nulls
  $stats->{nullStatus} = "noNulls";
  if ( $stats->{nonNullElements} != $nElements ) {
    my $outlierEdgeNumber = getOutlierEdgeNumber($nElements);
    #print "**nElements=$nElements, outlierEdgeNumber=$outlierEdgeNumber, nonNullElements=$stats->{nonNullElements}\n";
    if ( $stats->{nonNullElements} == 0 ) {
      $stats->{nullStatus} = "allNulls";
    } elsif ( $stats->{nonNullElements} <= $outlierEdgeNumber ) {
      $stats->{nullStatus} = "nullIsNormal";
    } elsif ( $nElements - $stats->{nonNullElements} <= $outlierEdgeNumber ) {
      $stats->{nullStatus} = "nonNullIsNormal";
    } else {
      $stats->{nullStatus} = "nullIsPartOfNormal";
    }
  }


  #### Caclulate the mean
  if ( $stats->{nonNullElements} ) {
    $stats->{mean} = $stats->{sum} / $stats->{nonNullElements};
  }

  #### Record some additional stats
  $stats->{nElements} = $nElements;
  $stats->{nDistinctValues} = scalar(keys(%observedValues));


  #### Try to decide the most likely dataType based on simple heuristics, allowing for missing values
  my $dataType = 'unknown';
  if ( $typeCounts{undefined} + $typeCounts{empty} + $typeCounts{integer} == $nElements ) {
    $dataType = 'integer';
  } elsif ( $typeCounts{undefined} + $typeCounts{empty} + $typeCounts{integer} + $typeCounts{float} == $nElements ) {
    $dataType = 'float';
  } elsif ( $typeCounts{undefined} + $typeCounts{empty} + $typeCounts{boolean} == $nElements ) {
    $dataType = 'boolean';
  } else {
    $dataType = 'string';
  }


  #### Determine a few classes of basic distributions (like allIdentical, TwoValued, allDifferent)
  my $nObservedValues = scalar(keys(%observedValues));
  my $distributionFlags = { allIdentical=>0, twoValued=>0, allDifferent=>0 };
  if ( $nObservedValues == 1 ) {
    $distributionFlags->{allIdentical} = 1;
  } elsif ( $nObservedValues == 2 ) {
    $distributionFlags->{twoValued} = 1;
  } elsif ( $nObservedValues == $nElements ) {
    $distributionFlags->{allDifferent} = 1;
  }

  #### If all the values are the same, then there's no point calculating stuff
  if ( $distributionFlags->{allIdentical} ) {
    if ( $dataType eq 'string' or $dataType eq 'boolean' ) {
      $stats->{median} = 0;
    } else {
      $stats->{median} = $vector->[0];
    }
   
  #### Or if there are fewer than 3 values, then there's no point calculating stuff
  } elsif ( $stats->{nonNullElements} < 3 ) {
    $stats->{median} = $vector->[0];
   
  #### But if there is variation, then assess it
  } else {

    #### Calculate median and siqr
    my @sortedVector = sort numerically @cleanedVector;
    my $nElements = scalar(@sortedVector);
    $stats->{median} = $sortedVector[$nElements/2];
    $stats->{siqr} = 0;
    if ( defined($sortedVector[$nElements/4*3]) && defined($sortedVector[$nElements/4]) ) {
      $stats->{siqr} = ( ( $sortedVector[$nElements/4*3] - $sortedVector[$nElements/4] ) / 2 );
    }
    #print "Input: ".join(",",@sortedVector)."\n";
    my @sortedVectorSomeOutliersRemoved = removeSomeOutliers(@sortedVector);
    #print "Output: ".join(",",@sortedVectorSomeOutliersRemoved)."\n";
    my $sum = 0;
    foreach my $value ( @sortedVectorSomeOutliersRemoved ) {
      $sum += $value;
    }
    my $newNElements = scalar(@sortedVectorSomeOutliersRemoved) || 1;
    $stats->{adjustedMean} = $sum/$newNElements;
    $sum = 0;
    foreach my $value ( @sortedVectorSomeOutliersRemoved ) {
      $sum += ($value-$stats->{adjustedMean})**2;
    }
    $stats->{adjustedStdev} = sqrt($sum/$newNElements);


    #### New experimental code to assess the degree of outliers rather than using the standard deviation
    my %gapStats;
    my $newCodeDebug = 0;

    #### Assess how big the gaps are for the potential outliers
    if ( $stats->{nonNullElements} > 15 ) {
      my @sortedVector = sort numerically @cleanedVector;
      my $nElements = scalar(@sortedVector);
      my $halfNElements = int($nElements/2);
      my $nFirstQuartile = int($nElements * 0.25);
      my $nThirdQuartile = int($nElements * 0.75);

      my $outlierFraction = 0.15;
      $outlierFraction = 0.10 if ( $nElements > 100 );
      $outlierFraction = 0.05 if ( $nElements > 1000 );

      #### Assess the upper half of the distribution
      my @halfVector = @sortedVector[$nFirstQuartile..($nElements-1)];
      my @compoundHalfVector;
      my @deltas;
      my $maxDelta = 0;
      for ( my $i=0; $i<scalar(@halfVector)-1; $i++) {
	my $delta = $halfVector[$i+1] - $halfVector[$i];
	$maxDelta = $delta if ( $delta > $maxDelta );
        push(@deltas, $delta);
	my %attributes = ( value=>$halfVector[$i+1], delta=>$delta, previousValue=>$halfVector[$i], nFromEnd=>scalar(@halfVector)-2-$i );
	push(@compoundHalfVector,\%attributes);
      }

      my @normalizedDeltas;
      my $i = 0;
      foreach my $delta ( @deltas ) {
	push(@normalizedDeltas, $delta / ($maxDelta||1) );
	$compoundHalfVector[$i]->{normalizedDelta} = $delta / ($maxDelta||1);
	$i++;
      }
      my @sortedDeltas = reverse sort numerically @normalizedDeltas;
      my @sortedCompoundHalfVector = sort byNormalizedDelta @compoundHalfVector;

      my @roundedDeltas;
      for ( my $i=0; $i<10; $i++) {
	push(@roundedDeltas,sprintf("%.3f",$sortedDeltas[$i]));
      }
      print join(",",@roundedDeltas)."\n" if ( $newCodeDebug );

      $gapStats{median} = $stats->{median};
      $gapStats{upper}->{normalBound} = $stats->{maximum};
      $gapStats{lower}->{normalBound} = $stats->{minimum};


      if ( $sortedCompoundHalfVector[1]->{normalizedDelta} <= 0.6 && $sortedCompoundHalfVector[1]->{normalizedDelta} != 0.0 ) {
	print "RESULT: Outlier flagged with delta $sortedCompoundHalfVector[1]->{normalizedDelta} at or above $sortedCompoundHalfVector[0]->{value} ($sortedCompoundHalfVector[0]->{nFromEnd} elements from end)\n" if ( $newCodeDebug );
	if ( $sortedCompoundHalfVector[0]->{nFromEnd} > $nElements * $outlierFraction ) {
	  print "  oops, but nFromEnd is above $nFirstQuartile, so discount that\n" if ( $newCodeDebug );
        } else {
	  my $thisGap = $sortedCompoundHalfVector[0]->{delta};
	  my $nextGap = $sortedCompoundHalfVector[1]->{delta};
	  my $gapFactor = 0;
	  if ( $nextGap ) {
	    $gapFactor = $thisGap / $nextGap;
  	  } else {
	    $gapFactor = 2.5;
          }
	  #### Set deviations to 2.25 times the next gap. This is an arbitrary scaling factor
	  #### to align Eric's perceived gaps to sensitivity cutoffs high=3, med=5, low=10
	  my $gapDeviations = $gapFactor * 2.25;
	  print "  This gap was $thisGap. The next biggest gap was $nextGap. gapFactor=$gapFactor. gapDeviations=$gapDeviations\n" if ( $newCodeDebug );

	  $gapStats{upper}->{triggerGap} = $thisGap;
	  $gapStats{upper}->{gapDeviations} = $gapDeviations;
	  $gapStats{upper}->{triggerValue} = $sortedCompoundHalfVector[0]->{value};
	  $gapStats{upper}->{normalBound} = $sortedCompoundHalfVector[0]->{value} - $thisGap;
	  $gapStats{upper}->{deviationScale} = $gapDeviations / ($thisGap||1);
	  if ( $newCodeDebug ) {
	    print "  ## upper triggerGap = $gapStats{upper}->{triggerGap}\n";
	    print "  ## upper gapDeviations = $gapStats{upper}->{gapDeviations}\n";
	    print "  ## upper triggerValue = $gapStats{upper}->{triggerValue}\n";
	    print "  ## upper normalBound = $gapStats{upper}->{normalBound}\n";
	    print "  ## upper deviationScale = $gapStats{upper}->{deviationScale}\n";
	  }
        }

      }

      #### Assess the lower half of the distribution
      @halfVector = @sortedVector[0..$nThirdQuartile];         #
      @compoundHalfVector = ();
      @deltas = ();
      $maxDelta = 0;
      for ( my $i=0; $i<scalar(@halfVector)-1; $i++) {
	my $delta = $halfVector[$i+1] - $halfVector[$i];
	$maxDelta = $delta if ( $delta > $maxDelta );
        push(@deltas, $delta);
	my %attributes = ( value=>$halfVector[$i], delta=>$delta, previousValue=>$halfVector[$i+1], nFromEnd=>$i );    #
	push(@compoundHalfVector,\%attributes);
      }

      @normalizedDeltas = ();
      $i = 0;
      foreach my $delta ( @deltas ) {
	push(@normalizedDeltas, $delta / ($maxDelta||1) );
	$compoundHalfVector[$i]->{normalizedDelta} = $delta / ($maxDelta||1);
	$i++;
      }
      @sortedDeltas = reverse sort numerically @normalizedDeltas;
      @sortedCompoundHalfVector = sort byNormalizedDelta @compoundHalfVector;

      @roundedDeltas = ();
      for ( my $i=0; $i<10; $i++) {
	push(@roundedDeltas,sprintf("%.3f",$sortedDeltas[$i]));
      }
      print join(",",@roundedDeltas)."\n" if ( $newCodeDebug );

      if ( $sortedCompoundHalfVector[1]->{normalizedDelta} <= 0.6 && $sortedCompoundHalfVector[1]->{normalizedDelta} != 0.0 ) {
	print "RESULT: Outlier flagged with delta $sortedCompoundHalfVector[1]->{normalizedDelta} at or below $sortedCompoundHalfVector[0]->{value} ($sortedCompoundHalfVector[0]->{nFromEnd} elements from end)\n" if ( $newCodeDebug );  #
	if ( $sortedCompoundHalfVector[0]->{nFromEnd} > $nElements * $outlierFraction ) {
	  print "  oops, but nFromEnd is above $nFirstQuartile, so discount that\n" if ( $newCodeDebug );
        } else {
	  my $thisGap = $sortedCompoundHalfVector[0]->{delta};
	  my $nextGap = $sortedCompoundHalfVector[1]->{delta};
	  my $gapFactor = 0;
	  if ( $nextGap ) {
	    $gapFactor = $thisGap / $nextGap;
  	  } else {
	    $gapFactor = 5;
          }
	  #### Set deviations to 2.25 times the next gap. This is an arbitrary scaling factor
	  #### to align Eric's perceived gaps to sensitivity cutoffs high=3, med=5, low=10
	  my $gapDeviations = $gapFactor * 2.25;
	  print "  This gap was $thisGap. The next biggest gap was $nextGap. gapFactor=$gapFactor. gapDeviations=$gapDeviations\n" if ( $newCodeDebug );

	  $gapStats{lower}->{triggerGap} = $thisGap;
	  $gapStats{lower}->{gapDeviations} = $gapDeviations;
	  $gapStats{lower}->{triggerValue} = $sortedCompoundHalfVector[0]->{value};
	  $gapStats{lower}->{normalBound} = $sortedCompoundHalfVector[0]->{value} + $thisGap;
	  $gapStats{lower}->{deviationScale} = $gapDeviations / ($thisGap||1);
        }
      }

    }
    print "\n" if ( $newCodeDebug );

    #### Calculate the extremities at 3 times SIQR and outliers at 5 times SIQR
    my $iValue = 0;
    $stats->{variance} = 0;
    my $siqr = $stats->{siqr} || $stats->{stdev} || $stats->{mean}/10 || 1;
    foreach my $datum ( @{$vector} ) {
      my $value = $datum;
      if ( $dataType eq 'string' ) {
        $value = $deviations[$iValue]->{value};
      }

      #### If the value is not null, then add to the variance
      if ( defined($value) && defined($stats->{mean}) ) {
        $stats->{variance} += ( ( ($value||0) - ($stats->{mean}||0) )**2 );
      }

      #### Set a default deviation flag
      my $deviation = 997;

      #### Calculate deviations based on gap stats
      if ( $gapStats{lower} ) {

	#### For the upper part of the distribution
	if ( defined($value) && defined($gapStats{median}) && $value >= $gapStats{median} ) {
	  if ( $value <= $gapStats{upper}->{normalBound} ) {
	    my $factor = ( $gapStats{upper}->{normalBound} - $gapStats{median} ) || 1;
	    my $delta = $value - $gapStats{median};
	    $deviation = 2.9 * $delta / $factor;
	  } else {
	    my $delta = ( $value - $gapStats{upper}->{normalBound} ) * $gapStats{upper}->{deviationScale};
	    $deviation = $delta;
	  }

	#### For the lower part of the distribution
        } elsif ( defined($value) ) {
	  if ( $value >= $gapStats{lower}->{normalBound} ) {
	    my $factor = ( $gapStats{median} - $gapStats{lower}->{normalBound} ) || 1;
	    my $delta = $gapStats{median} - $value;
	    $deviation = -2.9 * $delta / $factor;
	  } else {
	    my $delta = ( $gapStats{lower}->{normalBound} - $value ) * $gapStats{lower}->{deviationScale};
	    $deviation = -1 * $delta;
	  }
        }

      #### Otherwise, base the deviation on the value and SIQR if available
      } elsif ( defined($value) && defined($siqr) ) {

        #### Now try calculating the deviation based on a mean and stdev after some crude extreme value removal if available
        if ( defined($stats->{adjustedMean}) && $stats->{adjustedStdev} ) {
          $deviation = ( ($value||0) - ($stats->{adjustedMean}||0) ) / $stats->{adjustedStdev};
	  #print "==adjustedMean=$stats->{adjustedMean}, adjustedStdev=$stats->{adjustedStdev}, value=$value, deviation=$deviation\n";

        #### Else fall back to the original crude mechanism
        } elsif ( defined($stats->{median}) && $siqr ) {
          #### First attempt based simply on the median and the SIQR. Crude.
          $deviation = ( ($value||0) - ($stats->{median}||0) ) / $siqr;
	  #print "++median=$stats->{median}, siqr=$siqr, value=$value, deviation=$deviation\n";

        #### This is probably a two-values or weird distribution, just give up
        } else {
	  $deviation = 0.11111;
	  #print "--adjustedMean=$stats->{adjustedMean}, adjustedStdev=$stats->{adjustedStdev}, value=$value, deviation=$deviation\n";
        }
      }


      #### If the value is undefined, apply special rules for the deviation
      if ( $deviations[$iValue]->{dataType} eq "undefined" || $deviations[$iValue]->{dataType} eq 'empty' ) {
	if ( $stats->{nullStatus} eq "allNulls" || $stats->{nullStatus} eq "nullIsNormal"
             || $stats->{nullStatus} eq "nullIsPartOfNormal" ) {
	  $deviation = 0;
        }

      #### If the value is not undefined, but we've determined that null is the sole normal,
      #### then force the defined value to be an outlier
      } elsif ( $stats->{nullStatus} eq "nullIsNormal" ) {
	$deviation = 998;
      }

      #### Record the calculated deviation value
      $deviations[$iValue]->{deviation} = $deviation;

      my $flag = 'normal';
      $flag = 'extremity' if ( abs($deviation) >= 5 );
      $flag = 'outlier' if ( abs($deviation) >= 10 );

      #### Protect against undefined values
      my $datumOrNull = $datum;
      $datumOrNull = 'null' if ( !defined($datum) );

      #### Or if this is a two-valued distribution with only 1 or 2 outliers, then mark as an outlier
      #### Somewhat specialized, arbitrary rules
      if ( $distributionFlags->{twoValued} ) {

	#### If there is a singleton in a two-valued distribution
        if ( $observedValues{$datumOrNull} == 1 ) {
	  if ( $nElements > 2 ) {
	    $flag = 'extremity';
	    $deviations[$iValue]->{deviation} = 3;
	  }
	  if ( $nElements > 4 ) {
	    $flag = 'outlier';
	    $deviations[$iValue]->{deviation} = 11;
	  }

	#### Else if there are two items in a two-valued distribution
        } elsif ( $observedValues{$datumOrNull} == 2 ) {
	  if ( $nElements > 5 ) {
	    $flag = 'extremity';
	    $deviations[$iValue]->{deviation} = 3;
	  }
	  if ( $nElements > 9 ) {
	    $flag = 'outlier';
	    $deviations[$iValue]->{deviation} = 11;
	  }
        }

	#print "twoValued: adjustedMean=$stats->{adjustedMean}, datumOrNull=$datumOrNull, obs=$observedValues{$datumOrNull}, deviation=$deviations[$iValue]->{deviation}\n";
      }
        
      $deviations[$iValue]->{deviationFlag} = $flag;
      $deviations[$iValue]->{value} = $value;

      print " ****\t$iValue\t$value\t$deviation\t$flag\n" if ( $newCodeDebug );

      $iValue++;
    }    

    #### Calculate the stdev
    if ( defined($stats->{variance}) && $stats->{nonNullElements} ) {
      $stats->{stdev} = sqrt( $stats->{variance}/$stats->{nonNullElements} );
    }

  } # end else (not allIdentical)


  #### Store the information gleaned into the model in the response
  $response->{model} = { dataType=>$dataType, typeCounts=>\%typeCounts, observedValues=>\%observedValues,
    distributionFlags=>$distributionFlags, stats=>$stats, deviations=>\@deviations };



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
  my $vector = $self->getVector() || '';
  $buffer .= "  vector=$vector\n";

  print "DEBUG: Exiting $CLASS.$METHOD\n" if ( $DEBUG );
  return $buffer;
}


sub numerically {
###############################################################################
# numerically
# sorting routine to sort numbers but allow for missing values, which sort first
###############################################################################
  if ( ( (! defined($a)) || $a =~ /^\s*$/) && ( (! defined($b)) || $b =~ /^\s*$/) ) {
    return 0;
  } elsif ( (! defined($a)) || $a =~ /^\s*$/ ) {
    return -1;
  } elsif ( ! defined($b) || $b =~ /^\s*$/ ) {
    return 1;
  }
  return $a <=> $b;
}


sub byNormalizedDelta {
###############################################################################
# byNormalizedDelta
# sorting routine for an array of hashes by normalizedDelta: reversed
###############################################################################
  return $b->{normalizedDelta} <=> $a->{normalizedDelta};
}


sub removeSomeOutliers {
###############################################################################
# removeSomeOutliers
# Gets as input a sorted numerical vector with nulls removed
# Trims a reasonable number from the ends if they seem extreme
###############################################################################
  my @cleanedSortedVector = @_;

  my @deltas;
  my $nElements = scalar(@cleanedSortedVector);

  #### If there aren't even 3 datapoints, just return what came in
  if ( $nElements < 3 ) {
    return(@cleanedSortedVector);
  }

  #### Calculate the deltas of all the data points
  for (my $i=0; $i<$nElements-1; $i++) {
    push(@deltas,$cleanedSortedVector[$i+1]-$cleanedSortedVector[$i]);
  }

  #### Find the median of the deltas
  my @sortedDeltas = sort numerically @deltas;
  my $medianDelta = $sortedDeltas[$nElements/2-1];

  #### Set a reasonable number of points to potentially reject
  my $nPointsToReject = 1;
  $nPointsToReject = 2 if ( $nElements >= 5 );
  $nPointsToReject = 3 if ( $nElements >= 8 );
  $nPointsToReject = 4 if ( $nElements >= 12 );
  $nPointsToReject = 5 if ( $nElements >= 20 );
  $nPointsToReject = 6 if ( $nElements >= 30 );
  $nPointsToReject = $nElements*0.15 if ( $nElements >= 50 );
  $nPointsToReject = $nElements*0.05+10 if ( $nElements >= 100 );

  #### Loop through the sorted vector discarding either the first or last, whichever is farther
  #### This should be better FIXME
  while ( $nPointsToReject > 0 ) {
    my $nElementsLeft = scalar(@cleanedSortedVector);
    my $i=0;
    my $lowerDelta = $cleanedSortedVector[$i+1]-$cleanedSortedVector[$i];
    $i=$nElementsLeft-2;
    my $upperDelta = $cleanedSortedVector[$i+1]-$cleanedSortedVector[$i];

    if ( $lowerDelta > $upperDelta ) {
      shift(@cleanedSortedVector);
    } else {
      pop(@cleanedSortedVector);
    }
    $nPointsToReject--;
  }

  return @cleanedSortedVector;  
}


sub getOutlierEdgeNumber {
###############################################################################
# getOutlierEdgeNumber
# Based on the input number, return a somewhat subjective number of the maximum
# number of outliers permitted. More than this number of aberrant values would
# then be considered part of normal.
###############################################################################
  my $population = shift;
  die ("ERROR: getOutlierEdgeNumber requires a positive integer") if ( ! defined($population) );
  my @lowNumbers = ( 0,0,0,1,1,1,2,2,2,2,3 );
  return $lowNumbers[$population] if ( $population <= 10 );
  return int($population/5)+1 if ( $population <= 20 );
  return int($population/10)+3 if ( $population <= 50 );
  return int($population/15)+5 if ( $population <= 100 );
  return int($population*0.04)+7 if ( $population <= 1000 );
  return int($population*0.02)+47 if ( $population <= 10000 );
  return int($population*0.01)+127;
}


###############################################################################
1;
