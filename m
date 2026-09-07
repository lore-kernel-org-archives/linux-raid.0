Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CA9A4E8E04
	for <linux-raid@vger.kernel.org>; Mon,  7 Sep 2026 13:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788789404; cv=none; b=EUFeuDl42A9myZd+rdC8uikBpuohyhvLVz7GxyzzWLEe3Gj5jISpVEDnxblR9OhQgD/pdClphBI+pwRKdJolWz+SstqQ/+XbDW9eKbPGQN6Pq18AvjcPSM+gWr0L3QKLyrGvtl66p+4BAtV2w4ZhPOg0KFbwHiE6b9BBnI9u4dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788789404; c=relaxed/simple;
	bh=4qu8yDV389PazBI3xOJOIhR0CgUvU85nM/N1lom7amc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Af65jYQw+q1n/6uF8pVMaJltvAe9paH8puhP9jEqiJxbYsybWSO/O/GaLEcAQXHD5wu9cVPUOneCMTAiMYUbOzQFUXfQYGNed4cd5cH/nLqaNxZY6TiRFV6gXg91zxLl40ZxKkk8gmCyqiL8dEcOCL9SxohHPyJSjSjmS7uzuf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H5P+ldRu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H5P+ldRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94091F00A3F;
	Mon,  7 Sep 2026 13:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788789400;
	bh=+q9CEUNf7V5d0wJdMt4lx28kzpB/44y6fsHiyiS1VnA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H5P+ldRueck8qrA2bXm7l3dbjCm7pQrRpgozIiNDCOW7D/Igm6cMsxe8GEMf59eeA
	 dNF4wu+Lec4vTfy4h9kWLA6/2MUqgfHgJHUDI+K7cuPUJF9uRQ8RB+PUvl2Dl33t1w
	 mf+Q4RMQzEtUDcXqQHvlP+k/F8G0q7D4hcyzRujYUeb/UDgpaKVkvSNBr+fDh/Uokq
	 1JpBg1dAFu+On1K180NS7hOCibxYhGcrcra8AIDgrKli3OUgObLB6njZUwj4TCHPFQ
	 YduWxccHlfWiMj7f9ydnOL3t2S7WCryCcSP8icgVybmvP2Imyxt1CNLyInHfv7KgAu
	 +P7ESGgh4h6HQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 3/6] md: don't wait for q->limits_lock in
 check_sb_changes()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jack Wang" <jinpu.wang@ionos.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260907133929.1081540-4-jinpu.wang@ionos.com>
References: <20260907133929.1081540-1-jinpu.wang@ionos.com>
 <20260907133929.1081540-4-jinpu.wang@ionos.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 07 Sep 2026 13:56:39 +0000
Message-Id: <20260907135639.E94091F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The return value of queue_limits_commit_update() is ignored, allow=
ing a disk to be permanently added to the array even if its queue limits ar=
e rejected.
--

commit 9dfb5955d3bac2bdadfd9671f084d71c343b76e2
Author: Jack Wang <jinpu.wang@cloud.ionos.com>

md: don't wait for q->limits_lock in check_sb_changes()

This patch updates check_sb_changes() to use a non-blocking trylock when
stacking queue limits for a newly added spare. If the lock is acquired, the
limits are stacked inline to avoid blocking on I/O while holding the
reconfig_mutex.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
[ ... ]
> @@ -10885,7 +10900,24 @@ static void check_sb_changes(struct mddev *mddev=
, struct md_rdev *rdev)
[ ... ]
>  					rdev2->saved_raid_disk =3D -1;
>  				else
>  					rdev2->saved_raid_disk =3D role;
> -				ret =3D remove_and_add_spares(mddev, rdev2, NULL);
> +				/*
> +				 * reconfig_mutex is held, so don't wait for
> +				 * q->limits_lock; MD_RECOVERY_NEEDED below
> +				 * leaves a skipped add to md_start_sync().
> +				 */
> +				if (mddev_stack_limits_trylock(mddev, &lim)) {
> +					struct request_queue *q =3D
> +						mddev->gendisk->queue;
> +
> +					ret =3D remove_and_add_spares(mddev,
> +								    rdev2, &lim);
> +					queue_limits_commit_update(q, &lim);

[Severity: High]
Is it safe to ignore the return value of queue_limits_commit_update() here?

If blk_validate_limits() fails inside queue_limits_commit_update(), it retu=
rns
an error and the limits are not applied. Because the return value is ignored
here, the disk could still be permanently added to the array even if its qu=
eue
limits (such as incompatible integrity profiles or alignments) were rejecte=
d.

Previously, a failure when committing limits would abort the disk addition
(for example, in mddev_stack_new_rdev()). Does splitting the limit stacking
from the commit and dropping the return value bypass this safety check?

> +				} else if (mddev_is_dm(mddev)) {
> +					ret =3D remove_and_add_spares(mddev,
> +								    rdev2, NULL);
> +				} else {
> +					ret =3D remove_spares(mddev, rdev2);
> +				}
>  				pr_info("Activated spare: %pg\n",
>  					rdev2->bdev);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260907133929.1081=
540-1-jinpu.wang@ionos.com?part=3D3
