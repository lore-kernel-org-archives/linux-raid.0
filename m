From: Song Liu <song@kernel.org>
Subject: Re: [PATCH] md: improve io stats accounting
Date: Mon, 1 Jun 2020 23:48:45 -0700
Message-ID: <CAPhsuW4fjc4NgFGQUPuAKSvtWvtzyPor876anj64NF=nqaPo5g@mail.gmail.com>
References: <20200601161256.27718-1-artur.paszkiewicz@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200601161256.27718-1-artur.paszkiewicz@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Artur,

Thanks for the patch.

On Mon, Jun 1, 2020 at 9:13 AM Artur Paszkiewicz
<artur.paszkiewicz@intel.com> wrote:
>
> Use generic io accounting functions to manage io stats. There was an
[...]

> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
>  drivers/md/md.c | 65 +++++++++++++++++++++++++++++++++++++++----------
>  drivers/md/md.h |  1 +
>  2 files changed, 53 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f567f536b529..5a9f167ef5b9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -463,12 +463,32 @@ void md_handle_request(struct mddev *mddev, struct bio *bio)
>  }
>  EXPORT_SYMBOL(md_handle_request);
>
>

[...]

>
> -       /*
> -        * save the sectors now since our bio can
> -        * go away inside make_request
> -        */
> -       sectors = bio_sectors(bio);
> +       if (bio->bi_pool != &mddev->md_io_bs) {
> +               struct bio *clone;
> +               struct md_io *md_io;
> +
> +               clone = bio_clone_fast(bio, GFP_NOIO, &mddev->md_io_bs);

Handle clone == NULL?

Also, have you done benchmarks with this change?

Song
