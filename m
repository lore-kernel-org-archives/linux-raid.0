From: Shaohua Li <shli@kernel.org>
Subject: Re: Superblock of raid5 log can't be updated when array stoped
Date: Fri, 21 Oct 2016 15:43:41 -0700
Message-ID: <20161021224341.GC105663@kernel.org>
References: <tencent_382FBBB34581DF7E1F5EC9A2@qq.com>
 <20161018002814.GC106864@kernel.org>
 <tencent_5F7A406104D26FAD7587F1C4@qq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <tencent_5F7A406104D26FAD7587F1C4@qq.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Cc: shli <shli@fb.com>, Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Oct 18, 2016 at 01:51:57PM +0800, Zhengyuan Liu wrote:
> If that's the problem, I think there is another problem about next_checkpoint initialization.
> No initial operation was done to this field when we loaded/recovery  the log , it got
> assignment  only when IO to raid disk was finished.  So r5l_quiesce may use wrong 
> next_checkpoint to reclaim log space, that would confuse log recovery.  Bellow patch
> may help the expression.

Good catch. This doesn't confuse log recovery but maks reclaimable space
calculation confused. Could you please send a formal patch?

Thanks,
Shaohua 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 1b1ab4a..998ea00 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -1096,6 +1096,8 @@ static int r5l_recovery_log(struct r5l_log *log)
>                 log->seq = ctx.seq + 11;
>                 log->log_start = r5l_ring_add(log, ctx.pos, BLOCK_SECTORS);
>                 r5l_write_super(log, ctx.pos);
> +               log->last_checkpoint = ctx.pos;
> +               log->next_checkpoint = ctx.pos;
>         } else {
>                 log->log_start = ctx.pos;
>                 log->seq = ctx.seq;
> @@ -1168,6 +1170,7 @@ create:
>         if (log->max_free_space > RECLAIM_MAX_FREE_SPACE)
>                 log->max_free_space = RECLAIM_MAX_FREE_SPACE;
>         log->last_checkpoint = cp;
> +       log->next_checkpoint = cp;
>  
>         __free_page(page);
> 
> Thanks,
> --Zhengyuan
> 
> ------------------ Original ------------------
> From:  "Shaohua Li"<shli@kernel.org>;
> Date:  Tue, Oct 18, 2016 08:28 AM
> To:  "Zhengyuan Liu"<liuzhengyuan@kylinos.cn>;
> Cc:  "shli"<shli@fb.com>; "Song Liu"<songliubraving@fb.com>; "linux-raid"<linux-raid@vger.kernel.org>;
> Subject:  Re: Superblock of raid5 log can't be updated when array stoped
>  
> On Sat, Oct 15, 2016 at 10:19:36AM +0800, liuzhengyuan wrote:
> > Hi, Shaohua.
> > 
> > when we stop raid5 array with "mdadm -S" or reboot the system,  md module will 
> > call raid5_quiesce and r5l_quiesce to do some clean work. Some code of r5l_quiesce
> > was pasted bellow.
> > 
> >                 /* make sure r5l_write_super_and_discard_space exits */
> >                 mddev = log->rdev->mddev;
> >                 wake_up(&mddev->sb_wait);
> >                 r5l_wake_reclaim(log, -1L);
> >                 md_unregister_thread(&log->reclaim_thread);
> >                 r5l_do_reclaim(log);
> > +                md_update_sb(mddev, 1);
> > 
> > It will reclaim all used space of log and call r5l_write_super to reset rdev->journal_tail
> > to log->next_checkpoint . However, new rdev->journal_tail would not be written to 
> > journal device for persistent because journal device may not support discard operation
> > or due to mddev_trylock fail (this trylock should always get failed since raid5_quiesce 
> > was called with  reconfig_mutex hold, isn't it?). As a result, it will take a long time to
> >  recovery the log when the arrary was restarted. Should r5l_quiesce call md_update_sb
> >  directly to guarantee  superblock  update?
> 
> Yep, that's problem here. Unfortunately we can't call md_update_sb here,
> because we might not hold the mddev lock. I think we should call it at do_md_stop.
> 
> Thanks,
> Shaohua
