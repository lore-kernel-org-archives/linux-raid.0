From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: mdadm spare-group not working for me
Date: Wed, 7 Jul 2004 08:14:09 +0000 (GMT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0407070745260.20019@praktifix.dwd.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello

I am using mdadm 1.5.0 (kernel is 2.6.7) and noticed that spare-groups do
not work for me in a raid 10 setup. Here my mdadm.conf:

DEVICE /dev/hda[23567] /dev/hde[23567]
DEVICE /dev/sd[abcdef]1
DEVICE /dev/md[23456]
ARRAY /dev/md0 level=raid1 num-devices=2 UUID=ae4df447:33c21025:00e04356:461073a0
ARRAY /dev/md1 level=raid1 num-devices=2 UUID=3d426966:8a378a74:d73267fb:9ec0589c
ARRAY /dev/md2 level=raid1 num-devices=2 UUID=4e592020:0cc3ca3a:b983668f:d1595d33
ARRAY /dev/md3 level=raid1 num-devices=6 UUID=91e415e1:ab17103b:48d20b4a:1201303c spare-group=afdz
ARRAY /dev/md4 level=raid1 num-devices=2 UUID=71a92656:a1ac42c3:34577f43:f85a26ff spare-group=afdz
ARRAY /dev/md5 level=raid1 num-devices=2 UUID=7e51c839:aa48864b:b50bd5a5:267a1f1c spare-group=afdz
ARRAY /dev/md6 level=raid0 num-devices=3 UUID=c404c58a:42aeef9c:36a67c8e:cd229e88
MAILADDR root

Additionally mdadm is started in monitor mode with the following command:

mdadm --monitor /dev/md0 /dev/md1 /dev/md2 /dev/md3 /dev/md4 /dev/md5

Now I pulled a disk from /dev/md4 and as expected cat /proc/mdstat
looks as follows:

   Personalities : [raid0] [raid1] 
   md6 : active raid0 md3[0] md5[2] md4[1]
         215310528 blocks 64k chunks
         
   md1 : active raid1 hde3[1] hda3[0]
         4016128 blocks [2/2] [UU]
         
   md2 : active raid1 hde5[1] hda5[0]
         4007936 blocks [2/2] [UU]
         
   md3 : active raid1 sdd1[1] sda1[0] hde7[2] hde6[3] hda7[4] hda6[5]
         71770240 blocks [2/2] [UU]
         
   md4 : active raid1 sde1[2](F) sdb1[0]
         71770240 blocks [2/1] [U_]
         
   md5 : active raid1 sdf1[1] sdc1[0]
         71770240 blocks [2/2] [UU]
         
   md0 : active raid1 hde2[1] hda2[0]
         29197824 blocks [2/2] [UU]
      
   unused devices: <none>

mdadm does notice that a disk fails by sending a mail to root:

   Subject: Fail event on /dev/md4:hermes.dwd.de
   Status: R

   This is an automatically generated mail message from mdadm
   running on hermes.dwd.de
   
   A Fail event had been detected on md device /dev/md4.
   
   Faithfully yours, etc.

But no spare disk form /dev/md3 is taken to repair /dev/md4. Here the
output of mdadm -D for md3 and md4:

/dev/md3:
        Version : 00.90.01
  Creation Time : Sat May 22 17:35:09 2004
     Raid Level : raid1
     Array Size : 71770240 (68.45 GiB 73.49 GB)
    Device Size : 71770240 (68.45 GiB 73.49 GB)
   Raid Devices : 2
  Total Devices : 6
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Wed Jul  7 08:08:25 2004
          State : clean, no-errors
 Active Devices : 2
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 4


    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       49        1      active sync   /dev/sdd1
       2      33        7       -1      spare   /dev/hde7
       3      33        6       -1      spare   /dev/hde6
       4       3        7       -1      spare   /dev/hda7
       5       3        6       -1      spare   /dev/hda6
           UUID : 91e415e1:ab17103b:48d20b4a:1201303c
         Events : 0.355480

/dev/md4:
        Version : 00.90.01
  Creation Time : Sat May 22 17:35:22 2004
     Raid Level : raid1
     Array Size : 71770240 (68.45 GiB 73.49 GB)
    Device Size : 71770240 (68.45 GiB 73.49 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 4
    Persistence : Superblock is persistent

    Update Time : Wed Jul  7 08:08:25 2004
          State : clean, no-errors
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0


    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       0        0       -1      removed
       2       8       65       -1      faulty   /dev/sde1
           UUID : 71a92656:a1ac42c3:34577f43:f85a26ff
         Events : 0.277916

Why is none of the spares moved to the broken array. Something must
be wrong with my configuration, but I don't see what is wrong. Please
someone help me, I am willing to provide more information and do
more tests to solve this.

Thanks,
Holger
