Received: from va-2-58.ptr.blmpb.com (va-2-58.ptr.blmpb.com [209.127.231.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D832C363084
	for <linux-raid@vger.kernel.org>; Sun,  5 Jul 2026 09:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783243917; cv=none; b=aB1+g06cJjoq2DRY+siaauLLa3aq3GmvhJqE0aOmaJTfcsI1vJAzhtVl3nKM6KAIeD0g8lH9czmD0pzWoRD/kroyKeeHArfhfhRTC/aGolJoh+mg+tu9Evg+Dh1DO9ctt8+YvZxOAU5LGd9uwrdW7ErpNILukLmT7jyGvgJNwv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783243917; c=relaxed/simple;
	bh=muSn6gdtnfl0uaYSTPJDeDXbUQMEPPXpEhikQSyVeo0=;
	h=From:Cc:Subject:Date:Message-Id:Mime-Version:Content-Type:
	 In-Reply-To:References:To; b=egJnMUDiuB2PrDvj9E35Ob83aZkfAhXMx9XckVAZNOzXo4w0kvDnc4m/pckj2sj4q004vZwc6qE0KGxBqqL4Nn3B1GIKqrHFvEswdHu70gk6xn36qsvfLfpDDzpOV6bHs9sm1EJyFN8HzF7/jpEcT1hMSydqwgH603HZRjgA1r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=HTMcRtw4; arc=none smtp.client-ip=209.127.231.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="HTMcRtw4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783243901;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=aEixqaZPguDjuw9UgDDFjdrsMM1Iv/4uJ9tp3Gq3GKI=;
 b=HTMcRtw4i1li+10kBs56lk/OTNH4uutwDDvAsVWTAFxsYuXLTFwKivVbkrMR0pyGCyjchY
 k85/tTAQBZ283o0n/2DsEnH9VAt5m1Jmuhp+jpRxHPIf7i9JoWKClBeZoVyoxJ6HVdU9LQ
 nyyqYtk94pymX3m8jFEgKO+vUIf6CAvZHzz9FrAgxMONOAy9HXPyDyDL7Qgd2pzgNmHh31
 2fHp3AK4jblyB5icP+PezHBH22ysyQsM3cCk1IIcBpQU+i6L7poLfvuNswltVexRtwUT61
 Cd84kmSESVH42J6US1x9Ewy3h5XLwMCbw/6tqY22nN43azoOxrvkl4u5yvPimQ==
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Sun, 05 Jul 2026 09:31:40 +0000
From: "yu kuai" <yukuai@fygo.io>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] md/raid1: protect sequential read hints for read balance
Date: Sun, 5 Jul 2026 17:31:36 +0800
Message-Id: <b19a7c32-43b4-4ce3-8471-f4318c129423@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a4a247c+186f02+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
In-Reply-To: <20260623075940.2476255-1-chencheng@fnnas.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
References: <20260623075940.2476255-1-chencheng@fnnas.com>
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>

=E5=9C=A8 2026/6/23 15:59, Chen Cheng =E5=86=99=E9=81=93:

> The patch just suppress KCSAN noise. No functional change.
>
> KCSAN reports a race, point to update_read_sectors() update next_seq_sect=
 vs.
> read next_seq_sect.
>
> Protect next_seq_sect and seq_start with READ_ONCE/WRITE_ONCE, otherwise,
> read balance see stale sequential-read hints.
>
> KCSAN report:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   BUG: KCSAN: data-race in raid1_read_request / raid1_read_request
>
>   write to 0xffff8e3a2d6736d0 of 8 bytes by task 593784 on cpu 10:
>    raid1_read_request+0xe5a/0x19f0
>    raid1_make_request+0xdf/0x1990
>    md_handle_request+0x4a2/0xa40
>    [...]
>
>   read to 0xffff8e3a2d6736d0 of 8 bytes by task 593776 on cpu 11:
>    raid1_read_request+0xe3f/0x19f0
>    raid1_make_request+0xdf/0x1990
>    md_handle_request+0x4a2/0xa40
>    [...]
>
>   value changed: 0x0000000000356368 -> 0x0000000000356370
>
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
>   drivers/md/raid1.c | 18 ++++++++++--------
>   1 file changed, 10 insertions(+), 8 deletions(-)
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
