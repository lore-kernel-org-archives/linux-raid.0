From: Song Liu <song@kernel.org>
Subject: Re: [PATCH v5 04/16] md/raid5: add a member of r5pages for struct stripe_head
Date: Thu, 2 Jul 2020 15:56:57 -0700
Message-ID: <CAPhsuW4rcsOz49teDi_MzHTir7euoA21sYxZf=jo0_F=aRHcdg@mail.gmail.com>
References: <20200702120628.777303-1-yuyufen@huawei.com> <20200702120628.777303-5-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200702120628.777303-5-yuyufen@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yufen Yu <yuyufen@huawei.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.com>, Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, Hou Tao <houtao1@huawei.com>
List-Id: linux-raid.ids

On Thu, Jul 2, 2020 at 5:05 AM Yufen Yu <yuyufen@huawei.com> wrote:
>
> Since grow_buffers() uses alloc_page() to allocate the buffers for
> each stripe_head(), means, it will allocate 64K buffers and just use
> 4K of them, after setting stripe_size as 4096.
>
> To avoid wasting memory, we try to contain multiple 'page' of sh->dev
> into one real page. That means, multiple sh->dev[i].page will point to
> the only page with different offset. Example of 64K PAGE_SIZE and
> 4K stripe_size as following:
>
>                     64K PAGE_SIZE
>           +---+---+---+---+------------------------------+
>           |   |   |   |   |
>           |   |   |   |   |
>           +-+-+-+-+-+-+-+-+------------------------------+
>             ^   ^   ^   ^
>             |   |   |   +----------------------------+
>             |   |   |                                |
>             |   |   +-------------------+            |
>             |   |                       |            |
>             |   +----------+            |            |
>             |              |            |            |
>             +-+            |            |            |
>               |            |            |            |
>         +-----+-----+------+-----+------+-----+------+------+
> sh      | offset(0) | offset(4K) | offset(8K) | offset(12K) |
>  +      +-----------+------------+------------+-------------+
>  +----> dev[0].page  dev[1].page  dev[2].page  dev[3].page
>
> After trying to share one page, the users of sh->dev[i].page need to
> take care:
>
>   1) When issue bio into stripe_head, bi_io_vec.bv_page will point to
>      the page directly. So, we should make sure bv_offset to been set
>      with correct offset.
>
>   2) When compute xor, the page will be passed to computer function.
>      So, we also need to pass offset of that page to computer. Let it
>      compute correct location of each sh->dev[i].page.
>
> This patch will add a new member of r5pages into stripe_head to manage
> all pages needed by each sh->dev[i]. We also add 'offset' for each r5dev
> so that users can get related page offset easily. And add helper function
> to get page and it's index in r5pages array by disk index.
>
> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
> ---
>  drivers/md/raid5.h | 61 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 61 insertions(+)
>
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 98698569370c..61fe26061c92 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -246,6 +246,13 @@ struct stripe_head {
>                 int                  target, target2;
>                 enum sum_check_flags zero_sum_result;
>         } ops;
> +
> +       /* These pages will be used by bios in dev[i] */
> +       struct r5pages {
> +               struct page     **page;
> +               int     size; /* page array size */
> +       } pages;
> +

struct r5pages seems unnecessary. How about we just use
     struct page **pages;
     int nr_pages;


>         struct r5dev {
>                 /* rreq and rvec are used for the replacement device when
>                  * writing data to both devices.
> @@ -253,6 +260,7 @@ struct stripe_head {
>                 struct bio      req, rreq;
>                 struct bio_vec  vec, rvec;
>                 struct page     *page, *orig_page;
> +               unsigned int    offset;         /* offset of this page */
>                 struct bio      *toread, *read, *towrite, *written;
>                 sector_t        sector;                 /* sector of this page */
>                 unsigned long   flags;
> @@ -754,6 +762,59 @@ r5_next_bio(struct r5conf *conf, struct bio *bio, sector_t sector)
>                 return NULL;
>  }
>
> +/*
> + * Return corresponding page index of r5pages array.
> + */
> +static inline int raid5_get_page_index(struct stripe_head *sh, int disk_idx)
> +{
> +       struct r5conf *conf = sh->raid_conf;
> +       int cnt;
> +
> +       WARN_ON(!sh->pages.page);
> +       BUG_ON(conf->stripe_size > PAGE_SIZE);

We have too many of these WARN_ON() and BUG_ON().

> +
> +       cnt = PAGE_SIZE / conf->stripe_size;

Maybe add cnt (with different name) to r5conf?

> +       return disk_idx / cnt;
> +}
> +
> +/*
> + * Return offset of the corresponding page for r5dev.
> + */
> +static inline int raid5_get_page_offset(struct stripe_head *sh, int disk_idx)
> +{
> +       struct r5conf *conf = sh->raid_conf;
> +       int cnt;
> +
> +       WARN_ON(!sh->pages.page);
> +       BUG_ON(conf->stripe_size > PAGE_SIZE);
> +
> +       cnt = PAGE_SIZE / conf->stripe_size;
> +       return (disk_idx % cnt) * conf->stripe_size;
> +}
> +
> +/*
> + * Return corresponding page address for r5dev.
> + */
> +static inline struct page *
> +raid5_get_dev_page(struct stripe_head *sh, int disk_idx)
> +{
> +       int idx;
> +
> +       WARN_ON(!sh->pages.page);
> +       idx = raid5_get_page_index(sh, disk_idx);
> +       return sh->pages.page[idx];
> +}
> +
> +/*
> + * We want to let multiple buffers to share one real page for
> + * stripe_head when PAGE_SIZE is biggger than stripe_size. If
> + * they are equal, no need to use this strategy.
> + */
> +static inline int raid5_stripe_pages_shared(struct r5conf *conf)
> +{
> +       return conf->stripe_size < PAGE_SIZE;
> +}
> +
>  extern void md_raid5_kick_device(struct r5conf *conf);
>  extern int raid5_set_cache_size(struct mddev *mddev, int size);
>  extern sector_t raid5_compute_blocknr(struct stripe_head *sh, int i, int previous);
> --
> 2.25.4
>
