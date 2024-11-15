Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DD616A956;
	Fri, 15 Nov 2024 18:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731694797; cv=none; b=Qt4fvSWyA2vIaVarr4NCHpQLwU70SMCS9YNAJ2cltyG1/KNrQg5nRzz5TvdY/pyWIdoz4r0b80aaEMIS9t4wCELkrgSUYwroLTsTTZTe+myio2NEa+B6F5X/gDZGUOAnlc1MILNxHDaW72n1I94ikyIHU7TQfhSPtRU6yjVX8F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731694797; c=relaxed/simple;
	bh=jEHg9Jrc7N9nOTJAGsOnQqFd7YCh1peV7IhURNb7O/A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bMdq4DwhPPj/z1OczdyCh26qWShH05Cfnb28QsiNWU9i8N2IWvCK8bvPHcmQcDL08ar7VlBROrygvharVLl34DhJpY7hRFs0IWadyk0vLHW2leIbGZH69XDtcDkVWQmjc0EKpu6S42NBQZHvSlK1oVBH2F0gDAV6ZifZz4QDNA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ll3B7RpA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ll3B7RpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA4CC4CED6;
	Fri, 15 Nov 2024 18:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731694796;
	bh=jEHg9Jrc7N9nOTJAGsOnQqFd7YCh1peV7IhURNb7O/A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Ll3B7RpAClMKxVOgaKH06KffJRyuHZKK3D1XfJQyTeZ3STCatTHm0Wc6LvIbLvUxV
	 2phzlli4xMFSY6v4LTQMnHp+nwSKRfD8I0xOLJWS7i7K0RIV5IXd7z/ObgWu0QPR01
	 szOZ7hya9iBWU+0to5tghIZJG95p6R8Z2UY3H3nVh2KAu6GbAD44vMJb7RG1WL8WXY
	 00soHgyjyvHgHtZ4Qmk8HpMZLxuJqRpVRQJEaxYN9tTDiFCBS0rhBaUmWR/08BU/Jz
	 yVjOxpS9/7bAHRFfdrBlX3P3MByf/etJ6FI88xfOU5b71/G6W6O7VzqQfMOb26t+I/
	 YUt0aqtZBlS/Q==
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3a4e5a7b026so3058195ab.3;
        Fri, 15 Nov 2024 10:19:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUV765LGyStfRkFYrGuC7OK5Fdt5gwUuirz5y9e4YWxKgYmE3c+3rzNFAA+vuOQgzxrI+s0LRnWB3NorqGJ@vger.kernel.org, AJvYcCWu5gtBJrenmhObZlvh3+Xbi60fDd5VEPf52zaMUWFGJpn4QfMY9GfG/H7EV2EJQPMwV3CW8BHAYV1eMA==@vger.kernel.org, AJvYcCXZTgQpO+uxCHqmgPnyJIak9w2XtwC6yNewIyDg8IZUSckdVOkVQiLwhPJgReMZJ+5+ChiwAtIvYOnwDA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYOD2lfGnOwbc4fGRE3oMepcE/rB9RR2wZLC9eM2+MlHW4DeyN
	t4YqsnPNk7jhfuVCTh55G9N6g4a4RRlRnSEl7nvHboCDmAMTANGjXE+S33mdR95Dc/sjVJTGBPT
	MRkhqNVo+IgbIcuGPJsPjWEkf9Ok=
X-Google-Smtp-Source: AGHT+IHKNv1rYC+zz4Cii6bXK7MNqshpluCyaThnmk06bBl2Az82hVcP1DoYGi7z0Uyi7iayM3tR7OYNqZcUsJz9f9Y=
X-Received: by 2002:a05:6e02:16c6:b0:3a3:9471:8967 with SMTP id
 e9e14a558f8ab-3a748023930mr35721005ab.11.1731694795973; Fri, 15 Nov 2024
 10:19:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241112124256.4106435-1-john.g.garry@oracle.com> <20241112124256.4106435-6-john.g.garry@oracle.com>
In-Reply-To: <20241112124256.4106435-6-john.g.garry@oracle.com>
From: Song Liu <song@kernel.org>
Date: Fri, 15 Nov 2024 10:19:44 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6nJGQMQsEzJFZasg4LuHb3Qf-+JRTgqjaBtbYj_uBNGQ@mail.gmail.com>
Message-ID: <CAPhsuW6nJGQMQsEzJFZasg4LuHb3Qf-+JRTgqjaBtbYj_uBNGQ@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] md/raid10: Atomic write support
To: John Garry <john.g.garry@oracle.com>
Cc: axboe@kernel.dk, yukuai3@huawei.com, hch@lst.de, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, martin.petersen@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2024 at 4:43=E2=80=AFAM John Garry <john.g.garry@oracle.com=
> wrote:
>
> Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes.
>
> For an attempt to atomic write to a region which has bad blocks, error
> the write as we just cannot do this. It is unlikely to find devices which
> support atomic writes and bad blocks.
>
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>  drivers/md/raid10.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 8c7f5daa073a..a3936a67e1e8 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1255,6 +1255,7 @@ static void raid10_write_one_disk(struct mddev *mdd=
ev, struct r10bio *r10_bio,
>         const enum req_op op =3D bio_op(bio);
>         const blk_opf_t do_sync =3D bio->bi_opf & REQ_SYNC;
>         const blk_opf_t do_fua =3D bio->bi_opf & REQ_FUA;
> +       const blk_opf_t do_atomic =3D bio->bi_opf & REQ_ATOMIC;
>         unsigned long flags;
>         struct r10conf *conf =3D mddev->private;
>         struct md_rdev *rdev;
> @@ -1273,7 +1274,7 @@ static void raid10_write_one_disk(struct mddev *mdd=
ev, struct r10bio *r10_bio,
>         mbio->bi_iter.bi_sector =3D (r10_bio->devs[n_copy].addr +
>                                    choose_data_offset(r10_bio, rdev));
>         mbio->bi_end_io =3D raid10_end_write_request;
> -       mbio->bi_opf =3D op | do_sync | do_fua;
> +       mbio->bi_opf =3D op | do_sync | do_fua | do_atomic;
>         if (!replacement && test_bit(FailFast,
>                                      &conf->mirrors[devnum].rdev->flags)
>                          && enough(conf, devnum))
> @@ -1468,7 +1469,15 @@ static void raid10_write_request(struct mddev *mdd=
ev, struct bio *bio,
>                                 continue;
>                         }
>                         if (is_bad) {
> -                               int good_sectors =3D first_bad - dev_sect=
or;
> +                               int good_sectors;
> +
> +                               if (bio->bi_opf & REQ_ATOMIC) {
> +                                       /* We just cannot atomically writ=
e this ... */
> +                                       error =3D -EFAULT;

Is EFAULT the right error code here? I think we should return something
covered by blk_errors?

Other than this, 4/5 and 5/5 look good to me.

Thanks,
Song
