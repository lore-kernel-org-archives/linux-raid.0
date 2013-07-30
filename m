From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch 1/3] raid5: offload stripe handle to workqueue
Date: Tue, 30 Jul 2013 09:57:51 -0400
Message-ID: <20130730135751.GD12016@htj.dyndns.org>
References: <20130730055207.698660010@kernel.org>
 <20130730055257.527231772@kernel.org>
 <20130730125306.GC2599@htj.dyndns.org>
 <20130730130708.GA30352@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130730130708.GA30352@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, djbw@fb.com
List-Id: linux-raid.ids

Hello,

On Tue, Jul 30, 2013 at 09:07:08PM +0800, Shaohua Li wrote:
> Ok, I should explain here. I can't add a work_struct for each stripe, because
> this will stress workqueue very hard. My system handles > 1M/s stripes, which
> makes workqueue pool lock contended very hard.

It doesn't have to be embedding work_struct in each stripe and
schduling them altogether.  It's more about scheduling "work units"
rather than "workers" - ie. letting each scheduled work item handle
single work unit rather than making it dispatch multiple work items.
It may make controlling concurrency a bit more interesting but you can
always do it with workqueue_set_max_active(), which is the intended
usage anyway.

Thanks.

-- 
tejun
