From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 1/3] raid5: offload stripe handle to workqueue
Date: Wed, 31 Jul 2013 09:24:34 +0800
Message-ID: <20130731012434.GA1504@kernel.org>
References: <20130730055207.698660010@kernel.org>
 <20130730055257.527231772@kernel.org>
 <20130730125306.GC2599@htj.dyndns.org>
 <20130730130708.GA30352@kernel.org>
 <20130730135751.GD12016@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130730135751.GD12016@htj.dyndns.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, djbw@fb.com
List-Id: linux-raid.ids

On Tue, Jul 30, 2013 at 09:57:51AM -0400, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jul 30, 2013 at 09:07:08PM +0800, Shaohua Li wrote:
> > Ok, I should explain here. I can't add a work_struct for each stripe, because
> > this will stress workqueue very hard. My system handles > 1M/s stripes, which
> > makes workqueue pool lock contended very hard.
> 
> It doesn't have to be embedding work_struct in each stripe and
> schduling them altogether.  It's more about scheduling "work units"
> rather than "workers" - ie. letting each scheduled work item handle
> single work unit rather than making it dispatch multiple work items.
> It may make controlling concurrency a bit more interesting but you can
> always do it with workqueue_set_max_active(), which is the intended
> usage anyway.

stripe is the work unit actually. As I said, if I queue a work for each stripe,
just queue_work() will make the system blast because of the pwq->pool->lock
contention. dispatching one work has another side effect that I can't add block
plug. Since this is the queue stage concurrency problem,
workqueue_set_max_active() doesn't help.

Thanks,
Shaohua
