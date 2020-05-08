From: Song Liu <song@kernel.org>
Subject: Re: [PATCH RFC v2 2/8] md/raid5: add a member of r5pages for struct stripe_head
Date: Fri, 8 May 2020 16:58:07 -0700
Message-ID: <CAPhsuW4GxrgnToy=7HowOmWKBOqySdY=-n1KO-fYV+Thof7mtw@mail.gmail.com>
References: <20200421123952.49025-1-yuyufen@huawei.com> <20200421123952.49025-3-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200421123952.49025-3-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Coly Li <colyli@suse.de>, Xiao Ni <xni@redhat.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids

On Tue, Apr 21, 2020 at 5:40 AM Yufen Yu <yuyufen@huawei.com> wrote:
>
[...]
> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
> ---
> +
> +/*
> + * We want to 'compress' multiple buffers to one real page for
> + * stripe_head when PAGE_SIZE is biggger than STRIPE_SIZE. If their
> + * values are equal, no need to use this strategy. For now, it just
> + * support raid level less than 5.
> + */

I don't think "compress" is the right terminology here. It is more
like "share" a page.
Why not support raid6 here?

Overall, the set looks reasonable to me. Please revise and send another version.

Thanks,
Song



> +static inline int raid5_compress_stripe_pages(struct r5conf *conf)
> +{
> +       return (PAGE_SIZE > STRIPE_SIZE) && (conf->level < 6);
> +}
> +
>  extern void md_raid5_kick_device(struct r5conf *conf);
>  extern int raid5_set_cache_size(struct mddev *mddev, int size);
>  extern sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous);
> --
> 2.21.1
>
