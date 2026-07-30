Received: from va-2-59.ptr.blmpb.com (va-2-59.ptr.blmpb.com [209.127.231.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF963B7769
	for <linux-raid@vger.kernel.org>; Thu, 30 Jul 2026 08:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785401981; cv=none; b=Khuk80ovAFdvoJoKmkDhsgZJCGmlgiFYqXDH+W3FEYnwN0KhRVqSg/GWtlwnusujeBQolA2jBT/Qe6eW3YYWlWe3kTcrGduxTPnJ/eUw8H+s4W9YfatMDVJN1GxESToZyloytex5Knak2iXRKa+06LJjwVUmw0/BqXho2Q7bCL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785401981; c=relaxed/simple;
	bh=x6Nb4WYf7C1EM6ANSQsnJs8WPhwF7Va3Sg64k5rYpF4=;
	h=Cc:Date:Mime-Version:Content-Type:To:In-Reply-To:References:From:
	 Subject:Message-Id; b=IYUe+EjvsC9Ta/pWr7dZIyKKYfOsrxa1bmRZW1FFVoX/GcMnii32z2rYvNGZPnwiGrOyIJU9kuwzieTtYEhHkuMA1926HkVH5AQhNS9l7f0mFX+BDDUqsdC9KcbSoA6DEQeTiB4ogqA712Bg3kdlvudmdYeR00u1No25BVxIM7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=OAGtYC5y; arc=none smtp.client-ip=209.127.231.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="OAGtYC5y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785401965;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=JVvPd2kmNTSKthwF6Xn9Ai6yfPD4UsR63PKVG9DZ9z8=;
 b=OAGtYC5yyOJldalTvOwmLWXCZS+2Au8+5xvwt2tOrReyw5EEFKqoO/nhXEM7ZuI+DeqXqK
 MdbYCc5MWYXMBfyN0NZOL2/1oLkGRY1BaG118wNdlolXTX5tT1H1a/svNdBGT8SPYxcCLv
 wLLAeKU/6Yj7icVI9HUyUr5xSEwtsfluQ6kpQE9AUpJu2X75e0wHTw+8hKbXxj2yrC63Fn
 xnLJVMSh3QQrtabhS4B4hr+701Y+A3Bqhk0s42aQCgYUpqW8Opvyk84dmydN60z0IRR/wy
 D+C/ssXR0QZVA9GNJ0KeqOp1T8+DQQGzs2K3WzYGvACEnEws6M1wEf+sCwxHig==
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26a6b126d+3f5c26+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
Cc: <linux-kernel@vger.kernel.org>
Date: Thu, 30 Jul 2026 16:59:20 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260624024042.2561803-1-chencheng@fnnas.com>
References: <20260624024042.2561803-1-chencheng@fnnas.com>
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/raid5: fix lockless max_nr_stripes reads
Message-Id: <079ff51d-fb2b-4064-b560-33ce2b9ededb@fygo.io>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Thu, 30 Jul 2026 08:59:24 +0000

=E5=9C=A8 2026/6/24 10:40, Chen Cheng =E5=86=99=E9=81=93:

> From: Chen Cheng<chencheng@fnnas.com>
>
> max_nr_stripes is updated under cache_size_mutex in the stripe cache
> grow/shrink paths, while is_inactive_blocked() and
> raid5_end_read_request() read it without that lock.
>
> Use READ_ONCE() for those reads in lockless path to match the WRITE_ONCE(=
)
> updates and avoid KCSAN data race reports.
>
> A similar issue was previously fixed in commit-id:
> 	dfd2bf436709b2bccb78c2dda550dde93700efa7.
>
> Fixes: 0009fad033370 ("raid5 improve too many read errors msg by adding l=
imits")
> Fixes: 3514da58be9c4 ("md/raid5: Make is_inactive_blocked() helper")
>
> KCSAN report:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> BUG: KCSAN: data-race in grow_one_stripe / is_inactive_blocked
>
> write (marked) to 0xffff8f01f0b5a268 of 4 bytes by task 12616 on cpu 9:
>   grow_one_stripe+0x2d8/0x320
>   raid5d+0xb57/0xba0
>   md_thread+0x15a/0x2d0
>   [..........]
>
> read to 0xffff8f01f0b5a268 of 4 bytes by task 12670 on cpu 11:
>   is_inactive_blocked+0x97/0xc0
>   raid5_get_active_stripe+0x2fd/0xa70
>   raid5_make_request+0x4aa/0x2940
>   [..........]
>
> value changed: 0x000003b9 -> 0x000003ba
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/raid5.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
Applied to md-7.3

--=20
Thanks,
Kuai
