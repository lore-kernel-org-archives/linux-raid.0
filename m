Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6C01E1A17
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 16:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782319733; cv=pass; b=VEPSFdDqoM8aBqbG6i9QHSWoJBzEGakylz1EsUCXi2YsKSOKVad/enZCvv10SJEiQg7dx/UfAoLioVf18p6FaYhSpBReNCeTx2JUctfR1fzxULsw2tkyDyt64ZgBYpbAXsyEXlAqmUn9hSTSHNewBpsHpt3Il8jPoFIjtwDSsRk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782319733; c=relaxed/simple;
	bh=tUd9MSOf6Gpfnj/DjRgEetNk24cj0Ww3vsmnBOJTSdU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G1W8gGA5DoDeXQDIHVHGqGxuFq9asCGfUv2aIdYAgS/PgDfnT9szQLOAvsaAaZhjwMjFMH0Rb9ekBreFD4bWkLDAgNGmIRftsnbg2C8Z6WwJvD74Mkj1oDBmtB6Xd31siVX92YmklRHDiaAzk0PViY99i0v8ZelF48Sb5+cBr1k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qRTh3Q01; arc=pass smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qRTh3Q01"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2c7cfa17fedso10235165ad.3
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 09:48:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782319732; cv=none;
        d=google.com; s=arc-20240605;
        b=Pva6PYb6TNPMokvP48kn1ugvGi6G//llY1j65jmZxi2R73C0aQY3VuAtOtis1kGVYc
         mMmoyrOw2SW/FkO4LGNezKWW5AiV0bQql1qL3iXw+mklvX0LcsX4c1NJiYgBzV5+2YsB
         0dLsHGF5XaH6pSinwN7kPHqmHJNRKzIQ8mvK7KDmPwt+WmwZhMj1jaKfdG+4Rofg4gNL
         H76gJHhUqAshPluTiQ4NnYfLKCJvKH3V5xpNCWICJ/n1bgq9IghBBR9L0MQVjtb1xrnU
         MwMt+B9Ry5ZtsJljjNXrbhNNtzD5VL0rACDTUfL59tJ3eyxtR2WaawOJ7wbNiNg1e2zd
         1eqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Eqa0a7zsYCqL0jsMUMAnI+leBn+5NE0HEyi9TIA0TpY=;
        fh=s3zDK4oIW35lnMNj6ctNoLUCgCMK6Fehs3aY4gQYlrc=;
        b=XXXNcUSSMcqxDzD+Nj4t4BBAJFA/roxoaL5aYV8WkV95FdMP0CE1kOdK7J7F0sxhYg
         E4DUGuTQ7J0kZWhyGPOC0yOnJB3xpcj8KuOvI1DEFSIvrbkWWCn/L42k+T5p0j9SjExl
         h9JsKaV/gEZgK5kFntMvMbclpQMHs+GLai5RBeML2l/yyrYOxt6ZnG3Dg90CD5lvGWDr
         qwokjS20mgt7fH4VjdEmqRCnELHO3XWkX4HOymZygKnOOduLQPZpsPiIUCmdjYhlqsEP
         wayBlKwu6TzCff++1uuMxBPm/dnsR0REMpff2z83yNAcCI5W93bi6ZqncA9oqocb5JlQ
         Cn4w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782319732; x=1782924532; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eqa0a7zsYCqL0jsMUMAnI+leBn+5NE0HEyi9TIA0TpY=;
        b=qRTh3Q01H2krDwUIya6NmDrNcq2WTKHraOvAO7//F+LHVRNBYfq2VrhOQUfrknRMw8
         Id2b1zEHPatOallLPU6r2CtvmZiEug8trh45EuF2ox39v9c+xIdT4PrV+1ntLMWR7liE
         qyD5FXSlivwj26RQ4q1Mkv+sf6jgwCGyYa3jg616HC4Jd47XW/1+ISy2Q1Fe3JismCGd
         3fTfsJHUzJg+MV71414EHPyzJ19ailKdPIu2czomEf+SYPp8rVXTvQakf1KJ8RXgRQ4S
         K7cVLEdkTxYmUHmqmeIA5UgJIURFSHOtTeyJEb79VqzVM6cAGz9YbVCru79bDk+ejdgE
         dB3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782319732; x=1782924532;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Eqa0a7zsYCqL0jsMUMAnI+leBn+5NE0HEyi9TIA0TpY=;
        b=rlbC2+G4yOf+puxENbATldm+YF7xd/zDxX1vSD9nwZADkF01mGnbwUmwLSIi2owl1g
         yNpogkIb/jCX89FTmlAIA641A0SHQHM5BVvawUYyb+Q4z/nL/f0Rt98njAH5vDPIVpfA
         AbdlZtmwEsgBtVn51sHevsfC3ktR3UoaQd2ihuQ1RbsJwyYEpWRTYp7oGMWCiWGs0Yj4
         5uuj/+iKXgoWEyhhOL3iKeZk1DFsfFJlzzCWF+wkzDwsCRCP/Nasbj3opSMbWnUzp0j8
         /EwmHEV6SASVywvtJ1hx9Ngq8c7yRTzu1/XqMohyBGJmmT8z3BDV/6aYiw/pT3VcTw3J
         fRcw==
X-Forwarded-Encrypted: i=1; AHgh+Rr308552Dcu6mXvxB5+gBMOVfyY7PIkUg+oqyUe1qIJ2HgkzyS8DCQ7QXHqw/x7n+Yn+5F9+XsLKGv7@vger.kernel.org
X-Gm-Message-State: AOJu0YwfHjvWgs9Pmzvrwmsr4gfxZmxH7Dpd0b/Y72zsAdZDAO7TQPh1
	KLSKAEXaHi9in5vlrzX4UJtnlyAU/kQ9Y6WgPby/XFZxP7tB808JGERPnRXwL8l8Ib0Mn6baHXk
	mRSVrH4niVHGN6zSCWtqznd5tF+Z1e+iaI5QW/1DIew==
X-Gm-Gg: AfdE7cl5wrKXdc8/cEkp2RBmlWb3arpOKEo1oCR7RGAGQo58i8iWHA2VFDSVY7QWQGr
	gc/SNpSmP1brYa0GGy0pRyfz7wwqCrEBxdDK3aZJ9HX3/qU8Vt4L3wjyUk0GhImxHMX1WwuUUvR
	hNdK0xhUISipxdeY6KTQWzuazZiNdt6qQZokWH7Dg5uQDhTTSGGyf4MWuYxHV+fd01sA/eJCnrS
	g8ze+JXU7WdJ7+RA/+06qrfNNDcj+ZjDfUaiUiU4HL9fO2CSZGTlv3FFE+EoWwuohuZ8YMdVzI2
	zNLcDcIi/jwCWlxEP1HM9t1/6cAAXuxgLwASxxzdpx03lmICZrTiuyRNmcDh0WR/HvwXQLxWfJ9
	mdR0v+RF8BXlP
X-Received: by 2002:a17:903:1aad:b0:2c1:ef9:4516 with SMTP id
 d9443c01a7336-2c7e15c5297mr43674665ad.35.1782319732029; Wed, 24 Jun 2026
 09:48:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624155421.211626-1-nishidafmly@gmail.com>
 <20260624155421.211626-5-nishidafmly@gmail.com> <20260624160331.9C5F51F000E9@smtp.kernel.org>
In-Reply-To: <20260624160331.9C5F51F000E9@smtp.kernel.org>
From: Hiroshi Nishida <nishidafmly@gmail.com>
Date: Wed, 24 Jun 2026 09:48:41 -0700
X-Gm-Features: AVVi8Cc7jSMc1yHpFFYbnDbaOM6sh9UWwBeIwtrsGUnSAeV1VUeKclqRIYl7iAU
Message-ID: <CAE1ksKRGv8SVTuSh80L5VLs_O-+jhnSvnLi7fkLRT1g-HW3sZg@mail.gmail.com>
Subject: Re: [PATCH 4/5] md: use sector_t for recovery_active in status_resync()
To: sashiko-reviews@lists.linux.dev
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> [Medium] mddev->recovery_active is a standard atomic_t, not "sector-typed=
";
> changing the local to sector_t doesn't prevent narrowing.

You're right -- mddev->recovery_active is an atomic_t and
atomic_read() returns int, so there's nothing wider to narrow; the
int->sector_t conversion just moves to the assignment.
The change is only a type-consistency tidy (the local is used solely
with the sector_t curr_mark_cnt/resync_mark_cnt), not a narrowing fix.
I'll reword the commit message in v2 accordingly and drop the
"sector-typed atomic"/"narrows" wording.


2026=E5=B9=B46=E6=9C=8824=E6=97=A5(=E6=B0=B4) 9:03 <sashiko-bot@kernel.org>=
:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Medium] The commit message falsely claims `mddev->recovery_active` is =
a 'sector-typed atomic' and that declaring a local variable as `int` 'needl=
essly narrows it', but the structure field remains a standard 32-bit `atomi=
c_t`.
> --
>
> commit 7ec77a6b233ce4d151f7fc723e5f312b20b4ac92
> Author: Hiroshi Nishida <nishidafmly@gmail.com>
>
> md: use sector_t for recovery_active in status_resync()
>
> This commit changes the local variable recovery_active in status_resync()
> from int to sector_t. The commit message states this is to match the type
> of mddev->recovery_active and avoid needlessly narrowing the value.
>
> > recovery_active holds a sector count read from the sector-typed atomic
> > mddev->recovery_active and is then combined with the sector_t values
> > curr_mark_cnt and resync_mark_cnt. Declaring it as a plain int needless=
ly
> > narrows it and mixes signedness into sector_t arithmetic; declare it
> > sector_t to match.
>
> [Severity: Medium]
> Is this description accurate? Looking at struct mddev in drivers/md/md.h,
> recovery_active is defined as a standard atomic_t:
>
> drivers/md/md.h:struct mddev {
>     ...
>     atomic_t recovery_active;
>     ...
> }
>
> Since atomic_t is a 32-bit signed integer, and atomic_read() returns an i=
nt,
> does changing this local variable to sector_t actually prevent narrowing?=
 The
> implicit cast from int to sector_t will now simply happen at assignment
> rather than during the arithmetic operations.
>
> Could the commit message be updated to reflect that mddev->recovery_activ=
e
> is a standard atomic_t, rather than a "sector-typed atomic"?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624155421.21=
1626-1-nishidafmly@gmail.com?part=3D4



--=20
Hiroshi Nishida
nishidafmly@gmail.com
