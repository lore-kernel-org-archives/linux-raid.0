Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A6C4A3F38
	for <linux-raid@vger.kernel.org>; Thu,  1 Oct 2026 13:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860801; cv=none; b=uvPDgu3Qh/R3cqG5HfGlikkxFM/TkwWsaWdOOinxn+nnCvOYDr17zb3GmRJ8TOR+ZYcaHawWul2UC8DPSHiISNOzEZNeCYwJFDtucIyG+K5ffUy9pmmT571POmRSXBzKAk9EImhdTdKtna7vfnL4jcFBF5ipDRjmdCq5ifMLoiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860801; c=relaxed/simple;
	bh=NdX8ksbB9TJcYlpDqbWzYxjwb55pEa3xX5z8G6kZiQk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BboJiJWNTqVFERpvCel9MRZYR9vxbLUlmaWKnHekJ9lgPiQ3WViKYg/Fjprif556+CUDbT+K9yM/tpdMXWJsEcxSNzUwZck9+wYgbULVlFPCGRArZFHL/Khmqi0qrrWf+GfDLM1FG3kyDG1lzfUqCXUK65N7uIIY7pS2xznhnz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+R+35g4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+R+35g4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E6C1F000FF;
	Thu,  1 Oct 2026 13:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790860799;
	bh=njRfUaFFSirt5BKSkccOEU6FWQyP5hZtpyR80ifVTOE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Z+R+35g4OyB4KjOsbHM+OvHkO9WOzYN/U8eN2Pjradr9i72GsNaSbburgGxLPekRf
	 fYBQ6eOtPYXS4mettAucMTdwrWih27NWEyPFIklZx/cFuE7XelLPx6dyz2W9AoXdrx
	 VR8i6LmqxOfglUXUTTnDiCKvRW319c1DRa+2Bth/gm4z337uE7r+68pIxvl+WY9fq1
	 EWR9c5J71zcpH/jjkBip/iM8zaCaUkWLWrIVb/wsWLvBc3ZCE4Q1m2CmtOo3qHzPXm
	 Cg23RQN0Zgw9Iba0/7CU2x4fwXNVxvKV+VDE0gz+1F0KcmeS830OABsFNrOP5MFbeT
	 HrjSR5XX0zh6g==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 4/4] md: add a control device for array
 management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261001125611.943731-5-abd.masalkhi@gmail.com>
References: <20261001125611.943731-1-abd.masalkhi@gmail.com>
 <20261001125611.943731-5-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 13:19:58 +0000
Message-Id: <20261001131958.E1E6C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] md: MD_CLOSING flag is not cleared on error or RO transition
- [Medium] md: strict boundary check on UAPI name field rejects valid inputs
--

commit c2d6351bf75bbe25a5734b17638d14317134886c
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>

md: add a control device for array management

This commit introduces a new misc character device, /dev/md-control, to han=
dle
md management ioctls without requiring an open file descriptor to the md bl=
ock
device itself. This prevents races during array stop and reconfiguration wh=
en
multiple tasks share the same file descriptor table. The existing block dev=
ice
ioctls are preserved for compatibility but trigger a warning recommending an
upgrade to mdadm.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
[ ... ]
> @@ -8602,6 +8608,623 @@ static int md_compat_ioctl(struct block_device *b=
dev, blk_mode_t mode,
[ ... ]
> +static struct mddev *mdctl_get_mddev_name(const char *name)
> +{
> +	unsigned long minor;
> +	struct mddev *mddev, *ret =3D ERR_PTR(-EINVAL);
> +
> +	if (strncmp(name, "md", 2) || name[MD_NAME_LEN - 1])
> +		return ret;

[Severity: Medium]
Will this strict boundary check reject valid user input? If a userspace
program populates the name field with a short, properly null-terminated
string but leaves the trailing padding bytes uninitialized on the stack,
this check will fail because the absolute last byte isn't zero. Could
this be relaxed to ensure the string is null-terminated anywhere within
the buffer instead?

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
> +	mddev_put(mddev);
> +	return err;
> +}

[Severity: High]
Does this exit path need to clear the MD_CLOSING flag if it was set
earlier? When a privileged user calls MD_STOP_ARRAY and the array is
busy or transitions to read-only, MD_CLOSING is successfully set, but
the ioctl may later jump to out or return an error. Since the flag is
never cleared on these paths in mdctl_ioctl(), would this leave the
block device permanently locked out from future opens until reboot?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261001125611.9437=
31-1-abd.masalkhi@gmail.com?part=3D4
