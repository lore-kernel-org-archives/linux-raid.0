Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88EB337DE8A
	for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 14:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784815517; cv=none; b=CQkb1VIce2SHmteOUfu+8L4cJEhYm0vtYCvq1gIG6ca2ymcgv13ZVcwzeH+OFOJQ12YZnZc8+ypNbZVi/nb9Cx35N/TyKKHaGD1n4d5fGgBiY0jkpWqU/mqwmevZ/UJm/V4jMuys7R5b1E1tFDtTqeOk0KMqPmvsGH1GqXh6H38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784815517; c=relaxed/simple;
	bh=DbAAk4/HrqtR2M5X3UEJFWCITjqrWNdUAlNF6nQEIt0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uqjmvBLXS6XeNdgCAofaaz1odTGNmZK1ckAaqrs3vJ7BpZmVgupOhPcXXOtq3girR5GDbHPUBP6dvzQ4W8UDPZBzbOn+/iZ1S6jGWC4hpSNt3mUi+M0qwULxnuibKc1nAjvcYd+gnBPlbpE7aEeml87NqhT033GqrU/1ptNS9EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JNY9EpRJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JNY9EpRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33C21F000E9;
	Thu, 23 Jul 2026 14:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784815515;
	bh=fiywcVjVyJUjxImP1GawUtUu4u7sPJ0Bu8TIdL2J/0o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JNY9EpRJK/xLvUoZj6HhHfh7FfOGKkWhBtHj9R57/R+FlAJN0Q41ldUVnN/cWs45E
	 S9/MjOUGX/k+BB3ZqLNMdZHfhcYEN5S7rtSwRLRl5vRdWn+hj4g6KNbGFhQpMLmMtB
	 vdpB5VhWfurSLClkrbjydLdRGbA1SjFJSZzBu3Q0iVrK8f3gSYWKmWwHRyb9rEoj5V
	 YK58ZJd0AwhERAR/ToZ1+F4Pj75R2M0h7DAaY18eDijzyI8p61pUAq2EjdOmupFEpo
	 lJ+8TA/nhhbO92MWqJP91GinxW6ymoSLy+4bSrJa6l/A62zaeJxXbIi0gAugafYnVz
	 6KwQ9XxkCNZJQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/3] md: add cond_resched() to md_do_sync()'s skip
 path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yunye Zhao" <yunye.zhao@linux.alibaba.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260723135535.101995-3-yunye.zhao@linux.alibaba.com>
References: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com>
 <20260723135535.101995-1-yunye.zhao@linux.alibaba.com>
 <20260723135535.101995-3-yunye.zhao@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 14:05:13 +0000
Message-Id: <20260723140514.F33C21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unbounded waitqueue spam from md_new_event() during sync skip loop=
s.
--

--- Patch [2]: [PATCH v2 2/3] md: add cond_resched() to md_do_sync()'s skip=
 path ---
commit 6f3b7b59be28b3b7daedbe090461ee12870bd481
Author: Yunye Zhao <yunye.zhao@linux.alibaba.com>

md: add cond_resched() to md_do_sync()'s skip path

This patch adds a cond_resched() to the skip loop in md_do_sync(). It
addresses a soft lockup watchdog trigger during raid10 recovery on large,
mostly clean arrays by yielding the CPU when regions are skipped.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d1465bcd86c81..c2e8b203c4db2 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9881,8 +9881,10 @@ void md_do_sync(struct md_thread *thread)
>  			 */
>  			md_new_event();
> =20
> -		if (last_check + window > io_sectors || j =3D=3D max_sectors)
> +		if (last_check + window > io_sectors || j =3D=3D max_sectors) {
> +			cond_resched();
>  			continue;
> +		}

[Severity: High]
This isn't a bug introduced by this patch, but does this code cause unbound=
ed
waitqueue spam from md_new_event() during sync skip loops?

When last_check starts at 0 and the personality skips regions, io_sectors
does not increment. Because last_check remains 0, the block just above this
diff checks:

		if (last_check =3D=3D 0)
			/* this is the earliest that rebuild will be
			 * visible in /proc/mdstat
			 */
			md_new_event();

Since last_check =3D=3D 0 evaluates to true on every iteration of the skip =
loop,
md_new_event() is called continuously.

For a large clean array with small skip chunks (like 128 sectors), this cou=
ld
execute millions of times.

Could this lead to severe waitqueue spam and lock contention on
md_event_waiters, resulting in spurious wakeups for userspace processes
monitoring mdstat?

> =20
>  		last_check =3D io_sectors;
>  	repeat:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723135535.1019=
95-1-yunye.zhao@linux.alibaba.com?part=3D2
