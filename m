From: Eli Ben-Shoshan <eli@benshoshan.com>
Subject: Accidentally resized array to 9
Date: Fri, 29 Sep 2017 00:23:28 -0400
Message-ID: <0e59cefd-662f-bf77-0c32-49424d504c77@benshoshan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I need to add another disk to my array (/dev/md128) when I accidentally 
did an array resize to 9 with the following command:

First I add the disk to the array with the following:

mdadm --manage /dev/md128 --add /dev/sdl

This was a RAID6 with 8 devices. Instead of using --grow with 
--raid-devices set to 9, I did the following:

mdadm --grow /dev/md128 --size 9

This happily returned without any errors so I went to go look at 
/proc/mdstat and did not see a resize operation going. So I shook my 
head and read the output of --grow --help and did the right thing which is:

mdadm --grow /dev/md128 --raid-devices=9

Right after that everything hit the fan. dmesg reported a lot of 
filesystem errors. I quickly stopped all processes that were using this 
device and unmounted the filesystems. I then, stupidly, decided to 
reboot before looking around.

I am now booted and can assemble this array but it seems like there is 
no data there. Here is the output of --misc --examine:

ganon raid # cat md128
/dev/md128:
         Version : 1.2
   Creation Time : Sat Aug 30 22:01:09 2014
      Raid Level : raid6
   Used Dev Size : unknown
    Raid Devices : 9
   Total Devices : 9
     Persistence : Superblock is persistent

     Update Time : Thu Sep 28 19:44:39 2017
           State : clean, Not Started
  Active Devices : 9
Working Devices : 9
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 512K

            Name : ganon:ganon - large raid6  (local to host ganon)
            UUID : 2b3f41d5:ac904000:965be496:dd3ae4ae
          Events : 84345

     Number   Major   Minor   RaidDevice State
        0       8       32        0      active sync   /dev/sdc
        1       8       48        1      active sync   /dev/sdd
        6       8      128        2      active sync   /dev/sdi
        3       8       96        3      active sync   /dev/sdg
        4       8       80        4      active sync   /dev/sdf
        8       8      160        5      active sync   /dev/sdk
        7       8       64        6      active sync   /dev/sde
        9       8      112        7      active sync   /dev/sdh
       10       8      176        8      active sync   /dev/sdl

You will note that the "Used Dev Size" is unknown. The output of --misc 
--examine on each disk looks similar to this:

/dev/sdc:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 2b3f41d5:ac904000:965be496:dd3ae4ae
            Name : ganon:ganon - large raid6  (local to host ganon)
   Creation Time : Sat Aug 30 22:01:09 2014
      Raid Level : raid6
    Raid Devices : 9

  Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
      Array Size : 0
   Used Dev Size : 0
     Data Offset : 239616 sectors
    Super Offset : 8 sectors
    Unused Space : before=239528 sectors, after=3906789552 sectors
           State : clean
     Device UUID : b1bd681a:36849191:b3fdad44:22567d99

     Update Time : Thu Sep 28 19:44:39 2017
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : bca7b1d5 - correct
          Events : 84345

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAAAAAAA ('A' == active, '.' == missing, 'R' == 
replacing)

I followed directions to create overlays and I tried to re-create the 
array with the following:

mdadm --create /dev/md150 --assume-clean --metadata=1.2 
--data-offset=117M --level=6 --layout=ls --chunk=512 --raid-devices=9 
/dev/mapper/sdc /dev/mapper/sdd /dev/mapper/sdi /dev/mapper/sdg 
/dev/mapper/sdf /dev/mapper/sdk /dev/mapper/sde /dev/mapper/sdh 
/dev/mapper/sdl

while this creates a /dev/md150, it is basically empty. There should be 
an LVM PV label on this disk but pvck returns:

   Could not find LVM label on /dev/md150

The output of --misc --examine looks like this with the overlay:

/dev/md150:
         Version : 1.2
   Creation Time : Fri Sep 29 00:22:11 2017
      Raid Level : raid6
      Array Size : 13673762816 (13040.32 GiB 14001.93 GB)
   Used Dev Size : 1953394688 (1862.90 GiB 2000.28 GB)
    Raid Devices : 9
   Total Devices : 9
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Fri Sep 29 00:22:11 2017
           State : clean
  Active Devices : 9
Working Devices : 9
  Failed Devices : 0
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 512K

            Name : ganon:150  (local to host ganon)
            UUID : 84098bfe:74c1f70c:958a7d8a:ccb2ef74
          Events : 0

     Number   Major   Minor   RaidDevice State
        0     252       11        0      active sync   /dev/dm-11
        1     252        9        1      active sync   /dev/dm-9
        2     252       16        2      active sync   /dev/dm-16
        3     252       17        3      active sync   /dev/dm-17
        4     252       10        4      active sync   /dev/dm-10
        5     252       14        5      active sync   /dev/dm-14
        6     252       12        6      active sync   /dev/dm-12
        7     252       13        7      active sync   /dev/dm-13
        8     252       15        8      active sync   /dev/dm-15

What do you think? Am I hosed here? Is there any way I can get my data back?
