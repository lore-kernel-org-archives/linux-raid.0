From: Jim Schatzman <james.schatzman@futurelabusa.com>
Subject: Re: RAID1 with MBR and GPT fails to auto-assemble during boot
  - repost
Date: Thu, 22 Sep 2011 15:55:30 -0600
Message-ID: <20110922215540.C2949581F83@mail.futurelabusa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Does anyone have any idea how to fix this problem?  Again, I have a system with a RAID1 with two partitions - one on an MBR disk and one on a GPT disk.  Since my original posting, I moved the root partition to a separate MBR disk. No problems booting up. However, once booted, the RAID1 array is always missing the GPT disk.  I can well believe that I am doing something stupid, but I can't figure it out.

Thanks!

Jim

After booting:

/proc/mdstat:
----------------------------------
md1 : active raid1 sda1[0]
      9767424 blocks [2/1] [U_]
      
unused devices: <none>
-----------------------------------

/etc/mdadm.conf
----------------------------------
ARRAY /dev/md1 UUID=21b91d6f:e97bf1e3:ef6fdcec:d6c4a58e
-----------------------------------

madm -E:
------------------------------------
/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 21b91d6f:e97bf1e3:ef6fdcec:d6c4a58e
  Creation Time : Sat Oct 31 14:27:53 2009
     Raid Level : raid1
  Used Dev Size : 9767424 (9.31 GiB 10.00 GB)
     Array Size : 9767424 (9.31 GiB 10.00 GB)
   Raid Devices : 2
  Total Devices : 1
Preferred Minor : 1

    Update Time : Thu Sep 22 13:25:36 2011
          State : clean
 Active Devices : 1
Working Devices : 1
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 14926034 - correct
         Events : 0.9648


      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       0        0        1      faulty removed


/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 21b91d6f:e97bf1e3:ef6fdcec:d6c4a58e
  Creation Time : Sat Oct 31 14:27:53 2009
     Raid Level : raid1
  Used Dev Size : 9767424 (9.31 GiB 10.00 GB)
     Array Size : 9767424 (9.31 GiB 10.00 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Mon Sep 19 23:30:00 2011
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 148edee6 - correct
         Events : 0.6224


      Number   Major   Minor   RaidDevice State
this     1       8       33        1      active sync   /dev/sdc1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       33        1      active sync   /dev/sdc1
------------------------------------------------

It says "faulty", but there are no disk errors in the system log or dmesg. Also, I get the following result:


mdadm /dev/md1 --add /dev/sdc1
mdadm: re-added /dev/sdc1

md1 : active raid1 sdc1[2] sda1[0]
      9767424 blocks [2/1] [U_]
      [==>..................]  recovery = 11.9% (1167296/9767424) finish=1.5min speed=89792K/sec


The problem started occuring when I replaced drive sdc with a 3 TB drive with GPT partitioning. 

On the other problem, multiple RAID5 arrays using partitions on the same GPT drive have no difficulty. It is only the RAID1 array that has problem.

Dmesg does show an unexpected segfault. Is this occurring in md?   I find a couple of references to the same error by googling, but no explanation.  Thanks!



[    5.772168] raid6: int32x1    150 MB/s
[    5.840217] raid6: int32x2    232 MB/s
[    5.908165] raid6: int32x4    274 MB/s
[    5.976091] raid6: int32x8    302 MB/s
[    6.044124] raid6: mmxx1      360 MB/s
[    6.112020] raid6: mmxx2      715 MB/s
[    6.180175] raid6: sse1x1     312 MB/s
[    6.248068] raid6: sse1x2     555 MB/s
[    6.316039] raid6: sse2x1     620 MB/s
[    6.384005] raid6: sse2x2    1107 MB/s
[    6.384013] raid6: using algorithm sse2x2 (1107 MB/s)
[    6.384019] md: raid6 personality registered for level 6
[    6.384024] md: raid5 personality registered for level 5
[    6.384029] md: raid4 personality registered for level 4
[    6.389661] md: raid10 personality registered for level 10
[    6.395697] md: raid1 personality registered for level 1
[    6.446815] device-mapper: uevent: version 1.0.3
[    6.447282] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    6.862038] md: Autodetecting RAID arrays.
[    6.872198] md: Scanned 1 and added 1 devices.
[    6.872206] md: autorun ...
[    6.872212] md: considering sda1 ...
[    6.872228] md:  adding sda1 ...
[    6.872238] md: created md1
[    6.872243] md: bind<sda1>
[    6.872283] md: running: <sda1>
[    6.873023] raid1: raid set md1 active with 1 out of 2 mirrors
[    6.873247] md: ... autorun DONE.
[    6.873786] md: Autodetecting RAID arrays.
[    6.873793] md: Scanned 0 and added 0 devices.
[    6.873798] md: autorun ...
[    6.873801] md: ... autorun DONE.
[    6.874249] md: Autodetecting RAID arrays.
[    6.874256] md: Scanned 0 and added 0 devices.
[    6.874260] md: autorun ...
[    6.874264] md: ... autorun DONE.
[    6.874707] md: Autodetecting RAID arrays.
[    6.874713] md: Scanned 0 and added 0 devices.
[    6.874718] md: autorun ...
[    6.874722] md: ... autorun DONE.
[    6.875159] md: Autodetecting RAID arrays.
[    6.875166] md: Scanned 0 and added 0 devices.
[    6.875170] md: autorun ...
[    6.875174] md: ... autorun DONE.
[    6.975916]  md1: unknown partition table
[    7.778841] kjournald starting.  Commit interval 5 seconds
[    7.778855] EXT3-fs: mounted filesystem with ordered data mode.
[    8.837706] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    8.872148] ACPI: Power Button (FF) [PWRF]
[    8.872431] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
[    8.904136] ACPI: Power Button (CM) [PWRB]
[    9.134076] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    9.134117] r8169 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    9.134153] r8169 0000:01:00.0: setting latency timer to 64
[    9.134560]   alloc irq_desc for 26 on cpu 0 node 0
[    9.134572]   alloc kstat_irqs on cpu 0 node 0
[    9.134597] r8169 0000:01:00.0: irq 26 for MSI/MSI-X
[    9.134916] eth0: RTL8168c/8111c at 0xf8446000, 00:24:21:31:cb:7f, XID 3c4000c0 IRQ 26
[    9.137744] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    9.137780] r8169 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    9.137812] r8169 0000:02:00.0: setting latency timer to 64
[    9.137923]   alloc irq_desc for 27 on cpu 0 node 0
[    9.137934]   alloc kstat_irqs on cpu 0 node 0
[    9.137954] r8169 0000:02:00.0: irq 27 for MSI/MSI-X
[    9.138258] eth1: RTL8168c/8111c at 0xf803e000, 00:24:21:31:cb:80, XID 3c4000c0 IRQ 27
[    9.346760] intel_rng: FWH not detected
[    9.418997] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    9.419109] sd 0:0:1:0: Attached scsi generic sg1 type 0
[    9.419212] sd 1:0:0:0: Attached scsi generic sg2 type 0
[    9.419327] sd 1:0:1:0: Attached scsi generic sg3 type 0
[    9.439818] iTCO_vendor_support: vendor-support=0
[    9.446808] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[    9.448154] iTCO_wdt: Found a ICH7 or ICH7R TCO device (Version=2, TCOBASE=0x0860)
[    9.448332] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    9.819069] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   13.709963] warning: process `kmodule' used the deprecated sysctl system call with 1.23.
[   13.710236] kmodule[2741]: segfault at ffff9410 ip 08061417 sp bfc12690 error 4 in kmodule[8048000+1f000]
[   16.804037] floppy0: no floppy controllers found
[   18.063438] md: Autodetecting RAID arrays.
[   18.063446] md: Scanned 0 and added 0 devices.
[   18.063451] md: autorun ...
[   18.063454] md: ... autorun DONE.
[   18.085090] md: md8 stopped.
[   19.233872] md: bind<sdc5>
[   19.234093] md: bind<sdb5>
[   19.234294] md: bind<sdd8>
[   19.234510] md: bind<sda8>
[   19.269020] raid5: device sda8 operational as raid disk 0
[   19.269031] raid5: device sdd8 operational as raid disk 3
[   19.269039] raid5: device sdb5 operational as raid disk 2
[   19.269046] raid5: device sdc5 operational as raid disk 1
[   19.274079] raid5: allocated 4219kB for md8
[   19.274088] raid5: raid level 5 set md8 active with 4 out of 4 devices, algorithm 2
[   19.274094] RAID5 conf printout:
[   19.274098]  --- rd:4 wd:4
[   19.274104]  disk 0, o:1, dev:sda8
[   19.274109]  disk 1, o:1, dev:sdc5
[   19.274115]  disk 2, o:1, dev:sdb5
[   19.274120]  disk 3, o:1, dev:sdd8
[   19.278213] md: md7 stopped.
[   19.280491]  md8: unknown partition table
[   19.773986] md: bind<sdc4>
[   19.774209] md: bind<sdb4>
[   19.774411] md: bind<sdd7>
[   19.774616] md: bind<sda7>
[   19.807296] raid5: device sda7 operational as raid disk 0
[   19.807304] raid5: device sdd7 operational as raid disk 3
[   19.807311] raid5: device sdb4 operational as raid disk 2
[   19.807317] raid5: device sdc4 operational as raid disk 1
[   19.808319] raid5: allocated 4219kB for md7
[   19.808326] raid5: raid level 5 set md7 active with 4 out of 4 devices, algorithm 2
[   19.808332] RAID5 conf printout:
[   19.808336]  --- rd:4 wd:4
[   19.808342]  disk 0, o:1, dev:sda7
[   19.808347]  disk 1, o:1, dev:sdc4
[   19.808352]  disk 2, o:1, dev:sdb4
[   19.808357]  disk 3, o:1, dev:sdd7
[   19.808906] md: md6 stopped.
[   19.811985]  md7: unknown partition table
[   19.882641] md: bind<sdc3>
[   19.882874] md: bind<sdb3>
[   19.883080] md: bind<sdd6>
[   19.883302] md: bind<sda6>
[   19.916494] raid5: device sda6 operational as raid disk 0
[   19.916502] raid5: device sdd6 operational as raid disk 3
[   19.916510] raid5: device sdb3 operational as raid disk 2
[   19.916516] raid5: device sdc3 operational as raid disk 1
[   19.917493] raid5: allocated 4219kB for md6
[   19.917499] raid5: raid level 5 set md6 active with 4 out of 4 devices, algorithm 2
[   19.917507] RAID5 conf printout:
[   19.917511]  --- rd:4 wd:4
[   19.917516]  disk 0, o:1, dev:sda6
[   19.917521]  disk 1, o:1, dev:sdc3
[   19.917527]  disk 2, o:1, dev:sdb3
[   19.917532]  disk 3, o:1, dev:sdd6
[   19.918078] md: md5 stopped.
[   19.922394]  md6: unknown partition table
[   19.973799] md: bind<sdc2>
[   19.974029] md: bind<sdb2>
[   19.974239] md: bind<sdd5>
[   19.974571] md: bind<sda5>
[   20.007818] raid5: device sda5 operational as raid disk 0
[   20.007827] raid5: device sdd5 operational as raid disk 3
[   20.007833] raid5: device sdb2 operational as raid disk 2
[   20.007839] raid5: device sdc2 operational as raid disk 1
[   20.008827] raid5: allocated 4219kB for md5
[   20.008834] raid5: raid level 5 set md5 active with 4 out of 4 devices, algorithm 2
[   20.008840] RAID5 conf printout:
[   20.008843]  --- rd:4 wd:4
[   20.008848]  disk 0, o:1, dev:sda5
[   20.008854]  disk 1, o:1, dev:sdc2
[   20.008859]  disk 2, o:1, dev:sdb2
[   20.008864]  disk 3, o:1, dev:sdd5
[   20.015116]  md5: unknown partition table
[   20.068163] device-mapper: multipath: version 1.0.5 loaded
[   20.574136] EXT3 FS on hda2, internal journal
[   20.924664] kjournald starting.  Commit interval 5 seconds
[   20.924839] EXT3 FS on hda1, internal journal
[   20.924851] EXT3-fs: mounted filesystem with ordered data mode.
[   20.941929] kjournald starting.  Commit interval 5 seconds
[   20.941940] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[   20.942134] EXT3 FS on sdd1, internal journal
[   20.942145] EXT3-fs: mounted filesystem with ordered data mode.
[   20.994924] kjournald starting.  Commit interval 5 seconds
[   21.116510] EXT3 FS on dm-4, internal journal
[   21.116526] EXT3-fs: mounted filesystem with ordered data mode.
[   21.182060] kjournald starting.  Commit interval 5 seconds
[   21.245889] EXT3 FS on dm-3, internal journal
[   21.245904] EXT3-fs: mounted filesystem with ordered data mode.
[   21.327708] kjournald starting.  Commit interval 5 seconds
[   21.442270] EXT3 FS on dm-2, internal journal
[   21.442286] EXT3-fs: mounted filesystem with ordered data mode.
[   21.526178] kjournald starting.  Commit interval 5 seconds
[   21.592515] EXT3 FS on dm-1, internal journal
[   21.592531] EXT3-fs: mounted filesystem with ordered data mode.







----------------------------------------------------------------------------------------------------------------------------------------------------------------
Previous post:

I have a RAID1 array with 2 partitions. One partition is on an MBR drive and one is on a GPT drive.

When I reboot, only the MBR drive has been assembled.

Using

mdadm /dev/md1 --add /dev/sdc1

mdadm reports that the drive is "readded" and syncing proceeds without difficulty. Reboot, and the array again
shows up with only one drive.

This array contains an LVM containing the system partition.  mdadm.conf contains
--------------------------------------------------------
#
# PLEASE DO NOT MODIFY THIS CONFIGURATION FILE!
#   This configuration file was auto-generated
#   by Openfiler. Please do not modify it.
#
# Generated at: Sun Nov 1 19:28:17 MST 2009
#

DEVICE partitions
ARRAY /dev/md8 UUID=066bd3ee:b35a0f59:d111a4d2:91b551e6
ARRAY /dev/md7 UUID=8245e0c8:aeb40213:7d63f449:7e79d5c0
ARRAY /dev/md6 UUID=78d87cc4:4e8dfa53:6da2eef9:a1dfa4c3
ARRAY /dev/md5 UUID=b282fd35:d6ce1cb8:9747d521:9d1e8e97
ARRAY /dev/md1 UUID=21b91d6f:e97bf1e3:ef6fdcec:d6c4a58e
PROGRAM /opt/openfiler/bin/mdalert 
--------------------------------------------------------------

dmesg shows

[    5.415275] md: Autodetecting RAID arrays.
[    5.415509] md: Scanned 1 and added 1 devices.
[    5.415514] md: autorun ...
[    5.415519] md: considering sda1 ...
[    5.415535] md:  adding sda1 ...
[    5.415541] md: created md1
[    5.415546] md: bind<sda1>
[    5.415572] md: running: <sda1>
[    5.416220] raid1: raid set md1 active with 1 out of 2 mirrors
[    5.416395] md: ... autorun DONE.
[    5.416861] md: Autodetecting RAID arrays.
[    5.416867] md: Scanned 0 and added 0 devices.
[    5.416872] md: autorun ...
[    5.416876] md: ... autorun DONE.
[    5.417349] md: Autodetecting RAID arrays.
[    5.417357] md: Scanned 0 and added 0 devices.
[    5.417362] md: autorun ...
[    5.417365] md: ... autorun DONE.
[    5.417829] md: Autodetecting RAID arrays.
[    5.417836] md: Scanned 0 and added 0 devices.
[    5.417840] md: autorun ...
[    5.417844] md: ... autorun DONE.
[    5.418296] md: Autodetecting RAID arrays.
[    5.418303] md: Scanned 0 and added 0 devices.
[    5.418307] md: autorun ...
[    5.418311] md: ... autorun DONE.


Later on, it assembles /dev/md5 to /dev/md8 without difficulty, even though one of the disk partitions from each is on the GPT drive.

This is Openfiler with kernel 2.6.29.6 and mdadm version 2.6.4.

Previously, when /dev/sdc was partitioned MBR, there was no problem with assembling the RAID1 array.

Output of mdadm -E for /dev/sda1 and /dev/sdc1 is

/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 21b91d6f:e97bf1e3:ef6fdcec:d6c4a58e
  Creation Time : Sat Oct 31 14:27:53 2009
     Raid Level : raid1
  Used Dev Size : 9767424 (9.31 GiB 10.00 GB)
     Array Size : 9767424 (9.31 GiB 10.00 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Mon Sep 19 18:22:14 2011
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 148e96a2 - correct
         Events : 0.6224


      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       33        1      active sync   /dev/sdc1




/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.03
           UUID : 21b91d6f:e97bf1e3:ef6fdcec:d6c4a58e
  Creation Time : Sat Oct 31 14:27:53 2009
     Raid Level : raid1
  Used Dev Size : 9767424 (9.31 GiB 10.00 GB)
     Array Size : 9767424 (9.31 GiB 10.00 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 1

    Update Time : Mon Sep 19 18:24:14 2011
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 148e973c - correct
         Events : 0.6224


      Number   Major   Minor   RaidDevice State
this     1       8       33        1      active sync   /dev/sdc1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       33        1      active sync   /dev/sdc1


Why does Linux fail to auto-assemble /dev/md1 during boot and how do I fix the problem?


Thanks!

Jim


