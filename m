Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBD633BBD7
	for <linux-raid@vger.kernel.org>; Tue,  8 Sep 2026 04:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788842637; cv=pass; b=c1aWi2AEJ1s7tEP/XoMhVRmrYWcxhljWMzS1wEsWViH58eXkBwfpBO8h38nFaJwGNtvzdtjuVxVpoQQ7ETunRa9jjNE1VMVAq2iGYPAKlbbr0nNPVg0LwZ4ybTHg9RoaQrF3C+s8zsD3jT6IDyRu9Dn+dK0Hro84aZ+FGRotgmI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788842637; c=relaxed/simple;
	bh=8vsteFJKg7AwDfREPOwh3IZlj+5W2Opz5jTY9fZZN+A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZWENDb1A7RhmS5JE6k/Xk5JxXduK5CDfyp83RtXzc0hZqsMxPl1D/tzJ83xnpvxOvCJa5YsOSY9qGOYIlcTX8IXdrfrf+5uO+EN01qk28oY3+iI8uI7yj4ohU15bIkfRtGlUVoIA67HMl7b8iooUQ5QLxJKNeSKJFESBP8ESV08=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=B4J6m3B7; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="B4J6m3B7"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254c50ff6fso44810966b.2
        for <linux-raid@vger.kernel.org>; Mon, 07 Sep 2026 21:43:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788842632; cv=none;
        d=google.com; s=arc-20260327;
        b=ULl+5kBCcp6x99H0j8vc7m59YwgcA4g0PPQg6Nm9ZZkh8N89EUrLS4auBYMsWf3cpa
         HUtIhdDAEAEmYh0oG2FffYg/TuOdTU1EYK7wNXGtMplQNG0z4jnuOV2knbpIKm5JMsff
         FGyykdRCfVPsSt/W4jE8SKoS0eUYzOLcEfQUMOgvvGHvkjBwYP+lpyt+NNIAIQBJ11Ru
         6N9b8+iA5CwN2ZewEBJisBlxb0+dJhhLQcc05kAHSmtBXq3ecGJ4XAXXbXZ+tZEbba2A
         mgMaoMUcrqeUD6f6k+YrSTWs3i1njwwwo36mBFYtWZT+l86E8WtVKTQVXl7ZQnP/9lDv
         6Emg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DPxar+zPdGaJ5HhOGiKhNQM3J7uOCr+14/bCQzXtVzc=;
        fh=mTP6TkWV1IhQRgyhsEpYqIpiXvhDlZKdHAfNRdOTDjk=;
        b=M/wSzSiZFM6TXy2C7iBlstCpT2c0buKZxixdFvKX0NvQPhJuDFrMYZMxg/iWe3KfqU
         2RnLhGIwCIIyaJ58JxvCvBu2xrLw735wzZClFw2W/SnWjKJ7o33vlwh5ebvFaedmr5Eo
         WL63OP3oBMhCew3BC7hO0BtDeMLFIkBAZywOT/7hz4guooMi7kWRHF6ScRjmiCVGBiip
         QzifsJPFLPdTNdtf2+Y2MDnO5WyKBIHwMhdOePkmgBc96rOxPUVYxDCs4aFNxDFLsz7a
         gS/GwqpKza+vUVH4qHeGzpbLvuPTwqLCBXUJANYjf5LofXwjVxseeFlT7f8skFpfeuvb
         glrw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1788842632; x=1789447432; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DPxar+zPdGaJ5HhOGiKhNQM3J7uOCr+14/bCQzXtVzc=;
        b=B4J6m3B7qiZsUy70wdJfdsd5tJh53o8YGZOv8TVszkJONnLqIDthmnplqtJymRlD+U
         JTvkwKAYOQbnOMEPJr913s1Wb1ijkYb+3ypKVAuiiEEfJxhSj414RZ8sw+hVRWGkr1PD
         1+5tXaBtRkRjaiPX1u5d7hOilpu7Utx6Vw/JJytGsFhJ2FIm4DQj995x6xzUZgmZFS6n
         uAw4Y0EmDqX/oxzHsGa7PsSzCRAnV6t0ew9cLg5jkPSCygKCsPBfiVfTjmgK3POwtY41
         geU2lgzXxLlJsQNJh6+hNfAYeYyy8zG4VkVj80yJchHQQBf3F6Pl2ojOsh7IQfs9rA65
         AJ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788842632; x=1789447432;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DPxar+zPdGaJ5HhOGiKhNQM3J7uOCr+14/bCQzXtVzc=;
        b=mpObi7NLCt0XOHv9FpQ3l5lIm144IHJZ0ya3ZTdE9fAga87ekAPkNdosiV9oJJKApx
         kmDDNDLE7EOPmFxNk6Ca5+4EXMW7Gfb0wGhcPeQecd0vfgibA5cnJfDdJgaVQQSbPSc5
         i5CSsS0XgSlF9D8xgUWbOnFxetQdiouWl8bsTJJsp25piOWBif+VlpH2Q4xsMThatzMQ
         qFenVKysfHiDksQr5TfGM4IvUuYMOBeeOG5aq/wB9vQmEw9VndiqdObcBMFneGvh/fIj
         cx+TLsOZaevJ4jr+ZyI/zc53/IASBPck+72iTQFtSqI7fEXbJpuM5oZNSk5fueLJsJHJ
         3dVg==
X-Gm-Message-State: AFuF++kEtC20E/lwdIdiQR0HZJHQ6QQOxs48FVaI8lyGqPq9vknSltf0
	jeaKOVAG02Tql0XsMgDTnQctZqHlDM1EdOt9JyFqyXQXdzNfbNiOle6tbG8VVD/+G3uvZzitctV
	uLQDuqYYz3FWfD4CW86HC37OrUREi0d8P97nmK/plm2ZvI7sY4865Oig=
X-Gm-Gg: AYBFou1Bcmkell1DI5vGpB66PB5rUjMKCsrbNyWGa63Znwd3tzvZCEDXxca7Q/Pkx/5
	heXUIWCeuj3IQ3kY7Q6+4/p9H9FxJY/y9DtbuDP5hbaXqSSJOlUmBK1RNtsVUqeeSQp4zJE4SD5
	QFaLlyEnzB4cQj/XyGUwR/jIBT6gMzPwXZLMQhmMRRfMxDByY/18C1A5G5UzXhOF2wpXRYwJQ6C
	Y61hu3guH5iBEODszOEmXDhxga+hGrwPxD09cXu+1lpYmclsIV137ud5650AnHLvpUaeITAkek8
	YaBdfRW3pR5/h+oGRaE9shUPwHZETtwv7iCwWLnTlMIU8su9J6dCOdizLYzL5Z1+yGoFeo4mMMI
	dGQ==
X-Received: by 2002:a17:907:c1b:b0:c15:ccda:26d5 with SMTP id
 a640c23a62f3a-c2612b8e83fmr1061905366b.4.1788842631880; Mon, 07 Sep 2026
 21:43:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907133929.1081540-1-jinpu.wang@ionos.com>
 <20260907133929.1081540-3-jinpu.wang@ionos.com> <20260907135604.280C41F00A3D@smtp.kernel.org>
In-Reply-To: <20260907135604.280C41F00A3D@smtp.kernel.org>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Tue, 8 Sep 2026 06:43:38 +0200
X-Gm-Features: AcwNN1WZMVuMvqYmLR--l9kFxspZma9xmdbpzkfECQwjUT0fbxCOEuZeQejf8gs
Message-ID: <CAMGffEmU4HovbTB=E12kw-HFa2EgKQmf30-cbG8tBvpi0cD5fg@mail.gmail.com>
Subject: Re: [PATCH 2/6] md: pass a queue_limits down to ->hot_add_disk()
To: sashiko-reviews@lists.linux.dev
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 7, 2026 at 3:56=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential issu=
e(s) to consider:
>
> New issues:
> - [High] `linear_add()` ignores the new `lim` argument and unconditionall=
y calls `queue_limits_set()`, which will cause a deadlock.

Will fix in newer version.
>
> Pre-existing issues:
> - [High] Missing limit check and queue limit stacking for replacement dis=
ks in `raid1_add_disk()`.
> - [High] Missing limits update and stacking when hot-adding a disk in `ra=
id5_add_disk()`.
> --
>
> commit 37bd7159af00deb7b9d45549d34775a10b587170
> Author: Jack Wang <jinpu.wang@cloud.ionos.com>
>
>     md: pass a queue_limits down to ->hot_add_disk()
>
>     Adding a leg stacks its queue limits, which mddev_stack_new_rdev() do=
es
>     by taking q->limits_lock itself.  Callers that hold reconfig_mutex, o=
r
>     have the array suspended, must not do that: the lock's holder waits f=
or
>     I/O they are blocking.  They need to own the update instead.
>
>     Give ->hot_add_disk(), remove_and_add_spares() and
>     md_choose_sync_action() a queue_limits argument, and add
>     mddev_stack_rdev_into() to stack into a caller-owned update.  Every
>     caller passes NULL, so no functional change; the users follow.
>
> > diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
> > index 73b367b61b873..1f44c2d7db93d 100644
> > --- a/drivers/md/md-linear.c
> > +++ b/drivers/md/md-linear.c
> > @@ -186,7 +186,8 @@ static int linear_run(struct mddev *mddev)
> >       return ret;
> >  }
> >
> > -static int linear_add(struct mddev *mddev, struct md_rdev *rdev)
> > +static int linear_add(struct mddev *mddev, struct md_rdev *rdev,
> > +                   struct queue_limits *lim)
> >  {
> >       /* Adding a drive to a linear array allows the array to grow.
> >        * It is permitted if the new drive has a matching superblock
>
> [Severity: High]
> Does linear_add() miss using the new lim argument?
>
> Looking at the body of linear_add(), it unconditionally calls linear_conf=
()
> without passing the limits down. In the final state of this patch series,=
 when
> the caller already holds q->limits_lock, linear_conf() will eventually ca=
ll
> queue_limits_set() which tries to take the lock again. Could this lead to=
 a
> deadlock on q->limits_lock when hot-adding a disk?
>
> [ ... ]
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index f0646fb24371f..dd348b5695d06 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -1898,7 +1898,8 @@ static bool raid1_remove_conf(struct r1conf *conf=
, int disk)
> >       return true;
> >  }
> >
> > -static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
> > +static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev,
> > +                       struct queue_limits *lim)
> >  {
> >       struct r1conf *conf =3D mddev->private;
> >       int err =3D -EEXIST;
> > @@ -1923,7 +1924,10 @@ static int raid1_add_disk(struct mddev *mddev, s=
truct md_rdev *rdev)
> >       for (mirror =3D first; mirror <=3D last; mirror++) {
> >               p =3D conf->mirrors + mirror;
> >               if (!p->rdev) {
> > -                     err =3D mddev_stack_new_rdev(mddev, rdev);
> > +                     if (lim)
> > +                             err =3D mddev_stack_rdev_into(mddev, rdev=
, lim);
> > +                     else
> > +                             err =3D mddev_stack_new_rdev(mddev, rdev)=
;
> >                       if (err)
> >                               return err;
>
> [Severity: High]
> This is a pre-existing issue, but I noticed that further down in
> raid1_add_disk(), we add a replacement disk but omit any limit checks:
>
>         if (err && repl_slot >=3D 0) {
>                 /* Add this device as a replacement */
>                 clear_bit(In_sync, &rdev->flags);
>                 set_bit(Replacement, &rdev->flags);
>                 raid1_add_conf(conf, rdev, repl_slot, true);
>                 err =3D 0;
>                 conf->fullsync =3D 1;
>         }
>
> Since mddev_stack_new_rdev() or mddev_stack_rdev_into() is skipped for th=
is
> path, could this allow a replacement disk with incompatible queue limits
> (such as differing integrity profiles or larger logical block sizes) to j=
oin
> the array, resulting in data corruption or I/O failures?
>
> [ ... ]
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index b91545ce090de..0ec555ada64a0 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -8441,7 +8441,8 @@ static int raid5_remove_disk(struct mddev *mddev,=
 struct md_rdev *rdev)
> >       return err;
> >  }
> >
> > -static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
> > +static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev,
> > +                       struct queue_limits *lim)
> >  {
> >       struct r5conf *conf =3D mddev->private;
> >       int ret, err =3D -EEXIST;
>
> [Severity: High]
> This isn't a bug introduced by this patch, but I noticed that raid5_add_d=
isk()
> does not stack or check queue limits at all when hot-adding a disk:
>
>         for (disk =3D first; disk <=3D last; disk++) {
>                 p =3D conf->disks + disk;
>                 if (p->rdev =3D=3D NULL) {
>                         clear_bit(In_sync, &rdev->flags);
>                         rdev->raid_disk =3D disk;
>                         if (rdev->saved_raid_disk !=3D disk)
>                                 conf->fullsync =3D 1;
>                         WRITE_ONCE(p->rdev, rdev);
>
>                         err =3D log_modify(conf, rdev, true);
>
>                         goto out;
>                 }
>         }
>
> Because mddev_stack_new_rdev() or mddev_stack_rdev_into() are not called
> here, and the new lim argument is ignored, could this allow disks with
> incompatible limits to be successfully added to the array?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907133929.10=
81540-1-jinpu.wang@ionos.com?part=3D2
