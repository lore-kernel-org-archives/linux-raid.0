From: Lajber Zoltan <lajbi@lajli.gau.hu>
Subject: Re: aacraid just sucks?
Date: Wed, 4 Jan 2006 01:09:11 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0601040105430.6047@lajli.gau.hu>
References: <Pine.LNX.4.44.0601031849280.14492-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0601031849280.14492-100000@coffee.psychology.mcmaster.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 3 Jan 2006, Mark Hahn wrote:

> has anyone gotten good performance from aacraid?
> if you configure, say the 21610SA controller as JBOD and use
> normal Linux MD raid, can you mitigate the pain?

I have an ibm xseries 206 with aacraid:
0000:03:02.0 RAID bus controller: Adaptec AAC-RAID (rev 01)
000:00:00.0 Host bridge: Intel Corp. 82875P Memory Controller Hub (rev 02)
0000:00:03.0 PCI bridge: Intel Corp. 82875P Processor to PCI to CSA Bridge
(rev 02)
0000:00:1c.0 PCI bridge: Intel Corp. 6300ESB 64-bit PCI-X Bridge (rev 02)

To be more verbose:
0000:03:02.0 RAID bus controller: Adaptec AAC-RAID (rev 01)
        Subsystem: Adaptec AAR-2410SA PCI SATA 4ch (Jaguar II)
        Flags: bus master, fast Back2Back, 66MHz, slow devsel, latency 32,
IRQ 16
        Memory at d4000000 (32-bit, prefetchable) [size=64M]
        Expansion ROM at 80100000 [disabled] [size=32K]
        Capabilities: [80] Power Management version 2


With bonnie++ I can write 36M/sec, read	 59M/sec. I have four disks on it,
but _software_ raid1 with kernel.org 2.6.13.4 kernel.

Bye,
-=Lajbi=----------------------------------------------------------------
 LAJBER Zoltan               Szent Istvan Egyetem,  Informatika Hivatal
 Most of the time, if you think you are in trouble, crank that throttle!
