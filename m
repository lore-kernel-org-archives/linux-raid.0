From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Which drive gets read in case of inconsistency? [was: ext3 journal
 on software raid etc]
Date: Tue, 04 Jan 2005 14:57:57 +0300
Message-ID: <41DA84C5.3070403@tls.msk.ru>
References: <200501030916.j039Gqe23568@inv.it.uc3m.es> <l1nna2-e9i.ln1@news.it.uc3m.es> <200501031846.42950.maarten@ultratux.net> <200501032052.21459.maarten@ultratux.net> <a9noa2-o12.ln1@news.it.uc3m.es> <fh0pa2-kvp.ln1@news.it.uc3m.es> <16857.55609.534526.297577@cse.unsw.edu.au> <jh4pa2-pi.ln1@news.it.uc3m.es> <16857.64086.362458.177296@cse.unsw.edu.au> <ms4qa2-0qa.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ms4qa2-0qa.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter T. Breuer wrote:
> Neil Brown <neilb@cse.unsw.edu.au> wrote:
[]
>>If there is a system crash before correct, consistent data is written,
>>then on restart, disk B will not be read at all until disk A as been
> 
> Why do you think so? I know of no mechanism in RAID that records to
> which of the two disks paired data has been written and to which it has
> not!
> 
> Please clarify - this is important. If you are thinking of the "event
> count" that is stamped on the superblocks, that is only updated from
> time to time as far as I know! Can you please specify (for my
> curiousity) exactly when it is updated? That would be useful to know.

Yes, this is the most dark corner in whole raid stuff for me still.
I just looked at the code again, re-read it several times, but the
code is a bit.. large to understand in a relatively short time.  This
very question bothered me for quite some time now.  How md code "knows"
which drive has "more recent" data on it in case of system crash (power
loss, whatever) after one drive has completed the write but before
another hasn't?  The "event counter" isn't updated on every write
(it'd be very expensive in both time and disk health -- too much
seeking and too much writes to a single block where the superblock
is located).

For me, and I'm just thinking how it can be done, the only possible
solution in this case is to choose "random" drive and declare it as
"up-to-date" -- it will not necessary be really up-to-date.  Or,
maybe, write to "first" drive first and to "second" next, and assume
first drive have the data written before second (no guarantee here
because of reordering, differences in drive speed etc, but it is --
sort of -- valid assumption).

Speaking of a reasonable filesystem (journalling isn't relevant here,
the key word is "reasonable", that it, the system that makes comples
operations to be atomic) and filesystem metadata, choosing "random"
drive as up-to-date makes some sense, at least the metadata will
be consistent (not necessary up to date, ie, for example, it is
still possible to lose some mail file which has been acknowleged
by filesystem AND by the smtp server, but due to choosing the
"wrong" (not recent) drive, that file operation has been "rolled
back"), but still consistent (I'm not talking about data consistency
and integrity, that's another long story).

Or, maybe it's better to ask the question slightly (?) differently:
recalling "write barriers" etc and raid1 (for simplicity), will raid
code acknowlege a write only after ALL drives has been written to?
And thus, having reasonable filesystem (again), will the filesystem
operation (at least metadata) succeed ONLY after the md layer will
report ALL disks has the data written?  (This way, it really makes
no difference which - fresh or not - drive will be considered up to
date after the poweroff in the middle of some write, *at least* for
filesystem metadata, and for applications that implements "commit"
concept as needed to correctly implement "reasonable" metadata
operations).

How it all fits together?
Which drive will be declared "fresh"?
How about several (>2) drives in raid1 array?
How about data written without a concept of "commits", if "wrong"
drive will be choosen -- will it contain some old data in it, while
another drive contained new data but was declared "non fresh" at
reconstruction?
And speaking of the previous question, is there any difference here
between md device and single disk, which also does various write
reordering and stuff like that? -- I mean, does md layer increase
probability to see old data after reboot caused by a power loss
(for example) if an app (or whatever) was writing (or even when
the filesystem reported the write is complete) some new data during
the power loss?

Alot of questions.. but I think it's really worth to understand
how it all works.

Thanks.

/mjt
