From: Shaohua Li <shli@kernel.org>
Subject: Re: Low RAID10 performance during resync
Date: Thu, 9 Jun 2016 10:31:18 -0700
Message-ID: <20160609173118.GA17207@kernel.org>
References: <20160609134555.GA9104@proton.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160609134555.GA9104@proton.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

On Thu, Jun 09, 2016 at 03:45:55PM +0200, Tomasz Majchrzak wrote:
> A low performance of mkfs has been observed on RAID10 array during resync. It
> is not so significant for NVMe drives but for my setup of RAID10 consisting
> of 4 SATA drives format time has increased by 200%.
> 
> I have looked into the problem and I have found out it is caused by this
> changeset:
> 
> commit 09314799e4f0589e52bafcd0ca3556c60468bc0e md: remove 'go_faster' option
> from ->sync_request()
> 
> It seemed the code had been redundant and could be safely removed due to
> barriers mechanism but it proved otherwise. The barriers don't provide enough
> throttle to resync IOs. They only assure non-resync IOs and resync IOs are
> not being executed at the same time. In result resync IOs take around 25% of
> CPU time, mostly because there are many of them but only one at a time so a
> lot of CPU time is simply wasted waiting for a single IO to complete.
> 
> The removed sleep call in resync IO had allowed a lot of non-resync activity
> to be scheduled (nobody waiting for a barrier). Once sleep call had ended,
> resync IO had to wait longer to raise a barrier as all non-resync activity
> had to be completed first. It had nicely throttled a number of resync IOs in
> favour of non-resync activity. Since we lack it now, the performance has
> dropped badly.
> 
> I would like to revert the changeset. We don't have to put a resync IO to
> sleep for a second though. I have done some testing and it seems even a delay
> of 100ms is sufficient. It slows down resync IOs to the same extent as sleep
> for a second - the sleep call ends sooner but the barrier cannot be raised
> until non-resync IOs complete.

Add Neil.

I'd like to make sure I understand the situation. With the change reverted, we
dispatch a lot of normal IO and then do a resync IO. Without it reverted, we
dispatch few normal IO and then do a resync IO. In other words, we don't batch
normal IO currently. Is this what you say?

Agree the barrier doesn't throttle resync IOs, it only assures normal IO and
resync IO run in different time.

On the other hand, the change makes resync faster. Did you try to revert this one:
ac8fa4196d205ac8fff3f8932bddbad4f16e4110
If resync is fast, reverting this one will throttle resync.

Thanks,
Shaohua
