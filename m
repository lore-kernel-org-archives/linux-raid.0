Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6977C185B4C
	for <linux-raid@vger.kernel.org>; Mon, 23 Dec 2024 07:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734939123; cv=none; b=TAsiOXUZxl4Hc3qrXfVry/vBLGhckCIdf9brviwP5uAlhbs5IaoK9ygCLIzFGKriIYGqjSbXjF2aX525o4+zo/we8TaeCpmck6YMnk7bZ9i4iN4YU6dH5p/UWNInH19oFeqEBlKzH/oVraC3H3VGwzX1P6T97Xoo/fpniQYrdx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734939123; c=relaxed/simple;
	bh=bY4zuFqSK2nKiZEBevmmIlXN/DwukzK5gMiFThUt8wY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iTQtbZD/tcaHA75yOjloafflP2D5DCiL7GVje2+HTtFj6ymJcbXE9tT4JVNIFXXMNPSh2ZVjmy4fp0+fR2sMWTBYkSquOa4I/xmT5y7sMS7582MA1Ajb7Mw29NVjuFTIh0QXU7hPHmZYmkJathEUvf0WnHVqmhinnKhFFed3SNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a+MjQGhH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a+MjQGhH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734939120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x6s2tlXbx9mbFN9zse1Uz6CiZQwLhmvQZY2rHYals3M=;
	b=a+MjQGhHxOReOquqo30fkRh3VFFPdIqQq+Dc8eapGOdBovv4n0fN4DdTzr0QYZC6/WTiDc
	jEVcwXtT6Hd7NiYDuKH+LJ+ew9fuzPaxefHbKhcwp3rJATzNCpjzExebOJGvMf7A/dPnDy
	NS6ymydtvLg/IyITI6+ZFSypkMda4uo=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-634-76gZLLTRPeWyJpu2LOuYdw-1; Mon, 23 Dec 2024 02:31:58 -0500
X-MC-Unique: 76gZLLTRPeWyJpu2LOuYdw-1
X-Mimecast-MFC-AGG-ID: 76gZLLTRPeWyJpu2LOuYdw
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-53f167e95e6so976542e87.1
        for <linux-raid@vger.kernel.org>; Sun, 22 Dec 2024 23:31:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734939116; x=1735543916;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x6s2tlXbx9mbFN9zse1Uz6CiZQwLhmvQZY2rHYals3M=;
        b=cZDE0na7afd2YFIuyi7qsDm3n/R6LsIWIGfdvS17JSaSlo+1X2AugvlBu1nR0DqTJQ
         rh+hg0/wjOhXGsWXU+z1EUt9C/w3FfHa2F22MMgROquIlAHerb7EqYEx55/ucJCmA7k2
         IqeHeabtmP9leJ9ahYeqz2VWoQcZOIGK4liGwf4ka/Qi1bpil/34IBooJVoJCeEzEZWy
         U2/q7Lve4Z1Q2ZIryu2qMdX3uTDjA8Of+c+bDT3cXd14ti4ZIc8EVtgQokAyL+FN+fUt
         uBU0Hy534R5c/uJKWpgukmIeWdpnX1oSKW9N4j9ik3hh95G3bTHoASE+zr+0jAnPJm5N
         7SBg==
X-Forwarded-Encrypted: i=1; AJvYcCX32QX0IWXGG6E+3ibuVKlI5rlFfHvgBE2BWKhRfgOB9Qw7nhE+oWeB/MYtETjV5u8Jj98aOFRSIWhr@vger.kernel.org
X-Gm-Message-State: AOJu0YxRQNEGxGaoKFiJviCPT0ADloqfm53Blw+jc+ATsDCsu+0GCx9L
	1acLjJlwAW2Nha8/avIPrQ18edEf6Kl3vuIrI/IM4sRKkW3MPu8e4czEULZwxS2QnUPaoC8McQZ
	xz3Q7PkfnhTJeQpNkY3fjpvsKYmXsIOWRuLRBQu4AREA3MuPaHso6ZvMeJGHO9plwVCsF4E4CSA
	laOU3BX05Xvpce+NEsV2GO+iZ8+BcKnWNcMm31hkfNIJHxXP0=
X-Gm-Gg: ASbGncsOmWxkVaD5hP+y13VuzJ0hNq9wtatB6eX9+FBR31McYO30ezUXU7csQMUbK8s
	NtOBHrgjJ7n/M49vgBkxFcmTTUC0mH7DYlZFtYFQ=
X-Received: by 2002:ac2:4c56:0:b0:542:1b97:3db8 with SMTP id 2adb3069b0e04-542294256edmr3377227e87.5.1734939115927;
        Sun, 22 Dec 2024 23:31:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHmAoZGzMOza12YaYBXMZaqW0nFLK8xLvlrJpl0lsVKSZwC3sS5YWpQ+1Bvp49Gkjoonhg7GvBzNvGj/JCyUUA=
X-Received: by 2002:ac2:4c56:0:b0:542:1b97:3db8 with SMTP id
 2adb3069b0e04-542294256edmr3377217e87.5.1734939115503; Sun, 22 Dec 2024
 23:31:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241218121745.2459-1-yukuai@kernel.org> <20241218121745.2459-3-yukuai@kernel.org>
In-Reply-To: <20241218121745.2459-3-yukuai@kernel.org>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 23 Dec 2024 15:31:43 +0800
Message-ID: <CALTww2-nXW5Uv=+z0LHPvSkJMs7bTqoiWOE+8bKJrpf6XEB1-g@mail.gmail.com>
Subject: Re: [PATCH v2 md-6.14 2/5] md/md-bitmap: remove the last parameter
 for bimtap_ops->endwrite()
To: yukuai@kernel.org
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@hauwei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 18, 2024 at 8:21=E2=80=AFPM <yukuai@kernel.org> wrote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> It is useless, because for the case IO failed for one rdev:
>
> - If badblocks is set and rdev is not faulty, there is no need to
>  mark the bit as NEEDED;


Hi Kuai

It's better to add some comments before here. Before this patch, it's
easy to understand. It needs to set bitmap bit when a write request
fails. With this patch, there are some hidden logics here. To me, it's
not easy to maintain in the future. And in man mdadm, there is no-bbl
option, so it looks like an array may not have a bad block. And I
don't know how dmraid maintain badblock. So this patch needs to be
more careful.

Regards
Xiao

> - If rdev is faulty, then mddev->degraded will be set, and we can use
> it to mard the bit as NEEDED;
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Yu Kuai <yukuai@kernel.org>
> ---
>  drivers/md/md-bitmap.c   | 19 ++++++++++---------
>  drivers/md/md-bitmap.h   |  2 +-
>  drivers/md/raid1.c       |  3 +--
>  drivers/md/raid10.c      |  3 +--
>  drivers/md/raid5-cache.c |  3 +--
>  drivers/md/raid5.c       |  9 +++------
>  6 files changed, 17 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 84fb4cc67d5e..b40a84b01085 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -1726,7 +1726,7 @@ static int bitmap_startwrite(struct mddev *mddev, s=
ector_t offset,
>  }
>
>  static void bitmap_endwrite(struct mddev *mddev, sector_t offset,
> -                           unsigned long sectors, bool success)
> +                           unsigned long sectors)
>  {
>         struct bitmap *bitmap =3D mddev->bitmap;
>
> @@ -1745,15 +1745,16 @@ static void bitmap_endwrite(struct mddev *mddev, =
sector_t offset,
>                         return;
>                 }
>
> -               if (success && !bitmap->mddev->degraded &&
> -                   bitmap->events_cleared < bitmap->mddev->events) {
> -                       bitmap->events_cleared =3D bitmap->mddev->events;
> -                       bitmap->need_sync =3D 1;
> -                       sysfs_notify_dirent_safe(bitmap->sysfs_can_clear)=
;
> -               }
> -
> -               if (!success && !NEEDED(*bmc))
> +               if (!bitmap->mddev->degraded) {
> +                       if (bitmap->events_cleared < bitmap->mddev->event=
s) {
> +                               bitmap->events_cleared =3D bitmap->mddev-=
>events;
> +                               bitmap->need_sync =3D 1;
> +                               sysfs_notify_dirent_safe(
> +                                               bitmap->sysfs_can_clear);
> +                       }
> +               } else if (!NEEDED(*bmc)) {
>                         *bmc |=3D NEEDED_MASK;
> +               }
>
>                 if (COUNTER(*bmc) =3D=3D COUNTER_MAX)
>                         wake_up(&bitmap->overflow_wait);
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index e87a1f493d3c..31c93019c76b 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -92,7 +92,7 @@ struct bitmap_operations {
>         int (*startwrite)(struct mddev *mddev, sector_t offset,
>                           unsigned long sectors);
>         void (*endwrite)(struct mddev *mddev, sector_t offset,
> -                        unsigned long sectors, bool success);
> +                        unsigned long sectors);
>         bool (*start_sync)(struct mddev *mddev, sector_t offset,
>                            sector_t *blocks, bool degraded);
>         void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *=
blocks);
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 15ba7a001f30..81dff2cea0db 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -423,8 +423,7 @@ static void close_write(struct r1bio *r1_bio)
>         if (test_bit(R1BIO_BehindIO, &r1_bio->state))
>                 mddev->bitmap_ops->end_behind_write(mddev);
>         /* clear the bitmap if all writes complete successfully */
> -       mddev->bitmap_ops->endwrite(mddev, r1_bio->sector, r1_bio->sector=
s,
> -                                   !test_bit(R1BIO_Degraded, &r1_bio->st=
ate));
> +       mddev->bitmap_ops->endwrite(mddev, r1_bio->sector, r1_bio->sector=
s);
>         md_write_end(mddev);
>  }
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index c3a93b2a26a6..3dc0170125b2 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -429,8 +429,7 @@ static void close_write(struct r10bio *r10_bio)
>         struct mddev *mddev =3D r10_bio->mddev;
>
>         /* clear the bitmap if all writes complete successfully */
> -       mddev->bitmap_ops->endwrite(mddev, r10_bio->sector, r10_bio->sect=
ors,
> -                                   !test_bit(R10BIO_Degraded, &r10_bio->=
state));
> +       mddev->bitmap_ops->endwrite(mddev, r10_bio->sector, r10_bio->sect=
ors);
>         md_write_end(mddev);
>  }
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 4c7ecdd5c1f3..ba4f9577c737 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -314,8 +314,7 @@ void r5c_handle_cached_data_endio(struct r5conf *conf=
,
>                         set_bit(R5_UPTODATE, &sh->dev[i].flags);
>                         r5c_return_dev_pending_writes(conf, &sh->dev[i]);
>                         conf->mddev->bitmap_ops->endwrite(conf->mddev,
> -                                       sh->sector, RAID5_STRIPE_SECTORS(=
conf),
> -                                       !test_bit(STRIPE_DEGRADED, &sh->s=
tate));
> +                                       sh->sector, RAID5_STRIPE_SECTORS(=
conf));
>                 }
>         }
>  }
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 93cc7e252dd4..6eb2841ce28c 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3664,8 +3664,7 @@ handle_failed_stripe(struct r5conf *conf, struct st=
ripe_head *sh,
>                 }
>                 if (bitmap_end)
>                         conf->mddev->bitmap_ops->endwrite(conf->mddev,
> -                                       sh->sector, RAID5_STRIPE_SECTORS(=
conf),
> -                                       false);
> +                                       sh->sector, RAID5_STRIPE_SECTORS(=
conf));
>                 bitmap_end =3D 0;
>                 /* and fail all 'written' */
>                 bi =3D sh->dev[i].written;
> @@ -3711,8 +3710,7 @@ handle_failed_stripe(struct r5conf *conf, struct st=
ripe_head *sh,
>                 }
>                 if (bitmap_end)
>                         conf->mddev->bitmap_ops->endwrite(conf->mddev,
> -                                       sh->sector, RAID5_STRIPE_SECTORS(=
conf),
> -                                       false);
> +                                       sh->sector, RAID5_STRIPE_SECTORS(=
conf));
>                 /* If we were in the middle of a write the parity block m=
ight
>                  * still be locked - so just clear all R5_LOCKED flags
>                  */
> @@ -4062,8 +4060,7 @@ static void handle_stripe_clean_event(struct r5conf=
 *conf,
>                                         wbi =3D wbi2;
>                                 }
>                                 conf->mddev->bitmap_ops->endwrite(conf->m=
ddev,
> -                                       sh->sector, RAID5_STRIPE_SECTORS(=
conf),
> -                                       !test_bit(STRIPE_DEGRADED, &sh->s=
tate));
> +                                       sh->sector, RAID5_STRIPE_SECTORS(=
conf));
>                                 if (head_sh->batch_head) {
>                                         sh =3D list_first_entry(&sh->batc=
h_list,
>                                                               struct stri=
pe_head,
> --
> 2.43.0
>
>

