From: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Re: Spares and partitioning huge disks
Date: Sun, 9 Jan 2005 23:29:00 +0100
Message-ID: <20050109222900.GA12793@janus>
References: <crmt7e$8d6$1@sea.gmane.org> <200501081749.32816.maarten@ultratux.net> <20050109193353.GB9524@janus> <200501092226.25910.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200501092226.25910.maarten@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jan 09, 2005 at 10:26:25PM +0100, maarten wrote:
> On Sunday 09 January 2005 20:33, Frank van Maarseveen wrote:
> > On Sat, Jan 08, 2005 at 05:49:32PM +0100, maarten wrote:
> 
> > > However, IF during that
> > > resync one other drive has a read error, it gets kicked too and the array
> > > dies.  The chances of that happening are not very small;
> >
> > Ouch! never considered this. So, RAID5 will actually decrease reliability
> > in a significant number of cases because:
> 
> > -	>1 read errors can cause a total break-down whereas it used
> > 	to cause only a few userland I/O errors, disruptive but not foobar.
> 
> Well, yes and no.  You can decide to do a full backup in case you hadn't, 

backup (or taking snapshots) is orthogonal to this.

> prior to changing drives. And if it is _just_ a bad sector, you can 'assemble 
> --force' yielding what you would've had in a non-raid setup; some file 
> somewhere that's got corrupted. No big deal, ie. the same trouble as was 
> caused without raid-5.

I doubt that it's the same: either it wil fail totally during the
reconstruction or it might fail with a silent corruption. Silent
corruptions are a big deal.  It won't loudly fail _and_ leave the array
operational for an easy fixup later on so I think it's not the same.

> > -	disk replacement is quite risky. This is totally unexpected to me
> > 	but it should have been obvious: there's no bad block list in MD
> > 	so if we would postpone I/O errors during reconstruction then
> > 	1:	it might cause silent data corruption when I/O error
> > 		unexpectedly disappears.
> > 	2:	we might silently loose redundancy in a number of places.
> 
> Not sure if I understood all of that, but I think you're saying that md 
> _could_ disregard read errors _when_already_running_in_degraded_mode_ so as 
> to preserve the array at all cost.

We can't. Imagine a 3 disk RAID5 array, one disk being replaced. While
writing the new disk we get a single randon read error on one of the
other two disks. Ignoring that implies either:
1:	making up a phoney data block when a checksum block was hit by the error.
2:	generating a garbage checksum block.

RAID won't remember these events because there is no bad block list. Now
suppose the array is operational again and hits a read error after some
random interval. Then either it may:
1:	return corrupt data without notice.
2:	recalculate a block based on garbage.

so, we can't ignore errors during RAID5 reconstruction and we're toast
if it happens, even more toast than we would have been with a normal
disk (barring the case of an entirely dead disk). If you look at the
lower level then of course RAID5 has an advantage but to me it seems to
vaporize when exposed to the _complexity_ of handling secondary errors
during the reconstruction.

-- 
Frank
