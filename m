From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Fast (intelligent) raid1
Date: Mon, 17 Feb 2003 14:17:01 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302171317.h1HDH1J20820@oboe.it.uc3m.es>
References: <15952.20989.131713.951636@notabene.cse.unsw.edu.au>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15952.20989.131713.951636@notabene.cse.unsw.edu.au> from Neil Brown
 at "Feb 17, 2003 02:07:41 pm"
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: ptb@it.uc3m.es, Ross Vandegrift <ross@willow.seitz.com>, Ingo Molnar <mingo@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

"A month of sundays ago Neil Brown wrote:"
> Rather than having several bitmaps, have just one.  Normally it is
> full of zero and isn't touched.

I'm having a little trouble interpreting your suggestion, so I'll work
through it here, and you can maybe correct my understanding.

In the first place, I can say that having ONE bitmap per raid composite
device is OK with me and probably is a worthwhile simplification over
having ONE per mirror component, since the normal case will be a two
component mirror and a mark on the bitmap will indicate unambiguously
where the fault is if the mirror is operational at all.

Or will it .. while the mirror is resyncing there may be a doubt. But
then it's currently subject to some imprecisions at that stage, since
a fault from a normal write while a resync is going on will be marked
but the mark will be lost when the bitmap is cleared at the end of the
resync (this is a bug - I'm not sure how the raid code itself reacts
in this situation since there are races here).

Nevertheless the principle is sound. The mark on the bitmap need only
indicate "something may be wrong", not precisely what is wrong. More
precision implies more efficiency at resync time, but it's a tradeoff.

> When a write fails, or when a write is sent to some-but-not-all
> devices, set the relevant bit in the bitmap.

This is what is currently done, I believe, subject to my correct
implementation of the code, and correct understanding of the extant
source. Except that presently it's done per component instead of per
array.

I'm not too sure what whole-array structure to attach the bitmap to.
Suggestions welcome.

> The first time you set a bit, record the current 'event' number with
> the bitmap.

Let me clarify here that you are talking of a counter that is
incremented once per request received on the device, and which is
written to the superblock of all the mirror components at the point when
the global bitmap is first dirtied after previously having been clean.

I'd observe that we dirty the bitmap because a component has just
dropped out/failed, and so the register of that counter on the failed
component will stay at zero (or whatever it was), since we can/should no
longer write to it.

It is not quite clear to me if we should write the counter to a device
which is removed while up to date. Let's see ...

> The interpretation of this bit map is 'only the blocks that are
> flagged in this bitmap have changed since event X'.

This is fine by me.


> On hot-add, read the old superblock.  If it looks valid and matches
> the current array, and has an event counter of X or more, then ignore
> blocks that have [not got] their bits set in the bitmap [when]
> reconstructing, otherwise do a full reconstruction.

I have trouble understanding the implications here.  See items in
square brackets also for possible typos that I've "corrected".

Normally a disk will drop out with the counter set at zero on the disk
component involved, and the inmemory counter actually at X, but it would
not have been possible to write the counter to the sb of the component
since we find out that we should have written it only after it's dead...
So it will come back with its counter still set to zero.  So when it
comes back its counter will NOT be set at "X or more", so we "do a full
reconstruction".

This obviously is not the intention.

I believe that possibly that we should note the value of the counter
X when we last wrote it successfully to all the disks inkernel. This
is a "checkpoint". We can update the checkpoint on all disks (and in
kernel) from time to time, I think.  If the bitmap is dirtied, then it
will have been dirtied since the checkpoint was written in kernel AND on
disk.  This is one invariant.  

When a disk comes back without a replacement having been used in the
meantime, its checkpoint on its sb will match the checkpoint in
kernel, and we can update only the blocks signalled as dirty in the
bitmap.

When a disk comes back after a replacement has been used meantime, then
the checkpoint in the kernel will have advanced (umm, we have to
advance it by one at least on the first write after a hotadd, or do we
have a problem when a faulty disk is introduced as a replacement?)
beyond that on the disk, and we will know that we have to do a full
resync on the component.

> When we have a full compliment of devices again, clear the bitmap and
> the event record.

Not sure about that. It would lead to confusion when a replacement disk
was used with an old checkpoint value. I don't think one can ever 
reset the event counter safely, which means that it needs a generation
counter too.

> The advantages of this include:
>   - only need one bitmap

Agreed.


>   - don't need the hot_repair concept - what we have is more general.

Not sure.

>   - don't need to update the bitmap (which would have to be a
>     bus-locked operation) on every write.

Hmm .. one only updates the bitmap when there is a faulted disk
component, more or less. And I'm not quite sure what "bus-locked" means
.. you mean that the order wrt bus operations must be strictly
preserved? Is that necessary? It's not clear to me.

> Disadvantages:
>   - if two devices fail, will resync some blocks on the later one that
>     don't require it.

Doesn't matter. There are other race conditions which are possibly
worse karma.

> As for ths other bits about a block device 'fixing itself' - I think
> that belongs in user-space.  Have some program monitoring things and
> re-adding the device to the array when it appears to be working again.

I don't agree - programs are simply not reliable enough and users are
not reliable enough to install and configure them.  This can be done in
about 10 lines of kernel code or less, I believe.  1) notify the new
component in which array it is now with a generic ioctl after a hotadd,
2) let the component do a hotadd ioctl through the blkops array and
our struct when it comes back online, if it feels like it.

Thanks for the comments .. let me know if I've misinterpreted
something.

Peter
