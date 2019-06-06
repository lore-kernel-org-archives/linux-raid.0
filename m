From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH] md: md.c: Return -ENODEV when mddev is NULL in rdev_attr_show
Date: Thu, 6 Jun 2019 09:41:11 -0700
Message-ID: <CAPhsuW5Ea_bDRwoE7=AamzOsvLMdfQRTPh00iFHNrx8iU5ZOZw@mail.gmail.com>
References: <20190524024459.6875-1-marcos.souza.org@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190524024459.6875-1-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc: open list <linux-kernel@vger.kernel.org>, Shaohua Li <shli@kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, May 23, 2019 at 7:45 PM Marcos Paulo de Souza
<marcos.souza.org@gmail.com> wrote:
>
> Commit c42d3240990814eec1e4b2b93fa0487fc4873aed
> ("md: return -ENODEV if rdev has no mddev assigned") changed rdev_attr_store to
> return -ENODEV when rdev->mddev is NULL, now do the same to rdev_attr_show.

nit: checkpatch.pl complains

WARNING: Possible unwrapped commit description (prefer a maximum 75
chars per line)
#84:
("md: return -ENODEV if rdev has no mddev assigned") changed rdev_attr_store to

I fixed this in my tree, so no need to resend.

Thanks,
Song

>
> Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
> ---
>  drivers/md/md.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 45ffa23fa85d..0b391e7e063b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3363,7 +3363,7 @@ rdev_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
>         if (!entry->show)
>                 return -EIO;
>         if (!rdev->mddev)
> -               return -EBUSY;
> +               return -ENODEV;
>         return entry->show(rdev, page);
>  }
>
> --
> 2.21.0
>
