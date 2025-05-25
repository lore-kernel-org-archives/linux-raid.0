Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2501319CD16
	for <linux-raid@vger.kernel.org>; Sun, 25 May 2025 15:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748188274; cv=none; b=pdNdaqbe0pa1kIlKIyfZci9SlaNyV7e9CUN8tOvVfLYlMwnbPeJt1HZ0rCpfajoF07ag1C8YW1DFH2on22ORffA+DClt4MNrHHYTlbi/GUmZr4PHEdKCRu79GabZ3SU4zP0+nRhMOWQB/75y8mllVwl11uBCbjIAOwj9b3KXu38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748188274; c=relaxed/simple;
	bh=qe8H0mKh4DgkZ8oMMk63GJ3TFObqFHSYZ6YCB40Lq9M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P2pFGjMwUYWrjfUvRA0L+dRpEqp2qPG4Yikt+LD0wdpPZwyeHBu+Hr+qc6CgyKf3H3qgDYJUvMuSrlEHgswmkqN0WtofNvgNAn9W9/jUtj3HfBBZiEJcrWv8BwT5te3D9yWDuTHKjC8i42vjyq4p6OxKzkVYyiXx/0R8iUlzbkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IyZUWryF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IyZUWryF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748188272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iwrLG3QCszTQAJyUhEJ2A6/6HOeql0ILuej+avt1aaM=;
	b=IyZUWryFEwdWvDBbapnX1b5l+DLuRTn4CA9R9tSA/KZboKNnntwZ1Knj7YZqaW0j/RtYTM
	/uQHh40G2otFC0+Q51TobZTlegBbP9S4bj2yZ/v1pYH0kAo2WeCmxuwKbSDHOAY5cWltFU
	ROQVukOMyg3/2jEPGZGrBPNZfphpfAo=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-dXGYdfjGPiqyVXvYpktRUw-1; Sun, 25 May 2025 11:51:10 -0400
X-MC-Unique: dXGYdfjGPiqyVXvYpktRUw-1
X-Mimecast-MFC-AGG-ID: dXGYdfjGPiqyVXvYpktRUw_1748188269
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-553227ef925so62e87.0
        for <linux-raid@vger.kernel.org>; Sun, 25 May 2025 08:51:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748188269; x=1748793069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iwrLG3QCszTQAJyUhEJ2A6/6HOeql0ILuej+avt1aaM=;
        b=XRw3ZLFaKXmA22K+a8NvHiUz/GncKz3PFdxwCfqsjIiEvxzNVqceEfJ9DxCpng7Rn9
         X6op1/tmtj5mmSOOs/wKskJdJQlJjpU2zDRycy/kw+JVXr4+cSXSniZEEmZupZjkR/8i
         i9hK0lJBGZPiTY5H6WJmPj3xBN+JVaX21Ono4uDOhWG4F0EzC+IxP4eqgly3LdGrI31j
         u0iRWIToI9/9gZZAqUkDjmyQoTxcMVOzii7ZnjR0C4ZS4TWYssJ9b5vk4pFdzDe2HGqp
         2vmL1ZYqc4yTUIBTpqS5dvcqleeHpnKUhBARm6eKNtL0KHoK1bOZ6E0spuFJ+RW6NBiU
         YR+g==
X-Forwarded-Encrypted: i=1; AJvYcCWPykYk0hLwZgYIzWfcF9Oautt00+jMALN4A5N1AjXN/IzbTTOQ9qfJCrajivjw4lKseW561vNHekAx@vger.kernel.org
X-Gm-Message-State: AOJu0YyBY98GqflyqA+dFi/hiNmr/aq8QIj4wb02FPkTHVW5+yykntHT
	MMFnjRPAHy9vhNrFomB3jggTm5O0mz5Qb5gyRgKBQU1hfuqaMfWjkSwM6lRemnSmP64emypwTho
	GzrkXDQfv07HMTpCzpIxqHlFrYJ+ACOZ7RbKhvu1tTTPRWlPuFt0/IBpnrRHV5s8PABv/FfZWFl
	aBV5fRgXJMI539t3uyxJBYEue0BjXx4nc2k+tgUA==
X-Gm-Gg: ASbGncvkjiCIS1j2yZm0jXsTxE92ChD6f/mwlk/kmGLP4WnfJNClX2gyCs1LFb4ejRC
	pmSuYIOOBQ6tS0MCF7TkMq3VWZDzFY+dhHgjY76bDFEPfS4MctxtsZgRNmRFbjnXtzSAMKg==
X-Received: by 2002:a05:6512:3ca8:b0:550:e60b:1927 with SMTP id 2adb3069b0e04-5521c7a8310mr1468118e87.1.1748188268784;
        Sun, 25 May 2025 08:51:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsfWfsT0atwcf/hJDOP86x1FcJHR3shDO40BtH9vdfsy6YiFbr58KQx7DOPv5ghRAHFkryknKdRc2h/IC2V6s=
X-Received: by 2002:a05:6512:3ca8:b0:550:e60b:1927 with SMTP id
 2adb3069b0e04-5521c7a8310mr1468112e87.1.1748188268357; Sun, 25 May 2025
 08:51:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250524061320.370630-1-yukuai1@huaweicloud.com> <20250524061320.370630-3-yukuai1@huaweicloud.com>
In-Reply-To: <20250524061320.370630-3-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Sun, 25 May 2025 23:50:56 +0800
X-Gm-Features: AX0GCFuFPq7qv4cXuJZLz9imxCoDKZ5yXU5O2tMBZfSvZ08QD-ldOCwjuOtzYJ8
Message-ID: <CALTww28mqz8Dh=V_eH3dw9djM6gHSe29KxgRzaQdOnDo2pEmkQ@mail.gmail.com>
Subject: Re: [PATCH 02/23] md: factor out a helper raid_is_456()
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
> There are no functional changes, the helper will be used by llbitmap in
> following patches.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.c | 9 +--------
>  drivers/md/md.h | 6 ++++++
>  2 files changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 18e03f651f6b..b0468e795d94 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9037,19 +9037,12 @@ static sector_t md_sync_position(struct mddev *md=
dev, enum sync_action action)
>
>  static bool sync_io_within_limit(struct mddev *mddev)
>  {
> -       int io_sectors;
> -
>         /*
>          * For raid456, sync IO is stripe(4k) per IO, for other levels, i=
t's
>          * RESYNC_PAGES(64k) per IO.
>          */
> -       if (mddev->level =3D=3D 4 || mddev->level =3D=3D 5 || mddev->leve=
l =3D=3D 6)
> -               io_sectors =3D 8;
> -       else
> -               io_sectors =3D 128;
> -
>         return atomic_read(&mddev->recovery_active) <
> -               io_sectors * sync_io_depth(mddev);
> +              (raid_is_456(mddev) ? 8 : 128) * sync_io_depth(mddev);
>  }
>
>  #define SYNC_MARKS     10
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 5ba4a9093a92..c241119e6ef3 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -1011,6 +1011,12 @@ static inline bool mddev_is_dm(struct mddev *mddev=
)
>         return !mddev->gendisk;
>  }
>
> +static inline bool raid_is_456(struct mddev *mddev)
> +{
> +       return mddev->level =3D=3D ID_RAID4 || mddev->level =3D=3D ID_RAI=
D5 ||
> +              mddev->level =3D=3D ID_RAID6;
> +}
> +
>  static inline void mddev_trace_remap(struct mddev *mddev, struct bio *bi=
o,
>                 sector_t sector)
>  {
> --
> 2.39.2
>

Reviewed-by: Xiao Ni <xni@redhat.com>

