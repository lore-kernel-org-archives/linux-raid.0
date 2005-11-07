From: Troels Bang Jensen <marvin@fnuck.dk>
Subject: RAID 5 array keeps dropping drive on boot
Date: Mon, 7 Nov 2005 23:56:15 +0100
Message-ID: <2A807893-B5A6-4EF1-B862-1D6F22D71B60@fnuck.dk>
Mime-Version: 1.0 (Apple Message framework v734)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've got a simple setup with three IDE drives where two disks share a  
30mb RAID1 partition for /boot and all three share a 590GB RAID5  
array for /

My mdadm.conf looks like this:

DEVICE partitions
ARRAY /dev/md1 level=raid5 num-devices=3 UUID=4b22b17d: 
06048bd3:ecec156c:31fabbaf
    devices=/dev/hda3,/dev/hdc3,/dev/hdg2
ARRAY /dev/md0 level=raid1 num-devices=2  
UUID=7d5c8486:35fff755:f5d34fc2:a12f1f81
    devices=/dev/hda1,/dev/hdc1

The UUIDs check out with the devices, and indeed /dev/md0 works  
fine. /dev/md1 used to work perfectly, but read on :-p

All the raid partitions are type 0xfd RAID auto-detect.

Recently I had to replace hdc because it crashed. When I got the new  
drive, I copied the partition table from hda (using cfdisk) and  
hotadded it to md0 and md1.

The problem is that /dev/md1 starts without /dev/hdc3 whenever I boot  
the system, so I have to resynchronize each time.

The raid info for /dev/hda3 and /dev/hdg2 is the same, that is

/dev/hda3:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 4b22b17d:06048bd3:ecec156c:31fabbaf
   Creation Time : Tue Jun  7 13:03:54 2005
      Raid Level : raid5
    Raid Devices : 3
   Total Devices : 2
Preferred Minor : 1

     Update Time : Mon Nov  7 23:28:38 2005
           State : clean
Active Devices : 2
Working Devices : 2
Failed Devices : 1
   Spare Devices : 0
        Checksum : b0ce8bf5 - correct
          Events : 0.366671

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     0       3        3        0      active sync   /dev/hda3

    0     0       3        3        0      active sync   /dev/hda3
    1     1       0        0        1      faulty removed
    2     2      34        2        2      active sync   /dev/hdg2


/dev/hdc3 doesn't agree to this - it shows all drives as being online.
I just tried rebooting during a synchronization (had to move the  
computer), and the state of /dev/hdc3 is now:

/dev/hdc3:
           Magic : a92b4efc
         Version : 00.90.00
            UUID : 4b22b17d:06048bd3:ecec156c:31fabbaf
   Creation Time : Tue Jun  7 13:03:54 2005
      Raid Level : raid5
    Raid Devices : 3
   Total Devices : 3
Preferred Minor : 1

     Update Time : Mon Nov  7 23:23:24 2005
           State : clean
Active Devices : 2
Working Devices : 3
Failed Devices : 1
   Spare Devices : 1
        Checksum : b0ce8a68 - correct
          Events : 0.366603

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     3      22        3        3      spare   /dev/hdc3

    0     0       3        3        0      active sync   /dev/hda3
    1     1       0        0        1      faulty removed
    2     2      34        2        2      active sync   /dev/hdg2
    3     3      22        3        3      spare   /dev/hdc3

...but it's not synching.

/proc/mdstat shows

Personalities : [raid1] [raid5]
md0 : active raid1 hda1[0] hdc1[1]
       48064 blocks [2/2] [UU]

md1 : active raid5 hda3[0] hdg2[2]
       585585152 blocks level 5, 64k chunk, algorithm 2 [3/2] [U_U]

unused devices: <none>

Note that md0, although using hdc, doesn't have any problems and that  
hdc doesn't show up as spare on md1.

All three drives are the same model, and they're less than half a  
year old.

dmesg says the following:

...
devfs_mk_dev: could not append to parent for md/1
md: md1 stopped.
md: bind<hdg2>
md: bind<hda3>
raid5: device hda3 operational as raid disk 0
raid5: device hdg2 operational as raid disk 2
raid5: allocated 3164kB for md1
raid5: raid level 5 set md1 active with 2 out of 3 devices, algorithm 2
RAID5 conf printout:
--- rd:3 wd:2 fd:1
disk 0, o:1, dev:hda3
disk 2, o:1, dev:hdg2

I'm a little unsure about that "could not append to parent" part.  
Maybe that's the culprit somehow? Then md0 should also be broken  
since its output is

devfs_mk_dev: could not append to parent for md/0
md: md0 stopped.
md: bind<hdc1>
md: bind<hda1>
md: raid1 personality registered as nr 3
raid1: raid set md0 active with 2 out of 2 mirrors

...but it works perfectly.

My thoughts about possible explanations are:

-md drops hdc3 silently at boot ofr some reason. I believe this would  
constitute a grave bug

-perhaps hdc3 has weird information in the raid superblock - I've  
tried zeroing it before adding though.

-hda3 or hdg2 has information in their superblock that sets that  
drive as faulty and that information doesn't get reset after a sync


I've seen two or three posts concerning what seems to me to be the  
same problem when I searched through the mailing list archive - I  
just tried but could only find one, with the subject line:

RAID-1 mirror keeps mysteriously dropping one partition on boot



I'm running a Debian Sarge system with a 2.6.12-1-k7 stock kernel  
(taken from unstable).

mdadm is version 1.9.0 (04 feb. 2005)

I'm all out of ideas atm, so any pointers at all would be greatly  
appreciated.

Troels

