From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard)
Date: Sun, 2 Jan 2005 21:18:13 +0100
Message-ID: <5h1ma2-asq.ln1@news.it.uc3m.es>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es> <41D45C1F.5030307@tls.msk.ru> <u59ea2-4qr.ln1@news.it.uc3m.es> <20050102194240.GE99565@caffreys.strugglers.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andy Smith <andy@strugglers.net> wrote:
> [-- text/plain, encoding quoted-printable, charset: us-ascii, 22 lines --]
> 
> On Thu, Dec 30, 2004 at 10:39:42PM +0100, Peter T. Breuer wrote:
> > In gmane.linux.raid Michael Tokarev <mjt@tls.msk.ru> wrote:
> > > Peter T. Breuer wrote:
> > > > In gmane.linux.raid Georg C. F. Greve <greve@fsfeurope.org> wrote:
> > > > 
> > > > Yes, well, don't put the journal on the raid partition. Put it
> > > > elsewhere (anyway, journalling and raid do not mix, as write ordering
> > > > is not - deliberately - preserved in raid, as far as I can tell).
> > > 
> > > This is a sort of a nonsense, really.  Both claims, it seems.
> > 
> > It's perfectly correct, as far as I know!
> 
> Not really wishing to get into the middle of a flame war, but I
> didn't really see how this could be true so I asked for more info on
> ext3-users.
> 
> I got the following response:
> 
> https://listman.redhat.com/archives/ext3-users/2005-January/msg00003.html

Interesting - I'll post it (there is no flame war):

>     * From: "Stephen C. Tweedie" <sct redhat com>
>     * To: Andy Smith <andy lug org uk>
>     * Cc: Stephen Tweedie <sct redhat com>, ext3 users list <ext3-users
>     * redhat com>
>     * Subject: Re: ext3 journal on software raid
>     * Date: Sat, 01 Jan 2005 22:19:23 +0000

(snip)

> Disks and IO subsystems in general don't preserve IO ordering. 

This is true.

> ext3 is
> designed not to care.

That is surprising - write-order preservation is precisely the
condition that reiserfs requires for correct journal behaviour, and
Hans Reiser tld be so himself (sometime, some reiserfs mailing list, at
the time, etc).

It would be surprising if Stephen managed to do without it, but his
condition is definitely weaker.  He merely requires to be _told_
(synchronously) when each i/o has ended, in the order that it ends, I
think is what he says below.

I'm not sure that raid can guarrantee precisely that either.  There
might be minor disorderings on a SMP system with preemption, if for
example, one request is handled on one cpu and another on another, and
the acks are handled crosswise.  There might be a small temporal
displacement.  I haven't thought about it.

What I can say is that it makes no _attempt_ to respect that condition.
Whether it does or not I cannot exactly say.

> As long as the raid device tells the truth about
> when the data is actually committed to disk (all of the mirror volumes
> are uptodate) for a given IO, ext3 should be quite happy.

Uuff .. as I said, it is not quite clear to me that this (very weak)
condition is absolutely respected. Umm ... no, endio for the whole
request is sent back AFTER the mirror i/os have completed, but exactly
WHEN after is indeterminate on a preemptive (SMP) system. The mirrors
might have been factually updated for two requests in temporal order A
B, but might report endio in order B A. However, I think that he
probably is calling A then B in a single thread, which means that
B won't even be generated until A is acked.

OK - I think Stephen is probably saying that the ack must be sent back
AFTER the status of the writes on the mirror disks is known.

Yes, that is guarranteed (unless you apply an async raid patch ...).

> > What's wrong is that the journal will be mirrored (if it's a mirror).
> > That means that (1) its data will be written twice, which is a big deal
> > since ALL the i/o goes through the journal first
> 
> Not true; by default, only metadata goes through the journal, not data.

He is saying that data is not journalled by default on ext3.  I don't
see that as a comment about raid, and inasmuch as it means anything it
means that his comment "not true" is about as close to a rather strange
(political?) untruth as you can get in CS, since all the journal's data
WILL be written twice - it's up to you how much that is.  Whether you
pass the data through the journal or not, all the data you choose to
pass will be written twice, be it zero, some, or all. 

> 
> > and (2) the journal
> > is likely to be inconsistent (since it is so active) if you get one of
> > those creeping invisible RAID corruptions that can crop up inevitably
> > in RAID normal use.
> 
> Umm, if soft raid is expected to have silent invisible corruptions in
> normal use,

It is, just as is all types of RAID.  This is a very strange thing for
Stephen to say - I cannot believe that he is as naive as he makes
himself out to be about RAID here and I don't know why he should say
that (presuming that he really knows better).

> then you shouldn't be using it, period.  That's got zero to
> do with journaling.

It implies that one should not be doing journalling on top of it.

(The logic for why RAID corrupts silently is that errors accumulate at
n times the normal rate per sector, but none of them are detected by
RAID (no crc), and when a disk drops out then you get a good chance of
picking up a corrupted copy instead of a good copy, because nobody
has checked the copy meanwhiles to see if it matches the original).


Peter

