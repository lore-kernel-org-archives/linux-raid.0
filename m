Received: from va-2-47.ptr.blmpb.com (va-2-47.ptr.blmpb.com [209.127.231.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9583DA7C5
	for <linux-raid@vger.kernel.org>; Fri, 10 Jul 2026 07:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783669832; cv=none; b=uiJkrt3eGHJ3JBmnbnwI8JT73+xlU7LPDAeglyu8NovnzAf+GrxqlV8NLGvfoiQ2s7ZbI+7uIYEcGXuFWajE7gUbaSBfD1M9BKe1MDSAcxhMYKdUB9tZkeylD6ausjcjH/lksdk4rsBnDa1LXbscNSe+HznMxiqngnYTDXJFCOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783669832; c=relaxed/simple;
	bh=X3d1Hk5Eil9ZZioL2R/4TARq2IsZRzoA3R9uhXl42F0=;
	h=Subject:References:In-Reply-To:To:Cc:Date:Message-Id:Content-Type:
	 From:Mime-Version; b=kGOu2Ndvkawp7nge2lNAOCmmARNqlTdmFIQUnmAsdAxfBFF79ycxFLZW/TGq+zXTbbHdhXqdc47oaqrVHcROcjVvdvQQmVu1D3pk2aefE92rQBhzUhG6AGeJxBBx22j2Snc80CDGm9HwNaJCAveT36LmJQoQAH1I7OP7ndQhOLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=IDB8siwN; arc=none smtp.client-ip=209.127.231.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="IDB8siwN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783669818;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=TPZ3h+wgWXgHEkII3uDFC8EhhEG2VN/iny94yqQGGIM=;
 b=IDB8siwNF0Z1DzOUsSFcmDxXMfR0+sBPU+17SqbmFY1HJW8o5URpnQFaFBwwEbqxm6rvvR
 6gJgJmtKiqhhb6Yss8LBQsdwX0fxcbSu0nCr8lVdSNJnC58WT10aLg1qtp21u0KzKFiTWw
 YI/uDYU7JdOP5KyrmEXJIApsr9tKGYJMcFJTbmmytmxqpRyLKsZg6wVohnOO9m3t7VB46s
 nHvAMBIeBHTyUPHPiIPtejW/4MTZTw5EQ7ziQ2Nk67evcSEkLIghOXbNpytv3VnrnphZRq
 h9AxzGwKCngBx9PLT38wsrHv0GFtrjhW3mGWquqJsdOT5Jw6OyY6AwKw2yoE4g==
Subject: Re: [PATCH v2] md: recheck spare changes before starting sync
References: <20260708112003.474537-1-abd.masalkhi@gmail.com>
In-Reply-To: <20260708112003.474537-1-abd.masalkhi@gmail.com>
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<abd.masalkhi@gatech.edu>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Fri, 10 Jul 2026 07:50:16 +0000
Reply-To: yukuai@fygo.io
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Date: Fri, 10 Jul 2026 15:50:13 +0800
Message-Id: <6fb282bc-5f2d-4fa5-8852-994f01054c14@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a50a439+008344+vger.kernel.org+yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/7/8 19:20, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:

> remove_spares() and remove_and_add_spares() modify the array's rdev
> configuration. These operations are only safe after the array has been
> suspended.
>
> md_start_sync() checks whether spare configuration changes are needed
> before taking reconfig_mutex. However, the rdev state can change before
> the mutex is acquired, so the initial check can become stale. In that
> case, md_choose_sync_action() may remove or replace rdevs while normal
> I/O is still accessing them.
>
> The race can occur as follows:
>
> raid10d          Worker                      Normal IO
> ____________     _______________________     ______________________
>
>                                               raid10_write_request()
>                                               wait_blocked_dev()
> set Blocked
> set Faulty
>                                               Skip Faulty rdev
>                                               rrdev->nr_pending++
>                                               .repl_bio =3D bio
>                   removeable_rdev =3D false     .
>                   array not suspended         .
> lock mddev                                   goto err_handle
>                   lock mddev (wait)
>                   .
> update sb        .
> clear Blocked    .
>                   .
> unlock mddev     .
>                   lock mddev (acquires)
>                   remove_spares()
>                   removeable_rdev =3D true
>
>                   raid10_remove_disk()
>                   rdev =3D replacement
>                   replacement =3D NULL
>                                               rdev_dec_pending(NULL)
>                   unlock mddev                (NULL)->nr_pending--
>
> In this case, rdev_dec_pending() is called with a NULL pointer,
> resulting in a NULL pointer dereference when attempting to decrement
> nr_pending.
>
> Fix this by suspending the array when spare configuration changes are
> needed, including for non-read-write arrays, and checking again after
> taking reconfig_mutex. If the array was not already suspended and a
> change is now needed, release the mutex, suspend the array, and
> reacquire the mutex before continuing.
>
> Fixes: bc08041b32ab ("md: suspend array in md_start_sync() if array need =
reconfiguration")
> Reported-by: sashiko-bot<sashiko-bot@kernel.org>
> Closes:https://sashiko.dev/#/patchset/20260628142420.1051027-1-abd.masalk=
hi@gmail.com?part=3D3
> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
> ---
> Changes in v2:
>   - Recheck whether spare configuration changes are needed after taking
>     reconfig_mutex, and suspend the array before continuing if necessary.
>   - Account for read only arrays, where reshape_position may not be
>     MaxSector even though md_start_sync() can still modify the spare
>     configuration.
>   - Link to v1:https://lore.kernel.org/linux-raid/20260630075640.1081634-=
1-abd.masalkhi@gmail.com/
> ---
>   drivers/md/md.c | 14 +++++++++++++-
>   1 file changed, 13 insertions(+), 1 deletion(-)

Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
