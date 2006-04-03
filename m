From: "Nigel J. Terry" <nigel@nigelterry.net>
Subject: Help needed - RAID5 recovery from Power-fail
Date: Mon, 03 Apr 2006 19:41:39 -0400
Message-ID: <4431B2B3.9080700@nigelterry.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I wonder if you could help a Raid Newbie with a problem

I had a power fail, and now I can't access my RAID array. It has been
working fine for months until I lost power... Being a fool, I don't have
a full backup, so I really need to get this data back.

I run FC4 (64bit).
I have an array of two disks /dev/sda1 and /dev/sdb1 as a raid5 array
/dev/md0 on top of which I run lvm and mount the whole lot as /home. My
intention was always to add another disk to this array, and I purchased
one yesterday.

When I boot, I get:

md0 is not clean
Cannot start dirty degraded array
failed to run raid set md0


I can provide the following extra information:

# cat /proc/mdstat
Personalities : [raid5]
unused devices: <none>

# mdadm --query /dev/md0
/dev/md0: is an md device which is not active

# mdadm --query /dev/md0
/dev/md0: is an md device which is not active
/dev/md0: is too small to be an md component.

# mdadm --query /dev/sda1
/dev/sda1: is not an md array
/dev/sda1: device 0 in 2 device undetected raid5 md0.  Use mdadm
--examine for more detail.

#mdadm --query /dev/sdb1
/dev/sdb1: is not an md array
/dev/sdb1: device 1 in 2 device undetected raid5 md0.  Use mdadm
--examine for more detail.

# mdadm --examine /dev/md0
mdadm: /dev/md0 is too small for md

# mdadm --examine /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : c57d50aa:1b3bcabd:ab04d342:6049b3f1
  Creation Time : Thu Dec 15 15:29:36 2005
     Raid Level : raid5
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Tue Mar 21 06:25:52 2006
          State : active
 Active Devices : 1
Working Devices : 1
 Failed Devices : 2
  Spare Devices : 0
       Checksum : 2ba99f09 - correct
         Events : 0.1498318

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       0        0        1      faulty removed

#mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.02
           UUID : c57d50aa:1b3bcabd:ab04d342:6049b3f1
  Creation Time : Thu Dec 15 15:29:36 2005
     Raid Level : raid5
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 0

    Update Time : Tue Mar 21 06:23:57 2006
          State : active
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 2ba99e95 - correct
         Events : 0.1498307

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1

It looks to me like there is no hardware problem, but maybe I am wrong.
I cannot find any file /etc/mdadm.conf    nor   /etc/raidtab.

How would you suggest I proceed? I'm wary of doing anything (assemble,
build, create) until I am sure it won't reset everything.

Many Thanks

Nigel



