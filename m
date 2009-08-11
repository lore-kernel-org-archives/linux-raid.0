From: Oliver Martin <oliver@volatilevoid.net>
Subject: Re: Rebuild doesn't start
Date: Tue, 11 Aug 2009 15:28:21 +0200
Message-ID: <20090811152821.5e9b7657@ors.home>
References: <20090811015658.53da7ca8@ors.home>
	<edfe4bc699db8383c8f5603a3fefa6c5.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <edfe4bc699db8383c8f5603a3fefa6c5.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Tue, 11 Aug 2009 10:56:02 +1000 (EST) schrieb NeilBrown:

> If you look closely at the "mdadm -D" etc output that you included
> you will see that md1 things that sdi2 is faulty.  Maybe it is.
> You would need to check kernel logs to be sure.

I don't think the drive is bad. SMART values look ok, and md0 didn't
have any problem with re-adding sdi1.

I forgot another strange thing: While I could add sdi1 to md0 and the
rebuild succeeded, I couldn't add sdi2 to md1 until after a reboot. I
always got an error like this:
mdadm: add new device failed for /dev/sdi2: Device or resource busy

When all this happened, I was running 2.6.29.1. Afterwards, I tried
upgrading to 2.6.30.4 to see if that solved the problem, but nothing
changed.

> Yes, bitmaps should prevent a full rebuild.  I would need to see
> kernel logs of when this rebuild happened and "mdadm -D" the
> array to have any hope of guess why it didn't.
> 
> NeilBrown

$ mdadm -D /dev/md0
/dev/md0:
        Version : 1.01
  Creation Time : Sat Mar 15 13:28:07 2008
     Raid Level : raid5
     Array Size : 1953535232 (1863.04 GiB 2000.42 GB)
  Used Dev Size : 488383808 (465.76 GiB 500.11 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Mon Aug 10 19:29:47 2009
          State : active
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : quassel:0  (local to host quassel)
           UUID : 1111b4fd:4219035a:f52968e6:cc4dd971
         Events : 650394

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8       33        1      active sync   /dev/sdc1
       3       8       97        2      active sync   /dev/sdg1
       4       8      129        3      active sync   /dev/sdi1
       5       8       65        4      active sync   /dev/sde1


--- kernel log ---

21:58:14 usb 4-5.2.4: USB disconnect, address 13
21:58:28 usb 4-5.2.4: new high speed USB device using ehci_hcd and address 17
21:58:28 usb 4-5.2.4: configuration #1 chosen from 1 choice
21:58:28 scsi10 : SCSI emulation for USB Mass Storage devices
21:58:28 usb-storage: device found at 17
21:58:28 usb-storage: waiting for device to settle before scanning
21:58:33 usb-storage: device scan complete
21:58:33 scsi 10:0:0:0: Direct-Access     WDC WD10 EACS-00D6B0           PQ: 0 ANSI: 2 CCS
21:58:33 sd 10:0:0:0: [sdi] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
21:58:33 sd 10:0:0:0: [sdi] Write Protect is off
21:58:33 sd 10:0:0:0: [sdi] Mode Sense: 00 38 00 00
21:58:33 sd 10:0:0:0: [sdi] Assuming drive cache: write through
21:58:33 sd 10:0:0:0: [sdi] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
21:58:33 sd 10:0:0:0: [sdi] Write Protect is off
21:58:33 sd 10:0:0:0: [sdi] Mode Sense: 00 38 00 00
21:58:33 sd 10:0:0:0: [sdi] Assuming drive cache: write through
21:58:33  sdi: sdi1 sdi2
21:58:33 sd 10:0:0:0: [sdi] Attached SCSI disk
21:58:33 sd 10:0:0:0: Attached scsi generic sg9 type 0

I think here I unmounted the file system and stopped the LVM device on
the array, but I'm not entirely sure. The initial 17 second delay
suggests that this is the first time the array was accessed after
unplugging the drive, since the drives were all spun down at the time.

22:03:57 md: md0 still in use.
22:03:57 md: md1 still in use.
22:03:57 md: md0 still in use.
22:03:57 md: md1 still in use.
22:04:14 end_request: I/O error, dev sdh, sector 2
22:04:14 md: super_written gets error=-5, uptodate=0
22:04:14 raid5: Disk failure on sdh1, disabling device.
22:04:14 raid5: Operation continuing on 4 devices.
22:04:14 RAID5 conf printout:
22:04:14  --- rd:5 wd:4
22:04:14  disk 0, o:1, dev:sdb1
22:04:14  disk 1, o:1, dev:sdd1
22:04:14  disk 2, o:1, dev:sdg1
22:04:14  disk 3, o:0, dev:sdh1
22:04:14  disk 4, o:1, dev:sde1
22:04:14 RAID5 conf printout:
22:04:14  --- rd:5 wd:4
22:04:14  disk 0, o:1, dev:sdb1
22:04:14  disk 1, o:1, dev:sdd1
22:04:14  disk 2, o:1, dev:sdg1
22:04:14  disk 4, o:1, dev:sde1
22:04:16 md: md0 still in use.
22:04:16 md: md1 still in use.
22:04:16 md: md0 still in use.
22:04:16 md: md1 still in use.
22:04:21 raid5: Disk failure on sdh2, disabling device.
22:04:21 raid5: Operation continuing on 1 devices.
22:04:21 RAID5 conf printout:
22:04:21  --- rd:2 wd:1
22:04:21  disk 0, o:0, dev:sdh2
22:04:21  disk 1, o:1, dev:sde2
22:04:21 RAID5 conf printout:
22:04:21  --- rd:2 wd:1
22:04:21  disk 1, o:1, dev:sde2

/etc/init.d/mdadm-raid stop
This is mdadm 2.6.8 from Debian lenny. That segfault probably shouldn't
have happened...

22:04:32 md: md0 stopped.
22:04:32 md: unbind<sdb1>
22:04:32 md: export_rdev(sdb1)
22:04:32 md: unbind<sde1>
22:04:32 md: export_rdev(sde1)
22:04:32 md: unbind<sdh1>
22:04:32 md: export_rdev(sdh1)
22:04:32 md: unbind<sdg1>
22:04:32 md: export_rdev(sdg1)
22:04:32 md: unbind<sdd1>
22:04:32 md: export_rdev(sdd1)
22:04:32 mdadm[18096]: segfault at 118 ip 0806a7b9 sp bffb8160 error 4 in mdadm[8048000+2a000]

/etc/init.d/mdadm-raid start

22:04:37 md: md0 stopped.
22:04:38 md: bind<sdd1>
22:04:38 md: bind<sdg1>
22:04:38 md: bind<sdi1>
22:04:38 md: bind<sde1>
22:04:38 md: bind<sdb1>
22:04:38 md: kicking non-fresh sdi1 from array!
22:04:38 md: unbind<sdi1>
22:04:38 md: export_rdev(sdi1)
22:04:38 raid5: device sdb1 operational as raid disk 0
22:04:38 raid5: device sde1 operational as raid disk 4
22:04:38 raid5: device sdg1 operational as raid disk 2
22:04:38 raid5: device sdd1 operational as raid disk 1
22:04:38 raid5: allocated 5255kB for md0
22:04:38 raid5: raid level 5 set md0 active with 4 out of 5 devices, algorithm 2
22:04:38 RAID5 conf printout:
22:04:38  --- rd:5 wd:4
22:04:38  disk 0, o:1, dev:sdb1
22:04:38  disk 1, o:1, dev:sdd1
22:04:38  disk 2, o:1, dev:sdg1
22:04:38  disk 4, o:1, dev:sde1
22:04:38 md0: bitmap initialized from disk: read 1/1 pages, set 1 bits
22:04:38 created bitmap (8 pages) for device md0
22:04:38 md0: detected capacity change from 0 to 2000420077568
22:04:38  md0: unknown partition table

mdadm /dev/md0 -a /dev/sdi1

22:05:21 md: bind<sdi1>
22:05:21 RAID5 conf printout:
22:05:21  --- rd:5 wd:4
22:05:21  disk 0, o:1, dev:sdb1
22:05:21  disk 1, o:1, dev:sdd1
22:05:21  disk 2, o:1, dev:sdg1
22:05:21  disk 3, o:1, dev:sdi1
22:05:21  disk 4, o:1, dev:sde1
22:05:21 md: recovery of RAID array md0
22:05:21 md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
22:05:21 md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
22:05:21 md: using 128k window, over a total of 488383808 blocks.

This is probably where I tried to add sdi2 to md1 without any luck.

22:05:54 md: export_rdev(sdi2)
22:05:55 md: export_rdev(sdi2)
