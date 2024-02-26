Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59572129A8F
	for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 09:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708938922; cv=none; b=JzHdRJGfHTpHorfYz7n+F5Iu6ahOn7w0JroGoIg/wLRAursG5fym9g7HDgroz2Cfg7tGDUhY4VQ12MozFA/5XOeGDunU5Z1XEa3hH+Fg0szKFE9ZBmrO/F5498GXrv9Q3DfE1NgFU/QV0xzjpDc/N1IHz3LEyG0KSgxDiDDBpTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708938922; c=relaxed/simple;
	bh=OPslEpvTPGKWnBZFeMHtrwh2tuZS0bNiX5RiQgg4reo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dl+b6t7pJtAS/kize21JSc4wKLqx4+TRIY6NZU5P9wikVFC0ZuXbCfRMNut/DjeL6UBsJDU4F0exj6ocwyLKugemOuc7lHS9rM21+FXK9Yz2WGt/5MLPRbPfEy9yaDxDniMmb3yLRS5E+L9yN7OsZQBnvD6nS1WRlAikx2vJUQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Cp/uFrLr; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Cp/uFrLr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708938919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XM2rZSrkvpj1hoTBbAanVZWuvHXWVTnHCwh05d8mRxk=;
	b=Cp/uFrLrxxEqjZ4w+a1Zk9jF2V41ZGgj3kSfI32NuGy+XkcvOY/DsrM8GW2XJV4I140W+5
	xclE7i54n/IZIwLXaZlAaawLV+4uIQIx7C/yhG99T9E1zTjYE66gufDsoQB4AeH0XU8/tE
	r8RKLBuypO8YoVK9UT5ReoBeWeGyOtk=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-681-q37a7z1CNWS6i2Ri-8ud3g-1; Mon, 26 Feb 2024 04:15:16 -0500
X-MC-Unique: q37a7z1CNWS6i2Ri-8ud3g-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1d4212b6871so34645525ad.0
        for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 01:15:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708938916; x=1709543716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XM2rZSrkvpj1hoTBbAanVZWuvHXWVTnHCwh05d8mRxk=;
        b=O4I1AVWn1imq93j8QZ1BmDaB0UjwkALmFS+MBjbzL8QYkvA8UlFn6oHcbTrhurbWlp
         vwB8xK8pPRYlAx0rzI4W1yOr/m9JMJEzccO9jFNVgjwbjXshCqbBvI4/I+7P5Fxrllxz
         zpQ/EDs9C77LFqbK2NohDAK2alSzmnJ4hinRBGngYrD88UZ3hJ2FDls9/VuZDqqhalJw
         NpQ/63W0TL8Owzl5fUi/txFVCZyejAzTmwKYDp75Vk1+QicexouVWFaSIc13/fv4YcLS
         K5YjTRVkBTESgaqBnD0uj6mYuiLd02xsw2sneYydj5s0BIbKXstGZrpLlvZ9spqah8Vp
         muPg==
X-Forwarded-Encrypted: i=1; AJvYcCU0cglrannNxRRuuR28/NzVtUh6mx1RF5wz+MpSwmQy5uGSG59SeWdA9aoJs4HpJKD6AdZZ8MmzIMO4kNZkkbakpU4LLt3DZUI7zw==
X-Gm-Message-State: AOJu0YyWQzEtCI6wFCliof9db7D34alhpvBZCgyhZiK9Ps2K0N0edeSc
	lCOVDqzn4FmUsHp7SL+lOfYUvLEhqBx6VFdH4VAxpGM9Newzj6N5pc9raSI25dJl9rhEoFQRdPl
	mQY2jYDq1MIim4kRk/I+oaVEw+rbDBFe+80yUxvzWpHgFBF1AQAoScw0xeWmnkeFFg9RsBDbhyV
	97qqmsI1xir8NaRf7eEftTVUzEEKT8L/JvVQ==
X-Received: by 2002:a17:902:82cc:b0:1da:1e60:f9fe with SMTP id u12-20020a17090282cc00b001da1e60f9femr6496596plz.54.1708938915902;
        Mon, 26 Feb 2024 01:15:15 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGjtiAUPuzUBh4ubPX1A7L/YMlH/RSQKeJB9SeQOJhVhv0bZs2gncFg69XwV63F4kbstlJtlzKLWYqTjwHKI7s=
X-Received: by 2002:a17:902:82cc:b0:1da:1e60:f9fe with SMTP id
 u12-20020a17090282cc00b001da1e60f9femr6496587plz.54.1708938915603; Mon, 26
 Feb 2024 01:15:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240222075806.1816400-1-yukuai1@huaweicloud.com> <20240222075806.1816400-5-yukuai1@huaweicloud.com>
In-Reply-To: <20240222075806.1816400-5-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 26 Feb 2024 17:15:04 +0800
Message-ID: <CALTww2-heW83=h44Jo1+6urS1xkzm4EWBuoo_0R_Dn-RjiG9eg@mail.gmail.com>
Subject: Re: [PATCH md-6.9 04/10] md/raid1-10: add a helper raid1_check_read_range()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: paul.e.luse@linux.intel.com, song@kernel.org, neilb@suse.com, shli@fb.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 22, 2024 at 4:04=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> The checking and handler of bad blocks appear many timers during
> read_balance() in raid1 and raid10. This helper will be used in later
> patches to simplify read_balance() a lot.
>
> Co-developed-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Paul Luse <paul.e.luse@linux.intel.com>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/raid1-10.c | 49 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
>
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index 512746551f36..9bc0f0022a6c 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -227,3 +227,52 @@ static inline bool exceed_read_errors(struct mddev *=
mddev, struct md_rdev *rdev)
>
>         return false;
>  }
> +
> +/**
> + * raid1_check_read_range() - check a given read range for bad blocks,
> + * available read length is returned;
> + * @rdev: the rdev to read;
> + * @this_sector: read position;
> + * @len: read length;
> + *
> + * helper function for read_balance()
> + *
> + * 1) If there are no bad blocks in the range, @len is returned;
> + * 2) If the range are all bad blocks, 0 is returned;
> + * 3) If there are partial bad blocks:
> + *  - If the bad block range starts after @this_sector, the length of fi=
rst
> + *  good region is returned;
> + *  - If the bad block range starts before @this_sector, 0 is returned a=
nd
> + *  the @len is updated to the offset into the region before we get to t=
he
> + *  good blocks;
> + */
> +static inline int raid1_check_read_range(struct md_rdev *rdev,
> +                                        sector_t this_sector, int *len)
> +{
> +       sector_t first_bad;
> +       int bad_sectors;
> +
> +       /* no bad block overlap */
> +       if (!is_badblock(rdev, this_sector, *len, &first_bad, &bad_sector=
s))
> +               return *len;
> +
> +       /*
> +        * bad block range starts offset into our range so we can return =
the
> +        * number of sectors before the bad blocks start.
> +        */
> +       if (first_bad > this_sector)
> +               return first_bad - this_sector;
> +
> +       /* read range is fully consumed by bad blocks. */
> +       if (this_sector + *len <=3D first_bad + bad_sectors)
> +               return 0;
> +
> +       /*
> +        * final case, bad block range starts before or at the start of o=
ur
> +        * range but does not cover our entire range so we still return 0=
 but
> +        * update the length with the number of sectors before we get to =
the
> +        * good ones.
> +        */
> +       *len =3D first_bad + bad_sectors - this_sector;
> +       return 0;
> +}
> --
> 2.39.2
>
>

This patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

