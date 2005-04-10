From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: RAID1 and data safety?
Date: Sun, 10 Apr 2005 19:54:31 +0200
Message-ID: <nr5oi2-o3k.ln1@news.it.uc3m.es>
References: <76592C4D3DA1AC4FB8424084D10D31A8061152B0@mchh2c4e.mchh.siemens.de> <1112889935.7025.17.camel@compaq-rhel4.xsintricity.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford <dledford@xsintricity.com> wrote:
> > > Now, if I recall correctly, Peter posted a patch that changed this
> > > semantic in the raid1 code.  The raid1 code does not complete a write to
> > > the upper layers of the kernel until it's been completed on all devices
> > > and his patch made it such that as soon as it hit 1 device it returned
> > > the write to the upper layers of the kernel.
> > 
> > I am glad to hear, that the behaviour is such, that the barrier stops, until 
> > *all* media got written. That was one of the things that really made me 
> > worrying. I hope, the patch is backed out and didn't went into any distros.
> 
> No it never went anywhere.  It was just a "Hey guys, I played with this
> optimization, here's the patch" type posting and no one picked it up for
> inclusion in any upstream or distro kernels.

I'll just remark that the patch depended on a bitmap, so it _couldn't_
have been picked up (until now?).

And anyway, async writes (that's the name) were switched on by a module
/kernel parameter, and were off by default.

I suppose maybe Paul's 2.6 patches also offer the possibility of async
writes (I haven't checked).

It isn't very dangerous - the bitmap marks the write as not done until
all the components have been written, even though the write is acked
back to the kernel after the first of the components have been written.

There are extra openings for data loss if you choose that mode, but
they're relatively improbable.  You're likely to lose data under several
circumstances during normal raid1 operation (see for example the "split
brain" discussion!).  Choosing to decrease write latency by half against
some minor extra opportunity for data loss is an admin decision that
should be available to you, I think.

Umm ... what's the extra vulnerability? Well, I suppose that with ONE
bitmap, writes could be somewhat delayed to TWO DIFFERENT components in
turn.  Then if we lose the array node at that point, writes will be
outstanding to both components, and when we resync neither will have
perfect data to copy back over the other.  And we won't even be able to
know which was right, because of the single bitmap.

Shrug. We probably wouldn't have known which mirror component was the
good one in any case.

But with TWO bitmaps, we'd know which components were lacking what, and
we could maybe do a better recovery job. Or not. We'd always choose one
component to copy from, and that would overwrite the right data that
the other had.

Even with sync (not async) writes, we could get an array node crash
that left BOTH components of the mirror without some info that the other
component already had had written to it, and then copying from either
component over the other would lose data. Yer pays yer money and yer
takes yer choice.

So I don't see it as a big thing. It's a question of evaluating
probabilities, and benefits.


BTW - async writes without the presence of a bitmap also seems to me to
be a valid admin choice. Surely if a single component dies, and the
array stays up, everything will be fine. The problem is when the array
node crashes on its own. And that may cause data loss anyway.

Peter

