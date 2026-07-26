Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD3137FF43;
	Sun, 26 Jul 2026 12:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067603; cv=none; b=Ji5xqyrRbCnXj7vgY97TTjcSI/l4YA0ivQ7v/FHqWPPlaSNDQNFAkWF5LXaillDAIan0f6o+sxA4xZGwemZTxDkgVxWzJSIKBqfXNZiqOXjYwFbSUBwNtdhTaRxkhCeVLE7MNgxpjKUZvuv4C8rEMDDVxuqSjNV3m39XRWnSDRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067603; c=relaxed/simple;
	bh=KGzZP51JVtDDV8bYRejyAra8JgGiXhxLA0U0IVh02XQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cPEnmrlYV9/fYKQxA22WhfuRi/t5UPG2iJcxtXUCVHDc2I4lFX3t+QtoYNLoq1KBuPc0fBBReJQCMkijfcf7hm0k1s4iJHSHzVmILj5lJ9UQCj/46E+TqGVr90T8KfbWmKKp+Ry2a5mghrPhDOaoG4ILQSL+OE2sqW5kKc7E+W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T6SI2Ps1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T6SI2Ps1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12581F000E9;
	Sun, 26 Jul 2026 12:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067601;
	bh=BYEfJPBAXx+dVpjhseTl1Fky4qA86+gs1sKU3ZwP4e0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T6SI2Ps15scG6uYSRowuJ8g5Vl85jzje9n44FryAtJAOzLsLQkB6rV5GQaveo+RTR
	 C58eBWNXeAVFAnn3LEclmfNlESvCrtZ/LgebNMPPNsJFxf1BZe64H52yWDNQSWkgYq
	 2nmgz2zqqwNWBMVXZiAox0TUsSHA0whHtqFMkNprzj+svgjrk6fZNksZ+opZw/A/CY
	 AmogUxZGFs8/T1gQM5YW+GvC/Vo1boI/UOZ8z5LWqDnOEvnO/XJ6eD/KR9a+lFFmIG
	 rAcVTmka/cxS4R2Rz/S3b9tFDRpMx836/zaw8579pOrpfaNdQ6Vxt8sCSwVISenEw3
	 UHcqBtMgMjGrA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 08/12] md/raid1,raid10: set IO_BLOCKED in case of
 BLK_STS_P2PDMA
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, linux-pci@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260726113229.2154269-9-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
 <20260726113229.2154269-9-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 26 Jul 2026 12:06:41 +0000
Message-Id: <20260726120641.A12581F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] A pre-existing ABBA deadlock can occur if a read error is processe=
d by `raid1d` or `raid10d` concurrently with a management thread calling `f=
reeze_array(conf, 0)`.
--

--- Patch [8]: [PATCH v6 08/12] md/raid1,raid10: set IO_BLOCKED in case of =
BLK_STS_P2PDMA ---
commit f4692375c384d52b343af556c8a63ea0e3e48c0f
Author: Mykola Marzhan <mykola@meshstor.io>

md/raid1,raid10: set IO_BLOCKED in case of BLK_STS_P2PDMA
   =20
A read that fails with BLK_STS_P2PDMA cannot succeed against that
member, so mark the leg IO_BLOCKED and let the retry redirect elsewhere.
This skips the read-error machinery to avoid evicting a healthy member
under a P2P workload.

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 83ebf40237d57..16a47568679f0 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c

[ ... ]

> @@ -2674,7 +2676,7 @@ static void handle_read_error(struct r1conf *conf, =
struct r1bio *r1_bio)
>  	 * read error.  This is all done synchronously while the array is
>  	 * frozen.
>  	 */
> -	if (mddev->ro) {
> +	if (mddev->ro || status =3D=3D BLK_STS_P2PDMA) {

[Severity: High]
This isn't a bug introduced by this patch, but does extending this condition
expose a pre-existing ABBA deadlock to P2PDMA failures?

If a management thread concurrently calls freeze_array(conf, 0) (setting
conf->array_frozen =3D 1 and waiting for nr_pending to drop to 0), and
raid1d takes this branch, it skips calling freeze_array(conf, 1) and
unfreeze_array(conf).

Later in handle_read_error(), the daemon thread invokes
raid1_read_request(), which blocks on wait_read_barrier() waiting for
conf->array_frozen to be cleared.

The management thread is blocked waiting for the daemon to drop its
nr_pending count, while the daemon is blocked waiting for the management
thread to unfreeze the array. Can this cause both threads to hang
indefinitely?

>  		r1_bio->bios[r1_bio->read_disk] =3D IO_BLOCKED;
>  	} else if (test_bit(FailFast, &rdev->flags)) {
>  		md_error(mddev, rdev);

[ ... ]

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 77c7d8a599160..462f622556ed0 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c

[ ... ]

> @@ -2859,11 +2861,10 @@ static void handle_read_error(struct mddev *mddev=
, struct r10bio *r10_bio)
>  	 * This is all done synchronously while the array is
>  	 * frozen.
>  	 */
> -	bio =3D r10_bio->devs[slot].bio;
>  	bio_put(bio);
>  	r10_bio->devs[slot].bio =3D NULL;
> =20
> -	if (mddev->ro)
> +	if (mddev->ro || status =3D=3D BLK_STS_P2PDMA)

[Severity: High]
This isn't a bug introduced by this patch, but does this branch suffer from
a similar pre-existing deadlock in raid10?

If the daemon thread takes this path, it skips the freeze/unfreeze cycle
and later calls raid10_read_request(). This blocks on wait_barrier(),
waiting for the concurrent management freeze_array(conf, 0) to clear,
creating the same deadlock between the daemon and management thread.

>  		r10_bio->devs[slot].bio =3D IO_BLOCKED;
>  	else if (!test_bit(FailFast, &rdev->flags)) {
>  		freeze_array(conf, 1);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260726113229.2154=
269-1-mykola@meshstor.io?part=3D8
