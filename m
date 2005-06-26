From: Mitchell Laks <mlaks@verizon.net>
Subject: can we run a degraded raid 1 normally (without adding in a replacement
 second drive)
Date: Sun, 26 Jun 2005 13:21:39 -0400
Message-ID: <200506261321.39964.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Raid Gurus!

I described in my last post that when I physically removed one of the two 
mirror drives from my raid 1
/dev/md0 /dev/hdb1 /dev/hdg1
in the most direct way possible (shut down machine and removed it), 
where /dev/md0 is mounted in an optional part of the Linux file system 
(ie a (non LHS compliant) mount point I call /big  :) )
I was unable to figure out how to make my system boot normally- ie

boot - start the raid device - mount it via /etc/fstab in usual way.

I found that I needed to: manually invoke 

mdadm -A --run /dev/md0 /dev/hdb1
and then i could do 
mount -t ext3 /dev/md0 /big

or else my system drops to single  user repair mode when it can't 
start /dev/md0 and it tries to run fsck.ext3 on the nonexistent mount 
point /big if it is present in /etc/fstab

I have been thinking about this, and reading on the net via google.

I know that it is nonstandard to do this crazy thing I am doing.
Typically after a drive "failure" you  simply
1) replace  /dev/hdg1, 
2) run fdisk  /dev/hdg and create a partion with a superblock
perhaps zero any pre-existing superblock on /dev/hdg1 with
  mdadm --zero-superblock /dev/hdg1
3) then do mdadm -a /dev/md0 /dev/hdg1
 and wait till it resyncs.

However in my case i want to run the raid without a backup - because by taking 
the mirror off line I am better off (perhaps). 

If I  have a mirror off line this is good enough for me - and better in this 
case cause it is  not potentially corrupted by power surges and disaster of 
everyday life. 

Also I am adding a new additional raid device  /dev/md2 which needs to be 
mirrored as it is getting fresh data in.... so I want to use that cable 
location for that new mirrored raid device.

So is there a way to do this or must i set up a separate init script of my own 
to do this --run initiallization after the regular boot is completed 
(dumb ...).

Thanks !!
Mitchell Laks
