From: Janek Kozicki <janek_listy@wp.pl>
Subject: raid5 failed while rebuiling - classical problem
Date: Fri, 2 Jul 2010 16:31:55 +0200
Message-ID: <20100702163155.511919c1@atak.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,


Following is a lengthy and full explanation of my problem. A short
summary is at the end. It is possible that you already know the
answer without reading this, then please just scroll down and help
me ;-)


I saw smartmontools reporting that sdc has 

Jul  1 10:19:52 backup_ smartd[2793]: Device: /dev/sdc, 1 Currently unreadable (pending) sectors  

My md1 layout was at that time following:

/dev/md1: 
        Version : 01.01.03
  Creation Time : Fri Nov  2 23:35:37 2007
     Raid Level : raid5
     Array Size : 1933614592 (1844.04 GiB 1980.02 GB)
    Device Size : 966807296 (461.01 GiB 495.01 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Jul  1 11:14:03 2010
          State : active
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 128K

           Name : backup:1  (local to host backup)
           UUID : 22f22c35:99613d52:31d407a6:55bdeb84
         Events : 718999

    Number   Major   Minor   RaidDevice State
       5       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
       3       3        3        2      active sync   /dev/hda3
       4       8       51        3      active sync   /dev/sdd3
       6       8       35        4      active sync   /dev/sdc3

I wanted to get this corrected, so I ran following command, but it
didn't help:

 /usr/share/mdadm/checkarray -a

So I wanted to test sdc more thoroughly, to get this fixed:

$ mdmadm --fail /dev/md1 /dev/sdc3
mdadm: set /dev/sdc3 faulty in /dev/md1

$ mdmadm --remove /dev/md1 /dev/sdc3
mdadm: hot removed /dev/sdc3

$ badblocks -c 10240 -s -w -t random -v /dev/sdc3
Checking for bad blocks in read-write mode
From block 0 to 483403882
Testing with random pattern: done
Reading and comparing: done
Pass completed, 0 bad blocks found.

$ mdmadm --add /dev/md1 /dev/sdc3
mdadm: added /dev/sdc3

$ mdadm -D /dev/md1
/dev/md1: 
        Version : 01.01.03
  Creation Time : Fri Nov  2 23:35:37 2007
     Raid Level : raid5
     Array Size : 1933614592 (1844.04 GiB 1980.02 GB)
    Device Size : 966807296 (461.01 GiB 495.01 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Thu Jul  1 18:19:47 2010
          State : active, degraded, recovering
 Active Devices : 4
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 128K

 Rebuild Status : 0% complete

           Name : backup:1  (local to host backup)
           UUID : 22f22c35:99613d52:31d407a6:55bdeb84
         Events : 733802

    Number   Major   Minor   RaidDevice State
       5       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
       3       3        3        2      active sync   /dev/hda3
       4       8       51        3      active sync   /dev/sdd3
       6       8       35        4      spare rebuilding   /dev/sdc3

Ok, so I left it to rebuild. But then... hda3 failed.

I wasn't there when it happened. But this what I see in syslog:

Jul  1 22:34:49 backup_ mdadm: Rebuild60 event detected on md device /dev/md1 
Jul  1 22:49:51 backup_ smartd[2793]: Device: /dev/hda, SMART Usage Attribute: 194 Temperature_Celsius changed from 122 to 121  
Jul  1 22:49:51 backup_ smartd[2793]: Device: /dev/sda, SMART Usage Attribute: 194 Temperature_Celsius changed from 214 to 222  
Jul  1 22:49:52 backup_ smartd[2793]: Device: /dev/sdd, SMART Prefailure Attribute: 1 Raw_Read_Error_Rate changed from 118 to 108  
Jul  1 22:49:52 backup_ smartd[2793]: Device: /dev/sdd, SMART Usage Attribute: 195 Hardware_ECC_Recovered changed from 47 to 48  
Jul  1 23:42:25 backup_ uptimed: moving up to position 33: 8 days, 05:23:01 
Jul  1 23:49:51 backup_ smartd[2793]: Device: /dev/sda, SMART Usage Attribute: 194 Temperature_Celsius changed from 214 to 222  
Jul  1 23:49:53 backup_ smartd[2793]: Device: /dev/sdd, SMART Prefailure Attribute: 1 Raw_Read_Error_Rate changed from 115 to 117  
Jul  1 23:49:53 backup_ smartd[2793]: Device: /dev/sdd, SMART Usage Attribute: 190 Airflow_Temperature_Cel changed from 68 to 69  
Jul  1 23:49:53 backup_ smartd[2793]: Device: /dev/sdd, SMART Usage Attribute: 194 Temperature_Celsius changed from 32 to 31  
Jul  1 23:49:53 backup_ smartd[2793]: Device: /dev/sdd, SMART Usage Attribute: 195 Hardware_ECC_Recovered changed from 47 to 48  
Jul  1 23:55:25 backup_ uptimed: moving up to position 32: 8 days, 05:36:01 
Jul  1 23:58:07 backup_ kernel: hda: dma_intr: status=0x51 { DriveReady SeekComplete Error } 
Jul  1 23:58:07 backup_ kernel: hda: dma_intr: error=0x40 { UncorrectableError }, LBAsect=773056484, high=46, low=1304548, sector=773055468 
Jul  1 23:58:07 backup_ kernel: ide: failed opcode was: unknown 
Jul  1 23:58:07 backup_ kernel: end_request: I/O error, dev hda, sector 773055468 
Jul  1 23:58:07 backup_ kernel: raid5:md1: read error not correctable (sector 763095168 on hda3). 
Jul  1 23:58:07 backup_ kernel: raid5: Disk failure on hda3, disabling device. Operation continuing on 3 devices 
Jul  1 23:58:10 backup_ kernel: Buffer I/O error on device md1, logical block 26544335 
Jul  1 23:58:10 backup_ kernel: lost page write due to I/O error on md1 
Jul  1 23:58:10 backup_ kernel: Buffer I/O error on device md1, logical block 26544336 
Jul  1 23:58:10 backup_ kernel: lost page write due to I/O error on md1 
Jul  1 23:58:10 backup_ kernel: Buffer I/O error on device md1, logical block 26544337 
Jul  1 23:58:10 backup_ kernel: lost page write due to I/O error on md1 
Jul  1 23:58:10 backup_ kernel: Buffer I/O error on device md1, logical block 26544338 
Jul  1 23:58:10 backup_ kernel: lost page write due to I/O error on md1 
Jul  1 23:58:10 backup_ kernel: Buffer I/O error on device md1, logical block 26544339 
Jul  1 23:58:10 backup_ kernel: lost page write due to I/O error on md1 
Jul  1 23:58:10 backup_ kernel: Buffer I/O error on device md1, logical block 26544340 
Jul  1 23:58:10 backup_ kernel: lost page write due to I/O error on md1 
Jul  1 23:58:10 backup_ kernel: Buffer I/O error on device md1, logical block 26544341 
Jul  1 23:58:10 backup_ kernel: lost page write due to I/O error on md1 
Jul  1 23:58:10 backup_ kernel: Buffer I/O error on device md1, logical block 26544342 
Jul  1 23:58:10 backup_ kernel: lost page write due to I/O error on md1 
Jul  1 23:58:10 backup_ kernel: Buffer I/O error on device md1, logical block 26544343 
Jul  1 23:58:10 backup_ kernel: lost page write due to I/O error on md1 
Jul  1 23:58:10 backup_ kernel: Buffer I/O error on device md1, logical block 26544344 
Jul  1 23:58:10 backup_ kernel: lost page write due to I/O error on md1 
Jul  1 23:58:10 backup_ kernel: Aborting journal on device md1. 
Jul  1 23:58:10 backup_ kernel: md: md1: recovery done. 
Jul  1 23:58:10 backup_ mdadm: Fail event detected on md device /dev/md1, component device /dev/hda3 
Jul  1 23:58:10 backup_ kernel: ext3_abort called. 
Jul  1 23:58:10 backup_ kernel: EXT3-fs error (device md1): ext3_journal_start_sb: Detected aborted journal 
Jul  1 23:58:10 backup_ kernel: Remounting filesystem read-only 
Jul  1 23:58:10 backup_ kernel: RAID5 conf printout: 
Jul  1 23:58:10 backup_ kernel:  --- rd:5 wd:3 
Jul  1 23:58:10 backup_ kernel:  disk 0, o:1, dev:sda3 
Jul  1 23:58:10 backup_ kernel:  disk 1, o:1, dev:sdb3 
Jul  1 23:58:10 backup_ kernel:  disk 2, o:0, dev:hda3 
Jul  1 23:58:10 backup_ kernel:  disk 3, o:1, dev:sdd3 
Jul  1 23:58:10 backup_ kernel:  disk 4, o:1, dev:sdc3 
Jul  1 23:58:10 backup_ kernel: RAID5 conf printout: 
Jul  1 23:58:10 backup_ kernel:  --- rd:5 wd:3 
Jul  1 23:58:10 backup_ kernel:  disk 0, o:1, dev:sda3 
Jul  1 23:58:10 backup_ kernel:  disk 1, o:1, dev:sdb3 
Jul  1 23:58:10 backup_ kernel:  disk 2, o:0, dev:hda3 
Jul  1 23:58:10 backup_ kernel:  disk 3, o:1, dev:sdd3 
Jul  1 23:58:10 backup_ kernel: RAID5 conf printout: 
Jul  1 23:58:10 backup_ kernel:  --- rd:5 wd:3 
Jul  1 23:58:10 backup_ kernel:  disk 0, o:1, dev:sda3 
Jul  1 23:58:10 backup_ kernel:  disk 1, o:1, dev:sdb3 
Jul  1 23:58:10 backup_ kernel:  disk 2, o:0, dev:hda3 
Jul  1 23:58:10 backup_ kernel:  disk 3, o:1, dev:sdd3 
Jul  1 23:58:10 backup_ kernel: RAID5 conf printout: 
Jul  1 23:58:10 backup_ kernel:  --- rd:5 wd:3 
Jul  1 23:58:10 backup_ kernel:  disk 0, o:1, dev:sda3 
Jul  1 23:58:10 backup_ kernel:  disk 1, o:1, dev:sdb3 
Jul  1 23:58:10 backup_ kernel:  disk 3, o:1, dev:sdd3 
Jul  1 23:58:10 backup_ mdadm: RebuildFinished event detected on md device /dev/md1 
Jul  2 00:19:50 backup_ smartd[2793]: Device: /dev/hda, 1 Currently unreadable (pending) sectors  
Jul  2 00:19:50 backup_ smartd[2793]: Sending warning via /usr/share/smartmontools/smartd-runner to root ...  
Jul  2 00:19:50 backup_ smartd[2793]: Warning via /usr/share/smartmontools/smartd-runner to root: successful  
Jul  2 00:19:50 backup_ smartd[2793]: Device: /dev/hda, SMART Usage Attribute: 194 Temperature_Celsius changed from 121 to 122  
Jul  2 00:19:50 backup_ smartd[2793]: Device: /dev/hda, ATA error count increased from 0 to 1  
Jul  2 00:19:50 backup_ smartd[2793]: Sending warning via /usr/share/smartmontools/smartd-runner to root ...  
Jul  2 00:19:50 backup_ smartd[2793]: Warning via /usr/share/smartmontools/smartd-runner to root: successful  
Jul  2 00:19:50 backup_ smartd[2793]: Device: /dev/sda, SMART Prefailure Attribute: 1 Raw_Read_Error_Rate changed from 100 to 94  
Jul  2 00:19:51 backup_ smartd[2793]: Device: /dev/sdb, SMART Usage Attribute: 190 Airflow_Temperature_Cel changed from 69 to 70  
Jul  2 00:19:51 backup_ smartd[2793]: Device: /dev/sdb, SMART Usage Attribute: 194 Temperature_Celsius changed from 31 to 30  
Jul  2 00:19:51 backup_ smartd[2793]: Device: /dev/sdb, SMART Usage Attribute: 195 Hardware_ECC_Recovered changed from 66 to 64  
Jul  2 00:19:51 backup_ smartd[2793]: Device: /dev/sdc, SMART Usage Attribute: 194 Temperature_Celsius changed from 115 to 116  
Jul  2 00:19:51 backup_ smartd[2793]: Device: /dev/sdd, SMART Prefailure Attribute: 1 Raw_Read_Error_Rate changed from 117 to 118  
Jul  2 00:19:51 backup_ smartd[2793]: Device: /dev/sdd, SMART Usage Attribute: 195 Hardware_ECC_Recovered changed from 48 to 49  


And so in the end I have /dev/hda, 1 Currently unreadable (pending)
sectors, whereas in the beginning that was the error that got me
worried about sdc. Except that this time my raid5 is down:

$ mdadm -D /dev/md1
/dev/md1: 
        Version : 01.01.03
  Creation Time : Fri Nov  2 23:35:37 2007
     Raid Level : raid5
     Array Size : 1933614592 (1844.04 GiB 1980.02 GB)
    Device Size : 966807296 (461.01 GiB 495.01 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Fri Jul  2 15:25:45 2010
          State : active, degraded
 Active Devices : 3
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 128K

           Name : backup:1  (local to host backup)
           UUID : 22f22c35:99613d52:31d407a6:55bdeb84
         Events : 742938

    Number   Major   Minor   RaidDevice State
       5       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
       2       0        0        2      removed
       4       8       51        3      active sync   /dev/sdd3
       4       0        0        4      removed

       3       3        3        -      faulty spare   /dev/hda3
       6       8       35        -      spare   /dev/sdc3

The filesystem /backup is still mounted, albeit readonly:

backup:~$ pydf
Filesystem             Size   Used  Avail  Use%           Mounted on
/dev/md/0              942M   836M    77M  88.8 [###### ] /
/dev/md/1             1815G  1736G    24G  95.6 [#######] /backup
udev                    10M   128k    10M   1.3 [       ] /dev
tmpfs                  379M      0   379M   0.0 [       ] /dev/shm
tmpfs                  379M      0   379M   0.0 [       ] /lib/init/rw

backup:~$ ls -la /backup/
total 80
drwxr-xr-x 29 root    root    4096 Jul  1 16:20 .
drwxr-xr-x 24 root    root    4096 Mar  4 14:15 ..
drwxr-xr-x 11 salomea salomea 4096 Jul  1 23:46 .mldonkey
drwxr-xr-x 10 root    root    4096 Jul  1 14:59 .sync
?---------  ? ?       ?          ?            ? /backup/1_daily.4
?---------  ? ?       ?          ?            ? /backup/1_daily.5
?---------  ? ?       ?          ?            ? /backup/1_daily.6
?---------  ? ?       ?          ?            ? /backup/2_weekly.0
?---------  ? ?       ?          ?            ? /backup/3_monthly.3
?---------  ? ?       ?          ?            ? /backup/3_monthly.5
?---------  ? ?       ?          ?            ? /backup/lost+found
drwxr-xr-x 10 root    root    4096 Jul  1 14:59 0_hourly.0
drwxr-xr-x 10 root    root    4096 Jul  1 02:23 0_hourly.1
drwxr-xr-x 10 root    root    4096 Jun 30 18:31 0_hourly.2
drwxr-xr-x 10 root    root    4096 Jun 30 14:54 1_daily.0
drwxr-xr-x 10 root    root    4096 Jun 29 14:50 1_daily.1
drwxr-xr-x 10 root    root    4096 Jun 28 14:21 1_daily.2
drwxr-xr-x 10 root    root    4096 Jun 26 14:34 1_daily.3
drwxr-xr-x 10 root    root    4096 Jun 16 15:00 2_weekly.1
drwxr-xr-x 10 root    root    4096 Jun  8 14:33 2_weekly.2
drwxr-xr-x 10 root    root    4096 Jun  1 14:40 2_weekly.3
drwxr-xr-x 10 root    root    4096 May 24 14:32 3_monthly.0
drwxr-xr-x 10 root    root    4096 Apr 17 14:59 3_monthly.1
drwxr-xr-x 10 root    root    4096 Mar 24 02:19 3_monthly.2
drwxr-xr-x 10 root    root    4096 Jan 23 10:50 3_monthly.4

I suppose that this is a classic situation. I decided to wait for
your help before making it worse. sdc is irrecoverable, because I
tested it in read-write mode. But hda has been just removed, only due
to 1 damaged sector. I would much prefer to have all 2 TB intact with
just several kilobytes lost, than losing whole partition.

Please help me to assemble this array back, and I will instantly
replace hda with another 500GB drive that I have just
bought: /dev/hdc3 is ready, fresh from the shop and waiting. I just
don't know how to add it to the array now.

To summarize:

- /dev/md1 had following layout beforehand:

    Number   Major   Minor   RaidDevice State
       5       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
       3       3        3        2      active sync   /dev/hda3
       4       8       51        3      active sync   /dev/sdd3
       6       8       35        4      active sync   /dev/sdc3

- now it has following layout:

    Number   Major   Minor   RaidDevice State
       5       8        3        0      active sync   /dev/sda3
       1       8       19        1      active sync   /dev/sdb3
       2       0        0        2      removed
       4       8       51        3      active sync   /dev/sdd3
       4       0        0        4      removed

       3       3        3        -      faulty spare   /dev/hda3
       6       8       35        -      spare   /dev/sdc3

- now /dev/sdc3 is after read-write test, thus unusable, although in good condition
- now /dev/hda3 contains valid filesystem data, except for one
  damaged sector, which kicked it out of the array.

1. I would like to reassamble the array using (a little damaged) /dev/hda3
2. then add a newly purchased /dev/hdc3, remove /dev/hda3 and add /dev/sdc3 too

Next I plan to migrate all that into a raid6 configuration. But let's first fix this.

If you need any more information please let me know. I have /proc/mdstat
output also, from before the problem, and after the problem.

I am sorry, that I didn't upgrade my backup server yet:

backup:~# uname -a
Linux backup 2.6.24-etchnhalf.1-686 #1 SMP Sat Aug 15 16:51:49 UTC 2009 i686 GNU/Linux

After we fix this I plan to upgrade to debian squeeze and use latest kernel.

best regards
-- 
Janek Kozicki                               http://janek.kozicki.pl/  |
