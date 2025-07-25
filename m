Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B022376FD
	for <linux-raid@vger.kernel.org>; Fri, 25 Jul 2025 03:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753414986; cv=none; b=RhwzFxH4BgjYNVP7BV24Fy2WWFsQ5FCeFxQmjaqDAxjM0Jebuk0fEQAmA8zFhnGN055yMv9+pvuKWWAxk1B/c04kG3xtfboTRpzz1ygwHlvnOLj3o/Kdxib7AQOX1/mjSRvnQhXPa5sS2diVgLBOu5eCZjlYjLFCqEAK2f7LViI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753414986; c=relaxed/simple;
	bh=EYW/y1fwu5T+yqts+Bpy6dphKw7A/rXhOamx61AqAGo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=myn/p1n+SpbS6yRRJlwjizX7AudT60Ly/an6io80OuW037uWHLymgLVt1lwVED4YrG3qluae3/Z97tmo8n88XN2i6cEtpjMe2AUMzkwhaYrVPgQ5ZDEu0+BCOBGPL8Jo1FnFRmQvvSKOMdjUc6VTTnVSBEoqkgRA0pCMucnInic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=doKmXzY1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="doKmXzY1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753414982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JmT/ORzg0P1lBg635/k0jST+Uw1Ny6cPps1AZuQQysQ=;
	b=doKmXzY1VbSeW/mSJm1Bhsc29dEQG5tz8EwwOylEha7fnjbgZtJoYk4q5koei6pvefS4kG
	SyMpZXgB3GgZflnlSButP2K45GgMwuGF3MosAcYivp95Y2wBZYWvXMMi5LncGtToczudXR
	rCiI8G+edRy0DB97nhq3c/MCkzC1EIQ=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-376-IyK6SJGDOXO9qRHkd0a4Tw-1; Thu, 24 Jul 2025 23:43:00 -0400
X-MC-Unique: IyK6SJGDOXO9qRHkd0a4Tw-1
X-Mimecast-MFC-AGG-ID: IyK6SJGDOXO9qRHkd0a4Tw_1753414979
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-32eaaa0e729so3964501fa.3
        for <linux-raid@vger.kernel.org>; Thu, 24 Jul 2025 20:43:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753414979; x=1754019779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JmT/ORzg0P1lBg635/k0jST+Uw1Ny6cPps1AZuQQysQ=;
        b=RzYrkiLse2gOZ2/mBISqPXhYQi1c4TwCBj4IoVBZ3vFkCvcKW5qLRS0GwMgv944EwI
         9t/XA7LEcqKmCIi2/hBA1Wu/GulP7jgH4rTPQkvLURH1ApDjP9fzBNlYFD3snRBaY1bg
         kNsS2CgiaVrX2076Wg7RriaGi6GgTpt4sWvbaMeaQTMqtpOrxY2+wEZZZKmyfGfg66ke
         rL7vCCmC0DHpfWl1m7bEC3/x+4t6tJm/FS95nbYw+sXvNBbmFOSvyfXWcPQhuTi9/Eec
         ouXAqe7ElT47s8NZLuXNC497bFKf9JFPTV6TG+VoCxo8edGkvNtXFPy0NNzeh8kc937J
         Dhlw==
X-Forwarded-Encrypted: i=1; AJvYcCXHdaSicdSkkFKjENAhrdZn3S4TfByGq1vRgkX6jDmVOL3Z6O7hi+fI22LIPAQxlMQirpOZjnqsZoyj@vger.kernel.org
X-Gm-Message-State: AOJu0YzxgUv9iMfz/F6IsMJUtGDX48HXvYk/j5K3oEFSQ/2cCynGB4b8
	v4bxGaD78e2H9wPgQQFZMjmSgpqk3Ae1+jF9MLsN8zGmjknmRnWH1Vp32bY2Ta2IWN16I0QhR7N
	lyiYZNc6cAM5lxXIlpM8I/2ks+PIsQcFxZl78vZUgPBxyrxRobtoT7BG9RyQJ34rFasOtVN1jrb
	O9ZmOeHeH6EtvGdi4kl6m8Ql8pEyOgdeJgnYHU9g==
X-Gm-Gg: ASbGncsIEeI2xeWwSsWhXEaA0TRgXA8rjCUuPYI71xmZB+VXRErkRdnJt4zVm5KHcVK
	tdHZiH44ZBpb+9bdY2A4FRkOOD691rMso8FoVDO/d3vFq4HPY/dgwXWSzJ3eN77SgPEgU/w5ANo
	8DZmESQKsG4SPOuXSPWbT1JQ==
X-Received: by 2002:a2e:b8d2:0:b0:32b:78ce:be8e with SMTP id 38308e7fff4ca-331ee7ff19cmr1287151fa.32.1753414979002;
        Thu, 24 Jul 2025 20:42:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4YEQa+EOQb1BXl05be8PP0uoJ9yTAnU5IBjXbn4Pml9bhqsvSe6/FSlvFTpOWnC363qchUy3SyM0LBktBwFM=
X-Received: by 2002:a2e:b8d2:0:b0:32b:78ce:be8e with SMTP id
 38308e7fff4ca-331ee7ff19cmr1286981fa.32.1753414978556; Thu, 24 Jul 2025
 20:42:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250707012711.376844-1-yukuai1@huaweicloud.com> <20250707012711.376844-5-yukuai1@huaweicloud.com>
In-Reply-To: <20250707012711.376844-5-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 25 Jul 2025 11:42:47 +0800
X-Gm-Features: Ac12FXyOOKyHA7wp5OFT5LnhP7iR9jh1hN7dKn8UFtQrbCgR_dwXzkwUJs2-acg
Message-ID: <CALTww2-71P6Z0zxOeWJhu3bJ5AkKNqP0K+6M1djmBG=mZg38_w@mail.gmail.com>
Subject: Re: [PATCH v5 04/15] md/md-bitmap: merge md_bitmap_group into bitmap_operations
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, 
	yukuai3@huawei.com, dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	johnny.chenyi@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 7, 2025 at 9:35=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Now that all bitmap implementations are internal, it doesn't make sense
> to export md_bitmap_group anymore.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md-bitmap.c | 5 ++++-
>  drivers/md/md-bitmap.h | 2 ++
>  drivers/md/md.c        | 6 +++++-
>  drivers/md/md.h        | 1 -
>  4 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> index fc7282304b00..0ba1da35aa84 100644
> --- a/drivers/md/md-bitmap.c
> +++ b/drivers/md/md-bitmap.c
> @@ -2990,7 +2990,8 @@ static struct attribute *md_bitmap_attrs[] =3D {
>         &max_backlog_used.attr,
>         NULL
>  };
> -const struct attribute_group md_bitmap_group =3D {
> +
> +static struct attribute_group md_bitmap_group =3D {
>         .name =3D "bitmap",
>         .attrs =3D md_bitmap_attrs,
>  };
> @@ -3026,6 +3027,8 @@ static struct bitmap_operations bitmap_ops =3D {
>         .copy_from_slot         =3D bitmap_copy_from_slot,
>         .set_pages              =3D bitmap_set_pages,
>         .free                   =3D md_bitmap_free,
> +
> +       .group                  =3D &md_bitmap_group,
>  };
>
>  void mddev_set_bitmap_ops(struct mddev *mddev)
> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> index 28c1f1c1cc83..0ceb9e97d21f 100644
> --- a/drivers/md/md-bitmap.h
> +++ b/drivers/md/md-bitmap.h
> @@ -100,6 +100,8 @@ struct bitmap_operations {
>                               sector_t *hi, bool clear_bits);
>         void (*set_pages)(void *data, unsigned long pages);
>         void (*free)(void *data);
> +
> +       struct attribute_group *group;
>  };
>
>  /* the bitmap API */
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index bda3ef814d97..7ed95e5e43fc 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5749,7 +5749,6 @@ static const struct attribute_group md_redundancy_g=
roup =3D {
>
>  static const struct attribute_group *md_attr_groups[] =3D {
>         &md_default_group,
> -       &md_bitmap_group,
>         NULL,
>  };
>
> @@ -5996,6 +5995,11 @@ struct mddev *md_alloc(dev_t dev, char *name)
>                 return ERR_PTR(error);
>         }
>
> +       if (mddev->bitmap_ops && mddev->bitmap_ops->group)
> +               if (sysfs_create_group(&mddev->kobj, mddev->bitmap_ops->g=
roup))
> +                       pr_warn("md: cannot register extra bitmap attribu=
tes for %s\n",
> +                               mdname(mddev));
> +
>         kobject_uevent(&mddev->kobj, KOBJ_ADD);
>         mddev->sysfs_state =3D sysfs_get_dirent_safe(mddev->kobj.sd, "arr=
ay_state");
>         mddev->sysfs_level =3D sysfs_get_dirent_safe(mddev->kobj.sd, "lev=
el");
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 67b365621507..d6fba4240f97 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -796,7 +796,6 @@ struct md_sysfs_entry {
>         ssize_t (*show)(struct mddev *, char *);
>         ssize_t (*store)(struct mddev *, const char *, size_t);
>  };
> -extern const struct attribute_group md_bitmap_group;
>
>  static inline struct kernfs_node *sysfs_get_dirent_safe(struct kernfs_no=
de *sd, char *name)
>  {
> --
> 2.39.2
>
>

Looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

