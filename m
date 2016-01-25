From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 1/2] md-cluster: fix missing memory free
Date: Mon, 25 Jan 2016 09:33:54 +0800
Message-ID: <56A57B82.2050003@suse.com>
References: <0bc7fe7dece2c5aa4f8ed7194df27b02e0ae3142.1453509823.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0bc7fe7dece2c5aa4f8ed7194df27b02e0ae3142.1453509823.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>, NeilBrown <neilb@suse.com>
List-Id: linux-raid.ids



On 01/23/2016 08:45 AM, Shaohua Li wrote:
> There are several places we allocate dlm_lock_resource, but not free it.

Culd you also add below change? Thanks.

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 0ded8e9..6c756e2 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -858,6 +858,7 @@ static int leave(struct mddev *mddev)
         lockres_free(cinfo->token_lockres);
         lockres_free(cinfo->ack_lockres);
         lockres_free(cinfo->no_new_dev_lockres);
+       lockres_free(cinfo->resync_lockres);
         lockres_free(cinfo->bitmap_lockres);
         unlock_all_bitmaps(mddev);
         dlm_release_lockspace(cinfo->lockspace, 2);

Guoqing

>
> Cc: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Cc: Guoqing Jiang <gqjiang@suse.com>
> Cc: NeilBrown <neilb@suse.com>
> Signed-off-by: Shaohua Li <shli@fb.com>
> ---
>   drivers/md/md-cluster.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 0ded8e9..662369c 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -293,6 +293,7 @@ static void recover_bitmaps(struct md_thread *thread)
>   dlm_unlock:
>   		dlm_unlock_sync(bm_lockres);
>   clear_bit:
> +		lockres_free(bm_lockres);
>   		clear_bit(slot, &cinfo->recovery_map);
>   	}
>   }
> @@ -682,8 +683,10 @@ static int gather_all_resync_info(struct mddev *mddev, int total_slots)
>   		bm_lockres = lockres_init(mddev, str, NULL, 1);
>   		if (!bm_lockres)
>   			return -ENOMEM;
> -		if (i == (cinfo->slot_number - 1))
> +		if (i == (cinfo->slot_number - 1)) {
> +			lockres_free(bm_lockres);
>   			continue;
> +		}
>   
>   		bm_lockres->flags |= DLM_LKF_NOQUEUE;
>   		ret = dlm_lock_sync(bm_lockres, DLM_LOCK_PW);

