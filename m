From: Brock Nanson <brock@nanson.org>
Subject: RAID5 almost failed - reorder drives?
Date: Sun, 9 Jun 2002 11:20:21 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0206091054580.20768-100000@web-nanson>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I couldn't find this one in the FAQ, hopefully someone can offer some 
suggestions before I make a big mistake!

I have a RAID5 going based on a Mandrake 7.1 distro.  Three IDE drives on 
a motherboard with 4 IDE channels (so will support 8 IDE devices).  All 
three drives have been partitioned in the same way as I originally planned 
to run RAID1 on the other partitions.  So:

hda - contains operating system and is raid-disk 0 in raidtab
hdc - the position of the cdrom drive
hde - contains partitions for the operating system and is raid-disk 1 in 
raidtab
hdg - same as hde, but is raid-disk 2 in raidtab

My problem is that hda is failing... the dreaded tic-tac noise and poor 
response from the system.  A simple tape backup pushes the load average to 
almost 2.  I'm 99% sure hda is the one making the noise.  So it has to be 
replaced as smoothly as possible.

My plan is to copy the os partitions to hdg, using the hard disk upgrade 
mini how-to.  In theory, this disk could then be moved to the position of 
hda and boot.  However, I'm concerned about how the RAID will handle this.

1) If, before physically moving the drive around, I edited raidtab on hdg 
to make raid-disk 2 refer to device /dev/hda4 instead of /dev/hdg4 and 
show raid disk 0 as /dev/hdg4 marked 'failed disk', would RAID be happy to 
run and show 2 of 3 disks up?  In other words, if a disk is moved to 
another IDE channel, can one simply update the /dev/hdx info in the device 
and raid-disk pair?  In my case, as long as raid-disk 2 is still the same 
physical hard drive, just in another position?

2) Is there another way to do this, or a URL to review?

So what I want to do is take the portion of raidtab that looks like this:

nr-raid-disks 3
   device /dev/hda4
   raid-disk 0
   device /dev/hde4
   raid-disk 1
   device /dev/hdg4
   raid-disk 2

and, just before replacing hda with hdg and installing a new drive at hdg, 
edit this part of the file to look like this (minus the comments!)

nr-raid-disks 3
   device /dev/hdg4 (new hard drive)
   failed-disk 0
   device /dev/hde4
   raid-disk 1
   device /dev/hda4 (was in hdg position before)
   raid-disk 2

I don't know if my subscription to the list is active yet, so (PLEASE!) cc 
any responses to brock@nanson.org

Thanks!

-- 
Brock Nanson
Kamloops BC Canada

