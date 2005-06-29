From: Ken Walker <ken.walker@manchester.ac.uk>
Subject: problems creating my first  raid 1 on debian
Date: Wed, 29 Jun 2005 13:05:22 +0100
Message-ID: <60F5F1E2B94AD4119F0B00B0D0215FFF01A69EC8@bsc.tt.umist.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been using Mandrake Linux for a few years now, and always preferred
LM8.2 because it was supposed to be the most stable version they have
produce to date. But i got hacked and the main problem was updating packages
no longer supported by Mandrake.

I don't like their end of product life expectancy, similar to windows.

I'm now starting with Debian, because there more interested in stability
than adding everything before its been fully tested.

I could never get uprmi to work, even on Mandrakes latest releases, but apt
is excellent, works first time every time ( apart for openoffice, its says
there isn't one available )

Anyway, I'm trying to build a raid 1 with two 160gig IDE drives, I'm booting
from Debian 3.0r5 'vanilla' kernel from Scsi and have the two ide's on
separate ide channels.

Going through mdadm howtos and such they say start with the following

Samba3:/etc/init.d# mkraid /dev/md0

And i get the following 

mkraid version 0.36.4
parsing configuration file
mkraid: aborted

so then i tried 

Samba3:/etc/init.d# mdadm --create --verbose /dev/md0 --level=linear
--raid-devices=2 /dev/hda /dev/hdc

and got the following

mdadm: Create requires md driver version 0.90.0 or later

So i looked at the version of mdadm i had updated to using apt-get install
mdadm

Samba3:/etc/init.d# mdadm -V

and it said

mdadm - v1.9.0 - 04 February 2005

How do i get the latest version of md via apt, or am i doing something else
wrong here

I have also read that if i do the following

Samba3:/proc# cat mdstat

and get the following result  ( below is me )

Personalities :
read_ahead not set
md0 : inactive
md1 : inactive
md2 : inactive
md3 : inactive


Then i need kernel patches for raid !

Do i need kernel patches ( I'm running Debain on 'vanilla' because of my
scsi card )

ps if i run apt-get install mdadm now i get the following

Samba3:/proc# apt-install mdadm
bash: apt-install: command not found
Samba3:/proc# apt-get install mdadm
Reading Package Lists... Done
Building Dependency Tree... Done
The following NEW packages will be installed:
  mdadm
0 packages upgraded, 1 newly installed, 0 to remove and 344  not upgraded.
Need to get 0B/104kB of archives. After unpacking 254kB will be used.
debconf: unable to initialize frontend: Kde
debconf: (Can't locate Qt.pm in @INC (@INC contains: /etc/perl
/usr/local/lib/perl/5.8.4 /usr/local/share/perl/5.8.4 /usr/lib/perl5
/usr/share/perl5 /usr/lib/perl/5.8 /usr/share/perl/5.8
/usr/local/lib/site_perl .) at
/usr/share/perl5/Debconf/FrontEnd/Kde/Wizard.pm line 7, <> line 1.)
debconf: falling back to frontend: Dialog
Preconfiguring packages ...
(Reading database ... 48796 files and directories currently installed.)
Unpacking mdadm (from .../mdadm_1.9.0-4_i386.deb) ...
dpkg: error processing /var/cache/apt/archives/mdadm_1.9.0-4_i386.deb
(--unpack):
 trying to overwrite `/sbin/mdrun', which is also in package raidtools
dpkg-deb: subprocess paste killed by signal (Broken pipe)
Errors were encountered while processing:
 /var/cache/apt/archives/mdadm_1.9.0-4_i386.deb
E: Sub-process /usr/bin/dpkg returned an error code (1)
Samba3:/proc#

could this be my problem

Many thanks

Ken


	
