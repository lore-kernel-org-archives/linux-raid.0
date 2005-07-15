From: "David M. Strang" <dstrang@shellpower.net>
Subject: Raid5 Failure
Date: Thu, 14 Jul 2005 20:39:41 -0400
Message-ID: <001401c588d5$b0b15370$c200a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello -

I'm currently stuck in a moderately awkward predicament. I have a 28 disk 
software RAID5; at the time I created it I was using EVMS - this was because 
mdadm 1.x didn't support superblock v1 and mdadm 2.x wouldn't compile on my 
system. Everything was working great; until I had an unusual kernel error:

Jun 20 02:55:07 abyss last message repeated 33 times
Jun 20 02:55:07 abyss kernel: KERNEL: assertion (flags & MSG_PEEK) failed at 
net/ 59A9F3C
Jun 20 02:55:07 abyss kernel: KERNEL: assertion (flags & MSG_PEEK) failed at 
net/ipv4/tcp.c (1294)

I used to get this error randomly; a reboot would resolve it - the final fix 
was to update the kernel. The reason I even noticed the error this time, was 
because I was attempting to access my RAID, and some of the data wouldn't 
come up. I did a cat /proc/mdstat and it said 13 of the 28 devices were 
failed. I checked /var/log/kernel and the above message was spamming the log 
repeatedly.

Upon reboot, I fired up EVMSGui to remount the raid - and I received the 
following error messages:

Jul 14 20:17:46 abyss _3_ Engine: engine_ioctl_object: ioctl to object 
md/md0 failed with error code 19: No such device
Jul 14 20:17:47 abyss _3_ MDRaid5RegMgr: md_analyze_volume: Object sda is 
out of date.
Jul 14 20:17:47 abyss _3_ MDRaid5RegMgr: md_analyze_volume: Object sdb is 
out of date.
Jul 14 20:17:47 abyss _3_ MDRaid5RegMgr: md_analyze_volume: Object sdc is 
out of date.
Jul 14 20:17:47 abyss _3_ MDRaid5RegMgr: md_analyze_volume: Object sdd is 
out of date.
Jul 14 20:17:47 abyss _3_ MDRaid5RegMgr: md_analyze_volume: Object sde is 
out of date.
Jul 14 20:17:47 abyss _3_ MDRaid5RegMgr: md_analyze_volume: Object sdf is 
out of date.
Jul 14 20:17:47 abyss _3_ MDRaid5RegMgr: md_analyze_volume: Object sdg is 
out of date.
Jul 14 20:17:47 abyss _3_ MDRaid5RegMgr: md_analyze_volume: Object sdh is 
out of date.
Jul 14 20:17:47 abyss _3_ MDRaid5RegMgr: md_analyze_volume: Object sdi is 
out of date.
Jul 14 20:17:47 abyss _3_ MDRaid5RegMgr: md_analyze_volume: Object sdj is 
out of date.
Jul 14 20:17:47 abyss _3_ MDRaid5RegMgr: md_analyze_volume: Object sdk is 
out of date.
Jul 14 20:17:47 abyss _3_ MDRaid5RegMgr: md_analyze_volume: Object sdl is 
out of date.
Jul 14 20:17:47 abyss _3_ MDRaid5RegMgr: md_analyze_volume: Object sdm is 
out of date.
Jul 14 20:17:47 abyss _3_ MDRaid5RegMgr: md_analyze_volume: Found 13 stale 
objects in region md/md0.
Jul 14 20:17:47 abyss _0_ MDRaid5RegMgr: sb1_analyze_sb: MD region md/md0 is 
corrupt
Jul 14 20:17:47 abyss _3_ MDRaid5RegMgr: md_fix_dev_major_minor: MD region 
md/md0 is corrupt.
Jul 14 20:17:47 abyss _0_ Engine: plugin_user_message: Message is: 
MDRaid5RegMgr: Region md/md0 : MD superblocks found in object(s) [sda sdb 
sdc sdd sde sdf sdg sdh sdi sdj sdk sdl sdm ] are not valid.  [sda sdb sdc 
sdd sde sdf sdg sdh sdi sdj sdk sdl sdm ] will not be activated and should 
be removed from the region.

Jul 14 20:17:47 abyss _0_ Engine: plugin_user_message: Message is: 
MDRaid5RegMgr: RAID5 region md/md0 is corrupt.  The number of raid disks for 
a full functional array is 28.  The number of active disks is 15.
Jul 14 20:17:47 abyss _2_ MDRaid5RegMgr: raid5_read: MD Object md/md0 is 
corrupt, data is suspect
Jul 14 20:17:47 abyss _2_ MDRaid5RegMgr: raid5_read: MD Object md/md0 is 
corrupt, data is suspect

I realize this is not the EVMS mailing list; I tried earlier (I've been 
swamped at work) with no success on resolving this issue there. Today, I 
tried mdadm 2.0-devel-2. It compiled w/o issue. I did a mdadm --misc -Q 
/dev/sdm.

-(root@abyss)-(~/mdadm-2.0-devel-2)- # ./mdadm --misc -Q /dev/sdm
/dev/sdm: is not an md array
/dev/sdm: device 134639616 in 28 device undetected raid5 md-1.  Use 
mdadm --examine for more detail.

-(root@abyss)-(~/mdadm-2.0-devel-2)- # ./mdadm --misc -E /dev/sdm
/dev/sdm:
          Magic : a92b4efc
        Version : 01.00
     Array UUID : 4e2b6b0a8e:92e91c0c:018a4bf0:9bb74d
           Name : md/md0
  Creation Time : Wed Dec 31 19:00:00 1969
     Raid Level : raid5
   Raid Devices : 28

    Device Size : 143374592 (68.37 GiB 73.41 GB)
   Super Offset : 143374632 sectors
          State : clean
    Device UUID : 4e2b6b0a8e:92e91c0c:018a4bf0:9bb74d
    Update Time : Sun Jun 19 14:49:52 2005
       Checksum : 296bf133 - correct
         Events : 172758

         Layout : left-asymmetric
     Chunk Size : 128K

   Array State : uuuuuuuuuuuuUuuuuuuuuuuuuuuu

After which, I checked on /dev/sdn.

-(root@abyss)-(~/mdadm-2.0-devel-2)- # ./mdadm --misc -Q /dev/sdn
/dev/sdn: is not an md array
/dev/sdn: device 134639616 in 28 device undetected raid5 md-1.  Use 
mdadm --examine for more detail.

-(root@abyss)-(~/mdadm-2.0-devel-2)- # ./mdadm --misc -E /dev/sdn
/dev/sdn:
          Magic : a92b4efc
        Version : 01.00
     Array UUID : 4e2b6b0a8e:92e91c0c:018a4bf0:9bb74d
           Name : md/md0
  Creation Time : Wed Dec 31 19:00:00 1969
     Raid Level : raid5
   Raid Devices : 28

    Device Size : 143374592 (68.37 GiB 73.41 GB)
   Super Offset : 143374632 sectors
          State : active
    Device UUID : 4e2b6b0a8e:92e91c0c:018a4bf0:9bb74d
    Update Time : Sun Jun 19 14:49:57 2005
       Checksum : 857961c1 - correct
         Events : 172759

         Layout : left-asymmetric
     Chunk Size : 128K

   Array State : uuuuuuuuuuuuuUuuuuuuuuuuuuuu

It looks like the first 'segment of discs' sda->sdm are all marked clean; 
while sdn->sdab are marked active.

What can I do to resolve this issue? Any assistance would be greatly 
appreciated.

-- David M. Strang

