From: Gordon Henderson <gordon@drogon.net>
Subject: Raid5 or 6 here... ?
Date: Tue, 24 Oct 2006 11:33:07 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0610241125580.24361@lion.drogon.net>
References: <4535F660.90901@cgv.tugraz.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4535F660.90901@cgv.tugraz.at>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Heres an oddity - Just built a server with 15 external disks over 2 SAS
channels and I've noticed that the kernel is saying it's RAID5 rather than
RAID6 ...

Hard to explain what I mean in words, but:

  bertha:~# cat /proc/mdstat
  Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
  md9 : active raid6 sdh1[14] sdo1[13] sdg1[12] sdn1[11] sdf1[10] sdm1[9] sde1[8] sdl1[7] sdd1[6] sdk1[5] sdc1[4] sdj1[3] sdb1[2] sdi1[1] sda1[0]      6341993216 blocks level 6, 128k chunk, algorithm 2 [15/15]
	[UUUUUUUUUUUUUUU]

  md1 : active raid1 sdq1[1] sdp1[0]
      497856 blocks [2/2] [UU]

  md2 : active raid1 sdq2[1] sdp2[0]
      2000000 blocks [2/2] [UU]

  md3 : active raid1 sdq3[1] sdp3[0]
      2000000 blocks [2/2] [UU]

  md5 : active raid1 sdq5[1] sdp5[0]
      73240192 blocks [2/2] [UU]

  md6 : active raid1 sdq6[1] sdp6[0]
      78509504 blocks [2/2] [UU]

  unused devices: <none>

and:

  bertha:~# ps ax | grep raid
   1022 ?        S<     0:00 [md6_raid1]
   1026 ?        S<     0:00 [md5_raid1]
   1030 ?        S<     0:00 [md3_raid1]
   1034 ?        S<     0:00 [md2_raid1]
   1038 ?        S<     0:06 [md1_raid1]
   1747 ?        S<   724:25 [md9_raid5]

Note the raid5 at the bottom, even though /proc/mdstat says it's raid-6.
It was created with:

  mdadm --create /dev/md9 -n15 -l6 --chunk=128    \
        /dev/sda1 /dev/sdi1             \
        /dev/sdb1 /dev/sdj1             \
        /dev/sdc1 /dev/sdk1             \
        /dev/sdd1 /dev/sdl1             \
        /dev/sde1 /dev/sdm1             \
        /dev/sdf1 /dev/sdn1             \
        /dev/sdg1 /dev/sdo1             \
        /dev/sdh1

Is this right? I've been thrashing it all week and just notice this. On
other servers I have using RAID-6, I get what I expect in the 'ps' output.
I was just about to start removing disks from it to test rebuild, etc...
Now not so sure!

It's kernel 2.6.18 and
  mdadm - v1.9.0 - 04 February 2005
(Debian Sarge)

Finally:

  bertha:~# mdadm --detail /dev/md9
  /dev/md9:
        Version : 00.90.03
  Creation Time : Tue Oct 17 14:35:06 2006
     Raid Level : raid6
     Array Size : 6341993216 (6048.20 GiB 6494.20 GB)
    Device Size : 487845632 (465.25 GiB 499.55 GB)
   Raid Devices : 15
  Total Devices : 15
Preferred Minor : 9
    Persistence : Superblock is persistent

    Update Time : Tue Oct 24 06:26:03 2006
          State : clean
 Active Devices : 15
Working Devices : 15
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 128K

           UUID : c1a3973d:c46b7356:402fd93c:9778e5a5
         Events : 0.8

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8      129        1      active sync   /dev/sdi1
       2       8       17        2      active sync   /dev/sdb1
       3       8      145        3      active sync   /dev/sdj1
       4       8       33        4      active sync   /dev/sdc1
       5       8      161        5      active sync   /dev/sdk1
       6       8       49        6      active sync   /dev/sdd1
       7       8      177        7      active sync   /dev/sdl1
       8       8       65        8      active sync   /dev/sde1
       9       8      193        9      active sync   /dev/sdm1
      10       8       81       10      active sync   /dev/sdf1
      11       8      209       11      active sync   /dev/sdn1
      12       8       97       12      active sync   /dev/sdg1
      13       8      225       13      active sync   /dev/sdo1
      14       8      113       14      active sync   /dev/sdh1

Gordon
