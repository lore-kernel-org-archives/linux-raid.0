From: "Neil Cavan" <neilcavan@gmail.com>
Subject: RAID5 Recovery
Date: Tue, 13 Nov 2007 20:05:55 -0500
Message-ID: <f0d815c0711131705s17f365b4kc122db98e8e27895@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have a 5-disk RAID5 array that has gone belly-up. It consists of 2x
2 disks on Promise PCI controllers, and one on the mobo controller.

This array has been running for a couple years, and every so often
(randomly, sometimes every couple weeks sometimes no problem for
months) it will drop a drive. It's not a drive failure per se, it's
something controller-related since the failures tend to happen in
pairs and SMART gives the drives a clean bill of health. If it's only
one drive, I can hot-add with no problem. If it's 2 drives my heart
leaps into my mouth but I reboot, only one of the drives comes up as
failed, and I can hot-add with no problem. The 2-drive case has
happened a dozen times and my array is never any worse for the wear.

This morning, I woke up to find the array had kicked two disks. This
time, though, /proc/mdstat showed one of the failed disks (U_U_U, one
of the "_"s) had been marked as a spare - weird, since there are no
spare drives in this array. I rebooted, and the array came back in the
same state: one failed, one spare. I hot-removed and hot-added the
spare drive, which put the array back to where I thought it should be
( still U_U_U, but with both "_"s marked as failed). Then I rebooted,
and the array began rebuilding on its own. Usually I have to hot-add
manually, so that struck me as a little odd, but I gave it no mind and
went to work. Without checking the contents of the filesystem. Which
turned out not to have been mounted on reboot. Because apparently
things went horribly wrong.

The rebuild process ran its course. I now have an array that mdadm
insists is peachy:
-------------------------------------------------------------------------------------------------------
md0 : active raid5 hda1[0] hdc1[1] hdi1[4] hdg1[3] hde1[2]
      468872704 blocks level 5, 64k chunk, algorithm 2 [5/5] [UUUUU]

unused devices: <none>
-------------------------------------------------------------------------------------------------------

But there is no filesystem on /dev/md0:

-------------------------------------------------------------------------------------------------------
sudo mount -t reiserfs /dev/md0 /storage/
mount: wrong fs type, bad option, bad superblock on /dev/md0,
       missing codepage or other error
-------------------------------------------------------------------------------------------------------

Do I have any hope of recovering this data? Could rebuilding the
reiserfs superblock help if the rebuild managed to corrupt the
superblock but not the data?

Any help is appreciated, below is the failure event in
/var/log/messages, followed by the output of cat /var/log/messages |
grep md.

Thanks,
Neil Cavan

Nov 13 02:01:03 localhost kernel: [17805772.424000] hdc: dma_intr:
status=0x51 { DriveReady SeekComplete Error }
Nov 13 02:01:03 localhost kernel: [17805772.424000] hdc: dma_intr:
error=0x40 { UncorrectableError }, LBAsect=11736, sector=1
1719
Nov 13 02:01:03 localhost kernel: [17805772.424000] ide: failed opcode
was: unknown
Nov 13 02:01:03 localhost kernel: [17805772.424000] end_request: I/O
error, dev hdc, sector 11719
Nov 13 02:01:03 localhost kernel: [17805772.424000] R5: read error not
correctable.
Nov 13 02:01:03 localhost kernel: [17805772.464000] lost page write
due to I/O error on md0
Nov 13 02:01:05 localhost kernel: [17805773.776000] hdc: dma_intr:
status=0x51 { DriveReady SeekComplete Error }
Nov 13 02:01:05 localhost kernel: [17805773.776000] hdc: dma_intr:
error=0x40 { UncorrectableError }, LBAsect=11736, sector=1
1727
Nov 13 02:01:05 localhost kernel: [17805773.776000] ide: failed opcode
was: unknown
Nov 13 02:01:05 localhost kernel: [17805773.776000] end_request: I/O
error, dev hdc, sector 11727
Nov 13 02:01:05 localhost kernel: [17805773.776000] R5: read error not
correctable.
Nov 13 02:01:05 localhost kernel: [17805773.776000] lost page write
due to I/O error on md0
Nov 13 02:01:06 localhost kernel: [17805775.156000] hdc: dma_intr:
status=0x51 { DriveReady SeekComplete Error }
Nov 13 02:01:06 localhost kernel: [17805775.156000] hdc: dma_intr:
error=0x40 { UncorrectableError }, LBAsect=11736, sector=1
1735
Nov 13 02:01:06 localhost kernel: [17805775.156000] ide: failed opcode
was: unknown
Nov 13 02:01:06 localhost kernel: [17805775.156000] end_request: I/O
error, dev hdc, sector 11735
Nov 13 02:01:06 localhost kernel: [17805775.156000] R5: read error not
correctable.
Nov 13 02:01:06 localhost kernel: [17805775.156000] lost page write
due to I/O error on md0
Nov 13 02:01:06 localhost kernel: [17805775.196000] RAID5 conf printout:
Nov 13 02:01:06 localhost kernel: [17805775.196000]  --- rd:5 wd:3 fd:2
Nov 13 02:01:06 localhost kernel: [17805775.196000]  disk 0, o:1, dev:hda1
Nov 13 02:01:06 localhost kernel: [17805775.196000]  disk 1, o:0, dev:hdc1
Nov 13 02:01:06 localhost kernel: [17805775.196000]  disk 2, o:1, dev:hde1
Nov 13 02:01:06 localhost kernel: [17805775.196000]  disk 4, o:1, dev:hdi1
Nov 13 02:01:06 localhost kernel: [17805775.212000] RAID5 conf printout:
Nov 13 02:01:06 localhost kernel: [17805775.212000]  --- rd:5 wd:3 fd:2
Nov 13 02:01:06 localhost kernel: [17805775.212000]  disk 0, o:1, dev:hda1
Nov 13 02:01:06 localhost kernel: [17805775.212000]  disk 2, o:1, dev:hde1
Nov 13 02:01:06 localhost kernel: [17805775.212000]  disk 4, o:1, dev:hdi1
Nov 13 02:01:06 localhost kernel: [17805775.212000] lost page write
due to I/O error on md0
Nov 13 02:01:06 localhost last message repeated 4 times

at /var/log/messages | grep md:
-------------------------------------------------------------------------------------------------------
Nov 13 02:01:03 localhost kernel: [17805772.464000] lost page write
due to I/O error on md0
Nov 13 02:01:05 localhost kernel: [17805773.776000] lost page write
due to I/O error on md0
Nov 13 02:01:06 localhost kernel: [17805775.156000] lost page write
due to I/O error on md0
Nov 13 02:01:06 localhost kernel: [17805775.212000] lost page write
due to I/O error on md0
Nov 13 07:21:07 localhost kernel: [17179583.968000] md: md driver
0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
Nov 13 07:21:07 localhost kernel: [17179583.968000] md: bitmap version 4.39
Nov 13 07:21:07 localhost kernel: [17179583.972000] md: raid5
personality registered as nr 4
Nov 13 07:21:07 localhost kernel: [17179584.712000] md: md0 stopped.
Nov 13 07:21:07 localhost kernel: [17179584.876000] md: bind<hdc1>
Nov 13 07:21:07 localhost kernel: [17179584.884000] md: bind<hde1>
Nov 13 07:21:07 localhost kernel: [17179584.884000] md: bind<hdg1>
Nov 13 07:21:07 localhost kernel: [17179584.884000] md: bind<hdi1>
Nov 13 07:21:07 localhost kernel: [17179584.892000] md: bind<hda1>
Nov 13 07:21:07 localhost kernel: [17179584.892000] md: kicking
non-fresh hdg1 from array!
Nov 13 07:21:07 localhost kernel: [17179584.892000] md: unbind<hdg1>
Nov 13 07:21:07 localhost kernel: [17179584.892000] md: export_rdev(hdg1)
Nov 13 07:21:07 localhost kernel: [17179584.896000] raid5: allocated
5245kB for md0
Nov 13 07:21:07 localhost kernel: [17179665.524000] ReiserFS: md0:
found reiserfs format "3.6" with standard journal
Nov 13 07:21:07 localhost kernel: [17179676.136000] ReiserFS: md0:
using ordered data mode
Nov 13 07:21:07 localhost kernel: [17179676.164000] ReiserFS: md0:
journal params: device md0, size 8192, journal first block 18, max
trans len 1024, max batch 900, max commit age 30, max trans age 30
Nov 13 07:21:07 localhost kernel: [17179676.164000] ReiserFS: md0:
checking transaction log (md0)
Nov 13 07:21:07 localhost kernel: [17179676.828000] ReiserFS: md0:
replayed 7 transactions in 1 seconds
Nov 13 07:21:07 localhost kernel: [17179677.012000] ReiserFS: md0:
Using r5 hash to sort names
Nov 13 07:21:09 localhost kernel: [17179682.064000] lost page write
due to I/O error on md0
Nov 13 07:25:39 localhost kernel: [17179584.824000] md: md driver
0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
Nov 13 07:25:39 localhost kernel: [17179584.824000] md: bitmap version 4.39
Nov 13 07:25:39 localhost kernel: [17179584.828000] md: raid5
personality registered as nr 4
Nov 13 07:25:39 localhost kernel: [17179585.532000] md: md0 stopped.
Nov 13 07:25:39 localhost kernel: [17179585.696000] md: bind<hdc1>
Nov 13 07:25:39 localhost kernel: [17179585.696000] md: bind<hde1>
Nov 13 07:25:39 localhost kernel: [17179585.700000] md: bind<hdg1>
Nov 13 07:25:39 localhost kernel: [17179585.700000] md: bind<hdi1>
Nov 13 07:25:39 localhost kernel: [17179585.708000] md: bind<hda1>
Nov 13 07:25:39 localhost kernel: [17179585.708000] md: kicking
non-fresh hdg1 from array!
Nov 13 07:25:39 localhost kernel: [17179585.708000] md: unbind<hdg1>
Nov 13 07:25:39 localhost kernel: [17179585.708000] md: export_rdev(hdg1)
Nov 13 07:25:39 localhost kernel: [17179585.712000] raid5: allocated
5245kB for md0
Nov 13 07:25:40 localhost kernel: [17179666.064000] ReiserFS: md0:
found reiserfs format "3.6" with standard journal
Nov 13 07:25:40 localhost kernel: [17179676.904000] ReiserFS: md0:
using ordered data mode
Nov 13 07:25:40 localhost kernel: [17179676.928000] ReiserFS: md0:
journal params: device md0, size 8192, journal first block 18, max
trans len 1024, max batch 900, max commit age 30, max trans age 30
Nov 13 07:25:40 localhost kernel: [17179676.932000] ReiserFS: md0:
checking transaction log (md0)
Nov 13 07:25:40 localhost kernel: [17179677.080000] ReiserFS: md0:
Using r5 hash to sort names
Nov 13 07:25:42 localhost kernel: [17179683.128000] lost page write
due to I/O error on md0
Nov 13 07:26:57 localhost kernel: [17179757.524000] md: unbind<hdc1>
Nov 13 07:26:57 localhost kernel: [17179757.524000] md: export_rdev(hdc1)
Nov 13 07:27:03 localhost kernel: [17179763.700000] md: bind<hdc1>
Nov 13 07:30:24 localhost kernel: [17179584.180000] md: md driver
0.90.3 MAX_MD_DEVS=256, MD_SB_DISKS=27
Nov 13 07:30:24 localhost kernel: [17179584.180000] md: bitmap version 4.39
Nov 13 07:30:24 localhost kernel: [17179584.184000] md: raid5
personality registered as nr 4
Nov 13 07:30:24 localhost kernel: [17179584.912000] md: md0 stopped.
Nov 13 07:30:24 localhost kernel: [17179585.060000] md: bind<hde1>
Nov 13 07:30:24 localhost kernel: [17179585.064000] md: bind<hdg1>
Nov 13 07:30:24 localhost kernel: [17179585.064000] md: bind<hdi1>
Nov 13 07:30:24 localhost kernel: [17179585.064000] md: bind<hdc1>
Nov 13 07:30:24 localhost kernel: [17179585.068000] md: bind<hda1>
Nov 13 07:30:24 localhost kernel: [17179585.068000] raid5: allocated
5245kB for md0
Nov 13 07:30:24 localhost kernel: [17179585.068000] md: syncing RAID array md0
Nov 13 07:30:24 localhost kernel: [17179585.068000] md: minimum
_guaranteed_ reconstruction speed: 1000 KB/sec/disc.
Nov 13 07:30:24 localhost kernel: [17179585.068000] md: using maximum
available idle IO bandwidth (but not more than 200000 KB/sec) for
reconstruction.
Nov 13 07:30:24 localhost kernel: [17179585.068000] md: using 128k
window, over a total of 117218176 blocks.
Nov 13 07:30:24 localhost kernel: [17179684.160000] ReiserFS: md0:
warning: sh-2021: reiserfs_fill_super: can not find reiserfs on md0
Nov 13 08:57:11 localhost kernel: [17184895.816000] md: md0: sync done.
Nov 13 18:17:10 localhost kernel: [17218493.012000] ReiserFS: md0:
warning: sh-2021: reiserfs_fill_super: can not find reiserfs on md0
Nov 13 18:36:03 localhost kernel: [17219625.456000] ReiserFS: md0:
warning: sh-2021: reiserfs_fill_super: can not find reiserfs on md0
