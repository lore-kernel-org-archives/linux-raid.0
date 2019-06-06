From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH] md: raid10: Use struct_size() in kmalloc()
Date: Thu, 6 Jun 2019 09:51:09 -0700
Message-ID: <CAPhsuW5cBSsQemfBOyJ_kPLFbaiES8Koh2cvpy9AV4dMB68OJA@mail.gmail.com>
References: <20190604224418.GA23187@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190604224418.GA23187@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jun 4, 2019 at 3:47 PM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> One of the more common cases of allocation size calculations is finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
>
> struct foo {
>    int stuff;
>    struct boo entry[];
> };
>
> instance = kmalloc(size, GFP_KERNEL);
>
> Instead of leaving these open-coded and prone to type mistakes, we can
> now use the new struct_size() helper:
>
> instance = kmalloc(struct_size(instance, entry, count), GFP_KERNEL);
>
> This code was detected with the help of Coccinelle.
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Applied to my md-next tree.

Thanks,
Song

> ---
>  drivers/md/raid10.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index aea11476fee6..3caafd433163 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4780,8 +4780,7 @@ static int handle_reshape_read_error(struct mddev *mddev,
>         int idx = 0;
>         struct page **pages;
>
> -       r10b = kmalloc(sizeof(*r10b) +
> -              sizeof(struct r10dev) * conf->copies, GFP_NOIO);
> +       r10b = kmalloc(struct_size(r10b, devs, conf->copies), GFP_NOIO);
>         if (!r10b) {
>                 set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>                 return -ENOMEM;
> --
> 2.21.0
>
