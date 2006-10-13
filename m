From: jeff <jeff@jeffunit.com>
Subject: problem during boot with linux software raid 5
Date: Fri, 13 Oct 2006 18:28:21 -0400
Message-ID: <1160778501.8826.13.camel@dual_933>
Reply-To: jeff@jeffunit.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, jeff@jeffunit.com
List-Id: linux-raid.ids

I am running mandrake 2006 linux.

uname -a reports
Linux dual_933 2.6.12-12mdksmp #1 SMP Fri Sep 9 17:43:23 CEST 2005 i686
Pentium III (Coppermine) unknown GNU/Linux

I created a raid 5 partition using 4 250gb ide drives and 1 200gb ide
drive (I will get a bigger drive real soon now).

I said:
mdadm --create --verbose /dev/md0 --level=5 --raid-devices=5 /dev/hda
/dev/hdb /dev/hdc /dev/hdd /dev/hdf

Then I formatted it:
mkreiserfs /dev/md0

Then I made an entry in /etc/fstab:
/dev/md0 /mnt/data reiserfs notail 1 2

and I mounted it with 'mount -a'

Everything worked fine, and I filled up the disk.

When I rebooted, the reboot hung. I think for some reason it didn't
automatically start the md0 device, and as a result it couldn't mount
the /dev/md0 partition in my /etc/fstab. I went into single-user mode,
and commented out the /dev/md0 line in /etc/fsab, and I was able to
boot. Then I executed the mdadm --create line, uncommented /etc/fstab,
and I was able to access my data.

I was reading some documentation, and it said that you can use mdadm on
either partitions or on a device (as I did). When you have partitions, I
read that you should set the partition type to 0xFD so they get
autodetected during boot. I can't do this, as I don't have partitions.

I am not sure what I should do to fix the problem.
I would guess I can create one big partition per disk and mark each as
0xFD. I checked the superblock status on all of the disks (shown below)
so it is clear that the disk has a superblock and knows it is raid5.
Please advise.

Jeff Deifik


(Only one shown, but they rest are pretty similar)
mdadm --examine  /dev/hda
/dev/hda:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : ce5e9366:d83a232c:3da68804:f6814703
  Creation Time : Fri Oct 13 13:02:51 2006
     Raid Level : raid5
    Device Size : 195360896 (186.31 GiB 200.05 GB)
     Array Size : 781443584 (745.24 GiB 800.20 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Fri Oct 13 13:09:15 2006
          State : clean
 Active Devices : 4
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 19f15df2 - correct
         Events : 0.9

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       3        0        0      active sync   /dev/hda

   0     0       3        0        0      active sync   /dev/hda
   1     1       3       64        1      active sync   /dev/hdb
   2     2      22        0        2      active sync   /dev/hdc
   3     3      22       64        3      active sync   /dev/hdd
   4     4       0        0        4      faulty removed
   5     5      33       64        4      spare   /dev/hdf



