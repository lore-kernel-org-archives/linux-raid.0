Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293051DDF6
	for <linux-raid@vger.kernel.org>; Wed, 28 Feb 2024 01:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709085401; cv=none; b=PV53QaRarqtYPkK/rnQ4yiHxjeUDB8KInMNYVE0AdjjD8gCtx+xygCH8j7byNViTccfsbJw73DdLVB6Tjh0PzePZ7F5jkeaLmWAKXTBDutXRCRHtq1+hDhoAE+d3m4iMS2RtKdp5wcFqDOVVTf0H7N9gkpPtGn0fVXs+BBX0I1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709085401; c=relaxed/simple;
	bh=M30Tj3t5lTZv786f+bXW/0GU7BTmjZeW6hKWvgtwyds=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eKTmHcJzYq0KqIrDyVYUie2oiW7XIhSzPvJLXDHl2x/HmmJbdH75ASwit1X0U21m2zu6mPrIIgkUstyibJ1LR81D8aLAtEBvzklRrUH69QihSpcCkMSaDNQd5wQ1Z2GXk3h6MrVulh9R1QT3Ryqq3ckeTF4uXLhidTHp0cx5MMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gd/K7kLc; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gd/K7kLc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709085398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XHsJ7e3BatoYAGnNUg/1QAkgMUz1VE3RchWUpq3AxE4=;
	b=Gd/K7kLclIQd5y1u3IkFZFpdhj7i5d0hyhHEOQAkBeUzUYqHsKKyCLtFjFqJk9DRcgOgRR
	w6bUr9rPuuEjQgW2B9ZbNVm41pEhqSdONDCy+syHsC7lNEzsCSjk20lZfTiaL/5dj45sNb
	F7KEMotji5IZlXtXCZ2okGdSk+Et9q8=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-216-jcNDBHJMOzqyRPzFbDiNhw-1; Tue, 27 Feb 2024 20:56:36 -0500
X-MC-Unique: jcNDBHJMOzqyRPzFbDiNhw-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5ca4ee5b97aso3174607a12.1
        for <linux-raid@vger.kernel.org>; Tue, 27 Feb 2024 17:56:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709085395; x=1709690195;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XHsJ7e3BatoYAGnNUg/1QAkgMUz1VE3RchWUpq3AxE4=;
        b=hYHWg86v+JceVxUt23sWomOZFQRHACBHUFAYfISC+PxYxOTNz0tsdMK2Zzs/1H9qte
         cOV6TrG7t1CVzdaDIANjOQVGeJwnKmtCEbUmaKpWoWKY65kphf2MbdziLE/WCVxXAoFe
         Zv7L9Vw7HvIUVL1nsGoFQXanZ8XqhkUOCmWQmmpk86VXdycZdTOESULlppg4L3jMKHIy
         CtRVtCN42KiWts3CRF/6QybVA6YXKZQVO7RSS/Bix3+XmCc3yiefmTjyNwx4X5YAdawK
         5mNZIx7mnRE8+DeVfH5gYK6xWYOQm9n3M12m31ps++v+T7Yzjpb0bp5IvfoH3j9aYbbd
         8gZg==
X-Forwarded-Encrypted: i=1; AJvYcCVgtN/33D4ak2/He4UUHLz+ED5RCjS7C+AQHE1ZtXKcbppW8sLTAahwV7UBIqCKOk5rVk+t5rarhiV/+qpGcaiApyBevwwMTYLipA==
X-Gm-Message-State: AOJu0YySmb4+paZlct81tKrcX+ZY0zln6xRzsZ1orHJlfBHfK3Y7tvAh
	Ken8Ykf5nI19j9i4Dj7xSuFMrlg1mNexRlB6uz1QVFPgPBHQemkKm3hueJR+JdTOeWp+jVwOFSB
	OPTD+kOZtlOXAdCIQYWb9XwhO5h8nGLh8WDrbKRbXIfBHf0FACVxrmyzzKpXzZcnhp8KtiJDgnq
	EApwZPBYewkTpO3S6tGPQmoqt7FMbgf0HRMg==
X-Received: by 2002:a05:6a20:7829:b0:1a0:ee92:b6d2 with SMTP id a41-20020a056a20782900b001a0ee92b6d2mr3070407pzg.14.1709085395313;
        Tue, 27 Feb 2024 17:56:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG93uOJZ4Fv/BAmZEPHmiM+Cbhv2k8uPCwWC3HGvqCkG7nJ9jZxvmGjMwUnDZwWUZ2qSStnGq2ny3Rr38uV/x0=
X-Received: by 2002:a05:6a20:7829:b0:1a0:ee92:b6d2 with SMTP id
 a41-20020a056a20782900b001a0ee92b6d2mr3070399pzg.14.1709085395014; Tue, 27
 Feb 2024 17:56:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240227120327.1432511-1-yukuai1@huaweicloud.com> <20240227120327.1432511-3-yukuai1@huaweicloud.com>
In-Reply-To: <20240227120327.1432511-3-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 28 Feb 2024 09:56:24 +0800
Message-ID: <CALTww29DXbnhPF241WUbaibFS_aF3jZR8HiuBuj94+hCFUCgOA@mail.gmail.com>
Subject: Re: [PATCH md-6.9 v2 02/10] md/raid1: record nonrot rdevs while
 adding/removing rdevs to conf
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: paul.e.luse@linux.intel.com, song@kernel.org, shli@fb.com, neilb@suse.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 27, 2024 at 8:09=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> For raid1, each read will iterate all the rdevs from conf and check if
> any rdev is non-rotational, then choose rdev with minimal IO inflight
> if so, or rdev with closest distance otherwise.
>
> Disk nonrot info can be changed through sysfs entry:
>
> /sys/block/[disk_name]/queue/rotational
>
> However, consider that this should only be used for testing, and user
> really shouldn't do this in real life. Record the number of non-rotationa=
l
> disks in conf, to avoid checking each rdev in IO fast path and simplify
> read_balance() a little bit.
>
> Co-developed-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.h    |  1 +
>  drivers/md/raid1.c | 17 ++++++++++-------
>  drivers/md/raid1.h |  1 +
>  3 files changed, 12 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index a49ab04ab707..b2076a165c10 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -207,6 +207,7 @@ enum flag_bits {
>                                  * check if there is collision between ra=
id1
>                                  * serial bios.
>                                  */
> +       Nonrot,                 /* non-rotational device (SSD) */
>  };
>
>  static inline int is_badblock(struct md_rdev *rdev, sector_t s, int sect=
ors,
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index a145fe48b9ce..0fed01b06de9 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -599,7 +599,6 @@ static int read_balance(struct r1conf *conf, struct r=
1bio *r1_bio, int *max_sect
>         int sectors;
>         int best_good_sectors;
>         int best_disk, best_dist_disk, best_pending_disk;
> -       int has_nonrot_disk;
>         int disk;
>         sector_t best_dist;
>         unsigned int min_pending;
> @@ -620,7 +619,6 @@ static int read_balance(struct r1conf *conf, struct r=
1bio *r1_bio, int *max_sect
>         best_pending_disk =3D -1;
>         min_pending =3D UINT_MAX;
>         best_good_sectors =3D 0;
> -       has_nonrot_disk =3D 0;
>         choose_next_idle =3D 0;
>         clear_bit(R1BIO_FailFast, &r1_bio->state);
>
> @@ -637,7 +635,6 @@ static int read_balance(struct r1conf *conf, struct r=
1bio *r1_bio, int *max_sect
>                 sector_t first_bad;
>                 int bad_sectors;
>                 unsigned int pending;
> -               bool nonrot;
>
>                 rdev =3D conf->mirrors[disk].rdev;
>                 if (r1_bio->bios[disk] =3D=3D IO_BLOCKED
> @@ -703,8 +700,6 @@ static int read_balance(struct r1conf *conf, struct r=
1bio *r1_bio, int *max_sect
>                         /* At least two disks to choose from so failfast =
is OK */
>                         set_bit(R1BIO_FailFast, &r1_bio->state);
>
> -               nonrot =3D bdev_nonrot(rdev->bdev);
> -               has_nonrot_disk |=3D nonrot;
>                 pending =3D atomic_read(&rdev->nr_pending);
>                 dist =3D abs(this_sector - conf->mirrors[disk].head_posit=
ion);
>                 if (choose_first) {
> @@ -731,7 +726,7 @@ static int read_balance(struct r1conf *conf, struct r=
1bio *r1_bio, int *max_sect
>                          * small, but not a big deal since when the secon=
d disk
>                          * starts IO, the first disk is likely still busy=
.
>                          */
> -                       if (nonrot && opt_iosize > 0 &&
> +                       if (test_bit(Nonrot, &rdev->flags) && opt_iosize =
> 0 &&
>                             mirror->seq_start !=3D MaxSector &&
>                             mirror->next_seq_sect > opt_iosize &&
>                             mirror->next_seq_sect - opt_iosize >=3D
> @@ -763,7 +758,7 @@ static int read_balance(struct r1conf *conf, struct r=
1bio *r1_bio, int *max_sect
>          * mixed ratation/non-rotational disks depending on workload.
>          */
>         if (best_disk =3D=3D -1) {
> -               if (has_nonrot_disk || min_pending =3D=3D 0)
> +               if (READ_ONCE(conf->nonrot_disks) || min_pending =3D=3D 0=
)
>                         best_disk =3D best_pending_disk;
>                 else
>                         best_disk =3D best_dist_disk;
> @@ -1819,6 +1814,11 @@ static int raid1_add_disk(struct mddev *mddev, str=
uct md_rdev *rdev)
>                 WRITE_ONCE(p[conf->raid_disks].rdev, rdev);
>         }
>
> +       if (!err && bdev_nonrot(rdev->bdev)) {
> +               set_bit(Nonrot, &rdev->flags);
> +               WRITE_ONCE(conf->nonrot_disks, conf->nonrot_disks + 1);
> +       }
> +

Hi Kuai

I noticed raid1_run->setup_conf is used to add rdev to conf when
creating raid1. raid1_add_disk is only used for --add/--re-add after
creating array. So we need to add the same logic in setup_conf?

Regards
Xiao
>         print_conf(conf);
>         return err;
>  }
> @@ -1883,6 +1883,9 @@ static int raid1_remove_disk(struct mddev *mddev, s=
truct md_rdev *rdev)
>         }
>  abort:
>
> +       if (test_and_clear_bit(Nonrot, &rdev->flags))
> +               WRITE_ONCE(conf->nonrot_disks, conf->nonrot_disks - 1);
> +
>         print_conf(conf);
>         return err;
>  }
> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> index 14d4211a123a..5300cbaa58a4 100644
> --- a/drivers/md/raid1.h
> +++ b/drivers/md/raid1.h
> @@ -71,6 +71,7 @@ struct r1conf {
>                                                  * allow for replacements=
.
>                                                  */
>         int                     raid_disks;
> +       int                     nonrot_disks;
>
>         spinlock_t              device_lock;
>
> --
> 2.39.2
>

