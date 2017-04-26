#!/bin/bash
#===============================================================================
#
#          FILE:  solr_core_creator.sh
#
#         USAGE:  ./solr_core_creator.sh --core <CORENAME>
#
#   DESCRIPTION:  simple solr core creation
#
#       OPTIONS:  -h --help	help function
#		  -c --conf	link solr configuration path to the new core
#		  -l --lib	link solr library path to the new core
#		  --solrpath	set the solr home path
#		  --restart	restart solr after core creation. default is 'true'
#		  
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:  Patrick Kowalik, kowalik.patrick@online.de
#    REPOSITORY:  https://github.com/patrick0585/Solr-Core-Creator
#       COMPANY:  ---
#       VERSION:  1.0.2
#       CREATED:  30/04/2017 12:00:00 PM MDT
#      REVISION:  ---
#===============================================================================

VERSION=1.0.2
SOLRHOME="/opt/solr-5.3.2"
SOLRBINDIR="$SOLRHOME/bin"
SOLRBIN="$SOLRBINDIR/solr"
SOLRCORES="$SOLRHOME/server/solr"
SOLRCONFDIR="/home/xgwskow/projects/shops/shop217268/solr5/entw/conf"
SOLRLIBDIR="/home/xgwskow/projects/shops/shop217268/solr5/entw/lib"
SOLRCORENAME=""
SOLRRESTARTFLAG=true

# usage Message
usage="$(basename "$0") [--core, --conf, --lib, --restart] 
-- program to create a solr core --

where:
    -c, --conf		solr configuration path for the core	
    -l, --lib		solr library path for the core
    --restart		set TRUE to restart solr after creation of a solr core
    --core		set the name for the new solr core
    --solrpath		set the solr home path

"

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -c|--conf)
    SOLRCONFDIR="$2"
    shift
    ;;

    -l|--lib)
    SOLRLIBDIR="$2"
    shift
    ;;

    --restart)
    SOLRRESTARTFLAG="$2"
    shift
    ;;
 
    --core)
    SOLRCORENAME="$2"
    shift
    ;;

    --solrpath)
    SOLRHOME="$2"
    shift
    ;;

    -h|--help)
    echo "$usage" >&2
    exit 0
    ;;

    *)
    echo "unknown command"
    echo "$usage" >&2
    exit 0
    ;;
esac
shift
done

# check if core name was set
if [ -z "$SOLRCORENAME" ] || [ -z "$SOLRHOME" ];
then
    echo "no corename or solr-home set!"
    echo "set a corename with --core <NAME>"
    echo "set solr-home with --solrpath <PATH>"
    exit 0
fi

SOLRDIR="$SOLRCORES/$SOLRCORENAME"
SOLRCOREPROPS="$SOLRDIR/core.properties"

# Check if solr-core already exists
if [ -d $SOLRDIR ];
then
    echo "solr-core '$SOLRCORENAME' already exists!"
    exit
else
    echo "... start creating solr-core '$SOLRCORENAME'"
    
    # try to create solr directory
    if  sudo mkdir -p $SOLRDIR ;
    then
        echo ".... created directory: $SOLRCORENAME"
	
	# create data directory inside solr-core directory
	if sudo mkdir -p "$SOLRDIR/data" ;
        then
	    echo ".... created data-directory"
	else
	    echo ".... error creating data-directory"
	fi
	
	# fill core.properties file with content
	SOLRPROPCONTENT="name=$SOLRCORENAME"$'\nconfig=solrconfig.xml\nschema=schema.xml\ndataDir=data'
	sudo sh -c "echo '$SOLRPROPCONTENT' >> $SOLRCOREPROPS"
	
	# link conf directory
	if [ ! -z "$SOLRCONFDIR" ];
	then
	   sudo ln -s $SOLRCONFDIR $SOLRDIR
	fi

	# link lib directory
	if [ ! -z "$SOLRLIBDIR" ];
	then
	   sudo ln -s $SOLRLIBDIR $SOLRDIR
	fi

	# set rights for the new solr-core
	sudo sh -c "chown -R solr:solr $SOLRDIR"

	# restart solr if flag is set
	if [ "$SOLRRESTARTFLAG" = true ];
	then
	    sudo sh -c "$SOLRBIN restart"    
	fi
	
	echo "... solr-core '$SOLRCORENAME' successfully created"
    else
        echo ".... error creating directory: $SOLRCORENAME"
        exit
    fi 
fi
