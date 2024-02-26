Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE20963CB4
	for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 08:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708937750; cv=none; b=EhJ5uvc91f3em6+jQfVg0fHy4s/dd1gakaVoayzXuueSP3BiOtfnSF03HgF+MRh8z5PjJ1CbIBXFS+fXcN/vR52n1PqNdavGO6BHQhpOaS0q7wb2zagE7zNcTr0MFNG+9Fr1BuP8l2UVi4OYeZhtkwAAp94Sq2HXFR/djkJ9f7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708937750; c=relaxed/simple;
	bh=xBTnUv59kWvyLAhqO6KDtlSr9TFDCVXdaXaby5u/6oo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UT4WG9SyWJorXf31yNEHGeN6I6ze3wYD5AWjJh0Xx9GuRHNvRT69En9t5/UDyCEVNj03g5OwyRJquSJirHuyhK0SJh1vSUUkwplsyUHOVjwa6pmwgqj93ydsJZIpARYF1RHZjLi2eRyenF0LwsKthFPo2OnqdEblsH4FOE38YPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TPMlS66z; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TPMlS66z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708937747;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rqFxJuIWHix7xyq/6w8s5WEyjH5VBTqZf1DzXOvHkBA=;
	b=TPMlS66zDNCS4q7q8wF6Zpv4ZlVSXQn5FWgjyw11Oh/QAsu2ubBG+/rWOj6wszFv6l3k+D
	u2r+gR9yxwkoSkyJCW8Szm+4DV4TZokLOKC0z2bnm3YqLGjQouO+PZzJVrm9X4V+2+dgXX
	vt/2NSaqgBJx2ecEY+yA9N1R6u46WaE=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-412-_iJ2rQkaMN6RwAAP5N2e4w-1; Mon, 26 Feb 2024 03:55:44 -0500
X-MC-Unique: _iJ2rQkaMN6RwAAP5N2e4w-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3c1a8342d69so143581b6e.3
        for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 00:55:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708937744; x=1709542544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rqFxJuIWHix7xyq/6w8s5WEyjH5VBTqZf1DzXOvHkBA=;
        b=U05jt8ABdRhiCiI+iSqqOshqH76+dg6M+ALL+SgJeNDfADqbgtYNjJRcQtyHRDhhsT
         dWOnjBskWPFyAR2ATr/ImORsAV7/gJv2sweoYk7vF5c4lBotfxyEGK/0SucsNPQ7EiMq
         EQBkDEw5qU3yyXVy42QFzBLEWaM81lDeEV2XVNvYc5v317Fc/8wMjo1vJ5iph3B1OoOy
         l40LGrBFSKa2d1If0nS4rTUDch5m5t98AbMBxNCaAZJghHIaSAC/J84kFl2Il9DjdCNB
         BckMwy/pY7TaH/ssNf06lpBjf8pOqMiz+dsrX/s5mYrRWl3O4MMzHJzgR9TCnfICXUOr
         Aauw==
X-Forwarded-Encrypted: i=1; AJvYcCXKjId/DU6LDzmXTTZTc9WlVrxH3C+IqZcwofW4RA3wX/NV8NGiiPfKXWnBoylKL+c10IhKyGyziiu9E0ATWlv96FqKQiQ+goIHng==
X-Gm-Message-State: AOJu0YyLqr2GoSXmyXt499bIaoX2JcwiMpPrSOmfDXbSZnc8zTHbYgzV
	PdRY9Jy1treimrIGRCreGSAfmDlmbye3mRrX+mxzXNJ//Zj7WEzNFoFbazEc2K6MJXHJoRrxjO5
	u+X01fI9Go9kgi2Wtet50bkXuFgEGrZCb6R/RV0257LHxznVOV0CUu8/xm9y+l1fA41tCXjuX9I
	WkLeGpruvhPwQJauZnD/Xjq6q6fYHzIza5mg==
X-Received: by 2002:a54:448b:0:b0:3c1:377a:4641 with SMTP id v11-20020a54448b000000b003c1377a4641mr6119097oiv.24.1708937744240;
        Mon, 26 Feb 2024 00:55:44 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHd/1u6ZkqRJcKexqkxWhYXvuE5QCmFyR1ziOVySLmAaEeiRDUp6ISr2Juj+BNOXX8y/30UMjNLezlW6TIsjkw=
X-Received: by 2002:a54:448b:0:b0:3c1:377a:4641 with SMTP id
 v11-20020a54448b000000b003c1377a4641mr6119092oiv.24.1708937744034; Mon, 26
 Feb 2024 00:55:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222075806.1816400-1-yukuai1@huaweicloud.com> <20240222075806.1816400-4-yukuai1@huaweicloud.com>
In-Reply-To: <20240222075806.1816400-4-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 26 Feb 2024 16:55:32 +0800
Message-ID: <CALTww2_g5Sdxh5f=krWiZ1y2y7ud3XaSX5Hhx-mz3AU45c6rGg@mail.gmail.com>
Subject: Re: [PATCH md-6.9 03/10] md/raid1: fix choose next idle in read_balance()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: paul.e.luse@linux.intel.com, song@kernel.org, neilb@suse.com, shli@fb.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kuai

Thanks for the effort!

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

typo error: s/disk/dist/g

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
>    continue
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

There is a problem. If all disks are not idle and there is a disk with
dist=3D0 before the seq disk, it can't read from the seq disk. It will
read from the first disk with dist=3D0. Maybe we can only add the codes
which are removed from 2e52d449bcec?

Best Regards
Xiao

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
> --
> 2.39.2
>
>

