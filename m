Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794082751;
	b=syRsppg+xuruY4TS0IndsUPrgS3pbiniSh9AtYMrGuTEa6NzYsG2fzszXZDRpPeavlRy
	 JYU+Vu5dS11J7fyyZ5OTT6krjd10L5Jm6Kv7KvetMLiTVugskT3Bip2bayisETQ+8donC
	 RnMhVYRgN5QWg1A9vz9DO/XzdpOJRfWraaW53lKhoVVc7+2HdgKsNJFEAcwuTY2CQ/1pC
	 qSHc6G6ciFhk65D1LIA7XcDV+Q3gSeb9lLN1b/gHRrSsG1VhUX42zCPfQCNdO+a6p3crL
	 Efp7rN67JL3z3eq2fctA6amfORGIECNBDUwsp3Hbm8nZ6Zro8VQ6zI/qHa6tPUOwhxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794082751;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=6FhMKWdKOkguAKCaqB3I3/kd1XaywOiQ3PBgZVPlUiM=;
	b=Mlva3dW4Zi424cya884jCaGB/GOd2CIBEhQL26gDDD6t0TdbW811SfGvy4TtWVKhHmre
	 ScI5l+av3RhQCGHxVUrS4bYTa7quoD8pQao9KF8nOr+ck52ECf6JO0KsQ9BJfML+YV4Vh
	 ZLmbhM3tT8Sb9QtNWHeoqiHFqfl5k+j/39SLCqdltV1qGikQbR/4zsXy+uFPOMBWyZhAZ
	 340yYpVNR9dBXf3aksaqToG4zQ/odo64Ha8Txq8zGJtuNzRXUklr9ExWHFCDPEiaPzi2P
	 HQviQt4rH+gPc4dPg74y+K5x7fkM1lfd1Fhkvv6H6ASnySbDyz1yBwR5htJbDLbb24w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mSSTxyRM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F813606A32D
	for <linux-raid@vger.kernel.org>; Sat,  7 Nov 2026 20:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mSSTxyRM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666331F0089F;
	Sat,  7 Nov 2026 20:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794082750;
	bh=6FhMKWdKOkguAKCaqB3I3/kd1XaywOiQ3PBgZVPlUiM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mSSTxyRM3FE6xfwRORWJJNAh0dkW4J/fb87hnh/jUv5fgw980R1E+WhU/oQs/pTPJ
	 3DMIG4Mjm489V9pt/xeREGOxfq4ZL7FYwa9YJxYYLmZHsDsTlRS964WLHiwaJmCFTB
	 34RsfeTv8SCqANsWsIaa+GiYJk/oUs2wEGMpaz5+cTVOSjc1jkCpNQGpiMjxk0IUac
	 KUJAY+C1qi908DMQwcDqrPquK2gR6vE+IbIjNmTAMfl64+aosJZXRU5C+iw+DRS74H
	 GqMZoPpKOuWcie3dBW3bXLM67eRbT4Ft/lCzHA8xbwBNqo2qIIFn7ZQtWSJRw7F+/x
	 916EjKPGw2tGA==
Message-ID: <sashiko-outbox-203264@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.12] raid6: add missing vzeroupper to AVX-512 code
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261107200913.103158-1-ebiggers@kernel.org>
References: <20261107200913.103158-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 20:19:09 +0000
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
- [Low] raid6: missing Fixes trailer for AVX-512 xor_syndrome commit
  694dda62d286
--

commit 369a70502fe6ce19affa3189f8d493476e955e10
Author: Eric Biggers <ebiggers@kernel.org>

> raid6: add missing vzeroupper to AVX-512 code
>
> commit b82cf9e49c1be7cf1fd8e1bd806b0cdd25ab8127 upstream.
>
> Since the AVX-512 optimized RAID6 code uses ZMM registers, execute
> vzeroupper before returning from it.  This is needed to avoid degrading
> the performance of any later SSE code that may happen to be executed.
>
> Link: https://lore.kernel.org/20260831212316.213896-1-ebiggers@kernel.org
> Fixes: e0a491c12968 ("lib/raid6: Add AVX512 optimized gen_syndrome functi=
ons")
> Fixes: 13c520b2993c ("lib/raid6: Add AVX512 optimized recovery functions")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: <stable@vger.kernel.org>

[Severity: Low]
In addition to the gen_syndrome and recovery functions, this patch adds
vzeroupper to raid6_avx5121_xor_syndrome(), raid6_avx5122_xor_syndrome(),
and raid6_avx5124_xor_syndrome().  Should this also include:

  Fixes: 694dda62d286 ("lib/raid6: Add AVX512 optimized xor_syndrome functi=
ons")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261107200913.1031=
58-1-ebiggers@kernel.org?part=3D1
