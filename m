Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC4F272E6A
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 09:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767691560; cv=none; b=SbpY9oAoN5kvsBYILoNQPNKLMX5fgD3CN15Oa2gotPnny6qy1IcFtXyrOZvWZvFbk7Sz3DNRBd37hlUBFf5bYVX1r41sgawyoPBSY5VDQGLoNOCtdW8x6t+U9pRT6OXyXcP44X9dTIDfyI35hkmcJNyyVgLF9L6+StITuTbgdzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767691560; c=relaxed/simple;
	bh=oox+46LZSFZ0e5A/0LMIbx7iEMHB0JvBHMXflaUhmTA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S0iNGnTnGUEM35WsnON+YLoYT8bBW0IWVEzr3p1iHSzw+z2/KZAcQLHjBDBXk8/l300WN0Wkf/qJpFtQgbgGiUjPn6Vl9QeYsaKVs5hvveIGb6ptoFel82h6uFJfXufh9WTvYfqzhaf++9fHk9t2CZ+ranFNe5rlxfyDrAEJzyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A4VVL6Wq; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZdqcDUeS; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A4VVL6Wq";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZdqcDUeS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767691557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lpkLI2mrGJALpNLKQC0Yv51OL94e7T6Qi3DJlJVk9eQ=;
	b=A4VVL6WqvRSo9Z/tYERMYze5MLXw/eNl9bpACMKeCN3jNlMHva3IFC8yW5RzJFilZdJN4Z
	a0tTqu/P9dBSdtntCG7gsoR0DXulRu5wV/M4O3t2Hai+3Ls5onW7vdh5HoKmAvHGqm1hpb
	dusGaM3gezkM/IJy6Fcwd3ahc2iuW08=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-643-DfV4C-UTPmacCqV9T0gYIQ-1; Tue, 06 Jan 2026 04:25:56 -0500
X-MC-Unique: DfV4C-UTPmacCqV9T0gYIQ-1
X-Mimecast-MFC-AGG-ID: DfV4C-UTPmacCqV9T0gYIQ_1767691555
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-59434b284f8so516527e87.3
        for <linux-raid@vger.kernel.org>; Tue, 06 Jan 2026 01:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767691554; x=1768296354; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lpkLI2mrGJALpNLKQC0Yv51OL94e7T6Qi3DJlJVk9eQ=;
        b=ZdqcDUeSsxL2ONCZyQfpmih5zAH+Kmlvu7jiLUoJ9wS9L4vrqTxJywLWWkB/wHRhC4
         bBIBiRtaEEuPaCrITaIU97z4qX5+pLmMS+/iExoLSiHgr0zMDyuRr0iYBkQcoLQkTU8U
         imJH2Z9+2CKgJ10XEbxIXLCTPoAR63ReejiZP/FSm7oqzj9SYGUaWT+BAqPRjsIE4yjk
         L/vxMiLLQ0u5onWqc1S3LDmflnMG9xYiaolQwv2VyG6+WCQO8BRPzvlUkM7zPB6UaLt1
         MS1zJuZgeUz41gq9bGAllxOSHOJmJAfj/DPQymn1Sbjyq70TRz+K9ub6/VfC45HKpTq9
         BwMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767691554; x=1768296354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lpkLI2mrGJALpNLKQC0Yv51OL94e7T6Qi3DJlJVk9eQ=;
        b=VOlnOxYMQBOyZd2FHujT9CbWZ+sozfDdoWe2aHMMKpBazjBCk28cKf0Loyn87pRvcn
         j2u2PCtaH2bjDYRGiCDXVwSf/nE+1hE5JPBF2bWf4JRUhJJGNjaBs/eOrnmtufupFA7+
         MbQPXZuFkrjrN+PqWaAvCwFhWvtrqjBJd7UrVwUp3MsQP35gOpidedf5lUW1Re0VxaWm
         7Fpbs0bFfJbPoJvjJR8HRlWamFtzQvmK7Rm480XxlDuC9+YdruyLg7XxV8mpR66PZHMm
         MZvyuso50F8O/PTjVoN00XTPdAIRO7wkPQWk9ZjdxTZUW8w7xK9E/HhhSpU8+dru7qEU
         BIVA==
X-Forwarded-Encrypted: i=1; AJvYcCXf8Uf2hbszjET5ODug/jqmtrer7mJcL0oUOSqInQDAbaeSmQucosc/J/ocZYFkZEHQEpEGP4MfJiXj@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6jeBajB6RpmOI6FChXdx3z35asMbirgHHyy4PY1EKd5+ERkZy
	i7Yi2+CVsPJj0MCR8NLn7OF1MY6I0WtVxNdMGZ38ZUrzne2qzLf8X3bmccFXQ05UdM/u8l+cv2s
	TxQBDZOvvryiOkXH9tlbRa3W6/E5Sh5OLHIbJOxzwyGlVXuPLCE5+lsuecWoDUoiS5rQ+6Nktvz
	rRUK1dwFlAeJArM0lDKper0NXtqTZRj6nZXQt0YQ==
X-Gm-Gg: AY/fxX4/7qJIy21FZ1br8pNyNGmO17EzbCureSE5+RD0s18lLD3Ovg/8+z0+HeA5lci
	fFjAw8F/I7y7BoM3r5fczaSM7CLY1R/FWcMmJxJtV6zmfFNm/lnrVCZeqaKv3hJqDPIIHhL35MY
	TWcCgFEc+kfSngh/Q/MHCc/TLkYI2We1GFQgM/5gbQeCU6CkrfwGcD85RNT9/RaNbMpZ13PU0FV
	mKeXNuMvLzurUvH1/Emxu9+leveDFmuAe+Ag9QVckZdZPbdi4vMPmJK+FnLIglEhGmkfQ==
X-Received: by 2002:a05:6512:10c9:b0:598:fd99:323 with SMTP id 2adb3069b0e04-59b65279f64mr692398e87.1.1767691554395;
        Tue, 06 Jan 2026 01:25:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IErdq9Vcl3gtKIFPUdVbAx5jnSIDzy5EqAUljT2ZyMAKS5+knyDQCeFvzhPkFz4HRN5h4OASzj5M3MXAr0x0Ng=
X-Received: by 2002:a05:6512:10c9:b0:598:fd99:323 with SMTP id
 2adb3069b0e04-59b65279f64mr692391e87.1.1767691553938; Tue, 06 Jan 2026
 01:25:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260105144025.12478-1-k@mgml.me> <20260105144025.12478-2-k@mgml.me>
 <7944a042-2e1e-1487-1b42-529768afbbd0@huaweicloud.com> <CALTww2_j--2wA16=eM=2V8XXghwWrH9ARwi9vizZ0TOT3LnXnA@mail.gmail.com>
 <e32e34aa-bc07-25bd-f361-424ec01c14d1@huaweicloud.com>
In-Reply-To: <e32e34aa-bc07-25bd-f361-424ec01c14d1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 6 Jan 2026 17:25:41 +0800
X-Gm-Features: AQt7F2pLoGkoTZaaBCBfziiS85yL371QGm06cArimNLvwmMgKO84TcFWZyJNEnE
Message-ID: <CALTww2-6F8+TMqLTzQYEhSiWL+cFLn4JQqd1GXai5ekTxo8=3w@mail.gmail.com>
Subject: Re: [PATCH v6 1/2] md: Don't set MD_BROKEN for RAID1 and RAID10 when
 using FailFast
To: Li Nan <linan666@huaweicloud.com>
Cc: Kenta Akagi <k@mgml.me>, Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
	Shaohua Li <shli@fb.com>, Mariusz Tkaczyk <mtkaczyk@kernel.org>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 6, 2026 at 5:11=E2=80=AFPM Li Nan <linan666@huaweicloud.com> wr=
ote:
>
>
>
> =E5=9C=A8 2026/1/6 15:59, Xiao Ni =E5=86=99=E9=81=93:
> > On Tue, Jan 6, 2026 at 10:57=E2=80=AFAM Li Nan <linan666@huaweicloud.co=
m> wrote:
> >>
> >>
> >>
> >> =E5=9C=A8 2026/1/5 22:40, Kenta Akagi =E5=86=99=E9=81=93:
> >>> After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
> >>> if the error handler is called on the last rdev in RAID1 or RAID10,
> >>> the MD_BROKEN flag will be set on that mddev.
> >>> When MD_BROKEN is set, write bios to the md will result in an I/O err=
or.
> >>>
> >>> This causes a problem when using FailFast.
> >>> The current implementation of FailFast expects the array to continue
> >>> functioning without issues even after calling md_error for the last
> >>> rdev.  Furthermore, due to the nature of its functionality, FailFast =
may
> >>> call md_error on all rdevs of the md. Even if retrying I/O on an rdev
> >>> would succeed, it first calls md_error before retrying.
> >>>
> >>> To fix this issue, this commit ensures that for RAID1 and RAID10, if =
the
> >>> last In_sync rdev has the FailFast flag set and the mddev's fail_last=
_dev
> >>> is off, the MD_BROKEN flag will not be set on that mddev.
> >>>
> >>> This change impacts userspace. After this commit, If the rdev has the
> >>> FailFast flag, the mddev never broken even if the failing bio is not
> >>> FailFast. However, it's unlikely that any setup using FailFast expect=
s
> >>> the array to halt when md_error is called on the last rdev.
> >>>
> >>
> >> In the current RAID design, when an IO error occurs, RAID ensures faul=
ty
> >> data is not read via the following actions:
> >> 1. Mark the badblocks (no FailFast flag); if this fails,
> >> 2. Mark the disk as Faulty.
> >>
> >> If neither action is taken, and BROKEN is not set to prevent continued=
 RAID
> >> use, errors on the last remaining disk will be ignored. Subsequent rea=
ds
> >> may return incorrect data. This seems like a more serious issue in my =
opinion.
> >>
> >> In scenarios with a large number of transient IO errors, is FailFast n=
ot a
> >> suitable configuration? As you mentioned: "retrying I/O on an rdev wou=
ld
> >> succeed".
> >
> > Hi Nan
> >
> > According to my understanding, the policy here is to try to keep raid
> > work if io error happens on the last device. It doesn't set faulty on
> > the last in_sync device. It only sets MD_BROKEN to forbid write
> > requests. But it still can read data from the last device.
> >
> > static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
> > {
> >
> >      if (test_bit(In_sync, &rdev->flags) &&
> >          (conf->raid_disks - mddev->degraded) =3D=3D 1) {
> >          set_bit(MD_BROKEN, &mddev->flags);
> >
> >          if (!mddev->fail_last_dev) {
> >              return;  // return directly here
> >          }
> >
> >
> >
> > static void md_submit_bio(struct bio *bio)
> > {
> >      if (unlikely(test_bit(MD_BROKEN, &mddev->flags)) && (rw =3D=3D WRI=
TE)) {
> >          bio_io_error(bio);
> >          return;
> >      }
> >
> > Read requests can submit to the last working device. Right?
> >
> > Best Regards
> > Xiao
> >
>
> Yeah, after MD_BROKEN is set, read are forbidden but writes remain allowe=
d.

Hmm, reverse way? Write requests are forbidden and read requests are
allowed now. If MD_BROKEN is set, write requests return directly after
bio_io_error.

Regards
Xiao

> IMO we preserve the RAID array in this state to enable users to retrieve
> stored data, not to continue using it. However, continued writes to the
> array will cause subsequent errors to fail to be logged, either due to
> failfast or the badblocks being full. Read errors have no impact as they =
do
> not damage the original data.
>
> --
> Thanks,
> Nan
>

