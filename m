From: Eric Smith <eric.d.bald.smith@gmail.com>
Subject: 4 drive raid 5 array with 2 drives down
Date: Thu, 10 Oct 2013 18:51:28 -0400
Message-ID: <CAJJ2cgSy8J2tSy0g6YWJOYdfEp13Fu7jxgwtxp1qt7Z4jL+JtA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Please help for I have committed the sin of not having backups.

I had a functional 4 drive Raid5 array.  I lost one drive called
support to warranty it and in the time that it was coming to me a
second drive died also.

So from reading the raid recovery wiki page.  I believe  I have
gathered up all the information listed.  Which i will paste bellow.  I
don't have the second failed drive yet but it's on its way.

the system is is a qnap device I have spooken to there support and
they felt there was nothing else they could do.   Reading the wiki
though gives a glimmer of hope so here is the info I have gathered and
at the end the commands that qnap support tried.

Should anything be tried until replacement hard drives are in hand ?

Is there any more information I should gather ?

Also the message log is blank so no info is there.

Thank you in advanced for any and all help and advice.

[/var/log] # uname -a
Linux ssdrnas 3.4.6 #1 SMP Fri Mar 1 02:27:41 CST 2013 x86_64 unknown


[/var/log] # mdadm --version
mdadm - v2.6.3 - 20th August 2007

[/var/log] # mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 96e2de09:b9ac4714:f12744fe:2f50a9e9
  Creation Time : Thu Sep 27 04:08:51 2012
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 4
  Total Devices : 2
Preferred Minor : 9

    Update Time : Thu Oct 10 17:43:18 2013
          State : clean
Internal Bitmap : present
 Active Devices : 2
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 0
       Checksum : bcf9655c - correct
         Events : 0.122977





      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

   0     0       8       49        0      active sync   /dev/sdd1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
[/var/log] # mdadm --examine /dev/sdc1
mdadm: cannot open /dev/sdc1: No such device or address
[/var/log] # mdadm --examine /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 96e2de09:b9ac4714:f12744fe:2f50a9e9
  Creation Time : Thu Sep 27 04:08:51 2012
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 4
  Total Devices : 2
Preferred Minor : 9

    Update Time : Thu Oct 10 17:43:18 2013
          State : clean
Internal Bitmap : present
 Active Devices : 2
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 0
       Checksum : bcf9657a - correct
         Events : 0.122977


      Number   Major   Minor   RaidDevice State
this     0       8       49        0      active sync   /dev/sdd1

   0     0       8       49        0      active sync   /dev/sdd1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed


****************

[/var/log] # dmesg
k 0x0 SAct 0x0 SErr 0x0 action 0x0
[12286.089405] ata3.00: irq_stat 0x40000001
[12286.089411] ata3.00: failed command: READ DMA
[12286.089423] ata3.00: cmd c8/00:04:04:00:00/00:00:00:00:00/e0 tag 0
dma 2048 in
[12286.089426]          res 51/04:04:04:00:00/00:00:00:00:00/e0 Emask
0x1 (device error)
[12286.089431] ata3.00: status: { DRDY ERR }
[12286.089435] ata3.00: error: { ABRT }
[12286.089605] ata3.00: configured for UDMA/133
[12286.089621] ata3: EH complete
[12287.077327] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[12287.077333] ata3.00: irq_stat 0x40000001
[12287.077339] ata3.00: failed command: READ DMA
[12287.077351] ata3.00: cmd c8/00:04:04:00:00/00:00:00:00:00/e0 tag 0
dma 2048 in
[12287.077353]          res 51/04:04:04:00:00/00:00:00:00:00/e0 Emask
0x1 (device error)
[12287.077358] ata3.00: status: { DRDY ERR }
[12287.077362] ata3.00: error: { ABRT }
[12287.077527] ata3.00: configured for UDMA/133
[12287.077540] ata3: EH complete
[12288.068247] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[12288.068253] ata3.00: irq_stat 0x40000001
[12288.068259] ata3.00: failed command: READ DMA
[12288.068270] ata3.00: cmd c8/00:04:04:00:00/00:00:00:00:00/e0 tag 0
dma 2048 in
[12288.068273]          res 51/04:04:04:00:00/00:00:00:00:00/e0 Emask
0x1 (device error)
[12288.068278] ata3.00: status: { DRDY ERR }
[12288.068282] ata3.00: error: { ABRT }
[12288.068448] ata3.00: configured for UDMA/133
[12288.068461] ata3: EH complete
[12289.060180] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[12289.060188] ata3.00: irq_stat 0x40000001
[12289.060195] ata3.00: failed command: READ DMA
[12289.060207] ata3.00: cmd c8/00:04:04:00:00/00:00:00:00:00/e0 tag 0
dma 2048 in
[12289.060209]          res 51/04:04:04:00:00/00:00:00:00:00/e0 Emask
0x1 (device error)
[12289.060215] ata3.00: status: { DRDY ERR }
[12289.060219] ata3.00: error: { ABRT }
[12289.060388] ata3.00: configured for UDMA/133
[12289.060403] ata3: EH complete
[12290.051113] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[12290.051118] ata3.00: irq_stat 0x40000001
[12290.051124] ata3.00: failed command: READ DMA
[12290.051135] ata3.00: cmd c8/00:04:04:00:00/00:00:00:00:00/e0 tag 0
dma 2048 in
[12290.051137]          res 51/04:04:04:00:00/00:00:00:00:00/e0 Emask
0x1 (device error)
[12290.051142] ata3.00: status: { DRDY ERR }
[12290.051146] ata3.00: error: { ABRT }
[12290.051321] ata3.00: configured for UDMA/133
[12290.051338] sd 2:0:0:0: [sdc]  Result: hostbyte=DID_OK
driverbyte=DRIVER_SENSE
[12290.051345] sd 2:0:0:0: [sdc]  Sense Key : Aborted Command
[current] [descriptor]
[12290.051353] Descriptor sense data with sense descriptors (in hex):
[12290.051357]         72 0b 00 00 00 00 00 0c 00 0a 80 00 00 00 00 00
[12290.051371]         00 00 00 04
[12290.051378] sd 2:0:0:0: [sdc]  Add. Sense: No additional sense information
[12290.051385] sd 2:0:0:0: [sdc] CDB: Read(10): 28 00 00 00 00 04 00 00 04 00
[12290.051402] end_request: I/O error, dev sdc, sector 4
[12290.051408] Buffer I/O error on device sdc, logical block 2
[12290.051414] Buffer I/O error on device sdc, logical block 3
[12290.051440] ata3: EH complete
[12290.051728] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[12290.051736] ata3.00: irq_stat 0x40000001
[12290.051741] ata3.00: failed command: FLUSH CACHE
[12290.051753] ata3.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[12290.051755]          res 51/04:00:00:00:00/00:00:00:00:00/a0 Emask
0x1 (device error)
[12290.051761] ata3.00: status: { DRDY ERR }
[12290.051765] ata3.00: error: { ABRT }
[12290.051927] ata3.00: configured for UDMA/133
[12290.051933] ata3.00: device reported invalid CHS sector 0
[12290.051942] ata3: EH complete
[12291.042048] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[12291.042054] ata3.00: irq_stat 0x40000001
[12291.042059] ata3.00: failed command: FLUSH CACHE
[12291.042070] ata3.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[12291.042072]          res 51/04:00:00:00:00/00:00:00:00:00/a0 Emask
0x1 (device error)
[12291.042078] ata3.00: status: { DRDY ERR }
[12291.042082] ata3.00: error: { ABRT }
[12291.042250] ata3.00: configured for UDMA/133
[12291.042257] ata3.00: device reported invalid CHS sector 0
[12291.042267] ata3: EH complete
[12292.032963] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[12292.032970] ata3.00: irq_stat 0x40000001
[12292.032976] ata3.00: failed command: FLUSH CACHE
[12292.032991] ata3.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[12292.032994]          res 51/04:00:00:00:00/00:00:00:00:00/a0 Emask
0x1 (device error)
[12292.033000] ata3.00: status: { DRDY ERR }
[12292.033004] ata3.00: error: { ABRT }
[12292.033170] ata3.00: configured for UDMA/133
[12292.033177] ata3.00: device reported invalid CHS sector 0
[12292.033186] ata3: EH complete
[12293.017919] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[12293.017928] ata3.00: irq_stat 0x40000001
[12293.017934] ata3.00: failed command: FLUSH CACHE
[12293.017949] ata3.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[12293.017951]          res 51/04:00:00:00:00/00:00:00:00:00/a0 Emask
0x1 (device error)
[12293.017957] ata3.00: status: { DRDY ERR }
[12293.017961] ata3.00: error: { ABRT }
[12293.018124] ata3.00: configured for UDMA/133
[12293.018131] ata3.00: device reported invalid CHS sector 0
[12293.018140] ata3: EH complete
[12294.003875] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[12294.003882] ata3.00: irq_stat 0x40000001
[12294.003887] ata3.00: failed command: FLUSH CACHE
[12294.003899] ata3.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[12294.003901]          res 51/04:00:00:00:00/00:00:00:00:00/a0 Emask
0x1 (device error)
[12294.003906] ata3.00: status: { DRDY ERR }
[12294.003910] ata3.00: error: { ABRT }
[12294.004081] ata3.00: configured for UDMA/133
[12294.004087] ata3.00: device reported invalid CHS sector 0
[12294.004096] ata3: EH complete
[12295.000780] ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[12295.000786] ata3.00: irq_stat 0x40000001
[12295.000791] ata3.00: failed command: FLUSH CACHE
[12295.000802] ata3.00: cmd e7/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[12295.000804]          res 51/04:00:00:00:00/00:00:00:00:00/a0 Emask
0x1 (device error)
[12295.000810] ata3.00: status: { DRDY ERR }
[12295.000814] ata3.00: error: { ABRT }
[12295.000977] ata3.00: configured for UDMA/133
[12295.000984] ata3.00: device reported invalid CHS sector 0
[12295.001022] ata3: EH complete
[12326.303740] _ahci_qc_defer: command= 0x98 not supported
[12386.325541] _ahci_qc_defer: command= 0x98 not supported
[12446.571096] _ahci_qc_defer: command= 0x98 not supported
[12507.024747] _ahci_qc_defer: command= 0x98 not supported
[12552.635284] ata3: exception Emask 0x50 SAct 0x0 SErr 0x4090800
action 0xe frozen
[12552.635290] ata3: irq_stat 0x00400040, connection status changed
[12552.635296] ata3: SError: { HostInt PHYRdyChg 10B8B DevExch }
[12552.635306] ata3: hard resetting link
[12553.356327] ata3: SATA link down (SStatus 0 SControl 300)
[12558.345890] ata3: hard resetting link
[12558.650269] ata3: SATA link down (SStatus 0 SControl 300)
[12558.650287] ata3: limiting SATA link speed to 1.5 Gbps
[12563.639841] ata3: hard resetting link
[12563.944216] ata3: SATA link down (SStatus 0 SControl 310)
[12563.944231] ata3.00: disabled
[12563.944251] ata3: EH complete
[12563.944264] ata3.00: detaching (SCSI 2:0:0:0)
[12563.949409] sd 2:0:0:0: [sdc] Synchronizing SCSI cache
[12563.949486] sd 2:0:0:0: [sdc]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[12563.949493] sd 2:0:0:0: [sdc] Stopping disk
[12563.949513] sd 2:0:0:0: [sdc] START_STOP FAILED
[12563.949517] sd 2:0:0:0: [sdc]  Result: hostbyte=DID_BAD_TARGET
driverbyte=DRIVER_OK
[12578.121649] md: md0 stopped.
[/var/log] #


*****


[/var/log] # mdadm --examine /dev/sdb3
/dev/sdb3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : fa23dcb8:4e94a228:9fd4582a:da8f7f01
  Creation Time : Thu Sep 27 04:11:12 2012
     Raid Level : raid5
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 5855836800 (5584.56 GiB 5996.38 GB)
   Raid Devices : 4
  Total Devices : 2
Preferred Minor : 0

    Update Time : Wed Sep 25 04:56:42 2013
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 834c51c4 - correct
         Events : 0.152672

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       19        1      active sync   /dev/sdb3

   0     0       0        0        0      removed
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       0        0        2      faulty removed
   3     3       8       51        3      active sync   /dev/sdd3
[/var/log] # mdadm --examine /dev/sdc3
mdadm: cannot open /dev/sdc3: No such device or address
[/var/log] # mdadm --examine /dev/sdd3
/dev/sdd3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : fa23dcb8:4e94a228:9fd4582a:da8f7f01
  Creation Time : Thu Sep 27 04:11:12 2012
     Raid Level : raid5
  Used Dev Size : 1951945600 (1861.52 GiB 1998.79 GB)
     Array Size : 5855836800 (5584.56 GiB 5996.38 GB)
   Raid Devices : 4
  Total Devices : 2
Preferred Minor : 0

    Update Time : Wed Sep 25 04:56:42 2013
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 834c51e8 - correct
         Events : 0.152672

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       51        3      active sync   /dev/sdd3

   0     0       0        0        0      removed
   1     1       8       19        1      active sync   /dev/sdb3
   2     2       0        0        2      faulty removed
   3     3       8       51        3      active sync   /dev/sdd3
[/var/log] #


*****

[/var/log] # mdadm --examine /dev/sd[a-z] | egrep 'Event|/dev/sd'
mdadm: cannot open /dev/sda: No such device or address
mdadm: No md superblock detected on /dev/sdb.
mdadm: cannot open /dev/sdc: No such device or address
mdadm: No md superblock detected on /dev/sdd.
mdadm: cannot open /dev/sde: No such device or address
mdadm: cannot open /dev/sdf: No such device or address
mdadm: cannot open /dev/sdg: No such device or address
mdadm: cannot open /dev/sdh: No such device or address
mdadm: cannot open /dev/sdi: No such device or address
mdadm: cannot open /dev/sdj: No such device or address
mdadm: cannot open /dev/sdk: No such device or address
mdadm: cannot open /dev/sdl: No such device or address
mdadm: cannot open /dev/sdm: No such device or address
mdadm: cannot open /dev/sdn: No such device or address
mdadm: cannot open /dev/sdo: No such device or address
mdadm: cannot open /dev/sdp: No such device or address
mdadm: cannot open /dev/sdq: No such device or address
mdadm: cannot open /dev/sdr: No such device or address
mdadm: cannot open /dev/sds: No such device or address
mdadm: cannot open /dev/sdt: No such device or address
mdadm: cannot open /dev/sdu: No such device or address
mdadm: cannot open /dev/sdv: No such device or address
mdadm: cannot open /dev/sdw: No such device or address
mdadm: No md superblock detected on /dev/sdx.
mdadm: cannot open /dev/sdy: No such device or address
mdadm: cannot open /dev/sdz: No such device or address
[/var/log] # uname -all
uname: invalid option -- l
BusyBox v1.01 (2013.02.28-19:11+0000) multi-call binary

Usage: uname [OPTION]...

Print certain system information.  With no OPTION, same as -s.

Options:
        -a      print all information
        -m      the machine (hardware) type
        -n      print the machine's network node hostname
        -r      print the operating system release
        -s      print the operating system name
        -p      print the host processor type
        -v      print the operating system version

[/var/log] # uname -a
Linux ssdrnas 3.4.6 #1 SMP Fri Mar 1 02:27:41 CST 2013 x86_64 unknown
[/var/log] #


*******

[~] # mdadm --examine /dev/sd[bcdefghijklmn]1 >>raid.status
mdadm: cannot open /dev/sdc1: No such device or address
mdadm: cannot open /dev/sde1: No such device or address
mdadm: cannot open /dev/sdf1: No such device or address
mdadm: cannot open /dev/sdg1: No such device or address
mdadm: cannot open /dev/sdh1: No such device or address
mdadm: cannot open /dev/sdi1: No such device or address
mdadm: cannot open /dev/sdj1: No such device or address
mdadm: cannot open /dev/sdk1: No such device or address
mdadm: cannot open /dev/sdl1: No such device or address
mdadm: cannot open /dev/sdm1: No such device or address
mdadm: cannot open /dev/sdn1: No such device or address
[~] # ls
index_default.html  raid.status
[~] # cat raid.status
/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 96e2de09:b9ac4714:f12744fe:2f50a9e9
  Creation Time : Thu Sep 27 04:08:51 2012
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 4
  Total Devices : 2
Preferred Minor : 9

    Update Time : Thu Oct 10 17:43:18 2013
          State : clean
Internal Bitmap : present
 Active Devices : 2
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 0
       Checksum : bcf9655c - correct
         Events : 0.122977


      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

   0     0       8       49        0      active sync   /dev/sdd1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 96e2de09:b9ac4714:f12744fe:2f50a9e9
  Creation Time : Thu Sep 27 04:08:51 2012
     Raid Level : raid1
  Used Dev Size : 530048 (517.71 MiB 542.77 MB)
     Array Size : 530048 (517.71 MiB 542.77 MB)
   Raid Devices : 4
  Total Devices : 2
Preferred Minor : 9

    Update Time : Thu Oct 10 17:43:18 2013
          State : clean
Internal Bitmap : present
 Active Devices : 2
Working Devices : 2
 Failed Devices : 2
  Spare Devices : 0
       Checksum : bcf9657a - correct
         Events : 0.122977


      Number   Major   Minor   RaidDevice State
this     0       8       49        0      active sync   /dev/sdd1

   0     0       8       49        0      active sync   /dev/sdd1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       0        0        2      faulty removed
   3     3       0        0        3      faulty removed
[~] #



****** This were the commands that QNAP support tried *****

~] # df -h
Filesystem                Size      Used Available Use% Mounted on
/dev/ram0               139.5M    105.0M     34.4M  75% /
tmpfs                    64.0M    300.0k     63.7M   0% /tmp
/dev/sda4               356.5M    259.7M     96.8M  73% /mnt/ext
/dev/md9                509.5M     94.5M    414.9M  19% /mnt/HDA_ROOT
tmpfs                    32.0M         0     32.0M   0% /.eaccelerator.tmp
[~] # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
[raid4] [multipath]
md4 : active raid1 sdd2[1] sdb2[0]
      530048 blocks [2/2] [UU]

md13 : active raid1 sdd4[0] sdb4[1]
      458880 blocks [4/2] [UU__]
      bitmap: 46/57 pages [184KB], 4KB chunk

md9 : active raid1 sdd1[0] sdb1[1]
      530048 blocks [4/2] [UU__]
      bitmap: 45/65 pages [180KB], 4KB chunk

unused devices: <none>
[~] # mdadm -A /dev/md0 /dev/sdb3 /dev/sdc3 /dev/sdd3
mdadm: cannot open device /dev/sdc3: No such device or address
mdadm: /dev/sdc3 has no superblock - assembly aborted
