From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v1] md:fix a trivial typo in comments
Date: Tue, 14 Mar 2017 11:09:40 -0700
Message-ID: <20170314180940.lgekkkpalux74vrh@kernel.org>
References: <1489384407-12672-1-git-send-email-zlliu@suse.com>
 <1489477946-4202-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1489477946-4202-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org, Jack Wang <jack.wang.usish@gmail.com>, Guoqing Jiang <gqjiang@suse.com>, John Stoffel <john@stoffel.org>, Coly Li <colyli@suse.de>
List-Id: linux-raid.ids

On Tue, Mar 14, 2017 at 03:52:26PM +0800, Zhilong Liu wrote:
> raid1.c: fix a trivial typo in comments of freeze_array().
> 
> Cc: Jack Wang <jack.wang.usish@gmail.com>
> Cc: Guoqing Jiang <gqjiang@suse.com>
> Cc: John Stoffel <john@stoffel.org>
> Cc: Coly Li <colyli@suse.de>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>

applied, thanks

> ---
>  drivers/md/raid1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index fbc2d78..92ca6de 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1027,7 +1027,7 @@ static int get_unqueued_pending(struct r1conf *conf)
>  static void freeze_array(struct r1conf *conf, int extra)
>  {
>  	/* Stop sync I/O and normal I/O and wait for everything to
> -	 * go quite.
> +	 * go quiet.
>  	 * This is called in two situations:
>  	 * 1) management command handlers (reshape, remove disk, quiesce).
>  	 * 2) one normal I/O request failed.
> -- 
> 2.6.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
