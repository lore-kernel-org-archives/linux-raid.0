Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E294A20
	for <linux-raid@vger.kernel.org>; Tue,  3 Sep 2024 00:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725324839; cv=none; b=nY+eWkFj4TUXugE53L1A1Tw3OrEL4upMGWV17aj9h8KxLew8DyqLnS+//U2u79/TFotQhM8Yd6+gpuwjzJXID8jhGd6XModCWfncBgUo2uAKhFRtxE2+aFUWo2pkfTFmP3JHdGjqcM4/xcYzEjNTQyh/MNPV49/pDGRHOLTPIsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725324839; c=relaxed/simple;
	bh=3dGvKWnyUKSrJq/CZq64wHfrJTsYr8mEK8rCQss5GsQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CQHW9G7HYK+IRsxLfhjFpAy09QK03kSnlaQPIRZH/ETCshuZrP++G/IyRzY7kIJHP7kR7Uv4IcpvRL9GxucA8BeDGl642Qyj/OLxICVpQQilMi0bpSKOHdryxK+oO8+u5lR2N5GpN+cVP7VpXjn/8B/nLJESLwxYy3x4o7fleP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VW+FpYbo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VW+FpYbo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725324836;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vXxWdOmu0fiUF5av2sUAu0kygK5X4RyYroSCwjD137M=;
	b=VW+FpYboedInjujWmqz4Iec9TQPY4tlUfVXR07VtIsau2+onLN4jDO0zlnc5gm0XgOxQTv
	mO4ADUnqNOCris0zgxLwpuL7TY8Afut56V8tMejKo1jQJlLnqbY4Log46QvL9/+ou0VbRD
	on5RKFY/zhVMusWvoogsV1uL7RkSMwY=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-491-HTiExLqeNIO_VlmnPsyQ0Q-1; Mon, 02 Sep 2024 20:53:55 -0400
X-MC-Unique: HTiExLqeNIO_VlmnPsyQ0Q-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2d404e24c18so4708124a91.3
        for <linux-raid@vger.kernel.org>; Mon, 02 Sep 2024 17:53:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725324834; x=1725929634;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vXxWdOmu0fiUF5av2sUAu0kygK5X4RyYroSCwjD137M=;
        b=lyFjmdkjpCaocxP/gmL+ANOA01/m33AbSzoy8OZJ0TBqU/t0cJx9/5VrdGupw7hzYP
         iVnKNJ1ESjBY6Q9GZTC1aLId75KFhUpclbcWN5lOJMmEbd1WQ/3/jXRmCQ9op8rr0LLT
         gi6UwHyasAkJa1iwQShTJWTvSunz62a+gQC+lYuUL8zchHpHyR8d0jC6lOEnQfiSSUna
         bE+xuJws+hFxRLjbzSJ0gDiZGNejc863VVdmbr8XgafykwliA1UErX9ZIR562I5a+h9M
         6pIgKEgWUrPVhJdYR0pCVGsvL0C8LmMEJ9XkzeDc+vdNy5wcnePm3UfMJzl/AFD44XH8
         +EQA==
X-Gm-Message-State: AOJu0YyvMzPXivQuizzMXit6NCbXd/PoC/r6pfsLbP4IyO+jpQNtPXa8
	W4eidWtKUDfMHSj6nYrJzxmO6GaaoQGxOKUlgEcGto9Iivxl8/MyWcsA59ozQRWBLCGN297o+b5
	QHChbPpMyBAyUYGZ7n51XFW3Ulk3+UNENmDntCQdekT9HVyyhnxplVEgM2r4HdRTkRefVaQ7ufF
	M/sEzcSn0FPeifXO1vIgRRPUtAn5Ud7VoGuA==
X-Received: by 2002:a17:90b:3707:b0:2d8:9dd2:b8a1 with SMTP id 98e67ed59e1d1-2d89dd2b9e1mr7716203a91.9.1725324833969;
        Mon, 02 Sep 2024 17:53:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlcExzDvv8xsFE5OCh0glGdojPAMn154CbinyY9e3fFEPGsXvG5A2UjN7drfTdgyEowSkGFhoEZ7bS7flWxnA=
X-Received: by 2002:a17:90b:3707:b0:2d8:9dd2:b8a1 with SMTP id
 98e67ed59e1d1-2d89dd2b9e1mr7716188a91.9.1725324833458; Mon, 02 Sep 2024
 17:53:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240828021150.63240-1-xni@redhat.com> <20240828021150.63240-5-xni@redhat.com>
 <20240902121359.00007a84@linux.intel.com>
In-Reply-To: <20240902121359.00007a84@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 3 Sep 2024 08:53:42 +0800
Message-ID: <CALTww29ApVRidDFfgM7N-yM0NqBa2_X5yu3uWPTAZ1aGe_QHNg@mail.gmail.com>
Subject: Re: [PATCH 04/10] mdadm/Grow: sleep a while after removing disk in impose_level
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 2, 2024 at 6:14=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Wed, 28 Aug 2024 10:11:44 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > It needs to remove disks when reshaping from raid456 to raid0. In
> > kernel space it sets MD_RECOVERY_RUNNING. And it will fail to change
> > level. So wait sometime to let md thread to clear this flag.
> >
> > This is found by test case 05r6tor0.
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >  Grow.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/Grow.c b/Grow.c
> > index 2a7587315817..aaf349e9722f 100644
> > --- a/Grow.c
> > +++ b/Grow.c
> > @@ -3028,6 +3028,12 @@ static int impose_level(int fd, int level, char
> > *devname, int verbose) makedev(disk.major, disk.minor));
> >                       hot_remove_disk(fd, makedev(disk.major, disk.mino=
r),
> > 1); }
> > +             /*
> > +              * hot_remove_disk lets kernel set MD_RECOVERY_RUNNING
> > +              * and it can't set level. It needs to wait sometime
> > +              * to let md thread to clear the flag.
> > +              */
> > +             sleep_for(5, 0, true);
>

Hi Mariusz

> Shouldn't we check sysfs is shorter intervals? I know that is the simples=
t way but
> big sleeps are generally not good.
>
> I will merge it if you don't want to rework it but you need to add log th=
at we
> are waiting 5 second for the user to not panic that it is frozen.

Which sysfs do you mean? If we have a better way, I want to choose it.

Best Regards
Xiao

>
> Thanks,
> Mariusz
>

