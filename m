Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F90B46AEF2
	for <linux-raid@vger.kernel.org>; Tue, 20 Jan 2026 15:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768924427; cv=pass; b=hbp+9q25xhjG/WBudBx1LWHevc/MWDHsB5E8dcRYb0mQLfPVbOyGEPcedjtJfZsg+aUPVwwR8VgyF969qKEfNWjJIro7rhLgmo8yVanebX/+6ZTwm8GsgKrcuy21ILetBmO2FKcuMo8eop2A9nQTU3ujAi+6vkL3UywJlRDOL3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768924427; c=relaxed/simple;
	bh=wYj3EeM70nyeIH2YQci7y71hW+LEFujRJXtw6zRxiLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lRks+xe6uZOuc7wH5xkRrXQbE7x1IZ549VkHLsS9iXUsMpNLch4xzrbCVlOU6Jae/wojHpR6MIm8WeFBBI1q+HEz2G6RNP8Z9peUH3xteg/QOH24a2rknu+DhNTSXfCmmQuvz9sILs6wKaWmkzZGBUgEQ+6n4QTyn3PuLk6gin0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XxFZ5P4e; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bwnaJreP; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XxFZ5P4e";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bwnaJreP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768924423;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lkjO8sVjimNJC4/uw9zTKAQEiGtV4vC8KiLMDJM2aPs=;
	b=XxFZ5P4e/m2Te0ul2Y/lxLvIUGPUkLctmntd6U+5HnhKe84wAjUq2mXO5ozfvzPyAASLz+
	DvnJaoCK6LkayhEcG1qmRHyJ3gY93M0dbB1eZJ1O/jzdXMXUdZf9G3C+p5d+1rPDwiEjqc
	EiaTWlScN3R8vBgrL/CjtX3rn/2eAL0=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-YzwaKJAyNcy0m5irb1rKVQ-1; Tue, 20 Jan 2026 10:53:41 -0500
X-MC-Unique: YzwaKJAyNcy0m5irb1rKVQ-1
X-Mimecast-MFC-AGG-ID: YzwaKJAyNcy0m5irb1rKVQ_1768924420
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-3831426aeb1so32560031fa.3
        for <linux-raid@vger.kernel.org>; Tue, 20 Jan 2026 07:53:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768924419; cv=none;
        d=google.com; s=arc-20240605;
        b=U4QfvzOxg2g7wON5zGNQNtwZpoEHW4cm6HXZ/Q1EpVomtEQXcZIl/eLXjtcp/FsC4L
         rVXx8Q4xEyExtjVU6ghhs8xFdZLBLDLK5fn3OgRmR3f2HAhqfCliEu3CUpOaHIKFm71u
         3HrSG/+Wj7LW+8WhH8vrrxx/hIkfHRcJh5SBnMBShG61r7ZLLi4DkrySBIlqJZsty7RI
         x60WacnVRKsajoMKPUicvOjyBikmk7ux/uB/+bqcyaonRvCNM9sEZQOaEVvJEBVm3xwU
         LbwXm7RXQWR6rwdvFNIkHqoyIbEOmSN/drsj5nIR1hEr7i5g7iBymAmvonkEB8BgiGzr
         YStA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lkjO8sVjimNJC4/uw9zTKAQEiGtV4vC8KiLMDJM2aPs=;
        fh=gjQ/aOrN1Ac+QNX0LaxF/rXpM1111zpua/+EcXo5sLA=;
        b=FacobEWxtJFFQEf4wWZO9SpeMEu/P+Z3AMSSb6Lmkx7MA4RVzxBIq9nFLr9SPIu0Gn
         8W1YGIPJ9CHf5jA+QD7fde9oA8E1a6srr8U7FGKavGNv4nTHPcSoFhnZFMQBoXNXMTLv
         wuGvRdE3jMqRyH+2MLJwO1lAr1DcRLYrHouMmbSH2dOc22gy4vOJoCiTSh5scMCSLf4s
         3W1IBdQI7ACdcuts9RkiytIWjtCO9Lee3gR+kppJxiJW2/hg+PagwncSchlr76lttswt
         Jab2UOtM0LbpHcqm9/jRRncpeKInS2mITxU/oJDmUYBlItyaUxpgBfnBd5GAvsesk0gc
         hbWA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768924419; x=1769529219; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkjO8sVjimNJC4/uw9zTKAQEiGtV4vC8KiLMDJM2aPs=;
        b=bwnaJreP2pRiSZ+LF1PxjELseRpF1wa46SBaOhfGm/tZocMQFkQe/I6RquoX23pnCm
         UB60EgRhwOrXWqPjEcAbcbUybN4OPnciLsiyp757xoR7stw83r1STfqYpnZigLzmoQAS
         zhUtRXsNki7y87+K8n2s2wclVhxUc4RDM+unirqSNl/9NSamxP/OXpyAPZJ4+B9rIJWJ
         llOec8NKTydRmRCfOQsRfpIPlhr/raA7C8AtQYrwXu8aq5UVsacO++OoG/Mq5YMG5H1O
         2+PG6EssFr0FTDF5mTu423+f3P2SRJ/Qckr4SbNXSRx01KADp825s+sEmtK7un4R12ZB
         KR4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768924419; x=1769529219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lkjO8sVjimNJC4/uw9zTKAQEiGtV4vC8KiLMDJM2aPs=;
        b=beuv7UWV4K5Y0QqQfDyT/EWNA9wyULye0OnMMMyPvTnCHHB9J2Zy/9Fyp6k2v3vgr1
         DuymV0bHGhuf5hp4qUyq+0HMZelJvO8EMxkXM9VIFjg9nwW7xr8B3nXsqqB82iyROoYl
         telviGH2uci8ks5VXKorYSt7R4U+E46hYp3R3cZhT1Lin/Fh0eKAGIx+YVcIl/5mxYr5
         Mx8ltrV0XRUYZDWbiqVHB5Cxa4qazwZVwYIZXdk7KLMOh4W5Zna+cdamrEUDopAygYOJ
         yC7FREoirTkOt40LWXvTntD8Uzl6gAEDajWYEdnXHYizkTmVmcN09AygRkyCoeO4ryvX
         kv3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWG+8nQmN4t8oCfHsJIrOnHFgKQwFSzCS97Zqt1AR8GDL4idmjIIYbDAcVIcvj90IkfNf16fNecbkT7@vger.kernel.org
X-Gm-Message-State: AOJu0YzYZMq3Ytm/XoDAnp0QlAanj7glQBzX80xj7HyL+RyZtoHkzWYP
	WLEHRACNp/gUolDZDDD6ZxekxstJoJstc7AM5/Xhho5Z8ACOWPOaedQciRwEqEYQZf3wiSRVrSd
	z7ErJ5bL6Koj22LDBsJagnSRKg/S7fPZkyp1C0HCVy+WYvm+GH0JozqJeg7fgF4vqMVKI4zCosw
	eDvPo/YNDO4Cf0mgP328Xbr5Mc3tNpT/qMdr0lug==
X-Gm-Gg: AZuq6aKn38AkKP4TQB1xyLshD5TT8Fnfw6awMUPvd/C7XvlPC6tQCPKcMNmdRp1Lk0k
	IusH2ez+DNAHrcraR67OPN2uMufNhSY/omsNHjp1c3Cw0UrJWcJCbaTM9ahL0z4qvIv4Xn1b1Yq
	2sf1J6k/VneZxGm3e5t+ov5yNhJ+CZukMVqGCYOzc7zeXlxabWugm3ZA6hXOsY4rU1aNxcRm9CD
	hRvmq/Ogkc/5s9mD+gVQjnqftv0lsxXmvm8WAtHgu0GVka7ZjCsnrpOH2uAKxmP/OHPZg==
X-Received: by 2002:a05:651c:1509:b0:37f:d484:59b8 with SMTP id 38308e7fff4ca-383866b22b8mr59423551fa.7.1768924419157;
        Tue, 20 Jan 2026 07:53:39 -0800 (PST)
X-Received: by 2002:a05:651c:1509:b0:37f:d484:59b8 with SMTP id
 38308e7fff4ca-383866b22b8mr59423331fa.7.1768924418310; Tue, 20 Jan 2026
 07:53:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251217120013.2616531-1-linan666@huaweicloud.com> <20251217120013.2616531-7-linan666@huaweicloud.com>
In-Reply-To: <20251217120013.2616531-7-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 20 Jan 2026 23:53:25 +0800
X-Gm-Features: AZwV_Qhgo6jVltuu4UP0hb0uTRGnaRpNZ75ySOQ9jMbUWERxAx-04HxLRnsstM0
Message-ID: <CALTww28w8EJL2TVs06f_h98SjkiGAiYD9+BUvqEG2HKsrssSsg@mail.gmail.com>
Subject: Re: [PATCH 06/15] md/raid1,raid10: use folio for sync path IO
To: linan666@huaweicloud.com
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2025 at 8:11=E2=80=AFPM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> Convert all IO on the sync path to use folios. Rename page-related
> identifiers to match folio.
>
> Retain some now-unnecessary while and for loops to minimize code
> changes, clean them up in a subsequent patch.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>  drivers/md/md.c       |   2 +-
>  drivers/md/raid1-10.c |  60 ++++--------
>  drivers/md/raid1.c    | 155 ++++++++++++++-----------------
>  drivers/md/raid10.c   | 207 +++++++++++++++++++-----------------------
>  4 files changed, 179 insertions(+), 245 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0732bbcdb95d..dac03b831efa 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9409,7 +9409,7 @@ static bool sync_io_within_limit(struct mddev *mdde=
v)
>  {
>         /*
>          * For raid456, sync IO is stripe(4k) per IO, for other levels, i=
t's
> -        * RESYNC_PAGES(64k) per IO.
> +        * RESYNC_BLOCK_SIZE(64k) per IO.
>          */
>         return atomic_read(&mddev->recovery_active) <
>                (raid_is_456(mddev) ? 8 : 128) * sync_io_depth(mddev);
> diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
> index 260d7fd7ccbe..b8f2cc32606f 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -25,9 +25,9 @@
>  #define MAX_PLUG_BIO 32
>
>  /* for managing resync I/O pages */
> -struct resync_pages {
> +struct resync_folio {
>         void            *raid_bio;
> -       struct page     *pages[RESYNC_PAGES];
> +       struct folio    *folio;
>  };
>
>  struct raid1_plug_cb {
> @@ -41,77 +41,55 @@ static void rbio_pool_free(void *rbio, void *data)
>         kfree(rbio);
>  }
>
> -static inline int resync_alloc_pages(struct resync_pages *rp,
> +static inline int resync_alloc_folio(struct resync_folio *rf,
>                                      gfp_t gfp_flags)
>  {
> -       int i;
> -
> -       for (i =3D 0; i < RESYNC_PAGES; i++) {
> -               rp->pages[i] =3D alloc_page(gfp_flags);
> -               if (!rp->pages[i])
> -                       goto out_free;
> -       }
> +       rf->folio =3D folio_alloc(gfp_flags, get_order(RESYNC_BLOCK_SIZE)=
);
> +       if (!rf->folio)
> +               return -ENOMEM;

Is it ok to add an error log here? Compare with the multipage
situation, the possibility of failure will be somewhat higher because
it needs to alloc a contiguous block of physical memory.

>
>         return 0;
> -
> -out_free:
> -       while (--i >=3D 0)
> -               put_page(rp->pages[i]);
> -       return -ENOMEM;
>  }
>
> -static inline void resync_free_pages(struct resync_pages *rp)
> +static inline void resync_free_folio(struct resync_folio *rf)
>  {
> -       int i;
> -
> -       for (i =3D 0; i < RESYNC_PAGES; i++)
> -               put_page(rp->pages[i]);
> +       folio_put(rf->folio);
>  }
>
> -static inline void resync_get_all_pages(struct resync_pages *rp)
> +static inline void resync_get_all_folio(struct resync_folio *rf)
>  {
> -       int i;
> -
> -       for (i =3D 0; i < RESYNC_PAGES; i++)
> -               get_page(rp->pages[i]);
> +       folio_get(rf->folio);
>  }
>
> -static inline struct page *resync_fetch_page(struct resync_pages *rp,
> -                                            unsigned idx)
> +static inline struct folio *resync_fetch_folio(struct resync_folio *rf)
>  {
> -       if (WARN_ON_ONCE(idx >=3D RESYNC_PAGES))
> -               return NULL;
> -       return rp->pages[idx];
> +       return rf->folio;
>  }
>
>  /*
> - * 'strct resync_pages' stores actual pages used for doing the resync
> + * 'strct resync_folio' stores actual pages used for doing the resync
>   *  IO, and it is per-bio, so make .bi_private points to it.
>   */
> -static inline struct resync_pages *get_resync_pages(struct bio *bio)
> +static inline struct resync_folio *get_resync_folio(struct bio *bio)
>  {
>         return bio->bi_private;
>  }
>
>  /* generally called after bio_reset() for reseting bvec */
> -static void md_bio_reset_resync_pages(struct bio *bio, struct resync_pag=
es *rp,
> +static void md_bio_reset_resync_folio(struct bio *bio, struct resync_fol=
io *rf,
>                                int size)
>  {
> -       int idx =3D 0;
> -
>         /* initialize bvec table again */
>         do {
> -               struct page *page =3D resync_fetch_page(rp, idx);
> -               int len =3D min_t(int, size, PAGE_SIZE);
> +               struct folio *folio =3D resync_fetch_folio(rf);
> +               int len =3D min_t(int, size, RESYNC_BLOCK_SIZE);
>
> -               if (WARN_ON(!bio_add_page(bio, page, len, 0))) {
> +               if (WARN_ON(!bio_add_folio(bio, folio, len, 0))) {

Is it ok to use bio_add_folio(bio, folio, RESYNC_BLOCK_SIZE, 0)
directly here? It removes `size -=3D len` below, so it's not useless to
compare size and RESYNC_BLOCK_SIZE above?

>                         bio->bi_status =3D BLK_STS_RESOURCE;
>                         bio_endio(bio);
>                         return;
>                 }
> -
> -               size -=3D len;
> -       } while (idx++ < RESYNC_PAGES && size > 0);
> +       } while (0);
>  }
>
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 43453f1a04f4..370bdecf5487 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -120,11 +120,11 @@ static void remove_serial(struct md_rdev *rdev, sec=
tor_t lo, sector_t hi)
>
>  /*
>   * for resync bio, r1bio pointer can be retrieved from the per-bio
> - * 'struct resync_pages'.
> + * 'struct resync_folio'.
>   */
>  static inline struct r1bio *get_resync_r1bio(struct bio *bio)
>  {
> -       return get_resync_pages(bio)->raid_bio;
> +       return get_resync_folio(bio)->raid_bio;
>  }
>
>  static void *r1bio_pool_alloc(gfp_t gfp_flags, struct r1conf *conf)
> @@ -146,70 +146,69 @@ static void * r1buf_pool_alloc(gfp_t gfp_flags, voi=
d *data)
>         struct r1conf *conf =3D data;
>         struct r1bio *r1_bio;
>         struct bio *bio;
> -       int need_pages;
> +       int need_folio;
>         int j;
> -       struct resync_pages *rps;
> +       struct resync_folio *rfs;
>
>         r1_bio =3D r1bio_pool_alloc(gfp_flags, conf);
>         if (!r1_bio)
>                 return NULL;
>
> -       rps =3D kmalloc_array(conf->raid_disks * 2, sizeof(struct resync_=
pages),
> +       rfs =3D kmalloc_array(conf->raid_disks * 2, sizeof(struct resync_=
folio),
>                             gfp_flags);
> -       if (!rps)
> +       if (!rfs)
>                 goto out_free_r1bio;
>
>         /*
>          * Allocate bios : 1 for reading, n-1 for writing
>          */
>         for (j =3D conf->raid_disks * 2; j-- ; ) {
> -               bio =3D bio_kmalloc(RESYNC_PAGES, gfp_flags);
> +               bio =3D bio_kmalloc(1, gfp_flags);
>                 if (!bio)
>                         goto out_free_bio;
> -               bio_init_inline(bio, NULL, RESYNC_PAGES, 0);
> +               bio_init_inline(bio, NULL, 1, 0);
>                 r1_bio->bios[j] =3D bio;
>         }
>         /*
> -        * Allocate RESYNC_PAGES data pages and attach them to
> -        * the first bio.
> +        * Allocate data folio and attach them to the first bio.

typo error
s/attach them/attach it/g

>          * If this is a user-requested check/repair, allocate
> -        * RESYNC_PAGES for each bio.
> +        * folio for each bio.
>          */
>         if (test_bit(MD_RECOVERY_REQUESTED, &conf->mddev->recovery))
> -               need_pages =3D conf->raid_disks * 2;
> +               need_folio =3D conf->raid_disks * 2;
>         else
> -               need_pages =3D 1;
> +               need_folio =3D 1;
>         for (j =3D 0; j < conf->raid_disks * 2; j++) {
> -               struct resync_pages *rp =3D &rps[j];
> +               struct resync_folio *rf =3D &rfs[j];
>
>                 bio =3D r1_bio->bios[j];
>
> -               if (j < need_pages) {
> -                       if (resync_alloc_pages(rp, gfp_flags))
> -                               goto out_free_pages;
> +               if (j < need_folio) {
> +                       if (resync_alloc_folio(rf, gfp_flags))
> +                               goto out_free_folio;
>                 } else {
> -                       memcpy(rp, &rps[0], sizeof(*rp));
> -                       resync_get_all_pages(rp);
> +                       memcpy(rf, &rfs[0], sizeof(*rf));
> +                       resync_get_all_folio(rf);
>                 }
>
> -               rp->raid_bio =3D r1_bio;
> -               bio->bi_private =3D rp;
> +               rf->raid_bio =3D r1_bio;
> +               bio->bi_private =3D rf;
>         }
>
>         r1_bio->master_bio =3D NULL;
>
>         return r1_bio;
>
> -out_free_pages:
> +out_free_folio:
>         while (--j >=3D 0)
> -               resync_free_pages(&rps[j]);
> +               resync_free_folio(&rfs[j]);
>
>  out_free_bio:
>         while (++j < conf->raid_disks * 2) {
>                 bio_uninit(r1_bio->bios[j]);
>                 kfree(r1_bio->bios[j]);
>         }
> -       kfree(rps);
> +       kfree(rfs);
>
>  out_free_r1bio:
>         rbio_pool_free(r1_bio, data);
> @@ -221,17 +220,17 @@ static void r1buf_pool_free(void *__r1_bio, void *d=
ata)
>         struct r1conf *conf =3D data;
>         int i;
>         struct r1bio *r1bio =3D __r1_bio;
> -       struct resync_pages *rp =3D NULL;
> +       struct resync_folio *rf =3D NULL;
>
>         for (i =3D conf->raid_disks * 2; i--; ) {
> -               rp =3D get_resync_pages(r1bio->bios[i]);
> -               resync_free_pages(rp);
> +               rf =3D get_resync_folio(r1bio->bios[i]);
> +               resync_free_folio(rf);
>                 bio_uninit(r1bio->bios[i]);
>                 kfree(r1bio->bios[i]);
>         }
>
> -       /* resync pages array stored in the 1st bio's .bi_private */
> -       kfree(rp);
> +       /* resync folio stored in the 1st bio's .bi_private */
> +       kfree(rf);
>
>         rbio_pool_free(r1bio, data);
>  }
> @@ -2095,10 +2094,10 @@ static void end_sync_write(struct bio *bio)
>         put_sync_write_buf(r1_bio);
>  }
>
> -static int r1_sync_page_io(struct md_rdev *rdev, sector_t sector,
> -                          int sectors, struct page *page, blk_opf_t rw)
> +static int r1_sync_folio_io(struct md_rdev *rdev, sector_t sector, int s=
ectors,
> +                           int off, struct folio *folio, blk_opf_t rw)
>  {
> -       if (sync_page_io(rdev, sector, sectors << 9, page, rw, false))
> +       if (sync_folio_io(rdev, sector, sectors << 9, off, folio, rw, fal=
se))
>                 /* success */
>                 return 1;
>         if (rw =3D=3D REQ_OP_WRITE) {
> @@ -2129,10 +2128,10 @@ static int fix_sync_read_error(struct r1bio *r1_b=
io)
>         struct mddev *mddev =3D r1_bio->mddev;
>         struct r1conf *conf =3D mddev->private;
>         struct bio *bio =3D r1_bio->bios[r1_bio->read_disk];
> -       struct page **pages =3D get_resync_pages(bio)->pages;
> +       struct folio *folio =3D get_resync_folio(bio)->folio;
>         sector_t sect =3D r1_bio->sector;
>         int sectors =3D r1_bio->sectors;
> -       int idx =3D 0;
> +       int off =3D 0;
>         struct md_rdev *rdev;
>
>         rdev =3D conf->mirrors[r1_bio->read_disk].rdev;
> @@ -2162,9 +2161,8 @@ static int fix_sync_read_error(struct r1bio *r1_bio=
)
>                                  * active, and resync is currently active
>                                  */
>                                 rdev =3D conf->mirrors[d].rdev;
> -                               if (sync_page_io(rdev, sect, s<<9,
> -                                                pages[idx],
> -                                                REQ_OP_READ, false)) {
> +                               if (sync_folio_io(rdev, sect, s<<9, off, =
folio,
> +                                                 REQ_OP_READ, false)) {
>                                         success =3D 1;
>                                         break;
>                                 }
> @@ -2197,7 +2195,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio=
)
>                         /* Try next page */
>                         sectors -=3D s;
>                         sect +=3D s;
> -                       idx++;
> +                       off +=3D s << 9;
>                         continue;
>                 }
>
> @@ -2210,8 +2208,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio=
)
>                         if (r1_bio->bios[d]->bi_end_io !=3D end_sync_read=
)
>                                 continue;
>                         rdev =3D conf->mirrors[d].rdev;
> -                       if (r1_sync_page_io(rdev, sect, s,
> -                                           pages[idx],
> +                       if (r1_sync_folio_io(rdev, sect, s, off, folio,
>                                             REQ_OP_WRITE) =3D=3D 0) {
>                                 r1_bio->bios[d]->bi_end_io =3D NULL;
>                                 rdev_dec_pending(rdev, mddev);
> @@ -2225,14 +2222,13 @@ static int fix_sync_read_error(struct r1bio *r1_b=
io)
>                         if (r1_bio->bios[d]->bi_end_io !=3D end_sync_read=
)
>                                 continue;
>                         rdev =3D conf->mirrors[d].rdev;
> -                       if (r1_sync_page_io(rdev, sect, s,
> -                                           pages[idx],
> +                       if (r1_sync_folio_io(rdev, sect, s, off, folio,
>                                             REQ_OP_READ) !=3D 0)
>                                 atomic_add(s, &rdev->corrected_errors);
>                 }
>                 sectors -=3D s;
>                 sect +=3D s;
> -               idx ++;
> +               off +=3D s << 9;
>         }
>         set_bit(R1BIO_Uptodate, &r1_bio->state);
>         bio->bi_status =3D 0;
> @@ -2252,14 +2248,12 @@ static void process_checks(struct r1bio *r1_bio)
>         struct r1conf *conf =3D mddev->private;
>         int primary;
>         int i;
> -       int vcnt;
>
>         /* Fix variable parts of all bios */
> -       vcnt =3D (r1_bio->sectors + PAGE_SIZE / 512 - 1) >> (PAGE_SHIFT -=
 9);
>         for (i =3D 0; i < conf->raid_disks * 2; i++) {
>                 blk_status_t status;
>                 struct bio *b =3D r1_bio->bios[i];
> -               struct resync_pages *rp =3D get_resync_pages(b);
> +               struct resync_folio *rf =3D get_resync_folio(b);
>                 if (b->bi_end_io !=3D end_sync_read)
>                         continue;
>                 /* fixup the bio for reuse, but preserve errno */
> @@ -2269,11 +2263,11 @@ static void process_checks(struct r1bio *r1_bio)
>                 b->bi_iter.bi_sector =3D r1_bio->sector +
>                         conf->mirrors[i].rdev->data_offset;
>                 b->bi_end_io =3D end_sync_read;
> -               rp->raid_bio =3D r1_bio;
> -               b->bi_private =3D rp;
> +               rf->raid_bio =3D r1_bio;
> +               b->bi_private =3D rf;
>
>                 /* initialize bvec table again */
> -               md_bio_reset_resync_pages(b, rp, r1_bio->sectors << 9);
> +               md_bio_reset_resync_folio(b, rf, r1_bio->sectors << 9);
>         }
>         for (primary =3D 0; primary < conf->raid_disks * 2; primary++)
>                 if (r1_bio->bios[primary]->bi_end_io =3D=3D end_sync_read=
 &&
> @@ -2284,44 +2278,30 @@ static void process_checks(struct r1bio *r1_bio)
>                 }
>         r1_bio->read_disk =3D primary;
>         for (i =3D 0; i < conf->raid_disks * 2; i++) {
> -               int j =3D 0;
>                 struct bio *pbio =3D r1_bio->bios[primary];
>                 struct bio *sbio =3D r1_bio->bios[i];
>                 blk_status_t status =3D sbio->bi_status;
> -               struct page **ppages =3D get_resync_pages(pbio)->pages;
> -               struct page **spages =3D get_resync_pages(sbio)->pages;
> -               struct bio_vec *bi;
> -               int page_len[RESYNC_PAGES] =3D { 0 };
> -               struct bvec_iter_all iter_all;
> +               struct folio *pfolio =3D get_resync_folio(pbio)->folio;
> +               struct folio *sfolio =3D get_resync_folio(sbio)->folio;
>
>                 if (sbio->bi_end_io !=3D end_sync_read)
>                         continue;
>                 /* Now we can 'fixup' the error value */
>                 sbio->bi_status =3D 0;
>
> -               bio_for_each_segment_all(bi, sbio, iter_all)
> -                       page_len[j++] =3D bi->bv_len;
> -
> -               if (!status) {
> -                       for (j =3D vcnt; j-- ; ) {
> -                               if (memcmp(page_address(ppages[j]),
> -                                          page_address(spages[j]),
> -                                          page_len[j]))
> -                                       break;
> -                       }
> -               } else
> -                       j =3D 0;
> -               if (j >=3D 0)
> +               if (status || memcmp(folio_address(pfolio),
> +                                    folio_address(sfolio),
> +                                    r1_bio->sectors << 9)) {
>                         atomic64_add(r1_bio->sectors, &mddev->resync_mism=
atches);
> -               if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recover=
y)
> -                             && !status)) {
> -                       /* No need to write to this device. */
> -                       sbio->bi_end_io =3D NULL;
> -                       rdev_dec_pending(conf->mirrors[i].rdev, mddev);
> -                       continue;
> +                       if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery=
)) {
> +                               bio_copy_data(sbio, pbio);
> +                               continue;
> +                       }

The logic is changed here. The original logic:
1. read ok, no mismatch: no bio_copy_data
2. read ok, mismatch, check: no bio_copy_data
3. read ok, mismatch, no check: need bio_copy_data
4. read fail: need bio_copy_data

The 4 is broken.

How about adding a temporary need_write to make logic more clear?

something like:
        if (!status) {
            int ret =3D 0;
            ret =3D memcpy(folio_address(pfolio),
                             folio_address(sfolio),
                             r1_bio->sectors << 9);
            if (ret) {
                atomic64_add(r1_bio->sectors, &mddev->resync_mismatches);
                if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
                    need_write =3D true;
            }
        } else
            need_write =3D true;

        if (need_write)
            bio_copy_data(sbio, pbio);
        else {
            /* No need to write to this device. */
            sbio->bi_end_io =3D NULL;
            rdev_dec_pending(conf->mirrors[i].rdev, mddev);
        }

>                 }
>
> -               bio_copy_data(sbio, pbio);
> +               /* No need to write to this device. */
> +               sbio->bi_end_io =3D NULL;
> +               rdev_dec_pending(conf->mirrors[i].rdev, mddev);
>         }
>  }
>
> @@ -2446,9 +2426,8 @@ static void fix_read_error(struct r1conf *conf, str=
uct r1bio *r1_bio)
>                         if (rdev &&
>                             !test_bit(Faulty, &rdev->flags)) {
>                                 atomic_inc(&rdev->nr_pending);
> -                               r1_sync_page_io(rdev, sect, s,
> -                                               folio_page(conf->tmpfolio=
, 0),
> -                                               REQ_OP_WRITE);
> +                               r1_sync_folio_io(rdev, sect, s, 0,
> +                                               conf->tmpfolio, REQ_OP_WR=
ITE);
>                                 rdev_dec_pending(rdev, mddev);
>                         }
>                 }
> @@ -2461,9 +2440,8 @@ static void fix_read_error(struct r1conf *conf, str=
uct r1bio *r1_bio)
>                         if (rdev &&
>                             !test_bit(Faulty, &rdev->flags)) {
>                                 atomic_inc(&rdev->nr_pending);
> -                               if (r1_sync_page_io(rdev, sect, s,
> -                                               folio_page(conf->tmpfolio=
, 0),
> -                                               REQ_OP_READ)) {
> +                               if (r1_sync_folio_io(rdev, sect, s, 0,
> +                                               conf->tmpfolio, REQ_OP_RE=
AD)) {
>                                         atomic_add(s, &rdev->corrected_er=
rors);
>                                         pr_info("md/raid1:%s: read error =
corrected (%d sectors at %llu on %pg)\n",
>                                                 mdname(mddev), s,
> @@ -2799,7 +2777,6 @@ static sector_t raid1_sync_request(struct mddev *md=
dev, sector_t sector_nr,
>         int good_sectors =3D RESYNC_SECTORS;
>         int min_bad =3D 0; /* number of sectors that are bad in all devic=
es */
>         int idx =3D sector_to_idx(sector_nr);
> -       int page_idx =3D 0;
>
>         if (!mempool_initialized(&conf->r1buf_pool))
>                 if (init_resync(conf))
> @@ -3003,8 +2980,8 @@ static sector_t raid1_sync_request(struct mddev *md=
dev, sector_t sector_nr,
>         nr_sectors =3D 0;
>         sync_blocks =3D 0;
>         do {
> -               struct page *page;
> -               int len =3D PAGE_SIZE;
> +               struct folio *folio;
> +               int len =3D RESYNC_BLOCK_SIZE;
>                 if (sector_nr + (len>>9) > max_sector)
>                         len =3D (max_sector - sector_nr) << 9;
>                 if (len =3D=3D 0)
> @@ -3020,24 +2997,24 @@ static sector_t raid1_sync_request(struct mddev *=
mddev, sector_t sector_nr,
>                 }
>
>                 for (i =3D 0 ; i < conf->raid_disks * 2; i++) {
> -                       struct resync_pages *rp;
> +                       struct resync_folio *rf;
>
>                         bio =3D r1_bio->bios[i];
> -                       rp =3D get_resync_pages(bio);
> +                       rf =3D get_resync_folio(bio);
>                         if (bio->bi_end_io) {
> -                               page =3D resync_fetch_page(rp, page_idx);
> +                               folio =3D resync_fetch_folio(rf);
>
>                                 /*
>                                  * won't fail because the vec table is bi=
g
>                                  * enough to hold all these pages
>                                  */

The comments above may not be needed anymore. Because there is only
one vec in the bio.

> -                               __bio_add_page(bio, page, len, 0);
> +                               bio_add_folio_nofail(bio, folio, len, 0);
>                         }
>                 }
>                 nr_sectors +=3D len>>9;
>                 sector_nr +=3D len>>9;
>                 sync_blocks -=3D (len>>9);

These three lines are not needed anymore.

> -       } while (++page_idx < RESYNC_PAGES);
> +       } while (0);
>
>         r1_bio->sectors =3D nr_sectors;
>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 09238dc9cde6..c93706806358 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -96,11 +96,11 @@ static void end_reshape(struct r10conf *conf);
>
>  /*
>   * for resync bio, r10bio pointer can be retrieved from the per-bio
> - * 'struct resync_pages'.
> + * 'struct resync_folio'.
>   */
>  static inline struct r10bio *get_resync_r10bio(struct bio *bio)
>  {
> -       return get_resync_pages(bio)->raid_bio;
> +       return get_resync_folio(bio)->raid_bio;
>  }
>
>  static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
> @@ -133,8 +133,8 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void=
 *data)
>         struct r10bio *r10_bio;
>         struct bio *bio;
>         int j;
> -       int nalloc, nalloc_rp;
> -       struct resync_pages *rps;
> +       int nalloc, nalloc_rf;
> +       struct resync_folio *rfs;
>
>         r10_bio =3D r10bio_pool_alloc(gfp_flags, conf);
>         if (!r10_bio)
> @@ -148,58 +148,57 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, vo=
id *data)
>
>         /* allocate once for all bios */
>         if (!conf->have_replacement)
> -               nalloc_rp =3D nalloc;
> +               nalloc_rf =3D nalloc;
>         else
> -               nalloc_rp =3D nalloc * 2;
> -       rps =3D kmalloc_array(nalloc_rp, sizeof(struct resync_pages), gfp=
_flags);
> -       if (!rps)
> +               nalloc_rf =3D nalloc * 2;
> +       rfs =3D kmalloc_array(nalloc_rf, sizeof(struct resync_folio), gfp=
_flags);
> +       if (!rfs)
>                 goto out_free_r10bio;
>
>         /*
>          * Allocate bios.
>          */
>         for (j =3D nalloc ; j-- ; ) {
> -               bio =3D bio_kmalloc(RESYNC_PAGES, gfp_flags);
> +               bio =3D bio_kmalloc(1, gfp_flags);
>                 if (!bio)
>                         goto out_free_bio;
> -               bio_init_inline(bio, NULL, RESYNC_PAGES, 0);
> +               bio_init_inline(bio, NULL, 1, 0);
>                 r10_bio->devs[j].bio =3D bio;
>                 if (!conf->have_replacement)
>                         continue;
> -               bio =3D bio_kmalloc(RESYNC_PAGES, gfp_flags);
> +               bio =3D bio_kmalloc(1, gfp_flags);
>                 if (!bio)
>                         goto out_free_bio;
> -               bio_init_inline(bio, NULL, RESYNC_PAGES, 0);
> +               bio_init_inline(bio, NULL, 1, 0);
>                 r10_bio->devs[j].repl_bio =3D bio;
>         }
>         /*
> -        * Allocate RESYNC_PAGES data pages and attach them
> -        * where needed.
> +        * Allocate data folio and attach them where needed.

typo error
s/attach them/attach it/g

>          */
>         for (j =3D 0; j < nalloc; j++) {
>                 struct bio *rbio =3D r10_bio->devs[j].repl_bio;
> -               struct resync_pages *rp, *rp_repl;
> +               struct resync_folio *rf, *rf_repl;
>
> -               rp =3D &rps[j];
> +               rf =3D &rfs[j];
>                 if (rbio)
> -                       rp_repl =3D &rps[nalloc + j];
> +                       rf_repl =3D &rfs[nalloc + j];
>
>                 bio =3D r10_bio->devs[j].bio;
>
>                 if (!j || test_bit(MD_RECOVERY_SYNC,
>                                    &conf->mddev->recovery)) {
> -                       if (resync_alloc_pages(rp, gfp_flags))
> +                       if (resync_alloc_folio(rf, gfp_flags))
>                                 goto out_free_pages;

s/out_free_pages/out_free_folio/g

>                 } else {
> -                       memcpy(rp, &rps[0], sizeof(*rp));
> -                       resync_get_all_pages(rp);
> +                       memcpy(rf, &rfs[0], sizeof(*rf));
> +                       resync_get_all_folio(rf);

Maybe the name resync_get_folio is better?

>                 }
>
> -               rp->raid_bio =3D r10_bio;
> -               bio->bi_private =3D rp;
> +               rf->raid_bio =3D r10_bio;
> +               bio->bi_private =3D rf;
>                 if (rbio) {
> -                       memcpy(rp_repl, rp, sizeof(*rp));
> -                       rbio->bi_private =3D rp_repl;
> +                       memcpy(rf_repl, rf, sizeof(*rf));
> +                       rbio->bi_private =3D rf_repl;
>                 }
>         }
>
> @@ -207,7 +206,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void=
 *data)
>
>  out_free_pages:
>         while (--j >=3D 0)
> -               resync_free_pages(&rps[j]);
> +               resync_free_folio(&rfs[j]);
>
>         j =3D 0;
>  out_free_bio:
> @@ -219,7 +218,7 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void=
 *data)
>                         bio_uninit(r10_bio->devs[j].repl_bio);
>                 kfree(r10_bio->devs[j].repl_bio);
>         }
> -       kfree(rps);
> +       kfree(rfs);
>  out_free_r10bio:
>         rbio_pool_free(r10_bio, conf);
>         return NULL;
> @@ -230,14 +229,14 @@ static void r10buf_pool_free(void *__r10_bio, void =
*data)
>         struct r10conf *conf =3D data;
>         struct r10bio *r10bio =3D __r10_bio;
>         int j;
> -       struct resync_pages *rp =3D NULL;
> +       struct resync_folio *rf =3D NULL;
>
>         for (j =3D conf->copies; j--; ) {
>                 struct bio *bio =3D r10bio->devs[j].bio;
>
>                 if (bio) {
> -                       rp =3D get_resync_pages(bio);
> -                       resync_free_pages(rp);
> +                       rf =3D get_resync_folio(bio);
> +                       resync_free_folio(rf);
>                         bio_uninit(bio);
>                         kfree(bio);
>                 }
> @@ -250,7 +249,7 @@ static void r10buf_pool_free(void *__r10_bio, void *d=
ata)
>         }
>
>         /* resync pages array stored in the 1st bio's .bi_private */
> -       kfree(rp);
> +       kfree(rf);
>
>         rbio_pool_free(r10bio, conf);
>  }
> @@ -2342,8 +2341,7 @@ static void sync_request_write(struct mddev *mddev,=
 struct r10bio *r10_bio)
>         struct r10conf *conf =3D mddev->private;
>         int i, first;
>         struct bio *tbio, *fbio;
> -       int vcnt;
> -       struct page **tpages, **fpages;
> +       struct folio *tfolio, *ffolio;
>
>         atomic_set(&r10_bio->remaining, 1);
>
> @@ -2359,14 +2357,13 @@ static void sync_request_write(struct mddev *mdde=
v, struct r10bio *r10_bio)
>         fbio =3D r10_bio->devs[i].bio;
>         fbio->bi_iter.bi_size =3D r10_bio->sectors << 9;
>         fbio->bi_iter.bi_idx =3D 0;
> -       fpages =3D get_resync_pages(fbio)->pages;
> +       ffolio =3D get_resync_folio(fbio)->folio;
>
> -       vcnt =3D (r10_bio->sectors + (PAGE_SIZE >> 9) - 1) >> (PAGE_SHIFT=
 - 9);
>         /* now find blocks with errors */
>         for (i=3D0 ; i < conf->copies ; i++) {
> -               int  j, d;
> +               int  d;
>                 struct md_rdev *rdev;
> -               struct resync_pages *rp;
> +               struct resync_folio *rf;
>
>                 tbio =3D r10_bio->devs[i].bio;
>
> @@ -2375,31 +2372,23 @@ static void sync_request_write(struct mddev *mdde=
v, struct r10bio *r10_bio)
>                 if (i =3D=3D first)
>                         continue;
>
> -               tpages =3D get_resync_pages(tbio)->pages;
> +               tfolio =3D get_resync_folio(tbio)->folio;
>                 d =3D r10_bio->devs[i].devnum;
>                 rdev =3D conf->mirrors[d].rdev;
>                 if (!r10_bio->devs[i].bio->bi_status) {
>                         /* We know that the bi_io_vec layout is the same =
for
>                          * both 'first' and 'i', so we just compare them.
> -                        * All vec entries are PAGE_SIZE;
>                          */
> -                       int sectors =3D r10_bio->sectors;
> -                       for (j =3D 0; j < vcnt; j++) {
> -                               int len =3D PAGE_SIZE;
> -                               if (sectors < (len / 512))
> -                                       len =3D sectors * 512;
> -                               if (memcmp(page_address(fpages[j]),
> -                                          page_address(tpages[j]),
> -                                          len))
> -                                       break;
> -                               sectors -=3D len/512;
> +                       if (memcmp(folio_address(ffolio),
> +                                  folio_address(tfolio),
> +                                  r10_bio->sectors << 9)) {
> +                               atomic64_add(r10_bio->sectors,
> +                                            &mddev->resync_mismatches);
> +                               if (test_bit(MD_RECOVERY_CHECK,
> +                                            &mddev->recovery))
> +                                       /* Don't fix anything. */
> +                                       continue;
>                         }
> -                       if (j =3D=3D vcnt)
> -                               continue;
> -                       atomic64_add(r10_bio->sectors, &mddev->resync_mis=
matches);
> -                       if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)=
)
> -                               /* Don't fix anything. */
> -                               continue;
>                 } else if (test_bit(FailFast, &rdev->flags)) {
>                         /* Just give up on this device */
>                         md_error(rdev->mddev, rdev);
> @@ -2410,13 +2399,13 @@ static void sync_request_write(struct mddev *mdde=
v, struct r10bio *r10_bio)
>                  * First we need to fixup bv_offset, bv_len and
>                  * bi_vecs, as the read request might have corrupted thes=
e
>                  */
> -               rp =3D get_resync_pages(tbio);
> +               rf =3D get_resync_folio(tbio);
>                 bio_reset(tbio, conf->mirrors[d].rdev->bdev, REQ_OP_WRITE=
);
>
> -               md_bio_reset_resync_pages(tbio, rp, fbio->bi_iter.bi_size=
);
> +               md_bio_reset_resync_folio(tbio, rf, fbio->bi_iter.bi_size=
);
>
> -               rp->raid_bio =3D r10_bio;
> -               tbio->bi_private =3D rp;
> +               rf->raid_bio =3D r10_bio;
> +               tbio->bi_private =3D rf;
>                 tbio->bi_iter.bi_sector =3D r10_bio->devs[i].addr;
>                 tbio->bi_end_io =3D end_sync_write;
>
> @@ -2476,10 +2465,9 @@ static void fix_recovery_read_error(struct r10bio =
*r10_bio)
>         struct bio *bio =3D r10_bio->devs[0].bio;
>         sector_t sect =3D 0;
>         int sectors =3D r10_bio->sectors;
> -       int idx =3D 0;
>         int dr =3D r10_bio->devs[0].devnum;
>         int dw =3D r10_bio->devs[1].devnum;
> -       struct page **pages =3D get_resync_pages(bio)->pages;
> +       struct folio *folio =3D get_resync_folio(bio)->folio;
>
>         while (sectors) {
>                 int s =3D sectors;
> @@ -2492,19 +2480,21 @@ static void fix_recovery_read_error(struct r10bio=
 *r10_bio)
>
>                 rdev =3D conf->mirrors[dr].rdev;
>                 addr =3D r10_bio->devs[0].addr + sect;
> -               ok =3D sync_page_io(rdev,
> -                                 addr,
> -                                 s << 9,
> -                                 pages[idx],
> -                                 REQ_OP_READ, false);
> +               ok =3D sync_folio_io(rdev,
> +                                  addr,
> +                                  s << 9,
> +                                  sect << 9,
> +                                  folio,
> +                                  REQ_OP_READ, false);

By the comments at the beginning of fix_recovery_read_error, it needs
to submit io with a page size unit, right? If so, it still needs to
use sync_page_io here.

>                 if (ok) {
>                         rdev =3D conf->mirrors[dw].rdev;
>                         addr =3D r10_bio->devs[1].addr + sect;
> -                       ok =3D sync_page_io(rdev,
> -                                         addr,
> -                                         s << 9,
> -                                         pages[idx],
> -                                         REQ_OP_WRITE, false);
> +                       ok =3D sync_folio_io(rdev,
> +                                          addr,
> +                                          s << 9,
> +                                          sect << 9,
> +                                          folio,
> +                                          REQ_OP_WRITE, false);
>                         if (!ok) {
>                                 set_bit(WriteErrorSeen, &rdev->flags);
>                                 if (!test_and_set_bit(WantReplacement,
> @@ -2539,7 +2529,6 @@ static void fix_recovery_read_error(struct r10bio *=
r10_bio)
>
>                 sectors -=3D s;
>                 sect +=3D s;
> -               idx++;
>         }
>  }
>
> @@ -3174,7 +3163,6 @@ static sector_t raid10_sync_request(struct mddev *m=
ddev, sector_t sector_nr,
>         int max_sync =3D RESYNC_SECTORS;
>         sector_t sync_blocks;
>         sector_t chunk_mask =3D conf->geo.chunk_mask;
> -       int page_idx =3D 0;
>
>         /*
>          * Allow skipping a full rebuild for incremental assembly
> @@ -3277,7 +3265,7 @@ static sector_t raid10_sync_request(struct mddev *m=
ddev, sector_t sector_nr,
>          * with 2 bios in each, that correspond to the bios in the main o=
ne.
>          * In this case, the subordinate r10bios link back through a
>          * borrowed master_bio pointer, and the counter in the master
> -        * includes a ref from each subordinate.
> +        * bio_add_folio includes a ref from each subordinate.

What's the reason change this? And I don't understand the new version.

Best Regards
Xiao
>          */
>         /* First, we decide what to do and set ->bi_end_io
>          * To end_sync_read if we want to read, and
> @@ -3642,25 +3630,26 @@ static sector_t raid10_sync_request(struct mddev =
*mddev, sector_t sector_nr,
>         if (sector_nr + max_sync < max_sector)
>                 max_sector =3D sector_nr + max_sync;
>         do {
> -               struct page *page;
> -               int len =3D PAGE_SIZE;
> +               int len =3D RESYNC_BLOCK_SIZE;
> +
>                 if (sector_nr + (len>>9) > max_sector)
>                         len =3D (max_sector - sector_nr) << 9;
>                 if (len =3D=3D 0)
>                         break;
>                 for (bio=3D biolist ; bio ; bio=3Dbio->bi_next) {
> -                       struct resync_pages *rp =3D get_resync_pages(bio)=
;
> -                       page =3D resync_fetch_page(rp, page_idx);
> -                       if (WARN_ON(!bio_add_page(bio, page, len, 0))) {
> +                       struct resync_folio *rf =3D get_resync_folio(bio)=
;
> +                       struct folio *folio =3D resync_fetch_folio(rf);
> +
> +                       if (WARN_ON(!bio_add_folio(bio, folio, len, 0))) =
{
>                                 bio->bi_status =3D BLK_STS_RESOURCE;
>                                 bio_endio(bio);
>                                 *skipped =3D 1;
> -                               return max_sync;
> +                               return len;
>                         }
>                 }
>                 nr_sectors +=3D len>>9;
>                 sector_nr +=3D len>>9;
> -       } while (++page_idx < RESYNC_PAGES);
> +       } while (0);
>         r10_bio->sectors =3D nr_sectors;
>
>         if (mddev_is_clustered(mddev) &&
> @@ -4578,7 +4567,7 @@ static sector_t reshape_request(struct mddev *mddev=
, sector_t sector_nr,
>                                 int *skipped)
>  {
>         /* We simply copy at most one chunk (smallest of old and new)
> -        * at a time, possibly less if that exceeds RESYNC_PAGES,
> +        * at a time, possibly less if that exceeds RESYNC_BLOCK_SIZE,
>          * or we hit a bad block or something.
>          * This might mean we pause for normal IO in the middle of
>          * a chunk, but that is not a problem as mddev->reshape_position
> @@ -4618,14 +4607,13 @@ static sector_t reshape_request(struct mddev *mdd=
ev, sector_t sector_nr,
>         struct r10bio *r10_bio;
>         sector_t next, safe, last;
>         int max_sectors;
> -       int nr_sectors;
>         int s;
>         struct md_rdev *rdev;
>         int need_flush =3D 0;
>         struct bio *blist;
>         struct bio *bio, *read_bio;
>         int sectors_done =3D 0;
> -       struct page **pages;
> +       struct folio *folio;
>
>         if (sector_nr =3D=3D 0) {
>                 /* If restarting in the middle, skip the initial sectors =
*/
> @@ -4741,7 +4729,7 @@ static sector_t reshape_request(struct mddev *mddev=
, sector_t sector_nr,
>                 return sectors_done;
>         }
>
> -       read_bio =3D bio_alloc_bioset(rdev->bdev, RESYNC_PAGES, REQ_OP_RE=
AD,
> +       read_bio =3D bio_alloc_bioset(rdev->bdev, 1, REQ_OP_READ,
>                                     GFP_KERNEL, &mddev->bio_set);
>         read_bio->bi_iter.bi_sector =3D (r10_bio->devs[r10_bio->read_slot=
].addr
>                                + rdev->data_offset);
> @@ -4805,32 +4793,23 @@ static sector_t reshape_request(struct mddev *mdd=
ev, sector_t sector_nr,
>                 blist =3D b;
>         }
>
> -       /* Now add as many pages as possible to all of these bios. */
> +       /* Now add folio to all of these bios. */
>
> -       nr_sectors =3D 0;
> -       pages =3D get_resync_pages(r10_bio->devs[0].bio)->pages;
> -       for (s =3D 0 ; s < max_sectors; s +=3D PAGE_SIZE >> 9) {
> -               struct page *page =3D pages[s / (PAGE_SIZE >> 9)];
> -               int len =3D (max_sectors - s) << 9;
> -               if (len > PAGE_SIZE)
> -                       len =3D PAGE_SIZE;
> -               for (bio =3D blist; bio ; bio =3D bio->bi_next) {
> -                       if (WARN_ON(!bio_add_page(bio, page, len, 0))) {
> -                               bio->bi_status =3D BLK_STS_RESOURCE;
> -                               bio_endio(bio);
> -                               return sectors_done;
> -                       }
> +       folio =3D get_resync_folio(r10_bio->devs[0].bio)->folio;
> +       for (bio =3D blist; bio ; bio =3D bio->bi_next) {
> +               if (WARN_ON(!bio_add_folio(bio, folio, max_sectors, 0))) =
{
> +                       bio->bi_status =3D BLK_STS_RESOURCE;
> +                       bio_endio(bio);
> +                       return sectors_done;
>                 }
> -               sector_nr +=3D len >> 9;
> -               nr_sectors +=3D len >> 9;
>         }
> -       r10_bio->sectors =3D nr_sectors;
> +       r10_bio->sectors =3D max_sectors >> 9;
>
>         /* Now submit the read */
>         atomic_inc(&r10_bio->remaining);
>         read_bio->bi_next =3D NULL;
>         submit_bio_noacct(read_bio);
> -       sectors_done +=3D nr_sectors;
> +       sectors_done +=3D max_sectors;
>         if (sector_nr <=3D last)
>                 goto read_more;
>
> @@ -4932,8 +4911,8 @@ static int handle_reshape_read_error(struct mddev *=
mddev,
>         struct r10conf *conf =3D mddev->private;
>         struct r10bio *r10b;
>         int slot =3D 0;
> -       int idx =3D 0;
> -       struct page **pages;
> +       int sect =3D 0;
> +       struct folio *folio;
>
>         r10b =3D kmalloc(struct_size(r10b, devs, conf->copies), GFP_NOIO)=
;
>         if (!r10b) {
> @@ -4941,8 +4920,8 @@ static int handle_reshape_read_error(struct mddev *=
mddev,
>                 return -ENOMEM;
>         }
>
> -       /* reshape IOs share pages from .devs[0].bio */
> -       pages =3D get_resync_pages(r10_bio->devs[0].bio)->pages;
> +       /* reshape IOs share folio from .devs[0].bio */
> +       folio =3D get_resync_folio(r10_bio->devs[0].bio)->folio;
>
>         r10b->sector =3D r10_bio->sector;
>         __raid10_find_phys(&conf->prev, r10b);
> @@ -4958,19 +4937,19 @@ static int handle_reshape_read_error(struct mddev=
 *mddev,
>                 while (!success) {
>                         int d =3D r10b->devs[slot].devnum;
>                         struct md_rdev *rdev =3D conf->mirrors[d].rdev;
> -                       sector_t addr;
>                         if (rdev =3D=3D NULL ||
>                             test_bit(Faulty, &rdev->flags) ||
>                             !test_bit(In_sync, &rdev->flags))
>                                 goto failed;
>
> -                       addr =3D r10b->devs[slot].addr + idx * PAGE_SIZE;
>                         atomic_inc(&rdev->nr_pending);
> -                       success =3D sync_page_io(rdev,
> -                                              addr,
> -                                              s << 9,
> -                                              pages[idx],
> -                                              REQ_OP_READ, false);
> +                       success =3D sync_folio_io(rdev,
> +                                               r10b->devs[slot].addr +
> +                                               sect,
> +                                               s << 9,
> +                                               sect << 9,
> +                                               folio,
> +                                               REQ_OP_READ, false);
>                         rdev_dec_pending(rdev, mddev);
>                         if (success)
>                                 break;
> @@ -4989,7 +4968,7 @@ static int handle_reshape_read_error(struct mddev *=
mddev,
>                         return -EIO;
>                 }
>                 sectors -=3D s;
> -               idx++;
> +               sect +=3D s;
>         }
>         kfree(r10b);
>         return 0;
> --
> 2.39.2
>

