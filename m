Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053BEEADD
	for <linux-raid@vger.kernel.org>; Mon, 26 Feb 2024 05:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708924349; cv=none; b=ZndDfrZUkHZq2jUrVCeMnK41lw5FKugvCT6KOfCmXs66iUfuLR82VGSyBZl0/35GeLoHX/2jiEoNc0EXDYtdmDTBzgomEW40BBWf0rtBEz7PqAXBiq2wxUczatk/ec2BOS4pOEzEGZTXLTR5G/9NNJ5ryCybp+OlDojiAJfFdBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708924349; c=relaxed/simple;
	bh=KqlmOVtGoUefakZG/WqGvYeTGoB6+9PnZsPJmc5e/5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bq1Eot+FuHE8bSBjlqlR/A47/uzs8C9KgXM1uyAZgl/CN615vZLlO6p0eqHIqfGoJXFDR7/DZhstO/AxEv5YwYO6W+5BLiiJV88DQtEO1TTh9D2H3L4nfO0imMIpNZ90HyrKi/3jYL7Ce6OCpPGNrs8UH42di4xqlH5UHTf0wGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pli7eB3v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pli7eB3v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708924346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U1gtEf79F3Bw11he1ADUXNhmB6o0JZE9Su321zR0ac4=;
	b=Pli7eB3vUfreSunpWnnS6D4w3GBDFMyDTxNiR8PXISdl1fz+f9LYXr7QuJX/NgYTs4z/qM
	sHdSIYRME4OtYedgfadZotWopGL3dM9ZipicKRNXv3At2YoBrs2cOHaDcjMBFh8rjmjTor
	2tA5Lh2305D3SXWbq2BiZsuOkQJVe4k=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-325-58mz6U70Oq2cicFWyniWiw-1; Mon, 26 Feb 2024 00:12:24 -0500
X-MC-Unique: 58mz6U70Oq2cicFWyniWiw-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-29a82907e96so2189305a91.2
        for <linux-raid@vger.kernel.org>; Sun, 25 Feb 2024 21:12:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708924344; x=1709529144;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U1gtEf79F3Bw11he1ADUXNhmB6o0JZE9Su321zR0ac4=;
        b=eDIUg4rbuiZXso9l9tJH8ggGP5sXJsy5i3RHwDv5r1APmeakKGwH+INXogU5kC5Ids
         RdcXXMIMN1j4rG+6oRF9J6PkcKa0EUgq6flWtoDnn4ceaE2ta1tjFrr8ITHsahig+Xag
         ZczNzdBb6sUWSGBQDZ7g+a61CXmSTTApP4dkx897AJzSFFWv0MW4QiBV+cCwwsl+2lIT
         INlsQvY2MKB5HLoRBxwQONiiJ+zGw4jtNTNZqEEhSVMkJnfoPNQKLV7sFxymWiS/EHnq
         hAXViQ23LJT3ZsDHIiZqHxfEjSRd16MmEQjKAVWuDsLQXRewERrFWtq4QpEXKkZsliC8
         GNBw==
X-Forwarded-Encrypted: i=1; AJvYcCXBt3CwUZIdS+YuN+cjRuBtmRdfYc90bwAPnqIXLo00hMQePI/+9UJ0lMTWf/9LRkueUOhBivUqLR/ZYmUqKove7v6nAFdXlMUTKQ==
X-Gm-Message-State: AOJu0YwYE5HC6E2uQz+zAYwhLojnjpHvQYgpElXr/7Aj2NyLLryDbO+a
	P4neo869W29gcrzaL8/oaMLmPypd16ydIFmLyHy8GXFvA1miV26Du7+SBzddH/1VeXE9Kh0f0cD
	iiruZZUCEx/R3YgOdVz6PVIZ6BvwjAQXbykUuac6D/ffEL0HTGGUeVluC9yLrqvO781Bm1fu3xH
	inZGrc17bJJtR3diM4ar/eRonN8DXlTG2uNg==
X-Received: by 2002:a17:90a:f003:b0:29a:b73c:4978 with SMTP id bt3-20020a17090af00300b0029ab73c4978mr1558626pjb.33.1708924343764;
        Sun, 25 Feb 2024 21:12:23 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHXjOzzRhOy4V6HeBmrUkV+HKKee71QXpOMJbGu9Se0ZlJnXoIaOkY9COcsh4wIHLCWbmk5r0n6djU7ATkgvps=
X-Received: by 2002:a17:90a:f003:b0:29a:b73c:4978 with SMTP id
 bt3-20020a17090af00300b0029ab73c4978mr1558612pjb.33.1708924343384; Sun, 25
 Feb 2024 21:12:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240220153059.11233-1-xni@redhat.com> <20240220153059.11233-2-xni@redhat.com>
 <aa0859d5-6e1c-76f0-284d-9d1c21497f28@huaweicloud.com> <CALTww2-3WgtGMDpeDphcfkdCxORf5bTSFZATSZ=m3S4VbPv26w@mail.gmail.com>
 <15439a9b-1170-09a3-caf0-e1020e78b713@huaweicloud.com>
In-Reply-To: <15439a9b-1170-09a3-caf0-e1020e78b713@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 26 Feb 2024 13:12:12 +0800
Message-ID: <CALTww29H7+kau-V-wx9kPM4Beu9niUaYcDt+DvXGrQdUNP_Aag@mail.gmail.com>
Subject: Re: [PATCH RFC 1/4] dm-raid/md: Clear MD_RECOVERY_WAIT when stopping dmraid
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, bmarzins@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org, ncroxon@redhat.com, neilb@suse.de, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 26, 2024 at 9:31=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/02/23 21:20, Xiao Ni =E5=86=99=E9=81=93:
> > On Fri, Feb 23, 2024 at 11:32=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.c=
om> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2024/02/20 23:30, Xiao Ni =E5=86=99=E9=81=93:
> >>> MD_RECOVERY_WAIT is used by dmraid to delay reshape process by patch
> >>> commit 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock").
> >>> Before patch commit f52f5c71f3d4b ("md: fix stopping sync thread")
> >>> dmraid stopped sync thread directy by calling md_reap_sync_thread.
> >>> After this patch dmraid stops sync thread asynchronously as md does.
> >>> This is right. Now the dmraid stop process is like this:
> >>>
> >>> 1. raid_postsuspend->md_stop_writes->__md_stop_writes->stop_sync_thre=
ad.
> >>> stop_sync_thread sets MD_RECOVERY_INTR and wait until MD_RECOVERY_RUN=
NING
> >>> is cleared
> >>> 2. md_do_sync finds MD_RECOVERY_WAIT is set and return. (This is the
> >>> root cause for this deadlock. We hope md_do_sync can set MD_RECOVERY_=
DONE)
> >>> 3. md thread calls md_check_recovery (This is the place to reap sync
> >>> thread. Because MD_RECOVERY_DONE is not set. md thread can't reap syn=
c
> >>> thread)
> >>> 4. raid_dtr stops/free struct mddev and release dmraid related resour=
ces
> >>>
> >>> dmraid only sets MD_RECOVERY_WAIT but doesn't clear it. It needs to c=
lear
> >>> this bit when stopping the dmraid before stopping sync thread.
> >>>
> >>> But the deadlock still can happen sometimes even MD_RECOVERY_WAIT is
> >>> cleared before stopping sync thread. It's the reason stop_sync_thread=
 only
> >>> wakes up task. If the task isn't running, it still needs to wake up s=
ync
> >>> thread too.
> >>>
> >>> This deadlock can be reproduced 100% by these commands:
> >>> modprobe brd rd_size=3D34816 rd_nr=3D5
> >>> while [ 1 ]; do
> >>> vgcreate test_vg /dev/ram*
> >>> lvcreate --type raid5 -L 16M -n test_lv test_vg
> >>> lvconvert -y --stripes 4 /dev/test_vg/test_lv
> >>> vgremove test_vg -ff
> >>> sleep 1
> >>> done
> >>>
> >>> Fixes: 644e2537fdc7 ("dm raid: fix stripe adding reshape deadlock")
> >>> Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
> >>> Signed-off-by: Xiao Ni <xni@redhat.com>
> >>
> >> I'm not sure about this change, I think MD_RECOVERY_WAIT is hacky and
> >> really breaks how sync_thread is working, it should just go away soon,
> >> once we make sure sync_thread can't be registered before pers->start()
> >> is done.
> >
> > Hi Kuai
> >
> > I just want to get to a stable state without changing any existing
> > logic. After fixing these regressions, we can consider other changes.
> > (e.g. remove MD_RECOVERY_WAIT. allow sync thread start/stop when array
> > is suspend. )  I talked with Heinz yesterday, for dm-raid, it can't
> > allow any io to happen including sync thread when array is suspended.
>

Hi Kuai

> So, are you still thinking that my patchset will allow this for dm-raid?
>
> I already explain a lot why patch 1 from my set is okay, and why the set
> doesn't introduce any behaviour change like you said in this patch 0:


I'll read all your patches to understand you well.

But as I mentioned many times too, we're fixing regression problems.
It's better for us to fix them with the smallest change. As you can
see, in my patch set, we can fix these regression problems with small
changes (Sorry I didn't notice your patch set has some changes which
are the same with mine).  So why don't we need such a big change to
fix the regression problems? Now with my patch set I can reproduce a
problem by lvm2 test suit which happens in 6.6 too. It means with this
patch set we can back to a state same with 6.6.



>
> "Kuai's patch set breaks some rules".
>
> The only thing that will change is that for md/raid, sync_thrad can
> start for suspended array, however, I don't think this will be a problem
> because sync_thread can be running for suspended array already, and
> 'MD_RECOVERY_FROZEN' is already used to prevent sync_thread to start.

We can't allow sync thread happen for dmraid when it's suspended.
Because it needs to switch table when suspended. It's a base design.
If it can happen now. We should fix this.

Best Regards
Xiao
>
> Thanks,
> Kuai
>
> >
> > Regards
> > Xiao
> >>
> >> Thanks,
> >> Kuai
> >>> ---
> >>>    drivers/md/dm-raid.c | 2 ++
> >>>    drivers/md/md.c      | 1 +
> >>>    2 files changed, 3 insertions(+)
> >>>
> >>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> >>> index eb009d6bb03a..325767c1140f 100644
> >>> --- a/drivers/md/dm-raid.c
> >>> +++ b/drivers/md/dm-raid.c
> >>> @@ -3796,6 +3796,8 @@ static void raid_postsuspend(struct dm_target *=
ti)
> >>>        struct raid_set *rs =3D ti->private;
> >>>
> >>>        if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags=
)) {
> >>> +             if (test_bit(MD_RECOVERY_WAIT, &rs->md.recovery))
> >>> +                     clear_bit(MD_RECOVERY_WAIT, &rs->md.recovery);
> >>>                /* Writes have to be stopped before suspending to avoi=
d deadlocks. */
> >>>                if (!test_bit(MD_RECOVERY_FROZEN, &rs->md.recovery))
> >>>                        md_stop_writes(&rs->md);
> >>> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >>> index 2266358d8074..54790261254d 100644
> >>> --- a/drivers/md/md.c
> >>> +++ b/drivers/md/md.c
> >>> @@ -4904,6 +4904,7 @@ static void stop_sync_thread(struct mddev *mdde=
v, bool locked, bool check_seq)
> >>>         * never happen
> >>>         */
> >>>        md_wakeup_thread_directly(mddev->sync_thread);
> >>> +     md_wakeup_thread(mddev->sync_thread);
> >>>        if (work_pending(&mddev->sync_work))
> >>>                flush_work(&mddev->sync_work);
> >>>
> >>>
> >>
> >
> > .
> >
>

