Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEBD412E1DC
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 03:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767668735; cv=none; b=Lr8RmEebJChxRts/Q2xIYYVah/dFh/eiACM14TC+0VRv47eL/tP7ZY30Gzij3J6EXs2GW1S+v+lnQ2SXfld2pOIHf/s+TuFGigMh+q4Gd4qVOmuhge/V/1HljzO/FYy1gr46qgzhPXy++HcB+lOInuZqbwWPO6Zc/bPQMgO4tdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767668735; c=relaxed/simple;
	bh=g9toQ69dPG/PPOIIdelImHscA92FMe+3ehGimBJlvp8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dg0QjD6ARrXwFyuYROlsRdYaRJn0vMqsfNzDzeI246KJ2oI0el/SoQ7ROsbUZuKJWismvJyQBrxIXi2qNBxNqkyCzuuxx7CkL2mvZ13a2H3jcb1ULS8qDA1FVfZuP15I9XIxH7LgmOVQxGuMzzHZu8O9WUR8rEiP3QaD8I12hJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QsFNaHgz; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=HWkb7xQM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QsFNaHgz";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="HWkb7xQM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767668732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dRioDv+RdG9PtpMH+U4/WCL8hMve0XP2yih5IeXRr6I=;
	b=QsFNaHgzakSbjUm6EZDJS5pQ36RzfMzqsoXTSOSeQDpW7Le+ENPEyocRAWmXvONZzvEd5T
	BtMi9OpVaKB07ybnxj0n0zsnVa7TaQasJjYb3EzKA4Ga1Y/+I9a0Xnhnz6CvxEQ16jTD+G
	MJx0bL23mnYW+uhZN8Tbj3iRoWt9NHY=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-hdVGuOMgPjy8ZfB8gFsnIA-1; Mon, 05 Jan 2026 22:05:31 -0500
X-MC-Unique: hdVGuOMgPjy8ZfB8gFsnIA-1
X-Mimecast-MFC-AGG-ID: hdVGuOMgPjy8ZfB8gFsnIA_1767668730
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-598e12eab38so463193e87.1
        for <linux-raid@vger.kernel.org>; Mon, 05 Jan 2026 19:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1767668729; x=1768273529; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dRioDv+RdG9PtpMH+U4/WCL8hMve0XP2yih5IeXRr6I=;
        b=HWkb7xQMaDZm5vP4UzsOrtwrckzoAtFsX7th/5hRvipDO5UEYB8SrK7RfuYlnsSVpX
         z2C9U38C09PfwHfd8rtA3nwrrL+IrgArnAhjyQDRKxyED/fHrpQZLo215mR0V5nOP4Q+
         M+A0e6IEhuvXuEiPohQLTAzhyCm9c3933N5ihnNaXGACJNBIRCrtJW8lM6rJ7ka0PDf8
         qmN4bHbpk2mxzOw+/s5LVKsjdKYn4cz6cah+vfGnWwk+WgED6wQ2pzYUPkrVzhA1BW5W
         u4UO+TA4P9fOXoSNG7bjPVOgFqSoMnubX12GzibWe3/9yp0KgsFZt5O10AZ7OKt9K7lJ
         F3qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767668729; x=1768273529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dRioDv+RdG9PtpMH+U4/WCL8hMve0XP2yih5IeXRr6I=;
        b=UL8sRozxQijlPh5K4rGZc6YQoEJVJymy62L2w9Xg7EgQ0W/b6/95dARrnEDp1U5SIC
         7HGLSv85R/gh9GLKQGKeRwRUIcTBl/es1s0LhP8thpJII2OYcVlj7pO4IY8ck/+cPAgW
         qJzDddI0ZRKZz0mvjr79kYce/x9Zyq57KXYkIZz/zBqGF8sNeFPS4YpT9Q/UXwqabUwy
         ttiPkjVgEFkFHZWdPlfcKwfvDMPn6B6v7Nsl/8zGkWwTtcReIwvA+8aNHYHv1phwlzFn
         WwLmjOTl3qyMhpcX1jL88ZtN1UPSuK2lA1gxU9JjxN8FD8kJSiaZoDHNoRYOhtiS+qpO
         zJpA==
X-Gm-Message-State: AOJu0YyETKMmYyiDYhSU7SCUicuZOVh2h88uVmt8jucaRl3z2FJB952F
	AYp6pzJKM14DtY0c95inAiy4GZtuWrusjSTd95qkk/QtoKQkDtu5At7vz9hvL/54Yx1Hqa1l4uU
	CI9Eu0bsn2j4RxbVE4+inaYOXH2EREhdJgyjsiXvhUJDr8ALXCnmFD9umuTibNHNpaFJdhhxXzL
	14tKrROLGf3cQtMWTW92LpYjH0KyjQ3Qt8BwM8qB+CofkN0g==
X-Gm-Gg: AY/fxX4vfz80Oh4+trVvgbEGQ5gsF2jxf+ddIRxOY4Azod03SlHVyq7Pyd/bSBEJ3YJ
	aNdC58kvBSpYE+Lz4ua0TSam0TPyZW6k05LJWEnvOjL4SQcuvH49YLuUKQRWzAQgnn4eV8sW1oZ
	fn06qUDAa0Bi9rpcLbBNUNUuqazGrSKnh+wYjUAP9VOXI18in45j8XTxRoWFkXyYfKUUIkzff8L
	au77BwbS/yaRBF0A75a91y6wmRdwmNUrSwgl+BVtf09V0W7hXqlERSI6uOI7lEw6eFpgg==
X-Received: by 2002:a05:6512:1086:b0:594:768d:c3ef with SMTP id 2adb3069b0e04-59b652bc603mr521218e87.30.1767668729019;
        Mon, 05 Jan 2026 19:05:29 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH80AAwbwouxB7eCH19TzUrcZvT7LzUKmxJVOXpZ1H2L383sJfEJ2YmGqX9D/dSyFJFAxLB+4lso1MxwcSNpH0=
X-Received: by 2002:a05:6512:1086:b0:594:768d:c3ef with SMTP id
 2adb3069b0e04-59b652bc603mr521211e87.30.1767668728609; Mon, 05 Jan 2026
 19:05:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260103154543.832844-1-yukuai@fnnas.com>
In-Reply-To: <20260103154543.832844-1-yukuai@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 6 Jan 2026 11:05:15 +0800
X-Gm-Features: AQt7F2q4ndVOy3cE1GGRhyaETMjgQKMujG4ijV7roEgiotVdTxGdxEiOA6D13RM
Message-ID: <CALTww2-2W0uX-3OKPjd2tyRUf97fJaHfedWuxb_+Ff65xnSGxA@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] md: align bio to io_opt and fix abnormal io_opt
To: Yu Kuai <yukuai@fnnas.com>
Cc: linux-raid@vger.kernel.org, colyli@fnnas.com, linan122@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 3, 2026 at 11:46=E2=80=AFPM Yu Kuai <yukuai@fnnas.com> wrote:
>
> changes in v3:
>  - fix mempool in patch 4;
> changes in v2:
>  - add prep cleanup patches, 1-3;
>  - and patch 11 to fix abormal io_opt;
>
> Yu Kuai (11):
>   md: merge mddev has_superblock into mddev_flags
>   md: merge mddev faillast_dev into mddev_flags
>   md: merge mddev serialize_policy into mddev_flags
>   md/raid5: use mempool to allocate stripe_request_ctx
>   md/raid5: make sure max_sectors is not less than io_opt
>   md: support to align bio to limits
>   md: add a helper md_config_align_limits()
>   md/raid5: align bio to io_opt
>   md/raid10: align bio to io_opt
>   md/raid0: align bio to io_opt
>   md: fix abnormal io_opt from member disks
>
>  drivers/md/md-bitmap.c |   4 +-
>  drivers/md/md.c        | 117 +++++++++++++++++++++++++++++++++++------
>  drivers/md/md.h        |  32 +++++++++--
>  drivers/md/raid0.c     |   6 ++-
>  drivers/md/raid1-10.c  |   5 --
>  drivers/md/raid1.c     |  13 ++---
>  drivers/md/raid10.c    |  10 ++--
>  drivers/md/raid5.c     |  93 ++++++++++++++++++++++----------
>  drivers/md/raid5.h     |   3 ++
>  9 files changed, 217 insertions(+), 66 deletions(-)
>
> --
> 2.51.0
>
>

Hi Kuai

This patch set looks good to me.

Reviewed-by: Xiao Ni <xni@redhat.com>

