From: chris <linux_mail@rozpooh.com>
Subject: raid1 reconstruction locks up system
Date: Mon, 27 Sep 2004 23:30:42 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200409272330.42915.linux_mail@rozpooh.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

highpoint 370 ide controller (using kernel provided module)
(2) 120 gb ide harddisks

linux 2.6.8.1
raidtools 1.00.3
mdadm 1.6.0

i am using linux md raid1

i have a raid1 array that has been running fine through several kernel 
upgrades including 2.6.8.1

i recently had power outage that has left me in disarray (as if you have never 
heard that pun)

when using raidstart to start the array, both discs are found and md0 is 
created.    md says the raid is not clean and begins reconstruction.  i get a 
new prompt so one might assume that the reconstruction starts in the 
background.  md gives a few more messages about starting the sync, but, at 
this point my system is already locked up.  no keyboard input, no ssh in from 
another box.

i don't know where to go from here.  normally, the reconstruction would run in 
the background and i would go about my business.  i can't even tell if the 
reconstruction is taking place.  i suspect it is not, but, that's just a 
hunch.

btw, the same thing happens when i use mdadm to start the array...

any advice is appreciated.

here is an example of what the system is doing:

root@mybox:~#raidstart /dev/md0
md: raidstart (pid389) used deprecated START_ARRAY not supported past 2.6
(it has been running fine in 2.6 until now)
md: autorun
md: considering hdg1
adding hdg1
adding hde1
md: created md0
md: bind <hde1>
md: bind <hdg1>
md: running <hdg1><hde1>
md: md0: raid array is not clean
starting background reconstruction
raid1set md0 active 2 out of 2 mirrors
md: autorun DONE
root@mybox:~#md: syncing RAID array md0
md: using 128k window over (120gb) blocks

at this point the system is frozen, there is a blinking "-" but i cannot use 
keyboard or ssh in

i appreciate any advice.

-chris


