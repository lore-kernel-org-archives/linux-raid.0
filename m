From: "Tim Harvey" <tharvey@alumni.calpoly.edu>
Subject: Moving a RAID5 array
Date: Thu, 27 May 2004 15:04:51 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <000001c44436$a5df15c0$7001a8c0@darwin>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

I have an Ateonix NASAS 2040 NAS device with a RAID5 array composed of 4
300GB Maxtor IDE disks.  The NASAS 2040 is a std PC motherboard with a
PCI 'disk on flash' module which contains a linux OS that runs the
system.  Therefore the RAID array is /dev/hda1, /dev/hdb1, /dev/hdc1,
/dev/hdd1.  In my case, the flash based OS crashed due to a power glitch
while the system was recovering from a previous power glitch (single
point of failure was pretty easy to hit unfortunately).

Seeing as I know the NAS uses Linux, I figured perhaps I could use
another linux system to mount the array on, intact.  I have taken 1 of
the drives, installed it as hdc in a Linux FC1 system and examined it
with fdisk:

[root@masterbackend root]# fdisk /dev/hdc

The number of cylinders for this disk is set to 36473.
There is nothing wrong with that, but this is larger than 1024,
and could in certain setups cause problems with:
1) software that runs at boot time (e.g., old versions of LILO)
2) booting and partitioning software from other OSs
   (e.g., DOS FDISK, OS/2 FDISK)

Command (m for help): p

Disk /dev/hdc: 300.0 GB, 300001443840 bytes
255 heads, 63 sectors/track, 36473 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hdc1             1     36217 290913052   fd  Linux raid autodetect
/dev/hdc2         36218     36281    514080   83  Linux
/dev/hdc3         36282     36473   1542240   83  Linux

Command (m for help):q
[root@masterbackend root]#


Question:  What would the hdc2 and hdc3 partitions be?  I then examined
it using mdadm:

used 'mdadm --examine /dev/hdc1':

[root@masterbackend root]# mdadm --examine /dev/hdc1
/dev/hdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 979016d8:1ce73ff7:3251d40a:a184400c
  Creation Time : Sat Sep 13 21:40:22 2003
     Raid Level : raid5
    Device Size : 290912960 (277.44 GiB 297.89 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Wed May 26 16:16:36 2004
          State : dirty, no-errors
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : c2e94cf6 - correct
         Events : 0.24

         Layout : left-symmetric
     Chunk Size : 32K

      Number   Major   Minor   RaidDevice State
this     0       3        1        0      active sync   /dev/hda1
   0     0       3        1        0      active sync   /dev/hda1
   1     1       3       65        1      active sync   /dev/hdb1
   2     2      22        1        2      active sync   /dev/hdc1
   3     3      22       65        3      active sync   /dev/hdd1
[root@masterbackend root]#


Luckily the superblock seems ligit, so I think I can safely mount it.
 
My question is that, not being very familiar with Linux raid or mdadm,
I'm wondering if I can mount the array on my Linux system when the
devices are other than described above (they would likely be /dev/hdc1,
/dev/hdd1, etc as my boot/root drives use hda/hdb).  Additionally, how
should I go about mounting this array in a way that if anything doesn't
work right, it doesn't trash the array.  I'm a little paranoid that I
may do something wrong and the raidutils will start reconstructing or
otherwise altering the information on the array.

Thanks for any help.  I've read over the Linux RAID FAQ and looked
through the man pages for mdadm, but I'm pretty paranoid about loosing
the data and want to consult the experts here.

Thanks for any help,

Tim

