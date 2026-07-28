Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6953341C2F2
	for <linux-raid@vger.kernel.org>; Tue, 28 Jul 2026 09:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785230143; cv=none; b=FPOnVa9g63lhdzpVF7Q3htqdlF82PNoFu2UIyI2NBjNpgxAIttKFOuYTHfHtqarpQJSSHlHlGDSX3sTuEYaEtNZUBslK3n/rKeJRywDTLHDnKI/unNq1lrmcezEozPgchfg7BKuXaF8ZJaYrIqvnRk4l/yrYG74JmNFYX7aNasM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785230143; c=relaxed/simple;
	bh=QZd5inFWJZXapz24YygaHzkRU77+fzC7CCRFl/LxrmQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DX2OMGFJyP8vZiX4D0QwF0fcP7ih3qk1VNrtN/ectrSVMOG/sNppEhOpwBBNqByeee1BHXnwyBVYN/oV1H8CFKlKKt/eiIAOHoNhzgepUkjsgh9R6lvAeDpAyuc1uh6fZ2wUI1UJh4H0NN1lv7YQ0QQd1FsE6ws10Y6gFPzbtjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ddJLu8GB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ddJLu8GB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E7A1F000E9;
	Tue, 28 Jul 2026 09:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785230142;
	bh=Yxpa13UshfL9lmDC/m7YDJfN8iTcGIAQujPmk/Z9gkw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ddJLu8GBPoEWIglTQ6Ns7z3b0+bwqvQ730swRr3PC3qySkhYO5vF03MPx9Wp/8wf1
	 BaA53WuLDxXv6tjyscLVXAu2P5OWx8OP6nExrV//WsCB2qzRG4tMMACRwsccBOE7TE
	 Isgo9PFTS8CCSk0TOLSgVvsWUrX6o3orhihQCWtD5fxXzE+NFXWOe3rDCkFTbmu3kW
	 +OHKw1wMqtrETnd3+5ujh/3iwCxoMmMzoVHPtDNO9IK5cnO0ex+DkQ1r7GpYmhQRzR
	 t72nE6nQxuoh/2PIZ2iWH28hLRl71NxP5RCz8bH9hYuowA2tP9iN9GnxCgMjnKzNs/
	 22k4ygqyNUItw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 17/21] md/raid10: split reshape bios before bitmap
 accounting
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <8abef42ad491fe452b82d672c2fdeb6c64c20c91.1785206690.git.yukuai@fygo.io>
References: <cover.1785206690.git.yukuai@fygo.io>
 <8abef42ad491fe452b82d672c2fdeb6c64c20c91.1785206690.git.yukuai@fygo.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 28 Jul 2026 09:15:40 +0000
Message-Id: <20260728091541.83E7A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] Missing `md_write_end()` when `mddev_bio_split_at_reshape_offset()=
` fails on a write bio, leaking `mddev->writes_pending` reference count.
- [High] Mempool exhaustion deadlock due to double bio allocation from `con=
f->bio_split` without a rescuer thread.
--

--- Patch [17]: [PATCH v3 17/21] md/raid10: split reshape bios before bitma=
p accounting ---
commit f435d38ffb898e662e1e9b6225ad90d266d26363
Author: Yu Kuai <yukuai@fygo.io>

md/raid10: split reshape bios before bitmap accounting
   =20
This patch updates raid10 to use the shared mddev_bio_split_at_reshape_offs=
et()
helper. This ensures that RAID10 submits only one-side bios to llbitmap dur=
ing
reshape operations.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index e50e4adee389f..fd364a2e2fd98 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1911,6 +1911,12 @@ static bool raid10_make_request(struct mddev *mdde=
v, struct bio *bio)
>  		sectors =3D chunk_sects -
>  			(bio->bi_iter.bi_sector &
>  			 (chunk_sects - 1));
> +
> +	bio =3D mddev_bio_split_at_reshape_offset(mddev, bio, &sectors,
> +						&conf->bio_split);

[Severity: High]
Could this lead to a mempool exhaustion deadlock if bad blocks are present?

This splits the bio using conf->bio_split, and passes the split bio down
to __make_request(). If there are bad blocks that restrict the sector count
further, the lower level routines perform a second split using the exact
same bio_set:

drivers/md/raid10.c:raid10_write_request() {
    ...
    bio =3D bio_submit_split_bioset(bio, r10_bio->sectors,
                                  &conf->bio_split);
    ...
}

Since conf->bio_split lacks a rescuer thread, would two concurrent I/Os
that both cross a chunk boundary and hit a bad block exhaust the pool and
stall indefinitely?

> +	if (!bio)
> +		return true;

[Severity: High]
Does this early return leak the mddev->writes_pending reference?

Earlier in raid10_make_request(), we call md_write_start() which increments
the writes_pending count for write bios:

drivers/md/raid10.c:raid10_make_request() {
    ...
    md_write_start(mddev, bio);
    ...
}

If the bio is an atomic write that cannot be split,
mddev_bio_split_at_reshape_offset() returns NULL. When we return true here,
we bypass the md_write_end() cleanup at the end of the function, which
might hang the array when it is later suspended or stopped.

> +
>  	if (!__make_request(mddev, bio, sectors))
>  		md_write_end(mddev);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785206690.gi=
t.yukuai@fygo.io?part=3D17
