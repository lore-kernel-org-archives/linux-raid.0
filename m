From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: problems with "LSISAS2008 6Gb/s SAS" kernel mpt2sas driver
Date: Thu, 21 Oct 2010 14:50:25 +0200
Message-ID: <20101021125024.GB10933@apartia.fr>
References: <20101021073159.GA30734@apartia.fr>
 <4CC01F43.8010003@seoss.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4CC01F43.8010003@seoss.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Oct 21, 2010 at 12:08:51PM +0100, Tim Small wrote:
> 
> >Any suggestion on fixing that problem would be welcome. I can send more
> >complete logs.
> 
> Looks like a firmware bug - do you have the latest firmware?  Drive
> firmwares?  Anything in the drive error logs (using smartctl)?
> 
> If not, then try opening a bug on the kernel bugzilla - LSI
> engineers read that (and sometimes even fix things).
> 
> Otherwise, you could try replacing with a straight SATA contoller,
> if that box doesn't have a SAS backplane - I've not been to
> impressed by the quality of engineering for LSI contollers, and
> SATA-on-SAS in general hasn't been very reliable IMO.  Just go for a
> well supported SATA controller (e.g. Sil 3132 etc.).

Hi Tim and thanks for your feedback.

I was eventually able to "fix" the problem. After very carefully running
lilo on each disk with "raid-extra-boot=/dev/sdX" (instead of "mbr") I
rebooted into my live system with a freshly compliled 2.6.36 and the
problem vanished. lilo now runs fine even my "raid-extra-boot=mbr" and
several reboots have not triggered any further issue.

The firmwares are all to their latest so I guess the mpt2sas kernel
driver must have been improved between 2.6.35 and 2.6.36.

For info here is part of the 2.6.36 boot log with a few ominous "!!" and
one "failure" but with no apparent consequence.

Cheers,

Oct 21 14:25:47 zenon kernel: mpt2sas version 06.100.00.00 loaded
Oct 21 14:25:47 zenon kernel: scsi0 : Fusion MPT SAS Host
Oct 21 14:25:47 zenon kernel: mpt2sas 0000:02:00.0: PCI INT A -> GSI 41 (level, 
low) -> IRQ 41
Oct 21 14:25:47 zenon kernel: mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (16426776 kB)
Oct 21 14:25:47 zenon kernel: mpt2sas0: IO-APIC enabled: IRQ 41
Oct 21 14:25:47 zenon kernel: mpt2sas0: iomem(0x00000000df2b0000), mapped(0xffffc90000060000), size(65536)
Oct 21 14:25:47 zenon kernel: mpt2sas0: ioport(0x000000000000fc00), size(256)
Oct 21 14:25:47 zenon kernel: mpt2sas0: sending diag reset !!
Oct 21 14:25:47 zenon kernel: mpt2sas0: diag reset: SUCCESS
Oct 21 14:25:47 zenon kernel: mpt2sas0: Allocated physical memory: size(1091 kB)
Oct 21 14:25:47 zenon kernel: mpt2sas0: Current Controller Queue Depth(467), Max Controller Queue Depth(3439)
Oct 21 14:25:47 zenon kernel: mpt2sas0: Scatter Gather Elements per IO(128)
Oct 21 14:25:47 zenon kernel: mpt2sas0: LSISAS2008: FWVersion(02.15.63.00), ChipRevision(0x02), BiosVersion(07.01.09.00)
Oct 21 14:25:47 zenon kernel: mpt2sas0: Dell PERC H200 Integrated: Vendor(0x1000), Device(0x0072), SSVID(0x1028), SSDID(0x1F1E)
Oct 21 14:25:47 zenon kernel: mpt2sas0: Protocol=(Initiator,Target), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
Oct 21 14:25:47 zenon kernel: mpt2sas0: sending port enable !!
Oct 21 14:25:47 zenon kernel: mpt2sas0: host_add: handle(0x0001), sas_addr(0x5842b2b05020c600), phys(8)
Oct 21 14:25:47 zenon kernel: mpt2sas0: failure at drivers/scsi/mpt2sas/mpt2sas_scsih.c:4546/_scsih_add_device()!
Oct 21 14:25:47 zenon kernel: mpt2sas0: port enable: SUCCESS
Oct 21 14:25:47 zenon kernel: scsi 0:0:0:0: Direct-Access     ATA      WDC WD1002FAEX-0 1D05 PQ: 0 ANSI: 5
Oct 21 14:25:47 zenon kernel: scsi 0:0:0:0: SATA: handle(0x0011), sas_addr(0x4433221107000000), phy(7), device_name(0x4ee25001c38204eb)
Oct 21 14:25:47 zenon kernel: scsi 0:0:0:0: SATA: enclosure_logical_id(0x5842b2b05020c600), slot(0)
Oct 21 14:25:47 zenon kernel: scsi 0:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Oct 21 14:25:47 zenon kernel: scsi 0:0:0:0: qdepth(32), tagged(1), simple(1), ordered(0), scsi_level(6), cmd_que(1)

	etc..
