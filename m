From: Shaohua Li <shli@kernel.org>
Subject: Re: Superblock of raid5 log can't be updated when array stoped
Date: Mon, 17 Oct 2016 17:28:14 -0700
Message-ID: <20161018002814.GC106864@kernel.org>
References: <tencent_382FBBB34581DF7E1F5EC9A2@qq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <tencent_382FBBB34581DF7E1F5EC9A2@qq.com>
Sender: linux-raid-owner@vger.kernel.org
To: liuzhengyuan <liuzhengyuan@kylinos.cn>
Cc: shli <shli@fb.com>, Song Liu <songliubraving@fb.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Oct 15, 2016 at 10:19:36AM +0800, liuzhengyuan wrote:
> Hi, Shaohua.
> 
> when we stop raid5 array with "mdadm -S" or reboot the system,  md module will 
> call raid5_quiesce and r5l_quiesce to do some clean work. Some code of r5l_quiesce
> was pasted bellow.
> 
>                 /* make sure r5l_write_super_and_discard_space exits */
>                 mddev = log->rdev->mddev;
>                 wake_up(&mddev->sb_wait);
>                 r5l_wake_reclaim(log, -1L);
>                 md_unregister_thread(&log->reclaim_thread);
>                 r5l_do_reclaim(log);
> +                md_update_sb(mddev, 1);
> 
> It will reclaim all used space of log and call r5l_write_super to reset rdev->journal_tail
> to log->next_checkpoint . However, new rdev->journal_tail would not be written to 
> journal device for persistent because journal device may not support discard operation
> or due to mddev_trylock fail (this trylock should always get failed since raid5_quiesce 
> was called with  reconfig_mutex hold, isn't it?). As a result, it will take a long time to
>  recovery the log when the arrary was restarted. Should r5l_quiesce call md_update_sb
>  directly to guarantee  superblock  update?

Yep, that's problem here. Unfortunately we can't call md_update_sb here,
because we might not hold the mddev lock. I think we should call it at do_md_stop.

Thanks,
Shaohua
