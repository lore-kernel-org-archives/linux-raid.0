From: NeilBrown <neilb@suse.de>
Subject: Re: /dev/md2 stopped after changing SAS controller
Date: Sat, 14 May 2011 21:58:21 +1000
Message-ID: <20110514215821.58f49455@notabene.brown>
References: <20110513202900.GA1926@apartia.fr>
	<20110514073347.15dae0b8@notabene.brown>
	<20110514082159.GA306@apartia.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110514082159.GA306@apartia.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Louis-David Mitterrand <vindex+lists-linux-raid@apartia.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 14 May 2011 10:21:59 +0200 Louis-David Mitterrand
<vindex+lists-linux-raid@apartia.org> wrote:

> On Sat, May 14, 2011 at 07:33:47AM +1000, NeilBrown wrote:
> > On Fri, 13 May 2011 22:29:01 +0200 Louis-David Mitterrand
> > <vindex+lists-linux-raid@apartia.org> wrote:
> > > Each disk is configured thus:
> > > 
> > > 	Disk /dev/sda: 1000.2 GB, 1000204886016 bytes
> > > 	255 heads, 63 sectors/track, 121601 cylinders
> > > 	Units = cylinders of 16065 * 512 = 8225280 bytes
> > > 	Sector size (logical/physical): 512 bytes / 512 bytes
> > > 	I/O size (minimum/optimal): 512 bytes / 512 bytes
> > > 	Disk identifier: 0x05022e04
> > > 
> > > 	   Device Boot      Start         End      Blocks   Id  System
> > > 	/dev/sda1               1          32      257008+  fd  Linux raid autodetect
> > > 	/dev/sda2              33       17500   140311710   fd  Linux raid autodetect
> > > 	/dev/sda3           17501      121601   836191282+  fd  Linux raid autodetect
> > > 
> > 
> > Is this the config reported with the old controller or with the new
> > controller?
> 
> Sorry for the confusion, the above was with the old (LSI) controller.
> This is the disk geometry with the new (Adaptec) controller:
> 
> 	Disk /dev/sda: 1000.1 GB, 1000104157184 bytes
> 	255 heads, 63 sectors/track, 121589 cylinders
> 	Units = cylinders of 16065 * 512 = 8225280 bytes
> 	Sector size (logical/physical): 512 bytes / 512 bytes
> 	I/O size (minimum/optimal): 512 bytes / 512 bytes
> 	Disk identifier: 0x6397e8f6
> 
> 	   Device Boot      Start         End      Blocks   Id  System
> 	/dev/sda1               1          32      257008+  fd  Linux raid autodetect
> 	/dev/sda2              33       17500   140311710   fd  Linux raid autodetect
> 	/dev/sda3           17501      121601   836191282+  fd  Linux raid autodetect
> 
> Ah! 121589 vs 121601 cylinders...
> 
> > Because my guess is that the new controller makes the devices look a little
> > bit smaller.  That would cause the kernel to reject them, but quite possibly
> > allow mdadm to think they look OK.
> > 
> > It would also explain why the first 2 partitions work fine and only the last
> > one is a problem.
> > 
> > If this were the case I would expect a message like:
> >          "%s: p%d size %llu extends beyond EOD
> 
> Spot on:
> 
> 	May 14 10:15:46 zenon kernel: sda: p3 size 1672382565 extends beyond EOD, trunca
> ted
> 
> Is there any solution other than backuping my /dev/md2 somewhere with
> the old controller and re-creating a (slightly) smaller one with the new
> controller?

If the filesystem is ext3, then with the old controller you could
resize2fs the filesystem to be several megabytes smaller - aim to over-shrink
rather than under-shrink.  Say 2 Meg per devices, so 12Mmeg ... so maybe
20Meg for safety... or even double that again.

Then use mdadm to make the  array smaller (mdadm --grow --size=whatever).
Then 'fsck -f' the filesystem to make sure it is still OK.  If you messed up
you can still make the size bigger again with mdadm.  The 'size' is the
per-device size, so 1/6 of the array size, but a multiple of the chunk size.

Then switch back to the new controller and assemble with --update=devicesize
so:
   mdadm -A /dev/md2 --update=devicesize /dev/sd[abcdefg]3

and it should all work.

If you don't have ext3, then you probably need to backup and restore - I
don't think other filesystems support shrinking, but I could be wrong.

NeilBrown
