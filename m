Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BA3515746F
	for <linux-raid@vger.kernel.org>; Mon, 19 Jan 2026 03:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768792821; cv=none; b=tT97Gb0CwIi7JtgXsrcZBoT/tns6LWJOBcHH4qTNGwSxzTjdemw5pKwYhQ0s4epViujcyNUr5KYFfJCtEeE4MgDyc9AVEH48Tg7jd7Rw8BEwwB8gb+foR8PtLzG4uOs68meDkQWzdFfIdqE+hlSp5jKEsF9nesLxkf+NKUe2IR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768792821; c=relaxed/simple;
	bh=i4sVU6gUDelSzAgYV3XJKeLT6YSej5OTinZx5XAU8p0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jlUmUngQjQoid7p/stD4xFAkQpsEL/wSmnuxTf2rLyGcuV8gbBy6SG0xfnF4yg262JEymL1bU9aWN6DJ4hfmnDLa/e2mde2LKPlCh+E7s6M83mvSnAjOC3WxnSLfNkK7q56yjLye9oFft0w9btP+f+gNRrz2Nf4xrgHBnjifGPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EjgmzrSl; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ckrxmhhh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EjgmzrSl";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ckrxmhhh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768792819;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nKlZBE/uTqYoHJkASsgDvXK+2cr3j4JILTLENmiE78c=;
	b=EjgmzrSlEMfgtjM6gpO5t7LLh/lTteksSq7xIrS5LTrdLKsdhK4W8XUM+FpFFfo2QfNBdN
	GUx9DX1SqcE+6oCyIto0cZBse2JhrzT2cLcovTNIjdSKd6/1rkAv8p21U0cY4CKxqKhHWa
	SU3PQWWIR69Pq3SatpJlh8GKPw8sArI=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-499-eZjjYmXqMnGYWxTaIiE63A-1; Sun, 18 Jan 2026 22:20:17 -0500
X-MC-Unique: eZjjYmXqMnGYWxTaIiE63A-1
X-Mimecast-MFC-AGG-ID: eZjjYmXqMnGYWxTaIiE63A_1768792816
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-59b686eafcfso2591034e87.2
        for <linux-raid@vger.kernel.org>; Sun, 18 Jan 2026 19:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768792816; x=1769397616; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nKlZBE/uTqYoHJkASsgDvXK+2cr3j4JILTLENmiE78c=;
        b=ckrxmhhhkyILKovWoHjuheoWwBc2xxNVZ0i6hWYjbp+UbuD68ExFytV4ish67snKfs
         T1J9p2A9/yhtgWTGWEvrC+m6mldD/O6/wOzeGB65KZuvK+1hdHL2b1kLmn6QrHXs30El
         mgX2x7OSQOv+FExIvlVBjyoJy/yxk4kQNdlbGQ+8eXvFiLz7KidmHjUM0B75IfxYsoE3
         JdsFRfBktW4ruiMDyRr5xG/OQ8ObnEla2T0qUYll+y9ZTrfuXA8ZcKbK8BnuCMnsOhie
         fO7Bw59NM0MEuK1S8GftW0Zr3rCWb1URoXJe7G/qa46Y9ENFJ4p6ktY3XyF66vHV47mw
         yTuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768792816; x=1769397616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nKlZBE/uTqYoHJkASsgDvXK+2cr3j4JILTLENmiE78c=;
        b=eYsofU5GymnsMP3oQA7g6eWDdN4yeCMjcdVB7OKFaIsi5jltpocPXVf5RTC7FeBEn5
         QrlcWaEBV+DMLMDMOudnQveG4yMTbH5VeO5pWo1W7xzf1yqmMdjXpztTJtbrxZuRBwx1
         DNvDmbOEZW6pL8OPklhnVGNkNF/riN1uv5LwivueRxqE1dA3oRS1I796WBc2KianJtPZ
         8d+CZchWgmR3LpYTwkY7Qg6sncsjbHuvaeBIm+e+6iI4Eq6i2yw4jg4PvBjZGqFmO+Ym
         eh/GC/aW1r/Ibq6eObCTHZgFWHRFpAOFcC3+xjmngfHsYsoNnwYqPqHjcOWPMSRm1bZ2
         46kg==
X-Forwarded-Encrypted: i=1; AJvYcCUtexXh2SUN35dPFchgLHZmbIrNfiAugAbeJw47mlyifGlWtPGTjqH2TzTTPVtiINf89jgH84sjLTN6@vger.kernel.org
X-Gm-Message-State: AOJu0Ywvyi1MxU3nDzIu/ciEZhcCIXMaze6a6eEMSn4cIoJL5N6atWZE
	4WSI/A38A5u4h1cbitlvhmeqa9cJA9udZCPvaQ1ce0u7nmarBsZYdKLV6UxkrU+0idJRMRu7yDf
	7Y8/wpsmORv9RQOlW8wryPkxwF6v9b0dWRW9mQIMtPo/ZbXTd4oCNVZMd9tfVHm3m9J+qQIpVvU
	KTSuvN1mNkfM4a9apToSLpTvaMBAVUp7nYrSq8RA==
X-Gm-Gg: AY/fxX7MiMRP4+vQtzJNx/IgOCJXB7EqZr+9DHiR/ZhTwt8MTI/FQhI+wjKr+9WM6Qd
	LPaj+nRZaznRymFbUug+P9S7B+Q2bywzVaWcNICYiv6kAOLYIoFoe6BL2XalAkulpAa8a00SOT+
	R200SBlTPvptCXcTUP0cuE59Cuq/w0naNa5Wu75/jCGCxBieQ8DIxRyu86XySspqnu5xLMY3Twf
	KQc0Qt9/4Wev7Nrx78L2f5WPOPaui6fsMi9thtCOWm9CBCeCQbz6ybaiUFO4V13L3oY9A==
X-Received: by 2002:a05:6512:1385:b0:598:f262:1658 with SMTP id 2adb3069b0e04-59baffc6bb1mr3324550e87.34.1768792816148;
        Sun, 18 Jan 2026 19:20:16 -0800 (PST)
X-Received: by 2002:a05:6512:1385:b0:598:f262:1658 with SMTP id
 2adb3069b0e04-59baffc6bb1mr3324538e87.34.1768792815693; Sun, 18 Jan 2026
 19:20:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251217120013.2616531-1-linan666@huaweicloud.com> <20251217120013.2616531-5-linan666@huaweicloud.com>
In-Reply-To: <20251217120013.2616531-5-linan666@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 19 Jan 2026 11:20:03 +0800
X-Gm-Features: AZwV_Qg-WD_BjGs2JRZI35zCLftjACAUPcoCfHo89b3rpI0McmGlPHRxiybCDEA
Message-ID: <CALTww2-bCOHsK=iXqkTokFBdG=kxc6NsdgtyfWPXBaSX6pmcAA@mail.gmail.com>
Subject: Re: [PATCH 04/15] md/raid1: use folio for tmppage
To: linan666@huaweicloud.com
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2025 at 8:11=E2=80=AFPM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> Convert tmppage to tmpfolio and use it throughout in raid1.
>
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>  drivers/md/raid1.h |  2 +-
>  drivers/md/raid1.c | 18 ++++++++++--------
>  2 files changed, 11 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> index c98d43a7ae99..d480b3a8c2c4 100644
> --- a/drivers/md/raid1.h
> +++ b/drivers/md/raid1.h
> @@ -101,7 +101,7 @@ struct r1conf {
>         /* temporary buffer to synchronous IO when attempting to repair
>          * a read error.
>          */
> -       struct page             *tmppage;
> +       struct folio            *tmpfolio;
>
>         /* When taking over an array from a different personality, we sto=
re
>          * the new thread here until we fully activate the array.
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 407925951299..43453f1a04f4 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2417,8 +2417,8 @@ static void fix_read_error(struct r1conf *conf, str=
uct r1bio *r1_bio)
>                               rdev->recovery_offset >=3D sect + s)) &&
>                             rdev_has_badblock(rdev, sect, s) =3D=3D 0) {
>                                 atomic_inc(&rdev->nr_pending);
> -                               if (sync_page_io(rdev, sect, s<<9,
> -                                        conf->tmppage, REQ_OP_READ, fals=
e))
> +                               if (sync_folio_io(rdev, sect, s<<9, 0,
> +                                        conf->tmpfolio, REQ_OP_READ, fal=
se))
>                                         success =3D 1;
>                                 rdev_dec_pending(rdev, mddev);
>                                 if (success)
> @@ -2447,7 +2447,8 @@ static void fix_read_error(struct r1conf *conf, str=
uct r1bio *r1_bio)
>                             !test_bit(Faulty, &rdev->flags)) {
>                                 atomic_inc(&rdev->nr_pending);
>                                 r1_sync_page_io(rdev, sect, s,
> -                                               conf->tmppage, REQ_OP_WRI=
TE);
> +                                               folio_page(conf->tmpfolio=
, 0),
> +                                               REQ_OP_WRITE);
>                                 rdev_dec_pending(rdev, mddev);
>                         }
>                 }
> @@ -2461,7 +2462,8 @@ static void fix_read_error(struct r1conf *conf, str=
uct r1bio *r1_bio)
>                             !test_bit(Faulty, &rdev->flags)) {
>                                 atomic_inc(&rdev->nr_pending);
>                                 if (r1_sync_page_io(rdev, sect, s,
> -                                               conf->tmppage, REQ_OP_REA=
D)) {
> +                                               folio_page(conf->tmpfolio=
, 0),
> +                                               REQ_OP_READ)) {
>                                         atomic_add(s, &rdev->corrected_er=
rors);
>                                         pr_info("md/raid1:%s: read error =
corrected (%d sectors at %llu on %pg)\n",
>                                                 mdname(mddev), s,
> @@ -3120,8 +3122,8 @@ static struct r1conf *setup_conf(struct mddev *mdde=
v)
>         if (!conf->mirrors)
>                 goto abort;
>
> -       conf->tmppage =3D alloc_page(GFP_KERNEL);
> -       if (!conf->tmppage)
> +       conf->tmpfolio =3D folio_alloc(GFP_KERNEL, 0);
> +       if (!conf->tmpfolio)
>                 goto abort;
>
>         r1bio_size =3D offsetof(struct r1bio, bios[mddev->raid_disks * 2]=
);
> @@ -3196,7 +3198,7 @@ static struct r1conf *setup_conf(struct mddev *mdde=
v)
>         if (conf) {
>                 mempool_destroy(conf->r1bio_pool);
>                 kfree(conf->mirrors);
> -               safe_put_page(conf->tmppage);
> +               folio_put(conf->tmpfolio);
>                 kfree(conf->nr_pending);
>                 kfree(conf->nr_waiting);
>                 kfree(conf->nr_queued);
> @@ -3310,7 +3312,7 @@ static void raid1_free(struct mddev *mddev, void *p=
riv)
>
>         mempool_destroy(conf->r1bio_pool);
>         kfree(conf->mirrors);
> -       safe_put_page(conf->tmppage);
> +       folio_put(conf->tmpfolio);
>         kfree(conf->nr_pending);
>         kfree(conf->nr_waiting);
>         kfree(conf->nr_queued);
> --
> 2.39.2
>

Hi Nan

Same question for patch04 and patch05, tmpage is used in read io path.
From the cover letter, this patch set wants to resolve the multi pages
in sync io path. Is it better to keep them for your future patch set?

Best Regards
Xiao

Xiao

