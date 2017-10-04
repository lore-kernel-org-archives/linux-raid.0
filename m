From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v5 2/8] md: Neither resync nor reshape while the system
 is frozen
Date: Wed, 4 Oct 2017 03:16:10 +0200
Message-ID: <20171004011610.GP2294@wotan.suse.de>
References: <20171002225218.18548-1-bart.vanassche@wdc.com>
 <20171002225218.18548-3-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171002225218.18548-3-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, =Oleksandr Natalenko <oleksandr@natalenko.name>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-raid.ids

On Mon, Oct 02, 2017 at 03:52:12PM -0700, Bart Van Assche wrote:
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 3f7426120a3b..a2cf2a93b0cb 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8961,6 +8963,37 @@ static void md_stop_all_writes(void)
>  		mdelay(1000*1);
>  }
>  
> +/*
> + * Ensure that neither resyncing nor reshaping occurs while the system is
> + * frozen.
> + */
> +static int md_notify_pm(struct notifier_block *bl, unsigned long state,
> +			void *unused)
> +{
> +	struct mddev *mddev;
> +	struct list_head *tmp;
> +
> +	pr_debug("%s: state = %ld; system_freezing_cnt = %d\n", __func__, state,
> +		 atomic_read(&system_freezing_cnt));
> +
> +	switch (state) {
> +	case PM_HIBERNATION_PREPARE:

Hm, why not also include and use this for PM_SUSPEND_PREPARE and/or
a PM_RESTORE_PREPARE.

        case PM_HIBERNATION_PREPARE:
        case PM_SUSPEND_PREPARE:
        case PM_RESTORE_PREPARE:

> +		md_stop_all_writes();
> +		break;
> +	case PM_POST_HIBERNATION:

Likewise here:

        case PM_POST_SUSPEND:
        case PM_POST_HIBERNATION:
        case PM_POST_RESTORE:

I have revised the kernel suspend ordering and indeed things issued
with the pm notifier should suffice to be processed given we actually
call the pm ops (dpm_prepare()) for device drivers *after* the notifier
is called and then after userspace is frozen. That is:

   pm_suspend() --> enter_state() -->
     sys_sync()
     suspend_prepare() -->
             __pm_notifier_call_chain(PM_SUSPEND_PREPARE, ...);
             suspend_freeze_processes() -->
                     freeze_processes() -->
                             __usermodehelper_set_disable_depth(UMH_DISABLED);
                             freeze all tasks ...
                     freeze_kernel_threads()
     suspend_devices_and_enter() -->
             dpm_suspend_start() -->
                             dpm_prepare()
                             dpm_suspend()
             suspend_enter()  -->
                     platform_suspend_prepare()
                     dpm_suspend_late()
                     freeze_enter()
                     syscore_suspend()

On our way back up:

     enter_state() -->
     suspend_devices_and_enter() --> (bail from loop)
             dpm_resume_end() -->
                     dpm_resume()
                     dpm_complete()
     suspend_finish() -->
             suspend_thaw_processes() -->
                     thaw_processes() -->
                             __usermodehelper_set_disable_depth(UMH_FREEZING);
                             thaw_workqueues();
                             thaw all processes ...
                             usermodehelper_enable();
             pm_notifier_call_chain(PM_POST_SUSPEND);

So notifier would indeed be the right tooling to use here.

  Luis
