From: Amit Biswas <abiswas@nyu.edu>
Subject: Recovering RAID Volumes from 6 Disks
Date: Tue, 19 Jul 2016 12:29:51 -0400
Message-ID: <CADsVfeyiiAgxeeATrX9UqmWb+Hr3MCf2_eMPjL8hbD7Gpj5Ksg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings!

Backup server was acting up and the issue was the drives (all of them)
:( Could use some guidance or verdict.

It has a total of 6 drives: sda,b,c,d,e,f. From the superblock info
(attached), there is a raid 1, and a raid 10 volume. Problem is all
the disks are part of both raid volumes (according to superblock).

I am currently booted into an ubuntu live disk shell.

Raid 1 : sde2(0) sdb2(1) sdc2(s) sdd2(s) sdf2(s)
    - > 2 devices
    - > contains the boot partition. I was able to mount this.
Raid 0: sdc3(2) sdd3(3) sde3(4) sdf3(5)
    - > 6 Devices
    - > currently inactive

Again, attached are the superblocks, dmseg output.

[Thu Jul  7 15:54:07 2016] Buffer I/O error on dev sdb3, logical block
1, async page read




/dev/sdb2:

         Magic : a92b4efc

       Version : 1.2

   Feature Map : 0x0

    Array UUID : 356f81a0:69057dd3:8f19639c:26b37454

          Name : Vlab-backup:0

 Creation Time : Wed May 28 20:44:31 2014

    Raid Level : raid1

  Raid Devices : 2


Avail Dev Size : 976384 (476.83 MiB 499.91 MB)

    Array Size : 488128 (476.77 MiB 499.84 MB)

 Used Dev Size : 976256 (476.77 MiB 499.84 MB)

   Data Offset : 512 sectors

  Super Offset : 8 sectors

         State : clean

   Device UUID : ab7e7ad4:0bcf824d:3976a240:063016cf


   Update Time : Wed Jul  6 23:02:21 2016

      Checksum : ead06f71 - correct

        Events : 142



  Device Role : Active device 1

  Array State : AA ('A' == active, '.' == missing)

/dev/sdc2:

         Magic : a92b4efc

       Version : 1.2

   Feature Map : 0x0

    Array UUID : 356f81a0:69057dd3:8f19639c:26b37454

          Name : Vlab-backup:0

 Creation Time : Wed May 28 20:44:31 2014

    Raid Level : raid1

  Raid Devices : 2


Avail Dev Size : 976384 (476.83 MiB 499.91 MB)

    Array Size : 488128 (476.77 MiB 499.84 MB)

 Used Dev Size : 976256 (476.77 MiB 499.84 MB)

   Data Offset : 512 sectors

  Super Offset : 8 sectors

         State : clean

   Device UUID : 86665b3f:664bd08b:65195b2a:bd8345b1


   Update Time : Wed Jul  6 23:02:21 2016

      Checksum : 5fe6ca8b - correct

        Events : 142



  Device Role : spare

  Array State : AA ('A' == active, '.' == missing)

/dev/sdd2:

         Magic : a92b4efc

       Version : 1.2

   Feature Map : 0x0

    Array UUID : 356f81a0:69057dd3:8f19639c:26b37454

          Name : Vlab-backup:0

 Creation Time : Wed May 28 20:44:31 2014

    Raid Level : raid1

  Raid Devices : 2


Avail Dev Size : 976384 (476.83 MiB 499.91 MB)

    Array Size : 488128 (476.77 MiB 499.84 MB)

 Used Dev Size : 976256 (476.77 MiB 499.84 MB)

   Data Offset : 512 sectors

  Super Offset : 8 sectors

         State : clean

   Device UUID : 5ad0350e:5f2b9fad:c8cac4fa:aa5524ef


   Update Time : Wed Jul  6 23:02:21 2016

      Checksum : 5ed897aa - correct

        Events : 142



  Device Role : spare

  Array State : AA ('A' == active, '.' == missing)

/dev/sde2:

         Magic : a92b4efc

       Version : 1.2

   Feature Map : 0x0

    Array UUID : 356f81a0:69057dd3:8f19639c:26b37454

          Name : Vlab-backup:0

 Creation Time : Wed May 28 20:44:31 2014

    Raid Level : raid1

  Raid Devices : 2


Avail Dev Size : 976384 (476.83 MiB 499.91 MB)

    Array Size : 488128 (476.77 MiB 499.84 MB)

 Used Dev Size : 976256 (476.77 MiB 499.84 MB)

   Data Offset : 512 sectors

  Super Offset : 8 sectors

         State : clean

   Device UUID : 3e6b7c97:3feb9132:235a5a6e:836e4f35


   Update Time : Wed Jul  6 23:02:21 2016

      Checksum : 26d29aa2 - correct

        Events : 142



  Device Role : Active device 0

  Array State : AA ('A' == active, '.' == missing)

/dev/sdf2:

         Magic : a92b4efc

       Version : 1.2

   Feature Map : 0x0

    Array UUID : 356f81a0:69057dd3:8f19639c:26b37454

          Name : Vlab-backup:0

 Creation Time : Wed May 28 20:44:31 2014

    Raid Level : raid1

  Raid Devices : 2


Avail Dev Size : 976384 (476.83 MiB 499.91 MB)

    Array Size : 488128 (476.77 MiB 499.84 MB)

 Used Dev Size : 976256 (476.77 MiB 499.84 MB)

   Data Offset : 512 sectors

  Super Offset : 8 sectors

         State : clean

   Device UUID : b0b62b5e:56fbc4c5:735250c4:029d3ee2


   Update Time : Wed Jul  6 23:02:21 2016

      Checksum : 839a1cfc - correct

        Events : 142



  Device Role : spare

  Array State : AA ('A' == active, '.' == missing)

/dev/sdc3:

         Magic : a92b4efc

       Version : 1.2

   Feature Map : 0x0

    Array UUID : 3d825ac3:a2e5a336:554fa8d8:542297a3

          Name : Vlab-backup:1

 Creation Time : Wed May 28 20:44:56 2014

    Raid Level : raid10

  Raid Devices : 6


Avail Dev Size : 1952280576 (930.92 GiB 999.57 GB)

    Array Size : 2928419328 (2792.76 GiB 2998.70 GB)

 Used Dev Size : 1952279552 (930.92 GiB 999.57 GB)

   Data Offset : 262144 sectors

  Super Offset : 8 sectors

         State : clean

   Device UUID : 0b23c18b:3202f588:9b7b5636:49f80c36


   Update Time : Wed Jul  6 22:29:24 2016

      Checksum : 34d1544e - correct

        Events : 9149455


        Layout : near=2

    Chunk Size : 512K


  Device Role : Active device 2

  Array State : .AAAAA ('A' == active, '.' == missing)

/dev/sdd3:

         Magic : a92b4efc

       Version : 1.2

   Feature Map : 0x0

    Array UUID : 3d825ac3:a2e5a336:554fa8d8:542297a3

          Name : Vlab-backup:1

 Creation Time : Wed May 28 20:44:56 2014

    Raid Level : raid10

  Raid Devices : 6


Avail Dev Size : 1952280576 (930.92 GiB 999.57 GB)

    Array Size : 2928419328 (2792.76 GiB 2998.70 GB)

 Used Dev Size : 1952279552 (930.92 GiB 999.57 GB)

   Data Offset : 262144 sectors

  Super Offset : 8 sectors

         State : clean

   Device UUID : 2fd7193f:502b657f:708dc952:7a0a7309


   Update Time : Wed Jul  6 22:29:24 2016

      Checksum : ce735592 - correct

        Events : 9149455


        Layout : near=2

    Chunk Size : 512K


  Device Role : Active device 3

  Array State : .AAAAA ('A' == active, '.' == missing)

/dev/sde3:

         Magic : a92b4efc

       Version : 1.2

   Feature Map : 0x0

    Array UUID : 3d825ac3:a2e5a336:554fa8d8:542297a3

          Name : Vlab-backup:1

 Creation Time : Wed May 28 20:44:56 2014

    Raid Level : raid10

  Raid Devices : 6


Avail Dev Size : 1952280576 (930.92 GiB 999.57 GB)

    Array Size : 2928419328 (2792.76 GiB 2998.70 GB)

 Used Dev Size : 1952279552 (930.92 GiB 999.57 GB)

   Data Offset : 262144 sectors

  Super Offset : 8 sectors

         State : clean

   Device UUID : 43d64bab:059237da:63729452:2ce3beda


   Update Time : Wed Jul  6 22:29:24 2016

      Checksum : 668e7903 - correct

        Events : 9149455


        Layout : near=2

    Chunk Size : 512K


  Device Role : Active device 4

  Array State : .AAAAA ('A' == active, '.' == missing)

/dev/sdf3:

         Magic : a92b4efc

       Version : 1.2

   Feature Map : 0x0

    Array UUID : 3d825ac3:a2e5a336:554fa8d8:542297a3

          Name : Vlab-backup:1

 Creation Time : Wed May 28 20:44:56 2014

    Raid Level : raid10

  Raid Devices : 6


Avail Dev Size : 1952280576 (930.92 GiB 999.57 GB)

    Array Size : 2928419328 (2792.76 GiB 2998.70 GB)

 Used Dev Size : 1952279552 (930.92 GiB 999.57 GB)

   Data Offset : 262144 sectors

  Super Offset : 8 sectors

         State : clean

   Device UUID : c243087b:605b0938:f6b1e13b:11cf83ad


   Update Time : Wed Jul  6 22:29:24 2016

      Checksum : 50334dad - correct

        Events : 9149455


        Layout : near=2

    Chunk Size : 512K


  Device Role : Active device 5

  Array State : .AAAAA ('A' == active, '.' == missing)



[Thu Jul  7 15:53:41 2016] ata3: SATA link up 3.0 Gbps (SStatus 123
SControl 300)

[Thu Jul  7 15:53:41 2016] ata3.00: ATA-8: ST1000DM003-1CH162, CC46,
max UDMA/133

[Thu Jul  7 15:53:41 2016] ata3.00: 1953525168 sectors, multi 0: LBA48
NCQ (depth 31/32), AA

[Thu Jul  7 15:53:41 2016] ata3.00: configured for UDMA/133

[Thu Jul  7 15:53:41 2016] scsi 2:0:0:0: Direct-Access     ATA
ST1000DM003-1CH1 CC46 PQ: 0 ANSI: 5

[Thu Jul  7 15:53:41 2016] sd 2:0:0:0: [sda] 1953525168 512-byte
logical blocks: (1.00 TB/931 GiB)

[Thu Jul  7 15:53:41 2016] sd 2:0:0:0: [sda] 4096-byte physical blocks

[Thu Jul  7 15:53:41 2016] sd 2:0:0:0: Attached scsi generic sg2 type 0

[Thu Jul  7 15:53:41 2016] sd 2:0:0:0: [sda] Write Protect is off

[Thu Jul  7 15:53:41 2016] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00

[Thu Jul  7 15:53:41 2016] sd 2:0:0:0: [sda] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA

[Thu Jul  7 15:53:41 2016] scsi 3:0:0:0: Direct-Access     ATA
ST1000DM003-9YN1 CC9C PQ: 0 ANSI: 5

[Thu Jul  7 15:53:41 2016] sd 3:0:0:0: [sdb] 1953525168 512-byte
logical blocks: (1.00 TB/931 GiB)

[Thu Jul  7 15:53:41 2016] sd 3:0:0:0: [sdb] 4096-byte physical blocks

[Thu Jul  7 15:53:41 2016] sd 3:0:0:0: Attached scsi generic sg3 type 0

[Thu Jul  7 15:53:41 2016] sd 3:0:0:0: [sdb] Write Protect is off

[Thu Jul  7 15:53:41 2016] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00

[Thu Jul  7 15:53:41 2016] sd 3:0:0:0: [sdb] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA

[Thu Jul  7 15:53:41 2016] scsi 4:0:0:0: Direct-Access     ATA
ST1000NM0011     SN03 PQ: 0 ANSI: 5

[Thu Jul  7 15:53:41 2016] sd 4:0:0:0: [sdc] 1953525168 512-byte
logical blocks: (1.00 TB/931 GiB)

[Thu Jul  7 15:53:41 2016] sd 4:0:0:0: Attached scsi generic sg4 type 0

[Thu Jul  7 15:53:41 2016] sd 4:0:0:0: [sdc] Write Protect is off

[Thu Jul  7 15:53:41 2016] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00

[Thu Jul  7 15:53:41 2016] sd 4:0:0:0: [sdc] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA

[Thu Jul  7 15:53:41 2016] scsi 5:0:0:0: Direct-Access     ATA
ST1000NM0011     SN03 PQ: 0 ANSI: 5

[Thu Jul  7 15:53:41 2016] sd 5:0:0:0: [sdd] 1953525168 512-byte
logical blocks: (1.00 TB/931 GiB)

[Thu Jul  7 15:53:41 2016] sd 5:0:0:0: Attached scsi generic sg5 type 0

[Thu Jul  7 15:53:41 2016] sd 5:0:0:0: [sdd] Write Protect is off

[Thu Jul  7 15:53:41 2016] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00

[Thu Jul  7 15:53:41 2016] sd 5:0:0:0: [sdd] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA

[Thu Jul  7 15:53:41 2016] scsi 6:0:0:0: Direct-Access     ATA
ST1000DM003-1CH1 CC46 PQ: 0 ANSI: 5

[Thu Jul  7 15:53:41 2016] sd 6:0:0:0: [sde] 1953525168 512-byte
logical blocks: (1.00 TB/931 GiB)

[Thu Jul  7 15:53:41 2016] sd 6:0:0:0: [sde] 4096-byte physical blocks

[Thu Jul  7 15:53:41 2016] sd 6:0:0:0: Attached scsi generic sg6 type 0

[Thu Jul  7 15:53:41 2016] sd 6:0:0:0: [sde] Write Protect is off

[Thu Jul  7 15:53:41 2016] sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00

[Thu Jul  7 15:53:41 2016] sd 6:0:0:0: [sde] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA

[Thu Jul  7 15:53:41 2016] scsi 7:0:0:0: Direct-Access     ATA
ST1000DM003-9YN1 CC9C PQ: 0 ANSI: 5

[Thu Jul  7 15:53:41 2016] sd 7:0:0:0: [sdf] 1953525168 512-byte
logical blocks: (1.00 TB/931 GiB)

[Thu Jul  7 15:53:41 2016] sd 7:0:0:0: [sdf] 4096-byte physical blocks

[Thu Jul  7 15:53:41 2016] sd 7:0:0:0: Attached scsi generic sg7 type 0

[Thu Jul  7 15:53:41 2016] sd 7:0:0:0: [sdf] Write Protect is off

[Thu Jul  7 15:53:41 2016] sd 7:0:0:0: [sdf] Mode Sense: 00 3a 00 00

[Thu Jul  7 15:53:41 2016] sd 7:0:0:0: [sdf] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA

[Thu Jul  7 15:53:41 2016] random: nonblocking pool is initialized

[Thu Jul  7 15:53:41 2016]  sdd: sdd1 sdd2 sdd3

[Thu Jul  7 15:53:41 2016] sd 5:0:0:0: [sdd] Attached SCSI disk

[Thu Jul  7 15:53:41 2016]  sdc: sdc1 sdc2 sdc3

[Thu Jul  7 15:53:41 2016] sd 4:0:0:0: [sdc] Attached SCSI disk

[Thu Jul  7 15:53:41 2016]  sdb: sdb1 sdb2 sdb3

[Thu Jul  7 15:53:41 2016] sd 3:0:0:0: [sdb] Attached SCSI disk

[Thu Jul  7 15:53:41 2016]  sdf: sdf1 sdf2 sdf3

[Thu Jul  7 15:53:41 2016] sd 7:0:0:0: [sdf] Attached SCSI disk

[Thu Jul  7 15:53:41 2016]  sde: sde1 sde2 sde3

[Thu Jul  7 15:53:41 2016] sd 6:0:0:0: [sde] Attached SCSI disk

[Thu Jul  7 15:54:02 2016] ata3.00: qc timeout (cmd 0x47)

[Thu Jul  7 15:54:02 2016] ata3.00: READ LOG DMA EXT failed, trying unqueued

[Thu Jul  7 15:54:02 2016] ata3: failed to read log page 10h (errno=-5)

[Thu Jul  7 15:54:02 2016] ata3.00: exception Emask 0x1 SAct
0x10000000 SErr 0x0 action 0x6 frozen

[Thu Jul  7 15:54:02 2016] ata3.00: irq_stat 0x40000008

[Thu Jul  7 15:54:02 2016] ata3.00: failed command: READ FPDMA QUEUED

[Thu Jul  7 15:54:02 2016] ata3.00: cmd
60/08:e0:a8:6d:70/00:00:74:00:00/40 tag 28 ncq 4096 in

[Thu Jul  7 15:54:02 2016]          res
40/00:e0:a8:6d:70/00:00:74:00:00/40 Emask 0x1 (device error)

[Thu Jul  7 15:54:02 2016] ata3.00: status: { DRDY }

[Thu Jul  7 15:54:02 2016] ata3: hard resetting link

[Thu Jul  7 15:54:05 2016] ata3: SATA link up 3.0 Gbps (SStatus 123
SControl 300)

[Thu Jul  7 15:54:05 2016] ata3.00: configured for UDMA/133

[Thu Jul  7 15:54:05 2016] ata3: EH complete

[Thu Jul  7 15:54:06 2016] ata4.00: exception Emask 0x0 SAct 0x8 SErr
0x0 action 0x0

[Thu Jul  7 15:54:06 2016] ata4.00: irq_stat 0x40000008

[Thu Jul  7 15:54:06 2016] ata4.00: failed command: READ FPDMA QUEUED

[Thu Jul  7 15:54:06 2016] ata4.00: cmd
60/08:18:08:f8:0e/00:00:00:00:00/40 tag 3 ncq 4096 in

[Thu Jul  7 15:54:06 2016]          res
41/40:08:09:f8:0e/00:00:00:00:00/00 Emask 0x409 (media error) <F>

[Thu Jul  7 15:54:06 2016] ata4.00: status: { DRDY ERR }

[Thu Jul  7 15:54:06 2016] ata4.00: error: { UNC }

[Thu Jul  7 15:54:06 2016] ata4.00: configured for UDMA/133

[Thu Jul  7 15:54:06 2016] sd 3:0:0:0: [sdb] tag#3 FAILED Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE

[Thu Jul  7 15:54:06 2016] sd 3:0:0:0: [sdb] tag#3 Sense Key : Medium
Error [current] [descriptor]

[Thu Jul  7 15:54:06 2016] sd 3:0:0:0: [sdb] tag#3 Add. Sense:
Unrecovered read error - auto reallocate failed

[Thu Jul  7 15:54:06 2016] sd 3:0:0:0: [sdb] tag#3 CDB: Read(10) 28 00
00 0e f8 08 00 00 08 00

[Thu Jul  7 15:54:06 2016] blk_update_request: I/O error, dev sdb, sector 981001

[Thu Jul  7 15:54:06 2016] ata4: EH complete

[Thu Jul  7 15:54:07 2016] ata4.00: exception Emask 0x0 SAct 0x400
SErr 0x0 action 0x0

[Thu Jul  7 15:54:07 2016] ata4.00: irq_stat 0x40000008

[Thu Jul  7 15:54:07 2016] ata4.00: failed command: READ FPDMA QUEUED

[Thu Jul  7 15:54:07 2016] ata4.00: cmd
60/08:50:08:f8:0e/00:00:00:00:00/40 tag 10 ncq 4096 in

[Thu Jul  7 15:54:07 2016]          res
41/40:08:09:f8:0e/00:00:00:00:00/00 Emask 0x409 (media error) <F>

[Thu Jul  7 15:54:07 2016] ata4.00: status: { DRDY ERR }

[Thu Jul  7 15:54:07 2016] ata4.00: error: { UNC }

[Thu Jul  7 15:54:07 2016] ata4.00: configured for UDMA/133

[Thu Jul  7 15:54:07 2016] sd 3:0:0:0: [sdb] tag#10 FAILED Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE

[Thu Jul  7 15:54:07 2016] sd 3:0:0:0: [sdb] tag#10 Sense Key : Medium
Error [current] [descriptor]

[Thu Jul  7 15:54:07 2016] sd 3:0:0:0: [sdb] tag#10 Add. Sense:
Unrecovered read error - auto reallocate failed

[Thu Jul  7 15:54:07 2016] sd 3:0:0:0: [sdb] tag#10 CDB: Read(10) 28
00 00 0e f8 08 00 00 08 00

[Thu Jul  7 15:54:07 2016] blk_update_request: I/O error, dev sdb, sector 981001

[Thu Jul  7 15:54:07 2016] Buffer I/O error on dev sdb3, logical block
1, async page read

[Thu Jul  7 15:54:07 2016] ata4: EH complete

[Thu Jul  7 15:54:07 2016] ata4.00: exception Emask 0x0 SAct 0x2 SErr
0x0 action 0x0

[Thu Jul  7 15:54:07 2016] ata4.00: irq_stat 0x40000008

[Thu Jul  7 15:54:07 2016] ata4.00: failed command: READ FPDMA QUEUED

[Thu Jul  7 15:54:07 2016] ata4.00: cmd
60/08:08:08:f8:0e/00:00:00:00:00/40 tag 1 ncq 4096 in

[Thu Jul  7 15:54:07 2016]          res
41/40:08:09:f8:0e/00:00:00:00:00/00 Emask 0x409 (media error) <F>

[Thu Jul  7 15:54:07 2016] ata4.00: status: { DRDY ERR }

[Thu Jul  7 15:54:07 2016] ata4.00: error: { UNC }

[Thu Jul  7 15:54:07 2016] ata4.00: configured for UDMA/133

[Thu Jul  7 15:54:07 2016] sd 3:0:0:0: [sdb] tag#1 FAILED Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE

[Thu Jul  7 15:54:07 2016] sd 3:0:0:0: [sdb] tag#1 Sense Key : Medium
Error [current] [descriptor]

[Thu Jul  7 15:54:07 2016] sd 3:0:0:0: [sdb] tag#1 Add. Sense:
Unrecovered read error - auto reallocate failed

[Thu Jul  7 15:54:07 2016] sd 3:0:0:0: [sdb] tag#1 CDB: Read(10) 28 00
00 0e f8 08 00 00 08 00

[Thu Jul  7 15:54:07 2016] blk_update_request: I/O error, dev sdb, sector 981001

[Thu Jul  7 15:54:07 2016] Buffer I/O error on dev sdb3, logical block
1, async page read

[Thu Jul  7 15:54:07 2016] ata4: EH complete

[Thu Jul  7 15:54:08 2016] ata4.00: exception Emask 0x0 SAct 0x20 SErr
0x0 action 0x0

[Thu Jul  7 15:54:08 2016] ata4.00: irq_stat 0x40000008

[Thu Jul  7 15:54:08 2016] ata4.00: failed command: READ FPDMA QUEUED

[Thu Jul  7 15:54:08 2016] ata4.00: cmd
60/08:28:08:f8:0e/00:00:00:00:00/40 tag 5 ncq 4096 in

[Thu Jul  7 15:54:08 2016]          res
41/40:08:09:f8:0e/00:00:00:00:00/00 Emask 0x409 (media error) <F>

[Thu Jul  7 15:54:08 2016] ata4.00: status: { DRDY ERR }

[Thu Jul  7 15:54:08 2016] ata4.00: error: { UNC }

[Thu Jul  7 15:54:08 2016] ata4.00: configured for UDMA/133

[Thu Jul  7 15:54:08 2016] sd 3:0:0:0: [sdb] tag#5 FAILED Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE

[Thu Jul  7 15:54:08 2016] sd 3:0:0:0: [sdb] tag#5 Sense Key : Medium
Error [current] [descriptor]

[Thu Jul  7 15:54:08 2016] sd 3:0:0:0: [sdb] tag#5 Add. Sense:
Unrecovered read error - auto reallocate failed

[Thu Jul  7 15:54:08 2016] sd 3:0:0:0: [sdb] tag#5 CDB: Read(10) 28 00
00 0e f8 08 00 00 08 00

[Thu Jul  7 15:54:08 2016] blk_update_request: I/O error, dev sdb, sector 981001

[Thu Jul  7 15:54:08 2016] Buffer I/O error on dev sdb3, logical block
1, async page read

[Thu Jul  7 15:54:08 2016] ata4: EH complete

[Thu Jul  7 15:54:09 2016] ata4.00: exception Emask 0x0 SAct 0x4000000
SErr 0x0 action 0x0

[Thu Jul  7 15:54:09 2016] ata4.00: irq_stat 0x40000008

[Thu Jul  7 15:54:09 2016] ata4.00: failed command: READ FPDMA QUEUED

[Thu Jul  7 15:54:09 2016] ata4.00: cmd
60/08:d0:08:f8:0e/00:00:00:00:00/40 tag 26 ncq 4096 in

[Thu Jul  7 15:54:09 2016]          res
41/40:08:09:f8:0e/00:00:00:00:00/00 Emask 0x409 (media error) <F>

[Thu Jul  7 15:54:09 2016] ata4.00: status: { DRDY ERR }

[Thu Jul  7 15:54:09 2016] ata4.00: error: { UNC }

[Thu Jul  7 15:54:09 2016] ata4.00: configured for UDMA/133

[Thu Jul  7 15:54:09 2016] sd 3:0:0:0: [sdb] tag#26 FAILED Result:
hostbyte=DID_OK driverbyte=DRIVER_SENSE

[Thu Jul  7 15:54:09 2016] sd 3:0:0:0: [sdb] tag#26 Sense Key : Medium
Error [current] [descriptor]

[Thu Jul  7 15:54:09 2016] sd 3:0:0:0: [sdb] tag#26 Add. Sense:
Unrecovered read error - auto reallocate failed

[Thu Jul  7 15:54:09 2016] sd 3:0:0:0: [sdb] tag#26 CDB: Read(10) 28
00 00 0e f8 08 00 00 08 00

[Thu Jul  7 15:54:09 2016] blk_update_request: I/O error, dev sdb, sector 981001

[Thu Jul  7 15:54:09 2016] Buffer I/O error on dev sdb3, logical block
1, async page read

[Thu Jul  7 15:54:09 2016] ata4: EH complete

[Thu Jul  7 15:54:09 2016] ata4.00: exception Emask 0x0 SAct
0x40000000 SErr 0x0 action 0x0




Much appreciated,
Amit Biswas
