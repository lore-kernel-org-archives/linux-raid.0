Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92CF41D4EF
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785229995; cv=none; b=trTlgOHNoGvaMymlH2M+2qAr0DM+DeGCT4Nf6pz3GGRtI/+47VdFRyakQVDgB2N+HaDrb2ZdvNtH76gQwvnYi9fRzOgEoQalt2Nmi3TOgQ+ngZAuKuxGqIusYKqX3DdV3A2BQ96tc5+EW/1PashqxRaI3J+WMd+7O88Q8X4KrPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785229995; c=relaxed/simple;
	bh=Umc8pHSlG+dzOf2mIUnjCYZMi+PVWJuTaH62okDrftc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Dk3a3pSY5aPu9zXSGZqd/BXRzzk65ih1JmeiLlVw42lzecTO7yBjv0QxEY0b8ZV59Pzg0hY19RTLe8u0jLCEfsf84afSSifcYJ6ZtphT85OYaST3HTQSbeO65NQgl/vZ9BwZGw3jaNl6Q3J8McyaOCxQq9kvYw876V/qySotLAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ei7SKIwj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ei7SKIwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162021F000E9;
	Tue, 28 Jul 2026 09:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785229994;
	bh=b7z1ZNnyOQjzqCo0r71GArAYy02WEzF0S5y+4qc5wk8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ei7SKIwjfFqs48gpfs4VtyMVT9bpJBDqiYyO+a+yyQF4nSs11+23DhTy4kKo3AF/T
	 mjafnrMr2wlRayu4UVzjO7QQrsVnvsQrV68OoFVjkh27VlNvWncl0zEkdPk0gxNqMB
	 CHt2pbCYYsnSzZ+YraROsfveWXEdALJ7CSoY479V9pphGvejdAIwNfCHPQW2N+jW10
	 2b1fopq3VMaQNJl8gH0+5o+6cNZa5+i+92s7Se1lAC59K83JyMPzMGBAl9HmK/Ykyp
	 sNgmQEwDioux1y/WoSCMwg9sRGopj1riLgnZCWeUOPUOzI1+tr8UtEHsvVowLVdh3P
	 kuD/5V3UmVdnA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 14/21] md/md-llbitmap: clamp state-machine walks to
 tracked bits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <0510090c2be122814404150096768b180d0301e9.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <0510090c2be122814404150096768b180d0301e9.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:13:13 +0000
Message-Id: <20260728091314.162021F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] `llbitmap_cond_end_sync` prematurely clears the sync state for=
 partially synced chunks, leading to skipped sectors and data corruption.
--

--- Patch [14]: [PATCH v3 14/21] md/md-llbitmap: clamp state-machine walks =
to tracked bits ---
commit d30fecfeaabb2957753288e01ac48b29a04d716a
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: clamp state-machine walks to tracked bits

This commit clamps the state-machine range to llbitmap->chunks to
prevent it from walking past the tracked bitmap when handling boundary
conditions.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> index 794ac0eaf4379..bb83d15247d23 100644
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -1011,7 +1011,10 @@ static enum llbitmap_state llbitmap_state_machine(=
struct llbitmap *llbitmap,
>  		llbitmap_init_state(llbitmap);
>  		return BitNone;
>  	}
> -
> +	if (start >=3D llbitmap->chunks)
> +		return BitNone;
> +	if (end >=3D llbitmap->chunks)
> +		end =3D llbitmap->chunks - 1;

[Severity: Critical]
This is a pre-existing issue, but does llbitmap_cond_end_sync() prematurely
clear the sync state for partially synced chunks?

During array resync or initial build, the current resync position (sector)
typically advances by stripe size or resync sectors, which is smaller than
the bitmap chunk size. This means sector almost always falls in the middle =
of
a chunk.

When llbitmap_cond_end_sync() calls:

drivers/md/md-llbitmap.c:llbitmap_cond_end_sync() {
    ...
	llbitmap_state_machine(llbitmap, 0, sector >> llbitmap->chunkshift,
			       BitmapActionEndsync);
    ...
}

it calculates the inclusive end bound for Endsync but fails to ensure only
fully completed chunks are processed, applying BitmapActionEndsync to the
partially completed chunk that sector resides in.

Because the state machine transitions partially-synced chunks to BitDirty or
BitCleanUnwritten, the next call to md_bitmap_start_sync() in the same chunk
will evaluate to BitNone and return false.

Will this cause the sync thread to skip the remaining sectors of that chunk
without resyncing them, leaving stale parity or unsynced mirrors on the dis=
k?

>  	while (start <=3D end) {
>  		enum llbitmap_state c =3D llbitmap_read(llbitmap, start);
>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D14
