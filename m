From: "Daniel J. R. May" <daniel.may@kada-media.com>
Subject: mdadm RAID 5 reshape not working
Date: Wed, 14 Oct 2015 20:21:03 +0100
Message-ID: <1444850463.3967.19.camel@kada-media.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I attempted to add a disk to an mdadm RAID 5 array with the following:

mdadm --manage /dev/md1 --add /dev/sdf1
mdadm --grow --raid-devices=5 --backup-file=/root/md1-grow.bak /dev/md1

These command gave no errors, but although mdadm reports that the array
is reshaping it does not seem to have done anything after a couple of
hours:

[root@sulphur ~]# mdadm -D /dev/md1 
/dev/md1:
        Version : 1.2
  Creation Time : Thu May 14 18:19:10 2015
     Raid Level : raid5
     Array Size : 11720656896 (11177.69 GiB 12001.95 GB)
  Used Dev Size : 3906885632 (3725.90 GiB 4000.65 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Oct 14 18:48:37 2015
          State : clean, reshaping 
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

 Reshape Status : 0% complete
  Delta Devices : 1, (4->5)

           Name : sulphur.kada-media.red:1  (local to host sulphur.kada
-media.red)
           UUID : dbadf568:66ef2f61:ba13ddd6:176fb4f5
         Events : 14870

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       2       8       49        2      active sync   /dev/sdd1
       4       8       65        3      active sync   /dev/sde1
       5       8       81        4      active sync   /dev/sdf1


[root@sulphur ~]# cat /proc/mdstat 
Personalities : [raid6] [raid5] [raid4] 
md1 : active raid5 sdf1[5] sde1[4] sdb1[0] sdd1[2] sdc1[1]
      11720656896 blocks super 1.2 level 5, 512k chunk, algorithm 2
[5/5] [UUUUU]
      [>....................]  reshape =  0.0% (0/3906885632)
finish=19225133047.4min speed=0K/sec
      bitmap: 0/30 pages [0KB], 65536KB chunk

md0 : active raid5 sdk1[5] sdh1[1] sdi1[3] sdm1[7] sdg1[0] sdl1[4]
sdj1[2]
      17580804096 blocks super 1.2 level 5, 512k chunk, algorithm 2
[7/7] [UUUUUUU]
      bitmap: 0/22 pages [0KB], 65536KB chunk

unused devices: <none>

Output of dmesg:
[ 7351.071351] md: bind<sdf1>
[ 7351.398116] RAID conf printout:
[ 7351.398123]  --- level:5 rd:4 wd:4
[ 7351.398127]  disk 0, o:1, dev:sdb1
[ 7351.398131]  disk 1, o:1, dev:sdc1
[ 7351.398134]  disk 2, o:1, dev:sdd1
[ 7351.398136]  disk 3, o:1, dev:sde1
[ 7420.751226] RAID conf printout:
[ 7420.751234]  --- level:5 rd:5 wd:5
[ 7420.751239]  disk 0, o:1, dev:sdb1
[ 7420.751242]  disk 1, o:1, dev:sdc1
[ 7420.751245]  disk 2, o:1, dev:sdd1
[ 7420.751248]  disk 3, o:1, dev:sde1
[ 7420.751251]  disk 4, o:1, dev:sdf1
[ 7420.751524] md: reshape of RAID array md1
[ 7420.751530] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[ 7420.751534] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for reshape.
[ 7420.751542] md: using 128k window, over a total of 3906885632k.


The array is used as the physical volume for a single volume group
which I deactivated before performing the mdadm grow.

Can you tell me what I should do to get the reshape to start (and
complete) or rescue the array?

Thank you in advance for any help! 

Dan


