From: maarten <maarten@ultratux.net>
Subject: Re: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 00:16:58 +0100
Message-ID: <200501100016.58847.maarten@ultratux.net>
References: <crmt7e$8d6$1@sea.gmane.org> <200501092226.25910.maarten@ultratux.net> <20050109222900.GA12793@janus>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050109222900.GA12793@janus>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 09 January 2005 23:29, Frank van Maarseveen wrote:
> On Sun, Jan 09, 2005 at 10:26:25PM +0100, maarten wrote:
> > On Sunday 09 January 2005 20:33, Frank van Maarseveen wrote:
> > > On Sat, Jan 08, 2005 at 05:49:32PM +0100, maarten wrote:

> > Well, yes and no.  You can decide to do a full backup in case you hadn't,
>
> backup (or taking snapshots) is orthogonal to this.

Hm.  Okay, you're right.  

> > prior to changing drives. And if it is _just_ a bad sector, you can
> > 'assemble --force' yielding what you would've had in a non-raid setup;
> > some file somewhere that's got corrupted. No big deal, ie. the same
> > trouble as was caused without raid-5.
>
> I doubt that it's the same: either it wil fail totally during the
> reconstruction or it might fail with a silent corruption. Silent
> corruptions are a big deal.  It won't loudly fail _and_ leave the array
> operational for an easy fixup later on so I think it's not the same.

I either don't understand this, or I don't agree. Assemble --force effectively 
disables all sanitychecks, so it just can't "fail" that.  The result is 
therefore an array that either (A) holds a good FS with a couple of corrupted 
files (silent corruption) or (B) a filesystem that needs [metadata] fixing, 
or (C) one big mess that hardly resembles a FS. 
It stands to reason that in case (C) you either made a user error assembling 
the wrong parts or what you had wasn't a bad sector error in the first place 
but media failure or another type of disastrous corruption. 

I've been there. I suffered through a raid-5 two-disk failure, and I've got 
all of my data back eventually, even if some silent corruptions have happened 
(though I did not notice it, but that's no wonder with 500.000+ files)
It is ugly, and the last resort, but that doesn't mean it can't work.

> > > -	disk replacement is quite risky. This is totally unexpected to me
> > > 	but it should have been obvious: there's no bad block list in MD
> > > 	so if we would postpone I/O errors during reconstruction then
> > > 	1:	it might cause silent data corruption when I/O error
> > > 		unexpectedly disappears.
> > > 	2:	we might silently loose redundancy in a number of places.
> >
> > Not sure if I understood all of that, but I think you're saying that md
> > _could_ disregard read errors _when_already_running_in_degraded_mode_ so
> > as to preserve the array at all cost.
>
> We can't. Imagine a 3 disk RAID5 array, one disk being replaced. While
> writing the new disk we get a single randon read error on one of the
> other two disks. Ignoring that implies either:
> 1:	making up a phoney data block when a checksum block was hit by the
> error. 2:	generating a garbage checksum block.

Well, yes.  But some people -when confronted with the choice between losing 
everything or having silent corruptions- will happily accept the latter.  At 
least you could try to find the bad file(s) by md5sum, whereas in the total 
failure scenario you're left with nothing.
Of course that choice depends on how good and recent your backups are.

For my scenario, I wholly depend on md raid to preserve my files; I will not 
and cannot start backing up TV shows to DLT tape or something.  That is a 
no-no economically.  There is just no way to backup 700GB data in a home user 
environment, unless you want to spend a full week to burn it onto 170 DVDs.
(Or buy twice the amount of disks and leave them locked in a safe)

So I certainly would opt for the "possibility of silent corruption" choice. 
And if I ever find the corrupted file I delete it and mark it for 'new 
retrieval" or some such followup.  Or restore from tape where applicable.

> RAID won't remember these events because there is no bad block list. Now
> suppose the array is operational again and hits a read error after some
> random interval. Then either it may:
> 1:	return corrupt data without notice.
> 2:	recalculate a block based on garbage.

Definitely true, but we're still talking about errors on a single block, or a 
couple of blocks at most.  The other 1000.000+ blocks are still okay.
Again, it all depends on your circumstances what is worse: losing all the 
files including the good ones, or having silent corruptions somewhere.

> so, we can't ignore errors during RAID5 reconstruction and we're toast
> if it happens, even more toast than we would have been with a normal
> disk (barring the case of an entirely dead disk). If you look at the
> lower level then of course RAID5 has an advantage but to me it seems to
> vaporize when exposed to the _complexity_ of handling secondary errors
> during the reconstruction.

You cut out my entire idea about leaving the 'failed' disk around to 
eventually being able to compensate a further block error on another media.  
Why ?  It would _solve_ your problem, wouldn't it ?

Maarten


