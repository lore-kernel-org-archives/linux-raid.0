From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md:array cannot be opened again after 'md_set_readonly'
Date: Mon, 27 Mar 2017 11:22:14 -0700
Message-ID: <20170327182214.zde4kao2gz2lazgm@kernel.org>
References: <1490601145-5865-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1490601145-5865-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: neilb@suse.com, shli@fb.com, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

On Mon, Mar 27, 2017 at 03:52:25PM +0800, Zhilong Liu wrote:
> This is a bug about array cannot be opened again after 'md_set_readonly',
> because the MD_CLOSING bit is still waiting for clear.
> MD_CLOSING should only be set for a short period or time to avoid certain
> races. After the operation that set it completes, it should be cleared.

where is the bit set? Why don't clear it after the operation but clear it in
set_readonly?
 
> Reviewed-by: NeilBrown <neilb@suse.com>
> Cc: Guoqing Jiang <gqjiang@suse.com>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  drivers/md/md.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f6ae1d6..7f2db7c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5588,6 +5588,7 @@ static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
>  	int err = 0;
>  	int did_freeze = 0;
>  
> +	test_and_clear_bit(MD_CLOSING, &mddev->flags);

I don't understand why this must be a test_and_clear.

Thanks,
Shaohua
