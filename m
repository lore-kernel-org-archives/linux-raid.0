From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 01/14] md-cluster: remove unnecessary header files
Date: Tue, 28 Feb 2017 10:03:37 -0800
Message-ID: <20170228180337.j7qakl7kbf5lapup@kernel.org>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
 <1487906124-20107-2-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487906124-20107-2-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.de
List-Id: linux-raid.ids

On Fri, Feb 24, 2017 at 11:15:11AM +0800, Guoqing Jiang wrote:
> md-cluster.h is already included in md.h, so remove
> the redundant one and we don't want to cross include
> header file too.
> 
> Reviewed-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>

It would be better md.h doesn't include md-cluster.h and include md-cluster.h
in required .c files.

> ---
>  drivers/md/md-cluster.c | 1 -
>  drivers/md/md-cluster.h | 2 --
>  2 files changed, 3 deletions(-)
> 
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 2b13117fb918..03c38ed222ce 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -16,7 +16,6 @@
>  #include <linux/raid/md_p.h>
>  #include "md.h"
>  #include "bitmap.h"
> -#include "md-cluster.h"
>  
>  #define LVB_SIZE	64
>  #define NEW_DEV_TIMEOUT 5000
> diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
> index e765499ba591..8f26a5e80810 100644
> --- a/drivers/md/md-cluster.h
> +++ b/drivers/md/md-cluster.h
> @@ -3,8 +3,6 @@
>  #ifndef _MD_CLUSTER_H
>  #define _MD_CLUSTER_H
>  
> -#include "md.h"
> -
>  struct mddev;
>  struct md_rdev;
>  
> -- 
> 2.6.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
