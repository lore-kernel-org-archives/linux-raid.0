Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C284B4C9B
	for <linux-raid@vger.kernel.org>; Tue, 27 Feb 2024 02:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708999463; cv=none; b=Lb4KwTsDbxmzCr3UbW6LDxVD5noSVbajRYTlFEmj/BSumt8nWKlqBxejGKAeFU8jByR0io+XTKpBY8q9p6FxIyTF/b/qan+OTFNYRHBZYBLzzhyNz4zQa3mKX4taULnQ37XQvO5M2wS+EF3tpTNnWcn092UvxYLziR0X04IsGLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708999463; c=relaxed/simple;
	bh=nrWaqNQIdX6y7Bk5VJr5mLdgl7HbW5P50w18EEVmKLA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dCnomBdteLLWNdEFqajAx/VBBpeJmqCFG6qRFRQhCnv0fLcShr991juQHAAbtMEIy5IkJabGV3HzNheClmG4Hda7zwAKF6PyTngyQMKKK0jdA39FO/B7woKhV3BlvCH0bzdQBQgnW39cb64V4K6+0rkxuAMEBqz1zvRaNH/wHG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FCBL1Poh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FCBL1Poh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708999460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=thi6W3XXynZ5aMUAF7Mak29O3SZT41v2l8f5byno9Fs=;
	b=FCBL1PohQGVqC1x2ojhwEjvl1nJRblBUd2GOxc9BjHg0iYEg0t8r004baHaX/Hf5gMUvPJ
	n/KQQ5uzOZWU/BKvBAgAJdsk7pBJdu6Vk2JNJbYfn35KnmHNjXh6rN3CTGnL7R0sQaOAhq
	PwBq147Cx19uptnoKgVUq89JRYfqChc=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-286-6HuTRofEMaqi-krnC9l2rw-1; Mon, 26 Feb 2024 21:04:19 -0500
X-MC-Unique: 6HuTRofEMaqi-krnC9l2rw-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1dbcbffd853so29599875ad.3
        for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 18:04:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708999458; x=1709604258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=thi6W3XXynZ5aMUAF7Mak29O3SZT41v2l8f5byno9Fs=;
        b=TojAokEXQc17fCZc84HPw1qIcbx1RxxtU4oyEdPGTVD36uhLm4gsWBc0yMwnOT/tkg
         DZZye/sHMsprIQ1mXRKn/4ZOM2L3PW7t6nyUVO5B0L30bEU7vpgzeegb3LNwmzXaTIwW
         u4x4HzadlN/Xc2Gepof/bUM5zl2MEngt2i47xQkhdp14qJECjku85Qg9M+2glkUh9hCI
         aUwhQH2TAMYW5LUyxiiPpKmsMOGXyQINXTo3j9HbbZ5i1FRydPWMTXxhhoCUVFLGDW2F
         0feotxyhbIvWH3h/45bNxtprdOdZykdZw4krJCUFzwQ5rXfr7Cw1Kg/EzqeBHYdj0wAV
         pdbQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfzsO4ImzLjsMW+dwa0tktcbUCHLghfjOV7adBMDYrdunuwb8RGUFmwkET5hHSkb3XUMlT5bb+zQUVHPAIMP6zxTw7aCId0pTzgQ==
X-Gm-Message-State: AOJu0YzlnkjYZ+QU8HhQFs4CIML9sBJesjJr49u6E9MTjS+lTbiPS/q8
	uCLDZwWhkuAVwX8a0hP3vEl//jxtF1R31jqrtDZxEz89/2X5lvxVJ7a5yDJJ21uUyGQb28jXr2X
	52DVDj9A/rLPFcNQ9WL4H9w8ndUayfPr0jGrYvm+PWAryPzWnDDHOzvn8/QnXS7qtRYs1HuJVm5
	9nSgocj1pTgfoS7b5w8BNcWclMg+oI1BxEZQ==
X-Received: by 2002:a17:902:8545:b0:1db:f6b0:92d with SMTP id d5-20020a170902854500b001dbf6b0092dmr7919675plo.6.1708999458221;
        Mon, 26 Feb 2024 18:04:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE0bnSDhpcGxs4XAV4klGsplAA9yIY0uUxUkf8YuK8Rw0Fg7w7of6uDlmCFlpYVKklRKwp3tp020jPOYDmy9rw=
X-Received: by 2002:a17:902:8545:b0:1db:f6b0:92d with SMTP id
 d5-20020a170902854500b001dbf6b0092dmr7919656plo.6.1708999457834; Mon, 26 Feb
 2024 18:04:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222075806.1816400-1-yukuai1@huaweicloud.com> <20240222075806.1816400-10-yukuai1@huaweicloud.com>
In-Reply-To: <20240222075806.1816400-10-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 27 Feb 2024 10:04:06 +0800
Message-ID: <CALTww29ajdNAXQwAYG90HC26b_hZQz=s28nCsJazwkQ+YsW53w@mail.gmail.com>
Subject: Re: [PATCH md-6.9 09/10] md/raid1: factor out the code to manage
 sequential IO
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: paul.e.luse@linux.intel.com, song@kernel.org, neilb@suse.com, shli@fb.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 22, 2024 at 4:05=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
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
>  drivers/md/raid1.c | 71 +++++++++++++++++++++++++---------------------
>  1 file changed, 38 insertions(+), 33 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4694e0e71e36..223ef8d06f67 100644
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
> @@ -767,42 +792,22 @@ static int read_balance(struct r1conf *conf, struct=
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
> -                                * Set 'dist' to 0, so that if there is n=
o other
> -                                * idle disk and all disks are rotational=
, this
> -                                * disk will still be chosen.
> -                                */
> -                               pending++;
> -                               dist =3D 0;
> -                       } else {
> +               if (is_sequential(conf, disk, r1_bio)) {
> +                       if (!should_choose_next(conf, disk)) {
>                                 best_disk =3D disk;
>                                 break;
>                         }
> +
> +                       /*
> +                        * Add 'pending' to avoid choosing this disk if t=
here is
> +                        * other idle disk.
> +                        */
> +                       pending++;
> +                       /*
> +                        * Set 'dist' to 0, so that if there is no other =
idle
> +                        * disk, this disk will still be chosen.
> +                        */
> +                       dist =3D 0;
>                 }
>
>                 if (min_pending > pending) {
> --
> 2.39.2
>
>
Hi
This patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

