Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3A323BCF7
	for <linux-raid@vger.kernel.org>; Thu, 30 Apr 2026 01:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777514097; cv=pass; b=pk1bqVfbhInoosfjzox07HxYIO5iJojdaOR/DJuCmro8ONLRF03HGI61AKqYwrUVpjfIKsn2ctkCYz0BdmWMKf/P3NNp7ri7BJID4jP8IMoi4vCd7Gm4CZkcddH7776ko4f+FCT5zUyu8u6vktw+PH4eUjLsdyL1NsFZ1MXWr+8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777514097; c=relaxed/simple;
	bh=L05hgPw0/lVOmkJJqTFsQPotNCt32ehY2WStOxHHOac=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ge9/iecjVoErAAoWsY5S+yCrZL4l3yDYVvyOZfIRL4bNp9j+5bkQOhXUB3VOy2Yc5rR6+3pI253desRQ5nEzolVaNKN7RaQICtPt+gAPdzUVhja9pNtGyPXPr6k3fzhJbtMTjs9c7Nh+74qbU58dFfNoeyguMuFp7WZnmVSnT5M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PfWV1uwf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ir2MrSfr; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PfWV1uwf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ir2MrSfr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777514093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EfxAI5SPjVrxTVBuryphmr1GTJ9sRtYt8SEGtFifQss=;
	b=PfWV1uwfeQNjkcU6zld7F6MEzjh4RIUeDqbovNob1/Va41vNxG9x+n1LwFVTOdBiM/Ul3I
	t7gbzohD8MT399YTL7pRyosh/S2x80W56QOsWUsodkHJlQT8NukKT1BfDV32J8KDOJajsL
	Ln9fwtitPhiqBAMkHxotQ6fO2V8XiC4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-twRbKQrLPL68d587zekgnw-1; Wed, 29 Apr 2026 21:54:51 -0400
X-MC-Unique: twRbKQrLPL68d587zekgnw-1
X-Mimecast-MFC-AGG-ID: twRbKQrLPL68d587zekgnw_1777514090
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5a13072689fso123292e87.0
        for <linux-raid@vger.kernel.org>; Wed, 29 Apr 2026 18:54:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777514090; cv=none;
        d=google.com; s=arc-20240605;
        b=TNMsNaUWwihIzbczc0IxHv5a7wFfLwzsI582f80lqgXaGtSN1ZLuvC4qHgpzkBK2P2
         CK/wK/4rDCGVxfLec+zBk3SD0gBHkvFkqeki6whocVHpBJK86PW0cYljBgMGu0Jr0xX1
         osZfGbZ3j/cMsBtPKjfvRyDNe7rX1k2xHpy+lhTQXKuGDoOcFpLWbIOQvNm3SIAUeps+
         +xb+sw0AxHI+/VMcS6pF8mtmMCIqySaUap7o5H707apfFV9Y3oV63W/c8DvKqDIaYzvR
         jLwIoRCVQHvx17vzaBKqkPk9/N6hGDbMKUHFLrskPyk2D6L4ahzQFTUDDLRixfNAARVx
         jp5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EfxAI5SPjVrxTVBuryphmr1GTJ9sRtYt8SEGtFifQss=;
        fh=NQrhuedevQUGJfKUcPdneHNIUbXO6dO7iQ9O7VeFgr4=;
        b=Yz2t6M2p4H4OOB37MfG86FMcFUci7r/8lAP5RVr0a2vYU/tpAI0ogLAPfBxt2y4jfx
         6Y1E2gGCXOnDGtVQdLfWosXTA+8hf3+IYzAlYmjCS0uyMs8oMaOw1alVqmk1O9eFCMlX
         jktNJZDm+TolPO8STpp8jReInDTNODLL8WQEJ7YpgzRScfqYPByxaGlF6pWS0ypaCBbn
         BUTmK21qG5lrPSC4pHh/hzZjUjPmQOU27ouI2lioTw5sVyfosjQ+1VoVeAFl7cTkHWr8
         zefLdYT6EWku92P99UmAC1o2WhmcE7/52NT9De+wDN6rguwnmOVP7HlyiwQ6GvfHP41V
         /yIg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1777514090; x=1778118890; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EfxAI5SPjVrxTVBuryphmr1GTJ9sRtYt8SEGtFifQss=;
        b=ir2MrSfr75mSz1dNL3Q0Fl07akDTkIy0ZVbYYjH1qfirvUiZWLPdsnEtN10VV323QM
         DAT3eRkCH2XhHvK9dmFt8OBWe/SbfoLt6ImG36nstx7mag7f+yo0I8KU0JezYW9DGZst
         sKoYu8mNCMXeerE5Kr5tPPPystlxwCwKgqnHPtqlgJmSV/yTx25DI52lu89RGa0zFGV2
         se9iyJP54zctcKQiVZ8zp8B0cmk1PCPaUEmqvEx3XMgWw1HPVKfcarUgFQW5pUKSnQoj
         CJudNPuoixWdY4w3E2wEG+WAMbcsJ2TMA0v2/Md+RZ2LDKFAEcts8jpkIUwC09xCyqXT
         jASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777514090; x=1778118890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EfxAI5SPjVrxTVBuryphmr1GTJ9sRtYt8SEGtFifQss=;
        b=L20EmV7z1UqLsEXHqdqlHI/AXZeNocuMjRpPa+ZO00v90AXwQNyWU/KtU6HgfXKZXM
         8V9eJ+U7uilP6tJk0AUtktZUO6gxz6ePomn2NLOpTnln3Q7ePhOpz7YdjG3oN0dJu8f/
         mdDTGM/TaG2ZH8MjX1C0JeTF1u52GonWGYYPWBHF3UO6vhNiykITRVZnCTazbn+Z+j1n
         19y+zuxxbFcpcJCvVB0WVQ5BOaA8DAGe4dPfzbDyBfaDH1625dgOrQ1GFO1ImFJEAp4m
         0jEgQmbzi93sUCFiOiJ8Xbq1Hs273ggWtVj9WrDCEFnAXZUA65qiPW9v5CmJyJztDpLC
         dp1w==
X-Forwarded-Encrypted: i=1; AFNElJ8QmLrij10HwoBBr5m378qSkzsMgvUhC/oOEBkzvsodyJ592EZ/1qwJYVmmCWK7IXWKl9SdZIxtjiYZ@vger.kernel.org
X-Gm-Message-State: AOJu0YyGobioiXho8WWrY09iHdrNykxKKf6iUX+w+72rF0aN2k6tZItB
	RLiCyyuSvSYxTmrkdRsA00/nEttNZ07UKFJa1zIWHPqWUTwJ5AH1cEFnxWBnQPwkoV4MRJS2FOW
	NMmDTDuTrhuYnN4xKLTw219gzFDle+jVqRBLCKBbbz/RlZPNDPvcHUX0fQaWvR/NW8j2Crc4rA4
	IQVPPZ5MEH8jJizINWjCdriv4A9dG+oxnpURpTcg==
X-Gm-Gg: AeBDieuA7U6T6sD1bYEUuQflqF9FwmjY/NV8Y2CAmMAiXVb1dyEH4pNLXf3ru/XwCbR
	p+kfEqXMRRPJr01+hkjFMBKLjn4d8GDl8K6seRD+inm//dKCaGQM094A/BmgMs+Q0Gndw7PLZX/
	tm9OjKFYMMggjg5YqYRpubUg6cbP5vnuIDSFxVW6GPjcv8JeRCKdY3AuDI77CITjl5N8oBe0BBX
	x1jElvX4mlBnPAtjm9NAWga73OKjmr5WCC8yHFB7QMifWmIFB5JAet22GyRWBAbMroNoW3ay+jL
	iq4vGvRf+tPE
X-Received: by 2002:a05:6512:39cb:b0:5a4:1b8:1a92 with SMTP id 2adb3069b0e04-5a8522d4f00mr200484e87.21.1777514089630;
        Wed, 29 Apr 2026 18:54:49 -0700 (PDT)
X-Received: by 2002:a05:6512:39cb:b0:5a4:1b8:1a92 with SMTP id
 2adb3069b0e04-5a8522d4f00mr200464e87.21.1777514088914; Wed, 29 Apr 2026
 18:54:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260416033801.786415-1-linan666@huaweicloud.com> <20260416033801.786415-7-linan666@huaweicloud.com>
In-Reply-To: <20260416033801.786415-7-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 30 Apr 2026 09:54:36 +0800
X-Gm-Features: AVHnY4JvAjVd3zbUx46YzdF46RBwdRu_XpL51tgzm-29oxQY5ELkQQat64QZwAY
Message-ID: <CALTww29duRpWZkYQjRJM45DAG=gLiPzbtn9x+CHAFcF3XJXRTg@mail.gmail.com>
Subject: Re: [PATCH v3 6/8] md/raid1,raid10: use folio for sync path IO
To: linan666@huaweicloud.com
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Nan

On Thu, Apr 16, 2026 at 11:55=E2=80=AFAM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> Convert all IO on the sync path to use folios, and rename page-related
> identifiers to match folio.
>
> Since RESYNC_BLOCK_SIZE (64K) has higher allocation failure chance than 4=
k,
> retry with lower orders to improve allocation reliability. A r1/10_bio ma=
y
> have different rf->folio orders, so use minimum order as r1/10_bio sector=
s
> to prevent exceeding size when adding folio to IO later.
>
> Clean up:
> 1. Remove resync_get_all_folio() and invoke folio_get() directly instead.
> 2. Clean up redundant while(0) loop in md_bio_reset_resync_folio().
> 3. Clean up bio variable by directly referencing r10_bio->devs[j].bio
>    instead in r1buf_pool_alloc() and r10buf_pool_alloc().
> 4. Clean up RESYNC_PAGES.
> 5. Remove resync_fetch_folio(), access 'rf->folio' directly.
> 6. Remove resync_free_folio(), call folio_put() directly.
> 7. clean up sync IO size calculation in raid1/10_sync_request.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>  drivers/md/md.c       |   2 +-
>  drivers/md/raid1-10.c |  80 ++++---------
>  drivers/md/raid1.c    | 209 +++++++++++++++-------------------
>  drivers/md/raid10.c   | 254 +++++++++++++++++++++---------------------
>  4 files changed, 240 insertions(+), 305 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5e83914d5c14..6554b849ac74 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9440,7 +9440,7 @@ static bool sync_io_within_limit(struct mddev *mdde=
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
> index cda531d0720b..10200b0a3fd2 100644
> --- a/drivers/md/raid1-10.c
> +++ b/drivers/md/raid1-10.c
> @@ -1,7 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  /* Maximum size of each resync request */
>  #define RESYNC_BLOCK_SIZE (64*1024)
> -#define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
>  #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
>
>  /* when we get a read error on a read-only array, we redirect to another
> @@ -20,9 +19,9 @@
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
> @@ -36,77 +35,44 @@ static void rbio_pool_free(void *rbio, void *data)
>         kfree(rbio);
>  }
>
> -static inline int resync_alloc_pages(struct resync_pages *rp,
> -                                    gfp_t gfp_flags)
> +static inline int resync_alloc_folio(struct resync_folio *rf,
> +                                    gfp_t gfp_flags, int *order)
>  {
> -       int i;
> +       struct folio *folio;
>
> -       for (i =3D 0; i < RESYNC_PAGES; i++) {
> -               rp->pages[i] =3D alloc_page(gfp_flags);
> -               if (!rp->pages[i])
> -                       goto out_free;
> -       }
> +       do {
> +               folio =3D folio_alloc(gfp_flags, *order);
> +               if (folio)
> +                       break;
> +       } while (--(*order) > 0);

It has a problem here. If it can't allocate a big page, the sync
request unit will be smaller and sync performance may decrease. This
can happen when the system lacks sufficient continuous memory. This
change looks good to me. I just want to throw this problem out for an
open discussion.

>
> +       if (!folio)
> +               return -ENOMEM;
> +
> +       rf->folio =3D folio;
>         return 0;
> -
> -out_free:
> -       while (--i >=3D 0)
> -               put_page(rp->pages[i]);
> -       return -ENOMEM;
> -}
> -
> -static inline void resync_free_pages(struct resync_pages *rp)
> -{
> -       int i;
> -
> -       for (i =3D 0; i < RESYNC_PAGES; i++)
> -               put_page(rp->pages[i]);
> -}
> -
> -static inline void resync_get_all_pages(struct resync_pages *rp)
> -{
> -       int i;
> -
> -       for (i =3D 0; i < RESYNC_PAGES; i++)
> -               get_page(rp->pages[i]);
> -}
> -
> -static inline struct page *resync_fetch_page(struct resync_pages *rp,
> -                                            unsigned idx)
> -{
> -       if (WARN_ON_ONCE(idx >=3D RESYNC_PAGES))
> -               return NULL;
> -       return rp->pages[idx];
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
> -       do {
> -               struct page *page =3D resync_fetch_page(rp, idx);
> -               int len =3D min_t(int, size, PAGE_SIZE);
> -
> -               if (WARN_ON(!bio_add_page(bio, page, len, 0))) {
> -                       bio->bi_status =3D BLK_STS_RESOURCE;
> -                       bio_endio(bio);
> -                       return;
> -               }
> -
> -               size -=3D len;
> -       } while (idx++ < RESYNC_PAGES && size > 0);
> +       if (WARN_ON(!bio_add_folio(bio, rf->folio,
> +                                  min_t(int, size, RESYNC_BLOCK_SIZE),
> +                                  0))) {
> +               bio->bi_status =3D BLK_STS_RESOURCE;
> +               bio_endio(bio);
> +       }
>  }
>
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index a72abdc37a2d..724fd4f2cc3a 100644
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

The name need_folio is confusing. Can we keep the same style as the
old version? How about need_folios?

>         int j;
> -       struct resync_pages *rps;
> +       struct resync_folio *rfs;
> +       int order =3D get_order(RESYNC_BLOCK_SIZE);
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
> +        * Allocate data folio and attach it to the first bio.
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
> -               bio =3D r1_bio->bios[j];
> -
> -               if (j < need_pages) {
> -                       if (resync_alloc_pages(rp, gfp_flags))
> -                               goto out_free_pages;
> +               if (j < need_folio) {
> +                       if (resync_alloc_folio(rf, gfp_flags, &order))
> +                               goto out_free_folio;
>                 } else {
> -                       memcpy(rp, &rps[0], sizeof(*rp));
> -                       resync_get_all_pages(rp);
> +                       memcpy(rf, &rfs[0], sizeof(*rf));
> +                       folio_get(rf->folio);
>                 }
>
> -               rp->raid_bio =3D r1_bio;
> -               bio->bi_private =3D rp;
> +               rf->raid_bio =3D r1_bio;
> +               r1_bio->bios[j]->bi_private =3D rf;
>         }
>
> +       r1_bio->sectors =3D 1 << (order + PAGE_SECTORS_SHIFT);
>         r1_bio->master_bio =3D NULL;
>
>         return r1_bio;
>
> -out_free_pages:
> +out_free_folio:
>         while (--j >=3D 0)
> -               resync_free_pages(&rps[j]);
> +               folio_put(rfs[j].folio);
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
> +               folio_put(rf->folio);
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
> @@ -2284,44 +2278,39 @@ static void process_checks(struct r1bio *r1_bio)
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
> +               /*
> +                * Copy data and submit write in two cases:
> +                * - IO error (non-zero status)
> +                * - Data inconsistency and not a CHECK operation.
> +                */
> +               if (status) {
>                         atomic64_add(r1_bio->sectors, &mddev->resync_mism=
atches);
> -               if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recover=
y)
> -                             && !status)) {
> -                       /* No need to write to this device. */
> -                       sbio->bi_end_io =3D NULL;
> -                       rdev_dec_pending(conf->mirrors[i].rdev, mddev);
> +                       bio_copy_data(sbio, pbio);
>                         continue;
> +               } else if (memcmp(folio_address(pfolio),
> +                       folio_address(sfolio),
> +                       r1_bio->sectors << 9)) {
> +                       atomic64_add(r1_bio->sectors, &mddev->resync_mism=
atches);
> +                       if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery=
)) {
> +                               bio_copy_data(sbio, pbio);
> +                               continue;
> +                       }
>                 }
>
> -               bio_copy_data(sbio, pbio);
> +               /* No need to write to this device. */
> +               sbio->bi_end_io =3D NULL;
> +               rdev_dec_pending(conf->mirrors[i].rdev, mddev);
>         }
>  }
>
> @@ -2446,9 +2435,8 @@ static void fix_read_error(struct r1conf *conf, str=
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
> @@ -2461,9 +2449,8 @@ static void fix_read_error(struct r1conf *conf, str=
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
> @@ -2738,15 +2725,15 @@ static int init_resync(struct r1conf *conf)
>  static struct r1bio *raid1_alloc_init_r1buf(struct r1conf *conf)
>  {
>         struct r1bio *r1bio =3D mempool_alloc(&conf->r1buf_pool, GFP_NOIO=
);
> -       struct resync_pages *rps;
> +       struct resync_folio *rfs;
>         struct bio *bio;
>         int i;
>
>         for (i =3D conf->raid_disks * 2; i--; ) {
>                 bio =3D r1bio->bios[i];
> -               rps =3D bio->bi_private;
> +               rfs =3D bio->bi_private;
>                 bio_reset(bio, NULL, 0);
> -               bio->bi_private =3D rps;
> +               bio->bi_private =3D rfs;
>         }
>         r1bio->master_bio =3D NULL;
>         return r1bio;
> @@ -2775,10 +2762,9 @@ static sector_t raid1_sync_request(struct mddev *m=
ddev, sector_t sector_nr,
>         int write_targets =3D 0, read_targets =3D 0;
>         sector_t sync_blocks;
>         bool still_degraded =3D false;
> -       int good_sectors =3D RESYNC_SECTORS;
> +       int good_sectors;
>         int min_bad =3D 0; /* number of sectors that are bad in all devic=
es */
>         int idx =3D sector_to_idx(sector_nr);
> -       int page_idx =3D 0;
>
>         if (!mempool_initialized(&conf->r1buf_pool))
>                 if (init_resync(conf))
> @@ -2858,8 +2844,11 @@ static sector_t raid1_sync_request(struct mddev *m=
ddev, sector_t sector_nr,
>         r1_bio->sector =3D sector_nr;
>         r1_bio->state =3D 0;
>         set_bit(R1BIO_IsSync, &r1_bio->state);
> -       /* make sure good_sectors won't go across barrier unit boundary *=
/
> -       good_sectors =3D align_to_barrier_unit_end(sector_nr, good_sector=
s);
> +       /*
> +        * make sure good_sectors won't go across barrier unit boundary.
> +        * r1_bio->sectors <=3D RESYNC_SECTORS.
> +        */
> +       good_sectors =3D align_to_barrier_unit_end(sector_nr, r1_bio->sec=
tors);
>
>         for (i =3D 0; i < conf->raid_disks * 2; i++) {
>                 struct md_rdev *rdev;
> @@ -2979,44 +2968,28 @@ static sector_t raid1_sync_request(struct mddev *=
mddev, sector_t sector_nr,
>                 max_sector =3D mddev->resync_max; /* Don't do IO beyond h=
ere */
>         if (max_sector > sector_nr + good_sectors)
>                 max_sector =3D sector_nr + good_sectors;
> -       nr_sectors =3D 0;
> -       sync_blocks =3D 0;
>         do {
> -               struct page *page;
> -               int len =3D PAGE_SIZE;
> -               if (sector_nr + (len>>9) > max_sector)
> -                       len =3D (max_sector - sector_nr) << 9;
> -               if (len =3D=3D 0)
> +               nr_sectors =3D max_sector - sector_nr;
> +               if (nr_sectors =3D=3D 0)
>                         break;
> -               if (sync_blocks =3D=3D 0) {
> -                       if (!md_bitmap_start_sync(mddev, sector_nr,
> -                                                 &sync_blocks, still_deg=
raded) &&
> -                           !conf->fullsync &&
> -                           !test_bit(MD_RECOVERY_REQUESTED, &mddev->reco=
very))
> -                               break;
> -                       if ((len >> 9) > sync_blocks)
> -                               len =3D sync_blocks<<9;
> -               }
> +               if (!md_bitmap_start_sync(mddev, sector_nr,
> +                                         &sync_blocks, still_degraded) &=
&
> +                   !conf->fullsync &&
> +                   !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
> +                       break;
> +               if (nr_sectors > sync_blocks)
> +                       nr_sectors =3D sync_blocks;
>
>                 for (i =3D 0 ; i < conf->raid_disks * 2; i++) {
> -                       struct resync_pages *rp;
> -
>                         bio =3D r1_bio->bios[i];
> -                       rp =3D get_resync_pages(bio);
>                         if (bio->bi_end_io) {
> -                               page =3D resync_fetch_page(rp, page_idx);
> +                               struct resync_folio *rf =3D get_resync_fo=
lio(bio);
>
> -                               /*
> -                                * won't fail because the vec table is bi=
g
> -                                * enough to hold all these pages
> -                                */
> -                               __bio_add_page(bio, page, len, 0);
> +                               bio_add_folio_nofail(bio, rf->folio, nr_s=
ectors << 9, 0);
>                         }
>                 }
> -               nr_sectors +=3D len>>9;
> -               sector_nr +=3D len>>9;
> -               sync_blocks -=3D (len>>9);
> -       } while (++page_idx < RESYNC_PAGES);
> +               sector_nr +=3D nr_sectors;
> +       } while (0);

Now it can handle all pages in one go via a folio. It's strange to
keep while(0) here.


>
>         r1_bio->sectors =3D nr_sectors;


This patch is a little big. Is it better to split this patch here?

>
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 26f93040cd13..3638e00fe420 100644
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
> @@ -133,8 +133,9 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, void=
 *data)
>         struct r10bio *r10_bio;
>         struct bio *bio;
>         int j;
> -       int nalloc, nalloc_rp;
> -       struct resync_pages *rps;
> +       int nalloc, nalloc_rf;
> +       struct resync_folio *rfs;
> +       int order =3D get_order(RESYNC_BLOCK_SIZE);
>
>         r10_bio =3D r10bio_pool_alloc(gfp_flags, conf);
>         if (!r10_bio)
> @@ -148,66 +149,64 @@ static void * r10buf_pool_alloc(gfp_t gfp_flags, vo=
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
> +        * Allocate data folio and attach it where needed.
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
> -
> -               bio =3D r10_bio->devs[j].bio;
> +                       rf_repl =3D &rfs[nalloc + j];
>
>                 if (!j || test_bit(MD_RECOVERY_SYNC,
>                                    &conf->mddev->recovery)) {
> -                       if (resync_alloc_pages(rp, gfp_flags))
> -                               goto out_free_pages;
> +                       if (resync_alloc_folio(rf, gfp_flags, &order))
> +                               goto out_free_folio;
>                 } else {
> -                       memcpy(rp, &rps[0], sizeof(*rp));
> -                       resync_get_all_pages(rp);
> +                       memcpy(rf, &rfs[0], sizeof(*rf));
> +                       folio_get(rf->folio);
>                 }
>
> -               rp->raid_bio =3D r10_bio;
> -               bio->bi_private =3D rp;
> +               rf->raid_bio =3D r10_bio;
> +               r10_bio->devs[j].bio->bi_private =3D rf;
>                 if (rbio) {
> -                       memcpy(rp_repl, rp, sizeof(*rp));
> -                       rbio->bi_private =3D rp_repl;
> +                       memcpy(rf_repl, rf, sizeof(*rf));
> +                       rbio->bi_private =3D rf_repl;
>                 }
>         }
>
> +       r10_bio->sectors =3D 1 << (order + PAGE_SECTORS_SHIFT);
>         return r10_bio;
>
> -out_free_pages:
> +out_free_folio:
>         while (--j >=3D 0)
> -               resync_free_pages(&rps[j]);
> +               folio_put(rfs[j].folio);
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
> +                       folio_put(rf->folio);
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
> @@ -3050,7 +3039,7 @@ static int init_resync(struct r10conf *conf)
>  static struct r10bio *raid10_alloc_init_r10buf(struct r10conf *conf)
>  {
>         struct r10bio *r10bio =3D mempool_alloc(&conf->r10buf_pool, GFP_N=
OIO);
> -       struct rsync_pages *rp;
> +       struct resync_folio *rf;
>         struct bio *bio;
>         int nalloc;
>         int i;
> @@ -3063,14 +3052,14 @@ static struct r10bio *raid10_alloc_init_r10buf(st=
ruct r10conf *conf)
>
>         for (i =3D 0; i < nalloc; i++) {
>                 bio =3D r10bio->devs[i].bio;
> -               rp =3D bio->bi_private;
> +               rf =3D bio->bi_private;
>                 bio_reset(bio, NULL, 0);
> -               bio->bi_private =3D rp;
> +               bio->bi_private =3D rf;
>                 bio =3D r10bio->devs[i].repl_bio;
>                 if (bio) {
> -                       rp =3D bio->bi_private;
> +                       rf =3D bio->bi_private;
>                         bio_reset(bio, NULL, 0);
> -                       bio->bi_private =3D rp;
> +                       bio->bi_private =3D rf;
>                 }
>         }
>         return r10bio;
> @@ -3156,7 +3145,6 @@ static sector_t raid10_sync_request(struct mddev *m=
ddev, sector_t sector_nr,
>         int max_sync =3D RESYNC_SECTORS;
>         sector_t sync_blocks;
>         sector_t chunk_mask =3D conf->geo.chunk_mask;
> -       int page_idx =3D 0;
>
>         /*
>          * Allow skipping a full rebuild for incremental assembly
> @@ -3376,6 +3364,15 @@ static sector_t raid10_sync_request(struct mddev *=
mddev, sector_t sector_nr,
>                                                 continue;
>                                         }
>                                 }
> +
> +                               /*
> +                                * RESYNC_BLOCK_SIZE folio might alloc fa=
iled in
> +                                * resync_alloc_folio(). Fall back to sma=
ller sync
> +                                * size if needed.
> +                                */
> +                               if (max_sync > r10_bio->sectors)
> +                                       max_sync =3D r10_bio->sectors;
> +
>                                 any_working =3D 1;
>                                 bio =3D r10_bio->devs[0].bio;
>                                 bio->bi_next =3D biolist;
> @@ -3527,7 +3524,15 @@ static sector_t raid10_sync_request(struct mddev *=
mddev, sector_t sector_nr,
>                 }
>                 if (sync_blocks < max_sync)
>                         max_sync =3D sync_blocks;
> +
>                 r10_bio =3D raid10_alloc_init_r10buf(conf);
> +               /*
> +                * RESYNC_BLOCK_SIZE folio might alloc failed in resync_a=
lloc_folio().
> +                * Fall back to smaller sync size if needed.
> +                */
> +               if (max_sync > r10_bio->sectors)
> +                       max_sync =3D r10_bio->sectors;
> +
>                 r10_bio->state =3D 0;
>
>                 r10_bio->mddev =3D mddev;
> @@ -3620,29 +3625,25 @@ static sector_t raid10_sync_request(struct mddev =
*mddev, sector_t sector_nr,
>                 }
>         }
>
> -       nr_sectors =3D 0;
>         if (sector_nr + max_sync < max_sector)
>                 max_sector =3D sector_nr + max_sync;
>         do {
> -               struct page *page;
> -               int len =3D PAGE_SIZE;
> -               if (sector_nr + (len>>9) > max_sector)
> -                       len =3D (max_sector - sector_nr) << 9;
> -               if (len =3D=3D 0)
> +               nr_sectors =3D max_sector - sector_nr;
> +
> +               if (nr_sectors =3D=3D 0)
>                         break;
>                 for (bio=3D biolist ; bio ; bio=3Dbio->bi_next) {
> -                       struct resync_pages *rp =3D get_resync_pages(bio)=
;
> -                       page =3D resync_fetch_page(rp, page_idx);
> -                       if (WARN_ON(!bio_add_page(bio, page, len, 0))) {
> +                       struct resync_folio *rf =3D get_resync_folio(bio)=
;
> +
> +                       if (WARN_ON(!bio_add_folio(bio, rf->folio, nr_sec=
tors << 9, 0))) {
>                                 bio->bi_status =3D BLK_STS_RESOURCE;
>                                 bio_endio(bio);
>                                 *skipped =3D 1;
> -                               return max_sync;
> +                               return nr_sectors << 9;
>                         }
>                 }
> -               nr_sectors +=3D len>>9;
> -               sector_nr +=3D len>>9;
> -       } while (++page_idx < RESYNC_PAGES);
> +               sector_nr +=3D nr_sectors;
> +       } while (0);
>         r10_bio->sectors =3D nr_sectors;
>
>         if (mddev_is_clustered(mddev) &&
> @@ -4560,7 +4561,7 @@ static sector_t reshape_request(struct mddev *mddev=
, sector_t sector_nr,
>                                 int *skipped)
>  {
>         /* We simply copy at most one chunk (smallest of old and new)
> -        * at a time, possibly less if that exceeds RESYNC_PAGES,
> +        * at a time, possibly less if that exceeds RESYNC_BLOCK_SIZE,
>          * or we hit a bad block or something.
>          * This might mean we pause for normal IO in the middle of
>          * a chunk, but that is not a problem as mddev->reshape_position
> @@ -4600,14 +4601,13 @@ static sector_t reshape_request(struct mddev *mdd=
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
> @@ -4709,7 +4709,12 @@ static sector_t reshape_request(struct mddev *mdde=
v, sector_t sector_nr,
>         r10_bio->mddev =3D mddev;
>         r10_bio->sector =3D sector_nr;
>         set_bit(R10BIO_IsReshape, &r10_bio->state);
> -       r10_bio->sectors =3D last - sector_nr + 1;
> +       /*
> +        * RESYNC_BLOCK_SIZE folio might alloc failed in
> +        * resync_alloc_folio(). Fall back to smaller sync
> +        * size if needed.
> +        */
> +       r10_bio->sectors =3D min_t(int, r10_bio->sectors, last - sector_n=
r + 1);
>         rdev =3D read_balance(conf, r10_bio, &max_sectors);
>         BUG_ON(!test_bit(R10BIO_Previous, &r10_bio->state));
>
> @@ -4723,7 +4728,7 @@ static sector_t reshape_request(struct mddev *mddev=
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
> @@ -4787,32 +4792,23 @@ static sector_t reshape_request(struct mddev *mdd=
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

In fact, the original codes don't clean up before returning.
bio_add_folio_nofail is used in raid1 and can we use
bio_add_folio_nofail here as well?

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
> @@ -4914,8 +4910,8 @@ static int handle_reshape_read_error(struct mddev *=
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
> @@ -4923,8 +4919,8 @@ static int handle_reshape_read_error(struct mddev *=
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
> @@ -4940,19 +4936,19 @@ static int handle_reshape_read_error(struct mddev=
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
> @@ -4971,7 +4967,7 @@ static int handle_reshape_read_error(struct mddev *=
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
>

Regards
Xiao

