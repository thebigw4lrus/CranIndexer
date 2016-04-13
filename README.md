# Cran Indexer
----------------------------------------
When it comes to R language packages, we may say that there is not a good tool for downloading, installing (managing in general).  They are used to use tools like apt, rpm and the package installer R-studio itself.  This proposal goes directly to contribute to these people offering a way to index such packages.

## This design provides 3 major modules:
    - Parser: It receives the Cran server url and takes care about reading the PACKAGES file (the packages definition).
    - Indexer: It trigger the process of enrich the information that was already gathered by the parser from the Package files 	(every package metadata is split in 2 pieces: one in the PACKAGES file and the other part in some description file inside the actual package).                            
	- Db: A singleton class here, will take care about gather and send all package in batches to the Database.
	- Package: Is not a module itself but a class. It represents a single package with its behaviour and attributes.
Basically the idea is to create packages based on on the PACKAGES file, in a batch way, which will be routed and controlled along all the execution until its end (which will be on the Database).

## Patterns used:
### singleton pattern
Among others obvious OO techniques, The singleton pattern was implemented on Db::Adapter class.  The reason of this is that we need only one single instance which gather all the ready to send packages.

### Observer pattern
In order to use what ruby provides in terms of this pattern, Observer module was mixed with Package class. This is because everytime that a package enrich its definition (go to Cran server and download the package description), an update in the Db::Adapter ready-to-send queue is required, so this adapter will take care of implement the batching and will trigger the bulk insertion.

### Composition
Composition and ruby mixings is present across all the design.


## The good, the bad and the ugly
### The good
- Short classes
- All the configuration is centralized in config/settings.yml
- Unit test / Integration tests are present
- Use of known patterns to break the logic into readable pieces

### The bad
- At this stage, this proposal as is written is not geographically scalable
- Probably more integration tests are required

### The ugly
- Package view was implemented with sinatra with no style definiton
- Error handling could be improved

##  What's next?
In terms of scrum, this would be the outcome of the very first sprint. This is usable but not geographically distributable.
I will propose for the future implement some message bus log-centric system (like kafka or rabbit mq), so we could have the same components but with a little of effort, talking through this message bus (i.e.: Parser parse the PACKAGE files and generates a message in a queue called cran-pcks. 'Several' instances of Indexer could be listening to this topic in several places, ready to process each message (consuming in a balanced way).

## What was used to build this?
### Ruby 2.0.0
### Bundle
### Sinatra
### Rufus-scheduler

## How to use it?
### Tests
> rake spec:unit

> rake spec:integration

### Run
> rake run:now

> rake run:schedule

> rake run:server

NOTE: MongoDB service is required to be installed for the integration tests and for the execution in general
