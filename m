From: "Marc Marais" <marc@liquid-nexus.net>
Subject: Double failure on RAID-5 array
Date: Tue, 17 Jun 2003 00:18:48 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030616161848.M47561@liquid-nexus.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been running software raid on 2.2.19 for some time now (raidtools 0.9, 
patched etc) without incident.

I've recently upgraded to 2.4.18 (debian kernel-source pkg) and last night I 
experienced a strange failure. I'm wondering if this is somehow related to 
2.4.18 or if it was just a coincidence?

I'm running a Raid-5 array with 3 WDC 80GB drives (each on separate IDE 
busses).

hde/g are on a CMD649 based controller (on separate channels). It appears 
that a DMA timeout occurred on this device, causing a reset on both hde/g - 
fortunately one channel recovered. I had to reboot to get all drives back 
online.

So much for having devices on separate channels - looks like devices should 
be on separate controllers!

Any suggestions for preventing a recurrence? Are there known issues with 
CMD649 cards and software RAID in 2.4.18? Am I missing some patches for 
2.4.18 relating to software RAID/CMD649/IDE?

I'm hoping my move to 2.4 series wasn't a mistake - I have a lot of data on 
this array!

Appreciate any help. 

Jun 16 19:26:22 xerces kernel: hde: timeout waiting for DMA
Jun 16 19:26:22 xerces kernel: ide_dmaproc: chipset supported ide_dma_timeout 
func only: 14
Jun 16 19:26:22 xerces kernel: hde: status error: status=0x50 { DriveReady 
SeekComplete }
Jun 16 19:26:22 xerces kernel: hde: no DRQ after issuing MULTWRITE
Jun 16 19:26:22 xerces kernel: hde: status error: status=0x50 { DriveReady 
SeekComplete }
Jun 16 19:26:22 xerces kernel: hde: no DRQ after issuing MULTWRITE
Jun 16 19:26:22 xerces kernel: hdg: timeout waiting for DMA
Jun 16 19:26:22 xerces kernel: ide_dmaproc: chipset supported ide_dma_timeout 
func only: 14
Jun 16 19:26:22 xerces kernel: hdg: status error: status=0x58 { DriveReady 
SeekComplete DataRequest }
Jun 16 19:26:22 xerces kernel: hdg: drive not ready for command
Jun 16 19:26:22 xerces kernel: hdg: status timeout: status=0xd0 { Busy }
Jun 16 19:26:22 xerces kernel: hdg: drive not ready for command
Jun 16 19:26:22 xerces kernel: ide3: reset: success
Jun 16 19:26:22 xerces kernel: hde: status error: status=0x50 { DriveReady 
SeekComplete }
Jun 16 19:26:22 xerces kernel: hde: no DRQ after issuing MULTWRITE
Jun 16 19:26:22 xerces kernel: hde: status error: status=0x50 { DriveReady 
SeekComplete }
Jun 16 19:26:22 xerces kernel: hde: no DRQ after issuing WRITE
Jun 16 19:26:22 xerces kernel: ide2: reset: master: error (0x50?)
Jun 16 19:26:32 xerces kernel: hde: lost interrupt
Jun 16 19:26:42 xerces kernel: hdg: timeout waiting for DMA
Jun 16 19:26:42 xerces kernel: ide_dmaproc: chipset supported ide_dma_timeout 
func only: 14
Jun 16 19:26:42 xerces kernel: hdg: status error: status=0x58 { DriveReady 
SeekComplete DataRequest }
Jun 16 19:26:42 xerces kernel: hdg: drive not ready for command
Jun 16 19:26:42 xerces kernel: hdg: status timeout: status=0xd0 { Busy }
Jun 16 19:26:42 xerces kernel: hdg: drive not ready for command
Jun 16 19:26:42 xerces kernel: hde: lost interrupt
Jun 16 19:26:42 xerces kernel: hde: recal_intr: status=0xd0 { Busy }
Jun 16 19:26:43 xerces kernel: ide3: reset: success
Jun 16 19:26:43 xerces kernel: ide2: reset: master: error (0x50?)


--
Marc Marais
marc@liquid-nexus.net 
