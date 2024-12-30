Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8085EA59
	for <linux-raid@vger.kernel.org>; Mon, 30 Dec 2024 05:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735534884; cv=none; b=L10fzDSPB80LuTppjwMJpvjUW9/w4m7heaeDUTgy0uyaIRtB5/IyBC2AyxoF3PUvKDsJ9Cyfx+Uli/0CvxLvXD24KS+rmSqmbxKPSUJRb4ADMba0MbU/rvCQGsYP/RDdzKhvVHLyRNbPf5vGAbEOx37+3ieJsfkub5fE/29ttpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735534884; c=relaxed/simple;
	bh=KAusN3QSR441hKuYF91AGIngLxcknWb00m4BKOH6lBE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aJgJqzOrrjjX6caMOxq4iGndCL98oPaXBq+mEPd4sg2rPR37ggp8rTukwIxLkIkTcv+/TXgcjenj/hL8DOPjwaKvzcbtnYzxDSOY39gC+A3oGDplh++va7USRVVyKklwk5XsJfOQf6pXo+RqmI5iJLeSbeYsOKRLlwB1JG1FkTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hNAOguFH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hNAOguFH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735534881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EufIudNRTA85PI/AVDKx6P/EWGxk2WoTvrCUtmxr1qA=;
	b=hNAOguFHxcbLUAMapn+Lg1DQIrJ/Lq/LAFpLfSQ92JrzCUwjbiFQoi92Pctnw/VBiRBwiJ
	g0yTtnK25ZFaONVRDv+HznGHIQ4gBoRFcvZMHrRcHT8y2GOnKvoHfqOMC4An9QyVYIjWMz
	UktDWAyAEbFSl51lnMRD78KMW7GvdYY=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-sj4Q6ZGBM2uRripneBV3TQ-1; Mon, 30 Dec 2024 00:01:19 -0500
X-MC-Unique: sj4Q6ZGBM2uRripneBV3TQ-1
X-Mimecast-MFC-AGG-ID: sj4Q6ZGBM2uRripneBV3TQ
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-3022741859eso51890331fa.2
        for <linux-raid@vger.kernel.org>; Sun, 29 Dec 2024 21:01:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735534878; x=1736139678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EufIudNRTA85PI/AVDKx6P/EWGxk2WoTvrCUtmxr1qA=;
        b=GuZYzrNpkVweHBmPEkP0EF1bL5DPPBYeczyEmfzXVErJR+5+QO9I+WsV8OdqzfXfMG
         qk6f+ncst8MlPQp4vHTKfLnjeSg8nYzEVAAk+YAx5VgEE9P+hEupNdSfhUpak0Aas2Js
         lNmcjig+P117MZTEVvJzOY9ccS/whFWlTTiJcT7cCgR7uR5n7hdJobDDEXtkUt3rxoQy
         KwzE2579/KMUdzAvu9UhWnZWeZZbppuLURo5SbHkNpuW4dBJKdQvarlU3hObCoGROOiE
         czjpDQgTyEMtRmjX3tU9ukAouao5hyYa/2qzdP66szBL6EjNMwFaBoj0cxBaB+R6Lc7+
         SxYg==
X-Forwarded-Encrypted: i=1; AJvYcCV9WYu6SIYeVv8EKcd65gqaam5tl2OB1dJ4I/b9sWWRUqtVRQf7hlmsvzpl+vYRUJE2P1K54ehbiIqJ@vger.kernel.org
X-Gm-Message-State: AOJu0YzShaig5aQYefZWKX8Pp4r70nfp/eC2bPuMm7SUNGB/o1F/WZs9
	nJeSVB4C51QMbViJ8QcDsLwX/Okl3V7s01TQOD3H0E/DI5UHPB6mjhprriU73YDH7vLHRCA2t/8
	VNwg6SlHE9pE0DJ8gpwqv0JWl4UKL1hCXLMH/ba4X2tqn6XCgp/bxYNUyYrr8yXlWDsPzkfTukD
	Qr2sHkmtbm2QB/GLU39FwfmMQenpNGuTKU4Q==
X-Gm-Gg: ASbGncseWetKtDK9Owzed7D/hbAT9fPp4KnQvhr9glhcBIwC4QReJ12UnhdFGoOEkPu
	T606Nz7jOW4ixPplrFiNOWksCY3qi8nY8I3YRMPM=
X-Received: by 2002:a05:6512:3f1a:b0:542:1bdd:748d with SMTP id 2adb3069b0e04-542295328eamr9354504e87.13.1735534878121;
        Sun, 29 Dec 2024 21:01:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IElhHuUFezVnfYJewVzM1aVKPMniJOMLC2I69ml4rDfaNeVk9CgwllRFPu1/guIjA/XDWAM6CGDwlbCXWohC+0=
X-Received: by 2002:a05:6512:3f1a:b0:542:1bdd:748d with SMTP id
 2adb3069b0e04-542295328eamr9354496e87.13.1735534877703; Sun, 29 Dec 2024
 21:01:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241218121745.2459-1-yukuai@kernel.org> <20241218121745.2459-3-yukuai@kernel.org>
 <CALTww2-nXW5Uv=+z0LHPvSkJMs7bTqoiWOE+8bKJrpf6XEB1-g@mail.gmail.com> <6decfd12-111b-3eca-e781-9b4dbbdfda98@huaweicloud.com>
In-Reply-To: <6decfd12-111b-3eca-e781-9b4dbbdfda98@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 30 Dec 2024 13:01:05 +0800
Message-ID: <CALTww29Y0jUGZBAaKVTDYQWRYAs_MxtriR7WjmDcxVqO77KRSQ@mail.gmail.com>
Subject: Re: [PATCH v2 md-6.14 2/5] md/md-bitmap: remove the last parameter
 for bimtap_ops->endwrite()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: yukuai@kernel.org, song@kernel.org, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@hauwei.com, yangerkun@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 23, 2024 at 3:50=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/12/23 15:31, Xiao Ni =E5=86=99=E9=81=93:
> > On Wed, Dec 18, 2024 at 8:21=E2=80=AFPM <yukuai@kernel.org> wrote:
> >>
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> It is useless, because for the case IO failed for one rdev:
> >>
> >> - If badblocks is set and rdev is not faulty, there is no need to
> >>   mark the bit as NEEDED;
> >
> >
> > Hi Kuai
> >
> > It's better to add some comments before here. Before this patch, it's
> > easy to understand. It needs to set bitmap bit when a write request
> > fails.

Hi Kuai

>
> This is not accurate, it's doesn't matter if IO fails or succeed, bit
> must be set if data is not consistent, either IO is not done yet, or the
> array is degaraded.

Sorry for the wrong words. I want to say bitmap NEEDED bit is set when
a write request fails. After this patch, we can't see the logic
directly. So it's a hidden logic. It's better to add more comments
here for future maintenance.

And I read the codes, R1BIO_Degraded, STRIPE_DEGRADED,
R10BIO_Degraded, these three flags are only used to tell bitmap if it
needs to set NEEDED bit. After this patch, it looks like these flags
are not useful anymore.

>
> > With this patch, there are some hidden logics here. To me, it's
> > not easy to maintain in the future. And in man mdadm, there is no-bbl
> > option, so it looks like an array may not have a bad block. And I
> > don't know how dmraid maintain badblock. So this patch needs to be
> > more careful.
>
> no-bbl is one of the option of mdadm --update, I think it means remove
> current badblock entries, not that disable badblocks.
>
> In kernel, badblocks is always enabled by default, and IO error will
> always try to set badblocks first. For example:
>
>   - badblocks_init() is called from md_rdev_init(), and if
> badblocks_init() fails, the array can't be assembled.
>   - The only thing stop rdev to record badblocks after IO failure is that
> rdev is faulty.

Yes, thanks for pointing out this.
>
> Thanks,
> Kuai
>
> >
> > Regards
> > Xiao
> >
> >> - If rdev is faulty, then mddev->degraded will be set, and we can use
> >> it to mard the bit as NEEDED;
> >>
> >> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> >> Signed-off-by: Yu Kuai <yukuai@kernel.org>
> >> ---
> >>   drivers/md/md-bitmap.c   | 19 ++++++++++---------
> >>   drivers/md/md-bitmap.h   |  2 +-
> >>   drivers/md/raid1.c       |  3 +--
> >>   drivers/md/raid10.c      |  3 +--
> >>   drivers/md/raid5-cache.c |  3 +--
> >>   drivers/md/raid5.c       |  9 +++------
> >>   6 files changed, 17 insertions(+), 22 deletions(-)
> >>
> >> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
> >> index 84fb4cc67d5e..b40a84b01085 100644
> >> --- a/drivers/md/md-bitmap.c
> >> +++ b/drivers/md/md-bitmap.c
> >> @@ -1726,7 +1726,7 @@ static int bitmap_startwrite(struct mddev *mddev=
, sector_t offset,
> >>   }
> >>
> >>   static void bitmap_endwrite(struct mddev *mddev, sector_t offset,
> >> -                           unsigned long sectors, bool success)
> >> +                           unsigned long sectors)
> >>   {
> >>          struct bitmap *bitmap =3D mddev->bitmap;
> >>
> >> @@ -1745,15 +1745,16 @@ static void bitmap_endwrite(struct mddev *mdde=
v, sector_t offset,
> >>                          return;
> >>                  }
> >>
> >> -               if (success && !bitmap->mddev->degraded &&
> >> -                   bitmap->events_cleared < bitmap->mddev->events) {
> >> -                       bitmap->events_cleared =3D bitmap->mddev->even=
ts;
> >> -                       bitmap->need_sync =3D 1;
> >> -                       sysfs_notify_dirent_safe(bitmap->sysfs_can_cle=
ar);
> >> -               }
> >> -
> >> -               if (!success && !NEEDED(*bmc))
> >> +               if (!bitmap->mddev->degraded) {
> >> +                       if (bitmap->events_cleared < bitmap->mddev->ev=
ents) {
> >> +                               bitmap->events_cleared =3D bitmap->mdd=
ev->events;
> >> +                               bitmap->need_sync =3D 1;
> >> +                               sysfs_notify_dirent_safe(
> >> +                                               bitmap->sysfs_can_clea=
r);
> >> +                       }
> >> +               } else if (!NEEDED(*bmc)) {
> >>                          *bmc |=3D NEEDED_MASK;
> >> +               }
> >>
> >>                  if (COUNTER(*bmc) =3D=3D COUNTER_MAX)
> >>                          wake_up(&bitmap->overflow_wait);
> >> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
> >> index e87a1f493d3c..31c93019c76b 100644
> >> --- a/drivers/md/md-bitmap.h
> >> +++ b/drivers/md/md-bitmap.h
> >> @@ -92,7 +92,7 @@ struct bitmap_operations {
> >>          int (*startwrite)(struct mddev *mddev, sector_t offset,
> >>                            unsigned long sectors);
> >>          void (*endwrite)(struct mddev *mddev, sector_t offset,
> >> -                        unsigned long sectors, bool success);
> >> +                        unsigned long sectors);
> >>          bool (*start_sync)(struct mddev *mddev, sector_t offset,
> >>                             sector_t *blocks, bool degraded);
> >>          void (*end_sync)(struct mddev *mddev, sector_t offset, sector=
_t *blocks);
> >> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> >> index 15ba7a001f30..81dff2cea0db 100644
> >> --- a/drivers/md/raid1.c
> >> +++ b/drivers/md/raid1.c
> >> @@ -423,8 +423,7 @@ static void close_write(struct r1bio *r1_bio)
> >>          if (test_bit(R1BIO_BehindIO, &r1_bio->state))
> >>                  mddev->bitmap_ops->end_behind_write(mddev);
> >>          /* clear the bitmap if all writes complete successfully */
> >> -       mddev->bitmap_ops->endwrite(mddev, r1_bio->sector, r1_bio->sec=
tors,
> >> -                                   !test_bit(R1BIO_Degraded, &r1_bio-=
>state));
> >> +       mddev->bitmap_ops->endwrite(mddev, r1_bio->sector, r1_bio->sec=
tors);
> >>          md_write_end(mddev);
> >>   }
> >>
> >> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> >> index c3a93b2a26a6..3dc0170125b2 100644
> >> --- a/drivers/md/raid10.c
> >> +++ b/drivers/md/raid10.c
> >> @@ -429,8 +429,7 @@ static void close_write(struct r10bio *r10_bio)
> >>          struct mddev *mddev =3D r10_bio->mddev;
> >>
> >>          /* clear the bitmap if all writes complete successfully */
> >> -       mddev->bitmap_ops->endwrite(mddev, r10_bio->sector, r10_bio->s=
ectors,
> >> -                                   !test_bit(R10BIO_Degraded, &r10_bi=
o->state));
> >> +       mddev->bitmap_ops->endwrite(mddev, r10_bio->sector, r10_bio->s=
ectors);
> >>          md_write_end(mddev);
> >>   }
> >>
> >> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> >> index 4c7ecdd5c1f3..ba4f9577c737 100644
> >> --- a/drivers/md/raid5-cache.c
> >> +++ b/drivers/md/raid5-cache.c
> >> @@ -314,8 +314,7 @@ void r5c_handle_cached_data_endio(struct r5conf *c=
onf,
> >>                          set_bit(R5_UPTODATE, &sh->dev[i].flags);
> >>                          r5c_return_dev_pending_writes(conf, &sh->dev[=
i]);
> >>                          conf->mddev->bitmap_ops->endwrite(conf->mddev=
,
> >> -                                       sh->sector, RAID5_STRIPE_SECTO=
RS(conf),
> >> -                                       !test_bit(STRIPE_DEGRADED, &sh=
->state));
> >> +                                       sh->sector, RAID5_STRIPE_SECTO=
RS(conf));
> >>                  }
> >>          }
> >>   }
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index 93cc7e252dd4..6eb2841ce28c 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >> @@ -3664,8 +3664,7 @@ handle_failed_stripe(struct r5conf *conf, struct=
 stripe_head *sh,
> >>                  }
> >>                  if (bitmap_end)
> >>                          conf->mddev->bitmap_ops->endwrite(conf->mddev=
,
> >> -                                       sh->sector, RAID5_STRIPE_SECTO=
RS(conf),
> >> -                                       false);
> >> +                                       sh->sector, RAID5_STRIPE_SECTO=
RS(conf));
> >>                  bitmap_end =3D 0;
> >>                  /* and fail all 'written' */
> >>                  bi =3D sh->dev[i].written;
> >> @@ -3711,8 +3710,7 @@ handle_failed_stripe(struct r5conf *conf, struct=
 stripe_head *sh,
> >>                  }
> >>                  if (bitmap_end)
> >>                          conf->mddev->bitmap_ops->endwrite(conf->mddev=
,
> >> -                                       sh->sector, RAID5_STRIPE_SECTO=
RS(conf),
> >> -                                       false);
> >> +                                       sh->sector, RAID5_STRIPE_SECTO=
RS(conf));
> >>                  /* If we were in the middle of a write the parity blo=
ck might
> >>                   * still be locked - so just clear all R5_LOCKED flag=
s
> >>                   */
> >> @@ -4062,8 +4060,7 @@ static void handle_stripe_clean_event(struct r5c=
onf *conf,
> >>                                          wbi =3D wbi2;
> >>                                  }
> >>                                  conf->mddev->bitmap_ops->endwrite(con=
f->mddev,
> >> -                                       sh->sector, RAID5_STRIPE_SECTO=
RS(conf),
> >> -                                       !test_bit(STRIPE_DEGRADED, &sh=
->state));
> >> +                                       sh->sector, RAID5_STRIPE_SECTO=
RS(conf));
> >>                                  if (head_sh->batch_head) {
> >>                                          sh =3D list_first_entry(&sh->=
batch_list,
> >>                                                                struct =
stripe_head,
> >> --
> >> 2.43.0
> >>
> >>
> >
> >
> > .
> >
>

