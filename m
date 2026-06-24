Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F4038A711
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 07:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782284809; cv=none; b=HF6HX6asXL843LDJnhRqfv2AhD3vyn+/dwh9bO/iTlurVYIGYKBUDcaUAlTs13G91/XiiVZVILe1J/vEW0S1bu4OZ0S1pTyUrGKeHxipfXkgt4LbPMfrLYPMDkty/FM/LWJIB1JyDRDWcARvGt89XRkqkWydjWEu9O7mF39fuH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782284809; c=relaxed/simple;
	bh=oKqYhMM8jZKf0ig38D3e4pEV+DXSB2FvT8kNkjoVhFo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MZG4CNjYm7MSwuCPYn1uA1iJvrqRF4r1LoeIdyQyAYZ8me/R3Rzyr0Qmz9cZjnQ/nzEGh0cpUVa3ZEQ06RZRPuKjGOSsmUg4dCeMjJgimLR2fGjAXC6w3vlhlnvASYeBQCFHkXVWMJXFmSnnx4BF4xlgunHzYFNmCZdXkCZplRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=APo9azhv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="APo9azhv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7301F00A3A;
	Wed, 24 Jun 2026 07:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782284808;
	bh=6AyEuzfxQD8cIUgFRnQ4aQbzprIDqHG+OYlDUzGErC0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=APo9azhvs5LAfveuwrtp4NTUO2+YvPOteJaakf6AFDaUv+CAa2bXJCkyGpBvyBi2L
	 ZULP2Paps/vVrHLVHvQhO/q4BnokdDdDrlMPwazQLS2VWKsPmYyvh0OcKS15IvDjBA
	 eYYsMjT6ADomLRm8SdttY5p4kC7So7ndzBMAYQzquRscKhkfOpQw5vb9Z2tqguXuv8
	 aUNmG5FQw//JbXhZqAHd7zEdwiywDi5MZTfAQquKE1v6ej4pteBBbjJYYS0xEFUlKd
	 KUT15lZMrmMjXcuyvEn51zix/D3GX5G4uBfxKAkclheT7g8KlcUeqqs/bDqmkHCJ5/
	 Sn+gh8/X5Q/OA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 13/20] md/md-llbitmap: clamp state-machine walks to
 tracked bits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <2f58279987b8b8b3f5b2ed8e563512524c530297.1782282042.git.yukuai@kernel.org>
References: <20260605091527.2463539-1-yukuai@kernel.org>
 <cover.1782282042.git.yukuai@kernel.org>
 <2f58279987b8b8b3f5b2ed8e563512524c530297.1782282042.git.yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 07:06:47 +0000
Message-Id: <20260624070648.2D7301F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] llbitmap_cond_end_sync prematurely marks partially synced chun=
ks as completed, risking data corruption and skipped resyncs.
--

commit e55ca490604a05215923d84a1b1272a73343ea48
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: clamp state-machine walks to tracked bits

This commit adds bounds checking to llbitmap_state_machine() to prevent
walking past the tracked bitmap chunks. It ensures the state machine range
is clamped when the requested end bit exceeds the tracked boundary.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 00b77ecd600be..581ee9e4a3467 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -983,7 +983,10 @@ static enum llbitmap_state llbitmap_state_machine(st=
ruct llbitmap *llbitmap,
>  		llbitmap_init_state(llbitmap);
>  		return BitNone;
>  	}
> -
> +	if (start >=3D llbitmap->chunks)
> +		return BitNone;
> +	if (end >=3D llbitmap->chunks)
> +		end =3D llbitmap->chunks - 1;
>  	while (start <=3D end) {

[Severity: Critical]
This is a pre-existing issue, but does the inclusive bound here cause
prematurely completed resyncs?

Looking at llbitmap_cond_end_sync(), it passes the current sector's chunk
index as the end bit:

drivers/md/md-llbitmap.c:llbitmap_cond_end_sync() {
    ...
    llbitmap_state_machine(llbitmap, 0, sector >> llbitmap->chunkshift,
                           BitmapActionEndsync);
    ...
}

Because the while loop condition is start <=3D end, the chunk currently
undergoing resync will be included in BitmapActionEndsync and transition to
BitDirty prematurely.

If start_sync() is subsequently called for the remainder of this chunk,
won't it see BitDirty and return false? This would cause the resync loop
to interpret it as no resync needed, skipping the rest of the chunk's
sectors and leaving them out of sync.

Should the end parameter be treated as exclusive instead, or does
llbitmap_cond_end_sync() need to subtract one from the end chunk when
sector is not aligned to the chunk size?

>  		enum llbitmap_state c =3D llbitmap_read(llbitmap, start);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1782282042.gi=
t.yukuai@kernel.org?part=3D13
