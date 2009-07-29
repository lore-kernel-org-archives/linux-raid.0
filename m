From: Mark J Hewitt <mjh@elsabio.demon.co.uk>
Subject: PCI device initialisation and RAID assembly
Date: Wed, 29 Jul 2009 23:44:19 +0100
Message-ID: <4A70D0C3.9000901@elsabio.demon.co.uk>
Reply-To: m.hewitt@computer.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think I have an issue here with initialization timing of a PCI SATA 
card and a RAID 5 array assembly.

The history ...

I'm just putting together a small storage appliance using old 
components.  The Motherboard came from an old HP Compaq and has two SATA 
and two PATA connectors.  I build the first RAID 5 array from one PATA 
and two SATA drives, and this was working fine but very slow.  I decided 
to play with a PCI SATA card (StarTech 4 port) and migrate the PATA 
element onto another SATA drive.  Doing this is the most obvious way 
(add the new drive, fault the old one and remove it, wait for resync) 
seems to work fine.  However, when I reboot, the array is built from the 
original 2 SATA drives only in degraded mode.  I can re-add the SATA 
drive attached to the PCI card, but of course, it takes the best part of 
a day to resync.

So my guess is that the kernel (2.6.29.6 running in Fedora 11 compiled 
with PAE support) is not bringing up the PCI card before assembling the 
RAID array.

I say this because the log looks like this:
...
...
Jul 29 19:56:53 janus kernel: raid6: int32x2    761 MB/s
Jul 29 19:56:53 janus kernel: raid6: int32x4    699 MB/s
Jul 29 19:56:53 janus kernel: raid6: int32x8    457 MB/s
Jul 29 19:56:53 janus kernel: raid6: mmxx1     2140 MB/s
Jul 29 19:56:53 janus kernel: raid6: mmxx2     2417 MB/s
Jul 29 19:56:53 janus kernel: raid6: sse1x1    1265 MB/s
Jul 29 19:56:53 janus kernel: raid6: sse1x2    2121 MB/s
Jul 29 19:56:53 janus kernel: raid6: sse2x1    2539 MB/s
Jul 29 19:56:53 janus kernel: raid6: sse2x2    2652 MB/s
Jul 29 19:56:53 janus kernel: raid6: using algorithm sse2x2 (2652 MB/s)
Jul 29 19:56:53 janus kernel: md: raid6 personality registered for level 6
Jul 29 19:56:53 janus kernel: md: raid5 personality registered for level 5
Jul 29 19:56:53 janus kernel: md: raid4 personality registered for level 4
Jul 29 19:56:53 janus kernel: md: md0 stopped.
Jul 29 19:56:53 janus kernel: md: bind<sda3>                           
*<-- This is the removed PATA drive*
Jul 29 19:56:53 janus kernel: md: bind<sdc3>                           
*<-- Original SATA drive*
Jul 29 19:56:53 janus kernel: md: bind<sdb3>                           
*<-- Original SATA drive*
Jul 29 19:56:53 janus kernel: md: kicking non-fresh sda3 from array!
Jul 29 19:56:53 janus kernel: md: unbind<sda3>
Jul 29 19:56:53 janus kernel: md: export_rdev(sda3)
Jul 29 19:56:53 janus kernel: raid5: device sdb3 operational as raid disk 1
Jul 29 19:56:53 janus kernel: raid5: device sdc3 operational as raid disk 2
Jul 29 19:56:53 janus kernel: raid5: allocated 3176kB for md0
Jul 29 19:56:53 janus kernel: raid5: raid level 5 set md0 active with 2 
out of 3 devices, algorithm 2
Jul 29 19:56:53 janus kernel: RAID5 conf printout:
Jul 29 19:56:53 janus kernel: --- rd:3 wd:2
Jul 29 19:56:53 janus kernel: disk 1, o:1, dev:sdb3
Jul 29 19:56:53 janus kernel: disk 2, o:1, dev:sdc3
Jul 29 19:56:53 janus kernel: md0: unknown partition table

...
...
... later!
...
...
Jul 29 19:56:53 janus kernel: sata_sil 0000:05:09.0: PCI INT A -> GSI 18 
(level, low) -> IRQ 18
Jul 29 19:56:53 janus kernel: scsi4 : sata_sil
Jul 29 19:56:53 janus kernel: scsi5 : sata_sil
Jul 29 19:56:53 janus kernel: scsi6 : sata_sil
Jul 29 19:56:53 janus kernel: scsi7 : sata_sil
Jul 29 19:56:53 janus kernel: ata5: SATA max UDMA/100 mmio 
m1024@0xfc510000 tf 0xfc510080 irq 18
Jul 29 19:56:53 janus kernel: ata6: SATA max UDMA/100 mmio 
m1024@0xfc510000 tf 0xfc5100c0 irq 18
Jul 29 19:56:53 janus kernel: ata7: SATA max UDMA/100 mmio 
m1024@0xfc510000 tf 0xfc510280 irq 18
Jul 29 19:56:53 janus kernel: ata8: SATA max UDMA/100 mmio 
m1024@0xfc510000 tf 0xfc5102c0 irq 18

Jul 29 19:56:53 janus kernel: ata5: SATA link up 1.5 Gbps (SStatus 113 
SControl 310)
Jul 29 19:56:53 janus kernel: ata5.00: ATA-8: Hitachi HDT721050SLA360, 
ST3OA3AA, max UDMA/133  *<-- The third SATA drive*
Jul 29 19:56:53 janus kernel: ata5.00: 976773168 sectors, multi 16: 
LBA48 NCQ (depth 0/32)

...
... Finally, (and manually :-( )
...

Jul 29 20:00:12 janus kernel: md: bind<sdd3>
Jul 29 20:00:12 janus kernel: RAID5 conf printout:
Jul 29 20:00:12 janus kernel: --- rd:3 wd:2
Jul 29 20:00:12 janus kernel: disk 0, o:1, dev:sdd3
Jul 29 20:00:12 janus kernel: disk 1, o:1, dev:sdb3
Jul 29 20:00:12 janus kernel: disk 2, o:1, dev:sdc3
Jul 29 20:00:12 janus kernel: md: recovery of RAID array md0
Jul 29 20:00:12 janus kernel: md: minimum _guaranteed_  speed: 1000 
KB/sec/disk.
Jul 29 20:00:12 janus kernel: md: using maximum available idle IO 
bandwidth (but not more than 200000 KB/sec) for recovery.
Jul 29 20:00:12 janus kernel: md: using 128k window, over a total of 
487098624 blocks.

Is there anything I can do about this? 

Mark.

