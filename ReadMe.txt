This project has two parts
a. UI app to install/uninstall extension. Setup the directories to monitor by the Extension.
b. System Extension client to recieve the CRUD operation notifications.


What I have done
a. UI app gives a UI to install on every launch of the app, irrespective of SysExt being installed and running.
b. Once the SysExt is up and running, user is taken to another UI screen to select the directories/folders.
c. As of now one path can be added at a time and it gets saved in the user-defaults.
d. A logger is implemented to log the details. 
  Note: As of now one UI is added with Test-UI and Test-Code to write to a file. Since I could not complete, to get the data from SysExt to write those to the file.


Future Features
a. On launch of the client, check the SysExt status and proceed to install screen or Setup Folder screen.
b. Instead of saving the observed folders in user-defaults, it can be saved in Coredata or SQLite.
c. Show the list in a table-view with Add, Remove options
d. Once I learn how the System-Extension can be used as an observer for a given file, I can update the project by removing the Test-UI, and linking with the actual data.

