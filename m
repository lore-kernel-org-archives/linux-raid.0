From: Jim Klimov <klimov@2ka.mipt.ru>
Subject: Problem with large devices >2TB
Date: Wed, 10 May 2006 15:04:40 +0400
Message-ID: <0376848.20060510150440@2ka.mipt.ru>
Reply-To: Jim Klimov <klimov@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello linux-raid,

  We have a problem with large devices (over 2TB).

  While this is not exactly a software RAID issue, I saw quite a few
  references to hardware RAID in this list and hope that my question
  isn't an extreme offtopic. 

  I have seen this sort of problem in numerous mailing lists, and now
  during an upgrade I encountered it myself. And I have not yet found
  any well-working solutions, only hanging questions...

  The server I maintain now has 2 3Ware 9550SX-12 cards with 10*320
  and 9*400gb RAID5 arrays (addressable space is thus sized 2880gb
  and 3200gb). These arrays are partitioned in 9*320gb and 8*400gb
  parts (so we can defragment via a hotspare drive sometimes).

  The Linux kernel is 2.6.16.12 with CONFIG_LBD=y.

  The only tool that agreed to partition these arrays is a recent
  GNU parted (1.7.0rc5), both fdisk and cfdisk failed to see it.
  Fdisk from util-linux-2.12r suggested:

[root@storage bofh]# fdisk /dev/sdb
You must set cylinders.
You can do this from the extra functions menu.

Command (m for help): p

Disk /dev/sdb: 0 MB, 0 bytes
255 heads, 63 sectors/track, 0 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

  Blockdev also can not address the device:
  
[root@storage bofh]# blockdev --getsize /dev/sdc
BLKGETSIZE: File too large
[root@storage bofh]# blockdev -V
blockdev from util-linux-2.12r

  Since the new parted worked ok (older one didn't), we were happy
  until we tried a reboot. During the device initialization and after
  it the system only recognises the 6 or 7 partitions which start
  before the 2000Gb limit:

[    5.168239] 3ware Storage Controller device driver for Linux v1.26.02.001.
[    5.175294] 3ware 9000 Storage Controller device driver for Linux v2.26.02.007.
[    5.438278] 3w-9xxx: scsi0: AEN: WARNING (0x04:0x0008): Unclean shutdown detected:unit=0.
[    5.548104] 3w-9xxx: scsi0: AEN: WARNING (0x04:0x0008): Unclean shutdown detected:unit=1.
[    5.657930] scsi0 : 3ware 9000 Storage Controller
[    5.662833] 3w-9xxx: scsi0: Found a 3ware 9000 Storage Controller at 0xf6200000, IRQ: 201.
[    5.976432] 3w-9xxx: scsi0: Firmware FE9X 3.02.00.004, BIOS BE9X 3.01.00.024, Ports: 12.
[    5.985100]   Vendor: AMCC      Model: 9550SX-12  DISK   Rev: 3.02
[    5.993543]   Type:   Direct-Access                      ANSI SCSI revision: 03
[    6.002020]   Vendor: AMCC      Model: 9550SX-12  DISK   Rev: 3.02
[    6.010487]   Type:   Direct-Access                      ANSI SCSI revision: 03
[    6.278964] 3w-9xxx: scsi1: AEN: WARNING (0x04:0x0008): Unclean shutdown detected:unit=1.
[    6.388788] scsi1 : 3ware 9000 Storage Controller
[    6.393684] 3w-9xxx: scsi1: Found a 3ware 9000 Storage Controller at 0xf6340000, IRQ: 177.
[    6.707289] 3w-9xxx: scsi1: Firmware FE9X 3.02.00.004, BIOS BE9X 3.01.00.024, Ports: 12.
[    6.715910]   Vendor: AMCC      Model: 9550SX-12  DISK   Rev: 3.02
[    6.724362]   Type:   Direct-Access                      ANSI SCSI revision: 03
[    6.732850]   Vendor: AMCC      Model: 9550SX-12  DISK   Rev: 3.02
[    6.741298]   Type:   Direct-Access                      ANSI SCSI revision: 03
[    6.755016] SCSI device sda: 273395712 512-byte hdwr sectors (139979 MB)
[    6.761971] sda: Write Protect is off
[    6.765712] sda: Mode Sense: 23 00 00 00
[    6.766029] SCSI device sda: drive cache: none
[    6.770834] SCSI device sda: 273395712 512-byte hdwr sectors (139979 MB)
[    6.777764] sda: Write Protect is off
[    6.781507] sda: Mode Sense: 23 00 00 00
[    6.781824] SCSI device sda: drive cache: none
[    6.786343]  sda: sda1
[    6.789283] sd 0:0:0:0: Attached scsi disk sda
[    6.793993] sdb : very big device. try to use READ CAPACITY(16).
[    6.800164] SCSI device sdb: 5624801280 512-byte hdwr sectors (2879898 MB)
[    6.807363] sdb: Write Protect is off
[    6.811098] sdb: Mode Sense: 23 00 00 00
[    6.811589] SCSI device sdb: drive cache: write back, no read (daft)
[    6.818288] sdb : very big device. try to use READ CAPACITY(16).
[    6.824454] SCSI device sdb: 5624801280 512-byte hdwr sectors (2879898 MB)
[    6.831640] sdb: Write Protect is off
[    6.835397] sdb: Mode Sense: 23 00 00 00
[    6.835903] SCSI device sdb: drive cache: write back, no read (daft)
[    6.842334]  sdb: sdb1 sdb2 sdb3 sdb4 < sdb5 sdb6 sdb7 sdb8 >
    << here we lost sdb9 and sdb10
[    6.936783] sd 0:0:1:0: Attached scsi disk sdb
[    6.941515] sdc : very big device. try to use READ CAPACITY(16).
[    6.947680] SCSI device sdc: 6249824256 512-byte hdwr sectors (3199910 MB)
[    6.954870] sdc: Write Protect is off
[    6.958611] sdc: Mode Sense: 23 00 00 00
[    6.959085] SCSI device sdc: drive cache: write back, no read (daft)
[    6.965784] sdc : very big device. try to use READ CAPACITY(16).
[    6.947680] SCSI device sdc: 6249824256 512-byte hdwr sectors (3199910 MB)
[    6.954870] sdc: Write Protect is off
[    6.958611] sdc: Mode Sense: 23 00 00 00
[    6.959085] SCSI device sdc: drive cache: write back, no read (daft)
[    6.965784] sdc : very big device. try to use READ CAPACITY(16).
[    6.971953] SCSI device sdc: 6249824256 512-byte hdwr sectors (3199910 MB)
[    6.979131] sdc: Write Protect is off
[    6.982869] sdc: Mode Sense: 23 00 00 00
[    6.983341] SCSI device sdc: drive cache: write back, no read (daft)
[    6.989769]  sdc: sdc1 sdc2 sdc3 sdc4 < sdc5 sdc6 sdc7 >
    << here we lost sdc8 and sdc9
[    7.078365] sd 1:0:0:0: Attached scsi disk sdc
[    7.083087] SCSI device sdd: 144486400 512-byte hdwr sectors (73977 MB)
[    7.089944] sdd: Write Protect is off
[    7.093693] sdd: Mode Sense: 23 00 00 00
[    7.094008] SCSI device sdd: drive cache: write back, no read (daft)
[    7.100701] SCSI device sdd: 144486400 512-byte hdwr sectors (73977 MB)
[    7.107546] sdd: Write Protect is off
[    7.111292] sdd: Mode Sense: 23 00 00 00
[    7.111608] SCSI device sdd: drive cache: write back, no read (daft)
[    7.118032]  sdd: sdd1
[    7.120944] sd 1:0:1:0: Attached scsi disk sdd
  
  The "last" few partitions are invisible to mount, mkfs, fsck and
  other tools until a trick is done: we run parted, remove a partition
  and remake it again with same start-end parameters. This probably
  causes some re-read of the partition table and our data is
  accessible again (until a reboot). Nothing appears in dmesg, though.

  While this workaround works, it is unpleasant enough to put it in
  some startup scripts and forget about it in a few years :)

  Other workarounds seem to include remaking the arrays (so they are
  under 2Tb in size) or remaking the last partition so it's larger and
  starts before the 2Tb limit. So far we don't want to resort to these
  solutions and are willing to experiment with whatever ideas or
  patches the List People can suggest :)

  While googling around I saw references that standard SCSI devices
  can't address over 2Tb due to a 32-bit protocol, and several
  proposed extensions are not standardized and buggy. Perhaps this
  problem starts in the sd SCSI layer driver?

  Can anybody on the list suggest where the problem can be rooted and
  perhaps forward me and my message to the more appropriate list?
  
-- 
Best regards,
 Jim Klimov                          mailto:klimov@2ka.mipt.ru

