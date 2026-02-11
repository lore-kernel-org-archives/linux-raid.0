Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F12C334C27
	for <linux-raid@vger.kernel.org>; Wed, 11 Feb 2026 02:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770777906; cv=pass; b=UuRsu5FsH/A7D4m+jT9aqmGAn+n1jJRuG4IHLkQ8GL4y1bwRIlndkvJeJjR639jXMdCi6EkoU9hBlrw6Skb8bBqE5CTaofiurSQxUoj47pY4THqTrQ6tribEIpN+QyjyKvLuYEGoGvVkuY0Ge0ESuJG/wrhJIQkT0gOqJklW/GE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770777906; c=relaxed/simple;
	bh=YfLMpT5O2YKaHH6q/FBe24ArbhVQqbaNuFdVCgZ/Znk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UXBEMAiyLMXyHvsB7rNXXYVm0I5T9UhgtA/MtnqJuC+lwVhiFGL9nwmsL7EVP1s6wNffIluYuhBrF9MurjjaJNRFJLYmouUziLSlpr74lzr2cd7bIliQWcZTD/L7YjKPDDVain/XbLYlVN87wrrImCkWxuFtH3L0Q+Mu/tpcFyo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y1yQaSCX; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y1VxaNZF; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y1yQaSCX";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y1VxaNZF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770777903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A0MI0iyAXY5tkuf/q+YZuaoo0d3TR2l6KKCdLxhNS0E=;
	b=Y1yQaSCXlSWmi3AoxNAR3EPtt+Pi34bEXR1f4R1D4mek6dzr/a9AMdHWvWENL5BpBNAw0W
	GaJUY7DCHOPGEtMtTOFbLnY98/vWNPSm6mvCxiEg1g7RZmTOlAY16GSc2vGWrjlw18fFeV
	3vWT4se++GMEq9RVhBvuk1g61TSWVVg=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-UjIlXmkVNQ-mXAM6IP7Ytg-1; Tue, 10 Feb 2026 21:45:02 -0500
X-MC-Unique: UjIlXmkVNQ-mXAM6IP7Ytg-1
X-Mimecast-MFC-AGG-ID: UjIlXmkVNQ-mXAM6IP7Ytg_1770777901
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-59e11fb980fso3961435e87.2
        for <linux-raid@vger.kernel.org>; Tue, 10 Feb 2026 18:45:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770777900; cv=none;
        d=google.com; s=arc-20240605;
        b=fjhLsufSsjpYQ8M6hP/cdi6lGD8V4dhhL5UxmgBdTVGCs2YsOfHHCbKbQIym/Zjo5K
         P3+uoa+xvcV6mrfisz1gKAuh0Pk++iJi0JLyegODjpCrbYbjUif+eGZJLC31C1RBsbBj
         G279JdUo0C2VzDKKKHwkMvBanbfKOgS/EV68gMtsDfarwkYFXEWNPrujm039rvmbPpJG
         /7nGelfQvLYiawKbPt/qhHOa2sRlz+JgXtCPFKkTDwnBsFcFm84f8NkWZ4AXkBW6GgnC
         Hx/K753SiSX1Y3liYKvbnzD0qLo+1Qm4ozidfiR7ySdiin5YwH9qU81XY9nQ8fEiTxAm
         FMew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=A0MI0iyAXY5tkuf/q+YZuaoo0d3TR2l6KKCdLxhNS0E=;
        fh=I8OW7k8P+BLQBHzmhiDKbBm8181dSs47pELOdkDTbjM=;
        b=DdXHtdNfVCYL4BwBMRHzGjsLw0yfLcU04aJE1/6vzDdPtoXFh1PZldCKB9mlE8dhY1
         uORy1uS7HgxlhRwph56+C13BcAm0OTvA9/iXTz7Hqq0jEQtK3bi2QJIVpLJkbCH7k7ow
         bjU2s59cyuW1jO8EtGZt7qa1OZyyS8YvsQt9AFJNCwa5yNDX+tHF88eFxiTitOUT0an0
         qs/a/XDVh76YH3vbt4jyaBeVi1+fflffskhuP0/YFtb06ZAsc7zb7Qmxp5luTYprvkyE
         gUPSoH/e2XqGn0duaWtO6xx1g3KUvCgKzZ1vLpehXxlDj5kmvmPEeXAV39lAGCN0248G
         TM1g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770777900; x=1771382700; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A0MI0iyAXY5tkuf/q+YZuaoo0d3TR2l6KKCdLxhNS0E=;
        b=Y1VxaNZF1ENQRONlkxwdROdKDjc3svHtz7PdNvpZ/fPPKAkXXAqjkOXsNGTV4azZtN
         EsqB5Ea8x8Ll12ZuRlwE4092B/QDKt015zM1qqeStCaZRlNRJT5c90z92pXt6XYSWBfw
         j4gaHksO3wEFXrNiZEMwxVUA9dQfAgXyO79X7P/nHuAfnJ3/ZselxNV11vsNsI6nZmYe
         c/xE5OI9VgOCQBWQp6qcyH4fZyIdChCtI3cF/0XH8Up9XceHeTX9rldeJffiknpLa+ho
         3OBtUGu5FdvDsLXIii3dGhPySPHJGz90rkYyqINutQ9xwpjc7WadwezD6mQT8/0ODw/Z
         lOiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770777900; x=1771382700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=A0MI0iyAXY5tkuf/q+YZuaoo0d3TR2l6KKCdLxhNS0E=;
        b=UfSQsZSboSQXPAztdP9n3GZITX3u4+wuJ461J9AC2FbPOAWLiDeHRvRyGlkRz57GDi
         5f+z/Zp+WiY3LaOwGaerNBepFzKXSTJmw1+PqhqLGrMKPWcNw1c5PxLgMCqAOyl0DybX
         1agroJlMBXYfe2bChhaY8pyk3yg3aSzmQ4i5lp0YFTLW7+ZxD0f/5xQgRmMac75ZAlyE
         AoJMPr2d9dJ7AUL/ZpwFJpLZHcaeU3cr+XcJQ5OBqxCYVLcRM45y+RcKbAamp1JNJwgA
         eMy56RrlCG22/I3K81Cz2OCP/JA1zvms1ESiu6zlNDyGMrIDkdpLrtcS9jzGJNRH3wOk
         be9Q==
X-Forwarded-Encrypted: i=1; AJvYcCW6VLeqIGeprM3K8uJasbpO+44AvDOytafwnj5gD1HhXEgM19d8pUYkS6HZRUx9eUZ4j/FmULL9f+lI@vger.kernel.org
X-Gm-Message-State: AOJu0YxQFInGyce/NrX2Kbs+6vUZ6gaea1om/9C39VYbpLKulO83w2Ap
	IXxTEiTaFSUeuIfCnPY0Me8dI0hu+g0OzHtUcH4SEIM2sABMazpWR3+ApzrmN+fH9Fko8jpGDuq
	tWP+8PcahFdgm7qTKzgPyZZ5OTPszYV/YPruGtrL5USTaG5ZgMqvGqSRSBC2/mVQF1+Jedszhbb
	o0gGw0JdmfqpKbn4eWK34KlgK0GqH8C7Ug/dca1w==
X-Gm-Gg: AZuq6aL+DPwg1gG/7ikNpJF0Km7dmnsXvPFAE4459J1ADA8fxx1VFerqdpzPezZG81A
	meIGSjD6Lu6TvLe8LeW5H0vm+hS1iLoxM5aHU/uKpm9ag7nQ93tXgTJ55Ty52bd4nsIkCw3BEdO
	cSC9VGWQTdd7NT92wxVWTIRhFs9YIEgNfNYvdRqNsEIJQOeeUKrsAaI+P+6r89OrIYDHl13mNfo
	MreNdkhF6ugdqt5PxhsponwAa1ak11jKjqbR3pDmdgxoQdbIrZsv9uRVhN0iylkg8wOep8bW2y2
	Yl/78Q==
X-Received: by 2002:a05:6512:3195:b0:59e:38e3:c8f9 with SMTP id 2adb3069b0e04-59e5e1fa5c5mr153690e87.7.1770777900464;
        Tue, 10 Feb 2026 18:45:00 -0800 (PST)
X-Received: by 2002:a05:6512:3195:b0:59e:38e3:c8f9 with SMTP id
 2adb3069b0e04-59e5e1fa5c5mr153684e87.7.1770777900024; Tue, 10 Feb 2026
 18:45:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206053826.37416-1-xni@redhat.com> <20260206053826.37416-3-xni@redhat.com>
 <9bd6581f-289a-4490-af6d-f15589446e1e@fnnas.com>
In-Reply-To: <9bd6581f-289a-4490-af6d-f15589446e1e@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 11 Feb 2026 10:44:48 +0800
X-Gm-Features: AZwV_Qg7HiIybx9JM1p6LoarghyxyNZFuvJRTxODLYF4yUHxkTb8Ld-iNVxPtjo
Message-ID: <CALTww29NpmNbEb79KbVCX-rAF4o39rEd3-P1TjiDTc1OWpQiAw@mail.gmail.com>
Subject: Re: [PATCH 2/2] md/raid1: serialize overlapped io for writemostly disk
To: yukuai@fnnas.com
Cc: song@kernel.org, linux-raid@vger.kernel.org, linan666@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 11, 2026 at 10:32=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2026/2/6 13:38, Xiao Ni =E5=86=99=E9=81=93:
> > In behind mode, overlap bios for writemostly device are queued. They
> > In behind mode, bios which overlap the bio from the interval tree
> > need to wait in waitqueue. Those bios will be handled once the in-tree
> > bio finishes. They are waken up and try to get the tree lock. The bio
> > which gets the lock will be handled. So the sequence can't be guarantee=
d.
> >
> > For example
> > bio1(100,200)
> > bio2(150,200)
> > bio3(150,300)
> > The write sequence of fast device is bio1,bio2,bio3. But the write
> > sequence of slow device is bio1,bio3,bio2. This causes data corruption.
> > Replace waitqueue with a fifo list to guarantee the write sequence.
>
> To be honest, I think this is fine with the respect user won't send overl=
ap
> bios. In this case, bio1 is done in fast disk and pending in slow disk, t=
hen
> bio2 will stuck while issuing and waiting for bio1 to return from slow di=
sk.
> So send bio3 in this case is not expected, and if you do you can't guaran=
tee
> the complete order from fast disk as bio2, bio3 as well.

Hi Kuai

In write behind mode, raid1 returns bio1 to the upper layer once the
write on the fast disk finishes. The upper layer (app/filesystem)
thinks that bio1 has finished, while the write of bio1 to the slow
disk is still in progress. So bio2 will not be stuck while issuing, am
I right? If so, bio2 can be submitted to raid1 once the write of bio1
to the fast disk finishes. And bio3 can be submitted to raid1 once the
write of bio2 to fast disk finishes.

Best Regards
Xiao
>
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/md.c    |  1 -
> >   drivers/md/md.h    |  4 +++-
> >   drivers/md/raid1.c | 39 +++++++++++++++++++++++++++++----------
> >   3 files changed, 32 insertions(+), 12 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 59cd303548de..ab91d17c2d68 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -188,7 +188,6 @@ static int rdev_init_serial(struct md_rdev *rdev)
> >
> >               spin_lock_init(&serial_tmp->serial_lock);
> >               serial_tmp->serial_rb =3D RB_ROOT_CACHED;
> > -             init_waitqueue_head(&serial_tmp->serial_io_wait);
> >       }
> >
> >       rdev->serial =3D serial;
> > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > index ac84289664cd..64ffbb2efb87 100644
> > --- a/drivers/md/md.h
> > +++ b/drivers/md/md.h
> > @@ -126,7 +126,6 @@ enum sync_action {
> >   struct serial_in_rdev {
> >       struct rb_root_cached serial_rb;
> >       spinlock_t serial_lock;
> > -     wait_queue_head_t serial_io_wait;
> >   };
> >
> >   /*
> > @@ -382,6 +381,9 @@ struct serial_info {
> >       sector_t start;         /* start sector of rb node */
> >       sector_t last;          /* end sector of rb node */
> >       sector_t _subtree_last; /* highest sector in subtree of rb node *=
/
> > +     struct list_head        list_node;
> > +     struct list_head        waiters;
> > +     struct completion       ready;
> >   };
> >
> >   /*
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index a41b1ec3d695..38c73538d038 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -57,19 +57,25 @@ INTERVAL_TREE_DEFINE(struct serial_info, node, sect=
or_t, _subtree_last,
> >                    START, LAST, static inline, raid1_rb);
> >
> >   static int check_and_add_serial(struct md_rdev *rdev, struct r1bio *r=
1_bio,
> > -                             struct serial_info *si, int idx)
> > +                             struct serial_info *si)
> >   {
> >       unsigned long flags;
> >       int ret =3D 0;
> >       sector_t lo =3D r1_bio->sector;
> >       sector_t hi =3D lo + r1_bio->sectors - 1;
> > +     int idx =3D sector_to_idx(r1_bio->sector);
> >       struct serial_in_rdev *serial =3D &rdev->serial[idx];
> > +     struct serial_info *head_si;
> >
> >       spin_lock_irqsave(&serial->serial_lock, flags);
> >       /* collision happened */
> > -     if (raid1_rb_iter_first(&serial->serial_rb, lo, hi))
> > +     head_si =3D raid1_rb_iter_first(&serial->serial_rb, lo, hi);
> > +     if (head_si && head_si !=3D si) {
> > +             si->start =3D lo;
> > +             si->last =3D hi;
> > +             list_add_tail(&si->list_node, &head_si->waiters);
> >               ret =3D -EBUSY;
> > -     else {
> > +     } else if (!head_si) {
> >               si->start =3D lo;
> >               si->last =3D hi;
> >               raid1_rb_insert(si, &serial->serial_rb);
> > @@ -83,19 +89,23 @@ static void wait_for_serialization(struct md_rdev *=
rdev, struct r1bio *r1_bio)
> >   {
> >       struct mddev *mddev =3D rdev->mddev;
> >       struct serial_info *si;
> > -     int idx =3D sector_to_idx(r1_bio->sector);
> > -     struct serial_in_rdev *serial =3D &rdev->serial[idx];
> >
> >       if (WARN_ON(!mddev->serial_info_pool))
> >               return;
> >       si =3D mempool_alloc(mddev->serial_info_pool, GFP_NOIO);
> > -     wait_event(serial->serial_io_wait,
> > -                check_and_add_serial(rdev, r1_bio, si, idx) =3D=3D 0);
> > +     INIT_LIST_HEAD(&si->waiters);
> > +     INIT_LIST_HEAD(&si->list_node);
> > +     init_completion(&si->ready);
> > +     while (check_and_add_serial(rdev, r1_bio, si)) {
> > +             wait_for_completion(&si->ready);
> > +             reinit_completion(&si->ready);
> > +     }
> >   }
> >
> >   static void remove_serial(struct md_rdev *rdev, sector_t lo, sector_t=
 hi)
> >   {
> >       struct serial_info *si;
> > +     struct serial_info *first_si;
> >       unsigned long flags;
> >       int found =3D 0;
> >       struct mddev *mddev =3D rdev->mddev;
> > @@ -106,16 +116,25 @@ static void remove_serial(struct md_rdev *rdev, s=
ector_t lo, sector_t hi)
> >       for (si =3D raid1_rb_iter_first(&serial->serial_rb, lo, hi);
> >            si; si =3D raid1_rb_iter_next(si, lo, hi)) {
> >               if (si->start =3D=3D lo && si->last =3D=3D hi) {
> > -                     raid1_rb_remove(si, &serial->serial_rb);
> > -                     mempool_free(si, mddev->serial_info_pool);
> >                       found =3D 1;
> >                       break;
> >               }
> >       }
> >       if (!found)
> >               WARN(1, "The write IO is not recorded for serialization\n=
");
> > +     else {
> > +             raid1_rb_remove(si, &serial->serial_rb);
> > +             if (!list_empty(&si->waiters)) {
> > +                     first_si =3D list_first_entry(&si->waiters,
> > +                                             struct serial_info, list_=
node);
> > +                     list_del_init(&first_si->list_node);
> > +                     list_splice_init(&si->waiters, &first_si->waiters=
);
> > +                     raid1_rb_insert(first_si, &serial->serial_rb);
> > +                     complete(&first_si->ready);
> > +             }
> > +             mempool_free(si, mddev->serial_info_pool);
> > +     }
> >       spin_unlock_irqrestore(&serial->serial_lock, flags);
> > -     wake_up(&serial->serial_io_wait);
> >   }
> >
> >   /*
>
> --
> Thansk,
> Kuai
>

