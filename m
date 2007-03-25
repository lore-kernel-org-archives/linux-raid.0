From: Robert Stanford <rob@stanford.com.au>
Subject: addingdrive to raid 1
Date: Sun, 25 Mar 2007 16:44:49 +1000
Message-ID: <46061A61.7030806@stanford.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All, Long time Linux software raid user, first real problem.

I built md2 with 1 missing drive and am now trying to add a drive (hda4)

The partition that is hda4 was previously part of another  raid array 
md1 that no longer exists.

I have zeroed the superblock in hda4, however when I try to add it it 
sync's instantly, no rebuild.

The original raid array md1 is several years old and was built with the 
old raidtools package.

I even ran
dd if=/dev/zero of=/dev/hda4
just to be sure that nothing was left on the partition from the previous 
raid setup and still no joy.

Any help would be appreciated

Kind Regards
Robert Stanford

---------------------------------------------------------
/proc/mdstat
Personalities : [raid1]
md2 : active raid1 hdc4[0]
      72894848 blocks [2/1] [U_]



mdadm --examine /dev/hdc4
/dev/hdc4:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 90844a43:c57dd8a1:5a5eed64:48faee6c
  Creation Time : Sat Mar 24 06:33:03 2007
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 2

    Update Time : Sun Mar 25 16:30:59 2007
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 32ea145b - correct
         Events : 0.5610


      Number   Major   Minor   RaidDevice State
this     0      22        4        0      active sync   /dev/hdc4

   0     0      22        4        0      active sync   /dev/hdc4
   1     1       0        0        1      faulty removed



mdadm --examine /dev/hda4
mdadm: No super block found on /dev/hda4 (Expected magic a92b4efc, got 
00000000)



mdadm --add /dev/md2 /dev/hda4
mdadm: hot added /dev/hda4



Personalities : [raid1]
md2 : active raid1 hda4[1] hdc4[0]
      72894848 blocks [2/2] [UU]



 /var/log/kern.log
Mar 25 16:33:11 server kernel: md: bind<hda4>
Mar 25 16:33:11 server kernel: RAID1 conf printout:
Mar 25 16:33:11 server kernel:  --- wd:1 rd:2
Mar 25 16:33:11 server kernel:  disk 0, wo:0, o:1, dev:hdc4
Mar 25 16:33:11 server kernel:  disk 1, wo:1, o:1, dev:hda4
Mar 25 16:33:11 server kernel: md: syncing RAID array md2
Mar 25 16:33:11 server kernel: md: minimum _guaranteed_ reconstruction 
speed: 1000 KB/sec/disc.
Mar 25 16:33:11 server kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for reconstruction.
Mar 25 16:33:11 server kernel: md: using 128k window, over a total of 
72894848 blocks.
Mar 25 16:33:11 server kernel: md: md2: sync done.
Mar 25 16:33:11 server kernel: RAID1 conf printout:
Mar 25 16:33:11 server kernel:  --- wd:2 rd:2
Mar 25 16:33:11 server kernel:  disk 0, wo:0, o:1, dev:hdc4
Mar 25 16:33:11 server kernel:  disk 1, wo:0, o:1, dev:hda4



mdadm --set-faulty  /dev/md2 /dev/hda4
mdadm: set /dev/hda4 faulty in /dev/md2
mdadm -r  /dev/md2 /dev/hda4
mdadm: hot removed /dev/hda4
mdadm --zero-superblock /dev/hda4



/var/log/kern.log
Mar 25 16:34:09 server kernel: raid1: Disk failure on hda4, disabling 
device.
Mar 25 16:34:09 server kernel: ^IOperation continuing on 1 devices
Mar 25 16:34:09 server kernel: RAID1 conf printout:
Mar 25 16:34:09 server kernel:  --- wd:1 rd:2
Mar 25 16:34:09 server kernel:  disk 0, wo:0, o:1, dev:hdc4
Mar 25 16:34:09 server kernel:  disk 1, wo:1, o:0, dev:hda4
Mar 25 16:34:09 server kernel: RAID1 conf printout:
Mar 25 16:34:09 server kernel:  --- wd:1 rd:2
Mar 25 16:34:09 server kernel:  disk 0, wo:0, o:1, dev:hdc4
Mar 25 16:34:13 server kernel: md: unbind<hda4>
Mar 25 16:34:13 server kernel: md: export_rdev(hda4)



mdadm --examine /dev/hda4
/dev/hda4:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 90844a43:c57dd8a1:5a5eed64:48faee6c
  Creation Time : Sat Mar 24 06:33:03 2007
     Raid Level : raid1
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 2

    Update Time : Sun Mar 25 16:33:11 2007
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 32ea14e0 - correct
         Events : 0.5616


      Number   Major   Minor   RaidDevice State
this     1       3        4        1      active sync   /dev/hda4

   0     0      22        4        0      active sync   /dev/hdc4
   1     1       3        4        1      active sync   /dev/hda4


