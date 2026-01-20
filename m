Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87062F28EF
	for <linux-raid@vger.kernel.org>; Tue, 20 Jan 2026 16:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768924898; cv=pass; b=Os+hTXaIbBY0x2Ni+SolQRDBCpxBTfHhQqGnUqzzaPQRsxN/pgEEVqyFEYQJn+jxzHnGKFkfuGgJKQtr7qEmfhYRdHSRivqaMSnrIMGKTKOow6qW57ZLS7WVTXRUyMhvyZoN8x5CYWX1PgTXYPmVkDTf3GzaMejpOjsFRWctKpw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768924898; c=relaxed/simple;
	bh=mLfv/thHGLQ+osndvJHoRBacM5FXK//OGgzLE6EAoGA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OdU9P1z9X4Mix+Ccf0yNDWgw9au2gaH7Uz0A/9GGjls9CJN+nf8X7dHBsy58m8tpLkv4qdOgrsMKajSSd1+cz5GBjRFxRyK9PtYGtPT42ZXfOPvMsb8X8fDVaOy3TM3Y2YcBZPFOyZ8b7oz9cVRvi6AQewNyW8C4gP5ASuAzMgw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=D8LMkJvV; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Oq/uaK/b; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="D8LMkJvV";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Oq/uaK/b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768924895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OeE32QSk8Y91d80rk8ZwkvF0N1AVkW3hJHaP3MNSibE=;
	b=D8LMkJvV2Vtwic3gq8ZEg53VEdj10Z7GbtZ7fuHf3A9+Di9SfA4recVNeARw9OpKxHaQTQ
	AgnXJvvqarbxMMHeqXyy6F+PCXuLw2wMunNDZU5w/EekjOnVof+NewMAmCgefUhfB6ZElM
	UlfRG7XSTAfA9bm/8gEe4wKls56hPys=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-3BsFHnkXPviyUwEgFiTESw-1; Tue, 20 Jan 2026 11:01:32 -0500
X-MC-Unique: 3BsFHnkXPviyUwEgFiTESw-1
X-Mimecast-MFC-AGG-ID: 3BsFHnkXPviyUwEgFiTESw_1768924891
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-382f4c1fa42so24359161fa.0
        for <linux-raid@vger.kernel.org>; Tue, 20 Jan 2026 08:01:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768924891; cv=none;
        d=google.com; s=arc-20240605;
        b=ZO05vbVTjacimKR4jL4/ZvYjt3fELaqYSsfoYzxAWNLFtIQCjYleNZrq+tKsVT5kbX
         aVmgokYntIAFkZVRhHH3ujA7trPuRQ7WVUgLDnAF1jd7RX+r7bBUSJmyub4VDbN8vrNd
         daADJdxv1PQ2vQJp77hdgSepEaxgwmW/096Y1gGYX3SXF8VdGYLqkD66VdDB0SacEzVI
         tSex1YQ8hXuRGU7JGPYQ86cTdyy4b6AYVifcjVuk4kzgE84GnieO82iEI3GlmHWcPnbq
         r+bn9S6uku8QX2GyRQURs2Rbk+guIZU1xRAxwgc/ZzZ2ZjPUvNUTTyf3EcSsUxJPgjM5
         WciQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OeE32QSk8Y91d80rk8ZwkvF0N1AVkW3hJHaP3MNSibE=;
        fh=v0pp1zWYZh+aSR/Zk3/nXVbYfUHe2icicgcEBTqqoZw=;
        b=BE+GDt/Nw1IDR/Q+6asbr6KP+c71py2S5HVfuT/fGiUQyWKjMWDKyd31EkJN9vFaRH
         bUqxP8ESxLkUq+pdGBktrf1N5ePl8BZLJ/OvKPg6Ef8ZHaceiiB7VZjQ4bOqKUrTAhJy
         aAb4uC6nS4O1R8vI+l9vSV74Kke1WjXA5ncB5k5tdHhtMM9fwIlWNEM9AH8oNFo5nWK/
         nJ87RHbO29F2+EUVLD3FQLxiOeRjqMLnUQxz69rhNs1/m2R9vwLg3Z8JwYNdR4FqrwaS
         9ddsMJlFd+qM9D0bHhOkp8tBddaTzxBy3MthyPUDF26hIZ/LM2qIv0jNcqT3WavW+teY
         pQPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768924891; x=1769529691; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OeE32QSk8Y91d80rk8ZwkvF0N1AVkW3hJHaP3MNSibE=;
        b=Oq/uaK/bgsvUoUWnzZwL4UWkAs2f6dzhgVkjAg+M1BQhkUsUjRzL2Eq6NE8LfLknm+
         abCsFxDaiWn2oNsbIHwuYl5pLHqrCZZo3dfD4g++/cLwHad+3nDe5+xezgbeSWiihpst
         cphBifrAiUMrE5roZ1/MNjbkn01k9y0j8h2Od8dY+8v3mczmm2XEE31ncgVijP4hd2AP
         TnNy36cOfNWRR1oIiYWME4DX+2BM8pVSWE17tIVE1mZGLchgZX00fXkcJFYTITOoqX3u
         qOukuIv70xYs18JcQf/H+4KcHWVIWmzTpuiwVCbZk706D64X9qtWhX5xJfL8iqfYBBX4
         SHRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768924891; x=1769529691;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OeE32QSk8Y91d80rk8ZwkvF0N1AVkW3hJHaP3MNSibE=;
        b=BmlFApt+oJsgqDBSEPv8CExOhwWEH1VQAVnSnE+Bn+eIJJantdEfJ3Gc/laEfB1Sux
         PQ19oCtGig82M3T/0O+5AM2QAOadlp3TaSXJDDLpzGb80x0qvxNbwdxL0Rh8PqdOBRHZ
         nkXO1xCQqF3MNvqES/vXkP6vGakr8wLE0vNqRCIQIRoXkzL7TSJ2BZXjBg8XU1EPvo6X
         gGli4mLEzshYxbnGPsuTeoTz8oKpITC5T2JS2YtHPpOf8rO7gA/ChZJLjQ9xaaRWN6yI
         eFWMu532B+cF6TghKocVsMN8BmAGx8MeiGjVuStJ6W0AFR6rSC2wjOSVlq0iJGLAk3Tv
         G0rQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgdz5O5D8BpsgoleOwJRPrBzuUgGRl+NpebAUr7NLUYYByAQUvoVfusMrv8tvmLflqI99h/RLq+98q@vger.kernel.org
X-Gm-Message-State: AOJu0YwppG8tCW+J//cpfJpTM59axydOT9v2C0/2Gyed+zUf/4Y7094R
	uv+2q4IEPhp5yYJLpv6D8m2AWW9zy+HQsvwcBFgzhM1M5p8SE3Y1wYVHCma0QDu8iByz6xT66Yp
	KfFRPZ6TrlhF1e6uyIDqhEQtpQlDNGPVZtLUsknTGSqiaxgqckpfQQruZQx05ItoCf9lKbrMX+K
	SJGqV8EDsMSx7qgAFN1LiDzVdxQ+9kdlNEtb8fIg==
X-Gm-Gg: AZuq6aLyeIuT9CwWO8v/CvmRKsEFrM1IpTzIX1JSohx34lS45IXziCI8qBG8kUyd6cS
	3FSTTySnmqHz7L2YGiRIl8r04H97lILxwy1reb3aiEiCE3//tj74YIZtP0p/JD28ZPQadREgPpB
	U39EM00ssgBUpNrLSAcKco+CJjXEC2fYK1YyuDKM7veZ6mJYStgdb1RFj1Yu/3zZ1UQEsxt+T2m
	7MC8L7RxnOYI1K9maFdTP9rzy+mkF2F9TlHWJj1quKDWIGmr39lOva0/dWbPoM6S+7ShQ==
X-Received: by 2002:a2e:a585:0:b0:383:46e:4b50 with SMTP id 38308e7fff4ca-385a54a1852mr10835751fa.40.1768924890784;
        Tue, 20 Jan 2026 08:01:30 -0800 (PST)
X-Received: by 2002:a2e:a585:0:b0:383:46e:4b50 with SMTP id
 38308e7fff4ca-385a54a1852mr10835661fa.40.1768924890198; Tue, 20 Jan 2026
 08:01:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251217120013.2616531-1-linan666@huaweicloud.com> <20251217120013.2616531-8-linan666@huaweicloud.com>
In-Reply-To: <20251217120013.2616531-8-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 21 Jan 2026 00:01:17 +0800
X-Gm-Features: AZwV_Qg0CV9tPdMVZj5I144GG9ICXEmFvcmRVpxOWL1mzljwCPKjjYhiJnJ-jUQ
Message-ID: <CALTww2_ueZsHvk-=x6xcnxsZO9_U2CPZ=sSTMKM=rwUpQUsgkw@mail.gmail.com>
Subject: Re: [PATCH 07/15] md: Clean up folio sync support related code
To: linan666@huaweicloud.com
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2025 at 8:11=E2=80=AFPM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> 1. Remove resync_get_all_folio() and invoke folio_get() directly instead.
> 2. Clean up redundant while(0) loop in md_bio_reset_resync_folio().
> 3. Clean up bio variable by directly referencing r10_bio->devs[j].bio
>    instead in r1buf_pool_alloc() and r10buf_pool_alloc().
> 4. Clean up RESYNC_PAGES.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>  drivers/md/raid1-10.c | 22 ++++++----------------
>  drivers/md/raid1.c    |  6 ++----
>  drivers/md/raid10.c   |  6 ++----
>  3 files changed, 10 insertions(+), 24 deletions(-)
>
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index b8f2cc32606f..568ab002691f 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -1,7 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /* Maximum size of each resync request */
>  #define RESYNC_BLOCK_SIZE (64*1024)
> -#define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
>  #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
>
>  /*
> @@ -56,11 +55,6 @@ static inline void resync_free_folio(struct resync_fol=
io *rf)
>         folio_put(rf->folio);
>  }
>
> -static inline void resync_get_all_folio(struct resync_folio *rf)
> -{
> -       folio_get(rf->folio);
> -}
> -
>  static inline struct folio *resync_fetch_folio(struct resync_folio *rf)
>  {
>         return rf->folio;
> @@ -80,16 +74,12 @@ static void md_bio_reset_resync_folio(struct bio *bio=
, struct resync_folio *rf,
>                                int size)
>  {
>         /* initialize bvec table again */
> -       do {
> -               struct folio *folio =3D resync_fetch_folio(rf);
> -               int len =3D min_t(int, size, RESYNC_BLOCK_SIZE);
> -
> -               if (WARN_ON(!bio_add_folio(bio, folio, len, 0))) {
> -                       bio->bi_status =3D BLK_STS_RESOURCE;
> -                       bio_endio(bio);
> -                       return;
> -               }
> -       } while (0);
> +       if (WARN_ON(!bio_add_folio(bio, resync_fetch_folio(rf),
> +                                  min_t(int, size, RESYNC_BLOCK_SIZE),
> +                                  0))) {
> +               bio->bi_status =3D BLK_STS_RESOURCE;
> +               bio_endio(bio);
> +       }
>  }
>
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 370bdecf5487..f01bab41da95 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -181,18 +181,16 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, voi=
d *data)
>         for (j =3D 0; j < conf->raid_disks * 2; j++) {
>                 struct resync_folio *rf =3D &rfs[j];
>
> -               bio =3D r1_bio->bios[j];
> -
>                 if (j < need_folio) {
>                         if (resync_alloc_folio(rf, gfp_flags))
>                                 goto out_free_folio;
>                 } else {
>                         memcpy(rf, &rfs[0], sizeof(*rf));
> -                       resync_get_all_folio(rf);
> +                       folio_get(rf->folio);
>                 }
>
>                 rf->raid_bio =3D r1_bio;
> -               bio->bi_private =3D rf;
> +               r1_bio->bios[j]->bi_private =3D rf;
>         }
>
>         r1_bio->master_bio =3D NULL;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index c93706806358..a03afa9a6a5b 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -183,19 +183,17 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, vo=
id *data)
>                 if (rbio)
>                         rf_repl =3D &rfs[nalloc + j];
>
> -               bio =3D r10_bio->devs[j].bio;
> -
>                 if (!j || test_bit(MD_RECOVERY_SYNC,
>                                    &conf->mddev->recovery)) {
>                         if (resync_alloc_folio(rf, gfp_flags))
>                                 goto out_free_pages;
>                 } else {
>                         memcpy(rf, &rfs[0], sizeof(*rf));
> -                       resync_get_all_folio(rf);
> +                       folio_get(rf->folio);
>                 }
>
>                 rf->raid_bio =3D r10_bio;
> -               bio->bi_private =3D rf;
> +               r10_bio->devs[j].bio->bi_private =3D rf;
>                 if (rbio) {
>                         memcpy(rf_repl, rf, sizeof(*rf));
>                         rbio->bi_private =3D rf_repl;
> --
> 2.39.2
>

Reviewed-by: Xiao Ni <xni@redhat.com>

