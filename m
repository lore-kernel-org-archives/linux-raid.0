Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CFFA1A680B
	for <linux-raid@vger.kernel.org>; Wed,  1 Apr 2026 00:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775002976; cv=pass; b=Xm3Gx5dQaTBNlXNhVVzfgPi1gwUUKPyvNjdSsQ8fxcPc0I+IJdhyLt8efOuCkC3JXgrgERHO0cN1qbtH+9xnfBoar8gyZJDKQS1h5dm9x5Xpt+Io1UIjRtp/35BYYDjALB7qhKfsIL3i+er0lbvdVXLGLjKrcfC8WO+KbodwqO4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775002976; c=relaxed/simple;
	bh=yBBkHs/LAS6ZnYtK08lQN5v8Ue5ZEfNgP81umJUVSys=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j3VR4WPGdUrCSrSBTzmOpmydmnHk9vY2Ise1rQv42i1wA5atPp5S5BsymqYucCRPqL4pDcOavhkY0cIR9mQ0c5AICw1JEuxQZSz3i1s+CGXBEdmEa44rMnanoSibATEBoQ3LACRBzP5gIiBF1JVsbDUr51olaL8HfVmBbMmkOfA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BCX9ebhv; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=guDIW6I2; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BCX9ebhv";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="guDIW6I2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775002970;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=86/1GFAQc/b15uUZ8clkHiN+Tw+aFgT0ZroJyOo+ooY=;
	b=BCX9ebhvIEcv1yGO8QjKj5s3RHCvSTI7kRIOW6OTFmOjqGS+CAmCZvwvDnQPmRixfTempE
	3pC9io7KrTypEPqbpUz/kBnmnjn5yBukGDQwOWnFcUoLJNucIzhHdgyBGGcZnvQl5qqS6F
	THmV9pdWtpULEtAk2Vg+wAMNggnBCuk=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-355-fUMacmGEObyiDTp4h3gtXg-1; Tue, 31 Mar 2026 20:22:48 -0400
X-MC-Unique: fUMacmGEObyiDTp4h3gtXg-1
X-Mimecast-MFC-AGG-ID: fUMacmGEObyiDTp4h3gtXg_1775002967
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5a2c2448255so275527e87.0
        for <linux-raid@vger.kernel.org>; Tue, 31 Mar 2026 17:22:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775002967; cv=none;
        d=google.com; s=arc-20240605;
        b=g7fp9i6jt4/KU7zQsP0VHpHKDR5IW2z5KZikMYsEGoOhnRqnYFXocLQzvdewAYziMU
         KfC3n5TJwOyDfosXVNUYT7x9xCdzjsACbEbLdBc+g1spx0tPe75OUOMPseUTd074r5dl
         /QxbY+nHQPrL5VRL3jpQx/r7EkpxMYmWiQcMlvSqmIjxFPU9LekSI3Zd9TxtFwIjCavN
         4D4NzfZ8b5qRdNYBn3QdkYbTOXWVb39uCSPm6PbZoDuHoFHDrs4VGN61NAbUhIRR/Fa+
         gQtKDHzjGZTcXHtayUcw1FEs7WUKSV8Ujb8lPVLMFnBGVKt5mqm6ZHbilrZlPLvmtHbQ
         n4hQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=86/1GFAQc/b15uUZ8clkHiN+Tw+aFgT0ZroJyOo+ooY=;
        fh=Lme7RlNqtDaCDSJ+RugPwWsYiGBOgqs5i9rLKEkiMEE=;
        b=eVG1Yc/IJ2rby6Uuswe8ZwzmfUhff8JqtrSbuVwN4UsanDsxTCa7aw7/pZ3+rCoyny
         xynxd5XDBjj32es6pEY0TE+NApX6BvFwt/giPy5STJG/f85maDA21cklhHobUjsBV3Al
         kwRxK4n0VIsO0aE9NYERruu62xWirSsnlnSx9FH6sMMy5NsWq7c0f1RuWgMJH+ftLMsD
         PweAnNCa2lGx/jR8M6hdJUjHtWZwouXA0Lx6sy7r9RpZEXv2dqohmmGrhKCK/yu+L34O
         P6IpIqt2V7a3sSMn+oBEJh2BK3AS5MUCrDfIDz6yNzKa6AiWPQdye+c/QcTb8CCAJ3WV
         jJiw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1775002967; x=1775607767; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=86/1GFAQc/b15uUZ8clkHiN+Tw+aFgT0ZroJyOo+ooY=;
        b=guDIW6I2K5+uLoeg3g5mVB0dEzYTPu07E0tHaEqHub7t/O93NaoidYqTuvpInn1hUU
         gYn88CSFvkJTjnfWRvgz6GjYYPxQcxkbCc2kc09NkrOzU/NwDKi+OaylhYRqjLN4c+iJ
         GPzKyrDoUiCLvvO/9lBcpDVftgklSeMY/bQSm9G4F/rdgCPeKjV14H0jsnGV9+RQNz81
         LA+qwu6gp2oXp/UZ0K8fhhPcbHcZ5Xo5mTtHGeMj6eaPh5TPUo7mAFVH7pHUQRTGo94h
         PXtnlE9mfIf+hDXrXqDby9N7L9vZY+lcyJnA3687g//PxlWkArvBnj0sFO46p42S7Hhv
         c/QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775002967; x=1775607767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=86/1GFAQc/b15uUZ8clkHiN+Tw+aFgT0ZroJyOo+ooY=;
        b=KzqnIwdQBtp1NMvn7l+vZ412wAZPC4MMjjZzT2ykglTwnBEfYwj4WiWCoX9WSkgSJW
         CV+a8ksttK88RJroRynfgD2ohO8Yaey7m013bX89vgBbjf9Yl5QkWPP84pftQS74d5WI
         eazhfJcYHWSl0lpCYeLpniS5xIAr3lEHcmO8CZD/5zQ6sY4cWyPxMrvdJ9AbZUdqSAiC
         sQK2FuAXnB3jqepVxdOwAo+XztuoEUx2Rb2XGKwGhJAAUHniGt8QOoHcoTnRvpYAhDVS
         Z/VZDGgYYGVxJAnCvXf0wXF4VmfIitAvt3hpIThmqZNErnyKXn1MVLmphCkEUikhxrYw
         jVUw==
X-Forwarded-Encrypted: i=1; AJvYcCV41CTEMj7XQfK6LLnbETInxz/FPSY97rwJekvEc8lcn3H6kKTJALQES4U45uITXfjM7Scas/b5zP0a@vger.kernel.org
X-Gm-Message-State: AOJu0YzpdBobCcj9Rpl9mvrF+TuqpM83blrKX4wW/PNvFIy/lw7jY9ta
	wK+sBvYM7qTYzOCetDMYOCOOcpOcnRe/o8O4rvUb9/8BDVFq2EC/JzBz83oUY28rfrGJUDpQUDu
	0yNk3nSIDr7lE5k7JaYSKBD6x4kDPESDyoVn7T65CXHv4cKg55eayCPjY6QGln7vm8IGlH0r1Wo
	1D6J7DA6xrW0+60zmi2uX5xHSOrCrnz/vALOHXYQ==
X-Gm-Gg: ATEYQzwWqIGFAkKrQexyHu5sUqym4+eVF0LoT9riswqF5HiriYAwNlSF8621jsiMUJv
	WZKQbBiIwweNvo+srXSTNj/blgI0ua6jhcFwnv7d5YqdvjtJFr7UB7AK7Ck7Xjg45CuFbhgV5sL
	m8EyPnZBjOL/L15UpgH5QsuWw1OhVLzY+xvJZQ87Z8YHrOPfbu+8Nhi9S4cqgbva6U09kH11oEp
	wPVd1SHVmdVRa7fPFlAo/x13viwvcHjf3QAPgPswFzx2J13BFq/xi6laQoGWawT8sPrXDG7WUBh
	HEf2pA==
X-Received: by 2002:a05:6512:3b1f:b0:5a1:2c41:d28d with SMTP id 2adb3069b0e04-5a2c1ef9148mr523312e87.19.1775002966761;
        Tue, 31 Mar 2026 17:22:46 -0700 (PDT)
X-Received: by 2002:a05:6512:3b1f:b0:5a1:2c41:d28d with SMTP id
 2adb3069b0e04-5a2c1ef9148mr523298e87.19.1775002966009; Tue, 31 Mar 2026
 17:22:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260323225836.1037060-1-bmarzins@redhat.com> <CALTww29P_jZ-n9GMgFG0EW_N22vUsGAPJ5OGn5Lw8yfEpEoGOw@mail.gmail.com>
 <acrMIhAjB-HKszbs@redhat.com> <CALTww2-SE6b7bQ93ZbJ3N_Xxgrm4b8rv6Sukjt5cUVNHScPFRg@mail.gmail.com>
 <acv4A6WayrNbQEax@redhat.com>
In-Reply-To: <acv4A6WayrNbQEax@redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 1 Apr 2026 08:22:33 +0800
X-Gm-Features: AQROBzAbUB9fAWZsy2bN64IaOQW6a4ZMcQzijUt1zFZu6BW2yX4u7NCffDwI2cs
Message-ID: <CALTww29gvZBft7-WGwY_-hZCnrxbAK3AAZf-AmGKn7M1t0-0rw@mail.gmail.com>
Subject: Re: [RFC PATCH] md/raid5: Fix UAF on IO across the reshape position
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>, 
	Song Liu <song@kernel.org>, Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev, Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 1, 2026 at 12:36=E2=80=AFAM Benjamin Marzinski <bmarzins@redhat=
.com> wrote:
>
> On Tue, Mar 31, 2026 at 10:24:48AM +0800, Xiao Ni wrote:
> > On Tue, Mar 31, 2026 at 3:16=E2=80=AFAM Benjamin Marzinski <bmarzins@re=
dhat.com> wrote:
> > >
> > > On Mon, Mar 30, 2026 at 11:44:54PM +0800, Xiao Ni wrote:
> > > > On Tue, Mar 24, 2026 at 6:58=E2=80=AFAM Benjamin Marzinski <bmarzin=
s@redhat.com> wrote:
> > > > >
> > > > > If make_stripe_request() returns STRIPE_WAIT_RESHAPE,
> > > > > raid5_make_request() will free the cloned bio. But raid5_make_req=
uest()
> > > > > can call make_stripe_request() multiple times, writing to the var=
ious
> > > > > stripes. If that bio got added to the toread or towrite lists of =
a
> > > > > stripe disk in an earlier call to make_stripe_request(), then it'=
s not
> > > > > safe to just free the bio if a later part of it is found to cross=
 the
> > > > > reshape position. Doing so can lead to a UAF error, when bio_endi=
o()
> > > > > is called on the bio for the earlier stripes.
> > > > >
> > > > > Instead, raid5_make_request() needs to wait until all parts of th=
e bio
> > > > > have called bio_endio(). To do this, bios that cross the reshape
> > > > > position while the reshape can't make progress are flagged as nee=
ding a
> > > > > retry, and mddev tracks the number of bios needing a retry which =
have
> > > > > not yet completed. When raid5_make_request() has a bio that faile=
d
> > > > > make_stripe_request() with STRIPE_WAIT_RESHAPE, it waits for this
> > > > > counter to reach zero. When the bio_endio() is called for the las=
t time
> > > > > on a bio needing a retry, it decrements mddev's count of outstand=
ing
> > > > > bios needing a retry. This guarantees that raid5_make_request() d=
oesn't
> > > > > return until the cloned bio needing a retry for io across the res=
hape
> > > > > boundary is safely cleaned up.
> > > > >
> > > > > There is a simple reproducer available at [1]. Compile the kernel=
 with
> > > > > KASAN for more useful reporting when the error is triggered (this=
 is not
> > > > > necessary to see the bug).
> > > > >
> > > > > [1] https://gist.github.com/bmarzins/e48598824305cf2171289e47d724=
1fa5
> > > > >
> > > > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > > > ---
> > > > >
> > > > > I've tested this for regressions with the lvm2-testsuite raid tes=
ts. I
> > > > > have not run any md-specific tests on it.
> > > > >
> > > > >
> > > > >  drivers/md/md.c    | 30 +++++++++---------------------
> > > > >  drivers/md/md.h    |  5 ++++-
> > > > >  drivers/md/raid5.c |  8 +++++++-
> > > > >  3 files changed, 20 insertions(+), 23 deletions(-)
> > > > >
> > > > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > > > index 3ce6f9e9d38e..5ec116b9da32 100644
> > > > > --- a/drivers/md/md.c
> > > > > +++ b/drivers/md/md.c
> > > > > @@ -776,9 +776,11 @@ int mddev_init(struct mddev *mddev)
> > > > >         atomic_set(&mddev->active, 1);
> > > > >         atomic_set(&mddev->openers, 0);
> > > > >         atomic_set(&mddev->sync_seq, 0);
> > > > > +       atomic_set(&mddev->pending_retry_bios, 0);
> > > > >         spin_lock_init(&mddev->lock);
> > > > >         init_waitqueue_head(&mddev->sb_wait);
> > > > >         init_waitqueue_head(&mddev->recovery_wait);
> > > > > +       init_waitqueue_head(&mddev->retry_bios_wait);
> > > > >         mddev->reshape_position =3D MaxSector;
> > > > >         mddev->reshape_backwards =3D 0;
> > > > >         mddev->last_sync_action =3D ACTION_IDLE;
> > > > > @@ -9218,6 +9220,7 @@ static void md_end_clone_io(struct bio *bio=
)
> > > > >         struct md_io_clone *md_io_clone =3D bio->bi_private;
> > > > >         struct bio *orig_bio =3D md_io_clone->orig_bio;
> > > > >         struct mddev *mddev =3D md_io_clone->mddev;
> > > > > +       unsigned int must_retry =3D md_io_clone->must_retry;
> > > > >
> > > > >         if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enab=
led(mddev, false))
> > > > >                 md_bitmap_end(mddev, md_io_clone);
> > > > > @@ -9229,7 +9232,11 @@ static void md_end_clone_io(struct bio *bi=
o)
> > > > >                 bio_end_io_acct(orig_bio, md_io_clone->start_time=
);
> > > > >
> > > > >         bio_put(bio);
> > > > > -       bio_endio(orig_bio);
> > > > > +       if (unlikely(must_retry)) {
> > > > > +               if (atomic_dec_and_test(&mddev->pending_retry_bio=
s))
> > > > > +                       wake_up(&mddev->retry_bios_wait);
> > > > > +       } else
> > > > > +               bio_endio(orig_bio);
> > > > >         percpu_ref_put(&mddev->active_io);
> > > > >  }
> > > > >
> > > > > @@ -9243,6 +9250,7 @@ static void md_clone_bio(struct mddev *mdde=
v, struct bio **bio)
> > > > >         md_io_clone =3D container_of(clone, struct md_io_clone, b=
io_clone);
> > > > >         md_io_clone->orig_bio =3D *bio;
> > > > >         md_io_clone->mddev =3D mddev;
> > > > > +       md_io_clone->must_retry =3D 0;
> > > > >         if (blk_queue_io_stat(bdev->bd_disk->queue))
> > > > >                 md_io_clone->start_time =3D bio_start_io_acct(*bi=
o);
> > > > >
> > > > > @@ -9265,26 +9273,6 @@ void md_account_bio(struct mddev *mddev, s=
truct bio **bio)
> > > > >  }
> > > > >  EXPORT_SYMBOL_GPL(md_account_bio);
> > > > >
> > > > > -void md_free_cloned_bio(struct bio *bio)
> > > > > -{
> > > > > -       struct md_io_clone *md_io_clone =3D bio->bi_private;
> > > > > -       struct bio *orig_bio =3D md_io_clone->orig_bio;
> > > > > -       struct mddev *mddev =3D md_io_clone->mddev;
> > > > > -
> > > > > -       if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enab=
led(mddev, false))
> > > > > -               md_bitmap_end(mddev, md_io_clone);
> > > > > -
> > > > > -       if (bio->bi_status && !orig_bio->bi_status)
> > > > > -               orig_bio->bi_status =3D bio->bi_status;
> > > > > -
> > > > > -       if (md_io_clone->start_time)
> > > > > -               bio_end_io_acct(orig_bio, md_io_clone->start_time=
);
> > > > > -
> > > > > -       bio_put(bio);
> > > > > -       percpu_ref_put(&mddev->active_io);
> > > > > -}
> > > > > -EXPORT_SYMBOL_GPL(md_free_cloned_bio);
> > > > > -
> > > > >  /* md_allow_write(mddev)
> > > > >   * Calling this ensures that the array is marked 'active' so tha=
t writes
> > > > >   * may proceed without blocking.  It is important to call this b=
efore
> > > > > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > > > > index ac84289664cd..49a231f11676 100644
> > > > > --- a/drivers/md/md.h
> > > > > +++ b/drivers/md/md.h
> > > > > @@ -626,6 +626,9 @@ struct mddev {
> > > > >
> > > > >         /* The sequence number for sync thread */
> > > > >         atomic_t sync_seq;
> > > > > +
> > > > > +       wait_queue_head_t               retry_bios_wait;
> > > > > +       atomic_t                        pending_retry_bios;
> > > > >  };
> > > > >
> > > > >  enum recovery_flags {
> > > > > @@ -877,6 +880,7 @@ struct md_io_clone {
> > > > >         sector_t        offset;
> > > > >         unsigned long   sectors;
> > > > >         enum stat_group rw;
> > > > > +       unsigned int    must_retry;
> > > > >         struct bio      bio_clone;
> > > > >  };
> > > > >
> > > > > @@ -917,7 +921,6 @@ extern void md_finish_reshape(struct mddev *m=
ddev);
> > > > >  void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *=
rdev,
> > > > >                         struct bio *bio, sector_t start, sector_t=
 size);
> > > > >  void md_account_bio(struct mddev *mddev, struct bio **bio);
> > > > > -void md_free_cloned_bio(struct bio *bio);
> > > > >
> > > > >  extern bool __must_check md_flush_request(struct mddev *mddev, s=
truct bio *bio);
> > > > >  void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev=
,
> > > > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > > > index a8e8d431071b..fb78a757f2fd 100644
> > > > > --- a/drivers/md/raid5.c
> > > > > +++ b/drivers/md/raid5.c
> > > > > @@ -6217,7 +6217,13 @@ static bool raid5_make_request(struct mdde=
v *mddev, struct bio * bi)
> > > > >
> > > > >         mempool_free(ctx, conf->ctx_pool);
> > > > >         if (res =3D=3D STRIPE_WAIT_RESHAPE) {
> > > > > -               md_free_cloned_bio(bi);
> > > > > +               struct md_io_clone *md_io_clone =3D bi->bi_privat=
e;
> > > > > +
> > > > > +               md_io_clone->must_retry =3D 1;
> > > > > +               atomic_inc(&mddev->pending_retry_bios);
> > > > > +               bio_endio(bi);
> > > > > +               wait_event(mddev->retry_bios_wait,
> > > > > +                          atomic_read(&mddev->pending_retry_bios=
)=3D=3D0);
> > > >
> > > > Hi Ben
> > > >
> > > > There is a problem here. The new counter pending_retry_bios above
> > > > doesn't represent the bios which have been added to stripes. So uaf
> > > > still can happen.
> > >
> > > I don't think it can. That counter won't be zero until there are no b=
ios
> > > that need to get retried. So we way end up waiting too long, but we
> > > shouldn't ever end up not waiting long enough.
> >
> > Ah, yes, you're right. I thought wrongly. The counter tracks multiple
> > threads that encounter BLK_STS_RESOURCE. For each thread,
> > md_end_clone_bio is called only when all bios return. But why do
> > different threads need to sync at raid5_make_request?
> >
> >
> > >
> > > > Do we need to add a new counter?
> > >
> > > I did it that way because I wanted to avoid growing md_io_clone
> > > ("must_retry" fit nicely in a hole in the structure, so it didn't tak=
e
> > > up any extra space). But if you are fine with adding the extra
> >
> > Nice design.
> >
> > > reshape_completion pointer to md_io_clone, then your way avoids the
> > > chance that we might wait when we don't need to.
> >
> > If you mention the threads sync here, yes.
>
> I can certainly add comments explaining why I left off the READ_ONCE(),
> WRITE_ONCE() (actually, there's no real reason not to keep the
> WRITE_ONCE, since that's not in the fast path) if you think it makes
> sense to leave them off.
>
> I'm fine with either my or your code for to deal with the waiting,
> whichever you think makes more sense. Since this is a very hard bug to
> hit, and the fix involves adding extra data to every bio and extra code
> in the end_io function that all the raid bios call, I wanted to make the
> impact as small as possible. But md_io_clone is still 8 bytes away from
> filling up 3 cachelines (at 64 bytes a cacheline), so there's space to
> add the reshape_completion pointer without increaseing the number of
> cachelines, which means that your solution for waiting is probably the
> way to go, unless you think something else might end up needing that
> space.

Thanks. After thinking, as you said, this is a corner case. So both
ways are fine with me also. Let's wait for Kuai's decision.

Regards
Xiao
>
> -Ben
>
> > >
> > > > Because
> > > > md_end_clone_io is only called when all bios return. How about
> > > > something like:
> > > >
> > > > md_end_clone_io
> > > > +       if (unlikely(READ_ONCE(md_io_clone->waiting_reshape))) {
> > > > +               complete(md_io_clone->reshape_completion);
> > > > +       } else {
> > > > +               bio_endio(orig_bio);
> > > > +       }
> > > >
> > > > raid5_make_request:
> > > >
> > > >         if (res =3D=3D STRIPE_WAIT_RESHAPE) {
> > > > -               md_free_cloned_bio(bi);
> > > > +               struct md_io_clone *md_io_clone =3D bi->bi_private;
> > > > +               struct completion done;
> > > > +
> > > > +               init_completion(&done);
> > > > +               md_io_clone->reshape_completion =3D &done;
> > > > +               WRITE_ONCE(md_io_clone->waiting_reshape, 1);
> > > > +
> > > > +               bio_endio(bi);
> > > > +
> > > > +               wait_for_completion(&done);
> > >
> > > This looks fine.
> > >
> > > I'm pretty sure that the READ_ONCE() and WRITE_ONCE() are unnecessary=
.
> > > First, theres no chance that these operations will ever happen at the
> > > same time and we're just writing a 1, so there's no chance of tearing=
.
> >
> > For the first point, I have a question. They can't happen
> > simultaneously. But the cache of different CPUs may contain different
> > values.
> >
> > >
> > > The compiler can't reorder setting md_io_clone->waiting_reshape to af=
er
> > > bio_endio(), since bio_endio can free md_io_clone. Also the compiler
> > > can't reorder reading it to before calling md_end_clone_io() from
> > > bio_endio(), obviously.
> >
> > Thanks very much for pointing this out.
> >
> > >
> > > If the bio was never chained, then there can't be a race, since only
> > > raid5_make_request() will be calling bio_endio(). waiting_reshape wil=
l
> > > be read by the same process that sets it.
> > >
> > > If the bio was chained, then like you said, md_end_clone_io() will on=
ly
> > > get called by the final caller of bio_endio(). This is determined by
> > > bio_remaining_done(), which guarantees a full memory barrier for
> > > atomic_dec_and_test(&bio->__bi_remaining).
> >
> > Nice analysis! Thanks.
> >
> > >
> > > Since we know the compiler will keep these instructions on the proper
> > > size of a full memory barrier, I'm pretty sure that this is concurren=
cy
> > > race free, even without the READ_ONCE() and WRITE_ONCE(). Like with
> > > trying to avoid growing md_io_clone, I was trying to keep
> > > md_end_clone_io() as fast as possible (at least on architectures wher=
e
> > > READ_ONCE can have more of a performance impact) Again, if I'm
> > > overthinking this (or if my concurrency argument is flawed) feel free=
 to
> > > ignore me.
> >
> > Thanks for your patience in explaining the concurrency problem. I
> > agree with you. And it's better to add comments that describe the
> > reason and it will help people understand it better.
> >
> > By the way, the md raid maintainer's email has changed. I fixed the
> > email address in to list.
> >
> > Regards
> > Xiao
> >
> > >
> > > -Ben
> > >
> > > > Best Regards
> > > > Xiao
> > > >
> > > >
> > > > >                 return false;
> > > > >         }
> > > >
> > > > >
> > > > > --
> > > > > 2.53.0
> > > > >
> > >
>

