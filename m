From: "A.J.Dawson" <A.J.Dawson@Bradford.ac.uk>
Subject: Mdadm problem?
Date: Wed, 2 Aug 2006 09:50:23 +0100 (GMT Standard Time)
Message-ID: <Pine.WNT.4.63.0608020900120.532@ender>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I seem to be having a problem with mdadm running on Gentoo.  I recently 
upgraded from 1.12 to 2.5-r1 and then to 2.5.2, with both of the latter 
exhibiting the same behaviour on the machine in question.

The machine is running a RAID1 array and seemed quite happy running mdadm 
1.12.  Running mdadm 2.5.2 however, approximately two days after it is 
booted, a significant amount of disk activity starts.  Unfortunately the 
activity always seems to start overnight while I am not in the office and 
so I've no idea whether it is a sudden start at the high activity level, 
or whether it builds from a low start.  I can hear the disks being 
accessed and the machine's response becomes sluggish.  If I look at the 
activity of the machine using top, mdadm sits at the top of the activity 
table with a low CPU consumption, but high memory consumption (%mem > 
94%).  Note that I also have mdadm --follow --scan & echo $! > 
/var/run/mdadm in my local.start file.

I have tried leaving the machine for some time to see whether this 
'problem' goes away of its own accord, but after two weeks, I gave up and 
rebooted it.  Following a reboot, I again have about two days before the 
same behaviour starts.  I've not tried to look at exactly what activity is 
occuring (I'll have a rummage through Google to find out how).

I'm running Gentoo kernel 2.6.15, compiled on the box itself.  Here is the 
output from mdadm regarding the arrays:


# mdadm -D /dev/md0
/dev/md0:
         Version : 00.90.03
   Creation Time : Mon Aug 29 10:02:32 2005
      Raid Level : raid1
      Array Size : 505920 (494.15 MiB 518.06 MB)
     Device Size : 505920 (494.15 MiB 518.06 MB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Wed Aug  2 08:34:16 2006
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            UUID : 874cb92e:b841f7c3:b5612162:072d1697
          Events : 0.1892104

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        1       8       17        1      active sync   /dev/sdb1


# mdadm -D /dev/md1
/dev/md1:
         Version : 00.90.03
   Creation Time : Thu Jul 28 12:51:37 2005
      Raid Level : raid1
      Array Size : 17269760 (16.47 GiB 17.68 GB)
     Device Size : 17269760 (16.47 GiB 17.68 GB)
    Raid Devices : 2
   Total Devices : 2
Preferred Minor : 1
     Persistence : Superblock is persistent

     Update Time : Wed Aug  2 09:46:09 2006
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            UUID : fd167a84:0b5e9b00:6a71ad45:59c5bbf0
          Events : 0.3195760

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        1       8       18        1      active sync   /dev/sdb2


# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sdb2[1] sda2[0]
       17269760 blocks [2/2] [UU]

md0 : active raid1 sdb1[1] sda1[0]
       505920 blocks [2/2] [UU]

unused devices: <none>


I'm happy to go back to mdadm 1.12 if need be (that seemed to work okay 
for me...), but would obviously prefer to sort out the problem with the 
most recent version if possible.  I just hope I've not done something 
completely daft to cause this... :-)

Andy

