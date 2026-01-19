Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A215123BD06
	for <linux-raid@vger.kernel.org>; Mon, 19 Jan 2026 03:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768791858; cv=none; b=b4mtK3LTHOhf85oHgEvEGjs0HF46FUMT4TA3HMoBlaGEdYyl5MJb6E3YZrpO86WB9QaQt3j0wzaZNVfvWOkVTTbNLXfp98Vl5tKCxE8iNmGxQIuTnamrBk1whutRGui+qz5c4+jCHWgRQLLO3kTJDvODYfcdGt2yGU7iGssInBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768791858; c=relaxed/simple;
	bh=4pZRmaQXJBKCyxJrRM8WI/sNuw8JdnBKvnk/6w8IwAM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CKnrYkig86x0lj5f5qbZ7igWW16YKn6yXJhwMpod2BWIvwXwR2mMp701LTLX0wfOKOocNjY/lYNXNnwKLyBxwXulrOpfu5njoxSeHXEcfyg35YbWh4TlmnKTKB5Qqb53N2cBfbmbI+iMG/FWJmUu3bV7/ASDyhgIj40d5qqwpIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QM3PUM8R; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=qWqI4JQ2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QM3PUM8R";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="qWqI4JQ2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768791851;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=91oWUoswjEymMej7KaOOy96k0v+f5VavAH7M6th+fBQ=;
	b=QM3PUM8Ru3Jc+vYUciJcyKPQAs/pP9kURoDl11wC+IziQ3t0hg9b/mLfCR5L6E2RguqGxy
	kDesAgix/0lF5KrmVNfd+ecnYHyYrsCLboA9kMjSZMTGam+PyyEgrCTysg24dCO2ljPNjz
	9jUusHFDShICjsId/W0SeXLKJGpSb/M=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-wO1FHdINNSWTos_3Arm_5Q-1; Sun, 18 Jan 2026 22:04:10 -0500
X-MC-Unique: wO1FHdINNSWTos_3Arm_5Q-1
X-Mimecast-MFC-AGG-ID: wO1FHdINNSWTos_3Arm_5Q_1768791849
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-38323cab4bdso20889001fa.1
        for <linux-raid@vger.kernel.org>; Sun, 18 Jan 2026 19:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768791848; x=1769396648; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=91oWUoswjEymMej7KaOOy96k0v+f5VavAH7M6th+fBQ=;
        b=qWqI4JQ2d7CpdOspSkP6R88ZY6vg5li4IIetTk/OQkggF0fhLLXeFNM7verQ8K4J4d
         aOQBvmYzxcoypwXHfjlQCOuxC1VCLuX/NrtR7axVJwLFbRS4EG+GL29ibZF/tkB8GHx7
         RrRA7BYOgmKChnyIq1iqAXNAIp8Td4qogyfSFtIFREbgmminKdyzvx4+2xrTOzdmHPgN
         dNHhOphhMJJ+Oeljx4XqI3chuVofjZcztFHP8SSSNXYe+IsHkusDYzc+spcs2mpPCC7n
         p+sgiaHqHRxzZasQHAAaOtiOPaL97YXgr5pI5F89zcrs+WPovomPnA9AWd7GUuz8StFc
         Oq+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768791848; x=1769396648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=91oWUoswjEymMej7KaOOy96k0v+f5VavAH7M6th+fBQ=;
        b=ocQa/K4aMLilALmYVXyHdFAdU+OZPDIrLPG9VzNqZNwq02BMhQVZwAhuDh0Qigtlr3
         vmlCXP2gA65POqHEklXd2CCN09rsXer4UwJhPIzn61FRUbuBh7+GRBUolVFKIbYRWfEa
         EMP2lksusY95bRgJDb81RDcEExLTcZncMM+SBDCBx5WMQ34KDgQBeWfUnZqbYRe1isI4
         xRecOFq4hzklgQ3sCDzWnb5gkPeWZ4wU2Yp92UBKBV35l7yy0eSlbaZQEhVBZTAByHGt
         indKQcxGmbwK8iKUqrAyOo0gDNNq+MN/ocaAcSlNcBVTZMbCIdJZpyYRvMMXYLP36bYf
         MFDw==
X-Forwarded-Encrypted: i=1; AJvYcCX5OoiqwASoQ1qCt6tNcS+986yboecKzZ6LU5mWTwK0tGLqkeTATeZNokuasTH6Z6yUykfjARHXLnii@vger.kernel.org
X-Gm-Message-State: AOJu0YyEV28VZZhkVvuNt8sy84oy/8h7U164+yhSXT9FLQ7m1sKjfjYH
	qfBJHEVxYOpSBQtPPMZ4ocRwf0x90joSATUH5ptWq6v0yx/Z0fkq6Mt3jGsB3mCiKWBvoNWbaKN
	pN/WFJbHPSaYAs7KziupTB9KJKTwhNBOihaj7GZizV04TZjEwp+eXjHFSd7vhxSHXckikEaZHo9
	NAZTEkE0fjBv4370W0962RDImyxsnau+2KChEEog==
X-Gm-Gg: AY/fxX60g1yUUal/rD+aVlwPBBB/Vqi43SDlozg4Q6s91qXM5X6fZhHvPPRAe8JkpwJ
	JzomSzdFudtalg41giaIHr/O8hab74wRdBFy/EIOQWKneEb+ywbA1U1jL6WCyNSLaYDlqdO+0Id
	z65IzgDCcJ3lPAJqscvy9ksccnuE3QNX2Eu7ZOCUWYlhEICMwclDknWCxaydDx+SBmAqK6ozc+P
	CadzsvZ9q/n+9QytHnmziF+kux6rAUpYilu/XLKWFQfhKr4dDQMqYI4iHWphZ+QbSCJTw==
X-Received: by 2002:a05:651c:c91:b0:37b:aafa:5af6 with SMTP id 38308e7fff4ca-383841ab3a8mr32318281fa.16.1768791848425;
        Sun, 18 Jan 2026 19:04:08 -0800 (PST)
X-Received: by 2002:a05:651c:c91:b0:37b:aafa:5af6 with SMTP id
 38308e7fff4ca-383841ab3a8mr32318211fa.16.1768791848007; Sun, 18 Jan 2026
 19:04:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251217120013.2616531-1-linan666@huaweicloud.com> <20251217120013.2616531-4-linan666@huaweicloud.com>
In-Reply-To: <20251217120013.2616531-4-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 19 Jan 2026 11:03:56 +0800
X-Gm-Features: AZwV_QhVj5te9nPSg3mYjz4lkoKw6IFWRVsAMLRdFSj4HqnKNAsJLGk9uUOTzPQ
Message-ID: <CALTww28tZDgBVy=G=doJQ3yfWtuiLk5QoMMyL1cmveacXHLynA@mail.gmail.com>
Subject: Re: [PATCH 03/15] md: use folio for bb_folio
To: linan666@huaweicloud.com
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2025 at 8:11=E2=80=AFPM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> Convert bio_page to bio_folio and use it throughout.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>  drivers/md/md.h |  3 ++-
>  drivers/md/md.c | 25 +++++++++++++------------
>  2 files changed, 15 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 410f8a6b75e7..aa6d9df50fd0 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -144,7 +144,8 @@ struct md_rdev {
>         struct block_device *bdev;      /* block device handle */
>         struct file *bdev_file;         /* Handle from open for bdev */
>
> -       struct page     *sb_page, *bb_page;
> +       struct page     *sb_page;
> +       struct folio    *bb_folio;
>         int             sb_loaded;
>         __u64           sb_events;
>         sector_t        data_offset;    /* start of data in array */
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9dfd6f8da5b8..0732bbcdb95d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1073,9 +1073,9 @@ void md_rdev_clear(struct md_rdev *rdev)
>                 rdev->sb_start =3D 0;
>                 rdev->sectors =3D 0;
>         }
> -       if (rdev->bb_page) {
> -               put_page(rdev->bb_page);
> -               rdev->bb_page =3D NULL;
> +       if (rdev->bb_folio) {
> +               folio_put(rdev->bb_folio);
> +               rdev->bb_folio =3D NULL;
>         }
>         badblocks_exit(&rdev->badblocks);
>  }
> @@ -1909,9 +1909,10 @@ static int super_1_load(struct md_rdev *rdev, stru=
ct md_rdev *refdev, int minor_
>
>         rdev->desc_nr =3D le32_to_cpu(sb->dev_number);
>
> -       if (!rdev->bb_page) {
> -               rdev->bb_page =3D alloc_page(GFP_KERNEL);
> -               if (!rdev->bb_page)
> +       if (!rdev->bb_folio) {
> +               rdev->bb_folio =3D folio_alloc(GFP_KERNEL, 0);
> +
> +               if (!rdev->bb_folio)
>                         return -ENOMEM;
>         }
>         if ((le32_to_cpu(sb->feature_map) & MD_FEATURE_BAD_BLOCKS) &&
> @@ -1930,10 +1931,10 @@ static int super_1_load(struct md_rdev *rdev, str=
uct md_rdev *refdev, int minor_
>                 if (offset =3D=3D 0)
>                         return -EINVAL;
>                 bb_sector =3D (long long)offset;
> -               if (!sync_page_io(rdev, bb_sector, sectors << 9,
> -                                 rdev->bb_page, REQ_OP_READ, true))
> +               if (!sync_folio_io(rdev, bb_sector, sectors << 9, 0,
> +                                 rdev->bb_folio, REQ_OP_READ, true))
>                         return -EIO;
> -               bbp =3D (__le64 *)page_address(rdev->bb_page);
> +               bbp =3D (__le64 *)folio_address(rdev->bb_folio);
>                 rdev->badblocks.shift =3D sb->bblog_shift;
>                 for (i =3D 0 ; i < (sectors << (9-3)) ; i++, bbp++) {
>                         u64 bb =3D le64_to_cpu(*bbp);
> @@ -2300,7 +2301,7 @@ static void super_1_sync(struct mddev *mddev, struc=
t md_rdev *rdev)
>                 md_error(mddev, rdev);
>         else {
>                 struct badblocks *bb =3D &rdev->badblocks;
> -               __le64 *bbp =3D (__le64 *)page_address(rdev->bb_page);
> +               __le64 *bbp =3D (__le64 *)folio_address(rdev->bb_folio);
>                 u64 *p =3D bb->page;
>                 sb->feature_map |=3D cpu_to_le32(MD_FEATURE_BAD_BLOCKS);
>                 if (bb->changed) {
> @@ -2953,7 +2954,7 @@ void md_update_sb(struct mddev *mddev, int force_ch=
ange)
>                                 md_write_metadata(mddev, rdev,
>                                                   rdev->badblocks.sector,
>                                                   rdev->badblocks.size <<=
 9,
> -                                                 rdev->bb_page, 0);
> +                                                 folio_page(rdev->bb_fol=
io, 0), 0);
>                                 rdev->badblocks.size =3D 0;
>                         }
>
> @@ -3809,7 +3810,7 @@ int md_rdev_init(struct md_rdev *rdev)
>         rdev->sb_events =3D 0;
>         rdev->last_read_error =3D 0;
>         rdev->sb_loaded =3D 0;
> -       rdev->bb_page =3D NULL;
> +       rdev->bb_folio =3D NULL;
>         atomic_set(&rdev->nr_pending, 0);
>         atomic_set(&rdev->read_errors, 0);
>         atomic_set(&rdev->corrected_errors, 0);
> --
> 2.39.2
>

Hi Nan

Bad block page is only one single page. I don't think it's necessary
to use folio here. And it uses folio_page to get the page again. Or do
you plan to replace all page apis to folio apis? Looking through all
patches, sync_page_io is not removed. In patch02, it says sync_page_io
will be removed. So maybe it's better to switch bb_page to bb_folio in
your second patch set? And this patch set only focuses on replacing
sync pages with folio. It's my 2 cents point. If you think it's better
to change the bad block page here, I'm still ok.

Best Regards
Xiao

