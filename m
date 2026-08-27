Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01C93F7A8C
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 09:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787821507; cv=none; b=rC7bx7RDjb0w2x7DsoCmHDwx/FSH1QJMVkcMFiL5QazHL/GgEsng/Jag00JMlLRZcRsKkB0L7pDzm89owNyxwlzzC244hMrsjuEpH+Nbz/1DdT83w/lfrEDRAM+LGUWp2tqGaqO8905mcOKR0u6jfCOjRbuPl+JbdpglXFye6y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787821507; c=relaxed/simple;
	bh=BFTAdV6fQ9fAN2gTRePuWKfYQhhLBOYHsicS+Rf1wRQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Efjunb5wuAoTTV5l+Dt8s1nnW6GMPiCGmKYWvxTyoJaxiLnsyUF4D29pSKcAtAMKJAG0t9te3nUQNjl5Rkx2YDmebijYJJl8DBdVf+50mV/oAqm2AKDr07h6Qmk9NTD3oqU4Not8ih9UuDL+qLr0ydlhd6dg6QKB0Jmvsl19+xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NFiX2Hz0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NFiX2Hz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACB01F000E9;
	Thu, 27 Aug 2026 09:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787821499;
	bh=6mgAw0HNQGud7mXVXH4msLGamqhZ2IoKisgF+zje5Ls=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NFiX2Hz0xA9wCuwCVaFxh9BFkvVTgbtV69jDFCxty1GjFF4QS2iiJ14t7CscDDfV0
	 3mwLppZnXEEjqnj8/U+31NCUZx/DdTbJw3WgkQK+VEGb39I83yMz8mYS6mgG5ntrfc
	 NJ5UBPrfXfk4c/Wdwsp2tVHB1n8RbQ9sF6pxykqjHXrd6F+n0W/JJGK7lBJuXKbWZ2
	 Xbyz1/1W+EMl9b6kdLan/BgV6Yph7lUkYFmhGOe4/KtTJOU+TIaZ54BL+QQt46bnRK
	 d9+VG4L5fh03fdQrjmXq05m8e52xEjDtCEodnTKKB6HKhjwNNozVOuFcJiuYSXAobs
	 ITiu0wC+OILdw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/3] md-cluster: revert local resize and propagate
 cluster errors
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260827084453.124629-3-ghuicao@163.com>
References: <20260827061200.79753-1-ghuicao@163.com>
 <20260827084453.124629-1-ghuicao@163.com>
 <20260827084453.124629-3-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 09:04:58 +0000
Message-Id: <20260827090459.4ACB01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:

New issues:
- [High] Reverting the local array resize on cluster failure leaves the on-=
disk superblock inconsistent with the in-memory state.
- [High] Missing revert of block device capacity when cluster broadcast fai=
ls creates a split-brain state between the block layer and the MD layer.
- [High] The return value of the revert call to `pers->resize()` is ignored=
, which can hide a failed revert and leave the array in an unexpected state.

Pre-existing issues:
- [High] The patch fails to propagate the error when the cluster resize is =
rejected by other nodes, resulting in a silent failure reported as success =
to user-space.
--

commit cc96df1db446b526c4a40bb6ed18c53c2fa44fb6
Author: Cao Guanghui <caoguanghui@kylinos.cn>

md-cluster: revert local resize and propagate cluster errors

This patch attempts to fix a split-brain state during an array resize by
propagating the return value of the cluster update_size() operation and
reverting the local resize if the cluster operation fails. It also logs
a warning if the cluster update fails during the reshape completion path.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3d..10b9880e64580 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8022,9 +8022,11 @@ static int update_size(struct mddev *mddev, sector=
_t num_sectors)
>  	}
>  	rv =3D mddev->pers->resize(mddev, num_sectors);
>  	if (!rv) {
> -		if (mddev_is_clustered(mddev))
> -			mddev->cluster_ops->update_size(mddev, old_dev_sectors);
> -		else if (!mddev_is_dm(mddev))
> +		if (mddev_is_clustered(mddev)) {
> +			rv =3D mddev->cluster_ops->update_size(mddev, old_dev_sectors);

[Severity: High]
This is a pre-existing issue, but does mddev->cluster_ops->update_size()
correctly propagate errors?

If cluster_check_sync_size() returns an error, md-cluster.c:update_size()
executes a fallback path that overwrites the error state with the result of
the revert:

drivers/md/md-cluster.c:update_size() {
...
	} else {
		/* revert to previous sectors */
		ret =3D mddev->pers->resize(mddev, old_dev_sectors);
		if (ret)
			pr_err("%s:%d: failed to revert array size\n",
			       __func__, __LINE__);
		reverted =3D true;
...
}

If the local revert succeeds, ret becomes 0, silencing the error from
cluster_check_sync_size(). When this code receives rv =3D 0, it will
incorrectly assume the cluster update succeeded, bypassing the new revert
logic and reporting a false success to user-space.

> +			if (rv)

[Severity: High]
The new revert logic handles the in-memory array size, but misses correcting
the on-disk superblock if cluster communication fails.

In md-cluster.c:update_size(), md_update_sb() synchronously writes the new
size to disk. If lock_comm() fails, it returns -EIO without reverting:

drivers/md/md-cluster.c:update_size() {
	md_update_sb(mddev, 1);
	if (lock_comm(cinfo, 1)) {
		pr_err("%s: lock_comm failed\n", __func__);
		return -EIO;
	}
...
}

If cluster_ops->update_size() returns -EIO, we revert the internal MD array
size here, but shouldn't we also call md_update_sb(mddev, 1) to avoid
leaving the array in a split-brain state with a corrupted on-disk
superblock?

[Severity: High]
Does this sequence cause a split-brain state between the block layer and the
MD layer?

If the cluster broadcast fails right after checking the sync size,
md-cluster.c:update_size() unconditionally updates the block capacity before
returning the error:

drivers/md/md-cluster.c:update_size() {
...
	if (cluster_check_sync_size(mddev) =3D=3D 0) {
		memset(&cmsg, 0, sizeof(cmsg));
		cmsg.type =3D cpu_to_le32(CHANGE_CAPACITY);
		ret =3D __sendmsg(cinfo, &cmsg);
		if (ret)
			pr_err("%s:%d: failed to send CHANGE_CAPACITY msg\n",
			       __func__, __LINE__);
		set_capacity_and_notify(mddev->gendisk, mddev->array_sectors);
	}
...
}

This code catches the __sendmsg() error and reverts the MD layer capacity
via mddev->pers->resize(), but there is no corresponding call to revert the
block layer capacity. Could this lead to out-of-bounds IOs if the block
layer exposes more capacity than the MD array limits?

> +				mddev->pers->resize(mddev, old_dev_sectors);

[Severity: High]
Is it safe to ignore the return value of the revert operation here?

If mddev->pers->resize() fails (e.g., raid1_resize() returning -ENOMEM due
to bitmap allocation failure), the MD array will silently remain stuck at
the new size internally while user-space receives an error code. Shouldn't
we check the return value to handle a failed revert properly?

> +		} else if (!mddev_is_dm(mddev))
>  			set_capacity_and_notify(mddev->gendisk,
>  						mddev->array_sectors);
>  	}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827084453.1246=
29-1-ghuicao@163.com?part=3D3
