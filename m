From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 08/14] md-cluster: set MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD
 before unregister thread
Date: Tue, 28 Feb 2017 10:22:02 -0800
Message-ID: <20170228182202.svig6pbs5jsyx6bc@kernel.org>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
 <1487906124-20107-9-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487906124-20107-9-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.de
List-Id: linux-raid.ids

On Fri, Feb 24, 2017 at 11:15:18AM +0800, Guoqing Jiang wrote:
> After used sync way to handle METADATA_UPDATED msg, a deadlock
> could appear if stop a resyncing array.

shouldn't this put into the patch of 'handle METADATA_UPDATED' msg?
 
> betalinux244:~ # ps aux|grep md|grep D
> root     17164  0.0  0.0      0     0 ?        D    Jan09   0:00 [md0_cluster_rec]
> root     18151  0.0  0.1  19852  2008 ?        Ds   Jan09   0:00 /sbin/mdadm -Ssq
> betalinux244:~ # cat /proc/17164/stack
> [<ffffffffa06a7395>] recv_daemon+0x1f5/0x590 [md_cluster]
> [<ffffffffa067be20>] md_thread+0x130/0x150 [md_mod]
> [<ffffffff810995ed>] kthread+0xbd/0xe0
> [<ffffffff815e96bf>] ret_from_fork+0x3f/0x70
> [<ffffffff81099530>] kthread+0x0/0xe0
> [<ffffffffffffffff>] 0xffffffffffffffff
> betalinux244:~ # cat /proc/18151/stack
> [<ffffffff81099879>] kthread_stop+0x59/0x130
> [<ffffffffa067c566>] md_unregister_thread+0x46/0x80 [md_mod]
> [<ffffffffa06a6e71>] leave+0x81/0x120 [md_cluster]
> [<ffffffffa0684e94>] md_cluster_stop+0x14/0x30 [md_mod]
> [<ffffffffa06858b6>] bitmap_free+0x126/0x130 [md_mod]
> [<ffffffffa0682d06>] do_md_stop+0x356/0x5f0 [md_mod]
> [<ffffffffa0683cbe>] md_ioctl+0x6fe/0x1680 [md_mod]
> [<ffffffff812ed158>] blkdev_ioctl+0x258/0x920
> [<ffffffff8122f81d>] block_ioctl+0x3d/0x40
> [<ffffffff8120ac0d>] do_vfs_ioctl+0x2cd/0x4a0
> [<ffffffff8120ae54>] SyS_ioctl+0x74/0x80
> [<ffffffff815e936e>] entry_SYSCALL_64_fastpath+0x12/0x6d
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Since md_unregister_thread(&cinfo->recv_thread) is blocked by
> recv_daemon -> process_recvd_msg -> process_metadata_update.
> To resolve the issue, MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD is
> also need to be set before unregister thread.
> 
> Reviewed-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  drivers/md/md-cluster.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 0aad477d1b20..5e2c54be6f30 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -932,6 +932,7 @@ static int join(struct mddev *mddev, int nodes)
>  
>  	return 0;
>  err:
> +	set_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
>  	md_unregister_thread(&cinfo->recovery_thread);
>  	md_unregister_thread(&cinfo->recv_thread);
>  	lockres_free(cinfo->message_lockres);
> @@ -987,6 +988,7 @@ static int leave(struct mddev *mddev)
>  	if (cinfo->slot_number > 0 && mddev->recovery_cp != MaxSector)
>  		resync_bitmap(mddev);
>  
> +	set_bit(MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD, &cinfo->state);
>  	md_unregister_thread(&cinfo->recovery_thread);
>  	md_unregister_thread(&cinfo->recv_thread);
>  	lockres_free(cinfo->message_lockres);
> -- 
> 2.6.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
