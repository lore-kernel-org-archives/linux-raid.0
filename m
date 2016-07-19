From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] raid10: improve random reads performance
Date: Tue, 19 Jul 2016 15:20:06 -0700
Message-ID: <20160719222006.GA79792@kernel.org>
References: <1466770816-5227-1-git-send-email-tomasz.majchrzak@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1466770816-5227-1-git-send-email-tomasz.majchrzak@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jun 24, 2016 at 02:20:16PM +0200, Tomasz Majchrzak wrote:
> RAID10 random read performance is lower than expected due to excessive spinlock
> utilisation which is required mostly for rebuild/resync. Simplify allow_barrier
> as it's in IO path and encounters a lot of unnecessary congestion.
> 
> As lower_barrier just takes a lock in order to decrement a counter, convert
> counter (nr_pending) into atomic variable and remove the spin lock. There is
> also a congestion for wake_up (it uses lock internally) so call it only when
> it's really needed. As wake_up is not called constantly anymore, ensure process
> waiting to raise a barrier is notified when there are no more waiting IOs.
> 
> Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>

Patch looks good, applied. Do you have data how this improves the performance?

Thanks,
Shaohua
