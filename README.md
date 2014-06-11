WP-DuplicateDB
=========

Just a simple shell script to easily duplicate a WordPress MySQL database to another MySQL database. Can be useful when switching from your dev server to your production server.

The destination database must exist before executing this script. All the tables of the destination database will be dropped at the beginning of the script.

To use it, just update the constants in the duplicate.sh file.

To run it, just type:

	./duplicate.sh 
	
Do not forget to make the duplicate.sh script executable. You may need to execute it as root (sudo ./duplicate.sh).