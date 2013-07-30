From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch 1/3] raid5: offload stripe handle to workqueue
Date: Tue, 30 Jul 2013 07:46:58 -0400
Message-ID: <20130730114658.GA2599@htj.dyndns.org>
References: <20130730055207.698660010@kernel.org>
 <20130730055257.527231772@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130730055257.527231772@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shli@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, neilb@suse.de, djbw@fb.com
List-Id: linux-raid.ids

Hello,

On Tue, Jul 30, 2013 at 01:52:08PM +0800, shli@kernel.org wrote:
>  static int __init raid5_init(void)
>  {
> +	raid5_wq = alloc_workqueue("raid5wq",
> +		WQ_NON_REENTRANT|WQ_UNBOUND|WQ_MEM_RECLAIM|
> +			WQ_CPU_INTENSIVE|WQ_SYSFS, 0);

Workqueues are now always non-reentrant and WQ_NON_REENTRANT is noop.
I was planning to remove it and then forgot. :) Will send out patches
to kill it.

Thanks.

-- 
tejun
