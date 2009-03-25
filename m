From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: RAID5 reshape problems
Date: Wed, 25 Mar 2009 19:31:24 +0100
Message-ID: <49CA787C.2090100@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Could someone *please* help me out?

I have a problematic RAID5 and don't know how to proceed.

Situation:

gentoo linux, 32bit, 2.6.25-gentoo-r8

mdadm-2.6.4-r1

Initially 4 x 1TB SATA-disks, partitioned.

SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X
Fusion-MPT SAS (rev 01)

/dev/md2 contained of /dev/sd{abcd}4 ...

2 x 1 TB added (hotplugged), disks detected fine, partitioned

Added /dev/sd{ef}4 to /dev/md2, triggered grow to 6 raid-devices.

Started fine. Projected end of reshape ~3100 minutes, started at around
17h local time. Maybe it accelerated while I was out and userload decreased.

--

Then sdf failed:

Mar 25 17:23:47 horde sd 0:0:5:0: [sdf] CDB: cdb[0]=0x28: 28 00 01 5d de
a4 00 00 18 00
Mar 25 17:23:47 horde mptscsih: ioc0: target reset: FAILED (sc=eae51800)
Mar 25 17:23:47 horde mptscsih: ioc0: attempting bus reset! (sc=eae51800)
Mar 25 17:23:47 horde sd 0:0:5:0: [sdf] CDB: cdb[0]=0x28: 28 00 01 5d de
a4 00 00 18 00
Mar 25 17:23:47 horde mptsas: ioc0: removing sata device, channel 0, id
6, phy 6
Mar 25 17:23:47 horde port-0:5: mptsas: ioc0: delete port (5)
Mar 25 17:23:47 horde sd 0:0:5:0: [sdf] Synchronizing SCSI cache
Mar 25 17:23:47 horde mptscsih: ioc0: bus reset: SUCCESS (sc=eae51800)
Mar 25 17:23:47 horde mptscsih: ioc0: attempting host reset! (sc=eae51800)
Mar 25 17:23:47 horde mptbase: ioc0: Initiating recovery
Mar 25 17:23:47 horde mptscsih: ioc0: host reset: SUCCESS (sc=eae51800)
Mar 25 17:23:47 horde sd 0:0:5:0: Device offlined - not ready after
error recovery
Mar 25 17:23:47 horde sd 0:0:5:0: Device offlined - not ready after
error recovery
Mar 25 17:23:47 horde sd 0:0:5:0: Device offlined - not ready after
error recovery
Mar 25 17:23:47 horde sd 0:0:5:0: Device offlined - not ready after
error recovery
Mar 25 17:23:47 horde sd 0:0:5:0: Device offlined - not ready after
error recovery
Mar 25 17:23:47 horde sd 0:0:5:0: Device offlined - not ready after
error recovery
Mar 25 17:23:47 horde sd 0:0:5:0: Device offlined - not ready after
error recovery
Mar 25 17:23:47 horde sd 0:0:5:0: Device offlined - not ready after
error recovery
Mar 25 17:23:47 horde sd 0:0:5:0: [sdf] Result: hostbyte=0x01
driverbyte=0x00
Mar 25 17:23:47 horde end_request: I/O error, dev sdf, sector 42380636
Mar 25 17:23:47 horde raid5: Disk failure on sdf4, disabling device.
Operation continuing on 5 devices
Mar 25 17:23:47 horde sd 0:0:5:0: [sdf] Result: hostbyte=0x01
driverbyte=0x00
Mar 25 17:23:47 horde end_request: I/O error, dev sdf, sector 42379612
Mar 25 17:23:47 horde sd 0:0:5:0: [sdf] Result: hostbyte=0x01
driverbyte=0x00
Mar 25 17:23:47 horde end_request: I/O error, dev sdf, sector 22929100
Mar 25 17:23:47 horde raid5:md2: read error not correctable (sector
5000560 on sdf4).
Mar 25 17:23:47 horde sd 0:0:5:0: [sdf] Result: hostbyte=0x01
driverbyte=0x00
Mar 25 17:23:47 horde end_request: I/O error, dev sdf, sector 22929092
Mar 25 17:23:47 horde raid5:md2: read error not correctable (sector
5000552 on sdf4).
Mar 25 17:23:47 horde sd 0:0:5:0: [sdf] Result: hostbyte=0x01
driverbyte=0x00
Mar 25 17:23:47 horde end_request: I/O error, dev sdf, sector 22929084
Mar 25 17:23:47 horde raid5:md2: read error not correctable (sector
5000544 on sdf4).
Mar 25 17:23:47 horde sd 0:0:5:0: [sdf] Result: hostbyte=0x01
driverbyte=0x00
Mar 25 17:23:47 horde end_request: I/O error, dev sdf, sector 22929108
Mar 25 17:23:47 horde raid5:md2: read error not correctable (sector
5000568 on sdf4).
Mar 25 17:23:47 horde sd 0:0:5:0: [sdf] Result: hostbyte=0x01
driverbyte=0x00
Mar 25 17:23:47 horde end_request: I/O error, dev sdf, sector 22928988
Mar 25 17:23:47 horde raid5:md2: read error not correctable (sector
5000448 on sdf4).
Mar 25 17:23:47 horde raid5:md2: read error not correctable (sector
5000456 on sdf4).
Mar 25 17:23:47 horde raid5:md2: read error not correctable (sector
5000464 on sdf4).
Mar 25 17:23:47 horde raid5:md2: read error not correctable (sector
5000472 on sdf4).
Mar 25 17:23:47 horde raid5:md2: read error not correctable (sector
5000480 on sdf4).
Mar 25 17:23:47 horde raid5:md2: read error not correctable (sector
5000488 on sdf4).
Mar 25 17:23:47 horde raid5:md2: read error not correctable (sector
5000496 on sdf4).
Mar 25 17:23:47 horde raid5:md2: read error not correctable (sector
5000504 on sdf4).
Mar 25 17:23:47 horde raid5:md2: read error not correctable (sector
5000512 on sdf4).
Mar 25 17:23:47 horde sd 0:0:5:0: [sdf] Result: hostbyte=0x01
driverbyte=0x00
Mar 25 17:23:47 horde end_request: I/O error, dev sdf, sector 22929060
Mar 25 17:23:47 horde raid5:md2: read error not correctable (sector
5000520 on sdf4).
Mar 25 17:23:47 horde raid5:md2: read error not correctable (sector
5000528 on sdf4).
Mar 25 17:23:47 horde raid5:md2: read error not correctable (sector
5000536 on sdf4).
Mar 25 17:23:47 horde end_request: I/O error, dev sdf, sector 1953519836
Mar 25 17:23:47 horde md: super_written gets error=-5, uptodate=0
Mar 25 17:23:47 horde sd 0:0:5:0: [sdf] Result: hostbyte=0x01
driverbyte=0x00
Mar 25 17:23:47 horde md: md2: reshape done.
Mar 25 17:23:47 horde mdadm: Fail event detected on md device /dev/md2,
component device /dev/sdf4



----


Now I have a system with load ~77 ...

I don't get answers to "cat /proc/mdstat" ...

We removed sdf, which didn't decrease the load.

top doesn't show any particular hog, CPUs near idle, disks as well.

"mdadm -D" doesn't give me answers.

Only this:

# mdadm -E /dev/sda4
/dev/sda4:
          Magic : a92b4efc
        Version : 00.91.00
           UUID : 2e27c42d:40936d45:53eb5abe:265a9668
  Creation Time : Wed Oct 22 19:43:13 2008
     Raid Level : raid5
  Used Dev Size : 967795648 (922.96 GiB 991.02 GB)
     Array Size : 4838978240 (4614.81 GiB 4955.11 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 2

  Reshape pos'n : 61125760 (58.29 GiB 62.59 GB)
  Delta Devices : 2 (4->6)

    Update Time : Wed Mar 25 17:23:47 2009
          State : active
 Active Devices : 5
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 65f12171 - correct
         Events : 0.8247

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        4        0      active sync   /dev/sda4

   0     0       8        4        0      active sync   /dev/sda4
   1     1       8       20        1      active sync   /dev/sdb4
   2     2       8       36        2      active sync   /dev/sdc4
   3     3       8       52        3      active sync   /dev/sdd4
   4     4       0        0        4      faulty removed
   5     5       8       68        5      active sync   /dev/sde4


---


/dev/md2 is the single PV in an LVM-VG, I don't get output from
vgdisplay, pvdisplay.

But I see the mounted LVs, and I am able to browse the data.

The OS itself is on /dev/md1 which only contains /dev/sd{abcd}3 , so no
new/faulty disks included.

---

My question:

How to proceed? Is the raid OK? May I try a reboot and everything is OK
or NOT? Is it possible that the reshape with now only 5 disks was
finished so much faster?

I sh** my pants as there is important data there. Yes, backups exist ...
but the downtime ...

Please help me out so that I can fix this one and find sleep this night ...

Thanks a lot in advance!

Stefan
