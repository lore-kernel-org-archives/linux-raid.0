From: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Subject: Re: /dev/md2 stopped after changing SAS controller
Date: Sat, 14 May 2011 10:21:59 +0200
Message-ID: <20110514082159.GA306@apartia.fr>
References: <20110513202900.GA1926@apartia.fr>
 <20110514073347.15dae0b8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110514073347.15dae0b8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 14, 2011 at 07:33:47AM +1000, NeilBrown wrote:
> On Fri, 13 May 2011 22:29:01 +0200 Louis-David Mitterrand
> <vindex+lists-linux-raid@apartia.org> wrote:
> > Each disk is configured thus:
> > 
> > 	Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
> > 	255 heads, 63 sectors/track, 121601 cylinders
> > 	Units = cylinders of 16065 * 512 = 8225280 bytes
> > 	Sector size (logical/physical): 512 bytes / 512 bytes
> > 	I/O size (minimum/optimal): 512 bytes / 512 bytes
> > 	Disk identifier: 0x05022e04
> > 
> > 	   Device Boot      Start         End      Blocks   Id  System
> > 	/dev/sda1               1          32      257008+  fd  Linux raid autodetect
> > 	/dev/sda2              33       17500   140311710   fd  Linux raid autodetect
> > 	/dev/sda3           17501      121601   836191282+  fd  Linux raid autodetect
> > 
> 
> Is this the config reported with the old controller or with the new
> controller?

Sorry for the confusion, the above was with the old (LSI) controller.
This is the disk geometry with the new (Adaptec) controller:

	Disk /dev/sda: 1000.1 GB, 1000104157184 bytes
	255 heads, 63 sectors/track, 121589 cylinders
	Units = cylinders of 16065 * 512 = 8225280 bytes
	Sector size (logical/physical): 512 bytes / 512 bytes
	I/O size (minimum/optimal): 512 bytes / 512 bytes
	Disk identifier: 0x6397e8f6

	   Device Boot      Start         End      Blocks   Id  System
	/dev/sda1               1          32      257008+  fd  Linux raid autodetect
	/dev/sda2              33       17500   140311710   fd  Linux raid autodetect
	/dev/sda3           17501      121601   836191282+  fd  Linux raid autodetect

Ah! 121589 vs 121601 cylinders...

> Because my guess is that the new controller makes the devices look a little
> bit smaller.  That would cause the kernel to reject them, but quite possibly
> allow mdadm to think they look OK.
> 
> It would also explain why the first 2 partitions work fine and only the last
> one is a problem.
> 
> If this were the case I would expect a message like:
>          "%s: p%d size %llu extends beyond EOD

Spot on:

	May 14 10:15:46 zenon kernel: sda: p3 size 1672382565 extends beyond EOD, trunca
ted

Is there any solution other than backuping my /dev/md2 somewhere with
the old controller and re-creating a (slightly) smaller one with the new
controller?

Thanks,
