From: Technomage <technomage-hawke@cox.net>
Subject: Re: sata controllers status=0x51 { DriveReady SeekComplete Error } error=0x84 { DriveStatusError BadCRC }
Date: Thu, 30 Mar 2006 12:28:21 -0700
Message-ID: <200603301228.21861.technomage-hawke@cox.net>
References: <200603301051.31551.mlaks@verizon.net> <442C14A8.4030606@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <442C14A8.4030606@dgreaves.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

THANK YOU! :)

it appears this might be related to some of the errors a friend of mine got 
(ref: Re: recovering data on a failed raid-0 installation).

after a bit more research, it does appears that a kernel bug in combination 
with some "fast and loose" protocol usage on a laptop IDE interface may have 
been at fault.

more research on this forthcoming when a drive imager device arrives 
tomorrow....

******* error output
the error reported in his case was:

ata3 status = status 0x51 { DriveReady SeekComplete Error } 
0x40 {Unrecoverable Error } <repeated 5 times>

scsi error 2010 0x8000002 
return code = sdb current sense key medium error 
additional sense unrecovered read error 
auto realocate failed. 
end request i/o error /dev/sdb sector 22629482 
I/O error in filesystem  
md0 metadata device md0 block 0x29a1578 
xfs log mount recovery error failed error 5
xfs log mount failed mount i/o error .... kernel panic! .....

On Thursday 30 March 2006 10:26, you wrote:
> Party line: It's a faulty cable (on both drives? triggered by rsync?
> Doesn't show up under 'badblocks'? hah!)
>
> Check out the linux-ide archive for my (and others) reports.
>
> I've had lots of issues like this - spurious and IMHO incorrect error
> messages. Only certain types of disk access cause them - xfs_repair and
> rsync seem to tickle it.
>
> With 2.6.15 I had lots of *very* scary moments with multiple disk
> failures on a raid5 during xfs_repair.
> I think it's down to the 'basic' error handling in the libata code and
> certain disks/controllers being loose with the protocol. They then
> identified problems in 'fua' (IIRC) handling which was pulled for 2.6.16.
>
> 2.6.16 seems to be much better (fewer 'odd' errors reported and md
> doesn't mind)
>
> David
> PS Mitchell - you're still using Verizon and I still live off the edge
> of their known world (in the UK) so I don't expect you'll get this reply
> - hard luck my friend - get a better ISP!)
>
> Mitchell Laks wrote:
> >Hi,
> >
> >I have a production server in place at a remote site.
> >I have a single system drive that is an ide drive
> >and two data drives that are on a via SATA controller in a raid1
> >configuration.
> >
> >I am monitoring the /var/log/messages and I get messages every few days
> >
> >Mar 22 23:31:36 A1 kernel: ata6: status=0x51 { DriveReady SeekComplete
> > Error } Mar 22 23:31:36 A1 kernel: ata6: error=0x84 { DriveStatusError
> > BadCRC }
> >
> >Mar 23 23:20:12 A1 kernel: ata5: status=0x51 { DriveReady SeekComplete
> > Error } Mar 23 23:20:12 A1 kernel: ata5: error=0x84 { DriveStatusError
> > BadCRC } Mar 23 23:32:03 A1 kernel: ata6: status=0x51 { DriveReady
> > SeekComplete Error } Mar 23 23:32:04 A1 kernel: ata6: error=0x84 {
> > DriveStatusError BadCRC }
> >
> >Mar 24 23:22:45 A1 kernel: ata5: status=0x51 { DriveReady SeekComplete
> > Error } Mar 24 23:22:45 A1 kernel: ata5: error=0x84 { DriveStatusError
> > BadCRC }
> >
> >
> >Mar 27 23:16:57 A1 kernel: ata5: status=0x51 { DriveReady SeekComplete
> > Error } Mar 27 23:16:57 A1 kernel: ata5: error=0x84 { DriveStatusError
> > BadCRC }
> >
> >Mar 28 23:10:16 A1 kernel: ata5: status=0x51 { DriveReady SeekComplete
> > Error } Mar 28 23:10:17 A1 kernel: ata5: error=0x84 { DriveStatusError
> > BadCRC } Mar 28 23:23:32 A1 kernel: ata6: status=0x51 { DriveReady
> > SeekComplete Error } Mar 28 23:23:32 A1 kernel: ata6: error=0x84 {
> > DriveStatusError BadCRC }
> >
> >
> >Mar 29 23:33:26 A1 kernel: ata6: status=0x51 { DriveReady SeekComplete
> > Error } Mar 29 23:33:26 A1 kernel: ata6: error=0x84 { DriveStatusError
> > BadCRC }
> >
> >Interestingly by the logs I see that they have occured
> >
> >March 1,2,3,8,14,17x3,20x4,21,22,23x2,24,27,28x2,29.
> >
> >(x2 means two errors as in above example).
> >
> >Also they occur during the activity of the cron job I do at 11pm to rsync
> >backup the sata drive raid 1 to another server.
> >
> >here is the output of dmesg:
> >
> >
> >ata5: dev 0 cfg 49:2f00 82:746b 83:7f01 84:4023 85:7469 86:3c01 87:4023
> >88:407f
> >ata5: dev 0 ATA, max UDMA/133, 781422768 sectors: lba48
> >ata5: dev 0 configured for UDMA/133
> >scsi4 : sata_via
> >ata6: dev 0 cfg 49:2f00 82:746b 83:7f01 84:4023 85:7469 86:3c01 87:4023
> >88:407f
> >ata6: dev 0 ATA, max UDMA/133, 781422768 sectors: lba48
> >ata6: dev 0 configured for UDMA/133
> >scsi5 : sata_via
> >  Vendor: ATA       Model: WDC WD4000YR-01P  Rev: 01.0
> >  Type:   Direct-Access                      ANSI SCSI revision: 05
> >SCSI device sda: 781422768 512-byte hdwr sectors (400088 MB)
> >SCSI device sda: drive cache: write back
> >SCSI device sda: 781422768 512-byte hdwr sectors (400088 MB)
> >SCSI device sda: drive cache: write back
> > /dev/scsi/host4/bus0/target0/lun0: p1
> >Attached scsi disk sda at scsi4, channel 0, id 0, lun 0
> >  Vendor: ATA       Model: WDC WD4000YR-01P  Rev: 01.0
> >  Type:   Direct-Access                      ANSI SCSI revision: 05
> >SCSI device sdb: 781422768 512-byte hdwr sectors (400088 MB)
> >SCSI device sdb: drive cache: write back
> >SCSI device sdb: 781422768 512-byte hdwr sectors (400088 MB)
> >SCSI device sdb: drive cache: write back
> > /dev/scsi/host5/bus0/target0/lun0: p1
> >Attached scsi disk sdb at scsi5, channel 0, id 0, lun 0
> >
> >
> >Am I correct in assuming that the sata drives are giving me these errors,
> >and what shall I do? Could it possibly be a problem with the sata
> > controller rather than the drives?
> >
> >me@A1:~$ cat /proc/mdstat
> >Personalities : [raid1]
> >md0 : active raid1 sda1[0] sdb1[1]
> >      390708736 blocks [2/2] [UU]
> >
> >unused devices: <none>
> >
> >I have done some testing with different sata controllers and recently
> > switched another server from the built in
> >sata controller on the A8v (via8237 controller) motherboard to  an add in
> > pci promise sata II150 card.
> >
> >I think I have seen conflicts between the sata_via and sata_promise and I
> >already have a sata_promise card in the system for future expandability.
> >
> >I am running the debian stock 2.6.12-1-386 kernel and debian sarge with
> > mdadm ii  mdadm          1.9.0-4sarge1  Manage MD devices aka Linux
> > Software Raid
> >
> >
> >1:/var/log# lsmod|grep sata
> >sata_via                8452  2
> >sata_promise            9988  0
> >libata                 44164  2 sata_via,sata_promise
> >scsi_mod              129096  4 sr_mod,sata_promise,libata,sd_mod
> >
> >Thank you very much.
> >
> >Mitchell
> >-
> >To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
