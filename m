From: Nix <nix@esperi.org.uk>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store / raid5_make_request
Date: Mon, 22 May 2017 22:38:08 +0100
Message-ID: <87fufwy3lr.fsf@esperi.org.uk>
References: <87lgppz221.fsf@esperi.org.uk>
        <87a865jf9a.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87a865jf9a.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Mon, 22 May 2017 21:35:29 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22 May 2017, NeilBrown told this:

> Probably something like this:
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f6ae1d67bcd0..dbca31be22a1 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8364,8 +8364,6 @@ static void md_start_sync(struct work_struct *ws)
>   */
>  void md_check_recovery(struct mddev *mddev)
>  {
> -	if (mddev->suspended)
> -		return;
>  
>  	if (mddev->bitmap)
>  		bitmap_daemon_work(mddev);
> @@ -8484,6 +8482,7 @@ void md_check_recovery(struct mddev *mddev)
>  		clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
>  
>  		if (!test_and_clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery) ||
> +		    mddev->suspended ||
>  		    test_bit(MD_RECOVERY_FROZEN, &mddev->recovery))
>  			goto not_running;
>  		/* no recovery is running.
>
> though it's late so don't trust anything I write.
>
> If you try again it will almost certainly succeed.  I suspect this is a
> hard race to hit - well done!!!

Definitely not a hard race to hit :( I just hit it again with this
patch.

Absolutely identical hang:

[  495.833520] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  495.840618] mdadm           D    0  2700   2537 0x00000000
[  495.847762] Call Trace:
[  495.854825]  __schedule+0x290/0x810
[  495.861905]  schedule+0x36/0x80
[  495.868934]  mddev_suspend+0xb3/0xe0
[  495.875926]  ? wake_atomic_t_function+0x60/0x60
[  495.882976]  level_store+0x1a7/0x6c0
[  495.889953]  ? md_ioctl+0xb7/0x1c10
[  495.896901]  ? putname+0x53/0x60
[  495.903807]  md_attr_store+0x83/0xc0
[  495.910684]  sysfs_kf_write+0x37/0x40
[  495.917547]  kernfs_fop_write+0x110/0x1a0
[  495.924429]  __vfs_write+0x28/0x120
[  495.931270]  ? kernfs_iop_get_link+0x172/0x1e0
[  495.938126]  ? __alloc_fd+0x3f/0x170
[  495.944906]  vfs_write+0xb6/0x1d0
[  495.951646]  SyS_write+0x46/0xb0
[  495.958338]  entry_SYSCALL_64_fastpath+0x13/0x94

Everything else hangs the same way, too. This was surprising enough that
I double-checked to be sure the patch was applied: it was. I suspect the
deadlock is somewhat different than you supposed... (and quite possibly
not a race at all, or I wouldn't be hitting it so consistently, every
time. I mean, I only need to miss it *once* and I'll have reshaped... :) )

It seems I can reproduce this on demand, so if you want to throw a patch
with piles of extra printks my way, feel free.
