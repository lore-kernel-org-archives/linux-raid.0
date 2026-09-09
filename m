Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2732481B1
	for <linux-raid@vger.kernel.org>; Wed,  9 Sep 2026 04:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788928142; cv=pass; b=j4eCsXxeLjP3OUgwNfV1Ez9EDDbjcTcTkUZLVdyhJFWwYMuk6ExmYd/G5HBd8mWt2kr6zD8YF3be5BmDr3wXNLQcowQBAL1R+43WGkDfbDmTv9kTPaT4S4mQxxz/ko1GksVZu4bQhC/B39e9Gy0B+0/WV5R15rbyWH1tn4yx9Oc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788928142; c=relaxed/simple;
	bh=QQhJ3qYIjUasljmP8havcCtl5vRenKquD/kkYVenMyg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J++MXKAMYN6JeM1PyL6aLHnauUFmecYjE4ABmiOK4I4OYsKMdNzUEUadCrsqTDLySvfhaHr9C4X65s5USg73ZYM9OeFaLDCpNgmqbVcGnFfQJSRInn/M9w020h7MMugRt0n+mZyurGEy8pJ0RNTEv9ayVvgbR5+Fa5U15dSCXCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=bimaWllq; arc=pass smtp.client-ip=74.125.228.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="bimaWllq"
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c2507a618e1so61930566b.0
        for <linux-raid@vger.kernel.org>; Tue, 08 Sep 2026 21:29:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788928139; cv=none;
        d=google.com; s=arc-20260327;
        b=S791rzQAzQJqhpj8TXItvcedsccDdbkRoCIHctS56hvw2ZKIyqBg6hdP+bCmUKq7y1
         844w+5bPiEBIB2X3arCGUw1DPQrOFWECHfk4r+RZh8L4bJdRBNuZ4lc0tBVw7j29byfe
         rVbDAt9aqrkukwrRNjsZZiJEm2YRj6RTuD/TFysVV9mOalghFWobTVwxB2cdHVMI/JD+
         8FKE7lwAuRSyRpcddLhw8OSeADR6V6c5d1bUtNHG1zkP8QKo8RdzRHN6pwDb3cGTClN2
         YpzKwlsgqODlvJhrcNqk2iLtYXWV4jlV21zvmyBRcvxN5LUHNYzBSrDODUqm5qzrxhoP
         YXlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1JLg12pdT8x1DC+kmJ5GTBCz8csi15xeh0bsfDtpGJk=;
        fh=PH+ziDv3NrPhOUubXXQvAdQZZkww0jzxGqfBPeqgl28=;
        b=F3NEqsPXhnHJ18k2NTuVoqVZfiCZKmRRdRFHIzJLVG2h4UO+loQe2iQMlRTP0KYxVK
         zp1CRDItILwqcS2LcaRYiw+qfEW/W9WKs4YGnF5OIMdAiZyEpmWWneh3OT501But1XOQ
         Qb09jl9NqVR3vTh4S2KuX54CD6ZswNtklhci2OTa1oHjAj6+FefJRiHvT/QR5lFtSXph
         xSLWanHst79fd35Onjf9nLCyoiIASFMAb4CfWKYshfeW1RSTg3Z8FnzCNPRZdY9kF9TD
         Jsd0ZGNbUgvq/wuIHknNPPLXEDkdDA8h0eKTiQZhVL9ktfUtGqVZf86OMbfvuW+SmhXN
         zsgQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1788928139; x=1789532939; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1JLg12pdT8x1DC+kmJ5GTBCz8csi15xeh0bsfDtpGJk=;
        b=bimaWllqTtuuzjD4+40FfdVhALPOqyH2CKPYXbxCOZDuuGqRSInF6H6pavHefc9fB5
         l7ePySzV7jgCRM70sVJBcZRE1vRU2/bbwPXWhCXmv/6n2nlZp/UGN6f6b3PZ5vugfxkp
         ZHN36uI1JPwzMqaHlOAK5AoRGbPEcE33aKEv9ga9i2lJy3TFBeyG6p6/BZmJtpcVs4bw
         EVRUB0BSxuO6ZAu/a/CiVSaVQorWst1noOVsX8dM2jUpGr6jTSB2w/5CwzO6oCX2FZ2V
         Ng9iv7H5qrtEFEPF1JxqrrCow1dOWy2SKmRuh/PBkwUEmX9CAP6dBn1FV22qib4GLUMw
         NCYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788928139; x=1789532939;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1JLg12pdT8x1DC+kmJ5GTBCz8csi15xeh0bsfDtpGJk=;
        b=EHm9TcdUIViFBvFpP6xe6CSmGmWGd1oa6AbdwgQ2K1NC1BbLePFM4DoZ2u149UZC7f
         s8NLauRln++WgGKUX/1p7U9llRNvzkygNE8eHvSHUGjXC24SuCvcnERDV/BG1Tec19xm
         J8/JgDQQDY8gtu38CkYksHpkQOi+yiYpXqdBdrJQViCJaY7WuEfOfYVWNjdNe7Esc5qc
         ANy6dpcks+NF5Uv04YEkypEEXp+b4ZAI9wpNVTpV++aOx1nnkdj23RwEMFfiOX78UMEH
         kxL/JHVymYC0lCnLEAP+m2i0pojRPcYnQPQBheimQ25UlKTELbKloI+uACDVm6PXcItK
         lVaw==
X-Forwarded-Encrypted: i=1; AKwUvBySYeYSf4j9IvEy4AO5Chaklga/vnxLYXXyjZctZcBjF225fU8hFbXc3kfWN2B5v1AWGRPb2pkp0ytS@vger.kernel.org
X-Gm-Message-State: AFuF++k4ojeumQZFWgY18sDoJV/ayGfU+xRMcWazyPx6KOuICSq5bDGp
	zO37R7SoqON1KeLvcLInwvf03lnHG4R2dFw4lVg6/qlQ+Ahunkb3jCwjLdS7Ba/ZUBhpBTKxBjV
	YJ4FVU5cOYgJ0i60YtqCf2TWtsNeQv3TW9T1udB287Q==
X-Gm-Gg: AYBFou2yi+9FQoJT8nq0e1wdT1041M2SxUuF6NVPs3MAllAjkA960hfNnxTh6VLbZXA
	g22kVv+0pNOKtF2dKsq+qie6RmvYA5ins8wgKEY0Z9TxMA6jEh+uBCimcqpLPqTaJKcXPh8cBcr
	fKtOwNCUvBo/ItCQp0boAGqycIeeA7TS8jnIauAhtT0PE/kughbzRNmyBwZgSbJ8tIUkzbXpoHS
	LbQ0Cy2Niwvipxynk+fTnaaXhUAGihN+gOTCjHPQ/RzWHnWOPxYovvcxWoyr0+9DIO6U3wGCGqB
	EqSqSy+AHWi9PmN6uD286mf+IgRJbYG7UeHrFIDSLR2wzyRv2bLWrcQ4HPEvVzYUYxHY3lBLk9K
	Nd/r3M8Oz5TQ=
X-Received: by 2002:a17:907:7296:b0:c25:2ded:ad36 with SMTP id
 a640c23a62f3a-c2610e582d2mr1230577466b.0.1788928138997; Tue, 08 Sep 2026
 21:28:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260907133929.1081540-1-jinpu.wang@ionos.com>
 <e6ad5b61-0ba2-49fa-96c7-e821defe45a7@linux.ibm.com> <CAMGffEmKrqcxYAtdTxg6GnwwFjJJg50wxpTfBobps-_QwQAoGg@mail.gmail.com>
 <m2bja7612z.fsf@gmail.com> <m28q5b5s4n.fsf@gmail.com>
In-Reply-To: <m28q5b5s4n.fsf@gmail.com>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Wed, 9 Sep 2026 06:28:47 +0200
X-Gm-Features: AcwNN1V7hHSxU3jM0XuZmAWH9OsgQnh1FWej0MoI6-EHbmpkMwG-3O42FSIo6RE
Message-ID: <CAMGffEmg+UEfoMp-TTw9+T2kTtuv6fCiBfufO9Evads8dtGLwA@mail.gmail.com>
Subject: Re: [PATCH 0/6] md: don't wait for q->limits_lock while md holds back I/O
To: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Cc: Nilay Shroff <nilay@linux.ibm.com>, linux-raid <linux-raid@vger.kernel.org>, 
	linux-block <linux-block@vger.kernel.org>, Song Liu <song@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>, 
	Yu Kuai <yukuai@fygo.io>, tom.leiming@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 8, 2026 at 11:51=E2=80=AFPM Abd-Alrhman Masalkhi
<abd.masalkhi@gmail.com> wrote:
>
> On Tue, Sep 08, 2026 at 20:37 +0200, Abd-Alrhman Masalkhi wrote:
> > Hi Jack and Nilay,
> >
> > On Tue, Sep 08, 2026 at 14:09 +0200, Jinpu Wang wrote:
> >> On Tue, Sep 8, 2026 at 1:16=E2=80=AFPM Nilay Shroff <nilay@linux.ibm.c=
om> wrote:
> >>>
> >>> On 9/7/26 7:09 PM, Jack Wang wrote:
> >>> > From: Jack Wang<jinpu.wang@cloud.ionos.com>
> >>> >
> >>> > Writing to a queue limits attribute of an md array while a spare is
> >>> > being re-added deadlocks the array.  I reported this earlier here:
> >>> >
> >>> >    https://lore.kernel.org/linux-raid/CAMGffE=3DheGA3y8FjQ0Sm1jj-kd=
-=3DH9Y54WozKASSEZhc9UNKjA@mail.gmail.com/
> >>> >
> >>> > Four tasks, one array:
> >>> >
> >>> >    udev-worker    queue_attr_store() holds q->limits_lock, waits in
> >>> >                   blk_mq_freeze_queue() for q_usage_counter to drai=
n
> >>> >    fio            holds a q_usage_counter reference, parked in
> >>> >                   md_handle_request()'s is_suspended() loop
> >>> >    mdadm          suspended the array, waits for reconfig_mutex
> >>> >    md_start_sync  holds reconfig_mutex, waits for q->limits_lock
> >>> >
> >>> > The last leg is mddev_stack_new_rdev() from ->hot_add_disk().  Sinc=
e
> >>> > commit c99f66e4084a ("block: fix queue freeze vs limits lock order =
in
> >>> > sysfs store methods") the sysfs store holds q->limits_lock across t=
he
> >>> > freeze, so md must not block on that lock while it is holding back =
the
> >>> > I/O the freeze waits for.  That is the same hazard mddev_suspend()
> >>> > already documents for reconfig_mutex.
> >>> >
> >>> > The rule this series applies is that q->limits_lock nests outside b=
oth
> >>> > reconfig_mutex and the suspend.  Where md cannot arrange that, beca=
use
> >>> > it is called with reconfig_mutex already held or from the sync thre=
ad,
> >>> > it takes the update with a trylock and does without one on a conten=
ded
> >>> > pass.
> >>> >
> >>> > Patches 1, 2 and 4 are plumbing with no functional change.  Patches=
 3
> >>> > and 5 convert the two callers that cannot own an update.  Patch 6 d=
oes
> >>> > the hoists, all in one patch because a mix of the two lock orders i=
s an
> >>> > ABBA.
> >>> >
> >>> > Two callers still take q->limits_lock inside reconfig_mutex, both w=
ith
> >>> > the array suspended, and patch 6 says why: ->start_reshape() from
> >>> > action_store(), which suspends before flushing sync_work, and
> >>> > raid*_run() -> queue_limits_set() from level_store(), which already
> >>> > hangs on its own because it freezes the queue while suspended.  Bot=
h
> >>> > need more restructuring than belongs here.
> >>> >
> >>> > The patches are based on v7.3-rc2.
> >>> >
> >>> > Tested there with a raid1 of two ram devices, fio in flight and a l=
oop
> >>> > writing queue/max_sectors_kb: 20 fail/remove/add cycles complete,
> >>> > where the same test wedges the array before the series.  Every patc=
h
> >>> > builds on its own.  A reshape and a level change are not covered by=
 that
> >>> > test.
> >>>
> >>> Overall, I think the direction looks good. With this series, we now h=
ave the
> >>> locking order where q->limits_lock is acquired before the suspend and
> >>> reconfig_mutex.
> >>>
> >>> However, when I ran these changes through blktests, I hit the lockdep=
 splat[1],
> >>> which exposes an ABBA dependency between disk->open_mutex and q->limi=
ts_lock.
> >>>
> >>> Looking at the existing dependency chain, disk->open_mutex is expecte=
d to
> >>> be acquired before q->limits_lock. However, with this change, md_ioct=
l()
> >>> acquires q->limits_lock first and subsequently reaches md_import_devi=
ce(),
> >>> which acquires disk->open_mutex. This reverses the existing lock orde=
ring
> >>> and introduces the ABBA dependency, so I think this needs to be addre=
ssed.
> >>>
> >>
> >> Thanks for running this through blktests.
> >>
> >> You are right, and it is worse than the one path you hit.  The import =
is
> >> not the only offender: everything in the mddev->pers branch of
> >> md_add_new_disk() that opens or closes a component device runs with
> >> q->limits_lock held.  Besides md_import_device() there are four
> >> export_rdev() calls and one md_kick_rdev_from_array(), and export_rdev=
()
> >> ends in fput(rdev->bdev_file), so it takes disk->open_mutex too.
> >> rdev_attr_store() looks like a second instance: it starts the update f=
or
> >> every state_store() write, and "remove" reaches
> >> md_kick_rdev_from_array().
> >>
> >> So the rule needs to be stronger than what I wrote: q->limits_lock nes=
ts
> >> outside reconfig_mutex and the suspend, and must not be held across an=
y
> >> component device open or close.
> >>
> >> Two ways to get there, and I would rather hear which you prefer before
> >> respinning:
> >>
> >> 1) Keep the lock outermost, move the open and close out from under it.
> >>    md_ioctl() imports before taking q->limits_lock and releases after
> >>    committing and unlocking; md_add_new_disk() hands the rdev back
> >>    instead of exporting it.  The import then runs without
> >>    reconfig_mutex, so the superblock format fields need a snapshot and=
 a
> >>    recheck under the lock.  Only the mddev->pers branch needs this, th=
e
> >>    other two never reach add_bound_rdev().
> >>
> >> 2) Drop the hoist for ADD_NEW_DISK and stack the leg after resume, wit=
h
> >>    q->limits_lock on its own.  Much smaller, but the leg is live befor=
e
> >>    its limits are stacked and the integrity rejection lands after the
> >>    add rather than before it.
> >>
> > I am thinking about changeing the order of reconfig_mutex and the
> > suspention. we would suspend the array inside raid1_add_disk()
> > and raid1_remove_disk() when we add/remove the rdev from raid1 conf.
> >
>
> Sorry, changing the order would complicate it and result in a deadlock.
> In those cases, normal I/O can be waiting for a superblock update which
> needs to acquire the reconfig_mutex. At the same time, the task adding
> the new rdev would be holding the reconfig_mutex while waiting for that
> exact I/O to drain.
Hi Abd-Alrhman,

Yes, there are different deadlock scenarios.

Thank you for your input.
>
> >> Is there a better option?  If ->hot_add_disk() is meant to be callable
> >> with an update already in flight, that limits how far the open and clo=
se
> >> can move.
> >>
> >> Thanks,
> >> Jack
> >
> > --
> > Best Regards,
> > Abd-Alrhman
>
> --
> Best Regards,
> Abd-Alrhman
