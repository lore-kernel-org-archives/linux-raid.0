From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH] md-cluster: Fix a memleak in an error handling path
Date: Fri, 14 Apr 2017 14:23:56 +0800
Message-ID: <58F06AFC.509@suse.com>
References: <20170414060803.12472-1-christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20170414060803.12472-1-christophe.jaillet@wanadoo.fr>
Sender: kernel-janitors-owner@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>, shli@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids



On 04/14/2017 02:08 PM, Christophe JAILLET wrote:
> We know that 'bm_lockres' is NULL here, so 'lockres_free(bm_lockres)' is a
> no-op. According to resource handling in case of error a few lines below,
> it is likely that 'bitmap_free(bitmap)' was expected instead.
>
> Fixes: b98938d16a10 ("md-cluster: introduce cluster_check_sync_size")

Reviewed-by: Guoqing Jiang <gqjiang@suse.com>

Thanks,
Guoqing

>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   drivers/md/md-cluster.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index b21ef58819f6..7299ce2f08a8 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -1127,7 +1127,7 @@ int cluster_check_sync_size(struct mddev *mddev)
>   		bm_lockres = lockres_init(mddev, str, NULL, 1);
>   		if (!bm_lockres) {
>   			pr_err("md-cluster: Cannot initialize %s\n", str);
> -			lockres_free(bm_lockres);
> +			bitmap_free(bitmap);
>   			return -1;
>   		}
>   		bm_lockres->flags |= DLM_LKF_NOQUEUE;

