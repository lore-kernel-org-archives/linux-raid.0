From: Song Liu <song@kernel.org>
Subject: Re: [PATCH v3 01/11] md/raid5: add CONFIG_MD_RAID456_STRIPE_SHIFT to
 set STRIPE_SIZE
Date: Thu, 28 May 2020 07:23:35 -0700
Message-ID: <CAPhsuW7JLcWDEwEcN-6c+NHhMD1qrPtPNPa-k8y9SX3bVX_FzA@mail.gmail.com>
References: <20200527131933.34400-1-yuyufen@huawei.com> <20200527131933.34400-2-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200527131933.34400-2-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Coly Li <colyli@suse.de>, Xiao Ni <xni@redhat.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids

On Wed, May 27, 2020 at 6:20 AM Yufen Yu <yuyufen@huawei.com> wrote:
>
[...]
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index f90e0704bed9..b25f107dafc7 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -472,7 +472,9 @@ struct disk_info {
>   */
>
>  #define NR_STRIPES             256
> -#define STRIPE_SIZE            PAGE_SIZE
> +#define CONFIG_STRIPE_SIZE     (CONFIG_MD_RAID456_STRIPE_SHIFT << 9)
> +#define STRIPE_SIZE            \
> +       (CONFIG_STRIPE_SIZE > PAGE_SIZE ? PAGE_SIZE : CONFIG_STRIPE_SIZE)
>  #define STRIPE_SHIFT           (PAGE_SHIFT - 9)

I think we also need to update STRIPE_SHIFT.

Thanks,
Song
