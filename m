Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2B732E13B
	for <linux-raid@vger.kernel.org>; Tue,  8 Sep 2026 04:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788842710; cv=pass; b=PtdeA3dU7lV3KWXavvyyul2KKRENxYhdy/JUndx4DDZDzu3bg45CytRUrbOB/H7f0R8zDR5dXk9P4vJM2ujFJlVW41UW+97CK/6IpKQY0j1YYoJkRkfsDTczqClpfbdUZSOebdQIhow+hsjmQL833kpW+a5IviRE9hmGst9g8Zg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788842710; c=relaxed/simple;
	bh=BhoqelLA0SZQhL3W8H9XntAdaEDx8LHDQuj/4lBDOfc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nu9/zB25YW4UGEDad06S3czIPjRU0wLHYxnNzty9qVrd4rwXfVxKqbWKFoeyqM2mSoBpOsSSde+J0KSMg+B+K80UYlfn46vqbhqmKN5tiboykCTNFxK/GEIzpQ0MpAFmMrVAf85eQE5ExrTwfrs2J3nEz48rJ9PEe5oPJliZzyY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=N3YzwNO5; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="N3YzwNO5"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c250848d127so47247066b.3
        for <linux-raid@vger.kernel.org>; Mon, 07 Sep 2026 21:45:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788842706; cv=none;
        d=google.com; s=arc-20260327;
        b=ZP1ODH5QkJP8RY/Nj5pxToRZ6ygbV5ll7HacZXkOfchfMAOrnHzXAb1dmmDCYKeS2t
         W/DnateqkuJn4bL6ZvUcXmEyRKlx53iUoxWStxR91sv7Np5FBW7yT31Lb5M1s/ScStG+
         hXy5Rb4nOb/+NIlUDL9Dk+IyP9gxgH/3poUnLrxT4o4lz+druGijoyDLwIgdnCmEhMGT
         1snDaBpjErQQ8XABb6PnzWJ5tknOoPf4A4Mp702hyPv553mrKd5QyA/YfdR75dUjeQrm
         qi7ALa/sC7DEu6horCGElBBcFchK9X8+zp+g4/SLvIUgPUo887HQoI+oe/jq3rsulZp5
         Zbuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3rHo9ESoHXNd0UzaMM9hjklUasOY59724tGJSkfHmbc=;
        fh=mTP6TkWV1IhQRgyhsEpYqIpiXvhDlZKdHAfNRdOTDjk=;
        b=n+uAz+IFcad5q7kSgV5EH8KuWRAeZRkL4VtAder2jfTlHMkPaRkooHSUx792lMuJU3
         HTtdItK5YdeWIAxF0JXPqEHU3iobfYMC9YQy+r7F4rMr84aTh5LY0rdE9TKZIBC9KfHh
         GqZ5iTFPcVe8nBM1Hv7E7Li6+X4XObGW0CLigPtONNIKw5U3qk2dTVyEzkd2UJXiwo0f
         L+3yLf9PcowPPJEdjhSDOSsm2wDYeto60rF6A9VOd4wVmM2/Ri/zXP+e99ojxgTKSHfi
         J4l6FpYb0jl8kK+4HkjEaJ6A1o9s6kZelnmQeFdcrXYt9pkmnad39hxBr94LTA1Dsx8d
         Q1gg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1788842706; x=1789447506; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3rHo9ESoHXNd0UzaMM9hjklUasOY59724tGJSkfHmbc=;
        b=N3YzwNO5flD97qORLX9ANqqQe0ujZD/isn6zp/ym5H/ns6HbjEm1ijcgeZlAWbDp01
         1ZYiP+V2L1roZqbe72ObocYhPTiptXt+CuYeIjX7gOwch13ePYTuPjoH4vtalJlhAXCK
         glP97H3ROfHBl2LDOt8IyXhEMQaUF+iHwC27iP+uhnhPj6DgDWGtgO7g66Ee5gsvOF9y
         NciMzNRgsPDqxaMyaNU/lwertycXu9hmHGvI1o6UmKm+L+PEOIyCjCfmIq5BaOotGf2k
         LtX/MP0TBC7MMnixkzBRc0OongqUkpjuzGhAv/uVLkJVzhmnbn0rKhNfbl0wcq06gatF
         wrSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788842706; x=1789447506;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3rHo9ESoHXNd0UzaMM9hjklUasOY59724tGJSkfHmbc=;
        b=RQaNGKk8KCrX85FL7rL1JGUyGSHDGpxKCqwh8PydPGVBytA4yHQMr01Yw5YR98IHmc
         4U/wVJGNq6WRONOZiBH1v0ud0nwPehBeiSeyyl1eroTSguFLG1VYfiykvf5F5BWalTM2
         HJOCwRjsyaR7QUuA1EUKWRjs7cFRpBZScGPZSWUz+pDCArvZs9mal4Lw/J035M4WZ8Ea
         /LBG9mzG7gQ4I1oWSVgw1uLRF3xcpbdYdoojOo1LJIaSmJtoS7d4f3i34TGEZ7K+uFM8
         137fHCf74T+ICEQyEIpCkRDPmEZq5l7dIv6hHB2Hj2sSLidm2qLeEA1sFilC13PotEEJ
         ZRAg==
X-Gm-Message-State: AFuF++kSXbXLTjzWZ86cikI38WcI2XSzv/9Kumlxr4hQJOHUr+KE8Jfw
	KTCchwGudTUZDcIifwq6y0NzkrXGM4yW+foVzQ2wo0aYLkJZjNO9kRNY5M0jbdbfEtmkRDFfAqc
	oSVVHirlnGp0HynxqcHHNIxSrin0465w6fT6nhQ/S826v/6p5U2AN9/1QFw==
X-Gm-Gg: AYBFou1RJ1JA2BBaqC5rf1Ufwfbq2GxlLsw1kgZ2IOI8/yPLynaRa1KCgLKNEeAY+tQ
	liVPbyO3FvPyaNJn9skWxOlq2Ggxhx7P4X1GzkMIXId/CFqu37FLePFKv6az+julxPzh8R44iR9
	zENFCZu/ruzIUm/dRVMeczMsOcjEH1TuG8bebTnSTQPJHgjIHArVGjc/laYuzYaYu6Rxf7r31Ts
	s7b+7CZDaN0tG0hX4GDU38ThLfsL4i2royNWRuCuaIWsnXDSoJrgvPmC2FHZYfBgqGRDfflc8nl
	Hr17CbKpA+YMrRxlJHUHBOYnczottZONT35WEvuNf8Q5ebghlTy2GCZl4lHdFqGm9RucfQbE7oU
	GPRGJV8jFfJKV
X-Received: by 2002:a17:907:94d3:b0:c16:1290:11a7 with SMTP id
 a640c23a62f3a-c2624f0a534mr748736666b.1.1788842706538; Mon, 07 Sep 2026
 21:45:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907133929.1081540-1-jinpu.wang@ionos.com>
 <20260907133929.1081540-7-jinpu.wang@ionos.com> <20260907140031.C781F1F00A3D@smtp.kernel.org>
In-Reply-To: <20260907140031.C781F1F00A3D@smtp.kernel.org>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Tue, 8 Sep 2026 06:44:53 +0200
X-Gm-Features: AcwNN1UH1ToXGgiVaFhNPIYJsuOQ1CTBIOsRe4-FrEnGV7uGBHzzhpDdaajZFSs
Message-ID: <CAMGffE=pibzgtDnYSLXP08=PAv0OPth4u4v4juQb6iyvXF5hXQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] md: take q->limits_lock before locking and suspending
 the array
To: sashiko-reviews@lists.linux.dev
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 7, 2026 at 4:00=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> New issues:
> - [Medium] queue_limits_commit_update() return value is ignored and calle=
d unconditionally on error paths instead of queue_limits_cancel_update()
>
Will fix in newer version
> Pre-existing issues:
> - [High] ABBA deadlock between q->limits_lock and mddev_suspend in level_=
store()

Yes, there is a plan: thread a queue_limits through ->run() in all
five personalities so level_store() owns the update, the way
md_ioctl() now does. I left it out because it's ~40 lines across
raid0/1/5/10/linear and orthogonal to the deadlock being fixed here.
I'll post it as a follow-up. Worth noting the hang you describe is
reachable today without this series, since queue_limits_set() freezes
the queue while level_store() has the array suspended =E2=80=94 the freeze
then waits for I/O that mddev->suspended is holding back, no second
task needed.
> --
>
> commit ecb6e260e45c52011fdf103645ad33814409ccd9
> Author: Jack Wang <jinpu.wang@cloud.ionos.com>
>
> md: take q->limits_lock before locking and suspending the array
>
> This commit updates the block layer limits locking order for MD devices t=
o
> prevent a deadlock when writing queue limits attributes during disk opera=
tions.
> It takes the limits update before locking and suspending the array, passi=
ng it
> down into personality stacks.
>
> > Two callers still take the lock inside reconfig_mutex, both with the
> > array suspended: ->start_reshape() from action_store(), which suspends
> > before flushing sync_work so the update cannot be held across it, and
> > raid*_run() -> queue_limits_set() from level_store(), which already
> > hangs on its own because it freezes the queue while suspended.
>
> [Severity: High]
> This is a pre-existing issue, but is there a plan to address the ABBA
> deadlock in level_store()? When the array is suspended and locked, normal
> I/O parks on the queue usage counter. Concurrently, a udev sysfs write ca=
n
> take q->limits_lock and wait in blk_mq_freeze_queue() for the counter to
> drain, while level_store() holds the suspend lock and waits for
> q->limits_lock via pers->run() -> queue_limits_set(), causing a system
> hang.
>
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -3780,15 +3783,37 @@ rdev_attr_store(struct kobject *kobj, struct at=
tribute *attr,
> [ ... ]
> >       rv =3D suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev=
);
> >       if (!rv) {
> >               if (rdev->mddev =3D=3D NULL)
> >                       rv =3D -ENODEV;
> >               else
> > -                     rv =3D entry->store(rdev, page, length, NULL);
> > +                     rv =3D entry->store(rdev, page, length, limp);
> > +             /* apply the limits before the array takes I/O again */
> > +             if (limp) {
> > +                     queue_limits_commit_update(q, limp);
> > +                     limp =3D NULL;
> > +             }
>
> [Severity: Medium]
> Are we missing a check for the return value of queue_limits_commit_update=
()
> here? If the block layer rejects the new limits because blk_validate_limi=
ts()
> fails, the return value is ignored. This could allow the array to proceed
> using the new disk with old limits, risking I/O errors if requests exceed
> the disk's hardware limits.
>
> >               suspend ? mddev_unlock_and_resume(mddev) : mddev_unlock(m=
ddev);
> >       }
> >
> > +     if (limp)
> > +             queue_limits_commit_update(q, limp);
> > +
>
> [Severity: Medium]
> Does this code incorrectly call queue_limits_commit_update() unconditiona=
lly
> on error paths? If mddev_suspend_and_lock() or mddev_lock() failed, rv wi=
ll
> be non-zero but limp will still be set. In this situation, the code will
> commit unchanged limits instead of cancelling them via
> queue_limits_cancel_update().
>
> [ ... ]
> > @@ -8618,6 +8673,9 @@ static int md_ioctl(struct block_device *bdev, bl=
k_mode_t mode,
> >           err !=3D -EINVAL)
> >               mddev->hold_active =3D 0;
> >
> > +     if (limp)
> > +             queue_limits_commit_update(q, limp);
> > +
>
> [Severity: Medium]
> Similar to the rdev_attr_store() issue above, should this use
> queue_limits_cancel_update() on error paths? If an inner ioctl command
> fails, this will erroneously commit the unchanged limits rather than
> cancelling the update.
>
> [ ... ]
> > @@ -10419,6 +10497,8 @@ static void md_start_sync(struct work_struct *w=
s)
> >        *     https://bugzilla.kernel.org/show_bug.cgi?id=3D218200
> >        * Therefore, use __mddev_resume(mddev, false).
> >        */
> > +     if (limp)
> > +             queue_limits_commit_update(q, limp);
>
> [Severity: Medium]
> Does this safely handle limit validation failures when adding spares? The
> return value is ignored, which could leave the array with outdated limits=
 if
> the limits fail to stack correctly.
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907133929.10=
81540-1-jinpu.wang@ionos.com?part=3D6
