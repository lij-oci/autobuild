#
# $Id$
#

package WinCEMake;

use strict;
use warnings;

use Cwd;

###############################################################################
# Constructor

sub new
{
    my $proto = shift;
    my $class = ref ($proto) || $proto;
    my $self = {};

    bless ($self, $class);
    return $self;
}

##############################################################################

sub CheckRequirements ()
{
    my $self = shift;
    my $root = main::GetVariable ('root');

    if (!defined $root) {
        print STDERR __FILE__, ": Requires \"root\" variable\n";
        return 0;
    }
    
    if (!-r $root || !-d $root) {
        print STDERR __FILE__, ": Cannot access \"root\" directory: $root\n";
        return 0;
    }

    return 1;
}

##############################################################################

sub Run ($)
{
    my $self = shift;
    my $options = shift;
    my $root = main::GetVariable ('root');
    my $project_root = main::GetVariable ('project_root');

    # chop off trailing slash
    if ($root =~ m/^(.*)\/$/) {
        $root = $1;
    }

    main::PrintStatus ('Compile', 'wincemake');

    my $current_dir = getcwd ();
    
    my @dirs;
    my $dir='';
    if ($options =~ m/search='([^"]*)'/) {
        $dir = $1;
        @dirs = split(/,/, $1);
    }
    elsif ($options =~ m/search=([^\s]*)/) {
        $dir = $1;
        @dirs = split(/,/, $1);
    }
    $options =~ s/search=$dir//;

    if (!chdir $root) {
        print STDERR __FILE__, ": Cannot change to $root\n";
        return 0;
    }

    if (!defined $project_root) {
        $project_root = 'ACE_wrappers';
    }
    
    if (!chdir $project_root) {
        print STDERR __FILE__, ": Cannot change to $project_root\n";
        return 0;
    }

    my $basedir = getcwd();
    my $command = "evc $options";

# The idea here is to do a find starting at all the @dirs, looking for
# .vcw files and run evc on each. For now, need to specify all the
# .vcw (or .vcp) files directly in the options and run this for each one
# separately.
#    if ($dir) {
#        if(!chdir $dir) {
#            print STDERR __FILE__, ": Cannot change to $dir\n";
#            return 0; 
#        }
#    }

    print "Running: $command\n";

    my $ret = system ($command);

    if( $ret != 0  )
    {
        my $working_dir = getcwd();

        ## If we used 'make -C' to change the directory, let's
        ## append that information to the working_dir, so that we generate
        ## a more accurate error message.
        if( $command =~ /\-C\s+([\w\/]+)/  )
        {
            $working_dir = "$working_dir/$1"; 
        }

        print "[BUILD ERROR detected in $working_dir]\n ";
    } 

    chdir $current_dir;

    return 1;
}

##############################################################################

main::RegisterCommand ("wincemake", new WinCEMake ());
