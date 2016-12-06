From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: fix refcount problem on mddev when stopping array.
Date: Mon, 5 Dec 2016 16:39:31 -0800
Message-ID: <20161206003931.vjk566amo5wcvibs@kernel.org>
References: <87h96j53x9.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87h96j53x9.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org, Marc Smith <marc.smith@mcc.edu>
List-Id: linux-raid.ids

On Mon, Dec 05, 2016 at 04:40:50PM +1100, Neil Brown wrote:
> 
> md_open() gets a counted reference on an mddev using mddev_find().
> If it ends up returning an error, it must drop this reference.
> 
> There are two error paths where the reference is not dropped.
> One only happens if the process is signalled and an awkward time,
> which is quite unlikely.
> The other was introduced recently in commit af8d8e6f0.
> 
> Change the code to ensure the drop the reference when returning an error,
> and make it harded to re-introduce this sort of bug in the future.
> 
> Reported-by: Marc Smith <marc.smith@mcc.edu>
> Fixes: af8d8e6f0315 ("md: changes for MD_STILL_CLOSED flag")
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
> 
> Hi Shaohua,
>  as this bug was introduced in v4.9-rc1, it would be great if this
>  patch could get to Linus before v4.9-final comes out (on Sunday?).

Applied to the for-next tree. This sounds not significant enough, so I'll push
it to 4.10.

Thanks,
Shaohua
 
> Thanks,
> NeilBrown
> 
> 
>  drivers/md/md.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2089d46b0eb8..d1a291ac2a75 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7092,7 +7092,8 @@ static int md_open(struct block_device *bdev, fmode_t mode)
>  
>  	if (test_bit(MD_CLOSING, &mddev->flags)) {
>  		mutex_unlock(&mddev->open_mutex);
> -		return -ENODEV;
> +		err = -ENODEV;
> +		goto out;
>  	}
>  
>  	err = 0;
> @@ -7101,6 +7102,8 @@ static int md_open(struct block_device *bdev, fmode_t mode)
>  
>  	check_disk_change(bdev);
>   out:
> +	if (err)
> +		mddev_put(mddev);
>  	return err;
>  }
>  
> -- 
> 2.10.2
> 


