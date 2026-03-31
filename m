Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218D219D074
	for <linux-raid@vger.kernel.org>; Tue, 31 Mar 2026 02:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774923907; cv=pass; b=rYg4oM/LaHXV5gZh0GzMYRBRLS1dWYMResb0bkw0XKTuWcfsdsNmkmQNUvpHAqLwnDNCtYkYwDxXOzeKu+MhqbHfh6p1kDugrZJY1H5dXFCQL6RcIpghsPxDQi42ycm7MLoggBNRtnFJzGQ9URv7DKBJ5umdCw4PL1hqQoNjk9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774923907; c=relaxed/simple;
	bh=53waOxUAU8GIqETOQkUAx2zTki5kVHzmbzSTUC/qWTg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U8+Yzm5ayvcazVQXXas4JR9o3E9R7X8iX3NHCVZPys0gZgl6mt5qJJbpUbvkhdibQnkC6/rMglFtcWVS3VE0VNPfPBCrkYxpF6m8+NI2GjdJPSdCvK7h4hHo4KmbWgD0QSakM1Ho0YyeYmVGVSr6Vui8NGU4k0h1hHFO+VV2eEY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GaZp31tx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZKh917SL; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GaZp31tx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZKh917SL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774923904;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lzqRMsrsPMa4VNMQGbFosoNwmkTRdKsCUylOoUrvuG8=;
	b=GaZp31txP6y+AXbITPOsLpa03s1S0zsQyJaBA5OH9MaGFZ5G0SBTaEr70m4XW3C5hVpTS1
	0Upok5bIrqUfQKLAkZjSYTIjs+coGJK14ESO/yXD2QZ3r5Zs1chTKUMUlsYKSmdvKohaxS
	ztps57hrtlsT4wmbTLTDF7Pu6vnldRc=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-32-Ow-ultJeNeS4wIb3yA2H_Q-1; Mon, 30 Mar 2026 22:25:02 -0400
X-MC-Unique: Ow-ultJeNeS4wIb3yA2H_Q-1
X-Mimecast-MFC-AGG-ID: Ow-ultJeNeS4wIb3yA2H_Q_1774923901
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5a12f7bb92fso2914884e87.2
        for <linux-raid@vger.kernel.org>; Mon, 30 Mar 2026 19:25:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774923901; cv=none;
        d=google.com; s=arc-20240605;
        b=IvvdFwLZ0QWmaoiJESt3BDssFOV/jDSaNJDHhQJOlUwArnW7V5nB307Jr0fGjXMEo9
         yKqXrh+VRmO6zRfyExeG0mwtnG5oxJ4j96xIOlGdmP2Bh/Bo/rN/ZIogHYJHApslDE4g
         e8SCeXLpFH+bESqoGAcdlF0jyxywlCiUXx5QVnA0Ct2L6SklTBKhpOkhYwq1aq5MI6Wq
         va+tJHX2Nqwz1ff4qG2ZaaYx3mIc7qnobrZAGG2XNcKBTDFX5//2mO/4UkaHqUvhAejG
         b08xADsW68DAlSwNQ0Xi/fah5benuhnJijoJFchrkDfD1L1j2olbk/C2Kc4P32ybv7Ml
         k88Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lzqRMsrsPMa4VNMQGbFosoNwmkTRdKsCUylOoUrvuG8=;
        fh=C4rt0HF0XHYHxQJ/Vfcw+7JEJCuHrmEM15oMhh2Hb/4=;
        b=K45ANAFhcdWr8VFo6TaeBndqzIT+3XD5q0oo153aW7Y4ZyOJO9SmG+uO8d+4lWh4jR
         SNPqnVcYKsxkN88gfUajf8ItXY7jWa3WQYBmGzjgeSYzEBN5s4iUGyoe6fIec7q/A/2C
         NPwLqDPk6Z8ymdud5J+UPrNvyF8xOWmmuFYin405X5GQ/NVDoFFmK4NsUn0La2qJipOz
         UasxfDWqdRm2ObGup0MJEcaQSjq7GiMk+iVRh6g/FoCyWZrPzwhGQMolG0NwJYhD5qQV
         ovq3HJQdKxOvwOL65e6HcoDWG6dwBAFYh7JGTj9Z2qj4HxJPoTALPx3phV3oIAqe6QmB
         OjrQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1774923901; x=1775528701; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lzqRMsrsPMa4VNMQGbFosoNwmkTRdKsCUylOoUrvuG8=;
        b=ZKh917SLJD0MBb534XZ1uMgKvtV959KF9qSH4sgtwBg+xN1wbzZdSkZcTggdPSAoxA
         S2mX0Ns/ohcU8xV0/w7Cb9a6HayTlDElOzNkvjkwldbUiZUlnNVgnm33coMO8BTpFUpO
         HbDjgaBNE5LGCi/sdBUq5Bbi4Gn7WAAH1A+ot053s3zbCMti6tKJZ4xKDg955i1XLKgA
         x7wKkFbcwXdYhkiSFa6inhBjD16RCRPPUqSihocWIjrly0ku6msr8rbWlLp1DGNtc5HP
         Mwr8mlV2aB/O28Lv4yz/9fuYOL6U6SDbiUNoHIJtgvHjyn9L3BWJqPlOJTGVP4Re3V7P
         vghw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774923901; x=1775528701;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lzqRMsrsPMa4VNMQGbFosoNwmkTRdKsCUylOoUrvuG8=;
        b=T4oGWcUYWOoZMz0mQ/NIcp2xpsd8PzzzoHB8YkfirpMsJk+u+qa+acLpA3vooNsA2l
         qgw2ggAcgQuNQUjNWTsdtdM6HbAgCeAzOt7sQTmacONGy9jPcbXvL+Lo0nHSWTj0au1B
         E377UI0qh0ybyy8qWm1aMjuMJAr4aCQHzNMsds29xntzkcInMH2ychreGrnY6C25+57F
         G79/qWdtV3EtqLC+XYJywLSQF08sIYVMTuTTmLgc1kR9w+IgxZAO+2A4lFgmQUhJjtjR
         4ZWia+P5TYjEtgSRllBQKXAFfBNMCDp4kJ6KvMj/LwhWh2hi0hvDCwUMfmanz79GHu8j
         rFoQ==
X-Forwarded-Encrypted: i=1; AJvYcCUwhy9nMUlB8TjiTRnUO8nJRMQn5HcKpNg3vTFd42togmEy4nBc1w1akomJz4PZCm43r0j/Tznz0g/s@vger.kernel.org
X-Gm-Message-State: AOJu0Yx20Hcl8qsCK6mEk97FX42G/7FCAuSDCd5wjdcm4+YToZutKDXS
	mpmBtS9dHBnxVbsKrtJ8mXXwVptqOfCv1UuXvVQqH/FS1Qa01QO5i7ht+gPhqtNfSPwv05IcoO4
	kPyx4e25DaKvcoq7VZ0dkELEg64zkO4gitGmlPd/UZOoO/25LoSvobRC2yLW0VnAQnG5xRYc1tj
	9/hr/2kBijYeG2R87oWeM9KteuPQhrHcCfG0JZtA==
X-Gm-Gg: ATEYQzzrzOUapxZZQ8I7QcMtpvC1XEUu1O0O6IS2zxUNjUc9lxZZ30oi5IeDiGntJ+0
	qTyxIYIhlKjCIKwKLCrE2FJinwngdn2br5Zs/BwGwLumHvYKsTRiG3FFkCNapMsT5BAORVz6Nu7
	ywwHQ8YuyGhMo8QAAq1trFGEy9Ya0ODpOzPc6RZ6bDALc/57UkILjn1MzciXdfEWZl4NPR+MkdA
	9pTGhna8AnbRjC0J456YgfzTAX7Hi6Esd+hQaguTWl4ZPzhwIoUHANNv9DxFCN2ZzaGzj+Hoi15
	g1EWwg==
X-Received: by 2002:a05:6512:3d1c:b0:5a2:b842:6850 with SMTP id 2adb3069b0e04-5a2b842695cmr1489746e87.15.1774923900564;
        Mon, 30 Mar 2026 19:25:00 -0700 (PDT)
X-Received: by 2002:a05:6512:3d1c:b0:5a2:b842:6850 with SMTP id
 2adb3069b0e04-5a2b842695cmr1489732e87.15.1774923900001; Mon, 30 Mar 2026
 19:25:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260323225836.1037060-1-bmarzins@redhat.com> <CALTww29P_jZ-n9GMgFG0EW_N22vUsGAPJ5OGn5Lw8yfEpEoGOw@mail.gmail.com>
 <acrMIhAjB-HKszbs@redhat.com>
In-Reply-To: <acrMIhAjB-HKszbs@redhat.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 31 Mar 2026 10:24:48 +0800
X-Gm-Features: AQROBzAoNeL_79_n60BBdgTQ5ZkqBekFQ4T4471TwNRsR_066n-TnL_fljoedq8
Message-ID: <CALTww2-SE6b7bQ93ZbJ3N_Xxgrm4b8rv6Sukjt5cUVNHScPFRg@mail.gmail.com>
Subject: Re: [RFC PATCH] md/raid5: Fix UAF on IO across the reshape position
To: Benjamin Marzinski <bmarzins@redhat.com>, Yu Kuai <yukuai@fnnas.com>
Cc: Song Liu <song@kernel.org>, Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org, 
	dm-devel@lists.linux.dev, Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 31, 2026 at 3:16=E2=80=AFAM Benjamin Marzinski <bmarzins@redhat=
.com> wrote:
>
> On Mon, Mar 30, 2026 at 11:44:54PM +0800, Xiao Ni wrote:
> > On Tue, Mar 24, 2026 at 6:58=E2=80=AFAM Benjamin Marzinski <bmarzins@re=
dhat.com> wrote:
> > >
> > > If make_stripe_request() returns STRIPE_WAIT_RESHAPE,
> > > raid5_make_request() will free the cloned bio. But raid5_make_request=
()
> > > can call make_stripe_request() multiple times, writing to the various
> > > stripes. If that bio got added to the toread or towrite lists of a
> > > stripe disk in an earlier call to make_stripe_request(), then it's no=
t
> > > safe to just free the bio if a later part of it is found to cross the
> > > reshape position. Doing so can lead to a UAF error, when bio_endio()
> > > is called on the bio for the earlier stripes.
> > >
> > > Instead, raid5_make_request() needs to wait until all parts of the bi=
o
> > > have called bio_endio(). To do this, bios that cross the reshape
> > > position while the reshape can't make progress are flagged as needing=
 a
> > > retry, and mddev tracks the number of bios needing a retry which have
> > > not yet completed. When raid5_make_request() has a bio that failed
> > > make_stripe_request() with STRIPE_WAIT_RESHAPE, it waits for this
> > > counter to reach zero. When the bio_endio() is called for the last ti=
me
> > > on a bio needing a retry, it decrements mddev's count of outstanding
> > > bios needing a retry. This guarantees that raid5_make_request() doesn=
't
> > > return until the cloned bio needing a retry for io across the reshape
> > > boundary is safely cleaned up.
> > >
> > > There is a simple reproducer available at [1]. Compile the kernel wit=
h
> > > KASAN for more useful reporting when the error is triggered (this is =
not
> > > necessary to see the bug).
> > >
> > > [1] https://gist.github.com/bmarzins/e48598824305cf2171289e47d7241fa5
> > >
> > > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > > ---
> > >
> > > I've tested this for regressions with the lvm2-testsuite raid tests. =
I
> > > have not run any md-specific tests on it.
> > >
> > >
> > >  drivers/md/md.c    | 30 +++++++++---------------------
> > >  drivers/md/md.h    |  5 ++++-
> > >  drivers/md/raid5.c |  8 +++++++-
> > >  3 files changed, 20 insertions(+), 23 deletions(-)
> > >
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index 3ce6f9e9d38e..5ec116b9da32 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -776,9 +776,11 @@ int mddev_init(struct mddev *mddev)
> > >         atomic_set(&mddev->active, 1);
> > >         atomic_set(&mddev->openers, 0);
> > >         atomic_set(&mddev->sync_seq, 0);
> > > +       atomic_set(&mddev->pending_retry_bios, 0);
> > >         spin_lock_init(&mddev->lock);
> > >         init_waitqueue_head(&mddev->sb_wait);
> > >         init_waitqueue_head(&mddev->recovery_wait);
> > > +       init_waitqueue_head(&mddev->retry_bios_wait);
> > >         mddev->reshape_position =3D MaxSector;
> > >         mddev->reshape_backwards =3D 0;
> > >         mddev->last_sync_action =3D ACTION_IDLE;
> > > @@ -9218,6 +9220,7 @@ static void md_end_clone_io(struct bio *bio)
> > >         struct md_io_clone *md_io_clone =3D bio->bi_private;
> > >         struct bio *orig_bio =3D md_io_clone->orig_bio;
> > >         struct mddev *mddev =3D md_io_clone->mddev;
> > > +       unsigned int must_retry =3D md_io_clone->must_retry;
> > >
> > >         if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(=
mddev, false))
> > >                 md_bitmap_end(mddev, md_io_clone);
> > > @@ -9229,7 +9232,11 @@ static void md_end_clone_io(struct bio *bio)
> > >                 bio_end_io_acct(orig_bio, md_io_clone->start_time);
> > >
> > >         bio_put(bio);
> > > -       bio_endio(orig_bio);
> > > +       if (unlikely(must_retry)) {
> > > +               if (atomic_dec_and_test(&mddev->pending_retry_bios))
> > > +                       wake_up(&mddev->retry_bios_wait);
> > > +       } else
> > > +               bio_endio(orig_bio);
> > >         percpu_ref_put(&mddev->active_io);
> > >  }
> > >
> > > @@ -9243,6 +9250,7 @@ static void md_clone_bio(struct mddev *mddev, s=
truct bio **bio)
> > >         md_io_clone =3D container_of(clone, struct md_io_clone, bio_c=
lone);
> > >         md_io_clone->orig_bio =3D *bio;
> > >         md_io_clone->mddev =3D mddev;
> > > +       md_io_clone->must_retry =3D 0;
> > >         if (blk_queue_io_stat(bdev->bd_disk->queue))
> > >                 md_io_clone->start_time =3D bio_start_io_acct(*bio);
> > >
> > > @@ -9265,26 +9273,6 @@ void md_account_bio(struct mddev *mddev, struc=
t bio **bio)
> > >  }
> > >  EXPORT_SYMBOL_GPL(md_account_bio);
> > >
> > > -void md_free_cloned_bio(struct bio *bio)
> > > -{
> > > -       struct md_io_clone *md_io_clone =3D bio->bi_private;
> > > -       struct bio *orig_bio =3D md_io_clone->orig_bio;
> > > -       struct mddev *mddev =3D md_io_clone->mddev;
> > > -
> > > -       if (bio_data_dir(orig_bio) =3D=3D WRITE && md_bitmap_enabled(=
mddev, false))
> > > -               md_bitmap_end(mddev, md_io_clone);
> > > -
> > > -       if (bio->bi_status && !orig_bio->bi_status)
> > > -               orig_bio->bi_status =3D bio->bi_status;
> > > -
> > > -       if (md_io_clone->start_time)
> > > -               bio_end_io_acct(orig_bio, md_io_clone->start_time);
> > > -
> > > -       bio_put(bio);
> > > -       percpu_ref_put(&mddev->active_io);
> > > -}
> > > -EXPORT_SYMBOL_GPL(md_free_cloned_bio);
> > > -
> > >  /* md_allow_write(mddev)
> > >   * Calling this ensures that the array is marked 'active' so that wr=
ites
> > >   * may proceed without blocking.  It is important to call this befor=
e
> > > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > > index ac84289664cd..49a231f11676 100644
> > > --- a/drivers/md/md.h
> > > +++ b/drivers/md/md.h
> > > @@ -626,6 +626,9 @@ struct mddev {
> > >
> > >         /* The sequence number for sync thread */
> > >         atomic_t sync_seq;
> > > +
> > > +       wait_queue_head_t               retry_bios_wait;
> > > +       atomic_t                        pending_retry_bios;
> > >  };
> > >
> > >  enum recovery_flags {
> > > @@ -877,6 +880,7 @@ struct md_io_clone {
> > >         sector_t        offset;
> > >         unsigned long   sectors;
> > >         enum stat_group rw;
> > > +       unsigned int    must_retry;
> > >         struct bio      bio_clone;
> > >  };
> > >
> > > @@ -917,7 +921,6 @@ extern void md_finish_reshape(struct mddev *mddev=
);
> > >  void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev=
,
> > >                         struct bio *bio, sector_t start, sector_t siz=
e);
> > >  void md_account_bio(struct mddev *mddev, struct bio **bio);
> > > -void md_free_cloned_bio(struct bio *bio);
> > >
> > >  extern bool __must_check md_flush_request(struct mddev *mddev, struc=
t bio *bio);
> > >  void md_write_metadata(struct mddev *mddev, struct md_rdev *rdev,
> > > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > index a8e8d431071b..fb78a757f2fd 100644
> > > --- a/drivers/md/raid5.c
> > > +++ b/drivers/md/raid5.c
> > > @@ -6217,7 +6217,13 @@ static bool raid5_make_request(struct mddev *m=
ddev, struct bio * bi)
> > >
> > >         mempool_free(ctx, conf->ctx_pool);
> > >         if (res =3D=3D STRIPE_WAIT_RESHAPE) {
> > > -               md_free_cloned_bio(bi);
> > > +               struct md_io_clone *md_io_clone =3D bi->bi_private;
> > > +
> > > +               md_io_clone->must_retry =3D 1;
> > > +               atomic_inc(&mddev->pending_retry_bios);
> > > +               bio_endio(bi);
> > > +               wait_event(mddev->retry_bios_wait,
> > > +                          atomic_read(&mddev->pending_retry_bios)=3D=
=3D0);
> >
> > Hi Ben
> >
> > There is a problem here. The new counter pending_retry_bios above
> > doesn't represent the bios which have been added to stripes. So uaf
> > still can happen.
>
> I don't think it can. That counter won't be zero until there are no bios
> that need to get retried. So we way end up waiting too long, but we
> shouldn't ever end up not waiting long enough.

Ah, yes, you're right. I thought wrongly. The counter tracks multiple
threads that encounter BLK_STS_RESOURCE. For each thread,
md_end_clone_bio is called only when all bios return. But why do
different threads need to sync at raid5_make_request?


>
> > Do we need to add a new counter?
>
> I did it that way because I wanted to avoid growing md_io_clone
> ("must_retry" fit nicely in a hole in the structure, so it didn't take
> up any extra space). But if you are fine with adding the extra

Nice design.

> reshape_completion pointer to md_io_clone, then your way avoids the
> chance that we might wait when we don't need to.

If you mention the threads sync here, yes.

>
> > Because
> > md_end_clone_io is only called when all bios return. How about
> > something like:
> >
> > md_end_clone_io
> > +       if (unlikely(READ_ONCE(md_io_clone->waiting_reshape))) {
> > +               complete(md_io_clone->reshape_completion);
> > +       } else {
> > +               bio_endio(orig_bio);
> > +       }
> >
> > raid5_make_request:
> >
> >         if (res =3D=3D STRIPE_WAIT_RESHAPE) {
> > -               md_free_cloned_bio(bi);
> > +               struct md_io_clone *md_io_clone =3D bi->bi_private;
> > +               struct completion done;
> > +
> > +               init_completion(&done);
> > +               md_io_clone->reshape_completion =3D &done;
> > +               WRITE_ONCE(md_io_clone->waiting_reshape, 1);
> > +
> > +               bio_endio(bi);
> > +
> > +               wait_for_completion(&done);
>
> This looks fine.
>
> I'm pretty sure that the READ_ONCE() and WRITE_ONCE() are unnecessary.
> First, theres no chance that these operations will ever happen at the
> same time and we're just writing a 1, so there's no chance of tearing.

For the first point, I have a question. They can't happen
simultaneously. But the cache of different CPUs may contain different
values.

>
> The compiler can't reorder setting md_io_clone->waiting_reshape to afer
> bio_endio(), since bio_endio can free md_io_clone. Also the compiler
> can't reorder reading it to before calling md_end_clone_io() from
> bio_endio(), obviously.

Thanks very much for pointing this out.

>
> If the bio was never chained, then there can't be a race, since only
> raid5_make_request() will be calling bio_endio(). waiting_reshape will
> be read by the same process that sets it.
>
> If the bio was chained, then like you said, md_end_clone_io() will only
> get called by the final caller of bio_endio(). This is determined by
> bio_remaining_done(), which guarantees a full memory barrier for
> atomic_dec_and_test(&bio->__bi_remaining).

Nice analysis! Thanks.

>
> Since we know the compiler will keep these instructions on the proper
> size of a full memory barrier, I'm pretty sure that this is concurrency
> race free, even without the READ_ONCE() and WRITE_ONCE(). Like with
> trying to avoid growing md_io_clone, I was trying to keep
> md_end_clone_io() as fast as possible (at least on architectures where
> READ_ONCE can have more of a performance impact) Again, if I'm
> overthinking this (or if my concurrency argument is flawed) feel free to
> ignore me.

Thanks for your patience in explaining the concurrency problem. I
agree with you. And it's better to add comments that describe the
reason and it will help people understand it better.

By the way, the md raid maintainer's email has changed. I fixed the
email address in to list.

Regards
Xiao

>
> -Ben
>
> > Best Regards
> > Xiao
> >
> >
> > >                 return false;
> > >         }
> >
> > >
> > > --
> > > 2.53.0
> > >
>

