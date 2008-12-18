From: Dave Chinner <david@fromorbit.com>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Fri, 19 Dec 2008 09:26:21 +1100
Message-ID: <20081218222621.GA17177@disturbed>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan> <1229225480.16555.152.camel@localhost> <18757.4606.966139.10342@tree.ty.sabi.co.uk> <200812141912.59649.Martin@lichtvoll.de> <18757.33373.744917.457587@tree.ty.sabi.co.uk> <494971B2.1000103@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <494971B2.1000103@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Peter Grandi <pg_xf2@xf2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>, Linux XFS <xfs@oss.sgi.com>
List-Id: linux-raid.ids

On Wed, Dec 17, 2008 at 04:40:02PM -0500, Bill Davidsen wrote:
> What really bothers me is that there's no obvious need for
> barriers at the device level if the file system is just a bit
> smarter and does it's own async io (like aio_*), because you can
> track writes outstanding on a per-fd basis, so instead of stopping
> the flow of data to the drive, you can just block a file
> descriptor and wait for the count of outstanding i/o to drop to
> zero. That provides the order semantics of barriers as far as I
> can see, having tirelessly thought about it for ten minutes or so.

Well, you've pretty much described the algorithm XFS uses in it's
transaction system - it's entirely asynchronous - and it's been
clear for many, many years that this model is broken when you have
devices with volatile write caches and internal re-ordering.  I/O
completion on such devices does not guarantee data is safe on stable
storage.

If the device does not commit writes to stable storage in the same
order they are signalled as complete (i.e. internal device
re-ordering occurred after completion), then the device violates
fundamental assumptions about I/O completion that the above model
relies on.

XFS uses barriers to guarantee that the devices don't lie about the
completion order of critical I/O, not that the I/Os are on stable
storage. The fact that this causes cache flushes to stable storage
is result of the implementation of that guarantee of ordering. I'm
sure the linux barrier implementation could be smarter and faster
(for some hardware), but for an operation that is used to guarantee
integrity I'll take conservative and safe over smart and fast any
day of the week....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
