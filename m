From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Persistent superblock error
Date: Thu, 21 Oct 2004 20:57:20 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410220057.i9M0vPN03785@www.watkins-home.com>
References: <41783E28.9010209@atmos.colostate.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41783E28.9010209@atmos.colostate.edu>
To: 'Saurabh Barve' <sa@atmos.colostate.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You said: "Any advice on why my RAID array will not run?"
Yes, you have 2 failed disks!

     Number   Major   Minor   RaidDevice State
        0      22        1        0      active sync   /dev/hdc1
        1      22       65        1      faulty   /dev/hdd1
        2       0        0        2      faulty removed
        3      34       65        3      active sync   /dev/hdh1

        4      34        1        4      spare   /dev/hdg1


If you replaced 2 disks from a RAID5, then the data is lost!
Are you sure this is what you wanted to do?

How did you assemble with 2 failed/replaced disks?

I am confused.  Based on the output of "mdadm --detail", the array should be
down.

Do you want to recover the data?
If yes then
	If you hope to save the data stop doing stuff!
	And don't lose the failed disks!  They may not be bad.
	And label them so you know which is which, if not too late!
	If both disks are really bad (unreadable), then the data is gone.
	Post another message with the status of the failed disks.
If no then
	Just recreate the array with the current disks and move on.
	Use mkfs to create a new filesystem.

Guy
	

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Saurabh Barve
Sent: Thursday, October 21, 2004 6:55 PM
To: linux-raid@vger.kernel.org
Subject: Persistent superblock error

Hi,

I recently lost 2 hard drives in my 4-drive RAID-5 array. I replaced the 
two faulty hard drives and tried rebuilding the array. However, I 
continue to get errors.

I created the raid array using madam:
mdadm --assemble /dev/md0 --update=summaries /dev/hdc1 /dev/hdd1 
/dev/hdg1 /dev/hdh1


I then tried to run fsck on /dev/md0 to make sure there were no file 
system errors. However, fsck returned error messages that the number of 
cylinders according to the superblock were 183833712, while the physical 
size of the device was 183104736.

Running fdisk on /dev/md0 returned the following:

--------------
Device contains neither a valid DOS partition table, nor Sun, SGI or OSF 
disklabel
Building a new DOS disklabel. Changes will remain in memory only,
until you decide to write them. After that, of course, the previous
content won't be recoverable.


The number of cylinders for this disk is set to 183104736.
There is nothing wrong with that, but this is larger than 1024,
and could in certain setups cause problems with:
1) software that runs at boot time (e.g., old versions of LILO)
2) booting and partitioning software from other OSs
    (e.g., DOS FDISK, OS/2 FDISK)
Warning: invalid flag 0x0000 of partition table 4 will be corrected by 
w(rite)

Command (m for help): p

Disk /dev/md0: 749.9 GB, 749996998656 bytes
2 heads, 4 sectors/track, 183104736 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
---------------



I tried inspecting the raid array with mdamd - 'mdadm --detail --test 
/dev/md0'. It gave me the following results:
------------------
/dev/md0:
         Version : 00.90.00
   Creation Time : Thu Oct 21 16:27:20 2004
      Raid Level : raid5
      Array Size : 732418944 (698.49 GiB 749.100 GB)
     Device Size : 244139648 (232.83 GiB 249.100 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Thu Oct 21 16:38:59 2004
           State : dirty, degraded
  Active Devices : 2
Working Devices : 3
  Failed Devices : 1
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : c7a73d47:a072c630:7693d236:dff40ca6
          Events : 0.6

     Number   Major   Minor   RaidDevice State
        0      22        1        0      active sync   /dev/hdc1
        1      22       65        1      faulty   /dev/hdd1
        2       0        0        2      faulty removed
        3      34       65        3      active sync   /dev/hdh1

        4      34        1        4      spare   /dev/hdg1
--------------------


My /etc/raidtab files reads like this:

---------
raiddev /dev/md0
         raid-level              5
         nr-raid-disks           4
         nr-spare-disks          0
         persistent-superblock   1
         parity-algorithm        left-symmetric
         chunk-size              64
         device                  /dev/hdc1
         raid-disk               0
         device                  /dev/hdd1
         raid-disk               1
         device                  /dev/hdg1
         raid-disk               2
         device                  /dev/hdh1
         raid-disk               3
----------


Any advice on why my RAID array will not run?

Thanks,
Saurabh.

