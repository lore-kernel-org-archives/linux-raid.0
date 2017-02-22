From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] md/linear: shutup lockdep warnning
Date: Wed, 22 Feb 2017 15:23:15 +0800
Message-ID: <71114590-9641-4697-AE24-DE07464907FC@suse.de>
References: <6ceac5d5f76023fe2b76dc053041c50f81775b12.1487714093.git.shli@fb.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6ceac5d5f76023fe2b76dc053041c50f81775b12.1487714093.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> 在 2017年2月22日，上午5:55，Shaohua Li <shli@fb.com> 写道：
> 
> Commit 03a9e24(md linear: fix a race between linear_add() and
> linear_congested()) introduces the warnning.
> 
> Cc: Coly Li <colyli@suse.de>
> Signed-off-by: Shaohua Li <shli@fb.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks for the fix !

Coly



> ---
> drivers/md/linear.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index 789008b..5b06b0d 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -224,7 +224,8 @@ static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
>     * oldconf until no one uses it anymore.
>     */
>    mddev_suspend(mddev);
> -    oldconf = rcu_dereference(mddev->private);
> +    oldconf = rcu_dereference_protected(mddev->private,
> +            lockdep_is_held(&mddev->reconfig_mutex));
>    mddev->raid_disks++;
>    WARN_ONCE(mddev->raid_disks != newconf->raid_disks,
>        "copied raid_disks doesn't match mddev->raid_disks");
> -- 
> 2.9.3
> 

