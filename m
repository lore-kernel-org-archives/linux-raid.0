From: =?UTF-8?Q?BERTRAND_Jo=C3=ABl?= <joel.bertrand@systella.fr>
Subject: Adding a new disk after disk failure on raid6 volume
Date: Tue, 20 Dec 2011 09:46:13 +0100
Message-ID: <75d55f4581b6ae45b8131ff989836028@systella.fr>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I use several softraid volumes for a very long time. Last week, a disk 
has crashed on a raid6 volume and I have tried to replace faulty disk. 
Today, when Linux boots, it only assembles this volume if the new disk 
is marked as 'faulty' or 'removed', and I don't understand...

System is a sparc64-smp server running linux debian/testing :

Root rayleigh:[~] > uname -a
Linux rayleigh 2.6.36.2 #1 SMP Sun Jan 2 11:50:13 CET 2011 sparc64 
GNU/Linux
Root rayleigh:[~] > dpkg-query -l | grep mdadm
ii  mdadm                                 3.2.2-1

Faulty device is /dev/sde1 :

Root rayleigh:[~] > cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md7 : active raid6 sdc1[0] sdi1[6] sdh1[5] sdg1[4] sdf1[3] sdd1[1]
       359011840 blocks level 6, 64k chunk, algorithm 2 [7/6] [UU_UUUU]

All disks (/dev/sd[cdefghi]) are same model (Fujitsu SCA-2 73 GB) and 
each disk only contains one partition (type FD, linux autodetect). If I 
add /dev/sde1 to raid6 with mdadm -a /dev/md7 /dev/sde1, disk is added 
and my raid6 runs with all disks. But I obtain the same superblock on 
/dev/sde1 and /dev/sde ! If I remove /dev/sde superblock, /dev/sde1 one 
disappears also (i think that both superblocks are the same).

For information :

Root rayleigh:[~] > mdadm --examine --scan
ARRAY /dev/md6 UUID=a003dce6:121c0c4a:3f886e0a:7567841c
ARRAY /dev/md0 UUID=7439e08d:fc4de395:22484380:bdd49890
ARRAY /dev/md1 UUID=d035cc29:f693b530:a3f65a60:fc74e45f
ARRAY /dev/md2 UUID=dd9b6218:838d551e:e9582b84:96b48232
ARRAY /dev/md3 UUID=d5639361:22e3ea3e:1405d837:f1e5c9ea
ARRAY /dev/md4 UUID=41b4f376:e14d8be1:f3ff4b3c:33ab8d40
ARRAY /dev/md5 UUID=cba7995c:045168a1:f998aa64:f0e66714
ARRAY /dev/md7 UUID=3c07a5ac:79f3ad38:980f40e8:743f4cce
Root rayleigh:[~] > mdadm --examine /dev/sdc
/dev/sdc:
    MBR Magic : 55aa
Partition[0] :    143637102 sectors at           63 (type fd)
Root rayleigh:[~] > mdadm --examine /dev/sdc1
/dev/sdc1:
           Magic : a92b4efc
         Version : 0.90.00
            UUID : 3c07a5ac:79f3ad38:980f40e8:743f4cce (local to host 
rayleigh)
   Creation Time : Sun Dec 17 16:56:20 2006
      Raid Level : raid6
   Used Dev Size : 71802368 (68.48 GiB 73.53 GB)
      Array Size : 359011840 (342.38 GiB 367.63 GB)
    Raid Devices : 7
   Total Devices : 6
Preferred Minor : 7

     Update Time : Tue Dec 20 09:38:02 2011
           State : clean
  Active Devices : 6
Working Devices : 6
  Failed Devices : 1
   Spare Devices : 0
        Checksum : 464688f - correct
          Events : 1602268

          Layout : left-symmetric
      Chunk Size : 64K

       Number   Major   Minor   RaidDevice State
this     0       8       33        0      active sync   /dev/sdc1

    0     0       8       33        0      active sync   /dev/sdc1
    1     1       8       49        1      active sync   /dev/sdd1
    2     2       0        0        2      faulty removed
    3     3       8       81        3      active sync   /dev/sdf1
    4     4       8       97        4      active sync   /dev/sdg1
    5     5       8      113        5      active sync   /dev/sdh1
    6     6       8      129        6      active sync   /dev/sdi1
Root rayleigh:[~] >

All disks return same information except /dev/sde when it is running 
(mdadm --examine /dev/sde and mdadm --examine /dev/sde1 return the same 
information). What is my mistake ? Is this a known issue ?

Best regards,

JB
