From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Which drive gets read in case of inconsistency? [was: ext3 journal on software raid etc]
Date: Tue, 4 Jan 2005 13:44:55 +0100
Message-ID: <7nfqa2-3qg.ln1@news.it.uc3m.es>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es> <fh0pa2-kvp.ln1@news.it.uc3m.es> <16857.55609.534526.297577@cse.unsw.edu.au> <jh4pa2-pi.ln1@news.it.uc3m.es> <16857.64086.362458.177296@cse.unsw.edu.au> <ms4qa2-0qa.ln1@news.it.uc3m.es> <41DA84C5.3070403@tls.msk.ru>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> How it all fits together?
> Which drive will be declared "fresh"?

I'd like details of the event count too. No, I haven't been able to
figure it out from the code either. In this case "ask an author" is
indicated. :).

> How about several (>2) drives in raid1 array?
> How about data written without a concept of "commits", if "wrong"
> drive will be choosen -- will it contain some old data in it, while
> another drive contained new data but was declared "non fresh" at
> reconstruction?

To answer a question of yours which I seem to have missed quoting here,
standard softare raid only acks the user (does end_request) when ALL the
i/os corresponding to mirrored requests have finished.

This is precisely the condition Stephen wants for ext3, and it is
satisfied.  However, the last time I asked Hans Reiser what his
conditions were for reiserfs, he told me that he required write order to
be preserved, which is a different condition.  It's not precisely
stronger as it is, but it becomes precisely stronger than Stephen's when
you add in some extra "normal" hypotheses about the rest of the universe
it lives in.

However, the media underneath raid is free to lie.  In many respects, it
is likely to lie!  Hardware disks, for example, ack back the write when
they have buffered it, not when they have written it (and manufacturers
claim there is always enough capacitative energy in the disk
electrionics to get the buffer written to disk when you cut the power,
before the disk spins down - to which I say, "oh yeah?").  If there is
another software layer between you and the hardware then bets are off.

And you can also patch raid to do async writes, as I have - that is,
respond with an ack on the first component write, not the last. This
requires extra logic to account the pending list, and makes the danger
window larger than with standard raid, but it does not create it. The
bonus is halved latency.

Newer raid code attempts to solve latency on read, by the way, by always
choosing the disk to read from on which it thinks the heads are closest
to where they need to be.  That is probably a bogus calculation.

> And speaking of the previous question, is there any difference here
> between md device and single disk, which also does various write
> reordering and stuff like that?

Raid substitutes its own make_request, which does NOT do request
aggregation, as far as I can see. So it works like a single disk with
aggregation disabled. This is right, but it also wants to switch off
write aggregation on the underlying device if it can - it probably can,
by substituting its own max_whatever functions for those predicates
that calculate when to stp aggregating requests, but that would be a
layering violation.

One might request from Linus a generic way of asking a device to control
aggregation (which implies reordering).

> -- I mean, does md layer increase
> probability to see old data after reboot caused by a power loss
> (for example) if an app (or whatever) was writing (or even when
> the filesystem reported the write is complete) some new data during
> the power loss?

It does not introduce extra buffering (beyond maybe one request) except
inasmuch as it IS a buffering layer - the kernel will accumulate
requests to it, call its request function, and it will send them to the
mirror devices, where they will accumulate, until the kernel calls their
request functions ...

It might try and force processing of the mirrored requests as each is
generated. It could. I don't think it does.

Anyway, strictly speaking, the answer to your question is "yes". It
does not decrease the probability, and therefore it increases it. The
question is by how much, and that is unanswerable.

> Alot of questions.. but I think it's really worth to understand
> how it all works.

Agree.

Peter

