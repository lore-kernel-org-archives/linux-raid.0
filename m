From: Daniel Frey <djqfrey@gmail.com>
Subject: mdadm forces resync every boot
Date: Fri, 05 Aug 2011 08:05:53 -0700
Message-ID: <4E3C06D1.6030301@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I've been fighting with my raid array (imsm - raid10) for several weeks
now. I've now replaced all four drives in my array as the constant
rebuilding caused a smart error to trip on the old drives; unfortunately
mdadm is still resyncing the array at every boot.

One thing I would like to clarify is does mdadm need to disassemble the
array before reboot. At this point, I can't tell if my system is
currently doing this. Googling around it seems some say that this step
is unnecessary.

I've managed to update initramfs to 3.2.1 and the local system to 3.2.1
but the problem still persists.

The last thing my system does is remount root ro, which it does
successfully. However, at the next start:

[   12.657829] md: md127 stopped.
[   12.660652] md: bind<sdc>
[   12.660939] md: bind<sdb>
[   12.661212] md: bind<sda>
[   12.661282] md: bind<sdd>
[   12.664972] md: md126 stopped.
[   12.665284] md: bind<sdd>
[   12.665383] md: bind<sdc>
[   12.665476] md: bind<sdb>
[   12.665568] md: bind<sda>
[   12.669218] md/raid10:md126: not clean -- starting background
reconstruction
[   12.669221] md/raid10:md126: active with 4 out of 4 devices
[   12.669241] md126: detected capacity change from 0 to 1000210432000
[   12.678356] md: md126 switched to read-write mode.
[   12.678390] md: resync of RAID array md126
[   12.678393] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[   12.678395] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for resync.
[   12.678399] md: using 128k window, over a total of 976768256 blocks.

and cat /proc/mdstat shows it resyncing:

# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10]
md126 : active raid10 sda[3] sdb[2] sdc[1] sdd[0]
      976768000 blocks super external:/md127/0 64K chunks 2 near-copies
[4/4] [UUUU]
      [==>..................]  resync = 12.2% (119256896/976768256)
finish=100.7min speed=141865K/sec

md127 : inactive sdd[3](S) sda[2](S) sdb[1](S) sdc[0](S)
      9028 blocks super external:imsm

unused devices: <none>

When it resyncs it is fine until the next power down.

Some other details:

# mdadm --detail-platform
       Platform : Intel(R) Matrix Storage Manager
        Version : 9.6.0.1014
    RAID Levels : raid0 raid1 raid10 raid5
    Chunk Sizes : 4k 8k 16k 32k 64k 128k
      Max Disks : 7
    Max Volumes : 2
 I/O Controller : /sys/devices/pci0000:00/0000:00:1f.2 (SATA)
          Port0 : /dev/sda (WD-WCAYUJ525606)
          Port1 : /dev/sdb (WD-WCAYUJ525636)
          Port2 : /dev/sdc (WD-WCAYUX093587)
          Port3 : /dev/sdd (WD-WCAYUX092774)
          Port4 : - non-disk device (TSSTcorp CDDVDW SH-S203B) -
          Port5 : - no device attached -

# mdadm --detail --scan
ARRAY /dev/md/imsm0 metadata=imsm UUID=ec239ccc:22b7330b:0c4808ff:82dd176b
ARRAY /dev/md/HDD_0 container=/dev/md/imsm0 member=0
UUID=f61f87fc:1e85f04b:59e873c5:0afdb987

# ls /dev/md
HDD_0  HDD_0p1  HDD_0p2  HDD_0p3  HDD_0p4  imsm0

Everything seems to be working. Also, I can't reproduce the results in
Windows Vista x64 (dual-boot.) When I go from linux -> Windows, Windows
detects the array as bad and reinitializes it as well, but if I reboot
into Windows the array survives without being marked bad.

Can anyone shed some light on this? I've been bashing my head on my desk
for too long and have run out of ideas.

Dan
