From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch 1/3] raid5: offload stripe handle to workqueue
Date: Thu, 1 Aug 2013 08:15:01 -0400
Message-ID: <20130801121501.GB24966@htj.dyndns.org>
References: <20130730055207.698660010@kernel.org>
 <20130730055257.527231772@kernel.org>
 <20130730125306.GC2599@htj.dyndns.org>
 <20130730130708.GA30352@kernel.org>
 <20130730135751.GD12016@htj.dyndns.org>
 <20130731012434.GA1504@kernel.org>
 <20130731103332.GE2810@htj.dyndns.org>
 <20130801020101.GB12580@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130801020101.GB12580@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, djbw@fb.com
List-Id: linux-raid.ids

Hello,

On Thu, Aug 01, 2013 at 10:01:01AM +0800, Shaohua Li wrote:
> It does have lock, but when a stripe is queued to handle, no lock is required.

Hmmmm.... sorry but can you please explain it a bit further?  Why
wouldn't it require a lock?  Perhaps because it has to be on some
queue already?

> So the workqueue lock will be high contended.

I still don't follow how it'd be more contended than the presumably
single lock that you'd have to use for queueing.

> > Also, can you please
> > elaborate the block plug part?
> 
> Basically I do:
> 
> blk_start_plug()
> handle_stripe() //may dispatch request
> blk_end_plug()
> 
> If only handle one stripe between block plug, the plug is useless, so I need
> handle several stripes.

Ah, right, plugging is tied to the current context, so yeap that makes
sense.

The only thing which may actually matter is freezer handling as direct
freezer handling tends to be pretty tricky.  If the work item
processing doesn't need freezing (which should be the case, I think),
it's all good.  If it does, it'd probably be best to make the
workqueue freezable and breakout of the loop if freezing.

Thanks.

-- 
tejun
