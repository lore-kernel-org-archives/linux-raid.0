From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] md - 8 of 8 - Support reshaping raid1 arrays - adding or removing drives.
Date: Sat, 29 May 2004 08:47:10 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16567.49518.235636.692548@cse.unsw.edu.au>
References: <20040528163700.9426.patches@notabene>
	<E1BTb7N-0002U9-H3@notabene.cse.unsw.edu.au>
	<c97f1f$hmm$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mario 'BitKoenig' Holbe on Friday May 28
To: Mario 'BitKoenig' Holbe <Mario.Holbe@RZ.TU-Ilmenau.DE>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 28, Mario.Holbe@RZ.TU-Ilmenau.DE wrote:
> NeilBrown <neilb@cse.unsw.edu.au> wrote:
> > This requires allocating a new pool of "r1bio" structures which a different
> > number of bios, suspending IO, and swapping the new pool in place of the old.
> > (and a few other related changes).
> 
> Hmmm, I'm not really familiar with the md-code, but doesn't
> do memory allocation at runtime re-introduce the 2.2. swap-
> on-raid-problems?

No.

> Afair, they were due to swap out -> md driver allocates
> something -> no ram -> swap out -> md driver allocates ...
> 

This was not the problem.
When the md driver allocated memory in the write-out path it always
does it with a flag that say "don't trigger any write-out to while
trying to satisfy this request".  It also manages memory in  such a
way (using mempools) that if a memory request fails, it can just wait
for some pending requests to complete and it is certain to get some
memory soon.

Further, the "allocation a new pool" mentioned above is not in the
write-out path for raid1 so it has no bearing on these issues.

It allocates a new pool quite separately for the normally running of
raid1.  If all the needed allocations succeed, it blocks further
requests, swaps the new pool in place of the old and makes other
changes to reshape the array, and the allows further requests to
proceed.

The problem in 2.2 was only during resync.  Because of how buffers
were managed, swap could write out to a block that we in the process
of being re-synced, and the resync process would overwrite the new
swap data.  The buffer management is now completely different and this
is not a problem.

I hope this makes it a tiny bit clearer.

NeilBrown

