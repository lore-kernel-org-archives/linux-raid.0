From: Digimer <lists@alteeve.ca>
Subject: Broken array, trying to assemble enough to copy data off
Date: Wed, 09 Oct 2013 19:25:24 -0400
Message-ID: <5255E5E4.8010900@alteeve.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

  I've got a CentOS 6.4 box with a 4-drive RAID level 5 array that died
while I was away (so I didn't see the error(s) on screen). I took a
fresh drive, did a new minimal install. I then plugged in the four
drives from the dead box and tried to re-assemble the array. It didn't
work, so here I am. :) Note that I can't get to the machine's dmesg or
syslogs as they're on the failed array.

  I was following https://raid.wiki.kernel.org/index.php/RAID_Recovery
and stopped when I hit "Restore array by recreating". I tried some steps
suggested by folks in #centos on freenode, but had no more luck.

  Below is the output of 'mdadm --examine ...'. I'm trying to get just a
few files off. Ironically, it was a backup server, but there were a
couple files on there that I don't have elsewhere anymore. It's not the
end of the world if I don't get it back, but it would certainly save me
a lot of hassle to recover some or all of it.

  Some details;

  When I try;

====
[root@an-to-nas01 ~]# mdadm --assemble --run /dev/md1 /dev/sd[bcde]2
mdadm: ignoring /dev/sde2 as it reports /dev/sdb2 as failed
mdadm: failed to RUN_ARRAY /dev/md1: Input/output error
mdadm: Not enough devices to start the array.

[root@an-to-nas01 ~]# cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md1 : inactive sdc2[0] sdd2[4](S) sdb2[2]
      4393872384 blocks super 1.1

unused devices: <none>
====

  Syslog shows;

====
Oct 10 03:19:01 an-to-nas01 kernel: md: md1 stopped.
Oct 10 03:19:01 an-to-nas01 kernel: md: bind<sdb2>
Oct 10 03:19:01 an-to-nas01 kernel: md: bind<sdd2>
Oct 10 03:19:01 an-to-nas01 kernel: md: bind<sdc2>
Oct 10 03:19:01 an-to-nas01 kernel: bio: create slab <bio-1> at 1
Oct 10 03:19:01 an-to-nas01 kernel: md/raid:md1: device sdc2 operational
as raid disk 0
Oct 10 03:19:01 an-to-nas01 kernel: md/raid:md1: device sdb2 operational
as raid disk 2
Oct 10 03:19:01 an-to-nas01 kernel: md/raid:md1: allocated 4314kB
Oct 10 03:19:01 an-to-nas01 kernel: md/raid:md1: not enough operational
devices (2/4 failed)
Oct 10 03:19:01 an-to-nas01 kernel: md/raid:md1: failed to run raid set.
Oct 10 03:19:01 an-to-nas01 kernel: md: pers->run() failed ...
====

  As you can see, for some odd reason, it says that sde2 thinks sdb2 has
failed and tosses it out.

====
[root@an-to-nas01 ~]# mdadm --examine /dev/sd[b-e]2
/dev/sdb2:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : 8be7648d:09648bf3:f406b7fc:5ebd6b44
           Name : ikebukuro.alteeve.ca:1
  Creation Time : Sat Jun 16 14:01:41 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 2929248256 (1396.77 GiB 1499.78 GB)
     Array Size : 4393870848 (4190.32 GiB 4499.32 GB)
  Used Dev Size : 2929247232 (1396.77 GiB 1499.77 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 127735bd:0ba713c2:57900a47:3ffe04e3

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri Sep 13 04:00:39 2013
       Checksum : 2c41412c - correct
         Events : 2376224

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sdc2:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : 8be7648d:09648bf3:f406b7fc:5ebd6b44
           Name : ikebukuro.alteeve.ca:1
  Creation Time : Sat Jun 16 14:01:41 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 2929248256 (1396.77 GiB 1499.78 GB)
     Array Size : 4393870848 (4190.32 GiB 4499.32 GB)
  Used Dev Size : 2929247232 (1396.77 GiB 1499.77 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 83e37849:5d985457:acf0e3b7:b7207a73

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri Sep 13 04:01:13 2013
       Checksum : 4f1521d7 - correct
         Events : 2376224

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA. ('A' == active, '.' == missing)
/dev/sdd2:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : 8be7648d:09648bf3:f406b7fc:5ebd6b44
           Name : ikebukuro.alteeve.ca:1
  Creation Time : Sat Jun 16 14:01:41 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 2929248256 (1396.77 GiB 1499.78 GB)
     Array Size : 4393870848 (4190.32 GiB 4499.32 GB)
  Used Dev Size : 2929247232 (1396.77 GiB 1499.77 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : a2dac6b5:b1dc31aa:84ebd704:53bf55d9

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri Sep 13 04:01:13 2013
       Checksum : c110f6be - correct
         Events : 2376224

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : spare
   Array State : AA.. ('A' == active, '.' == missing)
/dev/sde2:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x1
     Array UUID : 8be7648d:09648bf3:f406b7fc:5ebd6b44
           Name : ikebukuro.alteeve.ca:1
  Creation Time : Sat Jun 16 14:01:41 2012
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 2929248256 (1396.77 GiB 1499.78 GB)
     Array Size : 4393870848 (4190.32 GiB 4499.32 GB)
  Used Dev Size : 2929247232 (1396.77 GiB 1499.77 GB)
    Data Offset : 2048 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : faa31bd7:f9c11afb:650fc564:f50bb8f7

Internal Bitmap : 8 sectors from superblock
    Update Time : Fri Sep 13 04:01:13 2013
       Checksum : b19e15df - correct
         Events : 2376224

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AA.. ('A' == active, '.' == missing)
====

  Any help is appreciated!

-- 
Digimer
Papers and Projects: https://alteeve.ca/w/
What if the cure for cancer is trapped in the mind of a person without
access to education?
