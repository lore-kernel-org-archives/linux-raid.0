From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 09/12] md-cluster: add missed lockres_free
Date: Mon, 27 Jul 2015 11:30:26 -0500
Message-ID: <55B65CA2.3050302@suse.de>
References: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
 <1436518883-12783-1-git-send-email-gqjiang@suse.com>
 <1436518883-12783-6-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1436518883-12783-6-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 07/10/2015 04:01 AM, Guoqing Jiang wrote:
> We also need to free the lock resource before goto out.
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>

Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

> ---
>   drivers/md/md-cluster.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 057a973..411b430 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -647,8 +647,10 @@ static int gather_all_resync_info(struct mddev *mddev, int total_slots)
>   			lockres_free(bm_lockres);
>   			continue;
>   		}
> -		if (ret)
> +		if (ret) {
> +			lockres_free(bm_lockres);
>   			goto out;
> +		}
>   		/* TODO: Read the disk bitmap sb and check if it needs recovery */
>   		dlm_unlock_sync(bm_lockres);
>   		lockres_free(bm_lockres);
>

-- 
Goldwyn
