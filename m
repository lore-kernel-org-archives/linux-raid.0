From: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Subject: Re: [PATCH] md-cluster: Fix potential error pointer dereference in
 resize_bitmaps()
Date: Tue, 4 Aug 2020 12:40:18 +0200
Message-ID: <824849e0-c98d-1f22-817c-7a76d3ee22b1@cloud.ionos.com>
References: <20200804101645.GB392148@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <20200804101645.GB392148@mwanda>
Content-Language: en-US
Sender: kernel-janitors-owner@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>, Song Liu <song@kernel.org>
Cc: Shaohua Li <shli@fb.com>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-raid.ids



On 8/4/20 12:16 PM, Dan Carpenter wrote:
> The error handling calls md_bitmap_free(bitmap) which checks for NULL
> but will Oops if we pass an error pointer.  Let's set "bitmap" to NULL
> on this error path.
>
> Fixes: afd756286083 ("md-cluster/raid10: resize all the bitmaps before start reshape")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/md/md-cluster.c | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 73fd50e77975..d50737ec4039 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -1139,6 +1139,7 @@ static int resize_bitmaps(struct mddev *mddev, sector_t newsize, sector_t oldsiz
>   		bitmap = get_bitmap_from_slot(mddev, i);
>   		if (IS_ERR(bitmap)) {
>   			pr_err("can't get bitmap from slot %d\n", i);
> +			bitmap = NULL;
>   			goto out;
>   		}
>   		counts = &bitmap->counts;

Thanks for the catch, Reviewed-by: Guoqing Jiang 
<guoqing.jiang@cloud.ionos.com>

BTW, seems there could be memory leak in the function since it keeps 
allocate bitmap
in the loop ..., will send a format patch.


diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 73fd50e77975..89d7b32489d8 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -1165,6 +1165,8 @@ static int resize_bitmaps(struct mddev *mddev, 
sector_t newsize, sector_t oldsiz
                          * can't resize bitmap
                          */
                         goto out;
+
+               md_bitmap_free(bitmap);
         }

         return 0;

Thanks,
Guoqing
