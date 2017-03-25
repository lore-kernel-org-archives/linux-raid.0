From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] md/raid1: skip data copy for behind io for discard request
Date: Sun, 26 Mar 2017 00:30:28 +0800
Message-ID: <CACVXFVOjP-TnsfxwgHm6pBLoERHEm2UWD3_PByneXT9=1RHkkw@mail.gmail.com>
References: <7dd6d110d2eeafaf2980f08e6e0b318be654f72a.1490393962.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7dd6d110d2eeafaf2980f08e6e0b318be654f72a.1490393962.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Mar 25, 2017 at 6:20 AM, Shaohua Li <shli@fb.com> wrote:
> discard request doesn't have data attached, so it's meaningless to
> allocate memory and copy from original bio for behind IO. And the copy
> is bogus because bio_copy_data_partial can't handle discard request.
>
> We don't support writesame/writezeros request so far.
>
> Cc: Ming Lei <tom.leiming@gmail.com>
> Signed-off-by: Shaohua Li <shli@fb.com>

Another way is to not do write behind for discard, but both should be fine, so:

Reviewed-by: Ming Lei <tom.leiming@gmail.com>

> ---
>  drivers/md/raid1.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index c6a671f..b7d9651 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1102,6 +1102,10 @@ static struct bio *alloc_behind_master_bio(struct r1bio *r1_bio,
>         if (!behind_bio)
>                 goto fail;
>
> +       /* discard op, we don't support writezero/writesame yet */
> +       if (!bio_has_data(bio))
> +               goto skip_copy;
> +
>         while (i < vcnt && size) {
>                 struct page *page;
>                 int len = min_t(int, PAGE_SIZE, size);
> @@ -1118,7 +1122,7 @@ static struct bio *alloc_behind_master_bio(struct r1bio *r1_bio,
>
>         bio_copy_data_partial(behind_bio, bio, offset,
>                               behind_bio->bi_iter.bi_size);
> -
> +skip_copy:
>         r1_bio->behind_master_bio = behind_bio;;
>         set_bit(R1BIO_BehindIO, &r1_bio->state);
>
> --
> 2.9.3
>



-- 
Ming Lei
