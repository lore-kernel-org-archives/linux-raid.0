Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F811AB6F1
	for <linux-raid@vger.kernel.org>; Wed, 13 Aug 2025 06:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755066888; cv=none; b=shALzCfM6hRIf+QqeNkI+CSbwSVUcFi2S+HRUZJdPNIGXkKAoHNPcVOpYXJmlMByLjBxCtncF8sJHcnbMORQ5QKe+ZJwItG4kS1lk2x4Qqqfghooc1eEjU7mABJHeGmgBuTPseDQCD6M1gLVnxoYAvMcO92Mo6m6iHdserJct+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755066888; c=relaxed/simple;
	bh=PYoBIl1sI6oz/gzLGVF35ivWJmpvlmAPd3LKuDWxl0k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gTGWR5LUpsr6VWkptb3yjmBHXO7ngh57CS9ewA603k/3HrFi9WNUd4GPUrUcOi8D9VSKixfnXnogOGpUtbxCyrxWqq4x6KRnkfh1gxW4ULcEt2a470Q4BdgcIZ8XsJ+6LauP2PX3qLIzKVzelWHgcRrAdiYK42tcyQw0xzTuF/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LbQgR1xd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LbQgR1xd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755066883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PB/ehwSpEQjFM91zbyTylMjbI/FmGOfLHBrhb4i9kxw=;
	b=LbQgR1xdR7I+vXllM7un5gz8C0GoJdf75rbVJtRnBBWlk2YQgKGM0Cw9/FGTdsppHqvtUZ
	/qeZPRr8opKAy2aPrH6IAAoJbjiBwXdiHcS5t+gqoxA3yJFDLF1QM7ZRE0mo3C8cnzFoW7
	Drp8Uc3wEuKbPK3jrVpmwVdWRy39OfE=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-677-Dl4SR5A1OdSDd2OtwbG0ig-1; Wed, 13 Aug 2025 02:34:39 -0400
X-MC-Unique: Dl4SR5A1OdSDd2OtwbG0ig-1
X-Mimecast-MFC-AGG-ID: Dl4SR5A1OdSDd2OtwbG0ig_1755066878
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-3326163953dso31676911fa.2
        for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 23:34:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755066878; x=1755671678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PB/ehwSpEQjFM91zbyTylMjbI/FmGOfLHBrhb4i9kxw=;
        b=q8QSh/6/SX2sEwsPcxJjFm8urQNq/ijc1vG5U0pP8qqV1HPbsZ8nfLaD2GB3aoMhkz
         EmbbOKldbHW8caiI3vQxFsC+CiGeKCZcdRl6d256TARCT2GulZArjAq6aM8puli3Eiku
         IbV+QhLyySMw+H+2uAZ6fTY9jz5vdD3Yy2IV7NGC+cc9VgAksAofDUSL5/Vnhvh4iHlc
         zD2aCPB8o53u3/ZEFdox+EDMiVbeeffWPYZ6Xrphi14sXNb6ibWPc1D3HOsufX7J8M6f
         90moJWdRBNP13GHxjI03Cib493D9MmCzD0MQ6gI7Y0sJnDXrfJbZS4nEnaXHYAGGeXQO
         as0Q==
X-Gm-Message-State: AOJu0YzplJ6m5KlE00IApmFbVKdMYsypOqIR1Vsm7FKK5PhW5z0cE4Hw
	LJ4cmJKSJH1tscc7JALqjq5AOG+gVeqZmQppMDUgGFD9ZiAtqSVcq6+Kyc26IQA8KMgQY8nlNdv
	zUVlFrluOXrcxzOgbQ/QkCXGu20QqDkX2hQX6B1PL27DbKBkErX7d2R2nlIlRnnsjl1Sgs4PHnN
	7t/pBeNJ19kK4OATGyky/8Dtn6LTxJbSpovmPs4A==
X-Gm-Gg: ASbGncsMwnWwip3NNUpPhgJZxV/5sePzv06w7CgwJBDG9SRW50JwrP8/lPE0n/9eMeV
	KZQOf6i4qPsSNgYIKgA7J528hA5OlBFd8Q5qBtLx8sE4rnURRS+UNY8Cy2B1V8/26L5vZNX+W3V
	KZKCG60xTVyU06A1cmcgM8Sw==
X-Received: by 2002:a05:651c:420a:b0:32c:bf84:eb05 with SMTP id 38308e7fff4ca-333e9b60d6amr4379561fa.33.1755066877701;
        Tue, 12 Aug 2025 23:34:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGunlg8Dwa14ssAxGX2FakTWkQlo54X2cY/8YjhF67MTQN5tDgjxNvKySUT74BrZIUTg8lQfL+auBWQdvXoBpY=
X-Received: by 2002:a05:651c:420a:b0:32c:bf84:eb05 with SMTP id
 38308e7fff4ca-333e9b60d6amr4379451fa.33.1755066877121; Tue, 12 Aug 2025
 23:34:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250813032929.54978-1-xni@redhat.com> <d571e27d-d363-48e0-b642-a51f2405cabc@molgen.mpg.de>
In-Reply-To: <d571e27d-d363-48e0-b642-a51f2405cabc@molgen.mpg.de>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 13 Aug 2025 14:34:24 +0800
X-Gm-Features: Ac12FXwB6yTTtb4W35k4du2xwEgqg0H1-UkhT6rl3XqIDsHpCHYOUWCmTgovxnA
Message-ID: <CALTww2_GGXf5vyT-VBSvg+Ztb_TtGBpeyLL-e54V9N57Do1o2g@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] md: add legacy_async_del_gendisk mode
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-raid@vger.kernel.org, yukuai1@huaweicloud.com, yukuai3@huawei.com, 
	mpatocka@redhat.com, luca.boccassi@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2025 at 1:27=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.de>=
 wrote:
>
> Dear Xiao,
>
>
> Thank you for sending the new version of the patch.
>
> Am 13.08.25 um 05:29 schrieb Xiao Ni:
> > commit 9e59d609763f ("md: call del_gendisk in control path") changes th=
e
> > async way to sync way of calling del_gendisk. But it breaks mdadm
> > --assemble command. The assemble command runs like this:
> > 1. create the array
> > 2. stop the array
> > 3. access the sysfs files after stopping
> >
> > The sync way calls del_gendisk in step 2, so all sysfs files are remove=
d.
> > Now to avoid breaking mdadm assemble command, this patch adds the param=
eter
> > legacy_async_del_gendisk that can be used to choose which way. The defa=
ult
> > is async way. In future, we plan to change default to sync way in kerne=
l
> > 7.0. Then users need to upgrade to mdadm 4.5+ which removes step 2.
> >
> > Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> > Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> > Closes: https://lore.kernel.org/linux-raid/CAMw=3DZnQ=3DET2St-+hnhsuq34=
rRPnebqcXqP1QqaHW5Bh4aaaZ4g@mail.gmail.com/T/#t
> > Suggested-and-reviewed-by: Yu Kuai <yukuai3@huawei.com>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> > v2: minor changes on format and log content
> > v3: changes in commit message and log content
> > v4: choose to change to sync way as default first in commit message
> >   drivers/md/md.c | 56 ++++++++++++++++++++++++++++++++++++------------=
-
> >   1 file changed, 42 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index ac85ec73a409..772cffe02ff5 100644
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
> > @@ -6021,6 +6032,9 @@ static int md_alloc_and_put(dev_t dev, char *name=
)
> >   {
> >       struct mddev *mddev =3D md_alloc(dev, name);
> >
> > +     if (legacy_async_del_gendisk)
> > +             pr_warn("md: async del_gendisk mode will be removed in fu=
ture, please upgrade to mdadm-4.5+\n");
>
> Should this log message also be updated?
>
> Problematic async del_gendisk mode will default to disable in Linux 7.0.
> Please upgrade to mdadm 4.5+.

Hi Paul

At first, I actually did so. But after thinking for a while, I didn't
do it. I don't want to give a specific version in the log, because we
don't know which version to do it. And it's true, we plan to remove it
in future. If you don't strongly reject it, I will not send a new
version.

>
> > +
> >       if (IS_ERR(mddev))
> >               return PTR_ERR(mddev);
> >       mddev_put(mddev);
> > @@ -6431,10 +6445,22 @@ static void md_clean(struct mddev *mddev)
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
> > +     if (legacy_async_del_gendisk && mddev->hold_active) {
> > +             clear_bit(MD_CLOSING, &mddev->flags);
> > +     } else {
> > +             /* if UNTIL_STOP is set, it's cleared here */
> > +             mddev->hold_active =3D 0;
> > +             /* Don't clear MD_CLOSING, or mddev can be opened again. =
*/
> > +             mddev->flags &=3D BIT_ULL_MASK(MD_CLOSING);
> > +     }
> >       mddev->sb_flags =3D 0;
> >       mddev->ro =3D MD_RDWR;
> >       mddev->metadata_type[0] =3D 0;
> > @@ -6658,7 +6684,8 @@ static int do_md_stop(struct mddev *mddev, int mo=
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
> > @@ -10392,6 +10419,7 @@ module_param_call(start_ro, set_ro, get_ro, NUL=
L, S_IRUSR|S_IWUSR);
> >   module_param(start_dirty_degraded, int, S_IRUGO|S_IWUSR);
> >   module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
> >   module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
> > +module_param(legacy_async_del_gendisk, bool, 0600);
> >
> >   MODULE_LICENSE("GPL");
> >   MODULE_DESCRIPTION("MD RAID framework");
>
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>

thanks for this.
>
>
> Kind regards,
>
> Paul
>

Best Regards
Xiao

