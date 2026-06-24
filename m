Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7763322B8C
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 16:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782317566; cv=none; b=HoO0VWZsje08B6Lnts8DwGqHo2+ZyqwGCAC500zAVTYxuYmpKG9RIBmJ2ze2qh5GCZXmXYwv4OHF2I9WuLg+0hWqHYkE1ICUqVy/oFmlVHc3Lg+p/wKscBmxXduIhIRhivKPo7nVza3TsellLQcBppeAT3W8bTSkc1w9Y6oeTg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782317566; c=relaxed/simple;
	bh=cViPEk60zKnYOAjtnSuqh2oU11gPWJwAigdYJzKZ09g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=H2/pvPEeySRVOPhBaH+TnA8XsQszWhfduLOooLU7R6ADWlkv3Q3HBTD0/sbyht5vDsZQZh8b14QoR09VBVUrUhP5NGHLX697I0T7Tz9ZCnTccoixGYlwQ0Y1OVDA0FjcPgQkLGD1JY7/KZxjJuc44lCYw89LeGLkWAYexcM0XoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UWOCF55k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UWOCF55k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 292821F000E9;
	Wed, 24 Jun 2026 16:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782317565;
	bh=O61ywiLgoXfd5x23ypgR4Tyag27laJpr/jtYx5uZ8Aw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=UWOCF55kOLhaz3rnmQdJ1SW3wuN/dofZHlvmkse7FF2q1R1P1tvRYi06Wiu3G9B7d
	 5z5NChzNGli/5jv2O45P7Ch9hBelNMqd+YhXUKwswYqlSGEr7Tsri9qupzqfXCTnIU
	 Lu22MsD0vMBN1p4VId2l+muQaG7+IdL1mH2Ma6aUvNQXPIg7tuPLx7RkHogmczboPY
	 8hb8Yi3ONvTMSha0svSoScXRY6yf2knBMQ8/II4nuO9rJSbUSoHgs/OSM15ny3/03o
	 XSR3YlHLAf2wNRzfvyXoASLydRgnQwlVk7qug4mblI/oCaUjUtBU+5HQQveMesBiAH
	 lbUVQC/5WFH/w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 8/8] md/raid5: reserve stripe cache for user I/O during
 rebuild
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hiroshi Nishida" <nishidafmly@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260624155452.211646-9-nishidafmly@gmail.com>
References: <20260624155452.211646-1-nishidafmly@gmail.com>
 <20260624155452.211646-9-nishidafmly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 16:12:44 +0000
Message-Id: <20260624161245.292821F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The patch fails to bound the rebuild's share of the stripe cache t=
o 50%. Breaking the read-ahead batch loop just causes the outer md_do_sync(=
) loop to allocate stripes one-by-one, relentlessly filling the cache to 10=
0% anyway.
--

commit 29ed9bbd7953c5d6ceeb0158cc53c81fd4d3aaf9
Author: Hiroshi Nishida <nishidafmly@gmail.com>

md/raid5: reserve stripe cache for user I/O during rebuild

This commit attempts to prevent rebuild operations from monopolizing the
stripe cache and starving concurrent user I/O. It adds yield points in the
resync read-ahead loop to stop submitting stripes if there are active
waiters or if the cache is more than half full.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -6656,6 +6656,27 @@ static inline sector_t raid5_sync_request(struct m=
ddev *mddev, sector_t sector_n
>  	     submitted < RAID5_SYNC_WINDOW && win_sector < max_sector &&
>  	     win_sector < mddev->resync_max;
>  	     submitted++, win_sector +=3D RAID5_STRIPE_SECTORS(conf)) {

[ ... ]

> +		/*
> +		 * Reserve cache for user I/O only when it is actually competing.
> +		 * preread_active_stripes counts stripes queued for write I/O
> +		 * (including the read phase of RMW); sync stripes never set
> +		 * STRIPE_PREREAD_ACTIVE, so during a pure rebuild it stays zero
> +		 * and the window fills freely.  Competing user reads do not bump
> +		 * the counter but are caught by the waitqueue_active() check
> +		 * above.
> +		 */
> +		if (atomic_read(&conf->preread_active_stripes) > 0 &&
> +		    atomic_read(&conf->active_stripes) >=3D
> +		    conf->max_nr_stripes / RAID5_SYNC_HWMARK)
> +			break;

[Severity: High]
Does breaking out of the read-ahead loop here actually limit the cache
usage to 50%?

When this breaks, raid5_sync_request() returns control to md_do_sync(),
which operates in a loop and will immediately call raid5_sync_request()=20
again for the next sector.

Because raid5_sync_request() unconditionally allocates its first stripe
earlier in the function before entering this batch loop, won't the outer
loop just continue allocating stripes one-by-one until the cache reaches
100% capacity and triggers the fallback blocking path anyway?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624155452.2116=
46-1-nishidafmly@gmail.com?part=3D8
