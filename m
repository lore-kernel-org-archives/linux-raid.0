From: Mark Thompson <mark@ruthless.ws>
Subject: Trashed Raid 5 software array
Date: Sun, 07 Nov 2004 15:50:24 +1300
Message-ID: <418D8D70.50905@ruthless.ws>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi there,

I've search low and high and havn't been able to find a solution for my
problem with a software raid that I have setup under linux.

Kernel: 2.6.6
Controller: PDC202XX (Promise TX2 ATA100 IDE Controller)

Up until recently everything was fine, but recently the array has
started playing up and dropping a disk and when I reboot the disk
doesn't have the superblock for the md device and as a result can't
start, I then explored the disk using cfdisk and the disk had no
partition there.  So I reformated and this is what I get from mdadm now:

* When I try to assemble the array manually:

cold:~# mdadm -Af /dev/md1 /dev/hd[fjl]1
mdadm: no RAID superblock on /dev/hdj1
mdadm: /dev/hdj1 has no superblock - assembly aborted


* When I assemble the array with the two disks I know work:

cold:~# mdadm -A /dev/md1 /dev/hd[fl]1
mdadm: failed to RUN_ARRAY /dev/md1: Invalid argument


* And mdadm -D

cold:~# mdadm -D /dev/md1
/dev/md1:
         Version : 00.90.01
   Creation Time : Tue May 25 14:19:54 2004
      Raid Level : raid5
     Device Size : 117218176 (111.79 GiB 120.03 GB)
    Raid Devices : 3
   Total Devices : 2
Preferred Minor : 1
     Persistence : Superblock is persistent

     Update Time : Tue Nov  2 09:18:08 2004
           State : dirty, degraded
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 32K

            UUID : 1acc6a85:ce7440d9:dfa74489:64bd5694
          Events : 0.343086

     Number   Major   Minor   RaidDevice State
        0       0        0        -      removed
        1      57       65        1      active sync   /dev/hdl1
        2      33       65        2      active sync   /dev/hdf1

It is usually a raid 5 array with 3 x 120 gig disks on it.

What I'm wanting to know, is despite the fact that hdj1 doesn't have the 
superblock is there a way I can add it to the array so that I can then 
start it and hopefuly recover the 200 gig of data on there, which I can 
then shift off to a hardware array?
