From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 10:38:04 +0100
Message-ID: <s0v9b2-0ir.ln1@news.it.uc3m.es>
References: <jsm9b2-iqp.ln1@news.it.uc3m.es> <200501100905.j0A95M920746@www.watkins-home.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy <bugzilla@watkins-home.com> wrote:
> Peter T. Breuer <ptb@lab.it.uc3m.es> wrote:
> > Well, here is a patch to at least stop the array (RAID 1) being failed
> > until all possible read sources have been exhausted for the sector in
> > question.  It's untested - I only checked that it compiles.
> A RAID1 array does not fail on a read error, unless the read error is on the
> only disk.

I'm sorry, I meant "degraded", not "failed", when I wrote that summary.

To clarify, the patch stops the mirror disk in question being _faulted_
out of the array when a sector read _fails_ on the disk.  The read is
instead retried on another disk (as is the case at present in the
standard code, if I recall correctly - the patch only stops the current
disk also being faulted while the retry is scheduled).

In addition I pointed to what line to comment to stop any disk being
ever faulted at all on a read error, which ("not faulting") in my
opinion is more correct.  The reasoning is that either we try all disks
and succeed on one, in which case there is nothing to mention to
anybody, or we succeed on none and there really is an error in that
position in the array, on all disks, and that's the right thing to say.

What happens on recovery is another question. There may be scattered
error blocks.

I would also like to submit a write to the dubious sectors, from the
readable disk, once we have found it. 

> Maybe you have found a bug?

There are bugs, but that is not one of them.

If you want to check the patch, check to see if schedule_retry moves
the current target of the bio to another disk in a fair way. I didn't
check.

Peter

