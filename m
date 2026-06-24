Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327561DED40
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 17:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782321199; cv=pass; b=FDYzFwcFV7ht/mhLRSHQyFOXEd8be7uiY4XrZaFnVgCpnUaqztqg62E/+cDUJb8mcZfz9YFwUEoYj5hmNg/AqhsMAzee73N0smu/Hbckse7ws+KwzYZaECb+Eu8+sPxx3haPkiOT8vwFfiv3bwlHXzjXBWK1CEImghM6a00IRxI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782321199; c=relaxed/simple;
	bh=M+qWvplBCfNcYUYxb18e9U3vILZNPA0XupfsmVtyyio=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LgsQ6LjrMjbYNnKHgmj0CBYvAqg8OVIo8r/hpiaSM9qIXpdssk8HcjWyKmnZWr6nV+s5/dV5D/pSkC0ozm0Cf/lErOr8EQ5xGWUkyCxA2aU75aDBwI4ddKEA5wxYfW/35enAvMUtPE1iMnkKm/cK5TDWVkzD7+G0i+0oTZugIbQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kf0aoEWV; arc=pass smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kf0aoEWV"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2c7e8eea816so318135ad.1
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 10:13:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782321197; cv=none;
        d=google.com; s=arc-20260327;
        b=sz4s9dduGKXsWJ1aOTSX96g2HNKeNfTDNLE7lxDWABIkgJ6t2hrrCd2ydtPcGMOtn2
         pKogrfKL9uUsuxA8d0d9RF2wAqk4FyEREXh7B4dJAFBj6Zg1SJ4MWPtCVKnYKDaq1faR
         n64gCQU63y9dhCFDT5RjdPzm9SJLB42Mzg1pjOnaI+vALB9s3uILOc3EudDq0djZ6exa
         +hx4qTJ3t2R04VdynHO2tWpDHmqwHxIQC98qhFFBFIVTYmfKz/Fe/JEzGOxfcCMfFDUc
         9Dmbam3B6DgUvwVCrwoFbTQyS4vDeViZnnbmyI4DcWGNJuda5NCYkOApK4AVwQBRn6Jg
         jRYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gPujeRuuTxJJkg1/xr5Q6pxPlOf/lNNbV1Cb9sjSGUw=;
        fh=mTP6TkWV1IhQRgyhsEpYqIpiXvhDlZKdHAfNRdOTDjk=;
        b=GuiGmrIGX+ybif99E7NLfI9s/y7JrbXiKZV5LiPnjkVr5uXBSvzn10xzoBDwIPh1l6
         xOfxTDJc2fPhfdOld8NN4XwkCxUrgcBG8eXgutV+ITqfDcyD7abp0LkML6X5JVc711FC
         3lvAqVLDsrOqaVf+4zSQMfCce7I8YGCpAxbrs9IpElYq8TaTEkQOkEulUaHtso4dxasY
         G2UqIiusl0hRpHvXEp5tVrubQqwsinkcarGgohwof2ytTZsuOzFhT6VvzwcSzNwh5qLA
         cGAfjQvz5p9t/SdDGDXpS97IT1DTrnKU/ZmVeCT62p+dbbA/pcxFr/U1tG8NQ9RFDlc9
         zAKg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782321197; x=1782925997; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gPujeRuuTxJJkg1/xr5Q6pxPlOf/lNNbV1Cb9sjSGUw=;
        b=kf0aoEWVJc9jCLWsF7YrsS3vsfeVWRHUnckwdEVOBjcpn2BjpOw1Gvy4GlWBH2XjX6
         j08acWk3TCG0oEfyRruM+Tvw3OSOT+tEFTQIHSJw9ZdFmNFD1pKGp1nmZZerhorfrQMB
         8bs12aWivFeySU2wchLfX5qEt5oUHUddFpnIzow8DUsgXuwV5z7Zeq5ffn97ooAQCcMr
         lOvjmTDm+5Il4uhc+VxJd9MwpjOBTjT39Ro6m3PGIVIvGKi4O1AN4fuz4CnXPHIPzJHK
         lukS4I8mYbyiw3DwSyXi2R55CbMmSLjC2mtn61QvklrWqi/T9H8DS5n11C+cVabNigf/
         7zzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782321197; x=1782925997;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gPujeRuuTxJJkg1/xr5Q6pxPlOf/lNNbV1Cb9sjSGUw=;
        b=VihtRWLaiFKJveX8hPgjjMhhaOopmtligE0zEQ1Ll6kZOOMUWA3sP4AKpSlmepIwvo
         hDnYFLlqvRDiGk2GnNnDpsn65lLIwmo2RiSctpa5+ohlLRIwloKI4qy8WWgPpPjNFq0Z
         8drnLx3L/B2KMbovqHu5bqODW+BiJBdzj7dU3tOg6paBv6CVfXJN0jrgQ50n/Sl6ora5
         6Xfypt95RKU9eTH6vEi/lhFb1yaSn7k/9xZ85vXlzMUF/lj2EHoPcjxxtf+otqA8qgbj
         0WF24PExtZp/MATi4HiDDCagdYCfnLElDk9M1ah8pjiJGA5AGsw4QxHYAe8kkT8Y1MY6
         lvwQ==
X-Gm-Message-State: AOJu0YzKSlFa7eXteZvOhPKNyUkCKJZlxr0n6Ud5/QmPOk3hNe68lHC6
	+5i+J+rUW3vzB+F6XVQFg0rsGhiUWOd0sawDf+ZC1KMHa6M3aJ6DixemzTfF8jCADrgYfy+VcnG
	zGbJjtcsD8Or62lhV6CRSyDOL+mTZPBs=
X-Gm-Gg: AfdE7ckua9w9/CdUtEkWzh7g0Wqb30Nvzgfz7H+cUVpum+VKH/pJzHktIzAiu5H+BoA
	sKM1EPnEmlL7+o+z3+kYxmKlana5l1t7LcVlA9J0xtdoq9H94flrBrU/KLAY4FrFXyl+SzDuRX2
	AySdXqQ3iK4S5d0sMyJP/Y/qsPLO+VYIsNOv460n+xL2kTFOgPwOl3ePpABLMNC4TJ/v55CKIh7
	FECF2f4vkgakzTeunFux65cnAAeayjSn45XY96FhKOfTQAiSgkfkLixM/VtoGKnPQObFJnoZtLK
	zJOjdx9pvzXmwHB7JgsCyERQbUcAkqkrMeg/p4hm5i4shqTU5OGrODGndOWbJYfB45OjMiNfiKy
	Y5zrJwPyeT/6q
X-Received: by 2002:a17:903:8c5:b0:2bd:3c21:a053 with SMTP id
 d9443c01a7336-2c7c3ff8e32mr74153345ad.24.1782321197437; Wed, 24 Jun 2026
 10:13:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624155452.211646-1-nishidafmly@gmail.com>
 <20260624155452.211646-6-nishidafmly@gmail.com> <20260624161238.6813B1F000E9@smtp.kernel.org>
In-Reply-To: <20260624161238.6813B1F000E9@smtp.kernel.org>
From: Hiroshi Nishida <nishidafmly@gmail.com>
Date: Wed, 24 Jun 2026 10:13:06 -0700
X-Gm-Features: AVVi8Cd-I-K9Emy_--RjqAi-F2e80vtRrtAAnC_s1NYaq--6GifSG0NkgPsXSuk
Message-ID: <CAE1ksKQi2WibOMxR1wwceqJXw4CLd1FHvuAuKTbqMBWHnuf0Pg@mail.gmail.com>
Subject: Re: [PATCH 5/8] md/raid5: submit a window of stripes during resync/recovery
To: sashiko-reviews@lists.linux.dev
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> [High] TOCTOU on still_degraded: the degraded check was moved before the
> blocking stripe get + schedule_timeout, so a drive failing during the sle=
ep
> leaves a stale still_degraded that can wrongly clear the NEEDED bit.

Agreed -- this is a real regression I introduced.
I hoisted the still_degraded computation so the window could reuse it,
but that placed it before the blocking get and the
schedule_timeout_uninterruptible(1),
whereas stock computes it after.
In v2 I'll move the still_degraded computation back below the blocking
get of the first stripe (restoring stock's ordering).
The remaining window stripes are fetched with R5_GAS_NOBLOCK and don't
sleep, so they can reuse that
value without reopening the race across a sleep.

  > [High] The batch loop ignores md_bitmap_start_sync()'s return and
force-syncs
  > clean stripes in the window.

Also correct.
Stock makes the skip decision once at the top
(!md_bitmap_start_sync(..., true) && sync_blocks >=3D ...),
but the window loop doesn't, so a clean bitmap region the window
crosses gets synced unnecessarily.
In v2 I'll have the window honor the bitmap and stop at the boundary of the
dirty region being resynced, rather than extending into already-in-sync str=
ipes.

Both are correctness details the per-stripe path got right and my
batching dropped;
I'll fold the fixes into v2 and re-test the bitmap resync path.

Thanks,

2026=E5=B9=B46=E6=9C=8824=E6=97=A5(=E6=B0=B4) 9:12 <sashiko-bot@kernel.org>=
:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [High] The batch loop ignores the return value of md_bitmap_start_sync(=
), forcing clean stripes to be unnecessarily synchronized.
> - [High] Time-of-check to time-of-use race on the array's degraded state,=
 leading to silent data corruption via incorrect bitmap updates.
> --
>
> commit 01d1e80ee6aa253c48c233e7fc218fbdac9522fa
> Author: Hiroshi Nishida <nishidafmly@gmail.com>
>
> md/raid5: submit a window of stripes during resync/recovery
>
> This commit alters raid5_sync_request() to dispatch up to 32 stripes per
> call instead of one. It attempts to submit the remaining stripes in the
> window with a non-blocking flag to avoid the per-stripe throttle sleep.
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 9cb4ed3bd85c5..8e9edaaca667b 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6620,16 +6621,7 @@ static inline sector_t raid5_sync_request(...)
> [ ... ]
> > -     sh =3D raid5_get_active_stripe(conf, NULL, sector_nr,
> > -                                  R5_GAS_NOBLOCK);
> > -     if (sh =3D=3D NULL) {
> > -             sh =3D raid5_get_active_stripe(conf, NULL, sector_nr, 0);
> > -             /* make sure we don't swamp the stripe cache if someone e=
lse
> > -              * is trying to get access
> > -              */
> > -             schedule_timeout_uninterruptible(1);
> > -     }
> > -     /* Need to check if array will still be degraded after recovery/r=
esync
> > +     /* Check once whether array will still be degraded after recovery=
/resync.
> >        * Note in case of > 1 drive failures it's possible we're rebuild=
ing
> >        * one drive while leaving another faulty drive in array.
> >        */
> > @@ -6640,13 +6632,42 @@ static inline sector_t raid5_sync_request(...)
> >                       still_degraded =3D true;
> >       }
> >
> > +     /* First stripe: block if stripe cache is full, then throttle. */
> > +     sh =3D raid5_get_active_stripe(conf, NULL, sector_nr, R5_GAS_NOBL=
OCK);
> > +     if (sh =3D=3D NULL) {
> > +             sh =3D raid5_get_active_stripe(conf, NULL, sector_nr, 0);
> > +             /* make sure we don't swamp the stripe cache if someone e=
lse
> > +              * is trying to get access
> > +              */
> > +             schedule_timeout_uninterruptible(1);
> > +     }
>
> [Severity: High]
> Does moving the degraded check before the stripe allocation introduce a
> time-of-check to time-of-use race?
>
> If a drive fails during the potential sleep in raid5_get_active_stripe() =
or
> schedule_timeout_uninterruptible(), the stale still_degraded value is use=
d
> below to update the bitmap. This could incorrectly clear the NEEDED bit,
> potentially leaving parity inconsistent if the system crashes before the =
sync
> completes.
>
> >       md_bitmap_start_sync(mddev, sector_nr, &sync_blocks, still_degrad=
ed);
> >       set_bit(STRIPE_SYNC_REQUESTED, &sh->state);
> >       set_bit(STRIPE_HANDLE, &sh->state);
>
> [ ... ]
>
> > +     win_sector =3D sector_nr + RAID5_STRIPE_SECTORS(conf);
> > +     for (submitted =3D 1;
> > +          submitted < RAID5_SYNC_WINDOW && win_sector < max_sector &&
> > +          win_sector < mddev->resync_max;
> > +          submitted++, win_sector +=3D RAID5_STRIPE_SECTORS(conf)) {
> > +             sh =3D raid5_get_active_stripe(conf, NULL, win_sector,
> > +                                          R5_GAS_NOBLOCK);
> > +             if (!sh)
> > +                     break;
> > +             md_bitmap_start_sync(mddev, win_sector, &sync_blocks,
> > +                                  still_degraded);
> > +             set_bit(STRIPE_SYNC_REQUESTED, &sh->state);
> > +             set_bit(STRIPE_HANDLE, &sh->state);
>
> [Severity: High]
> Does this batch loop unnecessarily synchronize clean stripes?
>
> The boolean return value of md_bitmap_start_sync() is ignored here. If th=
e
> first stripe needs sync but subsequent stripes in the window are clean, t=
his
> loop unconditionally queues every stripe for synchronization regardless o=
f
> its clean/dirty state, forcing read-rebuild-write cycles on clean stripes=
.
>
> > +             raid5_release_stripe(sh);
> > +     }
> > +
> > +     return submitted * RAID5_STRIPE_SECTORS(conf);
> >  }
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624155452.21=
1646-1-nishidafmly@gmail.com?part=3D5



--=20
Hiroshi Nishida
nishidafmly@gmail.com
