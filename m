From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Why does one get mismatches?
Date: Fri, 19 Feb 2010 23:37:36 +0100
Message-ID: <20100219223736.GA2381@lazy.lzy>
References: <4B67451F.8040206@tmr.com>
 <20100202093738.44b4fece@notabene.brown>
 <4B684087.50001@tmr.com>
 <20100211161444.7a0ea7bb@notabene.brown>
 <20100211175133.GA30187@atlantis.cc.ndsu.nodak.edu>
 <4B7B0D45.7040801@tmr.com>
 <6db64f7872286165ac1fd3436e9d6476@localhost>
 <20100218100547.7aecdc34@notabene.brown>
 <20100219151809.GB4995@lazy.lzy>
 <20100220090208.06c1130f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100220090208.06c1130f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, Steven Haigh <netwiz@crc.id.au>, Bill Davidsen <davidsen@tmr.com>, Bryan Mesich <bryan.mesich@ndsu.edu>, Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> > Or it is like that because we trust the filesystem?
> 
> It is because we trust the filesystem.

well, I hope the trust is not misplaced... :-)

> md is not in a position to lock the page - there is simply no way it can stop
> the filesystem from changing it.

How can this be?

> The only thing it could do would be to make a copy, then write the copy out.

Even making a copy would not be safe, since during
the copy the data could still change, or not?

> This would incur a performance cost.

It's a matter of deciding what is more important.

> > It seems to me, maybe I'm wrong, not a so safe design.
> 
> I think you are wrong.

Could be, I never heard of situations like this.
 
> > I assume, it should not be possible to cause this
> > situation, unless there is a crash or a bug in the
> > md layer.
> 
> I'm not sure what situation you are referring to...

It should not be possible to cause that different
mirrors of a RAID-1 end up with different data.

Otherwise, no point to have the mirroring.
 
> > What if a new filesystem will write a block, changing
> > on the fly, i.e. during RAID-1 writes, and then, later,
> > reading this block again?
> > 
> > It will get, maybe, not the correct data.
> 
> This is correct.  However it would be equally correct if you were talking
> about s normal disk drive rather than a RAID1 pair.

Nono, there is a huge difference.
In a single drive case, the FS is responsible of writing
rubbish to a single block. The result would be that a
block has "strange" data, but *always* the same data.

Here the situation is that the data might be "strange",
but different accesses, to the same block of the RAID-1,
could potentially return different data.

As a byproduct of this effect, the "check" functionality
becomes not so useful anymore.

> If the filesystem changes the page (or allows it to change) while a write is
> pending, then it cannot know what actual data was written.  So it must write
> the block out again before it ever reads it in.
> RAID1 is no different to any other device in this respect.

Is different, as mentioned above.

The FS could, intentionally, change the data during a write,
but later it could expect to have always the same data.

In other words, the FS does not guarantee the "spatial"
consistency of the data (the bytes in a block), but the
"temporal" consistency (successive reads return always
the same data) could be expected. And this happens in
case of a normal HDD. It does not happen in RAID-1.

> Possibly, but at what cost?

As I wrote: it is matter to decide what is more important
and useful.

> There are two ways that I can imagine to 'solve' this issue.
> 
> 1/ always copy the page before writing.  This would incur a significant
>   overhead, both in the complexity of pre-allocation memory and in the
>   delay taken to perform the copy.  And it would very rarely be actually
>   needed.

Does really a copy solve the issue? Is the copy done
in atomic way?
The pre-allocation does not seem to me to be a problem,
since it will be done once and for all (at device creation),
and not dynamically.
The copy *might* be an overhead, nevertheless I wonder if it
is really so much of a problem, expecially considering that,
after the copy, the MD layer can optimize the transaction
to the HDDs as much as it likes.

> 2/ Have the filesystem protect the page from changes while it is being
>    written.  This is quite possible for the filesystem to do (while it
>    is impossible for md to do).  There could be some performance

I'm really curious to understand what kind of thinking
is behind a design allowing such a situation...
I mean *system* design, not md design.

>    cost with memory-mapped pages as they would need to be unmapped,
>    but there would be no significant cost for reads, writes, and filesystem
>    metadata operations.
>    Further, any filesystem that wants to make use of the integrity checks
>    that newer drives provide (where the filesystem provides a 'checksum' for
>    the block which gets passed all the way down and written to storage, and
>    returned on a read) will need to do this anyway.  So it is likely the in
>    the near future all significant filesystems will provide all the
>    guarantees md needs or order to simply do nothing different.

That's good to know.
 
> So my feeling is that md is doing the best thing already.

I do not think this is an md issue, per se, it seems to me,
from the description, this is a overall design issue.

Normally, also for performance reasons, one approach is
to allocate queue(s) of buffers between two modules (like
FS and MD) and each of the modules has always *exclusive*
access to its own buffer(s), i.e. the buffer(s) it holds
in a certain time frame.
Once a module releases the buffer(s) this/these cannot be
anymore touched (read or write) by the module itself.
Once the buffer(s) arrive(s) to the other module, this
can do whatever it wants with it/them, and it is sure
it has exclusive access to it/them.

Normally real-time systems use techniques like this to
guarantee consistency *and* performances.

Anyway, thanks for the clarifications,

bye,

-- 

piergiorgio
