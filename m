From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: stoppind md from kicking out "bad' drives
Date: Sun, 24 Nov 2013 02:05:16 +0400
Message-ID: <5291269C.5080209@msgid.tls.msk.ru>
References: <5280870E.6080703@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5280870E.6080703@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Neil, I'm sorry for the repost, -- can you comment please?

I think this is important enough to deserve your comments... ;)

Meanwhile, in order to fix the mentioned broken raid5, I had
to resort to a small perl script which reads each stripe (all
parts which can be read), re-constructs missing stuff from
available data when possible, and writes result to external
file, displaying areas which can't be reconstructed.  Repeating
procedure for the missing areas using another set of drives...
So in the end we were able to completely restore all data
from the array in question.

Thanks,

/mjt

11.11.2013 11:28, Michael Tokarev wrote:
> Hello.
> 
> Yesterday we've hit a classical issue of two drives
> failure in raid5 configuration.
> 
> The scenario was like this:
> 
>  - one disk failed (atually just stopped responding, but
>    started working again after bus reset, but that was much
>    later than needed)
> 
>  - the failed disk has been kicked out of the array
> 
>  - md started syncronizing a hot-spare drive
> 
>  - during resync, another drive developed a bad (unreadable)
>    sector
> 
>  - another drive has been kicked out of the array
> 
>  - boom
> 
> Now it is obvious that almost all data on the second drive
> is intact, except of the area where the bad sector resides
> (which is, btw, at the very end of the drive, where most
> likely there's no useful data at all).  The hot-spare is
> almost ready too (up to amost the end of it).  But the array
> is non-functional and all filesystems are switched to read-
> only mode...
> 
> The question is: what's missing currently to prevent kicking
> drives from md arrays at all?  And I really mean preventing
> _both_ first failed drive (before start of resync) and second
> failed drive?
> 
> Can write-intent bitmap be used in this case, to mark areas
> changed in array which are failed to be written to one or
> another component device, for example?  Md can mark a drive
> as "semi-failed" and still try to use it in some situations.
> 
> This "semi" state can be different - f.e., one is where md
> tries all normal operations on the drive and redirects failed
> reads to other drives (with continued attempts to re-write
> bad data) and continues writing normally, marking all failed
> writes in the bitmap.  Let's say it is "semi-working" state.
> Another is when no regular I/O is happening to it except of
> the critical situations when _another_ drive becomes unreadable
> in some place - so md will try to reconstruct that data based
> on this semi-failed drive in a hope that those places will
> be read successfully.  And other variations of the same theme...
> 
> At the very least, maybe we should prevent md from kicking
> the last component device which makes the array unusable, like
> failed second drive on raid5 config - even if it has a bad
> sector, the array was 99.9% fine before md kicked it out,
> but after kicking it, the array is 100% dead...  This does
> not look right to me.
> 
> Also, what's the way to assemble this array now?  We've almost
> resynced hot spare, a failed-at-the-end drive (the second
> failed one), and a non-fresh first failed drive which is in
> good condition, just outdated.  Can mdadm be forced to assemble
> the array from good drives plus second-failed drive?, maybe in
> read-only mode (this will let us to copy data which is still
> readable to another place)?
> 
> I'd try to re-write the bad places on second-failed drive based
> on the information on good drives plus data from first-failed
> drive, -- it is obvious that those places still can be reconstructed,
> because even when the filesystem were in use during (attempt to)
> resync, no changes were made to the problematic areas, so there,
> first-failed drive still can be used.  But this - at this stage -
> is rather tricky, i'll need to write a program to help me, and
> made it bug-free to be useful.
> 
> All in all, it still looks like md has very good potential for
> improvements wrt reliability... ;)
> 
> (The system in question belongs to one of a very well-known
> organisations in free software, and it is (or was) the main
> software repository)
> 
> Thank you!
> 
> /mjt
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

