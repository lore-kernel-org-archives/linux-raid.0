From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH] md-linear: use struct_size() in kzalloc()
Date: Mon, 7 Jan 2019 15:01:21 -0800
Message-ID: <CAPhsuW7a_F_K1cJdrGHLhnuCdpeN365n1BG-QawmxKWaZajGeA@mail.gmail.com>
References: <20190107174538.GA7255@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190107174538.GA7255@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jan 7, 2019 at 10:35 AM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> One of the more common cases of allocation size calculations is finding the
> size of a structure that has a zero-sized array at the end, along with memory
> for some number of elements for that array. For example:
>
> struct foo {
>     int stuff;
>     void *entry[];
> };
>
> instance = kzalloc(sizeof(struct foo) + sizeof(void *) * count, GFP_KERNEL);
>
> Instead of leaving these open-coded and prone to type mistakes, we can now
> use the new struct_size() helper:
>
> instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);
>
> This code was detected with the help of Coccinelle.
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  drivers/md/md-linear.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> index d45c697c0ebe..5998d78aa189 100644
> --- a/drivers/md/md-linear.c
> +++ b/drivers/md/md-linear.c
> @@ -96,8 +96,7 @@ static struct linear_conf *linear_conf(struct mddev *mddev, int raid_disks)
>         int i, cnt;
>         bool discard_supported = false;
>
> -       conf = kzalloc (sizeof (*conf) + raid_disks*sizeof(struct dev_info),
> -                       GFP_KERNEL);
> +       conf = kzalloc(struct_size(conf, disks, raid_disks), GFP_KERNEL);
>         if (!conf)
>                 return NULL;
>
> --
> 2.20.1
>
