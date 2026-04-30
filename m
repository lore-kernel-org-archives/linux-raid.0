Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB8226E710
	for <linux-raid@vger.kernel.org>; Thu, 30 Apr 2026 02:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777515787; cv=pass; b=jgWS8rizIbtvIQg10UoWW4t2JJuASEeyYnBLhzH5xPs/WrnDN55MoQiX4QCtoKQkGMP8xIgnFNmHZybszIUEKCe/6Gacfx+KGfZ1c9H4S7xISGG/7+/rbV9ax9AUbBF5olY6D0jrwu+T3xhrdPeUhrMVvqHbDDZd4kgdrV4LJeM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777515787; c=relaxed/simple;
	bh=46KV7rw+OTjToH+MashOEWceTG76HMfw7qFom5Z693o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f/DaBDIMw9OX+VObB3edndSBZwomuif5y4aOu4ResKqHAmn3dW9f6i026+BNeEDOB7LuedZVjU6pfo4uLaNIEHcYSY8cZ2BLauFfbatNCwSSe5DHZawtAtTN/+cRpRciwLwJqwh08/k4O+6aOSxd3dr7+9BQ0IZNA+wi3GNdQZc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W5uKXkZ3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=sG2OWi4p; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W5uKXkZ3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="sG2OWi4p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777515784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TtSEVx7WDKYpSKx7Jq2cqkcxTmW0fNJcYF8EVOY9iWE=;
	b=W5uKXkZ3qrL1ChTsTNtDpkkIhgBEAVTj9Glh/DL37Rwvt3ydJBStWvIgbKQAncPuhIkzS7
	5hIUZgIz8I7WnuNKBSWFqI/V+L86Vk7YHDDfPhElVaL9yHw3k9aNuKPmo82pD8jw5pt+3t
	0lAr1+CdJ77d+oIgT+9STOkho0uXWsw=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-619-8-Ve9y_DMpaweUX2RFnhGA-1; Wed, 29 Apr 2026 22:23:03 -0400
X-MC-Unique: 8-Ve9y_DMpaweUX2RFnhGA-1
X-Mimecast-MFC-AGG-ID: 8-Ve9y_DMpaweUX2RFnhGA_1777515782
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5a7437b4ff9so794858e87.0
        for <linux-raid@vger.kernel.org>; Wed, 29 Apr 2026 19:23:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777515780; cv=none;
        d=google.com; s=arc-20240605;
        b=D6isZ7DIzCMoy2/Y+U6w08rR1FA7i9SVtPerO0r6ydvXn6mJBlS0ATjWgQLwCwzFQL
         ayg0esyK1SJ/MnkHx0o77nGqpn1NW0iJ82nTRighl3tWwhLN+E63Dckxi3hi3Wctwcvj
         kJ0VqF52UbQMkRRtJWVZvb9U+CHkeuXv9vWTv5gX/SSXa4m1TGs7uGmv2bOgkiHOQfdT
         OHhaFmtw8zDUyTelX5FFvSkboNlQtKgA8UaJLrynFbP8PC6af3/RbXxoGMx6/GMSPh6W
         7ePRAezDNp6UFR5pLYGZ4iZEGd6PE1uSHpIp+s403UD6IT+BgDu9xa8GvnKkwfgy+jOX
         +UOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TtSEVx7WDKYpSKx7Jq2cqkcxTmW0fNJcYF8EVOY9iWE=;
        fh=13x98EdDYrQdK+DgWEfd8PyOVQaeC0kY3ReAPNWGgAE=;
        b=C2oUGO7UXFAU8mz+DDL3I1NdPucN30wC1/XsW2tLdJKUgOx0mC7JId9PjEtWYETJSD
         RfXTIZTB5RP/EXvlkyseU6kO6P+LU3XpmN53+pArtW3H0S2FkXw0XcG8BkJFe/LQR/cv
         b5zvhwYirsvGusoqSIu6XLBvW5GpIIA7yJNP50MHllh/zSoWR92UUK7xsJ2Ar+YhGlu8
         fmj5fza5doyTy15Wz/Z4WT8uVoSP5u0lJZzhDO1F0FpCSUfXHRvQUc45g7zBQU7A4lq9
         /0uxwTL9AblP4CytVHuG86qkCPLA0KMkkhRpiZo6Fl2/Ypz4SYA7YBiauRHsmwNkgRM0
         /NLw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777515780; x=1778120580; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TtSEVx7WDKYpSKx7Jq2cqkcxTmW0fNJcYF8EVOY9iWE=;
        b=sG2OWi4p4DnUD0lL/W+ZnzL9Fekih3JGWE/oHZHsj85FZOYqCGaW/9iBkuj1gbU5Cu
         9X9bSI8TlyEaw/gzQ3XZG7MvDELk5uVY8StMFttPKNhO193FOonKyFdcHs8OoktZ/6jA
         ZTvQjn7GvWzyOmFKWaRmE2/ODou+J0ON9/Vy1NRMsT+IyenkMxGVKnmTNZdNpgMIBOA+
         C/QVk1jWy9sBtABjFY+zU39wqhiZ7Fb9g4u1t6kP2gPwnptHzNVhjk+VAbu+USumzFbu
         sblnGPq2UtnUNM4Sm85lHjpX0KDp1UsUkCz1135HiZqew8KKB4r71GmlNGVLNJTSqEnH
         Ykuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777515780; x=1778120580;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TtSEVx7WDKYpSKx7Jq2cqkcxTmW0fNJcYF8EVOY9iWE=;
        b=lzmDeFvk+DrFp+2A7qA9KoGKj6aoAqSev7Rky+3pTXY/fAJjV9pWPh7zenIPuGY1rF
         mB0x29eJW3q7vKy1TnV6TExkn1PySRAgPOmoCH8YLCbaLhKS0RWQYxlKc7Fl7gtlgM92
         SLyc0YOoqdTn+AUZ1d+XlPd1+QArkQ1Nc55RDR+zbbGJkfpauXhKzvqxWe7cFwS6XMJC
         A0IOQHE5MDnTCbyzRrnKqXbmljfn3m5zib2bFUdUSHb/0TZmTwYnRmHpIulBgiBj7JLI
         emCjvC4MRmm53QdGhZbwo338ZhwQS1q/uSAsc6LXJ6q++cJrRZOxdA/W2V10tt7qG0aB
         qzSA==
X-Forwarded-Encrypted: i=1; AFNElJ+Fj8upkaLlVx+abamEem1WijYDL6TIkHV553cvEg39rFFy80wkbHmhvgVbsPHKdOpTS+4bJjvRSWko@vger.kernel.org
X-Gm-Message-State: AOJu0YxcqeJIuUBlkaFKHttVm+qE06JIMnyz0cZEYP5+E3gIdRqDWUWC
	FshjYvcB1A5Qyehyj8oVlIoKmyCWexceCjIpSzmlAt2hoNUwf+S2/pUJuj7R4jPkt9qnkU6UcbM
	nbwWdBSgWL5iHbbi1kXmYsTSHeQjw7fs/L5bCrUh7O64YL3nQ7lKM2VrQxJV7lLBLE6tTk32+TE
	XSqHz1TsMHKeoIrkVetfJnk1qyK5YZctgPFxVsJSMBnlPZtw==
X-Gm-Gg: AeBDietyGcgYTkhScvwVldW+5eTEyva3jMvCZnOvewVZ5XGO8h6OJyl5tT1qSy/akwN
	IBcu9XA0Ge9jlcGsMvXbPfFG39I/Ts42eWMRb4BjFVIlKMFpd19Kne1cuP9/Jd7Ela0oBet9L/B
	4kk4Bq3LT3VTJUQnUDcZb/cGITOVujfZdcXGbgexEynGAgzlg2nb7fbl+06hglyw+ywXLTRQr0R
	bh+SRKLwWXhmcUvILDKT3IloK6rsjbVANh8pxYi5FNSjmsNpd1ZvtoxgsSi9tikA6RZskqZX2Dy
	LcZgu+MpeHft
X-Received: by 2002:a05:6512:10cf:b0:5a4:15ea:7b20 with SMTP id 2adb3069b0e04-5a85271cd12mr147532e87.3.1777515780407;
        Wed, 29 Apr 2026 19:23:00 -0700 (PDT)
X-Received: by 2002:a05:6512:10cf:b0:5a4:15ea:7b20 with SMTP id
 2adb3069b0e04-5a85271cd12mr147520e87.3.1777515780015; Wed, 29 Apr 2026
 19:23:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416033801.786415-1-linan666@huaweicloud.com> <20260416033801.786415-8-linan666@huaweicloud.com>
In-Reply-To: <20260416033801.786415-8-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 30 Apr 2026 10:22:48 +0800
X-Gm-Features: AVHnY4L5M-ajczt8R3UlwaeEHd-3VmmxYGitI9Yy33H2zFWuC-zO8a3SQdBKJpo
Message-ID: <CALTww28niren-AYKU3XEaAtz+Sa_CP7rHboittWymYudbDWRGQ@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] md/raid1: fix IO error at logical block size granularity
To: linan666@huaweicloud.com
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 16, 2026 at 11:55=E2=80=AFAM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> RAID1 currently fixes IO error at PAGE_SIZE granularity. Fix at smaller
> granularity can handle more errors, and RAID will support logical block
> sizes larger than PAGE_SIZE in the future, where PAGE_SIZE IO will fail.
>
> Switch IO error fix granularity to logical block size.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> Reviewed-by: Yu Kuai <yukuai@fnnas.com>
> ---
>  drivers/md/raid1.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 724fd4f2cc3a..de8c964ca11d 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2116,7 +2116,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio=
)
>  {
>         /* Try some synchronous reads of other devices to get
>          * good data, much like with normal read errors.  Only
> -        * read into the pages we already have so we don't
> +        * read into the block we already have so we don't
>          * need to re-issue the read request.
>          * We don't need to freeze the array, because being in an
>          * active sync request, there is no normal IO, and
> @@ -2147,13 +2147,11 @@ static int fix_sync_read_error(struct r1bio *r1_b=
io)
>         }
>
>         while(sectors) {
> -               int s =3D sectors;
> +               int s =3D min_t(int, sectors, mddev->logical_block_size >=
> 9);
>                 int d =3D r1_bio->read_disk;
>                 int success =3D 0;
>                 int start;
>
> -               if (s > (PAGE_SIZE>>9))
> -                       s =3D PAGE_SIZE >> 9;
>                 do {
>                         if (r1_bio->bios[d]->bi_end_io =3D=3D end_sync_re=
ad) {
>                                 /* No rcu protection needed here devices
> @@ -2192,7 +2190,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio=
)
>                         if (abort)
>                                 return 0;
>
> -                       /* Try next page */
> +                       /* Try next block */
>                         sectors -=3D s;
>                         sect +=3D s;
>                         off +=3D s << 9;
> @@ -2390,14 +2388,11 @@ static void fix_read_error(struct r1conf *conf, s=
truct r1bio *r1_bio)
>         }
>
>         while(sectors) {
> -               int s =3D sectors;
> +               int s =3D min_t(int, sectors, mddev->logical_block_size >=
> 9);
>                 int d =3D read_disk;
>                 int success =3D 0;
>                 int start;
>
> -               if (s > (PAGE_SIZE>>9))
> -                       s =3D PAGE_SIZE >> 9;
> -
>                 do {
>                         rdev =3D conf->mirrors[d].rdev;
>                         if (rdev &&
> --
> 2.39.2
>
>

This patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

