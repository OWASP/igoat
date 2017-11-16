# OWASP iGoat - A Learning Tool for iOS App Pentesting and Security #

iGoat is a learning tool for iOS developers (iPhone, iPad, etc.) and mobile app pentesters. It was inspired by the WebGoat project, and has a similar conceptual flow to it.

As such, iGoat is a safe environment where iOS developers can learn about the major security pitfalls they face as well as how to avoid them. It is made up of a series of lessons that each teach a single (but vital) security lesson.

### The lessons are laid out in the following steps: ###

1. Brief introduction to the problem.
1. Verify the problem by exploiting it.
1. Brief description of available remediations to the problem.
1. Fix the problem by correcting and rebuilding the iGoat program.

Step 4 is optional, but highly recommended for all iOS developers. Assistance is available within iGoat if you don't know how to fix a specific problem.


### Documentation: [iGoat Guide](https://swaroopsy.gitbooks.io/owasp-igoat-setup/content/)

### Project Details ###

__Page__ - https://www.owasp.org/index.php/OWASP_iGoat_Tool_Project

__Project Leader__ - Swaroop Yermalkar ([@swaroopsy](https://twitter.com/swaroopsy?lang=en))

__Twitter__ - ([@OWASPiGoat](https://twitter.com/owaspigoat?lang=en))

__Lead Developer__ - Anthony Gonsalves

### Vulnerabities Covered (version 3.0): ###
* __Key Management__
  * Hardcoded Encryption Keys
  * Key Storage Server Side
  * Random Key Generation
  
* __URL Scheme Attack__
  
* __Social Engineering__
  
* __Reverse Engineering__
  * String Analysis
  
* __Data Protection (Rest)__
  * Local Data Storage (SQLite)
  * Plist Storage
  * Keychain Usage
  * NSUserDefaults Storage
  
* __Data Protection (Transit)__
  * Server Communication
  * Public Key Pinning
  
* __Authentication__
  * Remote Authentication
  
* __Side Channel Data Leaks__
  * Device Logs
  * Cut-and-Paste
  * Backgrounding
  * Keystroke Logging
  
* __Tampering__ 
  * Method Swizzling
  
* __Injection Flaws__
  * SQL Injection
  * Cross Site Scripting
  
* __Broken Cryptography__

### How to countribute? ###
* You can add new exercises
* Testing iGoat and checking if any issues
* Suggest us new attacks
* Writing blogs / article about iGoat
* Spreading iGoat :)

To contribute to iGoat project, please contact __Swaroop__ ( swaroop.yermalkar@owasp.org or @swaroopsy )

### Project Contributors - ###
* Anthony Gonsalves
* Junard Lebajan (@junard)
* Ken van Wyk
* Jonathan Carter
* Heefan
* Tilak Kumar
* Bernhard Mueller
* Sagar Popat
* Chandrakant Nial 
* Valligayatri Rachakonda
* Suraj Kumar
* masbog
* Cheena Kathpal
* Matt Tesauro
