From: "Alwin Bakkenes" <alwin.bakkenes@consat.se>
Subject: Building a Raid-5 with failed-disk option doesn't work for Suse 9.1?
Date: Wed, 16 Jun 2004 13:30:55 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040616113107.5CD3321A0@nw-smtp-05.wineasy.se>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, 

I am trying to build a RAID-5 volume with 4 disks on my new Suse 9.1 box. As
it has, I have a large amount of data on one of the disks that I want to
move to the RAID volume and don't have any other place to "park" it. 

So, I wanted to try and build the array with the following raidtab: 

# /data md3 as RAID 5
raiddev                 /dev/md3
raid-level              5
nr-raid-disks           4
nr-spare-disks          0
persistent-superblock   1
parity-algorithm        left-symmetric
chunk-size              128
device                  /dev/hda3
raid-disk               0
device                  /dev/hdc3
raid-disk               1
device                  /dev/sda3
raid-disk               2
device                  /dev/sdb3
failed-disk             3

Using mkraid /dev/md3 I get the following output;

stylus:~ # mkraid /dev/md3
handling MD device /dev/md3
analyzing super-block
disk 0: /dev/hda3, 184313745kB, raid superblock at 184313664kB
disk 1: /dev/hdc3, 184321777kB, raid superblock at 184321664kB
disk 2: /dev/sda3, 184321777kB, raid superblock at 184321664kB
disk 3: /dev/sdb3, failed
/dev/md3: Invalid argument

And dmesg gives me the following messages: 

md: bind<hda3>
md: bind<hdc3>
md: bind<sda3>
raid5: device sda3 operational as raid disk 2
raid5: device hdc3 operational as raid disk 1
raid5: device hda3 operational as raid disk 0
raid5: cannot start dirty degraded array for md3
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, o:1, dev:hda3
 disk 1, o:1, dev:hdc3
 disk 2, o:1, dev:sda3
raid5: failed to run raid set md3
md: pers->run() failed .

/proc/mdstat says: 

md3 : inactive sda3[2] hdc3[1] hda3[0]
      552956928 blocks

And mdadm says: 

stylus:~ # mdadm --detail /dev/md3
/dev/md3:
        Version : 00.90.01
  Creation Time : Wed Jun 16 16:17:02 2004
     Raid Level : raid5
    Device Size : 184313600 (175.78 GiB 188.74 GB)
   Raid Devices : 4
  Total Devices : 3
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Thu Jan  1 01:00:00 1970
          State : dirty, no-errors
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

    Number   Major   Minor   RaidDevice State
       0       3        3        0      active sync   /dev/hda3
       1      22        3        1      active sync   /dev/hdc3
       2       8        3        2      active sync   /dev/sda3
       3       0        0       -1      removed

If I understand correctly, I should be able to start the RAID volume with a
failed disk. It works from RAID-1 volumes with a missing disk. I tried
another RAID-5 config with all disks on the same machine and that one builds
just fine. 

Am I doing something wrong? Anything I can do?

Thanks,

Alwin

