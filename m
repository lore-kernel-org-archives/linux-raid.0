From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: Re: [PATCH] raid10: improve random reads performance
Date: Wed, 20 Jul 2016 09:31:53 +0200
Message-ID: <20160720073153.GA10291@proton.igk.intel.com>
References: <1466770816-5227-1-git-send-email-tomasz.majchrzak@intel.com>
 <20160719222006.GA79792@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160719222006.GA79792@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 19, 2016 at 03:20:06PM -0700, Shaohua Li wrote:
> On Fri, Jun 24, 2016 at 02:20:16PM +0200, Tomasz Majchrzak wrote:
> > RAID10 random read performance is lower than expected due to excessive spinlock
> > utilisation which is required mostly for rebuild/resync. Simplify allow_barrier
> > as it's in IO path and encounters a lot of unnecessary congestion.
> > 
> > As lower_barrier just takes a lock in order to decrement a counter, convert
> > counter (nr_pending) into atomic variable and remove the spin lock. There is
> > also a congestion for wake_up (it uses lock internally) so call it only when
> > it's really needed. As wake_up is not called constantly anymore, ensure process
> > waiting to raise a barrier is notified when there are no more waiting IOs.
> > 
> > Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
> 
> Patch looks good, applied. Do you have data how this improves the performance?
> 
> Thanks,
> Shaohua

I have tested it on a platform with 4 NVMe drives using fio random reads
feature. Before the patch RAID10 array has been achieved 234% of single drive
performance. With my patch the same array achieves 347% of single drive
performance. The best performance of 4 drives in compare to one drive in this
test could be 400% so it's around 30% boost.

Tomek
