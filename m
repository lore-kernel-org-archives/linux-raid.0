Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794559882;
	b=Ykj9czcfPpQSKAQylxJVPZfvX5fRaqcU8jesnPv8dnmKWXonZ+I9Wl3R2nht/hu7mONq
	 ITw/iHPsyAMy/yrSIcWUI4J6ZiieoSEEeNLU05wbC11zas8OqsmOFsAqETN0aL3mZg5Nc
	 6inIYuUIV8Ok2w2eps8b/5Kw8HMhImPaV9uVZLx7zkvcrRo6JjjMnSghsIfien2NLVtpe
	 rMdVZkoombfrcDgECkT9na6UJanvRyxdg11mPSgQMq+zA+7Xyic2APJWFCT/QnVNby762
	 Z9rlhw7ViS2KlUPk62ekqpGCkSz702ePx48yQigMzH0Wy+BWD4RO8tB3rG9IxP3Rmqw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794559882;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=c5yfwfHf+asJs6SrRY3FRltZS6t5SdBG+HqpZbiOuiQ=;
	b=yWF03Yh/7zS1n8ambDIMz2g+q10alPKVWuneVLrMF80y4Gaj34AHWvou50M5sgMSfUeY
	 jCMtIPA2rLXMwsBMyK4n/Bb8Dq6I4w54JD6rPA4KEcxxDU4kAaxOeAtU1FVhik5sSs5tb
	 SjXNT42jhOAT0r+3a+2EzwqjiuFYpiLZTxHRHqp5w8RdAzeP1oLCguNOBdzs8xraryH7i
	 +/R0YEYOSPb3ABUkhQpou+fFOJjbpmYJhr0yHzPhMO+BeKCrV0niDyBa334pyAe/Lp69e
	 dhsBoNpfmnCeU3ubH/89748I9nzyyCCIB1p62NwW9ZHXWEZ+cqtynbVczA3YS8JvJUw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloud.ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=iiJpIDnv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.43
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8192A606A88B
	for <linux-raid@vger.kernel.org>; Fri, 13 Nov 2026 08:51:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8192A606A88B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=iiJpIDnv
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5c00b0866b0so59407e87.0
        for <linux-raid@vger.kernel.org>; Fri, 13 Nov 2026 00:51:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794559879; cv=none;
        d=google.com; s=arc-20260327;
        b=kPZDTDXzGnfCJ+GW7P3SBr7zWLKcmLrOEAu0BXamISVpBbAsoGAUrFRNwXVUkxbgEf
         q1DO78DBIfRiH4bu99yLbM9dgYj+Nu1h3yvUYK1QKEdFagh/fxztOdh0qcq6MkAb+MQF
         0eyvtWjwTI/F9XgTRE5lrjm4//2uQ1o9c/ZTwEaLm47iAsD7vbTL+i7E3lN5Elu47dhp
         M4XE/Lqwh2LJb5S4Uqej6AP2NCeQpC8fPAGkUlGYX6g+4QZ+aR1M5sdvBHd2j6FaNq+u
         0viPQW50fHfz3Dj3UmqrYSZONh6rawqtc5UjYho9GQYeNcr5lr1X4+7VORW1e5etwILi
         jQZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c5yfwfHf+asJs6SrRY3FRltZS6t5SdBG+HqpZbiOuiQ=;
        fh=wENDpBpPQBX0wUnJ5U4TGEb5n/ngLoCXl8+Kn9tuxlE=;
        b=LyAuJg3oG280x0l9sCZh7uxE8C1tNASjX9Q8hY508UCY5U61nVY5zdC07qWzSrvZpb
         Q0tMZw36B96LdMkvo55NiwQsbzD8LsPXNtQy+CO1lSL60TBwnVmTO3ZK2cmLN+8t/SJb
         1UsCpBdpboHb0XXaOaVw8Rc+dCaMBGXp9NsiKOmwSCx06YKIAyHBDvy5hrcUbdaus0bu
         qbyU50orwyI1vGLtrqc0ppjVdEBa1UBqw6l1rWVmfCLcByeF1U6Qk9pHxzQR0mrZMPwY
         Ls1D28Iz8hOiC3FuAz1SZ2R8F0awp9JsT8Dq0fYefMbdk7dNmntkULTY1QxwORwwZuDy
         16iQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1794559879; x=1795164679; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=c5yfwfHf+asJs6SrRY3FRltZS6t5SdBG+HqpZbiOuiQ=;
        b=iiJpIDnvpaPQ/XzHmx31nXgzQj/jyfvEb5mFvemtmZNMH28jzf3Sbkm/ZUnM056fK/
         ax9F77P/UjzRNUKsQo8Pg5cW0t+UQbb1/Kopbg16AE+Of/awW13fVqfrMdGhBbGoTcMx
         zq5wjt2xCkY+HW/Ood0dEcSZAjURzuL1MFCoU+5af0PmNvRS0XY8q14BVghRgYETNd1I
         bfSuAyo88nm2cCb1TYATUuEfKGt0i+ek45ItWMfn4mjX4XmlaX3Z+0ACUZEEgYmejZNx
         unbd1sPbq/CoyH0DUJXWpU8887Q0MImcltjNeNsUISdVnJVuOiB/yzeXl9Y1Xy3ZpqOE
         GlgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794559879; x=1795164679;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=c5yfwfHf+asJs6SrRY3FRltZS6t5SdBG+HqpZbiOuiQ=;
        b=ip4v6gcBjEcsBNIhR1n+HqHcJWV7XVUNtcXoNHEiILW7VrdQXDH5T/2BIP5eZZQgSU
         +l1lTDzZmrh1Ke1d+qxwmRsp4czYQE+VMXUS+UojmsIGcNQvo2HeVrPrbSsYyCQQslWk
         fkNzsqzs0tagp9wztpLSnAd7aSTVmcSLp+nsu+zlj/RqAlJdcdWLCt3pbmPsxYb/WDdF
         xl+BWKm5FdU/sje91ysDQQQmTigDrYP8a3SZv8DFR3qm2MJqJICKP2l89gHWfwDLg2E/
         Id5Z08x9grvHNn9NYtbOGOGe9kbdpsGRR1IK96wMfv8Q703QS1ingEf0J+CCYVKMDazt
         UbBg==
X-Forwarded-Encrypted: i=1; AL+hErHwo7F3XzubZYGTAQZ0hLnbb2MAn/X9fkUdJDWamBG4xMJXBLzZlqr5hcuzKWyxOvHaNihwfCgZwFQ1@vger.kernel.org
X-Gm-Message-State: APuU4Z++NVWZGQ8hCSE4Q8GdDUp8KYqD2ivrqJW2cWh4uyFDanYfh4Cx
	Zu7m+iqfp6kS5mW0WiMVHvyOsYR0i2TBKLmVi3BMnpVeTvzY94R70FHbD5vD7oOqmmAfIEiYfBQ
	J2ETQ85GYjqTVDoXucsS9nsNPRaqVfD3RAjRoAv3PMQ==
X-Gm-Gg: AYBFou08zYOsXL6cqwDyXN4OShJUjldnyrJC7N2P1rrY7CvwVLEN5l02C2R4Rhlkxjq
	j3WEB1yck2dy9DDsdJ+ipfMwE3SYOYMASUbBWUtVrFhkCocydQpa+V6k1hI20p1lx5K0GrXlTW0
	Rvee7vFMZ0X2kXUs3nCtNdcPCJoinVdjpjzPmblyjMeJWZo99qzp2JUheBKDu1TfmTxVz6oC++r
	xUjtznOR6W6XrpTp1o+PSjXhADpi4f5xq5+HpjJZldi/Qpn6xlVS6+OiPAeV0P6oUWkl9bNExWv
	Dn2BHbuAyyvq1PwJTMmh1eJDmXRkUnSXNJd+bzDn10p1z9+1Pv36V0LZyPbI3OINTrrT07Lz1Rp
	w7GUit92OUpN20gC7Sl2H28bX9dQ1sPibhC1VCOa4KztjOxT5UcRumqBQiA6pdlWnFHE0ow==
X-Received: by 2002:a05:6512:108a:b0:5c0:b5c:4084 with SMTP id
 2adb3069b0e04-5c1705d663fmr750666e87.1.1794559879287; Fri, 13 Nov 2026
 00:51:19 -0800 (PST)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102154847.198472-1-jinpu.wang@ionos.com> <20261102154847.198472-2-jinpu.wang@ionos.com>
 <sashiko-outbox-193747@kernel.org> <CAMGffEmyXYooOq9b8=eyzmrsdVQJhogEKWPCvyVXecX9JN-C+Q@mail.gmail.com>
 <eec58ab2-3283-4296-82cc-eba8baaeec8b@fygo.io>
In-Reply-To: <eec58ab2-3283-4296-82cc-eba8baaeec8b@fygo.io>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Fri, 13 Nov 2026 09:51:07 +0100
X-Gm-Features: AclHuK-YWofwpGFGyk9vj7B4Lax9xn3pMwXf0YWSTn2EV7mRAR_Emyti5wjkn_A
Message-ID: <CAMGffEk0qFnPMv8RAdSSVqaJvDFcip4ktTP7uHYqRhTaZDK=Hg@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] md: freeze the queue in mddev_suspend()
To: yukuai@fygo.io
Cc: sashiko-reviews@lists.linux.dev, linux-raid@vger.kernel.org, 
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 8, 2026 at 4:44=E2=80=AFAM yu kuai <yukuai@fygo.io> wrote:
>
> Hi,
>
> =E5=9C=A8 2026/11/3 18:03, Jinpu Wang =E5=86=99=E9=81=93:
> > On Mon, Nov 2, 2026 at 5:20=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
> >> Thank you for your contribution! Sashiko AI review found 2 potential i=
ssue(s) to consider:
> >> - [High] md: deadlock in raid1d() and raid10d() due to queue freeze in=
 mddev_suspend()
> >> - [High] md: deadlock in mddev_freeze_queue() when reshape is interrup=
ted during wait
> >> --
> > Hi Kuai,
> >
> > Sashiko flagged two issues with this patch, and I think both are valid:
> >
> > 1) mddev_freeze_queue() checks reshape_interrupted() only once. If a
> >     raid456 reshape is interrupted or frozen while we wait for
> >     q_usage_counter to drain, a bio already in md_handle_request() loop=
s
> >     back to check_suspended without dropping its q_usage_counter
> >     reference. The wait never ends, because active_io is not killed yet
> >     and prepare_suspend() has not been called.
> >
> > 2) Freezing the queue before killing active_io deadlocks with
> >     raid1d/raid10d. If a read error makes raid1_read_request() split an
> >     md_io_clone bio, the remainder is resubmitted from the md thread
> >     through bio_queue_enter(). That blocks on the frozen queue, so the
> >     md_cloned_bio() bypass in md_handle_request() is never reached and
> >     active_io never drains.
> >
> > For (1) I plan to re-evaluate the skip conditions periodically in the
> > wait. For (2) I don't see a small fix. The options are:
> >    a) have the raid1/raid10 read-error path submit the split remainder
> >       directly to md_handle_request() and skip bio_queue_enter(), or
> >    b) drop the freeze from mddev_suspend() and fix the original
> >       queue_attr_store()/limits_lock vs reconfig_mutex deadlock on the
> >       other side.
> >
> > Which do you prefer, or do you see another approach?
>
> I feel this is too complex and it's not worth it.
>
> Since the reason to freeze queue in queue_attr_store() is to avoid updati=
ng
> limits with I/O inflight, and call blk_mq_freeze_queue() for bio-based di=
sks
> is useless, which means there is still real problem for bio-based disks t=
hat
> queue_attr_store() can update limits with bios inflight.
>
> Christoph, how about adding a new suspend bio disk ops, and replace blk_m=
q_freeze_queue()
> with the new ops for bio-based disks in queue_limits_commit_update_frozen=
()?
Hi Kuai, hi Christoph,

Based on this suggestion, I've posted v4 patchset here:
https://lore.kernel.org/linux-raid/20261112134700.372702-1-jinpu.wang@cloud=
.ionos.com/T/#t

Please have a look!

Thx!
>
> >
> > Thanks,
> >
> >
> >> commit bc4b2b2abc71e036c550ab67e56cbc50b4eb867f
> >> Author: Jack Wang <jinpu.wang@cloud.ionos.com>
> >>
> >> md: freeze the queue in mddev_suspend()
> >>
> >> This commit freezes the request queue in mddev_suspend() and unfreezes=
 it in
> >> __mddev_resume() so that bios submitted while the array is suspended b=
lock in
> >> bio_queue_enter() without holding q_usage_counter, avoiding a deadlock=
 with
> >> concurrent queue_attr_store() limits updates.
> >>
> >>> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >>> index 03e35386a8028..29737a624844a 100644
> >>> --- a/drivers/md/md.c
> >>> +++ b/drivers/md/md.c
> >>> @@ -472,6 +472,42 @@ static void md_submit_bio(struct bio *bio)
> >>>        md_handle_request(mddev, bio);
> >>>   }
> >>>
> >>> +/*
> >>> + * Freeze the queue so a concurrent blk_mq_freeze_queue() (e.g. a li=
mits
> >>> + * update) can't wait on a bio parked in md_handle_request() while s=
uspended.
> >>> + * Skip the drain wait when parked bios hold a reference and only pr=
ogress
> >>> + * after suspend: the suspend_lo/hi window, or an interrupted raid45=
6 reshape.
> >>> + * Resume may run in another task, hence the non_owner variants.
> >>> + */
> >>> +static int mddev_freeze_queue(struct mddev *mddev, bool interruptibl=
e)
> >>> +{
> >>> +     struct request_queue *q;
> >>> +
> >>> +     if (mddev_is_dm(mddev))
> >>> +             return 0;
> >>> +
> >>> +     q =3D mddev->gendisk->queue;
> >>> +     blk_freeze_queue_start_non_owner(q);
> >>> +
> >>> +     if (READ_ONCE(mddev->suspend_lo) < READ_ONCE(mddev->suspend_hi)=
 ||
> >>> +         (mddev->pers && mddev->pers->prepare_suspend &&
> >>> +          reshape_interrupted(mddev)))
> >>> +             return 0;
> >>> +
> >>> +     if (!interruptible) {
> >>> +             blk_mq_freeze_queue_wait(q);
> >>> +             return 0;
> >>> +     }
> >>> +     return wait_event_interruptible(q->mq_freeze_wq,
> >>> +                     percpu_ref_is_zero(&q->q_usage_counter));
> >>> +}
> >> [Severity: High]
> >> Could this wait in mddev_freeze_queue() deadlock if a RAID456 reshape =
is
> >> interrupted or frozen after the initial reshape_interrupted(mddev) che=
ck
> >> passes, while an unsplit bio is already inside md_handle_request()?
> >>
> >> Consider an active RAID456 reshape where reshape_interrupted(mddev) is
> >> initially false and an unsplit bio enters:
> >>
> >> __submit_bio()
> >>    bio_queue_enter() /* acquires q->q_usage_counter */
> >>    md_submit_bio()
> >>      md_handle_request()
> >>        raid5_make_request()
> >>
> >> If mddev_suspend() runs concurrently (for example via suspend_lo_store=
() or
> >> suspend_hi_store(), which do not hold reconfig_mutex), mddev_freeze_qu=
eue()
> >> sees reshape_interrupted(mddev) =3D=3D false and blocks waiting for
> >> q->q_usage_counter to reach zero before mddev_suspend() reaches
> >> percpu_ref_kill(&mddev->active_io) or mddev->pers->prepare_suspend(mdd=
ev).
> >>
> >> If the reshape is then interrupted or frozen while mddev_freeze_queue(=
) is
> >> waiting (for example via action_store() setting MD_RECOVERY_FROZEN or
> >> MD_RECOVERY_INTR, or md_error() setting MD_RECOVERY_INTR on a disk fai=
lure),
> >> make_stripe_request() sees reshape_interrupted(mddev) =3D=3D true and =
returns
> >> STRIPE_WAIT_RESHAPE:
> >>
> >> drivers/md/raid5.c:raid5_make_request() {
> >>          ...
> >>          if (res =3D=3D STRIPE_WAIT_RESHAPE) {
> >>                  ...
> >>                  if (split) {
> >>                          submit_bio_noacct(front_bio);
> >>                          return true;
> >>                  }
> >>                  return false;
> >>          }
> >> }
> >>
> >> For an unsplit bio, raid5_make_request() returns false to md_handle_re=
quest():
> >>
> >> drivers/md/md.c:md_handle_request() {
> >>          ...
> >>          if (!mddev->pers->make_request(mddev, bio)) {
> >>                  percpu_ref_put(&mddev->active_io);
> >>                  if (mddev_is_dm(mddev) && mddev->pers->prepare_suspen=
d)
> >>                          return false;
> >>                  goto check_suspended;
> >>          }
> >> }
> >>
> >> Previously, mddev_suspend() killed mddev->active_io first, so dropping
> >> mddev->active_io allowed mddev_suspend() to finish while the bio parke=
d in
> >> check_suspended. With the queue freeze wait happening first, the bio l=
oops
> >> back to check_suspended inside md_handle_request() without exiting
> >> md_submit_bio() or dropping q->q_usage_counter (and busy-loops because
> >> mddev->active_io has not been killed yet), or sleeps in conf->wait_for=
_reshape
> >> because prepare_suspend() has not been called, so q->q_usage_counter n=
ever
> >> drains.
> >>
> >>> +
> >>> +static void mddev_unfreeze_queue(struct mddev *mddev)
> >>> +{
> >>> +     if (!mddev_is_dm(mddev))
> >>> +             blk_mq_unfreeze_queue_non_owner(mddev->gendisk->queue);
> >>> +}
> >>> +
> >>>   /*
> >>>    * Make sure no new requests are submitted to the device, and any r=
equests that
> >>>    * have been submitted are completely handled.
> >>> @@ -500,6 +536,13 @@ int mddev_suspend(struct mddev *mddev, bool inte=
rruptible)
> >>>                return 0;
> >>>        }
> >>>
> >>> +     err =3D mddev_freeze_queue(mddev, interruptible);
> >>> +     if (err) {
> >>> +             mddev_unfreeze_queue(mddev);
> >>> +             mutex_unlock(&mddev->suspend_mutex);
> >>> +             return err;
> >>> +     }
> >>> +
> >>>        percpu_ref_kill(&mddev->active_io);
> >> [Severity: High]
> >> Does freezing mddev->gendisk->queue before mddev->active_io drains cau=
se a
> >> deadlock with raid1d() and raid10d() when handling read errors?
> >>
> >> For bio-based MD devices, __submit_bio() drops q->q_usage_counter in
> >> blk_queue_exit() as soon as md_submit_bio() returns, while the cloned
> >> r1_bio->master_bio or r10_bio->master_bio (allocated from mddev->io_cl=
one_set
> >> by md_account_bio()) keeps holding a reference on mddev->active_io unt=
il the
> >> underlying member-disk read completes.
> >>
> >> If mddev_suspend() is called while a read bio is in flight on a member=
 disk:
> >> 1. mddev_freeze_queue() sees q->q_usage_counter is already zero and re=
turns
> >>     with mddev->gendisk->queue frozen.
> >> 2. mddev_suspend() kills mddev->active_io and blocks in wait_event() w=
aiting
> >>     for percpu_ref_is_zero(&mddev->active_io).
> >> 3. The member-disk read fails, and raid1d() or raid10d() runs
> >>     handle_read_error() -> raid1_read_request() / raid10_read_request(=
) using
> >>     the md_io_clone master_bio:
> >>
> >> drivers/md/raid1.c:raid1_read_request() {
> >>          ...
> >>          if (max_sectors < bio_sectors(bio)) {
> >>                  bio =3D bio_submit_split_bioset(bio, max_sectors,
> >>                                                &conf->bio_split);
> >>          ...
> >> }
> >>
> >> If the surviving mirror has a smaller max_sectors (for example, due to=
 bad
> >> blocks), bio_submit_split_bioset() splits the md_io_clone bio and call=
s
> >> submit_bio_noacct_nocheck() on the remainder targeting the MD device.
> >>
> >> Commit 7b15c24f8053 ("md: don't hang mddev_suspend() on resubmitted bi=
os")
> >> added the md_cloned_bio() check in md_handle_request() so that resubmi=
tted
> >> md_io_clone bios from raid1d() or raid10d() would bypass the suspend w=
ait and
> >> allow mddev->active_io to drain:
> >>
> >> drivers/md/md.c:md_handle_request() {
> >> check_suspended:
> >>          if (unlikely(md_cloned_bio(mddev, bio))) {
> >>                  /*
> >>                   * This bio is an MD cloned bio and already holds an
> >>                   * active_io reference, so percpu_ref_get() is safe h=
ere.
> >>                   */
> >>                  percpu_ref_get(&mddev->active_io);
> >>          } else {
> >>          ...
> >> }
> >>
> >> However, because raid1d() and raid10d() run with current->bio_list =3D=
=3D NULL,
> >> submit_bio_noacct_nocheck() synchronously calls __submit_bio() ->
> >> bio_queue_enter() on the frozen MD queue and blocks on q->mq_freeze_wq=
 before
> >> reaching md_submit_bio() and md_handle_request(). Won't raid1d() or ra=
id10d()
> >> wait forever for the queue to be unfrozen by __mddev_resume(), while
> >> mddev_suspend() waits forever for the split md_io_clone bio to complet=
e and
> >> drop mddev->active_io?
> >>
> >> --
> >> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102154847=
.198472-1-jinpu.wang@ionos.com?part=3D1
>
> --
> Thanks,
> Kuai
