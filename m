Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 220C64825D7
	for <linux-raid@vger.kernel.org>; Wed,  7 Oct 2026 12:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791374992; cv=none; b=o70PdXZ2cq7bCMoPSGNCeLwmiKw/T+4Pazd5EtRmrJvTOp1J79j8bTAGRjauc2pOZblGCBpu+rlgilEsYCNluHd7CbFVVhrOBOqD72xzmM3Lq1Z3r6qTvYd70GF7+cxmZPcoWdpCu0cR7y3c6uoWcz+p8xHvDkeLPPiq8DqmW4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791374992; c=relaxed/simple;
	bh=mkB2EH1bAc5FvSABOlVwILjxZ+e/ThyAq889+vHMxRw=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=RnOB8t7DcUOrgo+ohFIquxL1ONT4TVeUvgM+RxcPxhCq2nqdxwnanWVXqqyTv6Y08OisySAbhp47TCgTjIRmmafVVcPOLjcvfZyBBk9a3HXSjyAHKJDWtZSo05NgFqCX2V62pBeItCEtHEcBRWPUIXgrPArPUuztj/jpaXraLKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ajFjenWt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajFjenWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827AC1F0089B;
	Wed,  7 Oct 2026 12:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791374981;
	bh=nDbcDn23kRsjmdNi501cu7OxiqZ60MBQJ2mdxI7mTjI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ajFjenWtkbwV5/Jw8egStZ+gdhD0mpgIwfOSrHsjCnWR2y3KeSRtymqIhweSRUm5G
	 Ow5lMdyQvJe0usOW7yoRS1wXwYTSIsozxLgkfCGs0PVOIIWb8hOL1b+ZzXDvea05dg
	 1OVyVKIfclHvMg8p2yh/pxfYEjhp6QnMPuy1SMW0B7IaAdhfJXh1WlD095uyzR16HR
	 /zdJcjYr9gwHVvXMTyPgNvRPLYdwnfXEgA5qC3kzeIO2OBVqAyYOaG1pwkPoDFQ7Il
	 pWQkp+YwIG0Pom64sd48saEnZbqKirtYLPR2jTbiufEAgiI4ywNN3A1o/a3yme1I6a
	 Fow7BTEEFD8Bw==
Message-ID: <sashiko-outbox-162977@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 4/4] md: add a control device for array
 management
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWFzYWxraGksIEFiZCBBbHJobWFu?= <abd.masalkhi@gatech.edu>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20261007115104.13884-5-abd.masalkhi@gatech.edu>
References: <20261007115104.13884-1-abd.masalkhi@gatech.edu>
 <20261007115104.13884-5-abd.masalkhi@gatech.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 12:09:41 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] md: MD_CLOSING mutual exclusion broken in mdctl_ioctl
--

commit fe7502eb38662870e8ecf28880f3055a33951d2a
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>

md: add a control device for array management

This commit adds a misc character device, /dev/md-control, to handle md
management ioctls without opening the md block device. This aims to resolve
an issue where STOP_ARRAY races with concurrent writes from tasks sharing
the same file descriptor table.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
[ ... ]
> +static long mdctl_ioctl(struct file *filp, uint cmd, ulong u)
> +{
[ ... ]
> +	if (cmd =3D=3D MD_STOP_ARRAY) {
> +		/* Need to flush page cache, and ensure no openers */
> +		err =3D mddev_set_closing_and_sync_blockdev(mddev, 0);
> +		if (err)
> +			goto out;
> +	}
[ ... ]
> +out:
> +	if (cmd =3D=3D MD_STOP_ARRAY)
> +		clear_bit(MD_CLOSING, &mddev->flags);
> +
> +	mddev_put(mddev);
> +	return err;
> +}

[Severity: High]
Does this unconditional clearance of MD_CLOSING destroy mutual exclusion for
concurrent stop attempts?

If two tasks call mdctl_ioctl() with MD_STOP_ARRAY concurrently:

Task A succeeds in mddev_set_closing_and_sync_blockdev(), which sets
MD_CLOSING.

Task B fails in mddev_set_closing_and_sync_blockdev() because MD_CLOSING is
already set, returning -EBUSY and jumping to out.

Task B then unconditionally clears MD_CLOSING at the out label.

This clears the flag while Task A is still relying on it to prevent
concurrent openers or operations, potentially circumventing the protections
this patch aims to provide. Should this bit only be cleared if the task
actually set it, or removed entirely if the old md_ioctl() didn't need to
clear it here?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007115104.1388=
4-1-abd.masalkhi@gatech.edu?part=3D4
