From: Adam Barnett <adamtravisbarnett@gmail.com>
Subject: Reshape using drives not partitions, RAID gone after reboot
Date: Tue, 14 Jul 2020 13:50:52 -0600
Message-ID: <b551920e-ddad-c627-d75a-e99d32247b6d@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi everyone I had something happen to my mdadm raid after a reshape and 
reboot.

My mdadm RAID5 array just underwent a 5>8 disk grow and reshape. This 
took several days and went uninterrupted. When cat /proc/mdstat said it 
was complete I rebooted the system and now the array no longer shows.

One potential problem I can see is that I used the full disk when adding 
the new drives (e.g. /dev/sda not /dev/sda1). However these drives had 
partitions on them that should span the entire drive. I now realize this 
was pretty dumb.

I have tried:

$ sudo mdadm --assemble --scan
mdadm: No arrays found in config file or automatically

The three newly added drives do not appear to have md superblocks:

$ sudo mdadm --examine /dev/sd[kln]
/dev/sdk:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdl:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdn:
    MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)

$ sudo mdadm --examine /dev/sd[kln]1
mdadm: No md superblock detected on /dev/sdk1.
mdadm: No md superblock detected on /dev/sdl1.
mdadm: No md superblock detected on /dev/sdn1.

the five others do and show the correct stats for the array:

$ sudo mdadm --examine /dev/sd[ijmop]1
/dev/sdi1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 7399b735:98d9a6fb:2e0f3ee8:7fb9397e
            Name : Freedom-2:127
   Creation Time : Mon Apr  2 18:09:19 2018
      Raid Level : raid5
    Raid Devices : 8

  Avail Dev Size : 15627795456 (7451.91 GiB 8001.43 GB)
      Array Size : 54697259008 (52163.37 GiB 56009.99 GB)
   Used Dev Size : 15627788288 (7451.91 GiB 8001.43 GB)
     Data Offset : 254976 sectors
    Super Offset : 8 sectors
    Unused Space : before=254888 sectors, after=7168 sectors
           State : clean
     Device UUID : ca3cd591:665d102b:7ab8921f:f1b55d62

Internal Bitmap : 8 sectors from superblock
     Update Time : Tue Jul 14 11:46:37 2020
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 6a1bca88 - correct
          Events : 401415

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAAAAAA ('A' == active, '.' == missing, 'R' == replacing)

...ect

Forcing the assembly does not work:

$ sudo mdadm /dev/md1 --assemble --force /dev/sd[ijmop]1 /dev/sd[kln]
mdadm: /dev/sdi1 is busy - skipping
mdadm: /dev/sdj1 is busy - skipping
mdadm: /dev/sdm1 is busy - skipping
mdadm: /dev/sdo1 is busy - skipping
mdadm: /dev/sdp1 is busy - skipping
mdadm: Cannot assemble mbr metadata on /dev/sdk
mdadm: /dev/sdk has no superblock - assembly aborted

 From my looking around I now know that sometimes adding full drives can 
have issues with md superblocks being destroyed, and that I may be able 
to proceed with the --create --assume-clean command. I would like to get 
a second opinion before I go that route as it is somewhat of a last 
resort. I also may need help understanding how to transition from the 
full drives to partitions on those drives if I need to go that route.

Thank you so much for any and all help.


-Adam
