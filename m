Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 874981C1738
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 08:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730796534; cv=none; b=qtZYuUPwQ8rcGZEQ3uRtp86An0OSIrEldzV0BzD9vrQzsgsKE6p3PrmqoGslWZgQSz5soCFChn8TZdVfh2cpK24TVzG7lTaKHNeIpConUoWa/k3YgRUsqTA+wJs7ZCcMNgaMRS0vmu1ZrBbx69W/Y7+M+Z4uGfwHPCGj3wmIJbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730796534; c=relaxed/simple;
	bh=JU4ZlnjJmATtkJdV4eh69cgwMjLzi6YuVkBzbLazAX0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fLZT2dfjFmCWeOF5ljDANfX1ny+rgyEh+7CAQJwUiT4yCNTIUVmnw0Sw4iRnyERN/XSbuxHuIJDj47n8SzqthPma/Lz+EzWlj9QqLgvXkiIeMY2Ly8FyRUzd2gmUuipciTaf6iVmNH9BhIw8VkWcrkDLWsh199NS/w9UGl2i3oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hcnTCl1/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hcnTCl1/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730796531;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SJOaonitVstMB/vKerH8qBoCbE39XTetyueuDxRuLQo=;
	b=hcnTCl1/Tm2szix1sdsRbkR3yMS2B0ryjMfC6M+I1lMO5KeJpqyM24h/mb0e0iIsDrwK+A
	ovuxutIFdRB48aImxP9K4ULxVOO3V3KPsZ45td3g/V7WKKdyX42bEtZJs1gATCMeKTTssS
	W5BRepFRHKJFV6Yqk+hu6aFAOqrI3n4=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-186-kMX58O7BNKuK63lDiqVD3w-1; Tue, 05 Nov 2024 03:48:50 -0500
X-MC-Unique: kMX58O7BNKuK63lDiqVD3w-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-539ea0fcd4bso3527391e87.2
        for <linux-raid@vger.kernel.org>; Tue, 05 Nov 2024 00:48:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730796529; x=1731401329;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SJOaonitVstMB/vKerH8qBoCbE39XTetyueuDxRuLQo=;
        b=SBsJcYaRY0RIB4fIHrFJl6RMeVfv8ai/vbkiNz2k4K0bojsV0C4JNf2H1fYmc/+dfc
         yMixjVlE/EZImiJphSYqq0BwGAsBXFLMPqBO9xMhyjUrV51QHETSKhNn1klLrrD4LZBf
         NFhij6i/a3cRimoe/ddvjYqohDI/KUYwsrkMt6jYTCW83F+mfBjl8xBpGu7yD+Wj1l34
         XIXop3UE1KfPIhlWYJQnY0LH/2x4IsH89/f0LJYKvcTdrx+YNjpd4oqbMprFzAy+a9mx
         gIbZ/PfIWlaLmsXGB3xZ8a92j3o95z1S+5EQbRzvQxG94H4eGG6wcHk7UYmFcnWgcq6p
         O3rw==
X-Forwarded-Encrypted: i=1; AJvYcCVB2sV2H100HwmsYDqHa9CfPdL9s41sqkuZxcBJa/O/a9SkGJ7/i/KFia0WdPJiyERXVyCEER203K3Y@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2pXk/sVHCYsv9fBIrBoUgVqRzrWhzyrhtdbzmYkwPoVIdx1D9
	ksu0O3Z0cPSsU3SAbDxzv4ntmWkCy9Fcx0vtQwk6D9cALAqe5XstIapafA0nfe3Z2/YRjC9HEA2
	h4ySYwZx+fqyPdVorT3LYo0hOK3qKwJZyyY6h7dfXwL6vXQP6Qn14IWFJTpl/bABK1nvqOXbhQU
	AB/TBYUp1p7K8LIEKNpu+4cd/9PkoLaJvXsQ==
X-Received: by 2002:a05:6512:3da9:b0:539:e3a5:4fc7 with SMTP id 2adb3069b0e04-53c79eb5ef7mr9027789e87.59.1730796528795;
        Tue, 05 Nov 2024 00:48:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFku2iS3lPmQl+nXtIQ8XX+2LG++13wGpgPBhMptNrjqMt49LMSRVRgY3oWblV0cqZOx1U23HBca2WcJMpXUjs=
X-Received: by 2002:a05:6512:3da9:b0:539:e3a5:4fc7 with SMTP id
 2adb3069b0e04-53c79eb5ef7mr9027753e87.59.1730796528361; Tue, 05 Nov 2024
 00:48:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105075733.66101-1-xni@redhat.com> <e906cf48-1f2b-8d69-43f5-2a02bcd13346@huaweicloud.com>
In-Reply-To: <e906cf48-1f2b-8d69-43f5-2a02bcd13346@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 5 Nov 2024 16:48:36 +0800
Message-ID: <CALTww292azfpG2x=+PnY9RS-v09T1npqcvd-hXQ4FYt1te9m4A@mail.gmail.com>
Subject: Re: [PATCH RFC 1/1] md: Use pers->quiesce in mddev_suspend
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 4:14=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2024/11/05 15:57, Xiao Ni =E5=86=99=E9=81=93:
> > One customer reports a bug: raid5 is hung when changing thread cnt
> > while resync is running. The stripes are all in conf->handle_list
> > and new threads can't handle them.
> >
> > Commit b39f35ebe86d ("md: don't quiesce in mddev_suspend()") removes
> > pers->quiesce from mddev_suspend/resume, then we can't guarantee sync
> > requests finish in suspend operation. One personality knows itself the
> > best. So pers->quiesce is a proper way to let personality quiesce.
>
> Do you mean that other than normal IO, raid5 expects sync IO to be done
> as well by mddev_suspend()? If so, we'd better add some comments as
> well.

Hi Kuai

Yes, before patch b39f35ebe86d, mddev suspend can guarantee all io
(normal io from filesystem and sync requests) finish. And raid5
conf->handle_list have normal io and sync io, so it should wait all
these io finish in suspend operation. I'll add more comments.

Regards
Xiao
>
> Thanks,
> Kuai
>
> >
> > Fixes: b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/md.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 67108c397c5a..7409ecb2df68 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -482,6 +482,9 @@ int mddev_suspend(struct mddev *mddev, bool interru=
ptible)
> >               return err;
> >       }
> >
> > +     if (mddev->pers)
> > +             mddev->pers->quiesce(mddev, 1);
> > +
> >       /*
> >        * For raid456, io might be waiting for reshape to make progress,
> >        * allow new reshape to start while waiting for io to be done to
> > @@ -514,6 +517,9 @@ static void __mddev_resume(struct mddev *mddev, boo=
l recovery_needed)
> >       percpu_ref_resurrect(&mddev->active_io);
> >       wake_up(&mddev->sb_wait);
> >
> > +     if (mddev->pers)
> > +             mddev->pers->quiesce(mddev, 0);
> > +
> >       if (recovery_needed)
> >               set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> >       md_wakeup_thread(mddev->thread);
> >
>

