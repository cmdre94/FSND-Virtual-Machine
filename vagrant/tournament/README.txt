This project is not a website.  It is a python test file named tournament_test.py.  It tests another python file named tournament.py.  It is run via command line.  Git Bash is preferred.  The following instructions explain how to import the tournament.sql file into the tournament database and how to run the test file.  

How to run:
1.
Download the FSND-Virtual-Machine repository from Github.

2. 
Open Git Bash

3. 
Inside Git Bash CD to the location of the tournament folder inside the FSND-Virtual-Machine folder.  For example if the FSND-Virtual-Machine repositury is located in c:\, you would type cd c:\fsnd-virtual-machine\vagrant\tournament and press enter.

4.
type vagrant up  

wait for the virtual maching to start; you will see something like this:

$ vagrant up
Bringing machine 'default' up with 'virtualbox' provider...
==> default: Checking if box 'ubuntu/trusty32' is up to date...
==> default: A newer version of the box 'ubuntu/trusty32' is available! You currently
==> default: have version '20170202.0.0'. The latest is version '20170222.0.1'. Run
==> default: `vagrant box update` to update.
==> default: Machine already provisioned. Run `vagrant provision` or use the `--provision`
==> default: flag to force provisioning. Provisioners marked to run always will still run.

5.
type vagrant ssh
you will see something like this:

$ vagrant ssh
Welcome to Ubuntu 14.04.5 LTS (GNU/Linux 3.13.0-108-generic i686)

 * Documentation:  https://help.ubuntu.com/

  System information as of Sat Mar  4 04:01:11 UTC 2017

  System load:  0.0               Processes:           81
  Usage of /:   4.1% of 39.34GB   Users logged in:     1
  Memory usage: 16%               IP address for eth0: 10.0.2.15
  Swap usage:   0%

  Graph this data and manage this system at:
    https://landscape.canonical.com/

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud


The shared directory is located at /vagrant
To access your shared files: cd /vagrant
Last login: Sat Mar  4 04:01:11 2017 from 10.0.2.2
vagrant@vagrant-ubuntu-trusty-32:~$

6.
type cd/vagrant/tournament
You will see something like this:

vagrant@vagrant-ubuntu-trusty-32:/vagrant/tournament$

7.
type psql vagrant
This connects to the vagrant directory.

8. 
import the sql file by typing \i tournament.sql

9.
press ctrl+z
this exits the tournament database and takes you back the following prompt:

vagrant@vagrant-ubuntu-trusty-32:/vagrant/tournament$

10.
type python tournament_test.py
This runs the test file.




