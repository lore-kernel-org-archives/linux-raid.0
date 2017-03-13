From: Jack Wang <jack.wang.usish@gmail.com>
Subject: Re: [PATCH] md:fix a trivial typo in comments
Date: Mon, 13 Mar 2017 10:10:55 +0100
Message-ID: <CA+res+SABO1y1FAXX3CrncmmYHKis5QQiNUm=AVcV9i2Ej3-rA@mail.gmail.com>
References: <1489384407-12672-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1489384407-12672-1-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: shli@fb.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2017-03-13 6:53 GMT+01:00 Zhilong Liu <zlliu@suse.com>:
> fix a trivial typo in freeze_array() of raid1.c
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
> ---
>  drivers/md/raid1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 7b0f647..2ec0617 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -958,7 +958,7 @@ static void allow_barrier(struct r1conf *conf, sector_t start_next_window,
>  static void freeze_array(struct r1conf *conf, int extra)
>  {
>         /* stop syncio and normal IO and wait for everything to
> -        * go quite.
> +        * go quit.
>          * We wait until nr_pending match nr_queued+extra
>          * This is called in the context of one normal IO request
>          * that has failed. Thus any sync request that might be pending
> --

s/quite/quietly ?

Cheers,
Jack

> 2.6.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
