Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277392564
	for <linux-raid@vger.kernel.org>; Wed, 28 Feb 2024 02:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709086610; cv=none; b=u6NfALp3owjRBYi5JPjdOwClDG+1PFtFP4bML7HBhbRLT/UtLO4Y7fNI0KwwXQDtjhkLtcCDZMsFY1cWOFLkRJtbD2FMeaXIQPV7LhLPVFsbKboefxV6+LmnBXsuHCo9frDop1FMnXTzaf1nLaIUXl+Wd4k9I5BHBW7EppD/qqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709086610; c=relaxed/simple;
	bh=GU6ixNluhekxEtguIZCgo3Jij5X4BX3MefMauv26ads=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y8Vj5J869vgeua8yO9ioln7XmzWfeJkQK7/f0toxdkjtFio/hIPBT2AmKe7XJUYlQ0Y8IoN8Lr8X7F99OaNoDt/Sn/tTH3eGHm3uQMZ+oleuMAAsutWQ13+qYns/X2J/DoyHtV3WfD/rnJ+gXmp0BECeKQO+ipoFcF1rTq3Srig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UqSRvQM0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UqSRvQM0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709086606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lpYcWRZAYcWyDGupbKfQvhkHsOCQxOvJTZyhHpXeFOw=;
	b=UqSRvQM0U0LNrc/4F9Ab6PuCYSTm/czOxX5xzWvWxnkWJo8Y/trSFFOiwHKprBsQLtmFHh
	cMkJMfff+P53/xe816NOO3hP2/HlYw7x6piWwKVMhygQPdQVremG01OF+Bgzn/3u01XVSO
	IZ3eox75XFuct++tRXY9/o+RuoYS1TY=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-418-hC1ch_0ZNWeztAEp5QtTuA-1; Tue, 27 Feb 2024 21:16:44 -0500
X-MC-Unique: hC1ch_0ZNWeztAEp5QtTuA-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1dcb989a738so3538275ad.1
        for <linux-raid@vger.kernel.org>; Tue, 27 Feb 2024 18:16:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709086604; x=1709691404;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lpYcWRZAYcWyDGupbKfQvhkHsOCQxOvJTZyhHpXeFOw=;
        b=v7688tA+Frc44jgHgjvXxyEzAYyiQ9hMwkWPeH99drlSgweKNUlqn89l39AGL2Vz3v
         XARVd/aeDc0/F/+1XPQOZ0bY0Dy78xrt1b34PfUbLPb4knBZeizxosBd8wcudFvczI6W
         bT2TSV469u3ZKN6ghHoVpWcRk5zU0GYsiceJuLLJ/oT4u99LVEkujkGao15//CB+2FfI
         7BC5JrAkU2suGlho0CmngzBbwNrkFJS8/0b1VRQ7aCKrSZ46Nc8UDDApo++l71Gxayo8
         10xW09lIlyvSC0RXi4UmXBl8qd3aHqNmnbY7XrdXC3KjJZpAHBCAje+Z3ZOi7fkkLMxe
         tt2g==
X-Forwarded-Encrypted: i=1; AJvYcCUSdjZAeluDXbYFPKcAZe/qEhR4KxM3Sp6lD68kzTSN/xZjMfvIB9AHUTjupkoGCb/F/i8d0/78oO97xgGOxDNO1ha04476mBeLEw==
X-Gm-Message-State: AOJu0YwqZZOjpPxfSMMjoa9rdJWd83Moegvk3ogvm5+2phba8Zdxx5zN
	N0+VMZ0cujrLQjkY6yiD5PI5ZJYETOl22ueVd1oOywyhWUKwto5JfPFKPLL/7iHRHDdjzmEWmIj
	erineTHjeCYa6JoQkR/GghDl/fB5I2+39o9FenKovo2DsSTZPgMZ2DJSfRlNWxA7DTJ8pes/mHn
	CxOUqtqAi71uU/N7HXXZod2pqtiXPzCpYEiQ==
X-Received: by 2002:a17:902:d507:b0:1dc:b968:780e with SMTP id b7-20020a170902d50700b001dcb968780emr1677166plg.33.1709086603700;
        Tue, 27 Feb 2024 18:16:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG+ZX9Ky9Z6Yf4BZTSh+Ppsxgoif1PhJQwkAriev3uyxs8YMIgEtnIhXGEvf0RFK457opUj8dIr6/n+eNBrvUs=
X-Received: by 2002:a17:902:d507:b0:1dc:b968:780e with SMTP id
 b7-20020a170902d50700b001dcb968780emr1677147plg.33.1709086603389; Tue, 27 Feb
 2024 18:16:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240227120327.1432511-1-yukuai1@huaweicloud.com> <20240227120327.1432511-4-yukuai1@huaweicloud.com>
In-Reply-To: <20240227120327.1432511-4-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 28 Feb 2024 10:16:32 +0800
Message-ID: <CALTww2-4OGrfpPWnVq8-7qrZnc39hnvee3smsvs2vWymXLV38g@mail.gmail.com>
Subject: Re: [PATCH md-6.9 v2 03/10] md/raid1: fix choose next idle in read_balance()
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
> Commit 12cee5a8a29e ("md/raid1: prevent merging too large request") add
> the case choose next idle in read_balance():
>
> read_balance:
>  for_each_rdev
>   if(next_seq_sect =3D=3D this_sector || dist =3D=3D 0)
>   -> sequential reads
>    best_disk =3D disk;
>    if (...)
>     choose_next_idle =3D 1
>     continue;
>
>  for_each_rdev
>  -> iterate next rdev
>   if (pending =3D=3D 0)
>    best_disk =3D disk;
>    -> choose the next idle disk
>    break;
>
>   if (choose_next_idle)
>    -> keep using this rdev if there are no other idle disk
>    contine
>
> However, commit 2e52d449bcec ("md/raid1: add failfast handling for reads.=
")
> remove the code:
>
> -               /* If device is idle, use it */
> -               if (pending =3D=3D 0) {
> -                       best_disk =3D disk;
> -                       break;
> -               }
>
> Hence choose next idle will never work now, fix this problem by
> following:
>
> 1) don't set best_disk in this case, read_balance() will choose the best
>    disk after iterating all the disks;
> 2) add 'pending' so that other idle disk will be chosen;
> 3) add a new local variable 'sequential_disk' to record the disk, and if
>    there is no other idle disk, 'sequential_disk' will be chosen;
>
> Fixes: 2e52d449bcec ("md/raid1: add failfast handling for reads.")
> Co-developed-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/raid1.c | 32 ++++++++++++++++++++++----------
>  1 file changed, 22 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 0fed01b06de9..fc5899fb08c1 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -598,13 +598,12 @@ static int read_balance(struct r1conf *conf, struct=
 r1bio *r1_bio, int *max_sect
>         const sector_t this_sector =3D r1_bio->sector;
>         int sectors;
>         int best_good_sectors;
> -       int best_disk, best_dist_disk, best_pending_disk;
> +       int best_disk, best_dist_disk, best_pending_disk, sequential_disk=
;
>         int disk;
>         sector_t best_dist;
>         unsigned int min_pending;
>         struct md_rdev *rdev;
>         int choose_first;
> -       int choose_next_idle;
>
>         /*
>          * Check if we can balance. We can balance on the whole
> @@ -615,11 +614,11 @@ static int read_balance(struct r1conf *conf, struct=
 r1bio *r1_bio, int *max_sect
>         sectors =3D r1_bio->sectors;
>         best_disk =3D -1;
>         best_dist_disk =3D -1;
> +       sequential_disk =3D -1;
>         best_dist =3D MaxSector;
>         best_pending_disk =3D -1;
>         min_pending =3D UINT_MAX;
>         best_good_sectors =3D 0;
> -       choose_next_idle =3D 0;
>         clear_bit(R1BIO_FailFast, &r1_bio->state);
>
>         if ((conf->mddev->recovery_cp < this_sector + sectors) ||
> @@ -712,7 +711,6 @@ static int read_balance(struct r1conf *conf, struct r=
1bio *r1_bio, int *max_sect
>                         int opt_iosize =3D bdev_io_opt(rdev->bdev) >> 9;
>                         struct raid1_info *mirror =3D &conf->mirrors[disk=
];
>
> -                       best_disk =3D disk;
>                         /*
>                          * If buffered sequential IO size exceeds optimal
>                          * iosize, check if there is idle disk. If yes, c=
hoose
> @@ -731,15 +729,22 @@ static int read_balance(struct r1conf *conf, struct=
 r1bio *r1_bio, int *max_sect
>                             mirror->next_seq_sect > opt_iosize &&
>                             mirror->next_seq_sect - opt_iosize >=3D
>                             mirror->seq_start) {
> -                               choose_next_idle =3D 1;
> -                               continue;
> +                               /*
> +                                * Add 'pending' to avoid choosing this d=
isk if
> +                                * there is other idle disk.
> +                                */
> +                               pending++;
> +                               /*
> +                                * If there is no other idle disk, this d=
isk
> +                                * will be chosen.
> +                                */
> +                               sequential_disk =3D disk;
> +                       } else {
> +                               best_disk =3D disk;
> +                               break;
>                         }
> -                       break;
>                 }
>
> -               if (choose_next_idle)
> -                       continue;
> -
>                 if (min_pending > pending) {
>                         min_pending =3D pending;
>                         best_pending_disk =3D disk;
> @@ -751,6 +756,13 @@ static int read_balance(struct r1conf *conf, struct =
r1bio *r1_bio, int *max_sect
>                 }
>         }
>
> +       /*
> +        * sequential IO size exceeds optimal iosize, however, there is n=
o other
> +        * idle disk, so choose the sequential disk.
> +        */
> +       if (best_disk =3D=3D -1 && min_pending !=3D 0)
> +               best_disk =3D sequential_disk;
> +
>         /*
>          * If all disks are rotational, choose the closest disk. If any d=
isk is
>          * non-rotational, choose the disk with less pending request even=
 the
> --
> 2.39.2
>
Hi all
This patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

