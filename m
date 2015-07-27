From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 05/12] md-cluster: init completion within lockres_init
Date: Mon, 27 Jul 2015 11:44:53 -0500
Message-ID: <55B66005.3010605@suse.de>
References: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
 <1436518883-12783-1-git-send-email-gqjiang@suse.com>
 <1436518883-12783-2-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1436518883-12783-2-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 07/10/2015 04:01 AM, Guoqing Jiang wrote:
> We should init completion within lockres_init, otherwise
> completion could be initialized more than one time during
> it's life cycle.
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>


Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

> ---
>   drivers/md/md-cluster.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 85b7836..2a57f19 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -100,7 +100,6 @@ static int dlm_lock_sync(struct dlm_lock_resource *res, int mode)
>   {
>   	int ret = 0;
>
> -	init_completion(&res->completion);
>   	ret = dlm_lock(res->ls, mode, &res->lksb,
>   			res->flags, res->name, strlen(res->name),
>   			0, sync_ast, res, res->bast);
> @@ -125,6 +124,7 @@ static struct dlm_lock_resource *lockres_init(struct mddev *mddev,
>   	res = kzalloc(sizeof(struct dlm_lock_resource), GFP_KERNEL);
>   	if (!res)
>   		return NULL;
> +	init_completion(&res->completion);
>   	res->ls = cinfo->lockspace;
>   	res->mddev = mddev;
>   	namelen = strlen(name);
> @@ -169,7 +169,6 @@ static void lockres_free(struct dlm_lock_resource *res)
>   	if (!res)
>   		return;
>
> -	init_completion(&res->completion);
>   	dlm_unlock(res->ls, res->lksb.sb_lkid, 0, &res->lksb, res);
>   	wait_for_completion(&res->completion);
>
>

-- 
Goldwyn
