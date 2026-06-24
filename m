Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBAD7351C34
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 17:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782321943; cv=pass; b=NKph0Dx9agErAYmcn7MSh3aM3K89HnlquPKTpMYAJ7GP0J8/p975LFrRfIOyZqeMEb7szFSiYavnfAZAgFUcRpxnS7f8RowrdEvaMlisc75QKG8dg1H9r7CMZTdFf4UXdPx87XL7q4p3jCEPNFCYVTYnHWd2jy0TRNdaQeLwhwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782321943; c=relaxed/simple;
	bh=FDHI7VnrkkCOG8jvaI6SfzXOA+cSFumE07u+TGQZETg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Fbd9Va4UpCobVqDaxovBBrxU2aYv6Ql4Tz9AxpiIbKKqiSj07h1RBTgqjIWufnVmRRznkXOnvQKNwaWEo9Y1shBir2yPOo/WgsuoOvAu8py+ExBCNKuDgfTHsOqET9XDne1k7kI5sQK57jvaLGkKE7O/gkt5x/JHXrlZpQu9B0Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EXtAyqq3; arc=pass smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EXtAyqq3"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2c7f11646c3so4389425ad.3
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 10:25:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782321941; cv=none;
        d=google.com; s=arc-20240605;
        b=hoLW7rik9O+QjfE5l6bf/OkuqCJZN9it8Tqfwj7EtzFa3IDOWhlF2mTVwlD3v8HKNB
         nPqaPYnus7ihOARl3IJP7D3inkYiaDCKIOIqfW1pTRoKx3xwZslkXUM7Kkw0VLonyr0b
         v3C+Z5BUtBWnvRgUcAgyYu2ioVlduMEhWHVaf/ZDClAasV5c6rMEx1357mineTc62AuY
         3s6HKt30tESq8wHV4Qd2Uh3djNBBB9QBhxhYukNRwzgkOsq1yCMaz5P/PZRMvui/85dB
         knpRvHQVCc+x/zVZkCWvkSqaBUoRpyyla4FxYrDXzVIHcfztgNBhWlMsGJuYaQWPidSn
         X2ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ylil1kH8ULfeMONK9EVQ0jpuT/tHZ2Z7F3bsoKK5hxY=;
        fh=mTP6TkWV1IhQRgyhsEpYqIpiXvhDlZKdHAfNRdOTDjk=;
        b=jeKPV9BZ45PDUbsFY4thd0UUGV8tc9mYR2mUHke+fENcvOshLP6ITJUiq+OrXQgApt
         Jp9VaHTGZdSVJ4ZqOlzcpz+wnn9o8v3/ScEug/xc5H8W+NdsK8PIrWEVNunEcUAI+oiv
         CmMAFzYQi/SRLVRFG64R8GlaeCjPf8YnqKWM+7USSzJIpREaz7cFowUJl9+xdff/mZbq
         wg1re9h2Px17PtQ85ApKseb+iJaxsr3UHXuoxAzW8TIwNu5RcGoNCpThxf7o70gibzpM
         4a1IvBj35kRdFBSh0+J/ikHJbddxXEmVrBix5QVs5HSP5PKXfnEZI5GDiy2qhOZJAUdb
         yS3w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782321941; x=1782926741; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ylil1kH8ULfeMONK9EVQ0jpuT/tHZ2Z7F3bsoKK5hxY=;
        b=EXtAyqq3Uo2Z54FWnPuXYVOJe7csEcRUAZhiuMhy5FLdUiM/jW0Al3layJlRcJrCLr
         0kDToWxgwHS1yiBwx1LmfAom0pWcbgCGXFRjapODeLwgdssSl59pVAlBOrmXVA7ySx5O
         o2G5fjVcCCugdQC7othMOYszwuePi+ALD5yiRvLvvhInSiy+c7mGh08xDDEnn7gDNFf0
         qGxpBEGqT2CofKn21j8mKgNssSUVg34xoUKtUpEPGug+v+Fau/p7LN3j0barXrCLbqVM
         B5g1MeZdufvImUEyqvjJjdBRM2SZw/uKxZThM9FPZgoy5EasMkCHlHkC6P9nOa7naBhl
         KTyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782321941; x=1782926741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ylil1kH8ULfeMONK9EVQ0jpuT/tHZ2Z7F3bsoKK5hxY=;
        b=aNDa8Sj4t6hlWQSG6CUwKbkjKfWxx+j5KKxu3fBKSpUnfEOALOEcBtV/bvK7j/pQ86
         tBLpVgEya2kBA3IUW7CdaKONUfPo9rZfStd2LhvY/vVRdAVZ4InxB+7+5XpxD99pwKcH
         YyuUhpwr6E4IE+MurXqMiLxEabLLzFV0NqOxHr1tQW52ASKxvcTUfTBi8Ek38CpiRJUr
         KJlkG4p3F38IHkoaWWFt0Rs4r8b8eL8mUP4EHSCYZc7hwi1w0mGte0s+L13BBl6fmlpG
         rnpxIpGeqcV/a78fyWd4PffdiYvQats+eHW4ERNB69LT17OFogpuoAHAouPOrADuo47g
         0rFw==
X-Gm-Message-State: AOJu0YymIJto/8kdJPCMGV9RAVFV3up6AiVL6bHLUAeMD1ru1v4fCWUu
	fucmn1IadS2yAdb0DHEhr71z2hTTNik4n8z5bZ0u0JC6jx1KJBnbS0k1/RWQl9qgJg5Y+3P8WXt
	ZZB044D3twPod67TAF+oVuZ7c4KBfcPoQ9V+uRiS46Q==
X-Gm-Gg: AfdE7ck/w6XD76pbdhUm+0u7l4OciA8zGS1sh+f+/nb+LCy0ktYB8PZsdMNnLASpcim
	t+/GMQdk496EPIG6CYFk6KVKzGswCPyJCDu776+8RMaNrxaMjDdyBzvj2U0/SU9P5yvNxOtVBDr
	qPxqCh2TXL13PvJ2Y7ZAV6Gm1Mh231P0pJyfNP9rXY6oTC1GbiCcDUXs+HQ/QyqCsnIiyZlEhAv
	F9ck0OP3zIQD6L2sbuLkzoNWavdK+stv4xfhlp6u4DBf3e0RB3AjC+/ZXGtz14bIZY+RlTZ8JL8
	8TfMVSoralrUpapHIoPRMTNaFaniXAkeF7psjX2rHaWYT46JNEWC7JwO1ouNYzAgmoswlEF8wSA
	0V7VllJx3+5SH
X-Received: by 2002:a17:902:ec88:b0:2b7:aa20:3c61 with SMTP id
 d9443c01a7336-2c7c7724fedmr90657185ad.33.1782321941003; Wed, 24 Jun 2026
 10:25:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624155452.211646-1-nishidafmly@gmail.com>
 <20260624155452.211646-2-nishidafmly@gmail.com> <20260624161624.12CC81F000E9@smtp.kernel.org>
In-Reply-To: <20260624161624.12CC81F000E9@smtp.kernel.org>
From: Hiroshi Nishida <nishidafmly@gmail.com>
Date: Wed, 24 Jun 2026 10:25:29 -0700
X-Gm-Features: AVVi8CdRZclWHH6Q8FyuThmyI_0HKCh5bG2NnxDlL83UnzvO6xAEuuog11b_vKY
Message-ID: <CAE1ksKSByKNH=F7BY+VWtycoRgchwCK-wiCoSb0ANaOMKw-kAA@mail.gmail.com>
Subject: Re: [PATCH 1/8] md: change chunk_sectors and stripe cache counts to
 unsigned int
To: sashiko-reviews@lists.linux.dev
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> [Medium] unsigned types don't enable right-shift optimization for variabl=
e divisions.

You're right -- the hot-path divisions go through
sector_div()/do_div() (already u32),
and sectors_per_chunk is a runtime value, so signedness changes no codegen.
The rationale is wrong and the change has no perf benefit, so I'll
drop this patch
from v2 rather than reword a claim that doesn't hold.

> [Low] unupdated %d specifiers for the now-unsigned fields.
Another reason to drop it -- avoids the %d/%u churn. (They don't warn
in a default
build, only under -Wformat-signedness, but they are inconsistent.)

 > [Critical, pre-existing] round_down/round_up with a non-power-of-two div=
isor.
Good catch, and independent of this series.
sectors_per_chunk =3D chunk_sectors * (raid_disks - max_degraded)
isn't a power of two whenever the data-disk count isn't (raid5 4-disk
-> 3 data),
and round_down/round_up are mask-based.
I'll send a separate fix switching to rounddown()/roundup() with a Fixes: t=
ag.

Thanks,

2026=E5=B9=B46=E6=9C=8824=E6=97=A5(=E6=B0=B4) 9:16 <sashiko-bot@kernel.org>=
:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
>
> New issues:
> - [Medium] The commit's core justification is false. Changing the types t=
o unsigned does not enable compiler right-shift optimizations for variable =
divisions.
> - [Low] Unupdated printf-style format specifiers passing unsigned fields =
to '%d' cause compiler warnings (-Wformat) and break builds configured with=
 -Werror.
>
> Pre-existing issues:
> - [Critical] The macro `round_down` is incorrectly used with a non-power-=
of-two divisor, causing silent data corruption in bitmap sector calculation=
s.
> --
>
> commit 86528a8b22367a5ee16a7cb19a1d56bf58f6aa67
> Author: Hiroshi Nishida <nishidafmly@gmail.com>
>
> md: change chunk_sectors and stripe cache counts to unsigned int
>
> This commit changes several structural fields and local variables like
> chunk_sectors and max_nr_stripes from signed to unsigned int. The stated
> rationale is to prevent negative values and enable right-shift compiler
> optimizations for power-of-two division in the hot I/O path.
>
> >     chunk_sectors, new_chunk_sectors, prev_chunk_sectors, max_nr_stripe=
s,
> >     and min_nr_stripes are never negative. Using signed int is semantic=
ally
> >     wrong and prevents the compiler from optimizing division/modulo by
> >     power-of-two chunk sizes to right shifts in the hot I/O path.
>
> [Severity: Medium]
> Is this optimization rationale accurate? The hot I/O path uses sector_div=
(),
> which expands to do_div(). The do_div() macro explicitly casts the diviso=
r
> to a 32-bit unsigned integer, so the division was already operating on an
> unsigned value.
>
> Additionally, because sectors_per_chunk is a runtime variable rather than=
 a
> compile-time constant, would the compiler be able to optimize it into a
> right shift without a conditional branch?
>
> > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > index d8daf0f75cbbe..b9ad26844799d 100644
> > --- a/drivers/md/md.h
> > +++ b/drivers/md/md.h
> [ ... ]
> > @@ -437,7 +437,7 @@ struct mddev {
> >       int                             external;       /* metadata is
> >                                                        * managed extern=
ally */
> >       char                            metadata_type[17]; /* externally =
set*/
> > -     int                             chunk_sectors;
> > +     unsigned int                    chunk_sectors;
>
> [Severity: Low]
> Does changing this field to unsigned int cause compiler warnings with
> existing format strings?
>
> For example, chunk_size_show() in drivers/md/md.c appears to use %d to
> format mddev->chunk_sectors:
>
> chunk_size_show() {
>     ...
>     return sprintf(page, "%d (%d)\n",
>                    mddev->new_chunk_sectors << 9,
>                    mddev->chunk_sectors << 9);
> }
>
> Will this break builds configured with -Werror?
>
> > diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> > index cb5feae04db27..5cd9d0f36b6e0 100644
> > --- a/drivers/md/raid5.h
> > +++ b/drivers/md/raid5.h
> [ ... ]
> > @@ -572,12 +572,12 @@ struct r5conf {
> >       /* only protect corresponding hash list and inactive_list */
> >       spinlock_t              hash_locks[NR_STRIPE_HASH_LOCKS];
> >       struct mddev            *mddev;
> > -     int                     chunk_sectors;
> > +     unsigned int            chunk_sectors;
> >       int                     level, algorithm, rmw_level;
> >       int                     max_degraded;
> >       int                     raid_disks;
> > -     int                     max_nr_stripes;
> > -     int                     min_nr_stripes;
> > +     unsigned int            max_nr_stripes;
> > +     unsigned int            min_nr_stripes;
>
> [Severity: Low]
> Will the changes to min_nr_stripes and max_nr_stripes also trigger format
> warnings?
>
> Places like raid5_end_read_request() and raid5_set_cache_size() still use
> %d to print these fields. For instance, in raid5_set_cache_size():
>
> pr_err("md/raid:%s: Cannot increase cache size, ret=3D%d, new_size=3D%d, =
min_nr_stripes=3D%d, max_nr_stripes=3D%d\n",
>        ...
>        conf->min_nr_stripes,
>        conf->max_nr_stripes);
>
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 0c5c9fb0606ee..28828e083c2b3 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> [ ... ]
> > @@ -2970,7 +2970,7 @@ sector_t raid5_compute_sector(struct r5conf *conf=
, sector_t r_sector,
> >       sector_t new_sector;
> >       int algorithm =3D previous ? conf->prev_algo
> >                                : conf->algorithm;
> > -     int sectors_per_chunk =3D previous ? conf->prev_chunk_sectors
> > +     unsigned int sectors_per_chunk =3D previous ? conf->prev_chunk_se=
ctors
> >                                        : conf->chunk_sectors;
>
> [Severity: Critical]
> This is a pre-existing issue, but could the use of sectors_per_chunk
> cause problems when passed to rounding macros?
>
> Looking at raid5_bitmap_sector():
>
> raid5_bitmap_sector() {
>     ...
>     sectors_per_chunk =3D conf->chunk_sectors *
>         (conf->raid_disks - conf->max_degraded);
>     start =3D round_down(start, sectors_per_chunk);
>     end =3D round_up(end, sectors_per_chunk);
>     ...
> }
>
> The round_down() and round_up() macros are designed specifically for
> power-of-two divisors. If the number of data disks is not a power of two,
> sectors_per_chunk will not be a power of two, which would yield incorrect
> sector boundaries.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624155452.21=
1646-1-nishidafmly@gmail.com?part=3D1



--=20
Hiroshi Nishida
nishidafmly@gmail.com
