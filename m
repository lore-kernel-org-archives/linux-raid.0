Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262593DB30A
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 15:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782316710; cv=none; b=dWWR9KH/ZQ5GJ1cz9Rb4YvWBHoSL1bPv2iTXs4DFqFQoDHun8HaDAkMO384Gd6AlnND2sXMg3+H/quoJQPD3M/K2by2u3ypLsQtPT4ujJZAtkze+Y1/RkjsTZmyNg5LRWuIVRQqPTHJ8n/k6S+kP64AxDhnQPKPm6JC8FFCGmLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782316710; c=relaxed/simple;
	bh=YxUU7iG++tqiD3Uge65gw4RBSIX109jBxuC0OKOQTrM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=f3KS5G5Xd/3BGefbyOqbNqF0eMSuIN53pZdVQIuqivnpM3nHUToGHwMY6xWVqfPzBK5+srLB4tgQQMIs3CE/hcakwnowMqjQXkIlSUl7iwX6URpQC2bsBWXzLOC/LCMoB3meriV6raa+1vwI4bygaB0dVvHKMymA7xWZQ5jGl2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CYdevoHy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CYdevoHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C6F91F000E9;
	Wed, 24 Jun 2026 15:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782316708;
	bh=3pdI7pt4w8nzNNsGCna84YxOBf4XFFGIfSPAnSic9KI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CYdevoHyCw/8vEYippgDEmFNTFCHsvyz5lEgddzI/eyyj/Z/i9j1cL2jI7lhC6Tvu
	 +9CSdJD0Q1fAwtnq6MOtCue3QSW5EK+0eAe7On7HnYhBg6FA3YO/rM9S/cjohLfIqD
	 CVGxV44tEct7GRIQaiRdx4sdBnk4jtFvk5q5r0N4G6YA8JW0hbGWdA9v7+StGc710J
	 eaCMsW/nEYldRt5AWy7pKuocOZ/+JHGTBw8KlJ6ztyi16EoIxH/bjqTQ2Zibp1fV2J
	 wdyXjEbv/0+lUT9ZqWeUmIWR4+5oDjlHqQHxQuJu239tFD4o/XcqsthmPGjX7iTBFN
	 j/nYw6s7oEwcA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 5/5] md: clarify the resync ETA comment in
 status_resync()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Hiroshi Nishida" <nishidafmly@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260624155421.211626-6-nishidafmly@gmail.com>
References: <20260624155421.211626-1-nishidafmly@gmail.com>
 <20260624155421.211626-6-nishidafmly@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 15:58:27 +0000
Message-Id: <20260624155828.3C6F91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] The newly added comment incorrectly states that the divisor `db` is=
 scaled up by 32, when the code actually scales it down.
--

commit 21672ecf7d2b823245c32b9d2699f7cf1a5c2e7c
Author: Hiroshi Nishida <nishidafmly@gmail.com>

md: clarify the resync ETA comment in status_resync()

This commit updates the block comment above the remaining-time computation
in status_resync() to clarify the calculation logic. It is a comment-only
change.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0cd85cc92ed31..a5c0da0d11334 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8916,17 +8916,11 @@ static int status_resync(struct seq_file *seq, st=
ruct mddev *mddev)
>  	 * db: blocks written from mark until now
>  	 * rt: remaining time
>  	 *
> -	 * rt is a sector_t, which is always 64bit now. We are keeping
> -	 * the original algorithm, but it is not really necessary.
> -	 *
> -	 * Original algorithm:
> -	 *   So we divide before multiply in case it is 32bit and close
> -	 *   to the limit.
> -	 *   We scale the divisor (db) by 32 to avoid losing precision
> -	 *   near the end of resync when the number of remaining sectors
> -	 *   is close to 'db'.
> -	 *   We then divide rt by 32 after multiplying by db to compensate.
> -	 *   The '+1' avoids division by zero if db is very small.
> +	 * rt is computed as (remaining sectors) * dt / db.  To keep precision
> +	 * near the end of resync, when the remaining count is close to db, the
> +	 * divisor db is scaled up by 32 before the divide and rt is scaled back

[Severity: Low]
Is this new comment accurate regarding the math applied to db?

The comment states that the divisor db is scaled up by 32, but looking at
the actual code:

    rt =3D max_sectors - resync;
    rt =3D div64_u64(rt, db/32+1);

This divides db by 32, effectively scaling it down rather than up (which in
turn scales the resulting quotient up). Does this comment need to be
adjusted to reflect the db/32 downscaling?

> +	 * down by 32 afterwards.  The '+1' avoids division by zero when db is
> +	 * very small.
>  	 */
>  	dt =3D ((jiffies - mddev->resync_mark) / HZ);
>  	if (!dt) dt++;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624155421.2116=
26-1-nishidafmly@gmail.com?part=3D5
