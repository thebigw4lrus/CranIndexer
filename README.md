CRAN Server Indexer
----------------------------------------
When it comes to R language packages, we may say that there is not a good tool for downloading, installing (managing in general).  They are used to use tools like apt, rpm and the package installer R-studio itself.  This proposal goes directly to contribute to these people offering a way to index such packages. This is a **minimalistic** approach on how to contribute with these people.

## This design provides 3 major modules:
- Parser: It receives the Cran server url and takes care about reading the PACKAGES file (the packages definition).
- Indexer: It trigger the process of enrich the information that was already gathered by the parser from the Package files 	(every package metadata is split in 2 pieces: one in the PACKAGES file and the other part in some description file inside the actual package).                            
- Db: A singleton class here, will take care about gather and send all package in batches to the Database.
- Package: Is not a module itself but a class. It represents a single package with its behaviour and attributes.
Basically the idea is to create packages based on on the PACKAGES file, in a batch way, which will be routed and controlled along all the execution until its end (which will be on the Database).

## Patterns used:
### singleton pattern
The singleton pattern was implemented on Db::Adapter class.  The reason of this is that we need only one single instance which gather all the ready to send packages.

### Observer pattern
Observer module was mixed with Package class. Everytime a package enrich its definition (go to Cran server and download the package description), an update in the Db::Adapter ready-to-send queue is required, so this adapter will take care of implement the batching and will trigger the bulk insertion.

### Composition
Composition and ruby mixings is present across all the design.


## The good, the bad and the ugly
### The good
- Short classes
- All the configuration is centralized in config/settings.yml
- Unit test / Integration tests are present
- Use of known patterns to break the logic into readable pieces
- It was designed thinking on using some publish-subscribe service message system to scale it

### The bad
- At this stage, the code as is written currently, is not geographically scalable
- A bit naive with the error handling
- No log handler was included

### The ugly
- Package view(sinatra server) was implemented with no style definiton
- Error handling could be improved


##  What's next?
In terms of scrum, this would be the outcome of the very first sprint. This is usable but not geographically distributable.
I would propose for the future implement a **publish-subscribe log-centric bus** (like kafka or rabbit mq), so we could have the same components but with communicating through this mean(i.e.: ***Parser*** parse the PACKAGE files and generates a message to be inserted in a queue. An intermmediate component ***enricher*** could extend the message with the info in every tar.gz file and reinsert the message to the bus, and finally several distributed instances of ***Indexer*** could be listening to this topic, ready to index each message (balanced consumer). Under this approach we could spread components in different locations, achieving a decent scalation, resulting in more simple and self-contained components.
## What was used to build this?
- Ruby 2.0.0
- Bundle 1.11.2
- Rubygems 2.6.3
- Sinatra 1.4.7 (Web server)
- treetop 1.6.5 (thanks for that!)
- Rufus-scheduler 3.2.0 (schedule)
- mongo 2.0.0

## How to use it?
### Tests
> rake spec:unit

> rake spec:integration


### Run
> rake run:now

> rake run:schedule

> rake run:server

NOTE: **MongoDB** service **is required** to be installed for the integration tests and for the execution in general

