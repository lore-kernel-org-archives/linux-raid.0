Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11226231829
	for <linux-raid@vger.kernel.org>; Wed,  7 Oct 2026 12:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791374921; cv=none; b=meAh2Z7MjbPyYSn7pfT1Lfs47sedlq+87196KEsZQluuQ5dtGIPdsJU/3ZrE8YSLVxa4vGViAdfIsVPm+ixsBQKZxevmi2q8fNcq1zUqRjPVl+0yfqTUB9xvODdk8AcZyP8q9YOHRravLehOJn+YrGpniG0dbzXPX1O8ZiFl680=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791374921; c=relaxed/simple;
	bh=DFVP56J+DOknrwfQLMn4qW04kmPqx5zwLlTRlPGcoL8=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=iXOkuaaJ1XgX1XZnEw56xeCXE3R0B73JLUa5yfcur3uzvB1xlOzgxyFnqcAP0TWyuXNDKki3lMgUdmRSt0UQ+FsajtGliot12nww16PTt33ba0cc8fxU99t5oFp3HjmGDla1kdEVjDTxDTSo29XrJ2R55IvS0ZBF9akTiE08nRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g9x65bZq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g9x65bZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD211F0089B;
	Wed,  7 Oct 2026 12:08:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791374910;
	bh=wgRVjb+At6q7uN7Ioeo19K0UvWpz93u2oILSoZqjVYE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g9x65bZqhon35/KGTX8G6ZG6EvHhvEZR5w4M3J8TtY9SN7lZ9xwHU9t+pSXyVQElj
	 8QH7clnIhhWdnhnAbY9EBv/3CJv/Dn9lWgwA0rlHdMqmUS8Q89hZ6suTRNMfSQoJso
	 o1nmS/t9r4u2v+/0hmp1tK9m1q6AtduthMsnGGTeT0lDDJ7/UzGuYV31DAyn1Bd0QT
	 jRfRWgSMoOBeCXpFk8rE5x6bmP+gSsrrdF2H3R1apzOKOY8OAsSO5O3euh3VNycRlG
	 YrLb7a5c1Nd8YDZVPovWg4xcoWHdWhaC0TTswp6VAEXRW4m7kZO5LJgDEQoHfjokVT
	 5Wh70dbaNeeKg==
Message-ID: <sashiko-outbox-162974@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 2/4] md: pass struct mdu_disk_info64 to
 md_add_new_disk()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWFzYWxraGksIEFiZCBBbHJobWFu?= <abd.masalkhi@gatech.edu>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20261007115104.13884-3-abd.masalkhi@gatech.edu>
References: <20261007115104.13884-1-abd.masalkhi@gatech.edu>
 <20261007115104.13884-3-abd.masalkhi@gatech.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 12:08:29 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] md: uninitialized info->raid_disk evaluation outside MD_DISK_SYN=
C flag gate
--

commit 2e047f45700e04ece53e9f9cfd19bd6bb0bd587c
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>

md: pass struct mdu_disk_info64 to md_add_new_disk()

The md control device passes disk information as struct mdu_disk_info64.
Make md_add_new_disk() take this structure, so that the control device
and the old ADD_NEW_DISK ioctl can share it.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 154ee5a65cb79..be1634ae1d09c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8305,6 +8305,16 @@ static bool md_ioctl_need_suspend(unsigned int cmd)
>  	}
>  }
> =20
> +static void convert_to_disk_info64(struct mdu_disk_info64 *info64,
> +				   mdu_disk_info_t *info)
> +{
> +	info64->number =3D info->number;
> +	info64->major =3D info->major;
> +	info64->minor =3D info->minor;
> +	info64->raid_disk =3D info->raid_disk;

[Severity: Medium]
If the ADD_NEW_DISK ioctl is called to add a hot spare without the
MD_DISK_SYNC flag set, is it guaranteed that userspace has initialized
info->raid_disk?

Userspace is not required to initialize the raid_disk field if the
MD_DISK_SYNC flag is absent, meaning it may contain arbitrary garbage.
The convert_to_disk_info64() helper copies this unconditionally.

When md_add_new_disk() proceeds to evaluate it:

	if (info->raid_disk < mddev->raid_disks)
		rdev->raid_disk =3D info->raid_disk;
	else
		rdev->raid_disk =3D -1;

could this evaluation outside of the MD_DISK_SYNC flag gate cause array
role corruption?

If the uninitialized garbage happens to be a positive integer less than
mddev->raid_disks, rdev->raid_disk might be mistakenly assigned this
garbage value instead of the expected -1 for a spare, potentially
breaking rebuilding logic.

> +	info64->state =3D info->state;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007115104.1388=
4-1-abd.masalkhi@gatech.edu?part=3D2
