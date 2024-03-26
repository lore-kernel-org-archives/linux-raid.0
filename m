Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2E974BEB
	for <linux-raid@vger.kernel.org>; Tue, 26 Mar 2024 05:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711430572; cv=none; b=bMwWsywACLWXKhtoLd1PDmbka9+MaoffcV748vcDXa2RsEH9xbraN5xsAm7VQS1DFiS2ripTtWyF3QLZvFJ5VCETN7CeJFdwiU3PELkfDlmDIVkcbY/DcaYprAyVQbN2HQEXo4FuU5WwDwZeS8GOyh7IXHj2fBi91LY4+Bi7N5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711430572; c=relaxed/simple;
	bh=GJKQRFB4oqyw6mjVW9Jl9svBOx4zqwBoKikc2L/uBxA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HohKeRjokVyx8Eg4qNKJ16wf8QjOVjmmkh3GPPpDzStWUS03PNeWp1ZwEUyrsn2uVmEhG4QaQJgs8M0G4omagd57r6AvHaZXe9HENQoryinqywebs0uzbRHW2so/qOT+52IhQ8LzCCgZuHXMOJt4lv/MYMvVV679v/UKMqmeBd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=C5jpnnvL; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="C5jpnnvL"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-513e89d0816so6366671e87.0
        for <linux-raid@vger.kernel.org>; Mon, 25 Mar 2024 22:22:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1711430568; x=1712035368; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sZh/Jb+d+n1fU/W76l/Wtwn9fBE1ykQe6lTXRk4dQVg=;
        b=C5jpnnvLV76Nq6vHYByV38TRHJ7vDYtxxPsKe8mTeVoDTh4g3/beNKWS0SImweZthM
         oUY9SehoyU9B4S9AFeg+svmpur0YkceBJbHEuy6z9owhw/YusZc32QKR1ud9Yja/hSLb
         xi9pmGqSCRwGe24IJXIzINR4HB4Vj6gnQTphNNTltt+tLaYUc6t83fq0PmbZpcADmLJv
         E3t22XwCj5wo2UqDVE220lJB8dCpmOMHCDdpc4lvxyQtl59468NowJcxXtP/K4ZTwlCR
         AOJxieiLpnCTpLCaSg8DMHhfLi6HnJWFoyLOzWOM/notUVpWjxhTfBaUIDiEqOUpuTX/
         X/hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711430568; x=1712035368;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sZh/Jb+d+n1fU/W76l/Wtwn9fBE1ykQe6lTXRk4dQVg=;
        b=NnFckuhSlEQxih+BSrEr88FR6FRjq149AM8KgwslLpv581kmswVvNAagjHQhb6fYP4
         Cjv8CEe6Wg/x0O2MN5c8oF3SLV8iEzJ0J4us2UhiY313nC1+n1XkAbRtbrZJGiWX6J76
         hZATeKXGCH/3urRtxsr5JFf/W3Ei+fYWN+E+lg3/+Ki5xErMI8EMzEARU2OEuv+94Ivl
         boLUv9//FJbq2PukXlfyYCmFAX4m9joXbUEU4V310qYDtS4xST91NLzbbVPRd2ODHNBU
         x0WjqznJyu89u79xZsS9IU+I0BYY2uxSYCJFhTG3SALrUPN0mVNpyvnOHNTD8leLO+jr
         56Zg==
X-Forwarded-Encrypted: i=1; AJvYcCUMkKDvSPa+P8Oaje/n/OtqecJBbDsvfctTYAzbUWRT1BOJ9Q5BgKSvxsL8Rhe6dYIeRoe4zFRwxFH0Ugdn25hRhhlQT7Z/m3wgUw==
X-Gm-Message-State: AOJu0YyuwuNdaIpVrxZMAkKwI3SSF4t2/N7zMXdqHNAA9os2M2ODxsX2
	huSRUoPp8KNdpqcOciF/OZB6oWSY68ns4L73yjnXKAnu2bw6AjiWTre/2N3E+UmNxYSFXgat9we
	MO4WIvdL6WqqffIRiTT23KfAqPDRw9hR734KvQg==
X-Google-Smtp-Source: AGHT+IH+xwQGD8ha7e6Jw6lC55UOSc0gJdyDJvrJOy+Mh2R+GXAyNHnx5QYq+dKvBVDy1SUxM+kTooYZa3CG5Fwni1k=
X-Received: by 2002:ac2:46d0:0:b0:513:e375:12c1 with SMTP id
 p16-20020ac246d0000000b00513e37512c1mr6073990lfo.41.1711430567985; Mon, 25
 Mar 2024 22:22:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240307120835.87390-1-jinpu.wang@ionos.com>
In-Reply-To: <20240307120835.87390-1-jinpu.wang@ionos.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Tue, 26 Mar 2024 06:22:37 +0100
Message-ID: <CAMGffEm8hhg=C1BayDxRhGSTT2b0DBzopr3RWB7aM+XG3yTYNg@mail.gmail.com>
Subject: Re: [PATCHv3] md: Replace md_thread's wait queue with the swait variant
To: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org
Cc: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>, Paul Menzel <pmenzel@molgen.mpg.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Song, hi Kuai,

ping, Any comments?

Thx!

On Thu, Mar 7, 2024 at 1:08=E2=80=AFPM Jack Wang <jinpu.wang@ionos.com> wro=
te:
>
> From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
>
> Replace md_thread's wait_event()/wake_up() related calls with their
> simple swait~ variants to improve performance as well as memory and
> stack footprint.
>
> Use the IDLE state for the worker thread put to sleep instead of
> misusing the INTERRUPTIBLE state combined with flushing signals
> just for not contributing to system's cpu load-average stats.
>
> Also check for sleeping thread before attempting its wake_up in
> md_wakeup_thread() for avoiding unnecessary spinlock contention.
>
> With this patch (backported) on a kernel 6.1, the IOPS improved
> by around 4% with raid1 and/or raid5, in high IO load scenarios.
>
> Fixes: 93588e2284b6 ("[PATCH] md: make md threads interruptible again")
> Signed-off-by: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
>
> ---
> v3: add reviewed by from Paul, add fixes tag.
> v2: fix a type error for thread
>  drivers/md/md.c | 23 +++++++----------------
>  drivers/md/md.h |  2 +-
>  2 files changed, 8 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 48ae2b1cb57a..14d12ee4b06b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7970,22 +7970,12 @@ static int md_thread(void *arg)
>          * many dirty RAID5 blocks.
>          */
>
> -       allow_signal(SIGKILL);
>         while (!kthread_should_stop()) {
>
> -               /* We need to wait INTERRUPTIBLE so that
> -                * we don't add to the load-average.
> -                * That means we need to be sure no signals are
> -                * pending
> -                */
> -               if (signal_pending(current))
> -                       flush_signals(current);
> -
> -               wait_event_interruptible_timeout
> -                       (thread->wqueue,
> -                        test_bit(THREAD_WAKEUP, &thread->flags)
> -                        || kthread_should_stop() || kthread_should_park(=
),
> -                        thread->timeout);
> +               swait_event_idle_timeout_exclusive(thread->wqueue,
> +                       test_bit(THREAD_WAKEUP, &thread->flags) ||
> +                       kthread_should_stop() || kthread_should_park(),
> +                       thread->timeout);
>
>                 clear_bit(THREAD_WAKEUP, &thread->flags);
>                 if (kthread_should_park())
> @@ -8017,7 +8007,8 @@ void md_wakeup_thread(struct md_thread __rcu *threa=
d)
>         if (t) {
>                 pr_debug("md: waking up MD thread %s.\n", t->tsk->comm);
>                 set_bit(THREAD_WAKEUP, &t->flags);
> -               wake_up(&t->wqueue);
> +               if (swq_has_sleeper(&t->wqueue))
> +                       swake_up_one(&t->wqueue);
>         }
>         rcu_read_unlock();
>  }
> @@ -8032,7 +8023,7 @@ struct md_thread *md_register_thread(void (*run) (s=
truct md_thread *),
>         if (!thread)
>                 return NULL;
>
> -       init_waitqueue_head(&thread->wqueue);
> +       init_swait_queue_head(&thread->wqueue);
>
>         thread->run =3D run;
>         thread->mddev =3D mddev;
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index b2076a165c10..1dc01bc5c038 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -716,7 +716,7 @@ static inline void sysfs_unlink_rdev(struct mddev *md=
dev, struct md_rdev *rdev)
>  struct md_thread {
>         void                    (*run) (struct md_thread *thread);
>         struct mddev            *mddev;
> -       wait_queue_head_t       wqueue;
> +       struct swait_queue_head wqueue;
>         unsigned long           flags;
>         struct task_struct      *tsk;
>         unsigned long           timeout;
> --
> 2.34.1
>
