From: Dave Chinner <david@fromorbit.com>
Subject: Re: RAID6 r-m-w, op-journaled fs, SSDs
Date: Sun, 1 May 2011 19:36:59 +1000
Message-ID: <20110501093659.GH13542@dastard>
References: <19900.10868.583555.849181@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <19900.10868.583555.849181@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>, Linux fs JFS <jfs-discussion@lists.SourceForge.net>
List-Id: linux-raid.ids

On Sat, Apr 30, 2011 at 04:27:48PM +0100, Peter Grandi wrote:
> Regardless, op-journaled file system designs like JFS and XFS
> write small records (way below a stripe set size, and usually
> way below a chunk size) to the journal when they queue
> operations,

XFS will write log-stripe-unit sized records to disk. If the log
buffers are not full, it pads them. Supported log-sunit sizes are up
to 256k.

> even if sometimes depending on design and options
> may "batch" the journal updates (potentially breaking safety
> semantics). Also they do small write when they dequeue the
> operations from the journal to the actual metadata records
> involved.
> 
> How bad can this be when the journal is say internal for a
> filesystem that is held on wide-stride RAID6 set? I suspect very
> very bad, with apocalyptic read-modify-write storms, eating IOPS.

Not bad at all, because the journal writes are sequential, and XFS
can have multiple log IOs in progress at once (up to 8 x 256k =
2MB). So in general while metadata operations are in progress, XFS
will fill full stripes with log IO and you won't get problems with
RMW.

> Where are studies or even just impressions of anedoctes on how
> bad this is?

Just buy decent RAID hardware with a BBWC and journal IO does not
hurt at all.

> Are there instrumentation tools in JFS or XFS that may allow me
> to watch/inspect what is happening with the journal? For Linux
> MD to see what are the rates of stripe r-m-w cases?

XFS has plenty of event tracing, including all the transaction
reservation and commit accounting in it. And if you know what you
are looking for, you can see all the log IO and transaction
completion processing in the event traces, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
