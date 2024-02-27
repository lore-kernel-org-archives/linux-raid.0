Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45443125D5
	for <linux-raid@vger.kernel.org>; Tue, 27 Feb 2024 02:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709000646; cv=none; b=u7h4velELkcxeD1ZTml/moB3/ZIS+jiSM7sPltrWnrYgmU7MUcZ0v9sZnY4EZDWiaKEz948YfQplkWXfcuB6osYfrZ9K6uGcGeezNk8FWL+Bha6Vdamj4XyFrhxLLzJZxOakBn8o1s/zJjGuFCKNIbr4hWtnzJwlxIrnqX4ZZFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709000646; c=relaxed/simple;
	bh=m9TooM0cwnkc1+bq/BZQz6Huvr9O8nSycpXXvh/YqOA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XuNMoCvfbYNd2WdGG4D9PmcYu+w7fgt0zVtIa+EM4EhS3Ei2WV87ZN9Iwl4ON3EL+XDRR3dNTaMRAQ0cQrpuSRTwqNjBnaz9G/1dzh4YPBzDIBjUCZVMDO9QgJADuCRFXHg3rNQLFbTL5v6n1R3szVAmcnWwL58P9Q2hOiodvRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dcxavdAy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dcxavdAy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709000643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b5a16VMzkMT+MI17+9HmctoPRzIdjNSYPO8LyTflFu8=;
	b=dcxavdAySRlTE8rS6gXghWuJsueEmy4MRCj5T1rNWA3EnE6CMpj2WWUtAWXxe5dpVXUeb/
	Z8DpaOV66puQjr9kr//YQzYp6Y8NmhfphU88hVVcTxphZZtJLRy/YwBQZ0YqnY9tpcJnwm
	WvRmum/0Qljy2+m9sbVCr6YYeWtyK+s=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-h1Q19cLOPE6ZPlMjQo5jZA-1; Mon, 26 Feb 2024 21:24:00 -0500
X-MC-Unique: h1Q19cLOPE6ZPlMjQo5jZA-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5dc91de351fso3033936a12.0
        for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 18:24:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709000639; x=1709605439;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b5a16VMzkMT+MI17+9HmctoPRzIdjNSYPO8LyTflFu8=;
        b=diRktje0Vn5aCEaoZPdGKEud2qTMjvg8QLTuy60AFZ/rCir23c5RIyybTUb3jTXL/9
         cJm93RWWc0W2Wch7JaI3iKzvVSB4yeDnSCp0xWx1obFqnfHKJ1Dr5Ek+YcIaAorFhmP8
         EeFARN5cezUGigP7PhWcvvMy/M+yATs8c7cCL/bMUpDe7+fUePh1ZooNI+JGY5OxAnNl
         ErC7Fx5qL6p1DPeDmxkjJWFLRUb0wizlH6gTAu/1A2XSIZzcT+nLUF9ICcjVFWoJSXwJ
         ek6s+bIoeI6kBeVNqlI8oxKKCqkbQAXewkiUyAXxsGu/SDzVCkcjAhtVLiHiY7HXoTBA
         hTcw==
X-Forwarded-Encrypted: i=1; AJvYcCW/Gh20OgqAfMfFV+ALYRGp6qybJiqL8seRxLRm95TURqM4N2deby9o0eh94STpbpzQlXisLVOxgXnAuzcraFt4qldBOWuJ3/N98A==
X-Gm-Message-State: AOJu0YzCt+pwKechSHOxM7elJzwY3+zFAMQrLu3/z5Y70O2Wsyg2hXih
	EjK+DQNj52IuXKKrrbKnHU95W8jz1xxDAPG4YXlszkKWxKSMkVNIHDIsETAq83g9821jlEUBJde
	GHVMbbSpqbDwDwJBDsS2GCWF/HsqsGMh5mH0mxeSGJ71ORT8havBd3XydNCATHaDraW/12gI1vr
	tg19PGcqKCCm4Ry24T0DJ7C6t6hEl39S+fKg==
X-Received: by 2002:a17:902:e80b:b0:1db:cf57:7bb5 with SMTP id u11-20020a170902e80b00b001dbcf577bb5mr11038998plg.8.1709000639585;
        Mon, 26 Feb 2024 18:23:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH2vR9IwZQtWVoU6U3/SjKZ8ZS/OalZUG08cBdNDdLWZI/Ab/k/lnPrNwQq62u5FRx2fTQoVN7MKOs91473uyI=
X-Received: by 2002:a17:902:e80b:b0:1db:cf57:7bb5 with SMTP id
 u11-20020a170902e80b00b001dbcf577bb5mr11038983plg.8.1709000639281; Mon, 26
 Feb 2024 18:23:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222075806.1816400-1-yukuai1@huaweicloud.com> <20240222075806.1816400-4-yukuai1@huaweicloud.com>
In-Reply-To: <20240222075806.1816400-4-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 27 Feb 2024 10:23:47 +0800
Message-ID: <CALTww28PJPdqRkSEarwATG5GmkuMmEtT0La5s-9c9r5UPy4siA@mail.gmail.com>
Subject: Re: [PATCH md-6.9 03/10] md/raid1: fix choose next idle in read_balance()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: paul.e.luse@linux.intel.com, song@kernel.org, neilb@suse.com, shli@fb.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 22, 2024 at 4:04=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Commit 12cee5a8a29e ("md/raid1: prevent merging too large request") add
> the case choose next idle in read_balance():
>
> read_balance:
>  for_each_rdev
>   if(next_seq_sect =3D=3D this_sector || disk =3D=3D 0)
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
> 3) set 'dist' to 0 so that if there is no other idle disk, and all disks
>    are rotational, this disk will still be chosen;
>
> Fixes: 2e52d449bcec ("md/raid1: add failfast handling for reads.")
> Co-developed-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/raid1.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index c60ea58ae8c5..d0bc67e6d068 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -604,7 +604,6 @@ static int read_balance(struct r1conf *conf, struct r=
1bio *r1_bio, int *max_sect
>         unsigned int min_pending;
>         struct md_rdev *rdev;
>         int choose_first;
> -       int choose_next_idle;
>
>         /*
>          * Check if we can balance. We can balance on the whole
> @@ -619,7 +618,6 @@ static int read_balance(struct r1conf *conf, struct r=
1bio *r1_bio, int *max_sect
>         best_pending_disk =3D -1;
>         min_pending =3D UINT_MAX;
>         best_good_sectors =3D 0;
> -       choose_next_idle =3D 0;
>         clear_bit(R1BIO_FailFast, &r1_bio->state);
>
>         if ((conf->mddev->recovery_cp < this_sector + sectors) ||
> @@ -712,7 +710,6 @@ static int read_balance(struct r1conf *conf, struct r=
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
> @@ -731,15 +728,21 @@ static int read_balance(struct r1conf *conf, struct=
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
> +                                * Set 'dist' to 0, so that if there is n=
o other
> +                                * idle disk and all disks are rotational=
, this
> +                                * disk will still be chosen.
> +                                */
> +                               pending++;
> +                               dist =3D 0;
> +                       } else {
> +                               best_disk =3D disk;
> +                               break;
>                         }
> -                       break;
>                 }

Hi Kuai

I noticed something. In patch 12cee5a8a29e, it sets best_disk if it's
a sequential read. If there are no other idle disks, it will read from
the sequential disk. With this patch, it reads from the
best_pending_disk even min_pending is not 0. It looks like a wrong
behaviour?

Best Regards
Xiao
>
> -               if (choose_next_idle)
> -                       continue;
> -
>                 if (min_pending > pending) {
>                         min_pending =3D pending;
>                         best_pending_disk =3D disk;
> --
> 2.39.2
>
>

