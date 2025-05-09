Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51383275852
	for <linux-raid@vger.kernel.org>; Fri,  9 May 2025 09:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746783203; cv=none; b=oahLPqBzPzRhxs3o28cc+hHI4OYnz3M3Dot7TKBIsUKfrAe+rsNpcZAR6/4fZib4/a1SwpeaKhDR9VAN3pKaWtkQ/UFDp1b2f1EbVlNOD1al/v3V2mqbEU4r6dvz4k94e37FVNDA9oMNhISTKL02YG4CHI822yL0fiqAyVIihDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746783203; c=relaxed/simple;
	bh=XrDHeA9YzsUuuBctC0Et8hHJVvc9Bl3p8a9ZjRoRVVM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZVaNxrXcaR9582KkBtEt1xxbvj2D51rfkJz4EAILWNZttVTyiqDFKge0zLaiugN05Pw4OjbgKNT7FazdiyPRQs9Gb0bVd3uT3teWDOAo9eGJR3DEPW3s4fTEDlXgLT/h3j5veKNFNEdWM8GYZTBrqRZQ3gjLBWkGNymWlXBC29Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QPaF/sXG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QPaF/sXG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746783200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ag6e4NVqzIbC9N9+omjleD9ARKC8mr2vh/Cwum2GqDk=;
	b=QPaF/sXGv81sXRShartmlmur/SAK3Bad8U9mwhzdF9yKJLxOZNG63GZmqirOq9IxPUvgf4
	AdlCpKRgr5obxNuIVmlnNc+eMS59s3lauFD6Sc4RogiPjTbxlQNxI4E3lLV4yqY1VPT7Kl
	uo9POjdx30rGWIOwhQqG267yngJxNyA=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-50-IW8ogOi0PVK0x1noeLKFhQ-1; Fri, 09 May 2025 05:33:18 -0400
X-MC-Unique: IW8ogOi0PVK0x1noeLKFhQ-1
X-Mimecast-MFC-AGG-ID: IW8ogOi0PVK0x1noeLKFhQ_1746783197
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-326c9859298so1983781fa.1
        for <linux-raid@vger.kernel.org>; Fri, 09 May 2025 02:33:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746783197; x=1747387997;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ag6e4NVqzIbC9N9+omjleD9ARKC8mr2vh/Cwum2GqDk=;
        b=g5QXtdsWNvz/tAYHIrGMRcaLTdkZVdg0NxPzlcaTS8rDK+O3hQ54z/19VXyauoNNx+
         rMNFKcGLJO3uXEycVk20HAe2eg89VpqewstuEOvNusKJTr4ag2AVt1yTRDiCiF0aAmAm
         8XSNS/rbcfPoRcfTudQUd7P/6+0i6CtAvbM62InABRItLpKfvUFw69qpWUrzkOX2/pHj
         V2kg5B2IpZyXvWcvzE1FuTDykJawNKPq7iVGi3awtF5lgggThOKn8dSU8uSW37JQNF4w
         jlhmbEFv/aYjSzjFRb1aD7sO2GIwqYDoavqPQfGbTWdYp2i98gi3B27DMRkSO6Xzj17s
         dzCQ==
X-Gm-Message-State: AOJu0YxA7cZBHuVQA1328nWyOCJPDRwzL8c3UpHP1/shjfkszZajfZb3
	vxvvGMuaTN3fjlITHdsZxpvb/zMgB5ipW45lXlyEs66dYzvTNG01BJXRuneceO87U3hkg7MB+gX
	vM0x0QsNajhmCVcUscPq7ItVGfNP8qbMtOGFzgYh5WpYgouAkeLN5ojgevsZjlPhb5FHYF3rNGz
	vO4cbZxepOzXv6ucuQGXBOZ7pC4sosWGQtZA==
X-Gm-Gg: ASbGnctprCAxCKBdwQXZN7PCrbNSiNueeVdpsTfUo1L02CF/F7Eq86wCxA+7X5iMrbu
	hdGgZs+1y6wemgVEZJMQXutO5b6qKiXr5e/OiXs+JHtvigyDmOZcweRVqdcW3W1o5adeQ7Q==
X-Received: by 2002:a2e:ad89:0:b0:30b:b987:b676 with SMTP id 38308e7fff4ca-326c45549f9mr11870361fa.2.1746783197183;
        Fri, 09 May 2025 02:33:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsO4bs0LLS1j//maNRuay8EqN8ZIJ1N7w4L4A2NfmeTf1n+n5T2OhIRGhb64qYKwRHsN+7++65PAS6pegAMNY=
X-Received: by 2002:a2e:ad89:0:b0:30b:b987:b676 with SMTP id
 38308e7fff4ca-326c45549f9mr11870231fa.2.1746783196736; Fri, 09 May 2025
 02:33:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250507021415.14874-1-xni@redhat.com> <20250507021415.14874-3-xni@redhat.com>
 <09d3eb78-d2c9-5c04-bec5-5aae4a19cf83@huaweicloud.com>
In-Reply-To: <09d3eb78-d2c9-5c04-bec5-5aae4a19cf83@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 9 May 2025 17:33:05 +0800
X-Gm-Features: AX0GCFvNQJCncrEsLr9RI9sGXgamVauBzThCDuV3dpQCcHbQgFE5CfWNHtd8m-g
Message-ID: <CALTww29siTuVSpCOJB7j47DxWFMcZV9RHkX=VfdxU0OyA4TsFg@mail.gmail.com>
Subject: Re: [PATCH 2/3] md: replace MD_DELETED with MD_CLOSING
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, ncroxon@redhat.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 7, 2025 at 2:21=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2025/05/07 10:14, Xiao Ni =E5=86=99=E9=81=93:
> > Before commit 12a6caf27324 ("md: only delete entries from all_mddevs wh=
en
> > the disk is freed") MD_CLOSING is cleared in ioctl path. Now MD_CLOSING
> > will keep until mddev is freed. So MD_CLOSING can be used to check if t=
he
> > array is stopping.
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/md.c | 9 +++------
> >   drivers/md/md.h | 2 --
> >   2 files changed, 3 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 9b9950ed6ee9..c226747be9e3 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -599,7 +599,7 @@ static inline struct mddev *mddev_get(struct mddev =
*mddev)
> >   {
> >       lockdep_assert_held(&all_mddevs_lock);
> >
> > -     if (test_bit(MD_DELETED, &mddev->flags))
> > +     if (test_bit(MD_CLOSING, &mddev->flags))
> >               return NULL;
> >       atomic_inc(&mddev->active);
> >       return mddev;
>
> I noticed that MD_CLOSING can be set temporarily in following case:
>
> sysfs:
>          if (st =3D=3D readonly || st =3D=3D read_auto || st =3D=3D inact=
ive ||
>          =E2=94=8A   (err && st =3D=3D clear))
>                  clear_bit(MD_CLOSING, &mddev->flags);
>
> ioctl:
>          if (cmd =3D=3D STOP_ARRAY_RO || (err && cmd =3D=3D STOP_ARRAY))
>                  clear_bit(MD_CLOSING, &mddev->flags);
>
>
> And we should still allow mmdev_get() to pass in these cases.

The two places clear MD_CLOSING rather than setting MD_CLOSING.
MD_CLOSING is set when we really want to stop the array (STOP_ARRAY
cmd and clear>array_state_store). So the two places clear MD_CLOSING
for other situations which look good to me.

Regards
Xiao
>
> Thanks,
> Kuai
>
> > @@ -613,9 +613,6 @@ static void __mddev_put(struct mddev *mddev)
> >           mddev->ctime || mddev->hold_active)
> >               return;
> >
> > -     /* Array is not configured at all, and not held active, so destro=
y it */
> > -     set_bit(MD_DELETED, &mddev->flags);
> > -
> >       /*
> >        * Call queue_work inside the spinlock so that flush_workqueue() =
after
> >        * mddev_find will succeed in waiting for the work to be done.
> > @@ -3312,7 +3309,7 @@ static bool md_rdev_overlaps(struct md_rdev *rdev=
)
> >
> >       spin_lock(&all_mddevs_lock);
> >       list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
> > -             if (test_bit(MD_DELETED, &mddev->flags))
> > +             if (test_bit(MD_CLOSING, &mddev->flags))
> >                       continue;
> >               rdev_for_each(rdev2, mddev) {
> >                       if (rdev !=3D rdev2 && rdev->bdev =3D=3D rdev2->b=
dev &&
> > @@ -8992,7 +8989,7 @@ void md_do_sync(struct md_thread *thread)
> >                       goto skip;
> >               spin_lock(&all_mddevs_lock);
> >               list_for_each_entry(mddev2, &all_mddevs, all_mddevs) {
> > -                     if (test_bit(MD_DELETED, &mddev2->flags))
> > +                     if (test_bit(MD_CLOSING, &mddev2->flags))
> >                               continue;
> >                       if (mddev2 =3D=3D mddev)
> >                               continue;
> > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > index 1cf00a04bcdd..a9dccb3d84ed 100644
> > --- a/drivers/md/md.h
> > +++ b/drivers/md/md.h
> > @@ -338,7 +338,6 @@ struct md_cluster_operations;
> >    * @MD_NOT_READY: do_md_run() is active, so 'array_state', ust not re=
port that
> >    *             array is ready yet.
> >    * @MD_BROKEN: This is used to stop writes and mark array as failed.
> > - * @MD_DELETED: This device is being deleted
> >    *
> >    * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is =
added
> >    */
> > @@ -353,7 +352,6 @@ enum mddev_flags {
> >       MD_HAS_MULTIPLE_PPLS,
> >       MD_NOT_READY,
> >       MD_BROKEN,
> > -     MD_DELETED,
> >   };
> >
> >   enum mddev_sb_flags {
> >
>

