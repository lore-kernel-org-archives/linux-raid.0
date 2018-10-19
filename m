From: Xiao Ni <xni@redhat.com>
Subject: Re: [PATCH] md: fix memleak for mempool
Date: Fri, 19 Oct 2018 10:41:40 -0400 (EDT)
Message-ID: <1488114196.22211692.1539960100628.JavaMail.zimbra@redhat.com>
References: <1539958891-12412-1-git-send-email-jinpuwang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539958891-12412-1-git-send-email-jinpuwang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jack Wang <xjtuwjp@gmail.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Jack Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids



----- Original Message -----
> From: "Jack Wang" <xjtuwjp@gmail.com>
> To: shli@fb.com, linux-raid@vger.kernel.org
> Cc: xni@redhat.com, linux-kernel@vger.kernel.org, "Jack Wang" <jinpu.wang@profitbricks.com>
> Sent: Friday, October 19, 2018 10:21:31 PM
> Subject: [PATCH] md: fix memleak for mempool
> 
> From: Jack Wang <jinpu.wang@profitbricks.com>
> 
> I noticed kmemleak report memory leak when run create/stop
> md in a loop, backtrace:
> [<000000001ca975e7>] mempool_create_node+0x86/0xd0
> [<0000000095576bcd>] md_run+0x1057/0x1410 [md_mod]
> [<000000007b45c5fc>] do_md_run+0x15/0x130 [md_mod]
> [<000000001ede9ec0>] md_ioctl+0x1f49/0x25d0 [md_mod]
> [<000000004142cacf>] blkdev_ioctl+0x680/0xd00
> 
> The root cause is we alloc mddev->flush_pool and
> mddev->flush_bio_pool in md_run, but from do_md_stop
> will not call into md_stop but __md_stop, move the
> mempool_destroy to __md_stop fixes the problem for me.
> 
> The bug was introduced in 5a409b4f56d5, the fixes should go to
> 4.18+
> 
> Cc: Xiao Ni <xni@redhat.com>
> Fixes: 5a409b4f56d5 ("MD: fix lock contention for flush bios")
> Signed-off-by: Jack Wang <jinpu.wang@profitbricks.com>
> ---
>  drivers/md/md.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 4c0f3e0331d5..feb6145097da 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5904,14 +5904,6 @@ static void __md_stop(struct mddev *mddev)
>  		mddev->to_remove = &md_redundancy_group;
>  	module_put(pers->owner);
>  	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
> -}
> -
> -void md_stop(struct mddev *mddev)
> -{
> -	/* stop the array and free an attached data structures.
> -	 * This is called from dm-raid
> -	 */
> -	__md_stop(mddev);
>  	if (mddev->flush_bio_pool) {
>  		mempool_destroy(mddev->flush_bio_pool);
>  		mddev->flush_bio_pool = NULL;
> @@ -5920,6 +5912,14 @@ void md_stop(struct mddev *mddev)
>  		mempool_destroy(mddev->flush_pool);
>  		mddev->flush_pool = NULL;
>  	}
> +}
> +
> +void md_stop(struct mddev *mddev)
> +{
> +	/* stop the array and free an attached data structures.
> +	 * This is called from dm-raid
> +	 */
> +	__md_stop(mddev);
>  	bioset_exit(&mddev->bio_set);
>  	bioset_exit(&mddev->sync_set);
>  }
> --
> 2.7.4
> 
> 

Reviewed-by: Xiao Ni <xni@redhat.com>
