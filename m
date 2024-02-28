Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CD71C2AD
	for <linux-raid@vger.kernel.org>; Wed, 28 Feb 2024 02:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709087286; cv=none; b=tHiU7eeY/rUun0ItyeYVeQevG0O+A4eEi0NRFez27aFeekTFuB4wz9DpKeuKQ+pDNMqShvkEdmolKNHQ9+FzWhXI6GBr63jJABr92CDtL0zRsKfUhAl3kcu5rNzOEFrsx4rEWmOL9ovNC4ePzu3YQvmbOMT5Zp/EZb1N+5b7pLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709087286; c=relaxed/simple;
	bh=nZ78NxNzK7U9mK+nUgVZ10ZxdDryNRXooqpPaXVcKPA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VAeXN/hbBBAkEN6tVuGYGSqvlDZBGDqnvont8+G7+sJH1x9oyTo0MJAP4brGpQMnJ+Ik2F9hVo8ylmnejz6eF3jzAVILHn70WvGiwJ6A0R4Y/bDDzQzCoNZs11EftiK3O7DkA8axJA5tVdbjMQo23yFqCRMaNw80xS3CVKmrpv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Eka92/X6; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eka92/X6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709087283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t71JisMPrekak0Zx0BWeUZoF4CXW6G6b306wfjsDGBI=;
	b=Eka92/X67rqiDhk6cG2kpiQDblixXWl33Bw8hOT5CSBRmmzT9VhQPOdL3dEyH/PN3wYsjr
	bhyQM0ocV25numhK6kjariPgJtBexc8lG9O6e9/eF5qv9L3tXw2kh6rcGdOGWKV3LAYJfE
	EyrPLk53amitrJsmh38cId8aX9bD26c=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-148-d8VJrZPINfeFLEhfw28LBg-1; Tue, 27 Feb 2024 21:28:02 -0500
X-MC-Unique: d8VJrZPINfeFLEhfw28LBg-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-29a82907e96so4114734a91.2
        for <linux-raid@vger.kernel.org>; Tue, 27 Feb 2024 18:28:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709087281; x=1709692081;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t71JisMPrekak0Zx0BWeUZoF4CXW6G6b306wfjsDGBI=;
        b=Kp2t/Z8mCFZuQBRwGcTTHT6InEX9lBXULJkwz/RPrrssS+DVOwDH2K71pVOJwkBhSm
         JU/80xRCXPOgEpf1FMqFExCCTDneZlIrtbOOZiWF6zK3jSSNdFCZLHhhLmumhr1GRNtI
         yifRTpfxuwBTCLsoUf/e0XH5gJrPRQkUhjCrbGV83DpMJL+QrEB00FfJrByz0YISZFaL
         4MXaQzgaJfPUBXOspVfsZpiZ8zPtsdzb03IuQ9X0W1QoGplt0xwgFySPi/Z54uWzd5j7
         Hv4a8ePcnI1jmg85IfaAATZR0qzQMZLMSeyQVDWqNj1oYKrwGHTQv9n3/eDS65GMKoJO
         AgZA==
X-Forwarded-Encrypted: i=1; AJvYcCUcl3fqD4vuudyZs205N9UHW9icotNUeWCFqviJEJp0MaJy1CuwgLwKxhIVUeLsY2n89AXRD2tAUW8zK1HWl3W7ayFxjefn3ySf4Q==
X-Gm-Message-State: AOJu0Yzscn3WGcJSm3o325GpngmHv48Cf0xirrtrMYfVjN0Buc9egBsk
	rrSYTVwszh/xFdIA92gmowUw5IEUid7Q8YX4SuyIyxZoNNVIslwl6GOERWUD2GNqP/Pv9y0q9CP
	FqeToFwQZD0cIro13SMGGpCsTd1yxKBArj4oNbeor7/nXit1+3bED/jZYUJ5JGxXKznVHrl2Ag2
	V1SOEfm4gA0uQ3ZpXlTVCOC+QdA2VrP8uxcz75gemxcZm0
X-Received: by 2002:a17:90a:e285:b0:29a:b645:9661 with SMTP id d5-20020a17090ae28500b0029ab6459661mr6460145pjz.30.1709087280948;
        Tue, 27 Feb 2024 18:28:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEzD5Xb2Y5kKOKd77MJNlqw9r0blN/w+Lq3LTse8+JvDRD2yTk6NH23+8chYnwqdIn5a70B79G4qjxDbzv09Cg=
X-Received: by 2002:a17:90a:e285:b0:29a:b645:9661 with SMTP id
 d5-20020a17090ae28500b0029ab6459661mr6460131pjz.30.1709087280705; Tue, 27 Feb
 2024 18:28:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240227120327.1432511-1-yukuai1@huaweicloud.com> <20240227120327.1432511-10-yukuai1@huaweicloud.com>
In-Reply-To: <20240227120327.1432511-10-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 28 Feb 2024 10:27:49 +0800
Message-ID: <CALTww29v_aOjiPzcxGCgayv+11JCyy_zT=7HZNzPsYWeRLP-SQ@mail.gmail.com>
Subject: Re: [PATCH md-6.9 v2 09/10] md/raid1: factor out the code to manage
 sequential IO
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
> There is no functional change for now, make read_balance() cleaner and
> prepare to fix problems and refactor the handler of sequential IO.
>
> Co-developed-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/raid1.c | 71 ++++++++++++++++++++++++----------------------
>  1 file changed, 37 insertions(+), 34 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 76bb59ad1485..d3e9a0157437 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -705,6 +705,31 @@ static int choose_slow_rdev(struct r1conf *conf, str=
uct r1bio *r1_bio,
>         return bb_disk;
>  }
>
> +static bool is_sequential(struct r1conf *conf, int disk, struct r1bio *r=
1_bio)
> +{
> +       /* TODO: address issues with this check and concurrency. */
> +       return conf->mirrors[disk].next_seq_sect =3D=3D r1_bio->sector ||
> +              conf->mirrors[disk].head_position =3D=3D r1_bio->sector;
> +}
> +
> +/*
> + * If buffered sequential IO size exceeds optimal iosize, check if there=
 is idle
> + * disk. If yes, choose the idle disk.
> + */
> +static bool should_choose_next(struct r1conf *conf, int disk)
> +{
> +       struct raid1_info *mirror =3D &conf->mirrors[disk];
> +       int opt_iosize;
> +
> +       if (!test_bit(Nonrot, &mirror->rdev->flags))
> +               return false;
> +
> +       opt_iosize =3D bdev_io_opt(mirror->rdev->bdev) >> 9;
> +       return opt_iosize > 0 && mirror->seq_start !=3D MaxSector &&
> +              mirror->next_seq_sect > opt_iosize &&
> +              mirror->next_seq_sect - opt_iosize >=3D mirror->seq_start;
> +}
> +
>  /*
>   * This routine returns the disk from which the requested read should
>   * be done. There is a per-array 'next expected sequential IO' sector
> @@ -768,43 +793,21 @@ static int read_balance(struct r1conf *conf, struct=
 r1bio *r1_bio, int *max_sect
>                 pending =3D atomic_read(&rdev->nr_pending);
>                 dist =3D abs(this_sector - conf->mirrors[disk].head_posit=
ion);
>                 /* Don't change to another disk for sequential reads */
> -               if (conf->mirrors[disk].next_seq_sect =3D=3D this_sector
> -                   || dist =3D=3D 0) {
> -                       int opt_iosize =3D bdev_io_opt(rdev->bdev) >> 9;
> -                       struct raid1_info *mirror =3D &conf->mirrors[disk=
];
> -
> -                       /*
> -                        * If buffered sequential IO size exceeds optimal
> -                        * iosize, check if there is idle disk. If yes, c=
hoose
> -                        * the idle disk. read_balance could already choo=
se an
> -                        * idle disk before noticing it's a sequential IO=
 in
> -                        * this disk. This doesn't matter because this di=
sk
> -                        * will idle, next time it will be utilized after=
 the
> -                        * first disk has IO size exceeds optimal iosize.=
 In
> -                        * this way, iosize of the first disk will be opt=
imal
> -                        * iosize at least. iosize of the second disk mig=
ht be
> -                        * small, but not a big deal since when the secon=
d disk
> -                        * starts IO, the first disk is likely still busy=
.
> -                        */
> -                       if (test_bit(Nonrot, &rdev->flags) && opt_iosize =
> 0 &&
> -                           mirror->seq_start !=3D MaxSector &&
> -                           mirror->next_seq_sect > opt_iosize &&
> -                           mirror->next_seq_sect - opt_iosize >=3D
> -                           mirror->seq_start) {
> -                               /*
> -                                * Add 'pending' to avoid choosing this d=
isk if
> -                                * there is other idle disk.
> -                                */
> -                               pending++;
> -                               /*
> -                                * If there is no other idle disk, this d=
isk
> -                                * will be chosen.
> -                                */
> -                               sequential_disk =3D disk;
> -                       } else {
> +               if (is_sequential(conf, disk, r1_bio)) {
> +                       if (!should_choose_next(conf, disk)) {
>                                 best_disk =3D disk;
>                                 break;
>                         }
> +                       /*
> +                        * Add 'pending' to avoid choosing this disk if
> +                        * there is other idle disk.
> +                        */
> +                       pending++;
> +                       /*
> +                        * If there is no other idle disk, this disk
> +                        * will be chosen.
> +                        */
> +                       sequential_disk =3D disk;
>                 }
>
>                 if (min_pending > pending) {
> --
> 2.39.2
>
Hi all
This patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

