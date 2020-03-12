From: Phillip Susi <phill@thesusis.net>
Subject: Disk errors and retries
Date: Wed, 11 Mar 2020 21:43:40 -0400
Message-ID: <87zhcmgxf7.fsf@vps.thesusis.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-raid.ids

I noticed in my kernel logs tonight that one of my disks had a medium
error trying to read sector 2160 on /dev/sdd.  It appears that the
kernel retried the read request about 20 times and each time it failed
again.  After running an mdadm repair the error seems to have been
corrected and smartctl shows that the drive has had no reallocated
sectors, so I assume that either there was a power failure in the middle
of writing this sector, or the data became corrupted later, but there
isn't anything pysically wrong with the disk.  I am left with some
questions:

1)  Why did the scsi layer retry the request 20 times before finally
giving up, and then I guess md read the data from another drive?  My
understanding is that drive firmware will internally retry a number of
times before actually returning an error to the kernel.  At that point,
further reatries seem futile.  AFAIK, this is why there are some knobs
somewhere these days to instruct the drive to give up after some
reasonable time instead of continuing to retry internally, and some
knobs to tell the kernel to give up software retries.  Why is it not
just the default for the kernel to either accept the error when the
drive returns it, or at most, retry once or twice?

2)  The errored sector in this case was sector 2160 on sdd.  Partition 1
on sdd starts at sector 2048 and is part of an mdadm raid10.  That means
that the error is at sector 112 relative to /dev/sdd1, and mdadm -E
/dev/sdd1 says that data offset = 32768 sectors, unused space before =
32680 sectors.  So doesn't that mean that the errored sector isn't even
used?  So why was it being read?

This is the full mdadm -E output for /dev/sdd1:

/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 642f285a:d94f07e4:47248cca:1e948aec
           Name : faldara:0  (local to host faldara)
  Creation Time : Fri Dec 27 19:05:18 2013
     Raid Level : raid10
   Raid Devices : 3

 Avail Dev Size : 142571521 (67.98 GiB 73.00 GB)
     Array Size : 106905600 (101.95 GiB 109.47 GB)
  Used Dev Size : 142540800 (67.97 GiB 72.98 GB)
    Data Offset : 32768 sectors
   Super Offset : 8 sectors
   Unused Space : before=32680 sectors, after=30721 sectors
          State : clean
    Device UUID : 7839ac01:9625bb6d:e96cc198:04c221b6

    Update Time : Wed Mar 11 21:31:44 2020
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : bdd5e121 - correct
         Events : 1562347

         Layout : offset=2
     Chunk Size : 16384K

   Device Role : Active device 2
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)

And the full error that was repeated about 20 times:

[  255.128687] ata6.00: exception Emask 0x0 SAct 0x8000 SErr 0x0 action 0x0
[  255.128695] ata6.00: irq_stat 0x40000008
[  255.128702] ata6.00: failed command: READ FPDMA QUEUED
[  255.128713] ata6.00: cmd 60/80:78:00:08:00/00:00:00:00:00/40 tag 15 ncq dma 65536 in
                        res 41/40:00:70:08:00/00:00:00:00:00/00 Emask 0x409 (media error) <F>
[  255.128719] ata6.00: status: { DRDY ERR }
[  255.128723] ata6.00: error: { UNC }
[  255.129924] ata6.00: configured for UDMA/133
[  255.129942] sd 5:0:0:0: [sdd] tag#15 FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  255.129947] sd 5:0:0:0: [sdd] tag#15 Sense Key : Medium Error [current] 
[  255.129952] sd 5:0:0:0: [sdd] tag#15 Add. Sense: Unrecovered read error - auto reallocate failed
[  255.129956] sd 5:0:0:0: [sdd] tag#15 CDB: Read(10) 28 00 00 00 08 00 00 00 80 00
[  255.129959] print_req_error: I/O error, dev sdd, sector 2160
[  255.129993] ata6: EH complete
