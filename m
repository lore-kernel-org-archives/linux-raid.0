From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md: update slab_cache before releasing new stripes when
 stripes resizing
Date: Mon, 10 Apr 2017 09:25:38 -0700
Message-ID: <20170410162538.2q4v3eqddygrraea@kernel.org>
References: <1490773573-32692-1-git-send-email-dennisyang@qnap.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1490773573-32692-1-git-send-email-dennisyang@qnap.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dennis Yang <dennisyang@qnap.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 29, 2017 at 03:46:13PM +0800, Dennis Yang wrote:
> When growing raid5 device on machine with small memory, there is chance that
> mdadm will be killed and the following bug report can be observed. The same
> bug could also be reproduced in linux-4.10.6.
> 
> [57600.075774] BUG: unable to handle kernel NULL pointer dereference at           (null)
> [57600.083796] IP: [<ffffffff81a6aa87>] _raw_spin_lock+0x7/0x20
> [57600.110378] PGD 421cf067 PUD 4442d067 PMD 0
> [57600.114678] Oops: 0002 [#1] SMP
> [57600.180799] CPU: 1 PID: 25990 Comm: mdadm Tainted: P           O    4.2.8 #1
> [57600.187849] Hardware name: To be filled by O.E.M. To be filled by O.E.M./MAHOBAY, BIOS QV05AR66 03/06/2013
> [57600.197490] task: ffff880044e47240 ti: ffff880043070000 task.ti: ffff880043070000
> [57600.204963] RIP: 0010:[<ffffffff81a6aa87>]  [<ffffffff81a6aa87>] _raw_spin_lock+0x7/0x20
> [57600.213057] RSP: 0018:ffff880043073810  EFLAGS: 00010046
> [57600.218359] RAX: 0000000000000000 RBX: 000000000000000c RCX: ffff88011e296dd0
> [57600.225486] RDX: 0000000000000001 RSI: ffffe8ffffcb46c0 RDI: 0000000000000000
> [57600.232613] RBP: ffff880043073878 R08: ffff88011e5f8170 R09: 0000000000000282
> [57600.239739] R10: 0000000000000005 R11: 28f5c28f5c28f5c3 R12: ffff880043073838
> [57600.246872] R13: ffffe8ffffcb46c0 R14: 0000000000000000 R15: ffff8800b9706a00
> [57600.253999] FS:  00007f576106c700(0000) GS:ffff88011e280000(0000) knlGS:0000000000000000
> [57600.262078] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [57600.267817] CR2: 0000000000000000 CR3: 00000000428fe000 CR4: 00000000001406e0
> [57600.274942] Stack:
> [57600.276949]  ffffffff8114ee35 ffff880043073868 0000000000000282 000000000000eb3f
> [57600.284383]  ffffffff81119043 ffff880043073838 ffff880043073838 ffff88003e197b98
> [57600.291820]  ffffe8ffffcb46c0 ffff88003e197360 0000000000000286 ffff880043073968
> [57600.299254] Call Trace:
> [57600.301698]  [<ffffffff8114ee35>] ? cache_flusharray+0x35/0xe0
> [57600.307523]  [<ffffffff81119043>] ? __page_cache_release+0x23/0x110
> [57600.313779]  [<ffffffff8114eb53>] kmem_cache_free+0x63/0xc0
> [57600.319344]  [<ffffffff81579942>] drop_one_stripe+0x62/0x90
> [57600.324915]  [<ffffffff81579b5b>] raid5_cache_scan+0x8b/0xb0
> [57600.330563]  [<ffffffff8111b98a>] shrink_slab.part.36+0x19a/0x250
> [57600.336650]  [<ffffffff8111e38c>] shrink_zone+0x23c/0x250
> [57600.342039]  [<ffffffff8111e4f3>] do_try_to_free_pages+0x153/0x420
> [57600.348210]  [<ffffffff8111e851>] try_to_free_pages+0x91/0xa0
> [57600.353959]  [<ffffffff811145b1>] __alloc_pages_nodemask+0x4d1/0x8b0
> [57600.360303]  [<ffffffff8157a30b>] check_reshape+0x62b/0x770
> [57600.365866]  [<ffffffff8157a4a5>] raid5_check_reshape+0x55/0xa0
> [57600.371778]  [<ffffffff81583df7>] update_raid_disks+0xc7/0x110
> [57600.377604]  [<ffffffff81592b73>] md_ioctl+0xd83/0x1b10
> [57600.382827]  [<ffffffff81385380>] blkdev_ioctl+0x170/0x690
> [57600.388307]  [<ffffffff81195238>] block_ioctl+0x38/0x40
> [57600.393525]  [<ffffffff811731c5>] do_vfs_ioctl+0x2b5/0x480
> [57600.399010]  [<ffffffff8115e07b>] ? vfs_write+0x14b/0x1f0
> [57600.404400]  [<ffffffff811733cc>] SyS_ioctl+0x3c/0x70
> [57600.409447]  [<ffffffff81a6ad97>] entry_SYSCALL_64_fastpath+0x12/0x6a
> [57600.415875] Code: 00 00 00 00 55 48 89 e5 8b 07 85 c0 74 04 31 c0 5d c3 ba 01 00 00 00 f0 0f b1 17 85 c0 75 ef b0 01 5d c3 90 31 c0 ba 01 00 00 00 <f0> 0f b1 17 85 c0 75 01 c3 55 89 c6 48 89 e5 e8 85 d1 63 ff 5d
> [57600.435460] RIP  [<ffffffff81a6aa87>] _raw_spin_lock+0x7/0x20
> [57600.441208]  RSP <ffff880043073810>
> [57600.444690] CR2: 0000000000000000
> [57600.448000] ---[ end trace cbc6b5cc4bf9831d ]---
> 
> The problem is that resize_stripes() releases new stripe_heads before assigning new
> slab cache to conf->slab_cache. If the shrinker function raid5_cache_scan() gets called
> after resize_stripes() starting releasing new stripes but right before new slab cache
> being assigned, it is possible that these new stripe_heads will be freed with the old
> slab_cache which was already been destoryed and that triggers this bug.

applied, thanks!

 
> Signed-off-by: Dennis Yang <dennisyang@qnap.com>
> ---
>  drivers/md/raid5.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 6661db2c..172edc1 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -2286,6 +2286,10 @@ static int resize_stripes(struct r5conf *conf, int newsize)
>  		err = -ENOMEM;
>  
>  	mutex_unlock(&conf->cache_size_mutex);
> +	
> +	conf->slab_cache = sc;
> +	conf->active_name = 1-conf->active_name;
> +
>  	/* Step 4, return new stripes to service */
>  	while(!list_empty(&newstripes)) {
>  		nsh = list_entry(newstripes.next, struct stripe_head, lru);
> @@ -2303,8 +2307,6 @@ static int resize_stripes(struct r5conf *conf, int newsize)
>  	}
>  	/* critical section pass, GFP_NOIO no longer needed */
>  
> -	conf->slab_cache = sc;
> -	conf->active_name = 1-conf->active_name;
>  	if (!err)
>  		conf->pool_size = newsize;
>  	return err;
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
