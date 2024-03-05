Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4865A793
	for <linux-raid@vger.kernel.org>; Tue,  5 Mar 2024 12:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709641531; cv=none; b=OpoQTbDWmwLgSP7h8FC6dX32rPG5nsaI60byOZ1nFAZJYdeaC3oA5hhNa6PofyYbyQZUrIrwXN7CYCBvHqQ4TFbQzePv3MnxmRPSluOgTcFoWcE11sEgm/OzGrc4NKZRfymMdKo1dLBdbgw7UeD3nA6WNtC7z3Z0EUbQmZ3PVqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709641531; c=relaxed/simple;
	bh=u2UY+SjKuTIm5iSVjOtzXiFeNJRtjmXQYTnw6TEl8AM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jvr8QU98jk2Jk2EK8bw7I5TsapbQJVvgjxLgvt1vMl1bSDUAF6gmb1l6f0TVEy2UeTJk1AHjxrGvU423M5RsGDqCt2u7SFQ5QnSWcWx2YfJvPc5K7ojsblFKpg7xQgqPQSs8ATDmgUOmgp/qPwwH7+XrFHkfQm9cd8S8t9i/wd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=BRvYFJrr; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="BRvYFJrr"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2d3ee1c9ea9so9674921fa.3
        for <linux-raid@vger.kernel.org>; Tue, 05 Mar 2024 04:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1709641527; x=1710246327; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ePwfYodzVIqITQvuujiVA/QLiaOx65vTdaXdGDai+qQ=;
        b=BRvYFJrrqdIDQ6WgUYeEtgztMnKHuqEmMlmQVR5Sm5GY1aDcak/x7gL0TqlwFA0tyH
         3n7Mjb3ZcKi877qTGymiYyoARtP2AQXWj9j1p4Zezf/JdV2tpRTUb7gxPR/Dxj3zKKRt
         3qKq+JmO3xbP71/D5D2GWKCZuK7nbbpVYn9+k957t77jrlhDK1v5E3JcS0spRvqV36db
         5dbBLDVTdMtreljAKpnB74tsNveM6aqGs5B95I+7hWrod/xrPyll29lwJELv/TOYATZP
         g8g8DfF0A3D5k6oGnexs3/I7wMUk8tvbvykb8aRT3GCGMLy0x81aXJG2t0J7NkliemTP
         okeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709641527; x=1710246327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ePwfYodzVIqITQvuujiVA/QLiaOx65vTdaXdGDai+qQ=;
        b=xTlBBlnma6a4kGiOTasRLUzW0t8BWfhhbarOBrWO6oHLc8mvfXGxk3RVSE5Km7anZZ
         MW0P8DNG5295laoxbdpaqSKi5q0Y2dN868PkcrikFPG/6a2Mx2XYF//HI9GS5KII2ciM
         Y0Yy6xMZ3I0O8qZihHGrFPkF7zxQTDUoqjEBsM4tIEoDX45QPB8Xl8gb67dEY6gkWaM2
         kFEp0knEIEIkO0eoSBSCGyz4yhpJDWU2XqYXqgdYzRThtW3K6x+YKDu7DMg7GWt96aTq
         1d0/J0aakGT3YZYX64O1ees8iH/LBGCh29nYWTBXvGcFOcZI52ZyjUqwJnwt308uFOQZ
         hz6g==
X-Forwarded-Encrypted: i=1; AJvYcCU9wt4oDunv+MAXLWCzKUv9QLn2meYhyrdh9505BfedEQE9P8ltkz7/CAKWr6hYDBs5m78XCG8oM8ifFBiVM3noSdanNQwvMY31NA==
X-Gm-Message-State: AOJu0YxsexDuzgbEwtwwdvAVCLqw9khs9HrytHvppv0DttoLwvRq6+n4
	4mdwVLhHvg1CPRIigoo56RSrl/PgtcKUdS2uk+gUsU4KJVj/+Cic8ByjQVRZfYmMGb4V2k3/kmp
	iyc5KL1V3/tHssyLQMfLZWpyQWzNx3hr57of4WQ==
X-Google-Smtp-Source: AGHT+IFtwQbU02QrDtjBQF+RdlFyJ+yPHGptapUbH9o+3gO5TTCLfnUldNkzblNvIXndnIKm8zTpgpei2mDGTXoGEj8=
X-Received: by 2002:a19:3856:0:b0:513:39c8:10f2 with SMTP id
 d22-20020a193856000000b0051339c810f2mr1120916lfj.30.1709641526865; Tue, 05
 Mar 2024 04:25:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240305105419.21077-1-jinpu.wang@ionos.com> <9874f0e8-32d4-4c29-a332-718fb95a365a@molgen.mpg.de>
In-Reply-To: <9874f0e8-32d4-4c29-a332-718fb95a365a@molgen.mpg.de>
From: =?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>
Date: Tue, 5 Mar 2024 13:25:16 +0100
Message-ID: <CAHJVUegG9cL6WnNCeokOnAAJyb4yEWnyzi=S20=K=sREJy3AOQ@mail.gmail.com>
Subject: Re: [PATCHv2] md: Replace md_thread's wait queue with the swait variant
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Jack Wang <jinpu.wang@ionos.com>, song@kernel.org, yukuai3@huawei.com, 
	linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Thank you for your answer.

Regarding the INTERRUPTIBLE wait:
- it was introduced that time only for _not_ contributing to load-average.
- now obsolete, see also explanation in our patch.

Regarding our tests:
- we used 100 logical volumes (and more) doing full-blown random rd/wr
IO (fio) to the same md-raid1/raid5 device.

Best regards,


On Tue, Mar 5, 2024 at 1:01=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.de> =
wrote:
>
> Dear Jack, dear Florian-Ewald,
>
>
> Thank you for your patch.
>
> Am 05.03.24 um 11:54 schrieb Jack Wang:
> > From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
> >
> > Replace md_thread's wait_event()/wake_up() related calls with their
> > simple swait~ variants to improve performance as well as memory and
> > stack footprint.
> >
> > Use the IDLE state for the worker thread put to sleep instead of
> > misusing the INTERRUPTIBLE state combined with flushing signals
> > just for not contributing to system's cpu load-average stats.
> >
> > Also check for sleeping thread before attempting its wake_up in
> > md_wakeup_thread() for avoiding unnecessary spinlock contention.
> >
> > With this patch (backported) on a kernel 6.1, the IOPS improved
> > by around 4% with raid1 and/or raid5, in high IO load scenarios.
>
> It=E2=80=99d be great if you elaborated on your test setup.
>
> Should this have?
>
> Fixes: 93588e2284b6 ("[PATCH] md: make md threads interruptible again")
>
> I ask, because the simple waitqueue (swait) implementation was only
> introduced in 2016, so 11 years later than the mentioned commit.
>
> > Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
> > Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> > ---
> > v2: fix a type error for thread
> >   drivers/md/md.c | 23 +++++++----------------
> >   drivers/md/md.h |  2 +-
> >   2 files changed, 8 insertions(+), 17 deletions(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 48ae2b1cb57a..14d12ee4b06b 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -7970,22 +7970,12 @@ static int md_thread(void *arg)
> >        * many dirty RAID5 blocks.
> >        */
> >
> > -     allow_signal(SIGKILL);
> >       while (!kthread_should_stop()) {
> >
> > -             /* We need to wait INTERRUPTIBLE so that
> > -              * we don't add to the load-average.
> > -              * That means we need to be sure no signals are
> > -              * pending
> > -              */
> > -             if (signal_pending(current))
> > -                     flush_signals(current);
> > -
> > -             wait_event_interruptible_timeout
> > -                     (thread->wqueue,
> > -                      test_bit(THREAD_WAKEUP, &thread->flags)
> > -                      || kthread_should_stop() || kthread_should_park(=
),
> > -                      thread->timeout);
> > +             swait_event_idle_timeout_exclusive(thread->wqueue,
> > +                     test_bit(THREAD_WAKEUP, &thread->flags) ||
> > +                     kthread_should_stop() || kthread_should_park(),
> > +                     thread->timeout);
> >
> >               clear_bit(THREAD_WAKEUP, &thread->flags);
> >               if (kthread_should_park())
> > @@ -8017,7 +8007,8 @@ void md_wakeup_thread(struct md_thread __rcu *thr=
ead)
> >       if (t) {
> >               pr_debug("md: waking up MD thread %s.\n", t->tsk->comm);
> >               set_bit(THREAD_WAKEUP, &t->flags);
> > -             wake_up(&t->wqueue);
> > +             if (swq_has_sleeper(&t->wqueue))
> > +                     swake_up_one(&t->wqueue);
> >       }
> >       rcu_read_unlock();
> >   }
> > @@ -8032,7 +8023,7 @@ struct md_thread *md_register_thread(void (*run) =
(struct md_thread *),
> >       if (!thread)
> >               return NULL;
> >
> > -     init_waitqueue_head(&thread->wqueue);
> > +     init_swait_queue_head(&thread->wqueue);
> >
> >       thread->run =3D run;
> >       thread->mddev =3D mddev;
> > diff --git a/drivers/md/md.h b/drivers/md/md.h
> > index b2076a165c10..1dc01bc5c038 100644
> > --- a/drivers/md/md.h
> > +++ b/drivers/md/md.h
> > @@ -716,7 +716,7 @@ static inline void sysfs_unlink_rdev(struct mddev *=
mddev, struct md_rdev *rdev)
> >   struct md_thread {
> >       void                    (*run) (struct md_thread *thread);
> >       struct mddev            *mddev;
> > -     wait_queue_head_t       wqueue;
> > +     struct swait_queue_head wqueue;
> >       unsigned long           flags;
> >       struct task_struct      *tsk;
> >       unsigned long           timeout;
>
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
>
>
> Kind regards,
>
> Paul
