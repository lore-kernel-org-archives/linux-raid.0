Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A04288C96
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 13:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782219661; cv=none; b=B7dxoUeXhd/XY4gr3ig1qnFaEqgGmV8tft1d95w54jtPT2PkxrMw4UiEAustdtGZoMq+0SdaLmu43yc4j0evIcPcz73fNws9iyxAu/34HeLVek6OhcJJVLwcPyQ3JFBIBg/jlLvdNUTZCH3m3M9wE4WPF+mets+DTV+nqR7u9do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782219661; c=relaxed/simple;
	bh=5dPde9k8GA+tNpefUBX2isM9j1Rc9AxCGQzltVlfoiA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=C3J6qlns3LPdTm4jW0rVACJyApDa02tauNRq+/6u6OgeZItqcOH2BiCbUs2e0VIiqFDzW8xDDKlbOqidePZYogo9kaVs6snPO0AVVwB1xMBArjy7mU+stcd66z0VV8CbdqPJJPqjKMR07RIAU1dFmAJiWGbxoiWmcBznDm3nekQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M73J5QJR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M73J5QJR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477FE1F000E9;
	Tue, 23 Jun 2026 13:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782219660;
	bh=KxHLSzdwGIkwXORO4PADhla1HUa2NmdGrbZR4MENncs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=M73J5QJRMYZFuquOrrZK0CArrbw/l5mAAElqWCTojkVb2ZJIH+Swu4t6D59mQJ0h3
	 Qf2lbwoLgnj8RXeDfvEa4u+6o2sHZOu8PnFSH5h4Bwj/Ryc61+72d78KGykUXhgIOc
	 ig23gbRlwLRb74Tnmrely3iJekOFhFac1EVLsWHJsahzuPqC7VUjaGaDe2M67m425F
	 2MT+bijs1uRBLLZSjAfDH8uVDOAIgHA4Su2aIHzWkcQXic/4LDQsN2H0rWEv0MSq8D
	 kl9pHol5kljdbubiMZiFDNMqmksy1QzDv35vMMxAXwQTtU0wwBB3q+pwuj9f2X+DyS
	 3dep2SJaAxhpw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 2/3] md/raid10: resize r10bio_pool for reshape
Reply-To: sashiko-reviews@lists.linux.dev
To: "Chen Cheng" <chencheng@fnnas.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260623123840.2521340-3-chencheng@fnnas.com>
References: <20260623123840.2521340-1-chencheng@fnnas.com>
 <20260623123840.2521340-3-chencheng@fnnas.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 13:00:59 +0000
Message-Id: <20260623130100.477FE1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] The newly allocated `new_pool` is leaked on the `reshape_backwar=
ds` error path.
--

commit 2142096170ffdd8a1caabfde6f2461f6e7d64f61
Author: Chen Cheng <chencheng@fnnas.com>

md/raid10: resize r10bio_pool for reshape
   =20
When reshape grows raid_disks, the pool must also switch to new geometry
object size, and allocate a new geometry size pool and replace the old.

But not for shrinking reshape, because regular I/O can still use the
prev geo for sectors that have not crossed reshape_progress yet.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index cee5a253a281d..d740744a97461 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
[ ... ]
> @@ -4411,6 +4422,11 @@ static int raid10_start_reshape(struct mddev *mdde=
v)
>  		return -EINVAL;
> =20
>  	conf->offset_diff =3D min_offset_diff;
> +	if (mddev->delta_disks > 0) {
> +		new_pool =3D create_r10bio_pool(new.raid_disks);
> +		if (!new_pool)
> +			return -ENOMEM;
> +	}
>  	spin_lock_irq(&conf->device_lock);
>  	if (conf->mirrors_new) {
>  		memcpy(conf->mirrors_new, conf->mirrors,

[Severity: Medium]
Will this newly allocated new_pool be leaked if the reshape_backwards
error path is triggered?

If an array is configured for a reshape that expands the number of disks
(delta_disks > 0), the new_pool is allocated here. However, if the
component device sizes are also reduced such that the array is set to
reshape backwards, it can hit a pre-existing error check a few lines
down:

	if (mddev->reshape_backwards) {
		sector_t size =3D raid10_size(mddev, 0, 0);
		if (size < mddev->array_sectors) {
			spin_unlock_irq(&conf->device_lock);
			pr_warn("md/raid10:%s: array size must be reduce before number of disks\=
n",
				mdname(mddev));
			return -EINVAL;
		}

This direct return skips the standard cleanup path at the abort label,
causing the mempool_t structure and its preallocated elements to leak.
Should we add a mempool_destroy(new_pool) here, or change the return to
a goto abort?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623123840.2521=
340-1-chencheng@fnnas.com?part=3D2
