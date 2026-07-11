Received: from va-2-45.ptr.blmpb.com (va-2-45.ptr.blmpb.com [209.127.231.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342813A5421
	for <linux-raid@vger.kernel.org>; Sat, 11 Jul 2026 16:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783787065; cv=none; b=YLHENNpCOG/nVWB2m0K3c6keSclBFGECw9sqiXlDKlEjNk+bPj3TE8wLec5r6I9+2ZXHBxRHTRqP2CtT99C5OosyAxurSvXE13GOZiNUxq+yvO+mGgOo/FA4QMH1nsTa3Pwj8k26CVrmk2zCi1z1BRiqeAGfmU1HVoC5/PF0E7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783787065; c=relaxed/simple;
	bh=sQX89vlUHHfbjR2QTiTRIsmIc8XFL0n9bKZrOqRJrTw=;
	h=To:Subject:Date:References:From:In-Reply-To:Content-Type:Cc:
	 Message-Id:Mime-Version; b=rP1eKjHn6HKGWdZCz2tODibfWoC/eIVcP8iMMm61Ui4SLCigVuf+vQcEa0jdnQvRWZlwPZxDhQ/zUi1988/opISiWFPzNJCIUhXJzN5YkWkh5V7dYoshG9+YBAB/ylQ/XdKKwVIwGCLwai+CEG1qkQ9yqaIM85a07736tMQvW2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=dBd9NIqk; arc=none smtp.client-ip=209.127.231.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="dBd9NIqk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783787053;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=dSCYIkBFQtaB/K9CTNTwJ1M1YoULDJChYYaz+D/TZu8=;
 b=dBd9NIqk1X1uKYLkeRqkV/lA2ss5co2uYtsmf4NkKvveRfn11vGhoJPKVfVizWGjTrLKbj
 oJpM5z10zdbYnEAC1pRIAszbK+aPvhl3QQ3s6dkcYPy4pFd4TshkdqiUHu0F+I9bKP8E0r
 oGBYp41ABFngRhVRXD5yni4YPq2uF8uJAXbX252ltgiqhq458zTuww1ORDaigHqgAil4jl
 2wH49H/C84xGcSnAI2OfyA6Okr5tkX5awMF1Jn4kZGGSsvuao2uckH0qHG/qRua6PWC6ZG
 +87jcJHVG/yv5a8VUsk+7dBn6NA5Vk2W4GEIFfTsTOMyUkpoqBRTg4D3gIibFw==
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>
Subject: Re: [PATCH] md/raid5: protect lockless recovery_offset accesses during reshape
Date: Sun, 12 Jul 2026 00:24:08 +0800
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Sat, 11 Jul 2026 16:24:11 +0000
References: <20260627102519.136940-1-chencheng@fnnas.com>
From: "yu kuai" <yukuai@fygo.io>
In-Reply-To: <20260627102519.136940-1-chencheng@fnnas.com>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a526e2c+65365e+vger.kernel.org+yukuai@fygo.io>
Cc: <linux-kernel@vger.kernel.org>
Message-Id: <3d28447e-e1f6-43a6-804f-fb5ff46b2957@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/6/27 18:25, Chen Cheng =E5=86=99=E9=81=93:

> From: Chen Cheng<chencheng@fnnas.com>
>
> During reshape:
> - reshape_request() advances rdev->recovery_offset for non-In_sync
>    devices locklessly.
> - analyse_stripe() reads rdev->recovery_offset locklessly to decide:
>      a. use a replacement device to read ?
>      b. a device can already be treated as in-sync for the current
>         stripe ?
>
> one possible scenario is:
>
> CPU1                            CPU2
> reshape_request()
> -> mddev->curr_resync_completed =3D sector_nr
> -> if (!mddev->reshape_backwards)
> -> rdev->recovery_offset =3D sector_nr
>                                  analyse_stripe(sh)
>                                  -> rdev =3D conf->disks[i].replacement
>                                  -> if (rdev->recovery_offset >=3D
>                                        sh->sector + stripe_sectors)
>                                     set_bit(R5_ReadRepl)
>                                  -> or
>                                  -> if (sh->sector + stripe_sectors <=3D
>                                        rdev->recovery_offset)
>                                     set_bit(R5_Insync)
>
> And it could be:
>
> - reading from a replacement before it is recovered far enough; or
> - treating a not-yet-recovered device as in-sync for the current stripe.
>
> Fixes: db0505d32066 ("md: be cautious about using ->curr_resync_completed=
 for ->recovery_offset")
>
> The race report:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KCSAN: data-race in ops_run_io / reshape_request
>
> write to 0xffff8bdee168b270 of 8 bytes by task 1704 on cpu 10:
>   reshape_request+0x1292/0x17b0
>   raid5_sync_request+0x815/0xa00
>   md_do_sync.cold+0xf8d/0x1516
>   [......]
>
> read to 0xffff8bdee168b270 of 8 bytes by task 1696 on cpu 9:
>   ops_run_io+0xc25/0x1960
>   handle_stripe+0x2273/0x4570
>   handle_active_stripes.isra.0+0x6e0/0xa50
>   raid5d+0x7d5/0xb90
>   [......]
>
> value changed: 0x0000000000091a00 -> 0x0000000000091b00
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 34 +++++++++++++++++-----------------
>   1 file changed, 17 insertions(+), 17 deletions(-)
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
