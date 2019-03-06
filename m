From: Song Liu <liu.song.a23@gmail.com>
Subject: Re: [PATCH] md: Fix failed allocation of md_register_thread
Date: Wed, 6 Mar 2019 08:58:04 -0800
Message-ID: <CAPhsuW4+2r+CV71JGL6_0Cxn0aDeuLDg7Bhma51tS7RpR9fZpg@mail.gmail.com>
References: <20190304224854.12494-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190304224854.12494-1-pakki001@umn.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Shaohua Li <shli@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 4, 2019 at 2:50 PM Aditya Pakki <pakki001@umn.edu> wrote:
>
> mddev->sync_thread can be set to NULL on kzalloc failure downstream.
> The patch checks for such a scenario and frees allocated resources.
>
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>

This looks good. Could you please add a "Fixed:" tag?

Thanks,
Song

> ---
>  drivers/md/raid10.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index abb5d382f64d..f52b4d9bcd24 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3939,6 +3939,8 @@ static int raid10_run(struct mddev *mddev)
>                 set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
>                 mddev->sync_thread = md_register_thread(md_do_sync, mddev,
>                                                         "reshape");
> +               if (!mddev->sync_thread)
> +                       goto out_free_conf;
>         }
>
>         return 0;
> --
> 2.17.1
>
