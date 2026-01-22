Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1874139D0A
	for <linux-raid@vger.kernel.org>; Thu, 22 Jan 2026 07:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769065289; cv=pass; b=tjeq0/RzTh4GqqF+k+Ot5S0OWjCRx1ytuwE7RrwckbKN2oQGxUqcIoS+sAt6MY0F2YEfaVsw8stU8kSO9Gcl5E4ZwhoPwgR3I3wxlh92TPvg/wZZn1Q93LtAviOX/gslpgUgfifAUIDPM0zIvjvSh+EAxjKXqWJU3uL6ahECaB4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769065289; c=relaxed/simple;
	bh=SO36hAlZiBCps03JqsXwr3iOE/u1SC8k2lL5kV8fN/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ANfTZF4CxM01oQYJaOx1w2U4UXTxnCXI/ppfJOCXN5IYymOAGsta5siHWjijBjMUYI5gyP71LD8DrzMVHkmjKbKOgBp8Fb0dz7B49+swDUl7C0B/qIMZJsCs9Isa9LkMljpryJnXdAb11MO06Q7n6sgDgJ4pvJkORv2KAwJHjJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Mh+1bDZd; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=NsNPgKxx; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Mh+1bDZd";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="NsNPgKxx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769065281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4xkMZij0PcZqcjkVpIImQ2FA4oNqxtavMHLH1uQ8B1Y=;
	b=Mh+1bDZdPC4RjA9YyArUCJ4VSLQSTeUl5SW2r1rrSx4+pWlhtEiPgdXnnb8bGHFsLD+MB8
	nkxktOyGIth3DJW0798lmYVmgvebhdZPgEXV9ZCCwad0VR6ms5c7acWlHSCLJRzUuq2lzi
	hXEWJH1zrTURmx6wqNP4b5cFMf5blIY=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-104-MkAhWp0uNbehOByFMfABcA-1; Thu, 22 Jan 2026 02:01:19 -0500
X-MC-Unique: MkAhWp0uNbehOByFMfABcA-1
X-Mimecast-MFC-AGG-ID: MkAhWp0uNbehOByFMfABcA_1769065276
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-59dde1f5e41so231254e87.1
        for <linux-raid@vger.kernel.org>; Wed, 21 Jan 2026 23:01:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769065276; cv=none;
        d=google.com; s=arc-20240605;
        b=gLVE+5N7dynYA0stfgqSce6ckBA2mxUS1NUOfJ+r2571e9b+kHHDk3yMiIBi/XDF4Y
         9TR+FQZX5+7TkgE+4dAA6oRLt7rwGUdMXpeGpmyzC/qC2I0M/c6VzGn0Rlr/xwGfta1y
         FzY40PLWNZcLuAQry4Injw/PU0bwoHLdyNXCiV684H7tgb6otUTlpSOaUU/qVm6LLBuB
         3QpzywA3PWOnkis7m5qqThHGuHkmNQqLnRq9pYRJb33YLAcU7hY59ytOpo+M+QcxSf/Z
         91V8RoI/5uU7FG+0iyJXfsn1a48r9m/EOhsi5ft2rzVflM6daVGjrYaaJCg5VBGKD3Nz
         si5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4xkMZij0PcZqcjkVpIImQ2FA4oNqxtavMHLH1uQ8B1Y=;
        fh=YP5Dj73SABEgU1eGEfi88GPdWLo+j5y2J6R0974tvg4=;
        b=VtMq8qjEpU1BQv3UmshHM5Vj0kNrdNZnGhDiwx0+XMMFwLjOfsd5rWAhFzmhpe3Hui
         5LFndelA8dFtURCmmIAnBh6otDFsmeiJKioxdvwN2QeG/lI+ODNh8VexUvDoDFbdsRVa
         +gt1vAoa3Kue4tmNoAyrX5F50z+WfMUj+Frf4iwKGOJbLP5hhS5NNhV2KU4K8pYPa+KM
         zMa5ZqwQkZHAHlhXN0ihk69WGU1IxoYhHZ/RSUeKva2pqodTLHbvtl0z8zWyEHmNLyS1
         3rRHB8wtA9v7M/72srv5oqJXytix3zl5FGglktoE/WfvoVUimxdsqLCaWzdg4LgnVM+3
         i9Pg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769065276; x=1769670076; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4xkMZij0PcZqcjkVpIImQ2FA4oNqxtavMHLH1uQ8B1Y=;
        b=NsNPgKxxvSij+nQs2ycW+o4BoGpZERAgEeLAOlVtrzTQyMqIXCnSTqaVwRWdMvhh3e
         Jo0/zFCwq5ZbeeOsQtUlzoZSiCV9OEFTIOvPEDApVVXzYk12S7z1eRsJLbDqOSxea7yU
         qEf0PFzSQnjIyKjHW6jkMLh2ELGRFqMilbHGboq8oYyaIzVBz7k9anZxAqHxQaU/C+kh
         97kpYQt/2wnEfXRAGgZ/2mJnPYvExCBfjSRs4DW02QcWmi8Jjg1Jg/Wae3+kk3SxV2ZI
         Apm+sxqbWUH5oEA8tBuu/OCTGZijwZzjtxl9sAsMcR0PTL9gGXIC1uAbqPWMzNPB+/Jx
         yHDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769065276; x=1769670076;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4xkMZij0PcZqcjkVpIImQ2FA4oNqxtavMHLH1uQ8B1Y=;
        b=M/ZD+Q0MGNOWJDX6ptpI8Ow3+s9k/pB1oALg0pQx3i3Yqpqrc2/wPC+0Khxxp/NxL5
         YagTurYZ//DQcbHTbg6WDK3nu2v2uLqmGW/9Jgz4K+kk0Xpy+1+k7f1iDUiAtseoo/H8
         ctydvY9QZ1yDMjSebR7cOPah49wgy/3HL4gOFH33eO5yXj/lc6qS6M+yQpoqyOCDPMtz
         zh0+pTtWWRSLNbEZQzVgXjCYcH6aPwksXc0Kv8OYeIZbkX1cD9xcqFCQhmk02JMXRM+9
         KAZsY8nLpYt6NglBlDkiK4XNe3aGX5OqRUrMcG87i+UFpWr5EAwN649RMUHkDrSb9yUU
         b10g==
X-Forwarded-Encrypted: i=1; AJvYcCWoWHJOVbTUFJ2Xp214VdJMWkA5+ABcq3YYDJTFkKwd3tPR7OG4zhp/bbt62E0T4ZQtE86eimvcW8qP@vger.kernel.org
X-Gm-Message-State: AOJu0YyENEaL72/lfDOJrCfntXbLApi7ApZf+BRQY80zAfvv3pderVmQ
	yFR0AdItMuPNIDqaNx3s4T9+a7hWvZRbGygIX9P6c6wH7psEb152UYckKSHzbNfrth1Zf3qPfd4
	4EEepeCOFy+xFFV0urfCGWzqTbJELtYZpJ7LHIAGNuEpAiM21ikbzrwqNkD4xGk14wF+RrB3oy4
	m+QdkUw536xiBUEsojOh/WloJNn4Jt/mpXZ89JPQ==
X-Gm-Gg: AZuq6aKU42DD9NYDSwhBjh4RKJE2AVWMlghGmkWkZqKeZl7bf97cBXgyQvjca2BkH8N
	Fc83W5ES9UwxynHTIU6W5cQnd6KmOWcE2jGbAcwP6RFY0hxvpQnqEbd1ux0aqIyPHawehUOQK3+
	evySLKPoDDM52FKK3rpNqwwE3GZFSB3CgrG5SgXMuQsTuy5gKlGORgyk7a6DIaQPI+vGF0/VUWY
	+JvxybOO1gktwQCOd5tq3muNxReYmgJEP2CU5sHa/QHxpo6fytHiPJ+qJJHOOkHB0/Pnw==
X-Received: by 2002:a05:6512:2525:b0:59d:df02:afac with SMTP id 2adb3069b0e04-59ddf02b08dmr282362e87.8.1769065275271;
        Wed, 21 Jan 2026 23:01:15 -0800 (PST)
X-Received: by 2002:a05:6512:2525:b0:59d:df02:afac with SMTP id
 2adb3069b0e04-59ddf02b08dmr282345e87.8.1769065274454; Wed, 21 Jan 2026
 23:01:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251217120013.2616531-1-linan666@huaweicloud.com>
 <20251217120013.2616531-7-linan666@huaweicloud.com> <CALTww28w8EJL2TVs06f_h98SjkiGAiYD9+BUvqEG2HKsrssSsg@mail.gmail.com>
 <a0423bf6-c924-0012-172b-1217069ff3ec@huaweicloud.com>
In-Reply-To: <a0423bf6-c924-0012-172b-1217069ff3ec@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 22 Jan 2026 15:01:02 +0800
X-Gm-Features: AZwV_QiHl7pvra8M66u8MYzMlrpE_-46__5DlHOvsIACGekKV-BZC_fwgwRnu1o
Message-ID: <CALTww2-kpMGb8cYTtFcg5=5Y+8W_eBSHv=SdEExOivTK7OisLQ@mail.gmail.com>
Subject: Re: [PATCH 06/15] md/raid1,raid10: use folio for sync path IO
To: Li Nan <linan666@huaweicloud.com>
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2026 at 10:12=E2=80=AFAM Li Nan <linan666@huaweicloud.com> =
wrote:
>
>
>
> =E5=9C=A8 2026/1/20 23:53, Xiao Ni =E5=86=99=E9=81=93:
> > On Wed, Dec 17, 2025 at 8:11=E2=80=AFPM <linan666@huaweicloud.com> wrot=
e:
> >>
> >> From: Li Nan <linan122@huawei.com>
> >>
> >> Convert all IO on the sync path to use folios. Rename page-related
> >> identifiers to match folio.
> >>
> >> Retain some now-unnecessary while and for loops to minimize code
> >> changes, clean them up in a subsequent patch.
> >>
> >> Signed-off-by: Li Nan <linan122@huawei.com >> -static inline int resyn=
c_alloc_pages(struct resync_pages *rp,
> >> +static inline int resync_alloc_folio(struct resync_folio *rf,
> >>                                       gfp_t gfp_flags)
> >>   {
> >> -       int i;
> >> -
> >> -       for (i =3D 0; i < RESYNC_PAGES; i++) {
> >> -               rp->pages[i] =3D alloc_page(gfp_flags);
> >> -               if (!rp->pages[i])
> >> -                       goto out_free;
> >> -       }
> >> +       rf->folio =3D folio_alloc(gfp_flags, get_order(RESYNC_BLOCK_SI=
ZE));
> >> +       if (!rf->folio)
> >> +               return -ENOMEM;
> >
> > Is it ok to add an error log here? Compare with the multipage
> > situation, the possibility of failure will be somewhat higher because
> > it needs to alloc a contiguous block of physical memory.
> >
>
> Hi, Xiao
>
> Thanks for your review.
>
> In patch 15 we fall back to a smaller order if sync folio alloc fails.
> After that the alloc usually succeeds, so an error log seems noisy. Shoul=
d
> I add a log before the fallback and keep it in patch 15?

Thanks for the explanation. No change is needed here :)

>
> >> -static void md_bio_reset_resync_pages(struct bio *bio, struct resync_=
pages *rp,
> >> +static void md_bio_reset_resync_folio(struct bio *bio, struct resync_=
folio *rf,
> >>                                 int size)
> >>   {
> >> -       int idx =3D 0;
> >> -
> >>          /* initialize bvec table again */
> >>          do {
> >> -               struct page *page =3D resync_fetch_page(rp, idx);
> >> -               int len =3D min_t(int, size, PAGE_SIZE);
> >> +               struct folio *folio =3D resync_fetch_folio(rf);
> >> +               int len =3D min_t(int, size, RESYNC_BLOCK_SIZE);
> >>
> >> -               if (WARN_ON(!bio_add_page(bio, page, len, 0))) {
> >> +               if (WARN_ON(!bio_add_folio(bio, folio, len, 0))) {
> >
> > Is it ok to use bio_add_folio(bio, folio, RESYNC_BLOCK_SIZE, 0)
> > directly here? It removes `size -=3D len` below, so it's not useless to
> > compare size and RESYNC_BLOCK_SIZE above?
> >
>
> Same as the previous one, the size is no longer a fixed value after
> patch 15. I think keeping it here gives better compatibility.

Thanks for the explanation.

>
> >>          /*
> >> -        * Allocate RESYNC_PAGES data pages and attach them to
> >> -        * the first bio.
> >> +        * Allocate data folio and attach them to the first bio.
> >
> > typo error
> > s/attach them/attach it/g
> >
>
> I will fix it later. Thanks.
>
> >> @@ -2284,44 +2278,30 @@ static void process_checks(struct r1bio *r1_bi=
o)
> >>                  }
> >>          r1_bio->read_disk =3D primary;
> >>          for (i =3D 0; i < conf->raid_disks * 2; i++) {
> >> -               int j =3D 0;
> >>                  struct bio *pbio =3D r1_bio->bios[primary];
> >>                  struct bio *sbio =3D r1_bio->bios[i];
> >>                  blk_status_t status =3D sbio->bi_status;
> >> -               struct page **ppages =3D get_resync_pages(pbio)->pages=
;
> >> -               struct page **spages =3D get_resync_pages(sbio)->pages=
;
> >> -               struct bio_vec *bi;
> >> -               int page_len[RESYNC_PAGES] =3D { 0 };
> >> -               struct bvec_iter_all iter_all;
> >> +               struct folio *pfolio =3D get_resync_folio(pbio)->folio=
;
> >> +               struct folio *sfolio =3D get_resync_folio(sbio)->folio=
;
> >>
> >>                  if (sbio->bi_end_io !=3D end_sync_read)
> >>                          continue;
> >>                  /* Now we can 'fixup' the error value */
> >>                  sbio->bi_status =3D 0;
> >>
> >> -               bio_for_each_segment_all(bi, sbio, iter_all)
> >> -                       page_len[j++] =3D bi->bv_len;
> >> -
> >> -               if (!status) {
> >> -                       for (j =3D vcnt; j-- ; ) {
> >> -                               if (memcmp(page_address(ppages[j]),
> >> -                                          page_address(spages[j]),
> >> -                                          page_len[j]))
> >> -                                       break;
> >> -                       }
> >> -               } else
> >> -                       j =3D 0;
> >> -               if (j >=3D 0)
> >> +               if (status || memcmp(folio_address(pfolio),
> >> +                                    folio_address(sfolio),
> >> +                                    r1_bio->sectors << 9)) {
> >>                          atomic64_add(r1_bio->sectors, &mddev->resync_=
mismatches);
> >> -               if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->reco=
very)
> >> -                             && !status)) {
> >> -                       /* No need to write to this device. */
> >> -                       sbio->bi_end_io =3D NULL;
> >> -                       rdev_dec_pending(conf->mirrors[i].rdev, mddev)=
;
> >> -                       continue;
> >> +                       if (!test_bit(MD_RECOVERY_CHECK, &mddev->recov=
ery)) {
> >> +                               bio_copy_data(sbio, pbio);
> >> +                               continue;
> >> +                       }
> >
> > The logic is changed here. The original logic:
> > 1. read ok, no mismatch: no bio_copy_data
> > 2. read ok, mismatch, check: no bio_copy_data
> > 3. read ok, mismatch, no check: need bio_copy_data
> > 4. read fail: need bio_copy_data
> >
> > The 4 is broken.
> >
> > How about adding a temporary need_write to make logic more clear?
> >
> > something like:
> >          if (!status) {
> >              int ret =3D 0;
> >              ret =3D memcpy(folio_address(pfolio),
> >                               folio_address(sfolio),
> >                               r1_bio->sectors << 9);
> >              if (ret) {
> >                  atomic64_add(r1_bio->sectors, &mddev->resync_mismatche=
s);
> >                  if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
> >                      need_write =3D true;
> >              }
> >          } else
> >              need_write =3D true;
> >
> >          if (need_write)
> >              bio_copy_data(sbio, pbio);
> >          else {
> >              /* No need to write to this device. */
> >              sbio->bi_end_io =3D NULL;
> >              rdev_dec_pending(conf->mirrors[i].rdev, mddev);
> >          }
> >
>
> Nice catch, read failis is indeed broken. I=E2=80=99ll fix it in v2.
>
> >>                  }
> >>
> >> -               bio_copy_data(sbio, pbio);
> >> +               /* No need to write to this device. */
> >> +               sbio->bi_end_io =3D NULL;
> >> +               rdev_dec_pending(conf->mirrors[i].rdev, mddev);
> >>          }
> >>   }
> >> >> @@ -3020,24 +2997,24 @@ static sector_t   (struct mddev *mddev, sec=
tor_t
> sector_nr,
> >>                  }
> >>
> >>                  for (i =3D 0 ; i < conf->raid_disks * 2; i++) {
> >> -                       struct resync_pages *rp;
> >> +                       struct resync_folio *rf;
> >>
> >>                          bio =3D r1_bio->bios[i];
> >> -                       rp =3D get_resync_pages(bio);
> >> +                       rf =3D get_resync_folio(bio);
> >>                          if (bio->bi_end_io) {
> >> -                               page =3D resync_fetch_page(rp, page_id=
x);
> >> +                               folio =3D resync_fetch_folio(rf);
> >>
> >>                                  /*
> >>                                   * won't fail because the vec table i=
s big
> >>                                   * enough to hold all these pages
> >>                                   */
> >
> > The comments above may not be needed anymore. Because there is only
> > one vec in the bio.
> >
>
> I will clean it up.
>
> >> -                               __bio_add_page(bio, page, len, 0);
> >> +                               bio_add_folio_nofail(bio, folio, len, =
0);
> >>                          }
> >>                  }
> >>                  nr_sectors +=3D len>>9;
> >>                  sector_nr +=3D len>>9;
> >>                  sync_blocks -=3D (len>>9);
> >
> > These three lines are not needed anymore.
> >
>
> It is cleaned up in later patches. In this patch I only want minimal
> changes, just folio API and naming replacements. Do you think I should mo=
ve
> those cleanups into this patch?

I think it's a better choice. But it really depends on you. I'm ok if
you prefer your patch sequence.

>
>
> >>          /*
> >> -        * Allocate RESYNC_PAGES data pages and attach them
> >> -        * where needed.
> >> +        * Allocate data folio and attach them where needed.
> >
> > typo error
> > s/attach them/attach it/g
> >
>
> I will fix it in v2.
>
> >>           */
> >>          for (j =3D 0; j < nalloc; j++) {
> >>                  struct bio *rbio =3D r10_bio->devs[j].repl_bio;
> >> -               struct resync_pages *rp, *rp_repl;
> >> +               struct resync_folio *rf, *rf_repl;
> >>
> >> -               rp =3D &rps[j];
> >> +               rf =3D &rfs[j];
> >>                  if (rbio)
> >> -                       rp_repl =3D &rps[nalloc + j];
> >> +                       rf_repl =3D &rfs[nalloc + j];
> >>
> >>                  bio =3D r10_bio->devs[j].bio;
> >>
> >>                  if (!j || test_bit(MD_RECOVERY_SYNC,
> >>                                     &conf->mddev->recovery)) {
> >> -                       if (resync_alloc_pages(rp, gfp_flags))
> >> +                       if (resync_alloc_folio(rf, gfp_flags))
> >>                                  goto out_free_pages;
> >
> > s/out_free_pages/out_free_folio/g
> >
>
> I will fix it in v2.
>
> >>                  } else {
> >> -                       memcpy(rp, &rps[0], sizeof(*rp));
> >> -                       resync_get_all_pages(rp);
> >> +                       memcpy(rf, &rfs[0], sizeof(*rf));
> >> +                       resync_get_all_folio(rf);
> >
> > Maybe the name resync_get_folio is better?
>
> Agree, I will rename it in v2.
>
> >> @@ -2492,19 +2480,21 @@ static void fix_recovery_read_error(struct r10=
bio *r10_bio)
> >>
> >>                  rdev =3D conf->mirrors[dr].rdev;
> >>                  addr =3D r10_bio->devs[0].addr + sect;
> >> -               ok =3D sync_page_io(rdev,
> >> -                                 addr,
> >> -                                 s << 9,
> >> -                                 pages[idx],
> >> -                                 REQ_OP_READ, false);
> >> +               ok =3D sync_folio_io(rdev,
> >> +                                  addr,
> >> +                                  s << 9,
> >> +                                  sect << 9,
> >> +                                  folio,
> >> +                                  REQ_OP_READ, false);
> >
> > By the comments at the beginning of fix_recovery_read_error, it needs
> > to submit io with a page size unit, right? If so, it still needs to
> > use sync_page_io here.
> >
>
> Here 's' is PAGE_SIZE. We just use a 'page' from folio. In patch 10,
> I will change it to use logical block size instead, which should be more
> reasonable.

Ok.

>
> >>          /*
> >>           * Allow skipping a full rebuild for incremental assembly
> >> @@ -3277,7 +3265,7 @@ static sector_t raid10_sync_request(struct mddev=
 *mddev, sector_t sector_nr,
> >>           * with 2 bios in each, that correspond to the bios in the ma=
in one.
> >>           * In this case, the subordinate r10bios link back through a
> >>           * borrowed master_bio pointer, and the counter in the master
> >> -        * includes a ref from each subordinate.
> >> +        * bio_add_folio includes a ref from each subordinate.
> >
> > What's the reason change this? And I don't understand the new version.
> >
>
> It looks like a typo. I will remove it.
>
> > Best Regards
> > Xiao
>
> Thanks again for your careful review.

You're welcome.

Best Regards
Xiao
>
> --
> Thanks,
> Nan
>

