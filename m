Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8803917ADE0
	for <linux-raid@vger.kernel.org>; Wed, 11 Feb 2026 03:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770780394; cv=pass; b=DXsO81tiG8D2KFzEyQxY1vdt19IDCclRdaKfGodps9S5ojs1t8eiPlNFKx6SHGnzbke8cUunwqJXibgOtOIqdtHWFQgd3BhJERW9mTOQQfrMzQhadWZgAtBE0nA7ML5i5V2ZYTQptGLeFXQ4jgVpmgzxU9emmtKpqVIgb0ABiS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770780394; c=relaxed/simple;
	bh=KZlBQpQwWmLgUL6gRNrbOoNUaCVhVj0sJvxjfyoYMuw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ubw8IxNK85aH5Jw1zSyinrQMHxWEy2oLYZQd8HpgWmkr4vbCFvdFGFURSOFD6K8Bbsy2XBtt/JUW53cpI7wB48h5O9nxfvcnoPSG35LYrGe0T5Xf5TuvjxAK3tuAblFIolog6T8u8Z8khZItI5NCP0hCJ/LCuerSaMhnXedBoM8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z+ozOOWW; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=fwiBeFm9; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z+ozOOWW";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="fwiBeFm9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770780391;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bCsU2l+0Vd4Fn6l6t0qtY5PtMN6ov6Km6L1w/DrLb4U=;
	b=Z+ozOOWW3YuuB//Nba5CL1ar3G4kdBAX4/HFZtU90KG5ifPSh7r5cJGoopwRi05kniSgDX
	/BRb6mJS+HYOeSxRIeUHeRHZiKtObFSa54czvj6ke25WrK9VMgXjWkOByQSpQ5S1bSlqt2
	Tsm6vUgNlq2lgyHUxzamfRz+xP9AaMI=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-618-HllAPA__PLevKpNlUUHz8w-1; Tue, 10 Feb 2026 22:26:30 -0500
X-MC-Unique: HllAPA__PLevKpNlUUHz8w-1
X-Mimecast-MFC-AGG-ID: HllAPA__PLevKpNlUUHz8w_1770780389
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-59b6cbd5493so1196565e87.0
        for <linux-raid@vger.kernel.org>; Tue, 10 Feb 2026 19:26:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770780388; cv=none;
        d=google.com; s=arc-20240605;
        b=ObAlueHX97drcGq0In8PM/mETyqfMyI+u4ukzakWF+4/IqgYYt2X+uIRblE6bKhQZi
         CaRgTeq8Qih5dQ3lroFH7DCgHT8QDTsV97hKBZIwRjh81HsyNcASSWC6daESGLIAd4Qm
         U0oZyarKwX3ofVG9U0Lu1a7W1VBCCydKL569jCenQmdfB0lDid5frJXo8GoiTzvHqBpW
         zIxQ1FyS0IO+2KUxC9R4Y5kO/5Jiu4WhinQjP0OLwGYAD7iGOymtvbHqF/ySQL1svGBb
         sKQ99eqbRCiOIyhs4o9OG7SuQhjbomABBxDJEOg+89xfeyhjhKdCwsVJ9A93rcv/5/Ko
         17Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bCsU2l+0Vd4Fn6l6t0qtY5PtMN6ov6Km6L1w/DrLb4U=;
        fh=1Ac8trQ6nPFi53rfQKt64pTL8PUXOidyhRxnhwtZT6M=;
        b=HZ7jyr/fhP4JMJujovymVZFtUmEmB5Qa9oqwHeFwuHeilbG8d4FfqL49SjD5Jnh5xD
         +y0yGgGODTUpdvME7Bqy+PkAtAKGcOelRlqMOGoPmmRXJjwij5q9cmCCSR+KWS7O13NB
         EsurjjI6+LwA/6XR7mvkLvibHuAhrQDuDh1Li4kZl9iW/sNfoFda0c9mKQL38lELMtaU
         RYf4qg74LqZQLRPs53hHkBgYMhAEX+GFFgem5P+4k22RtmcUu3cEfphnulrMAcsQ3p3Q
         OsTT52k+VkI+x3h9dKMyDBnSUENnWmRboUm+d7yrVtzEBDhssrxheEWff9Vg7Y8TfmPr
         d6aA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770780388; x=1771385188; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bCsU2l+0Vd4Fn6l6t0qtY5PtMN6ov6Km6L1w/DrLb4U=;
        b=fwiBeFm91GhK7bU0PQmgqMrbCABQsoCPAnDWokyY16agdH/L9MWKOPyPccvS/KOSEU
         HJK5siX6jP9jixgTM7FHZjDJ1Pke2LmA7a2Jd6HYNovmaLfXIOq8nsJxSWQp3ZIkgRG5
         oIBZGuJbtVAiqHRK2vXe2j7IwXJHL6yPIKkKcsG5EVFVhEHnYHZsBwxvIGuJBTGQUJoO
         NhwLeLwgFk+w6iakPhm25aODaJIk9SE3v7OCdJtgpHbUpNaq2tOROKlUMps4dWGMz3EF
         +VGo3LBWRylWFt4f7D3VQsvjOhakAM/3AxdF5xeUUpHuMnTKhkNDVWRnxPMmp4wvvpZQ
         yKLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770780388; x=1771385188;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bCsU2l+0Vd4Fn6l6t0qtY5PtMN6ov6Km6L1w/DrLb4U=;
        b=jZDR/pjOrMnC8gumZu6t/9NEujnJPaPGqvX2xenOMVC7i3W2V7AuhC+AsxNhPWNUQf
         k+dbQZLteXUsIXke1aslKiVmprAw7E7pSA2Id7Xsuy5o3bZhbzAmniZyyqUIfbvyNAPu
         yB77uvTmmZfsAsQvq+ceQceTIpZyvByHHKvFEdRsUshWMSNC6z1cYBci4Pg3SOcutrO5
         LzqS+UukrYmPvzAOxtjAKFc8RTgVYYimVA4S+Lc9dDxFnElcz9gURmOYkvv0kZ80zXz9
         3WxBpwBdcFwoY9YV38r0CCywiarJbyE4nnuww0EH7tn1V6yqy9pDNGjHrMwtjjYn9MwC
         pSMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVAEypY+R/CtrLgUxUgc5ZVvcfMkgA65zNyAzHMOhp8Dn7PkW7cYM9fhJpHLhk5+eIe0zbvGvehr0z@vger.kernel.org
X-Gm-Message-State: AOJu0YztGipT8WWYLbhc2uIHDM8mAy6N8Xq2pC1ELuHZlLsx5K6JCid+
	4dLJGw+qFMDQdh4JOy3tMRuDELyK1LJut5Z6i4lbU/isVEtNKH97vtlpdcNQXzCcFpTJ5pVHjIf
	AGfw5GOj9DDZl8d8w5DHPHhL2gZbEPcuVa789wXfN5oAnREOX6GKQzPavAqt+UvSGhFfvBovEMC
	Z42j4O6u1QODRPFz1At82JDa/Zb3jN6ianBTXwFiCpSL0t1Hj1
X-Gm-Gg: AZuq6aIYLB2weTTJFAFSJGivl0dmYNAKm+bPH6NcQUWs5KMRb+mSXoXKc3GRJLsz7LY
	85yKieMFlQWmp/jBDKw09gjqO+65hJm2o8M0JPecwiWI6Y66+i4GKQHnQKHVXtsmZoKT5pjf61V
	YwZ31Wn2MsYMGxzHcihZppuDkHVs/6jNLXCOHiFndDp7DFfXgALO9insYoCezIz9vMfo6C6mzUc
	+AK/YmikYinEboA6wZ970fbaSoiH7sofWh8h/ntGZE0TN+Cg8+CutlMN/pXsbuHvmvaj9GcXMmc
	DHWZyQ==
X-Received: by 2002:a05:6512:3410:b0:59e:5cf3:d74 with SMTP id 2adb3069b0e04-59e5cf30e0dmr384363e87.19.1770780387994;
        Tue, 10 Feb 2026 19:26:27 -0800 (PST)
X-Received: by 2002:a05:6512:3410:b0:59e:5cf3:d74 with SMTP id
 2adb3069b0e04-59e5cf30e0dmr384354e87.19.1770780387505; Tue, 10 Feb 2026
 19:26:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260206053826.37416-1-xni@redhat.com> <20260206053826.37416-3-xni@redhat.com>
 <9bd6581f-289a-4490-af6d-f15589446e1e@fnnas.com> <CALTww29NpmNbEb79KbVCX-rAF4o39rEd3-P1TjiDTc1OWpQiAw@mail.gmail.com>
 <a753611f-91ee-4cee-97c8-706154d1cade@fnnas.com>
In-Reply-To: <a753611f-91ee-4cee-97c8-706154d1cade@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 11 Feb 2026 11:26:14 +0800
X-Gm-Features: AZwV_QgV23U1uuc63sJM_8Ose_s5P6LIcu0kD5CfAdL8Xb9XbzTNbtUZZR3lEP8
Message-ID: <CALTww2-Dsdpye5wseeFinYcKJdbi4qeuvfepZn902rSEeTWy2Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] md/raid1: serialize overlapped io for writemostly disk
To: yukuai@fnnas.com
Cc: song@kernel.org, linux-raid@vger.kernel.org, linan666@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 11, 2026 at 11:15=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2026/2/11 10:44, Xiao Ni =E5=86=99=E9=81=93:
> > On Wed, Feb 11, 2026 at 10:32=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wro=
te:
> >> Hi,
> >>
> >> =E5=9C=A8 2026/2/6 13:38, Xiao Ni =E5=86=99=E9=81=93:
> >>> In behind mode, overlap bios for writemostly device are queued. They
> >>> In behind mode, bios which overlap the bio from the interval tree
> >>> need to wait in waitqueue. Those bios will be handled once the in-tre=
e
> >>> bio finishes. They are waken up and try to get the tree lock. The bio
> >>> which gets the lock will be handled. So the sequence can't be guarant=
eed.
> >>>
> >>> For example
> >>> bio1(100,200)
> >>> bio2(150,200)
> >>> bio3(150,300)
> >>> The write sequence of fast device is bio1,bio2,bio3. But the write
> >>> sequence of slow device is bio1,bio3,bio2. This causes data corruptio=
n.
> >>> Replace waitqueue with a fifo list to guarantee the write sequence.
> >> To be honest, I think this is fine with the respect user won't send ov=
erlap
> >> bios. In this case, bio1 is done in fast disk and pending in slow disk=
, then
> >> bio2 will stuck while issuing and waiting for bio1 to return from slow=
 disk.
> >> So send bio3 in this case is not expected, and if you do you can't gua=
rantee
> >> the complete order from fast disk as bio2, bio3 as well.
> > Hi Kuai
> >
> > In write behind mode, raid1 returns bio1 to the upper layer once the
> > write on the fast disk finishes. The upper layer (app/filesystem)
> > thinks that bio1 has finished, while the write of bio1 to the slow
> > disk is still in progress. So bio2 will not be stuck while issuing, am
> > I right? If so, bio2 can be submitted to raid1 once the write of bio1
> > to the fast disk finishes. And bio3 can be submitted to raid1 once the
> > write of bio2 to fast disk finishes.
>
> I just take a look at raid1 code, turns out raid1_write_request() just al=
locate
> bio and issue it directly in each rdev iteration, I misunderstood.
>
> This solution looks fine to me, however, I'll suggest to keep the wait_qu=
eue and
> use prepare_to_wait_exclusive() to guarantee the fifo order.

Thanks for the suggestion. I'll use prepare_to_wait_exclusive and send v2.

Best Regards
Xiao
>
> >
> > Best Regards
> > Xiao
> >>> Signed-off-by: Xiao Ni <xni@redhat.com>
> >>> ---
> >>>    drivers/md/md.c    |  1 -
> >>>    drivers/md/md.h    |  4 +++-
> >>>    drivers/md/raid1.c | 39 +++++++++++++++++++++++++++++----------
> >>>    3 files changed, 32 insertions(+), 12 deletions(-)
> >>>
> >>> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >>> index 59cd303548de..ab91d17c2d68 100644
> >>> --- a/drivers/md/md.c
> >>> +++ b/drivers/md/md.c
> >>> @@ -188,7 +188,6 @@ static int rdev_init_serial(struct md_rdev *rdev)
> >>>
> >>>                spin_lock_init(&serial_tmp->serial_lock);
> >>>                serial_tmp->serial_rb =3D RB_ROOT_CACHED;
> >>> -             init_waitqueue_head(&serial_tmp->serial_io_wait);
> >>>        }
> >>>
> >>>        rdev->serial =3D serial;
> >>> diff --git a/drivers/md/md.h b/drivers/md/md.h
> >>> index ac84289664cd..64ffbb2efb87 100644
> >>> --- a/drivers/md/md.h
> >>> +++ b/drivers/md/md.h
> >>> @@ -126,7 +126,6 @@ enum sync_action {
> >>>    struct serial_in_rdev {
> >>>        struct rb_root_cached serial_rb;
> >>>        spinlock_t serial_lock;
> >>> -     wait_queue_head_t serial_io_wait;
> >>>    };
> >>>
> >>>    /*
> >>> @@ -382,6 +381,9 @@ struct serial_info {
> >>>        sector_t start;         /* start sector of rb node */
> >>>        sector_t last;          /* end sector of rb node */
> >>>        sector_t _subtree_last; /* highest sector in subtree of rb nod=
e */
> >>> +     struct list_head        list_node;
> >>> +     struct list_head        waiters;
> >>> +     struct completion       ready;
> >>>    };
> >>>
> >>>    /*
> >>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> >>> index a41b1ec3d695..38c73538d038 100644
> >>> --- a/drivers/md/raid1.c
> >>> +++ b/drivers/md/raid1.c
> >>> @@ -57,19 +57,25 @@ INTERVAL_TREE_DEFINE(struct serial_info, node, se=
ctor_t, _subtree_last,
> >>>                     START, LAST, static inline, raid1_rb);
> >>>
> >>>    static int check_and_add_serial(struct md_rdev *rdev, struct r1bio=
 *r1_bio,
> >>> -                             struct serial_info *si, int idx)
> >>> +                             struct serial_info *si)
> >>>    {
> >>>        unsigned long flags;
> >>>        int ret =3D 0;
> >>>        sector_t lo =3D r1_bio->sector;
> >>>        sector_t hi =3D lo + r1_bio->sectors - 1;
> >>> +     int idx =3D sector_to_idx(r1_bio->sector);
> >>>        struct serial_in_rdev *serial =3D &rdev->serial[idx];
> >>> +     struct serial_info *head_si;
> >>>
> >>>        spin_lock_irqsave(&serial->serial_lock, flags);
> >>>        /* collision happened */
> >>> -     if (raid1_rb_iter_first(&serial->serial_rb, lo, hi))
> >>> +     head_si =3D raid1_rb_iter_first(&serial->serial_rb, lo, hi);
> >>> +     if (head_si && head_si !=3D si) {
> >>> +             si->start =3D lo;
> >>> +             si->last =3D hi;
> >>> +             list_add_tail(&si->list_node, &head_si->waiters);
> >>>                ret =3D -EBUSY;
> >>> -     else {
> >>> +     } else if (!head_si) {
> >>>                si->start =3D lo;
> >>>                si->last =3D hi;
> >>>                raid1_rb_insert(si, &serial->serial_rb);
> >>> @@ -83,19 +89,23 @@ static void wait_for_serialization(struct md_rdev=
 *rdev, struct r1bio *r1_bio)
> >>>    {
> >>>        struct mddev *mddev =3D rdev->mddev;
> >>>        struct serial_info *si;
> >>> -     int idx =3D sector_to_idx(r1_bio->sector);
> >>> -     struct serial_in_rdev *serial =3D &rdev->serial[idx];
> >>>
> >>>        if (WARN_ON(!mddev->serial_info_pool))
> >>>                return;
> >>>        si =3D mempool_alloc(mddev->serial_info_pool, GFP_NOIO);
> >>> -     wait_event(serial->serial_io_wait,
> >>> -                check_and_add_serial(rdev, r1_bio, si, idx) =3D=3D 0=
);
> >>> +     INIT_LIST_HEAD(&si->waiters);
> >>> +     INIT_LIST_HEAD(&si->list_node);
> >>> +     init_completion(&si->ready);
> >>> +     while (check_and_add_serial(rdev, r1_bio, si)) {
> >>> +             wait_for_completion(&si->ready);
> >>> +             reinit_completion(&si->ready);
> >>> +     }
> >>>    }
> >>>
> >>>    static void remove_serial(struct md_rdev *rdev, sector_t lo, secto=
r_t hi)
> >>>    {
> >>>        struct serial_info *si;
> >>> +     struct serial_info *first_si;
> >>>        unsigned long flags;
> >>>        int found =3D 0;
> >>>        struct mddev *mddev =3D rdev->mddev;
> >>> @@ -106,16 +116,25 @@ static void remove_serial(struct md_rdev *rdev,=
 sector_t lo, sector_t hi)
> >>>        for (si =3D raid1_rb_iter_first(&serial->serial_rb, lo, hi);
> >>>             si; si =3D raid1_rb_iter_next(si, lo, hi)) {
> >>>                if (si->start =3D=3D lo && si->last =3D=3D hi) {
> >>> -                     raid1_rb_remove(si, &serial->serial_rb);
> >>> -                     mempool_free(si, mddev->serial_info_pool);
> >>>                        found =3D 1;
> >>>                        break;
> >>>                }
> >>>        }
> >>>        if (!found)
> >>>                WARN(1, "The write IO is not recorded for serializatio=
n\n");
> >>> +     else {
> >>> +             raid1_rb_remove(si, &serial->serial_rb);
> >>> +             if (!list_empty(&si->waiters)) {
> >>> +                     first_si =3D list_first_entry(&si->waiters,
> >>> +                                             struct serial_info, lis=
t_node);
> >>> +                     list_del_init(&first_si->list_node);
> >>> +                     list_splice_init(&si->waiters, &first_si->waite=
rs);
> >>> +                     raid1_rb_insert(first_si, &serial->serial_rb);
> >>> +                     complete(&first_si->ready);
> >>> +             }
> >>> +             mempool_free(si, mddev->serial_info_pool);
> >>> +     }
> >>>        spin_unlock_irqrestore(&serial->serial_lock, flags);
> >>> -     wake_up(&serial->serial_io_wait);
> >>>    }
> >>>
> >>>    /*
> >> --
> >> Thansk,
> >> Kuai
> >>
> >
> --
> Thansk,
> Kuai
>

