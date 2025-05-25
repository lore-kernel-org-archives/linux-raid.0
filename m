Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F4618859B
	for <linux-raid@vger.kernel.org>; Sun, 25 May 2025 15:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748188337; cv=none; b=OrNPyfUNOmkQpzNJ+Sh2kOFuEGRWYFfr8BsFNPKfZo8Le2pgT1zat0wvb2FSVgW/g5iDSg22DWHiFIQXPnouoF+yZ9g2TjGAzXYcqFcfFzVYlAmFhoP/xzqiuCASmF9uoq6M9x+lMyJkg36yD826y5SBsdjWBJ82tBINiU9E9r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748188337; c=relaxed/simple;
	bh=qOlVbQwRlaOZzBxJsGh6+hwiAsfE3d06I1Hr6cZUyqc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EiypUahsb6cla71XD+l/IUUkJgQTYjUKO1eVzHgUUxwWHZ27KrJSmU5Pn5JD9e8B1R0LEKKuLYoT9LfqwvGQlc0WgaRLmg8DzTk4yq+mukrNG6+xIIjkxckj0F348SVcyfjkksfThDxwx7QyYSf1CoBTbR5uOpsYmYtdbJwqWaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aA+5qOt/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aA+5qOt/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748188334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h+oFYeT9NuxC6H/0lZH+L7kYKTiWIWxTCcXXAYOLVQs=;
	b=aA+5qOt/ERI8uV4uiY1ihtpqjvMyZaxeHQKBhDtuv9HYB5NN8cX2bgoaiPls6h2LrdFZDA
	TN0c6lsLwiV+cMyuI1lB61mwK5zmzTNJTavEgsHMoP6E817uGQVqiJUGISvz3orHm099k5
	Iy1A/3klhYDxdBnookt4GQlblm3ocdA=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-4JcpbmNPPRu0sXpK5S_KYQ-1; Sun, 25 May 2025 11:52:13 -0400
X-MC-Unique: 4JcpbmNPPRu0sXpK5S_KYQ-1
X-Mimecast-MFC-AGG-ID: 4JcpbmNPPRu0sXpK5S_KYQ_1748188332
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-55212e53d50so885264e87.1
        for <linux-raid@vger.kernel.org>; Sun, 25 May 2025 08:52:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748188331; x=1748793131;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h+oFYeT9NuxC6H/0lZH+L7kYKTiWIWxTCcXXAYOLVQs=;
        b=opFBzPgRrFQv6X6GmhYi8IxgVt5yeBPAsRkJrm10thtY/QD0AmcNvciygukyVL8UBj
         xRIC3SmO2eZRH3vnRuN0QrA/WkerR9U5EzN4LiNvhLz6X53mQEX0RIGAvLXzeeXIAy7Q
         AlccEzXUGCJ69ao7Ge8ewzouibLpIvLjSwP5Zez/GAH9RXGo81oYdCJMMYAduysN1kFQ
         zK+wlmO+KpmYrDsLm4lN03r5M916RY/z+ohRVCaQDF+1zmrSv0LhLg8wWw1BDsmZlQ6F
         7vvNF5MTS1YwUr9QkVElEROgkiaKeP44P1E8Ptx45rCwMQNt7QgNjrAjDL7A3aT0k7Go
         Heqw==
X-Forwarded-Encrypted: i=1; AJvYcCWzh5Jqwwm+tMdnAa7MUFY5jFVywrJSl3a4aa8nxsuX00jO0BgBUed5Q85RNQdHWHKS/QDoZ/GMEB8r@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6Yw1EyVIv1ZLos6WU3HTbsVPNoR+RGFc0LwxbtiDt9z/gVNpd
	Vp6WAdtyFKQoQC+CXjI2GMwswNMus3yU0zHi6h73da3Vh/0/4n9+sIXcCdK9X/1Paxw5fmgJM8Y
	l2q0P35dpjgXi1ogt7hauhgWf+sKFHlhYVpl+ZuBxKQVn1yIwF+3dipIVi1RzJnDf/GitaiVd75
	Sv49L6qA4ITwVxu09jznGrqlO1gy844aWC68rXtA==
X-Gm-Gg: ASbGncusLJIBy7zYkZuMTSqXa62VtqMpt1JCv283um6YsnsIk664jNK6idCojBMLrbC
	2ECfxUy/7r//Frb3wOXnyoTM1wvsM9rs/q2N3Y4QIXuEYW0egu2Kh26UBZwMqikmvODHOmQ==
X-Received: by 2002:a2e:bc0f:0:b0:30b:d40c:7eb4 with SMTP id 38308e7fff4ca-3295b9fdd4dmr15192711fa.7.1748188331408;
        Sun, 25 May 2025 08:52:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHH2aX/UgHtnpAX8RU9WvmiAx9d3TmOQAco3dzYim5cKFUH8O/6ByaEpCDYrWLQgTDzMPQXykL7itxKXzBXS/0=
X-Received: by 2002:a2e:bc0f:0:b0:30b:d40c:7eb4 with SMTP id
 38308e7fff4ca-3295b9fdd4dmr15192591fa.7.1748188330964; Sun, 25 May 2025
 08:52:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250524061320.370630-1-yukuai1@huaweicloud.com> <20250524061320.370630-4-yukuai1@huaweicloud.com>
In-Reply-To: <20250524061320.370630-4-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Sun, 25 May 2025 23:51:59 +0800
X-Gm-Features: AX0GCFv0r1fl-vyM-nHN1Po4v0k4-DODc-eUClrp7RfxWBvr7XH5MJPAz9lkoVE
Message-ID: <CALTww2-sSWu7Ln6ASZA+OLPQOfY1TJvqq4Fop1wA4+EEkbF4Dw@mail.gmail.com>
Subject: Re: [PATCH 03/23] md/md-bitmap: cleanup bitmap_ops->startwrite()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, colyli@kernel.org, song@kernel.org, yukuai3@huawei.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	johnny.chenyi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 24, 2025 at 2:18=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> bitmap_startwrite() always return 0, and the caller doesn't check return
> value as well, hence change the method to void.
>
> Also rename startwrite/endwrite to start_write/end_write, which is more i=
n
> line with the usual naming convention.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md-bitmap.c | 17 ++++++++---------
>  drivers/md/md-bitmap.h |  6 +++---
>  drivers/md/md.c        |  8 ++++----
>  3 files changed, 15 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 168eea6595b3..2997e09d463d 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -1669,13 +1669,13 @@ __acquires(bitmap->lock)
>                         &(bitmap->bp[page].map[pageoff]);
>  }
>
> -static int bitmap_startwrite(struct mddev *mddev, sector_t offset,
> -                            unsigned long sectors)
> +static void bitmap_start_write(struct mddev *mddev, sector_t offset,
> +                              unsigned long sectors)
>  {
>         struct bitmap *bitmap =3D mddev->bitmap;
>
>         if (!bitmap)
> -               return 0;
> +               return;
>
>         while (sectors) {
>                 sector_t blocks;
> @@ -1685,7 +1685,7 @@ static int bitmap_startwrite(struct mddev *mddev, s=
ector_t offset,
>                 bmc =3D md_bitmap_get_counter(&bitmap->counts, offset, &b=
locks, 1);
>                 if (!bmc) {
>                         spin_unlock_irq(&bitmap->counts.lock);
> -                       return 0;
> +                       return;
>                 }
>
>                 if (unlikely(COUNTER(*bmc) =3D=3D COUNTER_MAX)) {
> @@ -1721,11 +1721,10 @@ static int bitmap_startwrite(struct mddev *mddev,=
 sector_t offset,
>                 else
>                         sectors =3D 0;
>         }
> -       return 0;
>  }
>
> -static void bitmap_endwrite(struct mddev *mddev, sector_t offset,
> -                           unsigned long sectors)
> +static void bitmap_end_write(struct mddev *mddev, sector_t offset,
> +                            unsigned long sectors)
>  {
>         struct bitmap *bitmap =3D mddev->bitmap;
>
> @@ -2990,8 +2989,8 @@ static struct bitmap_operations bitmap_ops =3D {
>         .end_behind_write       =3D bitmap_end_behind_write,
>         .wait_behind_writes     =3D bitmap_wait_behind_writes,
>
> -       .startwrite             =3D bitmap_startwrite,
> -       .endwrite               =3D bitmap_endwrite,
> +       .start_write            =3D bitmap_start_write,
> +       .end_write              =3D bitmap_end_write,
>         .start_sync             =3D bitmap_start_sync,
>         .end_sync               =3D bitmap_end_sync,
>         .cond_end_sync          =3D bitmap_cond_end_sync,
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index d3d50629af91..9474e0d86fc6 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -90,10 +90,10 @@ struct bitmap_operations {
>         void (*end_behind_write)(struct mddev *mddev);
>         void (*wait_behind_writes)(struct mddev *mddev);
>
> -       int (*startwrite)(struct mddev *mddev, sector_t offset,
> +       void (*start_write)(struct mddev *mddev, sector_t offset,
> +                           unsigned long sectors);
> +       void (*end_write)(struct mddev *mddev, sector_t offset,
>                           unsigned long sectors);
> -       void (*endwrite)(struct mddev *mddev, sector_t offset,
> -                        unsigned long sectors);
>         bool (*start_sync)(struct mddev *mddev, sector_t offset,
>                            sector_t *blocks, bool degraded);
>         void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *=
blocks);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b0468e795d94..04a659f40cd6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8849,14 +8849,14 @@ static void md_bitmap_start(struct mddev *mddev,
>                 mddev->pers->bitmap_sector(mddev, &md_io_clone->offset,
>                                            &md_io_clone->sectors);
>
> -       mddev->bitmap_ops->startwrite(mddev, md_io_clone->offset,
> -                                     md_io_clone->sectors);
> +       mddev->bitmap_ops->start_write(mddev, md_io_clone->offset,
> +                                      md_io_clone->sectors);
>  }
>
>  static void md_bitmap_end(struct mddev *mddev, struct md_io_clone *md_io=
_clone)
>  {
> -       mddev->bitmap_ops->endwrite(mddev, md_io_clone->offset,
> -                                   md_io_clone->sectors);
> +       mddev->bitmap_ops->end_write(mddev, md_io_clone->offset,
> +                                    md_io_clone->sectors);
>  }
>
>  static void md_end_clone_io(struct bio *bio)
> --
> 2.39.2
>

Reviewed-by: Xiao Ni <xni@redhat.com>

