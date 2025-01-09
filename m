Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB0713B2B8;
	Thu,  9 Jan 2025 18:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736447821; cv=none; b=C1GB918oetRO+qcySJge4B3uLgzVyJ4zcgV6sIagD3WdYit0pvQGWzsyg5crciHSgFlHJASHcd6o7m6Wyq9S5Cte2NAlTu1ejAlVRfdRcUX7rdGWnKqxjBVdsaAUDa4vTQDI8xfK1snNsaFFLV8ukJ03W8ZozELey1uXXEpLfCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736447821; c=relaxed/simple;
	bh=7Zor4R8odfWSIADnef/FQ6yzBAaeDlqQ63VJej5TbEQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BN+IflxJ7nXL+JbecqZCgv38B5Gvkjpde6chZFg7eRPU7PF60PiFUT9N5zkyWGd20N2uqsjlaGhYrLedUY7bOw+rZOHWDkXQ5a13VyIcavpUSKZzEOS2y9k5xmNxUpRe8Mo/GzrmtTbkvTBTvoz4TtSq0gJwE31mUQjIjGMFyes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJdggbQs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJdggbQs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59AA8C4CEE3;
	Thu,  9 Jan 2025 18:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736447821;
	bh=7Zor4R8odfWSIADnef/FQ6yzBAaeDlqQ63VJej5TbEQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MJdggbQsj3X0Bu3ZpgTTk10MRXxjHLJce5dmtKmgW5cHhQ42i/8vnd4KRqWcZVJZ/
	 IOvrhG8uXr0RV6wlmNIhIWETsFegljttwveheFN1FOEPz0IJX7uNqOsR1VSkydWvvx
	 JTAoHr9Z95Jg8g2BL0wLXM3rrEmb425mZjHt46iK1CjrWJJZANXoG8nplY3eSnvt8a
	 G1igBOnN7yfdfOgJefbDhhA1PDCuWyMzM06+jFUHPoru70tpo3GJq9n9JbhuPhvAve
	 ju8CE6B17oyV3xAP0SJ+c9bBV8QboRDeOjGM7Zp6zhYaxTiy9xqXwHuQrOXET/hvmD
	 Dc8rufP4Eez3A==
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3ce4b009465so4100905ab.0;
        Thu, 09 Jan 2025 10:37:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCV/14I4dLzLh+w3YpIw+Z0HL3j+nNU07M/FyX3pBv5a2b5RWCP8nwrRh3GYlygwrQYJ32Bqy9xlu+i3YCY=@vger.kernel.org, AJvYcCVmfvsAvrvfjus90EFwTbT20J1vOKEI+LEbBjqimUN/1oNGELPeAZG0WGXZFrbiIJWw1a9jb6Yy/7U4Jw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxEZh6R+dm+dRtWlPs4PGnN3Br6vZzsKYCukuGbRylhXfaDERah
	98oVir8qBMa1vdkdspdMWLMgxPs7hF/ybB1Xj2MgAqV/DrArvneYYGk6vVFt6vbDQgrIswaKaM4
	bJgJvxgBxR5jGmMT1So7AoLaOi4U=
X-Google-Smtp-Source: AGHT+IEVJRtnzjszOtQa2akbt8EcEuObvwVckzpCkKNQiJTFXSSBwq9GxP8ulYPS+SNOwhlHkBCcHfynSDgvyFgtbmo=
X-Received: by 2002:a05:6e02:1e01:b0:3cd:d6a5:23ef with SMTP id
 e9e14a558f8ab-3ce3a8781d6mr60971405ab.9.1736447820636; Thu, 09 Jan 2025
 10:37:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109015145.158868-1-yukuai1@huaweicloud.com> <20250109015145.158868-5-yukuai1@huaweicloud.com>
In-Reply-To: <20250109015145.158868-5-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 9 Jan 2025 10:36:49 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5eMz4s+x4zWx75wUkkzztEYVnmBYUv7rza0bJQRWC+6g@mail.gmail.com>
X-Gm-Features: AbW1kvZF7tSVupBPTI131p_7STIXTelPFuKUIQCutONU0aruAkWbRNEWQNupraI
Message-ID: <CAPhsuW5eMz4s+x4zWx75wUkkzztEYVnmBYUv7rza0bJQRWC+6g@mail.gmail.com>
Subject: Re: [PATCH v2 md-6.14 4/5] md/raid5: implement pers->bitmap_sector()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, yukuai3@huawei.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 8, 2025 at 5:56=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Bitmap is used for the whole array for raid1/raid10, hence IO for the
> array can be used directly for bitmap. However, bitmap is used for
> underlying disks for raid5, hence IO for the array can't be used
> directly for bitmap.
>
> Implement pers->bitmap_sector() for raid5 to convert IO ranges from the
> array to the underlying disks.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/raid5.c | 145 ++++++++++++++++++++++++++++++---------------
>  1 file changed, 98 insertions(+), 47 deletions(-)
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a5a619400d8f..5377f4c3fffc 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -63,6 +63,13 @@
>
>  #define RAID5_MAX_REQ_STRIPES 256
>
> +enum reshape_loc {
> +       LOC_NO_RESHAPE,
> +       LOC_AHEAD_OF_RESHAPE,
> +       LOC_INSIDE_RESHAPE,
> +       LOC_BEHIND_RESHAPE,
> +};
> +

It is unnecessary to move this enum definition and some functions.
I moved them back.

Thanks,
Song


>  static bool devices_handle_discard_safely =3D false;
>  module_param(devices_handle_discard_safely, bool, 0644);
>  MODULE_PARM_DESC(devices_handle_discard_safely,
> @@ -2947,6 +2954,94 @@ static void raid5_error(struct mddev *mddev, struc=
t md_rdev *rdev)
>         r5c_update_on_rdev_error(mddev, rdev);
>  }
>
> +static bool ahead_of_reshape(struct mddev *mddev, sector_t sector,
> +                            sector_t reshape_sector)
> +{
> +       return mddev->reshape_backwards ? sector < reshape_sector :
> +                                         sector >=3D reshape_sector;
> +}
> +
> +static bool range_ahead_of_reshape(struct mddev *mddev, sector_t min,
> +                                  sector_t max, sector_t reshape_sector)
> +{
> +       return mddev->reshape_backwards ? max < reshape_sector :
> +                                         min >=3D reshape_sector;
> +}
> +

[...]

> +static enum reshape_loc get_reshape_loc(struct mddev *mddev,
> +               struct r5conf *conf, sector_t logical_sector)
> +{
> +       sector_t reshape_progress, reshape_safe;
> +       /*
