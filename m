From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 - which disk failed ?
Date: Mon, 24 Sep 2007 12:44:23 +1000
Message-ID: <18167.9351.878707.227090@notabene.brown>
References: <1314153413.20070924011710@kaneda.iguw.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rainer Fuegenstein on Monday September 24
Sender: linux-raid-owner@vger.kernel.org
To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday September 24, rfu@kaneda.iguw.tuwien.ac.at wrote:
> 
> Hi,
> 
> I'm using a raid 5 with 4*400 GB PATA disks on a rather old VIA
> mainboard, running centos 5.0. a few days ago the server started to
> reboot or freeze occasionally, after reboot md always starts a resync
> of the raid:
> $ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 hdh1[3] hdg1[2] hdf1[1] hde1[0]
>       1172126208 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
>       [>....................]  resync =  0.9% (3819132/390708736) finish=366.2min speed=17603K/sec

This is normal.  If there was any write activity in the few hundred
milliseconds before a crash, you need to resync because the parity of
the stripe being written could not incorrect.

> 
> after about an hour, the server freezes again. I figured out that
> about this time the following errors are reported in the messages log:
> 
> Sep 23 22:23:05 alfred kernel: end_request: I/O error, dev hde, sector 254106007
> Sep 23 22:23:09 alfred kernel: hde: dma_intr: status=0x51 { DriveReady SeekComplete Error }
> Sep 23 22:23:09 alfred kernel: hde: dma_intr: error=0x40 { UncorrectableError }, LBAsect=254106015, high=15, low=2447775, sector=254106015
> Sep 23 22:23:09 alfred kernel: end_request: I/O error, dev hde, sector 254106015
> Sep 23 22:23:14 alfred kernel: hde: dma_intr: status=0x51 { DriveReady SeekComplete Error }
> Sep 23 22:23:14 alfred kernel: hde: dma_intr: error=0x40 { UncorrectableError }, LBAsect=254106023, high=15, low=2447783, sector=254106023
> Sep 23 22:23:14 alfred kernel: end_request: I/O error, dev hde, sector 254106023
> Sep 23 22:23:18 alfred kernel: hde: dma_intr: status=0x51 { DriveReady SeekComplete Error }
> Sep 23 22:23:18 alfred kernel: hde: dma_intr: error=0x40 { UncorrectableError }, LBAsect=254106031, high=15, low=2447791, sector=254106031
> Sep 23 22:23:18 alfred kernel: end_request: I/O error, dev hde, sector 254106031
> Sep 23 22:23:23 alfred kernel: hde: dma_intr: status=0x51 { DriveReady SeekComplete Error }
> Sep 23 22:23:23 alfred kernel: hde: dma_intr: error=0x40 { UncorrectableError }, LBAsect=254106039, high=15, low=2447799, sector=254106039
> Sep 23 22:23:23 alfred kernel: end_request: I/O error, dev hde, sector 254106039
> Sep 23 22:23:43 alfred kernel: hde: dma_timer_expiry: dma status == 0x21
> Sep 23 22:23:53 alfred kernel: hde: DMA timeout error
> Sep 23 22:23:53 alfred kernel: hde: dma timeout error: status=0x58 { DriveReady SeekComplete DataRequest }
> Sep 23 22:28:40 alfred kernel:     ide2: BM-DMA at 0x7800-0x7807, BIOS settings: hde:DMA, hdf:pio

Something definitely sick there.

> 
> now there are two things that puzzle me:
> 
> 1) when md starts a resync of the array, shouldn't one drive be marked
> as down [_UUU] in mdstat instead of reporting it as [UUUU] ? or, the
> other way round: is hde really the faulty drive ? how can I make sure
> I'm removing and replacing the proper drive ?

When a drive fail, md records that failure in the metadata on the
other devices in the array.
The fact that the drive is not marked as failed after the reboot
suggests that md failed to update the metadata of the good drives.
Maybe it is the controller that is failing rather than a drive, and it
cannot write to anything at this point.
Or maybe the drive is failing, but that is badly confusing the
controller, with the same result.
Is it always hde that is reporting errors?

With PATA, it is fairly easy to make sure you have removed the correct
drive, and names don't change.  hde is the 'master' on the 3rd
channel.  Presumably the first channel of your controller card.

Just disconnect the drive you think it is, reboot, and see if hde is
still there.

> 
> 2) can a faulty drive in a raid5 really crash the whole server ? maybe
> it's because of the bug in the onboard promise controller that adds to
> this problem (see attachment for dmesg output).

No, a faulty drive in a raid5 should not crash the whole server.  But
a bad controller card or buggy driver for the controller could.

NeilBrown
