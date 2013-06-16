From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID 5: low sequential write performance?
Date: Sun, 16 Jun 2013 22:27:34 +0100
Message-ID: <20926.11718.556180.928129@tree.ty.sabi.co.uk>
References: <51BCF46B.40704@fatooh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51BCF46B.40704@fatooh.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> [ ... ] see a high number of read operations for each drive,
> and I suspect that is related to the low performance, since
> presumably the drives are having to seek in order to perform
> these reads. I'm aware of the RAID 5 write penalty

Yes, that's Read-Modify-Write.

> but does it still apply to large sequential writes that
> traverse many stripes?

If the writes are striped aligned, things should be good. But
there is no guarantee that the writes you issue to a '/dev/md'
device will not be rescheduled by the IO subsystem, and even if
you issue aligned logical writes the physical writes may not be
aligned.

> I know this doesn't have anything to do with the filesystem--
> I was able to reproduce the behavior on a test system, writing
> directly to an otherwise unused array, using a single 768 MB
> write() call.

Usually writes via a filesystem are more likely to avoid RMW
issues, as suitabky chosen filesystem designs take into account
stripe alignment.

Some time ago I did some tests and I was also writing to a
'/dev/md' device, but I found I got RMW only if using
'O_DIRECT', while buffered writes ended up being aligned.
Without going into details, it looked like that the Linux IO
subsystem does significant reordering of requests, sometimes
surprisingly, when directly accessing the block device, but not
when writing files after creating a filesystem in that block
device. Perhaps currently MD expects to be fronted by a
filesystem.

> I measured chunk sizes at each power of 2 from 2^2 to 2^14
> KB. The results of this are that smaller chunks performed the
> best, [ ... ]

Your Perl script is a bit convoluted. I prefer to keep it simple
and use 'dd' advisedly to get upper boundaries.

Anyhow, try using a stripe-aware filesystem like XFS, and also
perhaps increase significantly the size of the stripe cache.
That seems to help scheduling too. Changing the elevator on the
member devices sometimes helps too (but is not necessarily
related to RMW issues).
