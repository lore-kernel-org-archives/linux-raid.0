Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F382D8375
	for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 07:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754984704; cv=none; b=XV4mbV+9herlGXfl8lucoXbYaAHcIXL1dNN3jM6RYI9tbVpgT20rkIC8U/e4hptv5RGe7VS49J8Lclu0fhrrpiRcqMxX8e5wAsQ8fSqpvy0Pt6lk5iVqKLKRs4JOk/bLRw3mJnj16LE8ipQ+B09R9zglj6aWp2f3dImAZeHhG+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754984704; c=relaxed/simple;
	bh=LRAkDwotJ2EUBfHFFMePXtQrp3bH++mv7FEV/9sajLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UBXnSOdVkekU1h3dbT4ofei4wTWbjMgaOiolOaHjl6ytShKxC9ZVjeWyEwl9GL3WslXZDlMCjnkv/4MF+ldpWA0+ebVHmdMPqQ0O5oDcSJk3ZJYo1akPRSVwMHU8RZobpyo4mxcrhVGVbLp8l2cc2j79T2y6vTXhs5fyChihUG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f/3UETSe; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f/3UETSe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754984701;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YZOc5udQ61BswjPn+gCa/RRdi645pob8hOdKqbPAT6k=;
	b=f/3UETSe+EurVGNlxS/kzn2UDO3mYCp4tqFSb+hz0OLJlZUapWbxCb29cbAtAEt9iCLVUc
	r5cKeE33DB9dvqpjWZADHzpW/KaLZSz83asQfLu1kYtmO9fEODpiOtLPdhrD30KA2gEoPv
	I/Y6ZBWJ5nsVu2SuC5jDxdit7rovbEY=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-9TQOpWqMNv-iaPFNOFX5Xg-1; Tue, 12 Aug 2025 03:45:00 -0400
X-MC-Unique: 9TQOpWqMNv-iaPFNOFX5Xg-1
X-Mimecast-MFC-AGG-ID: 9TQOpWqMNv-iaPFNOFX5Xg_1754984699
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-55b995be1e8so2312846e87.0
        for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 00:44:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754984698; x=1755589498;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YZOc5udQ61BswjPn+gCa/RRdi645pob8hOdKqbPAT6k=;
        b=lgsZUwnkSA8DsGNJuoGpAyE1350NcMCB5gSCr46NCpGDdGF0CmgmEFRQfkCRiAFN3k
         l5AkPXxjecFXs9elpNHPtUhXJ+q4b4qBdLiPSgVw9JcGUc1Qu/AjzHZ5KdZCS/8ZgASu
         zn6GLuzC/6WfYlaL6L9ZMRvvWt9unR2gBraSTjwcxerOfaOTTLrL1bfSS7bt685KN7Sd
         bewg5Hkybt1O7y3Y/duUnQ34jzXuU5TBLUSJLTLsZo1o1l8GQOwbeRnctS4Lfa+Pnpbi
         gd63fPYRsmYukHeet4A2wClmJ2rXsb3RaXKEzYPzoeYwetIdF1zM+daGFhvoKtJtTM6g
         uWCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWX+A0QCF7YaH4AE7Np2Csi9ah3m074lwv6RGI09GB4onqa3VFGErFcfvrkRdU32rTbv0InQ0CMu9lF@vger.kernel.org
X-Gm-Message-State: AOJu0YwKJOIsDWDbyfgsugwbvSo9EWMsifjZHS8U5rSlUUsyGHy31O8Y
	27mR09y3BBVSWWPgceGXH5DJP7lUpq8917VIjVbHr2cnp/uGTliw1nO7PjYTPjURDUMH4aUI3ub
	eFV1v2j5wisale+Q5O6+ZmuLZZkUkKorpAxdtaTWVLB1nvYjqu/APPh0MvHI0rITrFcrfj5DVEk
	4NQNObDkhnF9f2uKhUCldTpfHe9uT4h8qMK918Og==
X-Gm-Gg: ASbGnctuyOR7JpfTsMx9i/5/0m0Q/v0gTaWA15VtYqRJeHFPPsevbGIil4IwlQ56Zrv
	0h+PvSdcmJ4s+1m4FQU7T/ZDUMOUoTurorJEXupJ2tLCyx+ebsh9cnzcmU/r6Cj25mgCis2ckJJ
	1C0n9sYGJc2tN8+T8HCpDhjg==
X-Received: by 2002:a05:6512:1103:b0:553:a5e0:719c with SMTP id 2adb3069b0e04-55cd7666389mr830125e87.51.1754984698343;
        Tue, 12 Aug 2025 00:44:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFIBnhrQ0dnx2Hos+bfgrObER/oBoenXet1/bAi5PoOW5zaXlGxHAgt0EiaR2FVI9Kg2d17EUB8J9EdrcH6/6Y=
X-Received: by 2002:a05:6512:1103:b0:553:a5e0:719c with SMTP id
 2adb3069b0e04-55cd7666389mr830104e87.51.1754984697567; Tue, 12 Aug 2025
 00:44:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250812072709.61059-1-xni@redhat.com> <608bc5b7-f9f3-af6d-e7ac-d4a27cb0f132@huaweicloud.com>
In-Reply-To: <608bc5b7-f9f3-af6d-e7ac-d4a27cb0f132@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 12 Aug 2025 15:44:45 +0800
X-Gm-Features: Ac12FXzbBjQCTCAc7pkJGPQHpA85g3lAkQpsoR4TOtK891Igp_bz0pcwYMYu9ew
Message-ID: <CALTww2_6ZfvqgZXc=_YKjx390XsZe0Gis4jrU6=q4CCpzxz8ow@mail.gmail.com>
Subject: Re: [PATCH 1/1] md: add legacy_async_del_gendisk mode
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: yukuai@kernel.org, linux-raid@vger.kernel.org, mpatocka@redhat.com, 
	luca.boccassi@gmail.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2025 at 3:40=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2025/08/12 15:27, Xiao Ni =E5=86=99=E9=81=93:
> > commit 9e59d609763f ("md: call del_gendisk in control path") changes th=
e
> > async way to sync way of calling del_gendisk. But it breaks mdadm
> > --assemble command. The assemble command runs like this:
> > 1. create the array
> > 2. stop the array
> > 3. access the sysfs files after stopping
> >
> > The sync way calls del_gendisk in step2, so all sysfs files are removed=
.
> > Now to avoid breaking mdadm assemble command, this patch adds a paramet=
er
> > that can be used to choose which way. The default is async way. In futu=
re,
> > we can remove this parameter when users upgrade to mdadm 4.5 which remo=
ves
> > step2.
> >
> > Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> > Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> > Closes: https://lore.kernel.org/linux-raid/CAMw=3DZnQ=3DET2St-+hnhsuq34=
rRPnebqcXqP1QqaHW5Bh4aaaZ4g@mail.gmail.com/T/#t
> > Suggested-by: Yu Kuai <yukuai@kernel.org>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/md.c | 57 +++++++++++++++++++++++++++++++++++++-----------=
-
> >   1 file changed, 43 insertions(+), 14 deletions(-)
> >
>
> Other than some nits below, this patch LGTM
>
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index ac85ec73a409..e48ee59082a5 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -339,6 +339,7 @@ static int start_readonly;
> >    * so all the races disappear.
> >    */
> >   static bool create_on_open =3D true;
> > +static bool legacy_async_del_gendisk =3D true;
> >
> >   /*
> >    * We have a system wide 'event count' that is incremented
> > @@ -877,15 +878,18 @@ void mddev_unlock(struct mddev *mddev)
> >               export_rdev(rdev, mddev);
> >       }
> >
> > -     /* Call del_gendisk after release reconfig_mutex to avoid
> > -      * deadlock (e.g. call del_gendisk under the lock and an
> > -      * access to sysfs files waits the lock)
> > -      * And MD_DELETED is only used for md raid which is set in
> > -      * do_md_stop. dm raid only uses md_stop to stop. So dm raid
> > -      * doesn't need to check MD_DELETED when getting reconfig lock
> > -      */
> > -     if (test_bit(MD_DELETED, &mddev->flags))
> > -             del_gendisk(mddev->gendisk);
> > +     if (!legacy_async_del_gendisk) {
> > +             /*
> > +              * Call del_gendisk after release reconfig_mutex to avoid
> > +              * deadlock (e.g. call del_gendisk under the lock and an
> > +              * access to sysfs files waits the lock)
> > +              * And MD_DELETED is only used for md raid which is set i=
n
> > +              * do_md_stop. dm raid only uses md_stop to stop. So dm r=
aid
> > +              * doesn't need to check MD_DELETED when getting reconfig=
 lock
> > +              */
> > +             if (test_bit(MD_DELETED, &mddev->flags))
> > +                     del_gendisk(mddev->gendisk);
> > +     }
> >   }
> >   EXPORT_SYMBOL_GPL(mddev_unlock);
> >
> > @@ -5818,6 +5822,13 @@ static void md_kobj_release(struct kobject *ko)
> >   {
> >       struct mddev *mddev =3D container_of(ko, struct mddev, kobj);
> >
> > +     if (legacy_async_del_gendisk) {
> > +             if (mddev->sysfs_state)
> > +                     sysfs_put(mddev->sysfs_state);
> > +             if (mddev->sysfs_level)
> > +                     sysfs_put(mddev->sysfs_level);
> > +             del_gendisk(mddev->gendisk);
> > +     }
> >       put_disk(mddev->gendisk);
> >   }
> >
> > @@ -6021,6 +6032,10 @@ static int md_alloc_and_put(dev_t dev, char *nam=
e)
> >   {
> >       struct mddev *mddev =3D md_alloc(dev, name);
> >
> > +     if (legacy_async_del_gendisk) {
> > +             pr_warn("md: async del_gendisk mode will be removed.");
> > +             pr_warn("md: please upgrade to mdadm-4.5\n");
> Perhaps mdadm-4.5+

Ok
>
> And please use one line pr_warn, user may grep the whole line when they
> notice such warning.

I tried to use one line, but checkpatch gives warning all the time.
Any suggestion?

> > +     }
> >       if (IS_ERR(mddev))
> >               return PTR_ERR(mddev);
> >       mddev_put(mddev);
> > @@ -6431,10 +6446,22 @@ static void md_clean(struct mddev *mddev)
> >       mddev->persistent =3D 0;
> >       mddev->level =3D LEVEL_NONE;
> >       mddev->clevel[0] =3D 0;
> > -     /* if UNTIL_STOP is set, it's cleared here */
> > -     mddev->hold_active =3D 0;
> > -     /* Don't clear MD_CLOSING, or mddev can be opened again. */
> > -     mddev->flags &=3D BIT_ULL_MASK(MD_CLOSING);
> > +
> > +     /*
> > +      * For legacy_async_del_gendisk mode, it can stop the array in th=
e
> > +      * middle of assembling it, then it still can access the array. S=
o
> > +      * it needs to clear MD_CLOSING. If not legacy_async_del_gendisk,
> > +      * it can't open the array again after stopping it. So it doesn't
> > +      * clear MD_CLOSING.
> > +      */
> > +     if (legacy_async_del_gendisk && mddev->hold_active)
> > +             clear_bit(MD_CLOSING, &mddev->flags);
> > +     else {
> > +             /* if UNTIL_STOP is set, it's cleared here */
> > +             mddev->hold_active =3D 0;
> > +             /* Don't clear MD_CLOSING, or mddev can be opened again. =
*/
> > +             mddev->flags &=3D BIT_ULL_MASK(MD_CLOSING);
> > +     }
>
> It's prefered to use braces for above if as well.

Ok
>
> Otherwise feel free to add:
> Suggested-and-reviewed-by: Yu Kuai <yukuai3@huawei.com>

Thanks
Xiao
> >       mddev->sb_flags =3D 0;
> >       mddev->ro =3D MD_RDWR;
> >       mddev->metadata_type[0] =3D 0;
> > @@ -6658,7 +6685,8 @@ static int do_md_stop(struct mddev *mddev, int mo=
de)
> >
> >               export_array(mddev);
> >               md_clean(mddev);
> > -             set_bit(MD_DELETED, &mddev->flags);
> > +             if (!legacy_async_del_gendisk)
> > +                     set_bit(MD_DELETED, &mddev->flags);
> >       }
> >       md_new_event();
> >       sysfs_notify_dirent_safe(mddev->sysfs_state);
> > @@ -10392,6 +10420,7 @@ module_param_call(start_ro, set_ro, get_ro, NUL=
L, S_IRUSR|S_IWUSR);
> >   module_param(start_dirty_degraded, int, S_IRUGO|S_IWUSR);
> >   module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
> >   module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
> > +module_param(legacy_async_del_gendisk, bool, 0600);
> >
> >   MODULE_LICENSE("GPL");
> >   MODULE_DESCRIPTION("MD RAID framework");
> >
>

