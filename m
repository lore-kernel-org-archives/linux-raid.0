Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.175
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793700208;
	b=cJM0DkndzRBNH+lxEa0lC3S3N+zi1NtlvfpazlCIGcOe82RmqHBCn1DJm69YNHWOH0qP
	 MaEdsTGx/c+nNs9GMDKI05Uo7HZUUlwumBXDNWtuxxx+tSAplfZwAdaiBvJI/3BTIW9Vj
	 CUVNbyae1RLFjo0LQjuB3xb6F4RxZEkYbxyoj7b2J2Nyjv6fnx4ExEf/vdI1+0+Xg2TUm
	 mU2dqYo/cqD8rmaaJR123qt5y2hVz5r+7cKqgAgG9fC2oG78qWio/htK7RfBPzDKz1Zob
	 ZXK/VHVH7hzEdmQw5FPwBldqHBCLaOsXrBp2/I4oWC8c99NTzoJX0QER1TRirM0pVLw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793700208;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=Npn0dDU6ZnHvpE2nwwVjowqz6ov3UdnRkZPjyBcJCPM=;
	b=bWQ80xYzoKLFYkB6Jxl98WDb1GS+8N/D2st2ozNxi2OBRrxVLfT5gE4DMxBBW0ID9Tvr
	 9LiVaq7I8tNchlsceC+VqdaKWBKT5dB2NK90jrTlOfK5tnid/2FGsgF12JhVpn1JpRykb
	 4B41eKzp+UL81TdJO/PytCKoI/cSeHuL4iNWgkNC/L+CddIu02FXaNxtzmmlyw8j2UDdC
	 77v5N87WNPyxRGlZ2qzqrBdzN6MgzXrSvhgJ7WBpwHD6EHiKdc74TUSUt+eOoxZYhBH+7
	 jF30rF/COlKBOEjrEW48YrSipQ18DDfxxZzqjQDbT36jfO+vUh4QnI+vbsQHBPH+evg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=cloud.ionos.com;
	spf=pass smtp.mailfrom=ionos.com;
	dkim=pass header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=Ikz4MXvu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.175
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A294D606A810
	for <linux-raid@vger.kernel.org>; Tue,  3 Nov 2026 10:03:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A294D606A810
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.a=rsa-sha256 header.s=google header.b=Ikz4MXvu
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3ab1a37faaeso9714861fa.0
        for <linux-raid@vger.kernel.org>; Tue, 03 Nov 2026 02:03:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793700206; cv=none;
        d=google.com; s=arc-20260327;
        b=TprnzDNCYJ2NdWqBW9ZCDPX2brFcj6OB/Q/we3UprTvWWVAnc/EJ5c03+FG79mwvd/
         zSXDiFjKwSzZK+DglSE15fhmLRArhCN3n7gxALcKpxFOv2NhqAXRRUD/FuP5ApDiNOtN
         eIOhDgKFmDzb1P5JMQwNkaZBlpisv9dx3Rd9lWTKdtRIDoex9IDaxs/wctHntM2DWDju
         bOt+G0Ar7TZXlBTmvlGkeqBFPKCUDILiLxVtiu2mNxFv9c7WVgMn7ggtJ2NbqY+fgcwp
         Rf+S75PlBDNmxzDSi2pKmk/j5DMQnAAzH1EvUvux9B4P5CA5mj0maCp45+E4NewvvgnS
         grSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Npn0dDU6ZnHvpE2nwwVjowqz6ov3UdnRkZPjyBcJCPM=;
        fh=mTP6TkWV1IhQRgyhsEpYqIpiXvhDlZKdHAfNRdOTDjk=;
        b=pVLPjDTEpo0j/yzdkZsc++7IIR8/retCgdnIw1mgKhYM/zeyXZ1AL6NnR97E2oMkcK
         ceJDFdOromlpZGak8BvXERHy+uFy+StisbgAXJK3aKb2OIQOf6hcBRiIIdhsL63dB8R4
         kaS1XsDdd8wcz3G0LHUPp8SmnA9OeH50OMZs3jvBc5s2vpsEQKn8MH7Jch2WJwP0/28j
         /hBcjAMPe8dxsd5A+NHPHaoNvcDew4j5vRRqSsZCYYoqumlASSh9ZCSr0duF0MgP6pq/
         ZPdE4cJNSWD9A9NL+Bk1CMH5F/1KKWLZ1ai7K8IewxK87MFFrMl7waQPW8dehY1WxFZy
         7f/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1793700206; x=1794305006; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Npn0dDU6ZnHvpE2nwwVjowqz6ov3UdnRkZPjyBcJCPM=;
        b=Ikz4MXvuwm9TK2OZPrMIQsrWgAzShzQnbeVCBW9sA3pfbPoo2iQ3L9bHeEQijFT/sn
         dTdOwZqRiW16gf9Dc8BE2n0VOkaaI6Um7qXqSk0M4bKDns9IoUMLwZs8bhaltHNyt7gl
         Oo1b5IR70L83bfO7UHTLLPzYfScFSJ3+jh6MbX//gz5LyI2QkCevUOttCnN4j9KbWnJ8
         KTCRtnRcjjaiFYdgRfybPk43Jw7fL+IfJNS19mX5Pl29H4EZsRMYpUPWFYx88/ZlnHKu
         1FAF1B+QopQBx71FME9vy/uJBZ0mL/v1bqO7gR6G0DBRaMUm1nVeGw+jRKgpRAViE78t
         ewMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793700206; x=1794305006;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Npn0dDU6ZnHvpE2nwwVjowqz6ov3UdnRkZPjyBcJCPM=;
        b=iGFkXLiXW7YX7lq49X7yiW9QVf5DB2gS4HHvoysLJoCnx3LH3V4xChLRIj8qJaRcAe
         sMSFeWaVwoeDi68oH3IH4voUZQ53seeC0HKsrTAj7KXPafqk6423eIcTtnwNTzZtVIzR
         QRMzjLScacQ5dU2zlUaK1eOJ4GFdWPpBCSLMFK1bWy28zIsnDYc0l9UgZ3j64cjJZJTw
         9y7YjkXtDnN1M16WAQdkYr151rfrRuAOx/6wKvMWEdwdRhBPFItxkenhYXKrb8Of1ilH
         0X48PiALezvPGArZuyS4ini2MRLmA6GW1MdHt+fLkSEi1OnVsiNUhhwdszggtW1EVKsz
         CbLw==
X-Gm-Message-State: APuU4Z++RCkNonRRKUhbnYVwKATwsRfTteQ8TC4gsO2uiJaqU1QlCIXV
	F1LTEHsne7bboAUN29Sq8t2I7tt3Lj7yF9YO2XEjqLYMpKmzabLNVyOClpil6SH57pXdiaNpM/N
	3kedxj/st46EJZHmLWF4PjZMrzFlxVHX5KQhclMPYBqX2G5avi3emUTr9Pg==
X-Gm-Gg: AYBFou3Fbi2m0W3qGWbcSlfNaSVQF+IksUEZKhCmzUmIDWPZUVwpE2V+KJKPL9JW665
	zJo0+kUOFIA4EWOyxE0pevK5PCto8Nrgvoes91IlUkmRvzECyfzN++PN4CO3pPmzydr40ivFL20
	JyY2vx/kbWdAhOiB3W+EmpSqm8bLeGa2f+F+LlTGx/LWoW61HjcyTkJUJifZsn+0sUw6firvcf+
	yfsQ/KE1BAfllLJCtLj7+AzLiLH/dzLZ43qo/NHgIEOyCQgO9W9N/ysTOoY+FaOHYYXigb+HR34
	UXcI9tJP4fcr7jqaWfxoSU7d0mMsdFtfYZdYxsHC9sag250tkmt6CoFIGkEBH48mSdaOhYFVRTB
	/rXH9yhy0J+1vnMF+bNggEtphxyQUhxSfOTHtm5Br54Lxq+P4p5AyLuhSFA==
X-Received: by 2002:a05:6512:6d3:b0:5bf:b8f1:8109 with SMTP id
 2adb3069b0e04-5bfd95571d2mr5175761e87.4.1793700205673; Tue, 03 Nov 2026
 02:03:25 -0800 (PST)
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
 <sashiko-outbox-193747@kernel.org>
In-Reply-To: <sashiko-outbox-193747@kernel.org>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Tue, 3 Nov 2026 11:03:13 +0100
X-Gm-Features: AclHuK_Zj_gUwhS8uNptKULJVSCvk6qKf9LvDnnxrFHKw1A3_i2xPj_queHwPOM
Message-ID: <CAMGffEmyXYooOq9b8=eyzmrsdVQJhogEKWPCvyVXecX9JN-C+Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/1] md: freeze the queue in mddev_suspend()
To: sashiko-reviews@lists.linux.dev
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 2, 2026 at 5:20=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
> - [High] md: deadlock in raid1d() and raid10d() due to queue freeze in md=
dev_suspend()
> - [High] md: deadlock in mddev_freeze_queue() when reshape is interrupted=
 during wait
> --
Hi Kuai,

Sashiko flagged two issues with this patch, and I think both are valid:

1) mddev_freeze_queue() checks reshape_interrupted() only once. If a
   raid456 reshape is interrupted or frozen while we wait for
   q_usage_counter to drain, a bio already in md_handle_request() loops
   back to check_suspended without dropping its q_usage_counter
   reference. The wait never ends, because active_io is not killed yet
   and prepare_suspend() has not been called.

2) Freezing the queue before killing active_io deadlocks with
   raid1d/raid10d. If a read error makes raid1_read_request() split an
   md_io_clone bio, the remainder is resubmitted from the md thread
   through bio_queue_enter(). That blocks on the frozen queue, so the
   md_cloned_bio() bypass in md_handle_request() is never reached and
   active_io never drains.

For (1) I plan to re-evaluate the skip conditions periodically in the
wait. For (2) I don't see a small fix. The options are:
  a) have the raid1/raid10 read-error path submit the split remainder
     directly to md_handle_request() and skip bio_queue_enter(), or
  b) drop the freeze from mddev_suspend() and fix the original
     queue_attr_store()/limits_lock vs reconfig_mutex deadlock on the
     other side.

Which do you prefer, or do you see another approach?

Thanks,


>
> commit bc4b2b2abc71e036c550ab67e56cbc50b4eb867f
> Author: Jack Wang <jinpu.wang@cloud.ionos.com>
>
> md: freeze the queue in mddev_suspend()
>
> This commit freezes the request queue in mddev_suspend() and unfreezes it=
 in
> __mddev_resume() so that bios submitted while the array is suspended bloc=
k in
> bio_queue_enter() without holding q_usage_counter, avoiding a deadlock wi=
th
> concurrent queue_attr_store() limits updates.
>
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 03e35386a8028..29737a624844a 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -472,6 +472,42 @@ static void md_submit_bio(struct bio *bio)
> >       md_handle_request(mddev, bio);
> >  }
> >
> > +/*
> > + * Freeze the queue so a concurrent blk_mq_freeze_queue() (e.g. a limi=
ts
> > + * update) can't wait on a bio parked in md_handle_request() while sus=
pended.
> > + * Skip the drain wait when parked bios hold a reference and only prog=
ress
> > + * after suspend: the suspend_lo/hi window, or an interrupted raid456 =
reshape.
> > + * Resume may run in another task, hence the non_owner variants.
> > + */
> > +static int mddev_freeze_queue(struct mddev *mddev, bool interruptible)
> > +{
> > +     struct request_queue *q;
> > +
> > +     if (mddev_is_dm(mddev))
> > +             return 0;
> > +
> > +     q =3D mddev->gendisk->queue;
> > +     blk_freeze_queue_start_non_owner(q);
> > +
> > +     if (READ_ONCE(mddev->suspend_lo) < READ_ONCE(mddev->suspend_hi) |=
|
> > +         (mddev->pers && mddev->pers->prepare_suspend &&
> > +          reshape_interrupted(mddev)))
> > +             return 0;
> > +
> > +     if (!interruptible) {
> > +             blk_mq_freeze_queue_wait(q);
> > +             return 0;
> > +     }
> > +     return wait_event_interruptible(q->mq_freeze_wq,
> > +                     percpu_ref_is_zero(&q->q_usage_counter));
> > +}
>
> [Severity: High]
> Could this wait in mddev_freeze_queue() deadlock if a RAID456 reshape is
> interrupted or frozen after the initial reshape_interrupted(mddev) check
> passes, while an unsplit bio is already inside md_handle_request()?
>
> Consider an active RAID456 reshape where reshape_interrupted(mddev) is
> initially false and an unsplit bio enters:
>
> __submit_bio()
>   bio_queue_enter() /* acquires q->q_usage_counter */
>   md_submit_bio()
>     md_handle_request()
>       raid5_make_request()
>
> If mddev_suspend() runs concurrently (for example via suspend_lo_store() =
or
> suspend_hi_store(), which do not hold reconfig_mutex), mddev_freeze_queue=
()
> sees reshape_interrupted(mddev) =3D=3D false and blocks waiting for
> q->q_usage_counter to reach zero before mddev_suspend() reaches
> percpu_ref_kill(&mddev->active_io) or mddev->pers->prepare_suspend(mddev)=
.
>
> If the reshape is then interrupted or frozen while mddev_freeze_queue() i=
s
> waiting (for example via action_store() setting MD_RECOVERY_FROZEN or
> MD_RECOVERY_INTR, or md_error() setting MD_RECOVERY_INTR on a disk failur=
e),
> make_stripe_request() sees reshape_interrupted(mddev) =3D=3D true and ret=
urns
> STRIPE_WAIT_RESHAPE:
>
> drivers/md/raid5.c:raid5_make_request() {
>         ...
>         if (res =3D=3D STRIPE_WAIT_RESHAPE) {
>                 ...
>                 if (split) {
>                         submit_bio_noacct(front_bio);
>                         return true;
>                 }
>                 return false;
>         }
> }
>
> For an unsplit bio, raid5_make_request() returns false to md_handle_reque=
st():
>
> drivers/md/md.c:md_handle_request() {
>         ...
>         if (!mddev->pers->make_request(mddev, bio)) {
>                 percpu_ref_put(&mddev->active_io);
>                 if (mddev_is_dm(mddev) && mddev->pers->prepare_suspend)
>                         return false;
>                 goto check_suspended;
>         }
> }
>
> Previously, mddev_suspend() killed mddev->active_io first, so dropping
> mddev->active_io allowed mddev_suspend() to finish while the bio parked i=
n
> check_suspended. With the queue freeze wait happening first, the bio loop=
s
> back to check_suspended inside md_handle_request() without exiting
> md_submit_bio() or dropping q->q_usage_counter (and busy-loops because
> mddev->active_io has not been killed yet), or sleeps in conf->wait_for_re=
shape
> because prepare_suspend() has not been called, so q->q_usage_counter neve=
r
> drains.
>
> > +
> > +static void mddev_unfreeze_queue(struct mddev *mddev)
> > +{
> > +     if (!mddev_is_dm(mddev))
> > +             blk_mq_unfreeze_queue_non_owner(mddev->gendisk->queue);
> > +}
> > +
> >  /*
> >   * Make sure no new requests are submitted to the device, and any requ=
ests that
> >   * have been submitted are completely handled.
> > @@ -500,6 +536,13 @@ int mddev_suspend(struct mddev *mddev, bool interr=
uptible)
> >               return 0;
> >       }
> >
> > +     err =3D mddev_freeze_queue(mddev, interruptible);
> > +     if (err) {
> > +             mddev_unfreeze_queue(mddev);
> > +             mutex_unlock(&mddev->suspend_mutex);
> > +             return err;
> > +     }
> > +
> >       percpu_ref_kill(&mddev->active_io);
>
> [Severity: High]
> Does freezing mddev->gendisk->queue before mddev->active_io drains cause =
a
> deadlock with raid1d() and raid10d() when handling read errors?
>
> For bio-based MD devices, __submit_bio() drops q->q_usage_counter in
> blk_queue_exit() as soon as md_submit_bio() returns, while the cloned
> r1_bio->master_bio or r10_bio->master_bio (allocated from mddev->io_clone=
_set
> by md_account_bio()) keeps holding a reference on mddev->active_io until =
the
> underlying member-disk read completes.
>
> If mddev_suspend() is called while a read bio is in flight on a member di=
sk:
> 1. mddev_freeze_queue() sees q->q_usage_counter is already zero and retur=
ns
>    with mddev->gendisk->queue frozen.
> 2. mddev_suspend() kills mddev->active_io and blocks in wait_event() wait=
ing
>    for percpu_ref_is_zero(&mddev->active_io).
> 3. The member-disk read fails, and raid1d() or raid10d() runs
>    handle_read_error() -> raid1_read_request() / raid10_read_request() us=
ing
>    the md_io_clone master_bio:
>
> drivers/md/raid1.c:raid1_read_request() {
>         ...
>         if (max_sectors < bio_sectors(bio)) {
>                 bio =3D bio_submit_split_bioset(bio, max_sectors,
>                                               &conf->bio_split);
>         ...
> }
>
> If the surviving mirror has a smaller max_sectors (for example, due to ba=
d
> blocks), bio_submit_split_bioset() splits the md_io_clone bio and calls
> submit_bio_noacct_nocheck() on the remainder targeting the MD device.
>
> Commit 7b15c24f8053 ("md: don't hang mddev_suspend() on resubmitted bios"=
)
> added the md_cloned_bio() check in md_handle_request() so that resubmitte=
d
> md_io_clone bios from raid1d() or raid10d() would bypass the suspend wait=
 and
> allow mddev->active_io to drain:
>
> drivers/md/md.c:md_handle_request() {
> check_suspended:
>         if (unlikely(md_cloned_bio(mddev, bio))) {
>                 /*
>                  * This bio is an MD cloned bio and already holds an
>                  * active_io reference, so percpu_ref_get() is safe here.
>                  */
>                 percpu_ref_get(&mddev->active_io);
>         } else {
>         ...
> }
>
> However, because raid1d() and raid10d() run with current->bio_list =3D=3D=
 NULL,
> submit_bio_noacct_nocheck() synchronously calls __submit_bio() ->
> bio_queue_enter() on the frozen MD queue and blocks on q->mq_freeze_wq be=
fore
> reaching md_submit_bio() and md_handle_request(). Won't raid1d() or raid1=
0d()
> wait forever for the queue to be unfrozen by __mddev_resume(), while
> mddev_suspend() waits forever for the split md_io_clone bio to complete a=
nd
> drop mddev->active_io?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102154847.19=
8472-1-jinpu.wang@ionos.com?part=3D1
