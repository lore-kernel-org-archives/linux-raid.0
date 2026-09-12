Received: from va-2-46.ptr.blmpb.com (va-2-46.ptr.blmpb.com [209.127.231.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4372B2DBF75
	for <linux-raid@vger.kernel.org>; Sat, 12 Sep 2026 11:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213572; cv=none; b=lmtJkypSgq+rcvJGFKJy02pifXbygdZp6QOg1+byCLLndV3HH0U1I6oacb42NkPWjavuYOn2y4JQqQm3UwppOM2/+oE+WQVwhiOyxiYXC/b/6OLgTDjCtfNuMfYChTOULuvdxSaek7u8RW1CqXwRV2m1z+GHr2NTwDOoubND4fU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213572; c=relaxed/simple;
	bh=94Dh4wjJiDzYq9nLm7SkdwC7F2EB7AKroBL/Vc1NmrY=;
	h=Date:In-Reply-To:Cc:References:From:Subject:Mime-Version:To:
	 Message-Id:Content-Type; b=pbOEQpRky1cB3p3E3bYCFdJWiHzgkLSIHPREqJAInAo30XS8Li5l/oSQYW/8rUbfx0UPKx1jbVcKIITpsny4yGdbuyP3T2K3nFBJE0Yy9kh8D/Pz3Dols1EzF/17gKyx3D2PVuwxB4jT0y5qhWQt2GcfT6ECaoIyJypAPQy+XvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=ohk3ublM; arc=none smtp.client-ip=209.127.231.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="ohk3ublM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789213565;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=SfkG0fK0DCEjTz8EVMB11wgW09JzxNYFlJQtHSzA/ZQ=;
 b=ohk3ublMMkbUb+y8mPAZA2/NN68KhueAhN6cGALXutCKSyyoMGyGfwjzcWD84CDlu7pSEx
 unVUYVymGC6gEOZ4YnHX8aRbeLysdfWHOw14VxV5ZYGK9AsdMa1u6XzFcLp4HtsTgMaFXR
 uZ5peoFleA6MeLw1/Ejmf6+75e2TyUjw/kS8U7Sg5acOUWfG3DcH9yaCb3QimLpuMXljdW
 CQdWTNSds49WqlLxfzDiePy8jP3U2Qzl3qzMDHC4X/2+ZPukpIf4Gr2nEtvMAZrtEZryC9
 Jcw1FD7+XfhyXHCAipXfos7k0/4orAlh3BLHJcPwrfuVzyU0ANWoA5ye2WW4lA==
Date: Sat, 12 Sep 2026 19:46:00 +0800
In-Reply-To: <20260911041521.2433222-1-chencheng@fnnas.com>
Cc: <linux-kernel@vger.kernel.org>, 
	<syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com>
User-Agent: Mozilla Thunderbird
References: <20260911041521.2433222-1-chencheng@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.161]) by smtp.larksuite.com with ESMTPS; Sat, 12 Sep 2026 11:46:04 +0000
X-Original-From: yu kuai <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v3] md/raid5: reject raid4/5 arrays with too few disks
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
To: "Chen Cheng" <chencheng@fnnas.com>, <linux-raid@vger.kernel.org>, 
	<nixiao@fygo.io>, "yu kuai" <yukuai@fygo.io>
Message-Id: <6483cd2f-a181-4e09-b9ef-8dd1d5e1885c@fygo.io>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26aa53b7c+ee9b6d+vger.kernel.org+yukuai@fygo.io>

=E5=9C=A8 2026/9/11 12:15, Chen Cheng =E5=86=99=E9=81=93:

> From: Chen Cheng<chencheng@fnnas.com>
>
> raid4 and raid5 require at least two disks, while raid6 requires at least
> four disks. setup_conf() only rejects raid6 arrays with fewer than four
> disks. As a result, an invalid raid4 or raid5 array can be assembled with
> no data disks and later reach raid5_set_limits().
>
> Reject such arrays before the r5conf is created. This prevents the invali=
d
> geometry from reaching queue limit setup, where roundup_pow_of_two() can =
be
> called with a zero stripe size.
>
> Reported-by:syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com
> Closes:https://lore.kernel.org/r/6a778c82.01d0871a.3a0d52.006a.GAE@google=
.com/
> Fixes: f63f17350e53 ("md/raid5: use the atomic queue limit update APIs")
> Signed-off-by: Chen Cheng<chencheng@fnnas.com>
> ---
> v1->v2:
> - Fix wrong tags
> - Check raid-4 also
>
> v2->v3:
> - Keep two-disk raid5 arrays valid by rejecting raid4/5 only below two di=
sks
> ---
>   drivers/md/raid5.c | 8 +++++---
>   1 file changed, 5 insertions(+), 3 deletions(-)
Applied to md-7.3

--=20
Thanks,
Kuai
