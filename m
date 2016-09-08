From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH V3] md-cluster: make md-cluster also can work when
 compiled into kernel
Date: Thu, 8 Sep 2016 11:03:24 -0700
Message-ID: <20160908180324.GB21973@kernel.org>
References: <1472813500-4921-1-git-send-email-gqjiang@suse.com>
 <1473041848-28009-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473041848-28009-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, "v4.1+" <stable@vger.kernel.org>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids

On Sun, Sep 04, 2016 at 10:17:28PM -0400, Guoqing Jiang wrote:
> The md-cluster is compiled as module by default,
> if it is compiled by built-in way, then we can't
> make md-cluster works.
> 
> [64782.630008] md/raid1:md127: active with 2 out of 2 mirrors
> [64782.630528] md-cluster module not found.
> [64782.630530] md127: Could not setup cluster service (-2)
> 
> Fixes: edb39c9 ("Introduce md_cluster_operations to handle cluster functions")
> Cc: stable@vger.kernel.org (v4.1+)
> Cc: NeilBrown <neilb@suse.com>
> Reported-by: Marc Smith <marc.smith@mcc.edu>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
> V3 changes:
> 1. add the "!md_cluster_ops" test back
> 2. fix wrong mail info of stable kernel
> 
> V2 changes:
> 1. call try_module_get if md_cluster_ops is already set,
>    otherwise try_module_get/module_put are unbalanced.

applied, thanks!
