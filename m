Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794070396;
	b=EWupFBWE43Wje+Z/kfxrb5l1+a1/KYxkvN6nZN7NB/BlNh+XhQvu6DEVr9dTb3c6irNj
	 LyCFuC6qfTXCfSI25pA/iAfRPGyS99rbfXclxkT3nfpr6vtcZo13zBIrQuboUaoYh74TO
	 3QM2w1EDmP72J6QhK1C+AP5HNhPJjAxPwSCedyo3V3SATsNwpAY6QOfUzWu1rx0djYmEy
	 l87DTLIUsNNCe7M9dkd0v/nEukWBOS5tRe7KxUjivsBovFFTU3wlW8jlJo9lUBzxaLytF
	 CPP0xFptgS4MFH4lWKc60ZpHRMOM2O6Pq+2ss9Yvrr4mMVPVcngM1Lsm/uI0aFDrGNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794070396;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=0sLtQaOCZO/z9L8aTf4hGd3tFh2TVXZkWLbLYmFxXWU=;
	b=YKJ77tFLRius2CscehAHLFH+xasuOaAz7jEgmkjEMhkvQQlvR61lOXU2XDGX4GS/3kRd
	 +y5Vg0IL7mzwtyC68smg8q4C+DTYx/wLalihHaYTZy2Donb1GRCWrnAJwcfvS4bAhEXbs
	 HXXXlNGzTv0BZE7Wu0H+rdOAz+RTID90Rt7Kv8YZyWGYQiRXndS9zA318CI6Bv3Lrq5GW
	 jsaUOXOAdOqghPwejDW2FK+YWImuS8s28iM8HJBntX5sse2mAh/83Oqg+df/OoBQKMo48
	 If/xaDGFAC4jieDeR25lBzHowna6KjCHYD5d34lNvlWDChZvgvA6a7JlPs4WL6aT9dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SK6GABe0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BBA606A326
	for <linux-raid@vger.kernel.org>; Sat,  7 Nov 2026 16:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SK6GABe0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16BA1F0089F;
	Sat,  7 Nov 2026 16:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794070395;
	bh=0sLtQaOCZO/z9L8aTf4hGd3tFh2TVXZkWLbLYmFxXWU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SK6GABe0kI/Drjw6ySw6RNl7Bu784WshggKv6dvX+Dc03ugxeaE/IrWUhHwCxT/17
	 BHVLRQi0H2OtA2/fo2G/l5gVTzouTSJb4PQqqYgKuO/yIo1XccXk1RcbXlm3vpkzLO
	 YelLPYkZ6dLzc+i9pzzyltPY4rWNQ5GZzy5gWVubv2yKjWnD4cZasYb3cCpn67BTSO
	 az8C7aN0mwlHRWoVCwjbo2+aBymtHPhkM2xbgdbVpWzwzpWPJuJHaQQB4yrJDpzpoQ
	 MGfeMEE5AmElI8PH+b3RtuWTLoSBbCy9oNY7wnQvgJJQHi+9q9WUIEFGU9qmd2zrFC
	 lbSvAxxNIOAPA==
Message-ID: <sashiko-outbox-203076@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/bitmap: fix missing_pages restore in resize rollback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chengyu Liu" <lui2012qwq@gmail.com>, linux-raid@vger.kernel.org
Cc: yukuai@fygo.io
In-Reply-To: <20261107164305.11476-1-lui2012qwq@gmail.com>
References: <20261107164305.11476-1-lui2012qwq@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 16:53:15 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] md/bitmap: missing Fixes trailer for commit c9d650322829
--

commit 5db0c6c47a033569a681ebcef85c2c4ea4329e98
Author: Chengyu Liu <lui2012qwq@gmail.com>

> md/bitmap: fix missing_pages restore in resize rollback
>
> The rollback for a failed clustered-raid bitmap preallocation copies
> old_counts.pages into missing_pages instead of old_counts.missing_pages.
> The counter then reports every page as missing and can grow past the
> page count as pages are freed later, making the used_pages stat in
> /proc/mdstat wrap around.  Accounting only, no corruption.
>
> Signed-off-by: Chengyu Liu <lui2012qwq@gmail.com>

[Severity: Low]
Should this include a Fixes tag for the commit that introduced the
preallocation rollback in __bitmap_resize()?

  Fixes: c9d650322829 ("md-cluster: always setup in-memory bitmap")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107164305.1147=
6-1-lui2012qwq@gmail.com?part=3D1
