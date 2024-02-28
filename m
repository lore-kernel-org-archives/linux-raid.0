Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9BE14831E
	for <linux-raid@vger.kernel.org>; Wed, 28 Feb 2024 12:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709123739; cv=none; b=g8a58CoevzcUq5fdEHyYMyH9fTR3j8G82Nl/cvkBzwjB2sFCrX/ywH7qVEQhjTHEdC4vUD8od/kQrQDXA3BKLOKSGVYUJwRCp3zL26IBMZsVDX6G7RgS0CHG2YTxaXgoSfCTBuJ1DKqab8ljGYqPi7f0a5G30K7pdLwvW5j6L7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709123739; c=relaxed/simple;
	bh=foL0RQpwU9W61mkkBioqi4654qXiuIpQE/3zmH03wk0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NBZlV6R3CWjR0YhtD4z1Gc+BgiRkmOa5OFLxWyj5pJygFK6vn1P7zWkRASnH4fZKFLhpGSzJsuqrWTsccSWLQRYJIvFO28zoinDspqZaIFUmgpN3njeaA2WeadX8R7G7N5Xhc0z8mNOy8Tq18HYxCksBnMLZR8Hy6ShE1Hy5ing=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=glRwgyVa; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="glRwgyVa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709123736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0nKkfEqQcevoAqU5/3pnr5go0HmLBqkrwWYNjYP7RdE=;
	b=glRwgyVa6IHuYoMKdTSpJzyjNoqJOD4ayYnmd+9qpIlROiGgwHrZllLVr46dXco2HrLKjc
	fgDPR2CcP0XatOWPgX/iEiIqz3gtNnCptZAZz/PIYJTMzFpoe9QFTZd31of5gz5Q/dzM0X
	Cnp1UHBqdsXHsXTVyfoc3EHaJeFRgpI=
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com
 [209.85.161.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-533-BvXwYWOONZeXoMzQ6nNl8w-1; Wed, 28 Feb 2024 07:35:34 -0500
X-MC-Unique: BvXwYWOONZeXoMzQ6nNl8w-1
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-5a02065e470so5122043eaf.1
        for <linux-raid@vger.kernel.org>; Wed, 28 Feb 2024 04:35:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709123733; x=1709728533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0nKkfEqQcevoAqU5/3pnr5go0HmLBqkrwWYNjYP7RdE=;
        b=LXERIRfVRjpvxA5qonhG+L9xBmzTZavVbHCNZK7NANtQ95fCYpRsrIhMKKo2sz7Z1e
         oCjBKFZcvlVfomQtzLsSiPyZ9a7cdtok1QjqzraZDmwshydkTaH9yffrHskUzZCEhHfS
         xNp3TMRVoex7zURmO5CBwbwPMEy/Luxj/yjualJXIOEltnFhhXeeADM1OPDWiALPNkhn
         r4dhP8ovnOBbQjrMgOuu+lyTi0+jnAyivqbHYVdGqWsLYv8tSOGtG3mtfSOkV98wKetY
         Oq6drc4L/3Z9B4itvOOvoJ6LGo7GQgB8eMhuAmtNmjyf8ry7rIGK+DMxfBoanFZh7bIK
         3oxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeABmXMV6FBRIw8OhtmvZ88WdKxl1tRDWwTDsgdhZYOiz2JGURD6LlVrDaRm7loVHJDJySgr8Zjy0v0NPPy1hTjENXSVFsD+XpJQ==
X-Gm-Message-State: AOJu0Yxl7TXDIKan2i0mzVlOC3lWQOQf1i5r3obOIMzAGAmjUZX5Xc50
	fDAqkKbzoJLDFR/NpFgRGgqBb6GJwnGLSKFex+SZP8oIjZl8FTDPmyoa+MY4f964rDzpTVXnor/
	xhDBlfoyYzlph/9TFWVBQ0pkuPn/V37L9Ajt9Gq/5lCmBEQuGujYFUkVOdBYh6kA8Ruqe0WAczl
	9pEff+S906k4IYTTJpFD6nwZRiUBawhJL6OWhc3VQD99i5
X-Received: by 2002:a05:6358:9991:b0:17b:5e32:6009 with SMTP id j17-20020a056358999100b0017b5e326009mr15677561rwb.11.1709123733549;
        Wed, 28 Feb 2024 04:35:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFeRsYySUjU+B6O2Z36vB/yO0JBrMVskwe4Vu2AhHXgdTjvOGoSVrhIduUtiVTrLN2XIRvgK5Rt000TLfAIZ8c=
X-Received: by 2002:a05:6358:9991:b0:17b:5e32:6009 with SMTP id
 j17-20020a056358999100b0017b5e326009mr15677545rwb.11.1709123733270; Wed, 28
 Feb 2024 04:35:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240228114333.527222-1-yukuai1@huaweicloud.com>
In-Reply-To: <20240228114333.527222-1-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Wed, 28 Feb 2024 20:35:21 +0800
Message-ID: <CALTww2_NF6yMF7Ppc3DFj+-yERqM3gDy+Xt9u1_Pu56iw0zLbQ@mail.gmail.com>
Subject: Re: [PATCH md-6.9 v3 00/11] md/raid1: refactor read_balance() and
 some minor fix
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: paul.e.luse@linux.intel.com, song@kernel.org, shli@fb.com, neilb@suse.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 28, 2024 at 7:49=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Changes in v3:
>  - add patch 2, and fix that setup_conf() is missing in patch3;
>  - add some review tag from Xiao Ni(other than patch 2,3);
> Changes in v2:
>  - add new conter in conf for patch 2;
>  - fix the case choose next idle while there is no other idle disk in
>  patch 3;
>  - add some review tag from Xiao Ni for patch 1, 4-8
>
> The original idea is that Paul want to optimize raid1 read
> performance([1]), however, we think that the original code for
> read_balance() is quite complex, and we don't want to add more
> complexity. Hence we decide to refactor read_balance() first, to make
> code cleaner and easier for follow up.
>
> Before this patchset, read_balance() has many local variables and many
> branches, it want to consider all the scenarios in one iteration. The
> idea of this patch is to divide them into 4 different steps:
>
> 1) If resync is in progress, find the first usable disk, patch 5;
> Otherwise:
> 2) Loop through all disks and skipping slow disks and disks with bad
> blocks, choose the best disk, patch 10. If no disk is found:
> 3) Look for disks with bad blocks and choose the one with most number of
> sectors, patch 8. If no disk is found:
> 4) Choose first found slow disk with no bad blocks, or slow disk with
> most number of sectors, patch 7.
>
> Note that step 3) and step 4) are super code path, and performance
> should not be considered.
>
> And after this patchset, we'll continue to optimize read_balance for
> step 2), specifically how to choose the best rdev to read.
>
> [1] https://lore.kernel.org/all/20240102125115.129261-1-paul.e.luse@linux=
.intel.com/
>
> Yu Kuai (11):
>   md: add a new helper rdev_has_badblock()
>   md/raid1: factor out helpers to add rdev to conf
>   md/raid1: record nonrot rdevs while adding/removing rdevs to conf
>   md/raid1: fix choose next idle in read_balance()
>   md/raid1-10: add a helper raid1_check_read_range()
>   md/raid1-10: factor out a new helper raid1_should_read_first()
>   md/raid1: factor out read_first_rdev() from read_balance()
>   md/raid1: factor out choose_slow_rdev() from read_balance()
>   md/raid1: factor out choose_bb_rdev() from read_balance()
>   md/raid1: factor out the code to manage sequential IO
>   md/raid1: factor out helpers to choose the best rdev from
>     read_balance()
>
>  drivers/md/md.h       |  11 +
>  drivers/md/raid1-10.c |  69 ++++++
>  drivers/md/raid1.c    | 539 +++++++++++++++++++++++++-----------------
>  drivers/md/raid1.h    |   1 +
>  drivers/md/raid10.c   |  58 ++---
>  drivers/md/raid5.c    |  35 +--
>  6 files changed, 437 insertions(+), 276 deletions(-)
>
> --
> 2.39.2
>
Hi Kuai
This patch set looks good to me. By the way, have you run mdadm
regression tests?
Reviewed-by: Xiao Ni <xni@redhat.com>

