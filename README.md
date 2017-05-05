# iGoat - A Learning Tool for iOS App Pentesting and Security #

iGoat is a learning tool for iOS developers (iPhone, iPad, etc.) and mobile app pentesters. It was inspired by the WebGoat project, and has a similar conceptual flow to it.

As such, iGoat is a safe environment where iOS developers can learn about the major security pitfalls they face as well as how to avoid them. It is made up of a series of lessons that each teach a single (but vital) security lesson.

### The lessons are laid out in the following steps: ###

1. Brief introduction to the problem.
1. Verify the problem by exploiting it.
1. Brief description of available remediations to the problem.
1. Fix the problem by correcting and rebuilding the iGoat program.

Step 4 is optional, but highly recommended for all iOS developers. Assistance is available within iGoat if you don't know how to fix a specific problem.

__Project Details__ - https://www.owasp.org/index.php/OWASP_iGoat_Tool_Project

__Project Leader__ - Swaroop Yermalkar ([@swaroopsy](https://twitter.com/swaroopsy?lang=en))

### Vulnerabities Covered (version 2.8): ###
* Reverse Engineering
  * String Analysis
* Data Protection (Rest)
  * Local Data Storage (SQLite)
  * Plist Storage
  * Keychain Usage
  * NSUserDefaults Storage
* Data Protection (Transit)
  * Server Communication
  * Public Key Pinning
* Authentication
  * Remote Authentication
* Side Channel Data Leaks
  * Device Logs
  * Cut-and-Paste
  * Backgrounding
  * Keystroke Logging
* Tamepring 
  * Method Swizzling
* Injection Flaws
  * SQL Injection
  * Cross Site Scripting
  * Broken Cryptography

### How to countribute? ###
* You can add new exercises
* Testing iGoat and checking if any issues
* Suggest us new attacks
* Writing blogs / article about iGoat
* Spreading iGoat :)

To contribute to iGoat project, please contact __Swaroop__ ( swaroop[dot]yermalkar[at]owasp[dot]org or @swaroopsy )

### Project Contributors - ###
* Ken van Wyk
* Jonathan Carter
* masbog
* Cheena Kathpal
* Anthony Gonsalves
* Matt Tesauro
