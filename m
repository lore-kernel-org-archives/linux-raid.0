From: Morten Sylvest Olsen <mso@medical-insight.com>
Subject: Re: Which drive gets read in case of inconsistency? [was: ext3
 journal on software raid etc]
Date: Tue, 4 Jan 2005 13:40:33 +0100 (CET)
Message-ID: <20050104131249.O56643@arsenium.medical-insight.com>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <l1nna2-e9i.ln1@news.it.uc3m.es>
 <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net>
 <a9noa2-o12.ln1@news.it.uc3m.es> <fh0pa2-kvp.ln1@news.it.uc3m.es>
 <16857.55609.534526.297577@cse.unsw.edu.au> <jh4pa2-pi.ln1@news.it.uc3m.es>
 <16857.64086.362458.177296@cse.unsw.edu.au> <ms4qa2-0qa.ln1@news.it.uc3m.es>
 <41DA84C5.3070403@tls.msk.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41DA84C5.3070403@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Yes, this is the most dark corner in whole raid stuff for me still.
> I just looked at the code again, re-read it several times, but the
> code is a bit.. large to understand in a relatively short time.  This
> very question bothered me for quite some time now.  How md code "knows"
> which drive has "more recent" data on it in case of system crash (power
> loss, whatever) after one drive has completed the write but before
> another hasn't?  The "event counter" isn't updated on every write
> (it'd be very expensive in both time and disk health -- too much
> seeking and too much writes to a single block where the superblock
> is located).
>
> For me, and I'm just thinking how it can be done, the only possible
> solution in this case is to choose "random" drive and declare it as
> "up-to-date" -- it will not necessary be really up-to-date.  Or,
> maybe, write to "first" drive first and to "second" next, and assume
> first drive have the data written before second (no guarantee here
> because of reordering, differences in drive speed etc, but it is --
> sort of -- valid assumption).

Funny, I've been thinking alot about this lately, because I use RAID in
strange setup with failover (admittedly a stupid setup, I did not know any
better). I've have only been looking at scenarios for RAID-1. I can't
even begin to think about what might happen with RAID-5. But as the RAID
howto says, RAID does not protect you from power failures and the like,
and you should have an UPS.

The md layer will not acknowledge a write before it has been written to
all disks. I have not checked this, but the raid developers are smart
people, and otherwise I would loose my sanity. IMHO this means that it
doesn't really matter which disk is chosen as the one to synchronize from
after restarting. This means that data in files written to
during the failure might be corrupted, but metadata should be correct. Ie.
depending on which disk was chosen you might loose a little more or less,
but only within the limits of a "stripe". This is no different from a
failure without raid.

The important thing is of course, that if the RAID was recovering or
running in degraded mode when the power failed, that it does not make any
wrong decisions about which disk to use when coming back up, if for
example the failure of the disk was some temporary thing which the hard
reboot corrected. The superblock event-counter is updated on start, stop
and failure events. During recovery the superblock on the new disk is not
updated until the raid is properly closed.

> How it all fits together?
> Which drive will be declared "fresh"?

The first one possibly, or another one :) One should never assume
anything about this.

> How about several (>2) drives in raid1 array?

Shouldn't make a difference. Probably not a widely used setup either?

> How about data written without a concept of "commits", if "wrong"
> drive will be choosen -- will it contain some old data in it, while
> another drive contained new data but was declared "non fresh" at
> reconstruction?

Unless one drive was failed, the difference between the two drives will
never be more than one "stripe". The persistant superblock which is
updated at disk failure ensures that if the system fails while running
degraded or during recovery it will kick any non-fresh (failed) disks
from the array when restarting, and run in degraded mode.

> And speaking of the previous question, is there any difference here
> between md device and single disk, which also does various write
> reordering and stuff like that? -- I mean, does md layer increase
> probability to see old data after reboot caused by a power loss
> (for example) if an app (or whatever) was writing (or even when
> the filesystem reported the write is complete) some new data during
> the power loss?

I don't think md is worse than single drive. But cannot back that up
absolutely.

- Morten
----
A: No.
Q: Should I include quotations after my reply?
