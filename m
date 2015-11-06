From: Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH 2/8] mmc: handle add_disk() return value
Date: Fri, 6 Nov 2015 17:03:25 +0100
Message-ID: <CAPDyKFrAvodcmUL8V+84gFGMdLJjGonpEXU2FnaO6FAw=5x-dQ@mail.gmail.com>
References: <437969438-9181-1-git-send-email-vishnu.ps@samsung.com>
	<1446812535-10567-1-git-send-email-vishnu.ps@samsung.com>
	<1446812535-10567-2-git-send-email-vishnu.ps@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1446812535-10567-2-git-send-email-vishnu.ps@samsung.com>
Sender: linux-ide-owner@vger.kernel.org
To: Vishnu Pratap Singh <vishnu.ps@samsung.com>
Cc: Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, "David S. Miller" <davem@davemloft.net>, neilb@suse.com, Takashi Iwai <tiwai@suse.de>, hare@suse.de, ming.lei@canonical.com, jarod@redhat.com, viro@zeniv.linux.org.uk, Tejun Heo <tj@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>, Jon Hunter <jonathanh@nvidia.com>, Grant Grundler <grundler@chromium.org>, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc <linux-mmc@vger.kernel.org>, "cpgs ." <cpgs@samsung.com>, vishu13285@gmail.com, pintu.k@samsung.com, rohit.kr@samsung.com
List-Id: linux-raid.ids

On 6 November 2015 at 13:22, Vishnu Pratap Singh <vishnu.ps@samsung.com> wrote:
> This patch handles  add_disk() return value.
> Earlier add_disk() function doesn't handle error
> cases, now it is added, so the callers of this function
> should also handle it.
>
> Verfied on X86 based ubuntu machine.
> This patch depends on [PATCH 1/8] block/genhd.c: Add error handling

Please remove these two lines from the change log.

Still it's great that you provide this information while posting the
patches, but you can do that by adding text between the sign-off-by
and "---". Just add a new line consisting of "---" and then add you
text below it.

>
> Signed-off-by: Vishnu Pratap Singh <vishnu.ps@samsung.com>
> ---
>  drivers/mmc/card/block.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
> index 23b6c8e..543c670 100644
> --- a/drivers/mmc/card/block.c
> +++ b/drivers/mmc/card/block.c
> @@ -2432,7 +2432,10 @@ static int mmc_add_disk(struct mmc_blk_data *md)
>         int ret;
>         struct mmc_card *card = md->queue.card;
>
> -       add_disk(md->disk);
> +       ret = add_disk(md->disk);
> +       if (ret)
> +               goto add_disk_fail;

You don't need a goto here. Please just do "return ret;" as I think it
makes code easier.

> +
>         md->force_ro.show = force_ro_show;
>         md->force_ro.store = force_ro_store;
>         sysfs_attr_init(&md->force_ro.attr);
> @@ -2468,7 +2471,7 @@ power_ro_lock_fail:
>         device_remove_file(disk_to_dev(md->disk), &md->force_ro);
>  force_ro_fail:
>         del_gendisk(md->disk);
> -
> +add_disk_fail:
>         return ret;
>  }
>
> --
> 1.9.1
>

Kind regards
Uffe
