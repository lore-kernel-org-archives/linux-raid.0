From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH 2/4] md: raid0: Remove return statement from void function
Date: Mon, 20 May 2019 22:53:01 -0700
Message-ID: <CAPhsuW4DWL2OFvn+mdRUwG5J90LsuP=bDUJMhnabvRcz8g-7Fw@mail.gmail.com>
References: <20190520214427.18729-1-marcos.souza.org@gmail.com> <20190520214427.18729-3-marcos.souza.org@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190520214427.18729-3-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc: open list <linux-kernel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 20, 2019 at 2:45 PM Marcos Paulo de Souza
<marcos.souza.org@gmail.com> wrote:
>
> This return statement was introduced in commit
> 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 ("Linux-2.6.12-rc2") and can be
> safely removed.

Wow, that's a really old commit. :)

I think 3/4 and 4/4 of the set makes git-blame more difficult to
follow. Let's not
apply them.

Thanks,
Song

>
> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
> ---
>  drivers/md/raid0.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index f3fb5bb8c82a..42b0287104bd 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -609,7 +609,6 @@ static bool raid0_make_request(struct mddev *mddev, struct bio *bio)
>  static void raid0_status(struct seq_file *seq, struct mddev *mddev)
>  {
>         seq_printf(seq, " %dk chunks", mddev->chunk_sectors / 2);
> -       return;
>  }
>
>  static void *raid0_takeover_raid45(struct mddev *mddev)
> --
> 2.21.0
>
