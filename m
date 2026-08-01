Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5566B23392C
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 18:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785608937; cv=none; b=Ms0sznbOHYPZ5afyMdwECMXDL8S1Hy98W8I7WB4340JCQk5umeAGnUFSBls2yE7kp6xvauVER0jUHOE41FE7btPmhEWcjjCNp3eBoL0A4a1Gq6v1ijBn0m8gXGUJYc8WdXgSXtGRVAHN5a6CVrI9BIhE+9/UXOWS9QTiQLdEY94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785608937; c=relaxed/simple;
	bh=oEQyMPkHvOOLJCIPFmsT3fCgvFAFy9WKH0RivUKRs44=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=snRzUOmlXXDiEyCKpg7aMEdbxo8CV4Tgh1ibdPRPPSbYp1wYpqy8xtarwNFxDntn/APFK9A9EgUWf92wclp1WnILGl4tb7v3DPzu86gug97t5NXJP6S3pY7SfJm/PyrBTI1q+MifRQyNQvEPQ7aSwEEekjimDr7q6YbL257Wf5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ep1TR6UJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ep1TR6UJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68861F00AC4;
	Sat,  1 Aug 2026 18:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785608935;
	bh=ZYI3f8urkC7GRbjuJFopNGIRkYdlRGcsROB5WCPT/PQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ep1TR6UJ+gvWsjcFVgTCwVJg73oTztHybaqHDfIbCchmt3D/LjfgnWczij+aarBn8
	 SydjE8LOqBeqfGtETjrIvuV6t6/AUoWAqWGECqo9chZxo3uIfzqbtOsLIeJnUiesW6
	 SS9hVU6tg2px4mH3DIxhSHPg4GC8t6WIy0w+QQ0fk6CfL/vHqsGcthOl7C6cbnkVxs
	 2pCDhhhPutWR11P8ocUS9Q8w5wIsg3vYb5psifmt/f1kaDVKCOyc6lkjPsFJ3OVh3w
	 Gw37tgkAzPMIK9A9SHKRRvGZrIfFPHgLch872WsACeZlk5762lqB4e1lXF7UzaVf3u
	 46BjhhETEmsqw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 20/25] md/raid10: wire llbitmap reshape lifecycle
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260801172519.2982121-21-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-21-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 18:28:55 +0000
Message-Id: <20260801182855.B68861F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Inconsistent abstraction usage in bitmap reshape lifecycle hooks, c=
hecking specific bitmap ID only in finish phase.
--

--- Patch [20]: [PATCH v4 20/25] md/raid10: wire llbitmap reshape lifecycle=
 ---
commit 2fc96f9ae1ba07f2366bbf0c6db64db484bf74ad
Author: Yu Kuai <yukuai@fygo.io>

md/raid10: wire llbitmap reshape lifecycle

This commit prepares the llbitmap before RAID10 starts growing and finishes
the geometry update when reshape completes. It also exports the old and new
tracked sizes.

> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4394,6 +4394,12 @@ static int raid10_start_reshape(struct mddev *mdde=
v)
> =20
>  	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>  		return -EBUSY;
> +	if (md_bitmap_enabled(mddev, false) &&
> +	    mddev->bitmap_ops->reshape_can_start) {
> +		ret =3D mddev->bitmap_ops->reshape_can_start(mddev);
> +		if (ret)
> +			return ret;
> +	}

[ ... ]

> @@ -5039,10 +5062,15 @@ static void end_reshape_request(struct r10bio *r1=
0_bio)
>  static void raid10_finish_reshape(struct mddev *mddev)
>  {
>  	struct r10conf *conf =3D mddev->private;
> +	bool llbitmap =3D mddev->bitmap_id =3D=3D ID_LLBITMAP &&
> +		md_bitmap_enabled(mddev, false);
> =20
>  	if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>  		return;
> =20
> +	if (llbitmap && mddev->bitmap_ops->reshape_finish)
> +		mddev->bitmap_ops->reshape_finish(mddev);

[Severity: Low]
This isn't a bug, but is it intentional to explicitly check for ID_LLBITMAP
here in raid10_finish_reshape()?

In earlier hooks like raid10_start_reshape() shown above, the code relies
entirely on the presence of the function pointer:

    if (md_bitmap_enabled(mddev, false) &&
        mddev->bitmap_ops->reshape_can_start)

If another bitmap provider implements reshape_finish() in the future,
would this hardcoded ID check silently prevent its hook from running?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D20
