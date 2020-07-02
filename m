From: Song Liu <song@kernel.org>
Subject: Re: [PATCH v5 12/16] md/raid5: support config stripe_size by sysfs entry
Date: Thu, 2 Jul 2020 15:38:41 -0700
Message-ID: <CAPhsuW5rTOwd+hPsBobFWD4TWGO4pWMgwt5BVAt=Fnab71MC=w@mail.gmail.com>
References: <20200702120628.777303-1-yuyufen@huawei.com> <20200702120628.777303-13-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200702120628.777303-13-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids

On Thu, Jul 2, 2020 at 5:05 AM Yufen Yu <yuyufen@huawei.com> wrote:
>
> After this patch, we can adjust stripe_size by writing value into sysfs
> entry, likely, set stripe_size as 16KB:
>
>           echo 16384 > /sys/block/md1/md/stripe_size
>
> Show current stripe_size value:
>
>           cat /sys/block/md1/md/stripe_size
>
> stripe_size should not be bigger than PAGE_SIZE, and it requires to be
> multiple of 4096.

I think we can just merge 02/16 into this one.

>
> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
> ---
>  drivers/md/raid5.c | 69 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 68 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index f0fd01d9122e..a3376a4e4e5c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6715,7 +6715,74 @@ raid5_show_stripe_size(struct mddev  *mddev, char *page)
>  static ssize_t
>  raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
>  {
> -       return -EINVAL;
> +       struct r5conf *conf = mddev->private;

We need mddev_lock(mddev) before accessing mddev->private.

> +       unsigned int new;
> +       int err;
> +       int nr;
> +
> +       if (len >= PAGE_SIZE)
> +               return -EINVAL;
> +       if (kstrtouint(page, 10, &new))
> +               return -EINVAL;
> +       if (!conf)
> +               return -ENODEV;
> +
> +       /*
> +        * When PAGE_SZIE is 4096, we don't need to modify stripe_size.
> +        * And the value should not be bigger than PAGE_SIZE.
> +        * It requires to be multiple of 4096.
> +        */
> +       if (PAGE_SIZE == 4096 || new % 4096 != 0 ||
> +                       new > PAGE_SIZE || new == 0)
> +               return -EINVAL;
> +
> +       if (new == conf->stripe_size)
> +               return len;
> +
> +       pr_debug("md/raid: change stripe_size from %u to %u\n",
> +                       conf->stripe_size, new);
> +
> +       err = mddev_lock(mddev);
> +       if (err)
> +               return err;
> +
> +       if (mddev->sync_thread ||
> +           test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
> +           mddev->reshape_position != MaxSector ||
> +           mddev->sysfs_active) {
> +               err = -EBUSY;
> +               goto out_unlock;
> +       }
> +
> +       nr = conf->max_nr_stripes;
> +
> +       /* 1. suspend raid array */
> +       mddev_suspend(mddev);
> +
> +       /* 2. free all old stripe_head */
> +       mutex_lock(&conf->cache_size_mutex);
> +       shrink_stripes(conf);
> +       BUG_ON(conf->max_nr_stripes != 0);


> +
> +       /* 3. set new stripe_size */
> +       conf->stripe_size = new;
> +       conf->stripe_shift = ilog2(new) - 9;
> +       conf->stripe_sectors = new >> 9;
> +
> +       /* 4. allocate new stripe_head */
> +       if (grow_stripes(conf, nr)) {
> +               pr_warn("md/raid:%s: couldn't allocate buffers\n",
> +                               mdname(mddev));
> +               err = -ENOMEM;
> +       }
> +       mutex_unlock(&conf->cache_size_mutex);
> +
> +       /* 5. resume raid array */
> +       mddev_resume(mddev);
> +
> +out_unlock:
> +       mddev_unlock(mddev);
> +       return err ?: len;
>  }
>
>  static struct md_sysfs_entry
> --
> 2.25.4
>
