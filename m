From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 01/10 v3] raid5: use wake_up_all for overlap waking
Date: Thu, 28 Jun 2012 16:53:09 +0800
Message-ID: <20120628085309.GA8024@kernel.org>
References: <20120625072447.268095276@kernel.org>
 <20120625072553.970838108@kernel.org>
 <20120628172621.463d9a84@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120628172621.463d9a84@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

On Thu, Jun 28, 2012 at 05:26:21PM +1000, NeilBrown wrote:
> On Mon, 25 Jun 2012 15:24:48 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > It's possible several tasks are waiting for stripe overlap. We clear R5_Overlap
> > bit and wake_up, but wake_up just wakes one task. So if there are several tasks
> > in the wait queue, some tasks will not be woken up even its strip R5_Overlap
> > clear. The end result is tasks hang in make_request.
> > 
> > wake_up_all should not introduce performance issue here, since overlap case is
> > rare.
> 
> This is not necessary.
> wake_up_all is only different from wake_up if WQ_FLAG_EXCLUSIVE it set, e.g.
> by prepare_to_wait_exclusive.
> As we don't use an exclusive wait to wait on wait_for_overlap, there is no
> point in using wake_up_all, wake_up already wakes everything up.

Oh, this is silly, sorry about it. So the only problem I hit the hang is that I
fixed in the second patch. Other patches can still applied without this one.

Thanks,
Shaohua
