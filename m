Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793989601;
	b=yIuWcuL1/VRdGy00U2BZuntTGUDiWj3HjCYlnyfqGultetGrB1s5tDGivZQsEZm/FmYm
	 tzif01IcPjHd7bh6pcUHtcxGRwUYKTveNuAfDDhpP7AxhyqjKNypk4u01E/Gn+QC4kO3o
	 aUMa1gpMWVuUr6Wnt1IkI+yYi/aCcrW9AsIak1nHGlkG3VN8l7Jmd9xW+F902Uf9F+vlZ
	 8o8sz1xlp0w+AaLGd1c+1i66B9kPEBh/XdshQvqUJtHJvNtNk5iRwYXxt0GSlHDPp9GTw
	 UykViFr2g0Rc4eZEaZwIqhZ0qEj4pihqtlQbPHHqFb0pGg9aFh2FYvs6AyEi7OOfrAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793989601;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=E0hhlSyWSz5uQkMY19SrpOGcgpyDAdGlK/TYDJD26QI=;
	b=nrd7U5vUi27+7i30FDiTGeYlrltY0UXLC8xMXS62COFJur6RnMg12qq9xqbtwHKaJnZp
	 soXYlMCIdQ2iGpgRYLc1Dq2HsBind+WHVVub52RJcgUCwfEt7nN+74AvYnipqmni95bnZ
	 ohT67WuyvyTcf8JweTuSkJfl44QzGZPoFdjSlSOn2LAkf0bPU/5Fgis2cNcL8d3yD44Sj
	 koUgQuZ+4NtA6sGH1JolDCRKj5dO1taJoX0uS4K6sClLdKVxb0C9FxeHDsZ6s67xJ/tGq
	 McwupVLjXGwOEyOZ74jksoXwUTMFQ6eajKWqOMeP1o0xyCgKpkkn1/urtarA5yGnHZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="eAWLg/ol";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2525F606A326
	for <linux-raid@vger.kernel.org>; Fri,  6 Nov 2026 18:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eAWLg/ol
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5E81F0089F;
	Fri,  6 Nov 2026 18:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793989600;
	bh=E0hhlSyWSz5uQkMY19SrpOGcgpyDAdGlK/TYDJD26QI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eAWLg/olIjyMymw75NnS5zrCzCZ7jielVjuEyt6N7R9jtaG7fv8EcsHwZt/R3CRQv
	 plY0IOSfNrVdv4SdCH61UOPnKXUZKzmdXbNwCOIkxRNfwDw4SFFsBaDOGTwRdIZY1J
	 27/VSK+m2G6f/nb6jbbSCgV8IFhns7Vl4vw812kaCG7VbYmN7CJ1I/BxZYvQIPuxkw
	 WBtrhHgUAZa6WXvxRBlwj7y89tEhHnQiMrZTdPQu+yHTGQ0riTq6+vU21SeL9OzdJt
	 64Jhsy5zZU2D3IUKcTNGy1+cZSk9nxwSQDRut7ljtvlHGf9yojw6pjP13eE+hlQHrU
	 sZpZAkTjzdLRQ==
Message-ID: <sashiko-outbox-202027@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: dont warn about sb update on auto read only arrays
Reply-To: sashiko-reviews@lists.linux.dev
To: incharilla <incharilla@incharilla.site>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261106-md-auto-read-only-sb-warn-v1-1-5bfde3559841@incharilla.site>
References: <20261106-md-auto-read-only-sb-warn-v1-1-5bfde3559841@incharilla.site>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 18:26:40 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] md: badblocks log overlap check fails in
  super_1_allow_new_offset() [1]
--

commit 86c28dfbafd4341535246399e368c7eda6a1eb2d
Author: incharilla <incharilla@incharilla.site>

md: dont warn about sb update on auto read only arrays

This commit suppresses the read-only superblock update error message in
md_update_sb() when the array is in MD_AUTO_READ state.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 03e35386a8028..a0fc602899053 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2819,7 +2819,8 @@ void md_update_sb(struct mddev *mddev, int force_ch=
ange)
>  	if (!md_is_rdwr(mddev)) {
>  		if (force_change)
>  			set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
> -		if (!mddev_is_dm(mddev))
> +		/* auto read only arrays write the sb once they become writable */
> +		if (!mddev_is_dm(mddev) && mddev->ro !=3D MD_AUTO_READ)
>  			pr_err_ratelimited("%s: can't update sb for read-only array %s\n",
>  					   __func__, mdname(mddev));
>  		return;

[Severity: Critical]
This problem wasn't introduced by this patch, but does clearing
rdev->badblocks.size in md_update_sb() [1] cause
super_1_allow_new_offset() to miss badblocks log overlaps during a
reshape?

drivers/md/md.c:md_update_sb() {
	...
			if (rdev->badblocks.size) {
				md_write_metadata(mddev, rdev,
						  rdev->badblocks.sector,
						  rdev->badblocks.size << 9,
						  rdev->bb_page, 0);
				rdev->badblocks.size =3D 0;
			}
	...
}

drivers/md/md.c:super_1_allow_new_offset() {
	...
	if (rdev->badblocks.sector + rdev->badblocks.size > new_offset)
		return 0;

	return 1;
}

super_1_sync() sets rdev->badblocks.size, and md_update_sb() zeroes it as
soon as the badblocks metadata is written.  When a later reshape checks a
new data offset via super_1_allow_new_offset(), rdev->badblocks.size is 0,
allowing new_offset to overlap the on-disk badblocks log and corrupt
metadata or user data.

[1] https://sashiko.dev/#/bug/linux-18a3f5e9-47e5-4da7-8d4b-120745e50fdb

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106-md-auto-re=
ad-only-sb-warn-v1-1-5bfde3559841@incharilla.site?part=3D1
