Received: from va-2-45.ptr.blmpb.com (va-2-45.ptr.blmpb.com [209.127.231.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6705736F414
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 10:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785405932; cv=none; b=lSlELyWQ4u/UABaw588mRgzAfZCxz6fRoMzHEIR83lTGxaQ07d5fFyS+5g41aWveeoGa31o0ujEEQ/dnubqXjpl+GRizt8xnA1kxL6AiEY/WNGHrlHMI+IRmyyeCoPYjYLY6k3gHhw//XVevtZql4Wz4yWYp9HIBB1DzCFSZY8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785405932; c=relaxed/simple;
	bh=PwlVLDx7FfCy+h0AtG4OwmgfqEnoy5iBYBI2QRjMV5g=;
	h=Date:From:Cc:Message-Id:References:Content-Type:In-Reply-To:
	 Subject:Mime-Version:To; b=jvvmLKQBiKqOZZYRFnX5rbrFPW3MkFN/K4wivFlZRfxyeLCtVcFvs+GmlV7N+VIgIoYUy5oS2T/Wa2CSj1bFWbC6+zOysFCGKrGTFN6Nh+altZR+LkA2NW8AaAMX6v1SHf3RDISiN4I20gDZCI7SExBSKpEEMJUxuFYLBTo0qDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Q1yKtoNv; arc=none smtp.client-ip=209.127.231.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Q1yKtoNv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785405923;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=IXsA3oL5Sxz7H5QknF1PoPejcEPNJYQmxvvfmK+ruSI=;
 b=Q1yKtoNv4O2ksi4wAZAj8TPgaH/cWL/RFfKgrD0KfjZsWCLE1/tRBAn0K74VjX5R5whvVd
 P+R3tU6cXsmOldnAdn3ZdraDhviwoE30oEnmrbkNEnXPM93H8AdkeA1bDmUZ9Cv6OkmU9K
 qHsrqH8IN9gH59iptsPCv3/jEk27y1vdQj3UzRgmpQwOHl5uA4PeFohUS/FALPmMDZ0xAQ
 mWfqFMD0Gt7px2qnEKBh3SvPdzfYj5UVMKfgOXMj9Wj9gL6R3BFAAdOA6JLEIFN9uPcFK8
 IM8czSx3XE0JQlgsg2S8BZWiNYls4A9q/8dLj7diz/2YKeVHEk/UQoZqzmnaOw==
Date: Thu, 30 Jul 2026 18:05:18 +0800
From: "yu kuai" <yukuai@fygo.io>
Cc: <linux-kernel@vger.kernel.org>
Message-Id: <2f1ea07f-53bb-4391-bdfb-bae394d1678c@fygo.io>
References: <20260627102519.136940-1-chencheng@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Reply-To: yukuai@fygo.io
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 10:05:21 +0000
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260627102519.136940-1-chencheng@fnnas.com>
Subject: Re: [PATCH] md/raid5: protect lockless recovery_offset accesses during reshape
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26a6b21e2+b1ab0b+vger.kernel.org+yukuai@fygo.io>
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>

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
Applied to md-7.3

--=20
Thanks,
Kuai
