From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: RAID-6
Date: Wed, 13 Nov 2002 14:33:46 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15825.51226.122496.604304@notabene.cse.unsw.edu.au>
References: <aqou9k$ou5$1@cesium.transmeta.com>
	<20021112162205.GB22407@unthought.net>
	<15825.22660.685310.237185@notabene.cse.unsw.edu.au>
	<20021113021343.GC22407@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jakob Oestergaard on Wednesday November 13
To: Jakob Oestergaard <jakob@unthought.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday November 13, jakob@unthought.net wrote:
> 
> Writes on a 128k chunk array are significantly slower than writes on a
> 4k chunk array, according to someone else on this list   -  I wanted to
> look into this myself, but now is just a bad time for me (nothing new
> on that front).
> 
> The benchmark goes:
> 
> | some tests on raid5 with 4k and 128k chunk size. The results are as follows:
> | Access Spec     4K(MBps)        4K-deg(MBps)    128K(MBps) 128K-deg(MBps)
> | 2K Seq Read     23.015089       33.293993       25.415035  32.669278
> | 2K Seq Write    27.363041       30.555328       14.185889  16.087862
> | 64K Seq Read    22.952559       44.414774       26.02711   44.036993
> | 64K Seq Write   25.171833       32.67759        13.97861   15.618126
> 
> So down from 27MB/sec to 14MB/sec running 2k-block sequential writes on
> a 128k chunk array versus a 4k chunk array (non-degraded).

When doing sequential writes, a small chunk size means you are more
likely to fill up a whole stripe before data is flushed to disk, so it
is very possible that you wont need to pre-read parity at all.  With a
larger chunksize, it is more likely that you will have to write, and
possibly read, the parity block several times.

So if you are doing single threaded sequential accesses, a smaller
chunk size is definately better.
If you are doing lots of parallel accesses (typical multi-user work
load), small chunk sizes tends to mean that every access goes to all
drives so there is lots of contention.  In theory a larger chunk size
means that more accesses will be entirely satisfied from just one disk,
so there it more opportunity for concurrency between the different
users.

As always, the best way to choose a chunk size is develop a realistic
work load and test it against several different chunk sizes.   There
is no rule like "bigger is better" or "smaller is better".

NeilBrown
