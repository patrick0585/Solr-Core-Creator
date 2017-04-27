# Solr-Core-Creator

simple creation of new cores for solr

## Getting Started

Set the following variables:

```
SOLRHOME    path to the solr home directory

```
Set SOLRHOME during execution of the script with the following option:
```
./solr_core_creator.sh --core <CORENAME> --solrpath <PATH TO SOLR HOME DIR>
```

or the SOLRHOME variable inside the script
```
SOLRHOME="path to solr home directory"
```

## Usage

### Mandatory script parameter

Start the script with a name for the core that will be created
```
./solr_core_creator.sh --core <CORENAME> --conf <SOLR CONF DIR> --lib <SOLR LIB DIR>
```
Set the Solr Configration Directory that will be linked as an symbolic 
link inside the new core
```
./solr_core_creator.sh --core <CORENAME> [-c, --conf] <CONFIG DIRECTORY>
```

Set the Solr Library Directory that will be linked as an symbolic link
inside the new core
```
./solr_core_creator.sh --core <CORENAME> [-l, --lib] <LIBRARY DIRECTORY>
```

### Optional script parameter

Print the help
```
./solr_core_creator.sh [-h, --help]
```

Activate or Deactivate that solr will restart after the creation of a new 
core. Default value ist "true"
```
./solr_core_creator.sh --core <CORENAME> --restart false
```

## Authors

* **Patrick Kowalik** - *Initial work* - [patrick0585](https://github.com/patrick0585)
