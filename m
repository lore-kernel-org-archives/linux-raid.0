From: Paul Waldo <pwaldo@waldoware.com>
Subject: Re: Can't add disk to failed raid array
Date: Sun, 16 Jul 2006 10:39:29 -0400
Message-ID: <200607161039.29838.pwaldo@waldoware.com>
References: <200607152056.55090.pwaldo@waldoware.com> <200607160913.32005.pwaldo@waldoware.com> <Pine.LNX.4.62.0607161524170.7520@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.62.0607161524170.7520@uplift.swm.pp.se>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Mikael Abrahamsson <swmike@swm.pp.se>
List-Id: linux-raid.ids

Still no joy after zeroing the superblock,  Mikael.  :-(

[root@paul ~]# mdadm --examine /dev/hdd2
/dev/hdd2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 2e316d9e:20cac82a:2555918e:bb9acc07
  Creation Time : Fri Jun 23 22:35:27 2006
     Raid Level : raid6
    Device Size : 155308288 (148.11 GiB 159.04 GB)
     Array Size : 776541440 (740.57 GiB 795.18 GB)
   Raid Devices : 7
  Total Devices : 6
Preferred Minor : 1

    Update Time : Sun Jul 16 09:10:41 2006
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 6bdf5797 - correct
         Events : 0.1401144


      Number   Major   Minor   RaidDevice State
this     2      22       66       -1      sync   /dev/hdd2

   0     0       3        2        0      active sync   /dev/hda2
   1     1      22        2        1      active sync   /dev/hdc2
   2     2      22       66       -1      sync   /dev/hdd2
   3     3      33        2        3      active sync   /dev/hde2
   4     4      34        2        4      active sync   /dev/hdg2
   5     5       8        2        5      active sync   /dev/sda2
   6     6       8       18        6      active sync   /dev/sdb2
[root@paul ~]# cat /proc/mdstat
Personalities : [raid6] [raid1]
md0 : active raid1 hda1[0] hdc1[1] hdd1[2](S) hde1[3](S) hdg1[4](S) sda1[5](S) 
sdb1[6](S)
      979840 blocks [2/2] [UU]

md1 : active raid6 sdb2[6] sda2[5] hdg2[4] hde2[3] hdc2[1] hda2[0]
      776541440 blocks level 6, 256k chunk, algorithm 2 [7/6] [UU_UUUU]

unused devices: <none>
[root@paul ~]# mdadm --examine /dev/hdd2|grep -i super
[root@paul ~]# mdadm --misc --zero-superblock /dev/hdd2
[root@paul ~]# cat /proc/mdstat
Personalities : [raid6] [raid1]
md0 : active raid1 hda1[0] hdc1[1] hdd1[2](S) hde1[3](S) hdg1[4](S) sda1[5](S) 
sdb1[6](S)
      979840 blocks [2/2] [UU]

md1 : active raid6 sdb2[6] sda2[5] hdg2[4] hde2[3] hdc2[1] hda2[0]
      776541440 blocks level 6, 256k chunk, algorithm 2 [7/6] [UU_UUUU]

unused devices: <none>
[root@paul ~]# mdadm --add /dev/md1  /dev/hdd2
mdadm: add new device failed for /dev/hdd2 as 2: Invalid argument
[root@paul ~]# tail -5 /var/log/messages
Jul 16 09:10:42 paul kernel: md: md_import_device returned -22
Jul 16 09:10:42 paul kernel: md: hdd2 has invalid sb, not importing!
Jul 16 09:10:42 paul kernel: md: md_import_device returned -22
Jul 16 10:33:33 paul kernel: md: hdd2 has invalid sb, not importing!
Jul 16 10:33:33 paul kernel: md: md_import_device returned -22


On Sunday 16 July 2006 9:26 am, you wrote:
> On Sun, 16 Jul 2006, Paul Waldo wrote:
>
> The superblock is at the end so you probably didnt clear it. Use "mdadm
> --examine /dev/hdd2" and see what it says. If it does say it has a
> superblock, use "--misc --zero-superblock /dev/hdd2"
