From: Georgi Nikolov <gnikolov@icdsoft.com>
Subject: Re: Pausing md check hangs
Date: Tue, 10 Mar 2020 17:30:36 +0200
Message-ID: <58a16d12-4df3-c97c-33cb-b7eed3534a8b@icdsoft.com>
References: <2ce8813c-fd3e-5e78-39ac-049ddfa79ff6@icdsoft.com>
 <15519216-347d-c355-fa1e-e1ec29f7e996@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15519216-347d-c355-fa1e-e1ec29f7e996@cloud.ionos.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, song@kernel.org
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have tried new 4.19 kernel with proposed patches with no success. Same 
story with md1_raid6 (last time it was with 5.4 and md10_raid6).

   57.45%  [kernel]  [k] analyse_stripe
   17.34%  [kernel]  [k] ops_run_io
    6.60%  [kernel]  [k] handle_stripe
    6.20%  [kernel]  [k] handle_active_stripes.isra.73
    4.86%  [kernel]  [k] __list_del_entry_valid
    1.82%  [kernel]  [k] queue_work_on
    1.68%  [kernel]  [k] raid5_wakeup_stripe_thread
    1.65%  [kernel]  [k] do_release_stripe
    1.09%  [kernel]  [k] __release_stripe

Thank you

> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 9b6da759dca2..a961d8eed73e 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2532,13 +2532,10 @@ static ssize_t r5c_journal_mode_show(struct 
> mddev *mddev, char *page)
>         struct r5conf *conf;
>         int ret;
>
> -       ret = mddev_lock(mddev);
> -       if (ret)
> -               return ret;
> -
> +       spin_lock(&mddev->lock);
>         conf = mddev->private;
>         if (!conf || !conf->log) {
> -               mddev_unlock(mddev);
> +               spin_unlock(&mddev->lock);
>                 return 0;
>         }
>
> @@ -2558,7 +2555,7 @@ static ssize_t r5c_journal_mode_show(struct 
> mddev *mddev, char *page)
>         default:
>                 ret = 0;
>         }
> -       mddev_unlock(mddev);
> +       spin_unlock(&mddev->lock);
>         return ret;
>  }
>
>
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4779,7 +4779,8 @@ action_store(struct mddev *mddev, const char 
> *page, size_t len)
>                 if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) &&
>                     mddev_lock(mddev) == 0) {
>                         flush_workqueue(md_misc_wq);
> -                       if (mddev->sync_thread) {
> +                       if (mddev->sync_thread ||
> + test_bit(MD_RECOVERY_RUNNING,&mddev->recovery)) {
>
