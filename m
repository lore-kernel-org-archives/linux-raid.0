Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4867D1FF1D8
	for <linux-raid@vger.kernel.org>; Wed, 28 May 2025 04:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748408005; cv=none; b=BDJwMrdV66O7mx0dKoTw2zor+M6KxBK8DxpbkiUBe7JjPGPMjRylJuqoLmWQPnSxTjT6idOsfMqdPXTnt7L21OegyDVmVamnfPGEsz3mTa2RbZTsDGW043bPiuSBxcRD6AF3ecRlg+jvjgWu9sbImzH88AcsFh/FL0DUQywfKso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748408005; c=relaxed/simple;
	bh=+5bT6sLoqX1CK/nv6Y09Rlj5Wk6fqnt7kYp3W/6/AZU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ooP46JTZ/TEyn58/8fpI/T3ENEkNUonN01uZLERyRKnsVBPcz2FQx++clDaxZL26GLy3ibZgXBgyvpq1qwaapaMif7rfXnY9Sg/AtIL3ktC4IoO0bsap63bZUQA6JP5O68E8FiLwiNT8f3C7OemaBdwe+whOs6MeDM9wFVab8kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=agn2Ps02; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="agn2Ps02"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748408002;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3qoz40Fv9dqOLasbkSia0eh+o0evOnHHCkU1NVu2z+o=;
	b=agn2Ps02l63Xvf1mLtylM/SD896lnm4vby29EvZnUDfPjf0ncEa+2Ojkmiwys8dYsqFgbh
	c2yrTDdGlonuxMhsS16jsJhS+GhhOp6ac7KtqjPoun0tje/UzJvaZVmi+iFaPaCLxyBi6L
	TS6BZMk3eXrbmvzRm4oEkvmgky1csXs=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-163-BMsXyIKxMaOrm5Blz6l7tg-1; Wed, 28 May 2025 00:53:20 -0400
X-MC-Unique: BMsXyIKxMaOrm5Blz6l7tg-1
X-Mimecast-MFC-AGG-ID: BMsXyIKxMaOrm5Blz6l7tg_1748407999
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-3292a313051so22148191fa.3
        for <linux-raid@vger.kernel.org>; Tue, 27 May 2025 21:53:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748407999; x=1749012799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3qoz40Fv9dqOLasbkSia0eh+o0evOnHHCkU1NVu2z+o=;
        b=fL2+XWQIq4F1T17AHMJ+Q3kqwOarG6nnPwcSOvMn/2sUFXPI3J9OKWJ5gIG2Brqrdo
         kZMAET1nUeK4/43Oo+vdB1rI3Bqq1YX/EQ3aD7OmYm1bGb9CfaN6z4MysOk+qkkP7XPJ
         qVrBHCMEvinWVCb3UsSXgSb67ESXPYISf8O+jf/q3fKUcynXLlTFXUFF40+tFAsClZhD
         n04bdF4buPTvFpkMcqAgbwC51TLHpKcAWU5+oXqpEWEn+bPR7JPDnnX6xwQn/iJfxzuh
         84fGgdGQwCSmBdjNOBbYmlYSMsT77J/FyXV3tq+2Vk5DNMdviBImL6UEHIljhvih7pJx
         r1lQ==
X-Forwarded-Encrypted: i=1; AJvYcCVw7Y1E0xV9h0fx6cWgr/wpYWzLYa5giicZqyo76tNpGtnf9C4nsnXVAGDA2klLUBZEu5DGlBKbL1Aj@vger.kernel.org
X-Gm-Message-State: AOJu0YwltKENxsrzkrB91Lljap19C+/23i4iuc4DpmbThRdd66essSuD
	Rz5Vyyww7cYWdEYsAo/HNeqw11cjJ7iE+j392bmZmTctyhXsN1UK7WAlMqdVJAL/odYZsDvmrKL
	gJLAwlKWihjdoL+obkiCCXSXopMMpyuloxHvK7BPiqVZKYo70v6cqFaaLi5NBsImH1PlWjjtMfX
	ZHgWxR0l5bxQ1zLW484je2vKVmc6M+E8SCPp4eWw==
X-Gm-Gg: ASbGncvp/uRW+cfu5tz7jGiwYFfTPuFiJ8shNwgrpTbcnFDEhkWFEnsYkM4PuvTH/ar
	llBLc+3bvMvVGkv4jsHWTcV8cryeogiamXoNzuCwaedZJJ0QBVgfCh+cTtdzo5SPIN0BCmw==
X-Received: by 2002:a05:651c:547:b0:326:ba31:bc1b with SMTP id 38308e7fff4ca-3295b9c6e82mr56903971fa.19.1748407998740;
        Tue, 27 May 2025 21:53:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHST1hlfOsH7e7ZZwenC3npuT82YxgHz4N9xnnGh2MZrS78ykwqpUhtP6DEAauq3IXZOjG0ltgie6ZYMAAqIkk=
X-Received: by 2002:a05:651c:547:b0:326:ba31:bc1b with SMTP id
 38308e7fff4ca-3295b9c6e82mr56903931fa.19.1748407998310; Tue, 27 May 2025
 21:53:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250524061320.370630-1-yukuai1@huaweicloud.com> <20250524061320.370630-13-yukuai1@huaweicloud.com>
In-Reply-To: <20250524061320.370630-13-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 28 May 2025 12:53:05 +0800
X-Gm-Features: AX0GCFsPvf7RCW8LBzVeUbKU7yRZ83m7i3GdKLvyxYqxJBrFEjDYTcKPMZaxrmY
Message-ID: <CALTww2_pEnnWTGMbHUvX2CURrEvUHO=t2Notw9-Ynjemr5sDsw@mail.gmail.com>
Subject: Re: [PATCH 12/23] md/md-bitmap: add macros for lockless bitmap
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
> Also move other values to md-bitmap.h and update comments.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md-bitmap.c |  9 ---------
>  drivers/md/md-bitmap.h | 17 +++++++++++++++++
>  2 files changed, 17 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index 17d41a7b30ce..689d5dba9328 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -36,15 +36,6 @@
>  #include "md-bitmap.h"
>  #include "md-cluster.h"
>
> -#define BITMAP_MAJOR_LO 3
> -/* version 4 insists the bitmap is in little-endian order
> - * with version 3, it is host-endian which is non-portable
> - * Version 5 is currently set only for clustered devices
> - */
> -#define BITMAP_MAJOR_HI 4
> -#define BITMAP_MAJOR_CLUSTERED 5
> -#define        BITMAP_MAJOR_HOSTENDIAN 3
> -
>  /*
>   * in-memory bitmap:
>   *
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index f2d79c8a23b7..d2cdf831ef1a 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -18,10 +18,27 @@ typedef __u16 bitmap_counter_t;
>  #define RESYNC_MASK ((bitmap_counter_t) (1 << (COUNTER_BITS - 2)))
>  #define COUNTER_MAX ((bitmap_counter_t) RESYNC_MASK - 1)
>
> +/*
> + * version 3 is host-endian order, this is deprecated and not used for n=
ew
> + * array
> + */
> +#define BITMAP_MAJOR_LO                3
> +#define BITMAP_MAJOR_HOSTENDIAN        3
> +/* version 4 is little-endian order, the default value */
> +#define BITMAP_MAJOR_HI                4
> +/* version 5 is only used for cluster */
> +#define BITMAP_MAJOR_CLUSTERED 5
> +/* version 6 is only used for lockless bitmap */
> +#define BITMAP_MAJOR_LOCKLESS  6
> +
> +#define BITMAP_SB_SIZE 1024

Hi

For super1, the bitmap bits are next to bitmap superblock.
BITMAP_SB_SIZE is only used by md-llbitmap, is it better to define it
in md-llbitmap.c?

Regards
Xiao

>  /* use these for bitmap->flags and bitmap->sb->state bit-fields */
>  enum bitmap_state {
>         BITMAP_STALE       =3D 1,  /* the bitmap file is out of date or h=
ad -EIO */
>         BITMAP_WRITE_ERROR =3D 2, /* A write error has occurred */
> +       BITMAP_FIRST_USE   =3D 3, /* llbitmap is just created */
> +       BITMAP_CLEAN       =3D 4, /* llbitmap is created with assume_clea=
n */
> +       BITMAP_DAEMON_BUSY =3D 5, /* llbitmap daemon is not finished afte=
r daemon_sleep */
>         BITMAP_HOSTENDIAN  =3D15,
>  };
>
> --
> 2.39.2
>

