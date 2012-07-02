From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 03/10 v3] raid5: add a per-stripe lock
Date: Mon, 2 Jul 2012 11:16:26 +0800
Message-ID: <20120702031626.GE29770@kernel.org>
References: <20120625072447.268095276@kernel.org>
 <20120625072613.620625574@kernel.org>
 <20120702105046.56cd47ec@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120702105046.56cd47ec@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

On Mon, Jul 02, 2012 at 10:50:46AM +1000, NeilBrown wrote:
> On Mon, 25 Jun 2012 15:24:50 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > Add a per-stripe lock to protect stripe specific data, like dev->read,
> > written, ... The purpose is to reduce lock contention of conf->device_lock.
> > 
> > Signed-off-by: Shaohua Li <shli@fusionio.com>
> 
> I had hoped to avoid having a per-stripe lock again, but it does look like it
> is needed.
> However I don't like the way you have split up these three patches - it makes
> them a little hard to review.
> 
> I would like to see one patch which converts the bi_phys_segments access to
> be atomic and also removes all the spin_lock calls that were just for
> protecting that.
> 
> Then another patch which adds the new stripe_lock, clearly documenting
> exactly what is protects (not just "like dev->read" but an explicit list)
> and also removes any spin_lock of device_lock that is no longer needed.
> 
> Then I could see what is being added and what is being removed all in the one
> patch and I can be sure that they balance.

reworked the patch 3-5 to two patches as you suggested, and sent to you. please check.

Thanks,
Shaohua
