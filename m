From: Song Liu <song@kernel.org>
Subject: Re: [PATCH v5 02/16] md/raid5: add sysfs entry to set and show stripe_size
Date: Thu, 2 Jul 2020 15:14:33 -0700
Message-ID: <CAPhsuW7oDE_hD8=s1zZucn3khXWgrFh-CUewtSguM1KG6628mg@mail.gmail.com>
References: <20200702120628.777303-1-yuyufen@huawei.com> <20200702120628.777303-3-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200702120628.777303-3-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids

On Thu, Jul 2, 2020 at 5:05 AM Yufen Yu <yuyufen@huawei.com> wrote:
>
> Here, we don't support setting stripe_size by sysfs.
> Following patches will do that.
>
> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
> ---
>  drivers/md/raid5.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 2981b853c388..51bc39dab57b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6518,6 +6518,27 @@ raid5_rmw_level = __ATTR(rmw_level, S_IRUGO | S_IWUSR,
>                          raid5_show_rmw_level,
>                          raid5_store_rmw_level);
>
> +static ssize_t
> +raid5_show_stripe_size(struct mddev  *mddev, char *page)
> +{
> +       struct r5conf *conf = mddev->private;
> +
> +       if (conf)
> +               return sprintf(page, "%d\n", conf->stripe_size);
> +       else
> +               return 0;
> +}
> +
> +static ssize_t
> +raid5_store_stripe_size(struct mddev  *mddev, const char *page, size_t len)
> +{
> +       return -EINVAL;
> +}

How about we make the file read only for now?

Song
