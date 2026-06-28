Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463EA3AC0C2
	for <linux-raid@vger.kernel.org>; Sun, 28 Jun 2026 14:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782657383; cv=none; b=XyChbRvSVJofdyzEraxhHqjjvVYJHkKdB3SlbPTCf2kW0vDCP3u1yaDUsQZdv4ohDpEx6cH7++uTsYJQSGS8CySKesSH3+tWt5aPvvJOhAUWg+QMGlgDhVfe1WkLbhNFaz8+4cnXIbB5l4+KjNgltCKqoCIE/gzoL0hLv4iFoEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782657383; c=relaxed/simple;
	bh=wYkuZYf9XFKY7oyR8K9tJZoWW3mDqVdNxM4z5zWlMHk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fokjJKLzHNjrY5M9SYwvv6dj11hpYtqE4+4ZypsNiEVhK4H+wf0IpQmUxMlAYGWduX+rhHat/WqxLEvxRVYyQDB/997bRnLctdUc+5DKTKxbAH++vSRedBy47zk25Sh5byQa6zbpNRG+ksjqEkkcM7YmCuJjp7NlH1HwK5Rxwog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ErAswZJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ErAswZJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A6C1F000E9;
	Sun, 28 Jun 2026 14:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782657380;
	bh=9YuMh3Q7IjGFeNOKihOZ9PtidEs3HDqgAgUIqBaWLeA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ErAswZJJs81ehaaID4vr73ewzYLMDkruXzpZ2kH6PjQsQ2yZ24QEofcvRQKrKPw4j
	 pw3a9KLwcNU7ongA7gCdEyLZle0atM6p2u25WHb/ySsg8f7nGOjcNMyIKx/tWCc2Pc
	 NRAe5V9qnGvTfi3oQm4TcR5dMY1jCaOh1K5OPVlvCg/B8aRanzo4NCyLPnEWhQSRja
	 ZAY7+1didFvQ+1tTCub0SCy9nKVvPKmSTDFikIqJmJUtpZwLNIe2EALJVGMxpQCY2O
	 clI7q/WGnCaRlXe86zzvZA4A7dae1dmHjzHqTBIWVnvQcSecwKOuWGvmoT6Z5qsvjr
	 XlLanzB3y0QkQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/7] md/raid10: consistently fail atomic writes that
 require splitting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260628142420.1051027-4-abd.masalkhi@gmail.com>
References: <20260628142420.1051027-1-abd.masalkhi@gmail.com>
 <20260628142420.1051027-4-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 28 Jun 2026 14:36:19 +0000
Message-Id: <20260628143620.64A6C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The `err_dec_pending` (formerly `err_handle`) cleanup path in `rai=
d10_write_request` can trigger a NULL pointer dereference when a replacemen=
t device is promoted concurrently.
--

commit bc9d81fdb2c33f8c55baad27ab1eedf427ae25ed
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

md/raid10: consistently fail atomic writes that require splitting

RAID10 handles one badblock path explicitly by failing atomic writes with
EIO, but another path can also reduce the writable range and force the bio
through bio_submit_split_bioset(), completing it with EINVAL. This commit
centralizes the check to fail all atomic writes requiring splitting with
EIO.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index bd322eccdc3ff..3480fc7907f01 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
[ ... ]
> @@ -1493,6 +1484,9 @@ static bool raid10_write_request(struct mddev *mdde=
v, struct bio *bio,
>  		r10_bio->sectors =3D max_sectors;
> =20
>  	if (r10_bio->sectors < bio_sectors(bio)) {
> +		if (atomic)
> +			goto err_handle;
> +

[Severity: High]
This is a pre-existing issue, but can this jump to the error handler cause a
null pointer dereference if a replacement device is concurrently promoted?

In the error handler path, the code fetches the replacement device without
checking for null or falling back to the primary slot:

err_handle:
	for (k =3D 0;  k < i; k++) {
		int d =3D r10_bio->devs[k].devnum;
		struct md_rdev *rrdev =3D conf->mirrors[d].replacement;
		...
		if (r10_bio->devs[k].repl_bio) {
			rdev_dec_pending(rrdev, mddev);
			r10_bio->devs[k].repl_bio =3D NULL;
		}
	}

If raid10_remove_disk() runs concurrently, it can promote the replacement to
the primary slot and clear conf->mirrors[d].replacement:

raid10_remove_disk() {
	...
	WRITE_ONCE(*rdevp, NULL);
	if (p->replacement) {
		WRITE_ONCE(p->rdev, p->replacement);
		clear_bit(Replacement, &p->replacement->flags);
		WRITE_ONCE(p->replacement, NULL);
	}
	...
}

If this concurrent promotion happens, will rrdev be null here? It looks like
other paths such as raid10_end_write_request() safely handle this exact
race by falling back to rdev when replacement is null, but this cleanup
path does not.

>  		allow_barrier(conf);
>  		bio =3D bio_submit_split_bioset(bio, r10_bio->sectors,
>  					      &conf->bio_split);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260628142420.1051=
027-1-abd.masalkhi@gmail.com?part=3D3
