From: <linux-raid.vger.kernel.org@atu.cjb.net>
Subject: =?UTF-8?B?UmU6IFJBSUQtNiBtZGFkbSBkaXNrcyBvdXQgb2Ygc3luYyBpc3N1ZSAobm8gc3VjY2Vzcyk=?=
Date: Sat, 13 Jun 2009 03:18:46 -0600
Message-ID: <200906130918.n5D9Ipt5057035@cjb.net>
References: <18993.44716.150839.661647@notabene.brown>
Reply-To: <linux-raid.vger.kernel.org@atu.cjb.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18993.44716.150839.661647@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was too busy with work to try repairing the RAID-6 array until
tonight.  I turned off the computer and carefully rearranged all disks
and wires so everything was in a good/snug position, removed the two of
six disks that had failed days before the others, and then tested that
the six remaining disks were all working now without errors -- which
they were.

I used the following command to reassemble the array:

# mdadm --assemble /dev/md13 --verbose --force /dev/sd{a,b,c,d,e,f}1

mdadm: looking for devices for /dev/md13
mdadm: /dev/sda1 is identified as a member of /dev/md13, slot 2.
mdadm: /dev/sdb1 is identified as a member of /dev/md13, slot 5.
mdadm: /dev/sdc1 is identified as a member of /dev/md13, slot 1.
mdadm: /dev/sdd1 is identified as a member of /dev/md13, slot 6.
mdadm: /dev/sde1 is identified as a member of /dev/md13, slot 7.
mdadm: /dev/sdf1 is identified as a member of /dev/md13, slot 3.
mdadm: forcing event count in /dev/sdc1(1) from 2186232 upto 2186236
mdadm: forcing event count in /dev/sdf1(3) from 2186232 upto 2186236
mdadm: forcing event count in /dev/sde1(7) from 2186232 upto 2186236
mdadm: no uptodate device for slot 0 of /dev/md13
mdadm: added /dev/sda1 to /dev/md13 as 2
mdadm: added /dev/sdf1 to /dev/md13 as 3
mdadm: no uptodate device for slot 4 of /dev/md13
mdadm: added /dev/sdb1 to /dev/md13 as 5
mdadm: added /dev/sdd1 to /dev/md13 as 6
mdadm: added /dev/sde1 to /dev/md13 as 7
mdadm: added /dev/sdc1 to /dev/md13 as 1
[ 2727.749972] raid5: raid level 6 set md13 active with 6 out of 8 devices, algorithm 2
mdadm: /dev/md13 has been started with 6 drives (out of 8).

After this I viewed the /proc/mdstat which seemed in order, the only note
being that it was listed as read-only due to the /sys/module/md_mod/parameters/start_ro being set to read-only mode.

At this point I added the Linux Device-Mapper encryption over /dev/md13 as
I always do, and attempted to mount the filesystem from the encrypted
device in read-only mode, but it failed.

I rebooted at this point so it wouldn't be in read-only mode anymore, and
see if it would auto-assemble properly after a reboot -- and it did.

However, I can not mount my encrypted filesystem no matter what I try.

# mdadm --verbose --verbose --detail --scan /dev/md13

/dev/md13:
        Version : 00.90
  Creation Time : Sun Aug  3 10:21:28 2008
     Raid Level : raid6
     Array Size : 5852944512 (5581.80 GiB 5993.42 GB)
  Used Dev Size : 975490752 (930.30 GiB 998.90 GB)
   Raid Devices : 8
  Total Devices : 6
Preferred Minor : 13
    Persistence : Superblock is persistent

    Update Time : Sat Jun 13 02:03:43 2009
          State : clean, degraded
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 64K

           UUID : 7f6da4ce:2ddbe010:f7481424:9a8f8874 (local to host gqq)
         Events : 0.2186266

    Number   Major   Minor   RaidDevice State
       0       0        0        0      removed
       1       8       33        1      active sync   /dev/sdc1
       2       8        1        2      active sync   /dev/sda1
       3       8       81        3      active sync   /dev/sdf1
       4       0        0        4      removed
       5       8       17        5      active sync   /dev/sdb1
       6       8       49        6      active sync   /dev/sdd1
       7       8       65        7      active sync   /dev/sde1

The individual disks still have confusing/conflicting information, each
disk showing different states of failed and active for the various disks,
as it did before I reassembled it.


I don't suppose the Linux Device-Mapper / cryptsetup have had any
changes between 2.6.17 and 2.6.28 which could account for me being
unable to decrypt my filesystem?  I tried using "strings" on the
/dev/mapper/blah after it is created, but it's pure random data.
I am positive my password is correct, I have tried it at least a
dozen times already.

Is there anything I can do at this point?

I feel dreadful to lose this data.

 - S.A.





