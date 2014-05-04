From: "L.M.J" <linuxmasterjedi@free.fr>
Subject: Big mistake while changing a RAID5 disk (was Corrupted ext4
 filesystem ...)
Date: Sun, 4 May 2014 10:33:37 +0200
Message-ID: <20140504103337.1db08101@netstation>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

  Sorry to ask for help again, I want to start from a fresh email to be sure I explain my problem correctly.

  Here is my story 10 days again :
 
  1) My 2 years old 3 disks RAID5 got a faulty drive : sdb, sdc and sdd remains good.

  2) I maked sdb1 as faulty : mdadm --fail /dev/md0 /dev/sdb1

  3) Stopped my computer, removed sdb and put a new hard drive

  4) Restarted the computer and then, the RAID5 didn't want to start by itself (should be in degraded mode).
  Maybe I've mixed up SATA cables ?

  5) I'm not a mdadm expert, after a couple of minutes on Google, I've found a command who looked quite
  good to me. I made a new partition on sdb (sdb1) and : 
  ~# mdadm -Cv /dev/md0 --assume-clean --level=5 --raid-devices=3 /dev/sdc1 /dev/sdd1 /dev/sdb1
  -> several mistakes here : "-C" was not a good option, mix drive order...

  6) I had LVM on this md0, so I ran pvdisplay, pvscan, vgdisplay but they returned empty information...

  7) At this time, I didn't know I've did a big mistake... Then, I try to rebuild the array :
  ~# mdadm --create /dev/md0 --level=5 --raid-devices=3 missing /dev/sdd1 /dev/sdc1
  Here am I again : "--create" was not a good option, but I put the right number of drives...
  I guess I've lost all my chance to recover my data here :-(

  8) Then, I try :
  ~# mdadm --assemble --force /dev/md0 /dev/sdc1 /dev/sdd1
  ~# mdadm --add /dev/md0 /dev/sdb1
  pvdisplay still returned empty information.

  9) To be sure if I've wiped out my data or not, I did this
  ~# dd if=/dev/md0 bs=512 count=255 skip=1 of=/tmp/md0.txt
  md0 first bytes still contains valid informations !   

	[..]
	physical_volumes {
		pv0 {
			id = "5DZit9-6o5V-a1vu-1D1q-fnc0-syEj-kVwAnW"
			device = "/dev/md0"
			status = ["ALLOCATABLE"]
			flags = []
			dev_size = 7814047360
			pe_start = 384
			pe_count = 953863
		}
	}
	logical_volumes {
		lvdata {
			id = "JiwAjc-qkvI-58Ru-RO8n-r63Z-ll3E-SJazO7"
			status = ["READ", "WRITE", "VISIBLE"]
			flags = []
			segment_count = 1
	[..]
       
   That's the reason I still want to try to recover my data...
   So, I've done a 
   ~# pvcreate --uuid "5DZit9-6o5V-a1vu-1D1q-fnc0-syEj-kVwAnW" 
	--restorefile /etc/lvm/archive/lvm-raid_00302.vg /dev/md0 
   ~# vgcfgrestore lvm-raid
   ~# lvs -a -o +devices
        LV     VG       Attr   LSize   Origin Snap%  Move Log Copy%  Convert  Devices
        lvmp   lvm-raid -wi-a-  80,00g                                        /dev/md0(263680)
   ~# lvchange -ay /dev/lvm-raid/lv*
   ~# mount /home/foo/RAID_mp/  (ext4 partition)
   ~# df -h /home/foo/RAID_mp
      Filesystem                            Size  Used Avail Use%   Mounted on
      /dev/mapper/lvm--raid-lvmp   79G   61G   19G  77%   /home/foo/RAID_mp
   ~# ls -la /home/foo/RAID_mp
      total 0

    -> that's the big problem, my filesystem seems now corrupted...
   

  8) Sad of my presumed mistakes, I asked help (too late) to linux-lvm and linux-raid
     I tried to recreate the array again without sdb and add it again : same problem.

  9) I did a fsck on a /dev/mapper/lvm--raid-lvmp snapshot (avoid modification on the original filesystem). It
  recovered around 50% of the files only, all located in lost+found/ directory with names starting with
  #xxxxx.

  10) Last news : yesterday, I rebooted my computer after an upgrade and now, the RAID is not available again.
  ~# cat /proc/mdstat 
     Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
     md0 : inactive sdb1[2](S)
           1953511936 blocks
      
     md_d0 : inactive sdc1[1](S)
           1953511936 blocks

   What is md_d0 ? Where is my RAID5 md0 with sdb1/sdc1/sdd1 ?
   Maybe that's a problem from /etc/mdadm/mdadm.conf ?
   ~# cat /etc/mdadm/mdadm.conf
   [...]
   # definitions of existing MD arrays
   ARRAY /dev/md0 level=raid5 num-devices=3 UUID=eb75a31a:35312029:5e3c6b8a:6edaa46b
   ARRAY /dev/md0 level=raid5 num-devices=3 UUID=71b4b533:64c36783:5e3c6b8a:6edaa46b
   [...]

   My mdadm config seems really fuck up, no ? Any chance to recover something ?

   Thanks















