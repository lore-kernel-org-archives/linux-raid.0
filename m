From: Philipp Frauenfelder <philipp.frauenfelder@gmail.com>
Subject: RAID5 recovery
Date: Wed, 05 Jun 2013 14:02:58 +0200
Message-ID: <51AF28F2.3010701@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050600090704060207090902"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------050600090704060207090902
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi

I am new to this list and RAID problems (but not to Linux).

My RAIDs run well but one of my colleague in a Synology has failed. It 
was a 4-disk RAID5 and the hot-spare disk and one of the used disks (the 
middle one) failed. Unfortunately, he returned the disks to the vendor 
the get new ones.

So, we ended up with 2 out of 4 disks and trying to get the data of the 
disks now. My colleague copied the disks and we were trying to rebuild 
the RAID5 on the copies. We tried to do the rebuild on a PC runing a 
fairly recent Knoppix:

root@Microknoppix:~# mdadm --create --assume-clean --level=5 
--raid-devices=4 --size=1948662272 /dev/md2 missing /dev/sda3 missing 
/dev/sdb3
mdadm: /dev/sda3 appears to be part of a raid array:
     level=raid5 devices=4 ctime=Thu May  9 22:47:08 2013
mdadm: /dev/sdb3 appears to be part of a raid array:
     level=raid5 devices=4 ctime=Thu May  9 22:47:08 2013
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: RUN_ARRAY failed: Input/output error

Apparently, this did not work. :-(

In the RAID wiki, it says one should ask here before trying a destroying 
to much, that's why I am asking here....

Btw, attached is the raid.status and the dmesg output.

Is there a hint what we need to do?

Thanks in advance,
Philipp

--------------050600090704060207090902
Content-Type: text/plain; charset=windows-1252;
 name="output.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="output.txt"

[    8.601246] grow_buffers: requested out-of-range block 18446744072372647623 for device sdb3
[    8.601249] UDF-fs: error (device sdb3): udf_read_tagged: read failed, block=3198020433, location=-1096946863
[    8.601252] grow_buffers: requested out-of-range block 18446744072372647934 for device sdb3
[    8.601254] UDF-fs: error (device sdb3): udf_read_tagged: read failed, block=3198020688, location=-1096946608
[    8.601257] grow_buffers: requested out-of-range block 18446744072372647622 for device sdb3
[    8.601260] UDF-fs: error (device sdb3): udf_read_tagged: read failed, block=3198020432, location=-1096946864
[    8.601262] grow_buffers: requested out-of-range block 18446744072372647624 for device sdb3
[    8.601265] UDF-fs: error (device sdb3): udf_read_tagged: read failed, block=3198020434, location=-1096946862
[    8.601268] grow_buffers: requested out-of-range block 18446744072372647933 for device sdb3
[    8.601270] UDF-fs: error (device sdb3): udf_read_tagged: read failed, block=3198020687, location=-1096946609
[    8.601273] grow_buffers: requested out-of-range block 18446744072372647621 for device sdb3
[    8.601276] UDF-fs: error (device sdb3): udf_read_tagged: read failed, block=3198020431, location=-1096946865
[    8.601278] grow_buffers: requested out-of-range block 18446744072372647750 for device sdb3
[    8.601281] UDF-fs: error (device sdb3): udf_read_tagged: read failed, block=3198020539, location=-1096946757
[    8.601284] grow_buffers: requested out-of-range block 18446744072372647438 for device sdb3
[    8.601286] UDF-fs: error (device sdb3): udf_read_tagged: read failed, block=3198020283, location=-1096947013
[    8.601289] grow_buffers: requested out-of-range block 18446744072372647748 for device sdb3
[    8.601291] UDF-fs: error (device sdb3): udf_read_tagged: read failed, block=3198020537, location=-1096946759
[    8.601294] grow_buffers: requested out-of-range block 18446744072372647436 for device sdb3
[    8.601297] UDF-fs: error (device sdb3): udf_read_tagged: read failed, block=3198020281, location=-1096947015
[    8.633283] UDF-fs: warning (device sdb3): udf_fill_super: No partition found (1)
[    8.671669] FAT-fs (sdc1): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
[    8.827286] cloop: Can't open device read-write in mode 0x1f
[    8.841807] cloop: losetup_file: 15549 blocks, 131072 bytes/block, largest block is 131098 bytes.
[    8.861463] ISO 9660 Extensions: RRIP_1991A
[   18.316899] aufs test_add:264:busybox[2042]: uid/gid/perm /KNOPPIX 0/0/0755, 0/0/01777
[   19.568037] [drm] radeon kernel modesetting enabled.
[   19.568191] [drm] initializing kernel modesetting (CEDAR 0x1002:0x68F9 0x1043:0x03CA).
[   19.568206] [drm] register mmio base: 0xF7DC0000
[   19.568207] [drm] register mmio size: 131072
[   19.568397] ATOM BIOS: 68F9.12.20.0.60.AS01
[   19.568470] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 - 0x000000003FFFFFFF (1024M used)
[   19.568473] radeon 0000:01:00.0: GTT: 512M 0x0000000040000000 - 0x000000005FFFFFFF
[   19.573103] [drm] Detected VRAM RAM=1024M, BAR=256M
[   19.573107] [drm] RAM width 64bits DDR
[   19.573202] [TTM] Zone  kernel: Available graphics memory: 435976 kiB
[   19.573203] [TTM] Zone highmem: Available graphics memory: 1685004 kiB
[   19.573204] [TTM] Initializing pool allocator
[   19.573234] [drm] radeon: 1024M of VRAM memory ready
[   19.573236] [drm] radeon: 512M of GTT memory ready.
[   19.573255] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   19.573256] [drm] Driver supports precise vblank timestamp query.
[   19.573301] radeon 0000:01:00.0: irq 44 for MSI/MSI-X
[   19.573310] radeon 0000:01:00.0: radeon: using MSI.
[   19.573344] [drm] radeon: irq initialized.
[   19.573348] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   19.573636] [drm] probing gen 2 caps for device 8086:29c1 = 1/0
[   19.573674] [drm] Loading CEDAR Microcode
[   19.752047] ACPI Warning: 0x00000400-0x0000041f SystemIO conflicts with Region \SMRG 1 (20120711/utaddress-251)
[   19.752055] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   19.771647] ACPI Warning: 0x00000480-0x000004bf SystemIO conflicts with Region \GPS0 1 (20120711/utaddress-251)
[   19.771653] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
[   19.771655] lpc_ich: Resource conflict(s) found affecting gpio_ich
[   19.794779] sky2: driver version 1.30
[   19.794818] sky2 0000:02:00.0: Yukon-2 EC Ultra chip revision 3
[   19.794900] sky2 0000:02:00.0: irq 45 for MSI/MSI-X
[   19.795088] sky2 0000:02:00.0: eth0: addr 00:1e:8c:9b:c2:a8
[   19.795973] snd_hda_intel 0000:00:1b.0: irq 46 for MSI/MSI-X
[   20.317373] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[   20.317477] radeon 0000:01:00.0: WB enabled
[   20.317482] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000040000c00 and cpu addr 0xff924c00
[   20.333784] [drm] ring test on 0 succeeded in 0 usecs
[   20.333930] [drm] ib test on ring 0 succeeded in 0 usecs
[   20.334383] [drm] Radeon Display Connectors
[   20.334385] [drm] Connector 0:
[   20.334386] [drm]   HDMI-A-1
[   20.334388] [drm]   HPD1
[   20.334390] [drm]   DDC: 0x6460 0x6460 0x6464 0x6464 0x6468 0x6468 0x646c 0x646c
[   20.334392] [drm]   Encoders:
[   20.334393] [drm]     DFP1: INTERNAL_UNIPHY1
[   20.334395] [drm] Connector 1:
[   20.334397] [drm]   DVI-I-1
[   20.334398] [drm]   HPD4
[   20.334400] [drm]   DDC: 0x6450 0x6450 0x6454 0x6454 0x6458 0x6458 0x645c 0x645c
[   20.334402] [drm]   Encoders:
[   20.334403] [drm]     DFP2: INTERNAL_UNIPHY
[   20.334405] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[   20.334407] [drm] Connector 2:
[   20.334408] [drm]   VGA-1
[   20.334411] [drm]   DDC: 0x6430 0x6430 0x6434 0x6434 0x6438 0x6438 0x643c 0x643c
[   20.334412] [drm]   Encoders:
[   20.334413] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   20.334453] [drm] Internal thermal controller without fan control
[   20.334495] [drm] radeon: power management initialized
[   20.409843] [drm] fb mappable at 0xD0142000
[   20.409846] [drm] vram apper at 0xD0000000
[   20.409848] [drm] size 7299072
[   20.409849] [drm] fb depth is 24
[   20.409851] [drm]    pitch is 6912
[   20.409894] fbcon: radeondrmfb (fb0) is primary device
[   20.634495] Console: switching to colour frame buffer device 210x65
[   20.642330] fb0: radeondrmfb frame buffer device
[   20.642332] drm: registered panic notifier
[   20.642335] [drm] Initialized radeon 2.24.0 20080528 for 0000:01:00.0 on minor 0
[   20.642447] snd_hda_intel 0000:01:00.1: irq 47 for MSI/MSI-X
[   23.204085] Floppy drive(s): fd0 is 1.44M
[   23.222067] FDC 0 is a post-1991 82077
[   23.255387] logitech-djreceiver 0003:046D:C52B.0004: hiddev0,hidraw1: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1/input2
[   23.259694] input: Logitech Unifying Device. Wireless PID:4002 as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.2/0003:046D:C52B.0004/input/input3
[   23.259764] logitech-djdevice 0003:046D:C52B.0005: input,hidraw2: USB HID v1.11 Keyboard [Logitech Unifying Device. Wireless PID:4002] on usb-0000:00:1d.0-1:1
[   23.317599] Linux media interface: v0.10
[   23.329515] Linux video capture interface: v2.00
[   23.342380] gspca_main: v2.14.0 registered
[   23.354400] gspca_main: ALi m5602-2.14.0 probing 0402:5602
[   23.447385] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[   23.467999] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   23.468324] gspca_m5602: Sensor reported 0x00
[   23.491436] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[   23.507888] gspca_m5602: Detected a s5k83a sensor
[   23.563589] usbcore: registered new interface driver ALi m5602
[   23.985843] Adding 2527504k swap on /dev/zram0.  Priority:0 extents:1 across:2527504k SS
[   24.362914] sky2 0000:02:00.0: eth0: enabling interface
[   26.808806] sky2 0000:02:00.0: eth0: Link is up at 1000 Mbps, full duplex, flow control both
[   26.989818] NET: Registered protocol family 10
[   45.775875] lp: driver loaded but no devices found
[   45.779193] ppdev: user-space parallel port driver
[  108.873580] md: md2 stopped.
[  108.874281] md: bind<sda3>
[  251.127903] md: md2 stopped.
[  251.127911] md: unbind<sda3>
[  251.153329] md: export_rdev(sda3)
[  262.889300] md: md2 stopped.
[  262.890686] md: bind<sdb3>
[  262.891379] md: bind<sda3>
[  365.539083] async_tx: api initialized (async)
[  365.540515] xor: automatically using best checksumming function:
[  365.573320]    pIII_sse  : 10740.000 MB/sec
[  365.639975] raid6: mmxx1     3941 MB/s
[  365.696652] raid6: mmxx2     3113 MB/s
[  365.753338] raid6: sse1x1    1817 MB/s
[  365.809996] raid6: sse1x2    2225 MB/s
[  365.866645] raid6: sse2x1    3366 MB/s
[  365.923309] raid6: sse2x2    4144 MB/s
[  365.923312] raid6: using algorithm sse2x2 (4144 MB/s)
[  365.923314] raid6: using ssse3x1 recovery algorithm
[  365.927355] md: raid6 personality registered for level 6
[  365.927358] md: raid5 personality registered for level 5
[  365.927359] md: raid4 personality registered for level 4
[  365.927525] bio: create slab <bio-1> at 1
[  365.927545] md/raid:md2: device sda3 operational as raid disk 1
[  365.927547] md/raid:md2: device sdb3 operational as raid disk 3
[  365.927898] md/raid:md2: allocated 4250kB
[  365.927933] md/raid:md2: not enough operational devices (2/4 failed)
[  365.927944] RAID conf printout:
[  365.927946]  --- level:5 rd:4 wd:2
[  365.927948]  disk 1, o:1, dev:sda3
[  365.927950]  disk 3, o:1, dev:sdb3
[  365.928222] md/raid:md2: failed to run raid set.
[  365.928224] md: pers->run() failed ...
[  764.898143] md: md2 stopped.
[  764.898151] md: unbind<sda3>
[  764.926609] md: export_rdev(sda3)
[  764.926629] md: unbind<sdb3>
[  764.943268] md: export_rdev(sdb3)
[  787.874649] md: md2 stopped.
[  787.875397] md: bind<sdb3>
[  787.875581] md: bind<sda3>
[ 1848.916785] md: md2 stopped.
[ 1848.916793] md: unbind<sda3>
[ 1848.939838] md: export_rdev(sda3)
[ 1848.939862] md: unbind<sdb3>
[ 1848.969834] md: export_rdev(sdb3)
[ 1943.094851] md: bind<sda3>
[ 1943.096685] md: bind<sdb3>
[ 1943.098368] bio: create slab <bio-1> at 1
[ 1943.098389] md/raid:md2: device sdb3 operational as raid disk 3
[ 1943.098392] md/raid:md2: device sda3 operational as raid disk 1
[ 1943.098746] md/raid:md2: allocated 4250kB
[ 1943.098775] md/raid:md2: not enough operational devices (2/4 failed)
[ 1943.098786] RAID conf printout:
[ 1943.098788]  --- level:5 rd:4 wd:2
[ 1943.098790]  disk 1, o:1, dev:sda3
[ 1943.098792]  disk 3, o:1, dev:sdb3
[ 1943.099068] md/raid:md2: failed to run raid set.
[ 1943.099069] md: pers->run() failed ...
[ 1943.099093] md: md2 stopped.
[ 1943.099098] md: unbind<sdb3>
[ 1943.109816] md: export_rdev(sdb3)
[ 1943.109821] md: unbind<sda3>
[ 1943.126481] md: export_rdev(sda3)
root@Microknoppix:~# ls /dev/md2
/dev/md2
root@Microknoppix:~# cat /proc/partitions
major minor  #blocks  name

 240        0    1990272 cloop0
   8        0 2930266584 sda
   8        1    2498076 sda1
   8        2    2097152 sda2
   8        3 1948793856 sda3
   8       16 2930266584 sdb
   8       17    2498076 sdb1
   8       18    2097152 sdb2
   8       19 1948793856 sdb3
 251        0    2527508 zram0
   8       32    7876607 sdc
   8       33    7875583 sdc1
root@Microknoppix:~# mdadm -S /dev/md2
mdadm: stopped /dev/md2
root@Microknoppix:~# mdadm --create --assume-clean --level=5 --raid-devices=4 --size=1948662272 /dev/md2 missing /dev/sda3 missing /dev/sdb3
mdadm: /dev/sda3 appears to be part of a raid array:
    level=raid5 devices=4 ctime=Thu May  9 22:47:08 2013
mdadm: /dev/sdb3 appears to be part of a raid array:
    level=raid5 devices=4 ctime=Thu May  9 22:47:08 2013
Continue creating array? y
mdadm: Defaulting to version 1.2 metadata
mdadm: RUN_ARRAY failed: Input/output error
root@Microknoppix:~#

--------------050600090704060207090902
Content-Type: text/plain; charset=windows-1252;
 name="raid.status"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="raid.status"

/dev/sda3:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : d6f749fd:c8facea3:67a12527:d26839ce
           Name : CubeStation_CH:2
  Creation Time : Fri May 14 19:21:32 2010
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3897586617 (1858.51 GiB 1995.56 GB)
     Array Size : 5846379840 (5575.54 GiB 5986.69 GB)
  Used Dev Size : 3897586560 (1858.51 GiB 1995.56 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : 17580b66:1315c925:7cd68c49:ab0fd414

    Update Time : Thu Dec 13 22:17:50 2012
       Checksum : 2a65b28 - correct
         Events : 539041

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 1
   Array State : .A.A ('A' == active, '.' == missing)
/dev/sdb3:
          Magic : a92b4efc
        Version : 1.1
    Feature Map : 0x0
     Array UUID : d6f749fd:c8facea3:67a12527:d26839ce
           Name : CubeStation_CH:2
  Creation Time : Fri May 14 19:21:32 2010
     Raid Level : raid5
   Raid Devices : 4

 Avail Dev Size : 3897586617 (1858.51 GiB 1995.56 GB)
     Array Size : 5846379840 (5575.54 GiB 5986.69 GB)
  Used Dev Size : 3897586560 (1858.51 GiB 1995.56 GB)
    Data Offset : 264 sectors
   Super Offset : 0 sectors
          State : clean
    Device UUID : afc651a8:70326fd6:c6e261b2:4aac6c8e

    Update Time : Thu Dec 13 22:17:50 2012
       Checksum : d800900a - correct
         Events : 539041

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 3
   Array State : .A.A ('A' == active, '.' == missing)

--------------050600090704060207090902--
