From: jiao hui <jiaohui@bwstor.com.cn>
Subject: Re: [PATCH] md/raid1: always set MD_RECOVERY_INTR flag in raid1 error
 handler to avoid potential data corruption
Date: Mon, 28 Jul 2014 16:23:35 +0800
Message-ID: <CAEuG+XKD4qjsozq7szmF-8NmaDWbT=jG9voQSvvuZDDHx1tpPw@mail.gmail.com>
References: <1406534973.21454.3.camel@fedws>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1406534973.21454.3.camel@fedws>
Sender: linux-raid-owner@vger.kernel.org
To: jiao hui <jiaohui@bwstor.com.cn>
Cc: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>, guomingyang <guomingyang@nrchpc.ac.cn>, zhaomeng <zhaomeng@bwstor.com.cn>
List-Id: linux-raid.ids

I reproduce this issue almost each time with a raid1 with considerable
large bitmap-chunk=EF=BC=8C such as 64MB=E3=80=82
I make this patch on Centos7.0=E3=80=82
Any comments are welcome.

On Mon, Jul 28, 2014 at 4:09 PM, jiao hui <jiaohui@bwstor.com.cn> wrote=
:
> From 1fdbfb8552c00af55d11d7a63cdafbdf1749ff63 Mon Sep 17 00:00:00 200=
1
> From: Jiao Hui <simonjiaoh@gmail.com>
> Date: Mon, 28 Jul 2014 11:57:20 +0800
> Subject: [PATCH] md/raid1: always set MD_RECOVERY_INTR flag in raid1 =
error handler to avoid potential data corruption
>
>     In the recovery of raid1 with bitmap, if a bitmap bit has a NEEDE=
D or RESYNC flag,
>     actual resync io will happen. The sync_thread check each rdev, if=
 any rdev is missing
>     or has a FAULTY flag, the array is still_degraded, then the bitma=
p bit NEEDED flag
>     not cleared. Otherwise, we cleared NEEDED flag and set RESYNC fla=
g. The RESYNC flag cleared
>     in bitmap_cond_end_sync or bitmap_close_sync.
>
>     If the only disk which is being recovered fails again when raid1 =
recovery is in progress.
>     The resync_thread can't find a non-In_sync disk to write, then th=
e remaining recovery skipped.
>     RAID1 error handler only set MD_RECOVERY_INTR flag when a In_sync=
 disk fails. But the disk
>     being reocvered is non-In_sync, then md_do_sync can't got the INT=
R singal to break, and the
>     mddev->curr_resync is uptodated to max_sectors (mddev->dev_sector=
s). When raid1 personality
>     tries to finish resync process, no bitmap bit with RESYNC flag ca=
n set back to NEEDED flag,
>     and bitmap_close_sync clear the RESYNC flag. When the disk is add=
ed back, the area from
>     the offset of last recovery to the end of bitmap-chunk is skipped=
 by resync_thread forever.
>
>     Signed-off-by: JiaoHui <jiaohui@bwstor.com.cn>
>
> ---
>  drivers/md/raid1.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index aacf6bf..51d06eb 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1391,16 +1391,16 @@ static void error(struct mddev *mddev, struct=
 md_rdev *rdev)
>                 return;
>         }
>         set_bit(Blocked, &rdev->flags);
> +       /*
> +        * if recovery is running, make sure it aborts.
> +        */
> +       set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>         if (test_and_clear_bit(In_sync, &rdev->flags)) {
>                 unsigned long flags;
>                 spin_lock_irqsave(&conf->device_lock, flags);
>                 mddev->degraded++;
>                 set_bit(Faulty, &rdev->flags);
>                 spin_unlock_irqrestore(&conf->device_lock, flags);
> -               /*
> -                * if recovery is running, make sure it aborts.
> -                */
> -               set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>         } else
>                 set_bit(Faulty, &rdev->flags);
>         set_bit(MD_CHANGE_DEVS, &mddev->flags);
> --
> 1.8.3.1
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
