From: Doug Herr <gmane@wombatz.com>
Subject: Replacing a RAID1 drive that has not failed.
Date: Mon, 26 Oct 2015 23:00:38 +0000 (UTC)
Message-ID: <n0mbam$gmk$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think it might be time to replace one or both of my RAID 1 drives.  
They have been giving good service for six years.  Both still have good 
smartctl reports but I am ready to move one out to be used as a member of 
my backup solution using old drives to hold rsync backups.  I would thus 
give my RAID a fresh disk before there is an actual failure.

I recently experimented with adding a third partition to my swap raid 
partition and that went very well, so I was thinking that this would 
provide a safer method to replace one drive compared to failing it and 
then replacing it.

My test makes me think it might be as easy as:

 1. Partition new drive (plugged in via external SATA dock)
Use: fdisk /dev/sdc

 2. Add 3rd partition to each RAID.
Use: mdadm /dev/md4 --grow --raid-devices=3 --add /dev/sdc2

 3. Wait for all the resyncs.
Use: watch cat /proc/mdstat

 4. Fail out sda for each RAID.
Use: mdadm /dev/md4 --fail /dev/sda2

 5. Drop back down to two disk.
Use: mdadm /dev/md4 --grow --raid-devices=2

 6. Make the old partitions "safe".
Use: mdadm --zero-superblock /dev/sdc2

 7. Power down and swap sdc into sda slot.

I only tested that with version 1.2 metadata, so I would be interested if 
there is anything above that would not work with version 0.90.  Also note 
that I did my test using my swap partition but it seems like the 
procedure should not care what sort of partitioning is used.


Below is info about my setup and how I tested to come up with the above 
steps...

I am:
15:40-doug@wombat-~>uname -a
Linux wombat.wombatz.com 4.2.3-200.fc22.x86_64 #1 SMP Thu Oct 8 03:23:55 
UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

15:40-doug@wombat-~>cat /etc/fedora-release 
Fedora release 22 (Twenty Two)

15:40-doug@wombat-~>mdadm -V
mdadm - v3.3.2 - 21st August 2014

My RAID setup:

(I am not using RAID for /boot, instead I rsync /boot to /bootalt each 
night.  Otherwise everything is on RAID 1, including swap.)

15:23-doug@wombat-~/wombat-4/raid/current-2015-10-26>df -hT |grep -v 
^tmpfs
Filesystem     Type      Size  Used Avail Use% Mounted on
devtmpfs       devtmpfs  4.4G     0  4.4G   0% /dev
/dev/md126     ext4       30G   11G   18G  39% /
/dev/sdb1      ext4      579M  126M  411M  24% /bootalt
/dev/md1       ext4       40G   18G   23G  44% /home
/dev/md123     ext4      422G  209G  192G  53% /data2
/dev/md125     ext4      422G   74G  327G  19% /data1
/dev/sda1      ext4      579M  126M  411M  24% /boot

15:09-doug@wombat-~>swapon -s
Filename				Type		Size	Used	
Priority
/dev/md4                               	partition	4946980	0	-1

(I am using UUID for /etc/mdadm.conf and in /etc/fstab so I did not 
bother to "fix" the names when they got changed to md12x during Fedora 
upgrades.)


15:19-doug@wombat-~>cat /proc/mdstat 
Personalities : [raid1] 
md123 : active raid1 sdb7[1] sda7[0]
      448888128 blocks [2/2] [UU]
      bitmap: 0/4 pages [0KB], 65536KB chunk

md125 : active raid1 sdb6[1] sda6[0]
      448888128 blocks [2/2] [UU]
      bitmap: 1/4 pages [4KB], 65536KB chunk

md1 : active raid1 sdb5[0] sda5[2]
      41952620 blocks super 1.2 [2/2] [UU]
      bitmap: 1/1 pages [4KB], 65536KB chunk

md126 : active raid1 sdb3[0] sda3[1]
      31463232 blocks [2/2] [UU]
      bitmap: 1/1 pages [4KB], 65536KB chunk

md4 : active raid1 sdb2[2] sda2[3]
      4946984 blocks super 1.2 [2/2] [UU]
      
unused devices: <none>



Notes from the test I did using a partion on a older and smaller drive...

[root@wombat Documents]# mdadm --detail /dev/md4
/dev/md4:
        Version : 1.2
  Creation Time : Sat Mar 24 16:53:28 2012
     Raid Level : raid1
     Array Size : 4946984 (4.72 GiB 5.07 GB)
  Used Dev Size : 4946984 (4.72 GiB 5.07 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Fri Oct 23 10:55:06 2015
          State : clean 
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : wombat.wombatz.com:4  (local to host wombat.wombatz.com)
           UUID : 2382da1b:c77c04c7:9e4f955c:9450c809
         Events : 541

    Number   Major   Minor   RaidDevice State
       3       8        2        0      active sync   /dev/sda2
       2       8       18        1      active sync   /dev/sdb2


[root@wombat Documents]# fdisk /dev/sdc
[snip]


[root@wombat doug]# mdadm /dev/md4 --grow --raid-devices=3 --add /dev/sdc2
mdadm: added /dev/sdc2
unfreeze


[root@wombat Documents]# cat /proc/mdstat 
[snip]
md4 : active raid1 sdc2[4] sdb2[2] sda2[3]
      4946984 blocks super 1.2 [3/2] [UU_]
      [=======>.............]  recovery = 39.2% (1941056/4946984) 
finish=0.6min speed=71890K/sec

Soon it showed:

md4 : active raid1 sdc2[4] sdb2[2] sda2[3]
      4946984 blocks super 1.2 [3/3] [UUU]


And now:

[root@wombat Documents]# mdadm --detail /dev/md4
/dev/md4:
        Version : 1.2
  Creation Time : Sat Mar 24 16:53:28 2012
     Raid Level : raid1
     Array Size : 4946984 (4.72 GiB 5.07 GB)
  Used Dev Size : 4946984 (4.72 GiB 5.07 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Sat Oct 24 12:57:39 2015
          State : clean 
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

           Name : wombat.wombatz.com:4  (local to host wombat.wombatz.com)
           UUID : 2382da1b:c77c04c7:9e4f955c:9450c809
         Events : 562

    Number   Major   Minor   RaidDevice State
       3       8        2        0      active sync   /dev/sda2
       2       8       18        1      active sync   /dev/sdb2
       4       8       33        2      active sync   /dev/sdc2


Now try to remove it:
[root@wombat doug]# mdadm /dev/md4 --fail /dev/sdc2
mdadm: set /dev/sdc2 faulty in /dev/md4

[root@wombat doug]# mdadm /dev/md4 --grow --raid-devices=2 
raid_disks for /dev/md4 set to 2
unfreeze

Seems good:
md4 : active raid1 sdc2[4](F) sdb2[2] sda2[3]
      4946984 blocks super 1.2 [2/2] [UU]

Just to be safe:
mdadm --zero-superblock /dev/sdc2


-- 
Doug Herr 

