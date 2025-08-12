Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C889B156CA
	for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 12:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755001239; cv=none; b=GrcFICaqDKGZH53nCRdNLP4r2wIPJAzhLO7jhSrtbY7AFIuEmaUhB8WHobpHAF1JvEqOp0SznI7VhT+YusaZG+sROPzsmY2CXHxAXCcaxC0TuSVKplgHnFxOlCEPbYfMgcYNkzLwju4Y0ekqVLiEblbujRUFP9OfHQ3cPFgbiK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755001239; c=relaxed/simple;
	bh=yuOg0pUALGEmKZMyXzr3uoMLhs2J9UDibEN2dr3n5Ig=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eHgo5ywN2lNoCV7092TFrjv33bWupKaRM1fdNDA3APK+P6X3aTTPs59Jieu2aNIZ0dxZlXImQCQxHzD9UQy2oaffqVC4dNK5Uyj8WmkomQGrqFwJyKlXVXmf8qnGrLVdcmDCyRPGl6blROY+OJCb/hFq+yhM0BXVSA/7zV3/nlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JJMtyIL6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JJMtyIL6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755001236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9GNiULuy2Gn6qc9prlM5XRCv36BKknu9LpI5Ik/eSqQ=;
	b=JJMtyIL6mLfbsYl6OU5D2a+nVYOn12bp1FqJlziugTZyUqNc1FKUP+Eagxoo7JkG7+qQRx
	munsJW1LbLKIKKEHOSeeLQEWlOH6CdiCRqXictY3QM3XTlZW75wKj8/pR0cE7Amu5FiaEt
	AMbNLRq/k4dXInGGRC8bAkpLEU5VIJw=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655--XmMTP9DMTWMWTdjz2PamA-1; Tue, 12 Aug 2025 08:20:35 -0400
X-MC-Unique: -XmMTP9DMTWMWTdjz2PamA-1
X-Mimecast-MFC-AGG-ID: -XmMTP9DMTWMWTdjz2PamA_1755001234
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-55b930b37bfso3275847e87.1
        for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 05:20:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755001234; x=1755606034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9GNiULuy2Gn6qc9prlM5XRCv36BKknu9LpI5Ik/eSqQ=;
        b=P++guAbJISmywL1mWB/D/4lQ4D1BQfhKjuEI4FGFuhH6GQZreDHQ+xgEO9jxOzGzFM
         uD/n4qwqpqbqEASUzE3hqFnghwHX/34jXor5UyvQ0/lNhl1+d8b5TLtv53ue167RnrUb
         vaitnUIO/1ItVBn88mbTRuW5TJmqt97ox3Uigr6wFCsn3F3lNcYoKuJEmPa2/nf3IKLo
         QJVDUi4kAybpc0CaOiFst/uF3pRn2oSs9MyqOAfSh1TfkfATz/dM9a/DVwmN5o5Y4p2E
         uRdUXXlzvYv9SrQNds3bOgOY6UsrUwk94L8Nkt2skTdJZjpAkwJPnagoCnQN8R/g5iXp
         0pJw==
X-Forwarded-Encrypted: i=1; AJvYcCXtO+es2REBdG6H8xPF5OwdcisczaaoYQVS02KF714+Olq8xV9aFCPLMpLNBRmj1BNkMxBocYvD0g98@vger.kernel.org
X-Gm-Message-State: AOJu0YyZWJfUZjfSpvvAzPEnqTtaomAvFIGapmvuFKWyPa0fGLniSa/O
	2jXlNet6QIY13Ft80k14cVBRSToojzLtq6s4x9Md5AsFau801h2JEw9tnNb6ezqQBux44Nww6PJ
	cFI9Sw5v+PdpmJa8sNUROqp0b9ok6grPfbmuFjhoZ1WmAvKKVqUY+VMGzZiQJ3SHN6SFbHuPu3d
	DY2A5P0O4riYM4rQVVjs5MrkXtp6FWGhc4Pv77XQ==
X-Gm-Gg: ASbGncsmuvLcbM40FvSUKj2v5XSfwKRZeXP6MJfsm6d689FCbjPtX6mlCr6vmr+Qf7V
	IPBikYs2625m6ou3Wh5Wg0SjZpzO9DmyyW6amifE/s89Qi7XORhMMJGwrnrVjuRaOJsNaCPZRN+
	QmiGG84zyWH/C1M8TVRQUYhg==
X-Received: by 2002:a05:6512:ad3:b0:55b:79e8:bf83 with SMTP id 2adb3069b0e04-55cd8c44653mr942657e87.14.1755001233594;
        Tue, 12 Aug 2025 05:20:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVpZkhJeu7Xn8C1LjFWq2SAKaDuGtz6ycKNUwj/ooNgZ0KhswLrziDbUE0v8eofpyOugLV7DK6b+yEnmMYxn4=
X-Received: by 2002:a05:6512:ad3:b0:55b:79e8:bf83 with SMTP id
 2adb3069b0e04-55cd8c44653mr942647e87.14.1755001233042; Tue, 12 Aug 2025
 05:20:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250812074947.61740-1-xni@redhat.com> <75175b99-57ce-4384-9b75-c91d4fe4ddad@molgen.mpg.de>
In-Reply-To: <75175b99-57ce-4384-9b75-c91d4fe4ddad@molgen.mpg.de>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 12 Aug 2025 20:20:21 +0800
X-Gm-Features: Ac12FXzwlKSUpmK-AevWOsTvOwHFngflvXEc7J6QELFDnLpfDbl7d9_95ptIZUk
Message-ID: <CALTww29wxGA=o2+pcsF=SBffL_v0tZqrAqM1sCjwHTf+S79wqA@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] md: add legacy_async_del_gendisk mode
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: yukuai1@huaweicloud.com, linux-raid@vger.kernel.org, yukuai3@huawei.com, 
	mpatocka@redhat.com, luca.boccassi@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paul

On Tue, Aug 12, 2025 at 5:58=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.de>=
 wrote:
>
> Dear Xiao,
>
>
> Thank you for your patch.
>
> Am 12.08.25 um 09:49 schrieb Xiao Ni:
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
>
> =E2=80=A6 the parameter legacy_async_del_gendisk =E2=80=A6

ok
>
> > that can be used to choose which way. The default is async way. In futu=
re,
> > we can remove this parameter when users upgrade to mdadm 4.5 which remo=
ves
> > step2.
>
> step 2

ok
>
> Maybe say to first change the default, and then remove it.

I don't follow this. What's the meaning of "to first change the default"?

>
> >
> > Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> > Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> > Closes: https://lore.kernel.org/linux-raid/CAMw=3DZnQ=3DET2St-+hnhsuq34=
rRPnebqcXqP1QqaHW5Bh4aaaZ4g@mail.gmail.com/T/#t
> > Suggested-and-reviewed-by: Yu Kuai <yukuai3@huawei.com>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> > v2: minor changes on format and log content
> >   drivers/md/md.c | 56 ++++++++++++++++++++++++++++++++++++------------=
-
> >   1 file changed, 42 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index ac85ec73a409..44827f841927 100644
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
> > +             pr_warn("md: async del_gendisk mode will be removed pleas=
e upgrade to mdadm-4.5+\n");
>
> Maybe add a timeframe?
>
> md: async del_gendisk mode will be removed in Linux 6.18. Please upgrade
> to mdadm 4.5+

Ah, it makes sense.
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
>
> Kind regards,
>
> Paul
>

Best Regards
Xiao

