From: Song Liu <song@kernel.org>
Subject: Re: [PATCH RFC v2 1/8] md/raid5: add CONFIG_MD_RAID456_STRIPE_SIZE to
 set STRIPE_SIZE
Date: Thu, 7 May 2020 17:56:58 -0700
Message-ID: <CAPhsuW4qoT-nGA4RvGhxvabkNsz=x_gseWN7hzp4SFCHdsEZTw@mail.gmail.com>
References: <20200421123952.49025-1-yuyufen@huawei.com> <20200421123952.49025-2-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200421123952.49025-2-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Coly Li <colyli@suse.de>, Xiao Ni <xni@redhat.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids

On Tue, Apr 21, 2020 at 5:40 AM Yufen Yu <yuyufen@huawei.com> wrote:
>
[...]
> Thus, we provide a configure to set STRIPE_SIZE when PAGE_SIZE is bigger
> than 4096. Normally, default value (4096) can get relatively good
> performance. But if each issued io is bigger than 4096, setting value more
> than 4096 may get better performance.
>
> Signed-off-by: Yufen Yu <yuyufen@huawei.com>

I am sorry for the delay response.

> ---
>  drivers/md/Kconfig | 18 ++++++++++++++++++
>  drivers/md/raid5.h |  4 +++-
>  2 files changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index d6d5ab23c088..05c5a315358b 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -157,6 +157,24 @@ config MD_RAID456
>
>           If unsure, say Y.
>
> +config MD_RAID456_STRIPE_SIZE
> +       int "RAID4/RAID5/RAID6 stripe size"
> +       default "4096"
> +       depends on MD_RAID456
> +       help
> +         The default value is 4096. Just setting a new value when PAGE_SIZE
> +         is bigger than 4096.  In that case, you can set it as more than
> +         4096, such as 8KB, 16K, 64K, which requires that be a multiple of
> +         4K.
> +
> +         When you try to set a big value, likely 64KB on arm64, that means,
> +         you know size of each io that issued to raid device is more than
> +         4096. Otherwise just use default value.
> +
> +         Normally, using default STRIPE_SIZE can get better performance.
> +         Only change this value if you know what you are doing.
> +
> +
>  config MD_MULTIPATH
>         tristate "Multipath I/O support"
>         depends on BLK_DEV_MD
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index f90e0704bed9..b0010991bdc8 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -472,7 +472,9 @@ struct disk_info {
>   */
>
>  #define NR_STRIPES             256
> -#define STRIPE_SIZE            PAGE_SIZE
> +#define STRIPE_SIZE    \
> +       ((PAGE_SIZE > 4096 && (CONFIG_MD_RAID456_STRIPE_SIZE % 4096 == 0)) ? \
> +        CONFIG_MD_RAID456_STRIPE_SIZE : PAGE_SIZE)

How about we make the config multiple of 4kB? So 4096 will be 1, 8192 will be 2.

Thanks,
Song
