Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BDF470EA7;
	Wed, 22 Jul 2026 19:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784747215; cv=none; b=mHBr1zvAOOWLVW3Mx2YW0wKeTBprCj8SGCgeyMgYjFhayJ/CHYPRLNWzWRLsEHuMMMxtf1qnM6tyMnC4KzbQWS3MJ/5cU2R/rOsr2uo/30ylstrp6jBbbif0JUkihu/2MElXWHY8rsejkXspIMO+SBn8SI5pAt7mt0MdGpUEAoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784747215; c=relaxed/simple;
	bh=VrSotu7uz3ZTRi+/4/UGVnS3rRSacg/dhKM+dIdk7cA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HdedZvH9LQSmH5e7+OZRRo+Az4GhkeU4qQ0QLUDChsLhtzpc4axhFtznpFV6ou0sBBzRXghLmSAHsLG56/flDN8deiFcaQrCmujajc48t3zV1NEJaXGQ6kwOKIou7icrgK2KXtMxoWkXIl3weJrG5dbXMVyOU3q6QOfEg+7Hh4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jQDIoKCI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jQDIoKCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6C21F000E9;
	Wed, 22 Jul 2026 19:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784747213;
	bh=hwad+3Aao7WK/vG7ulyV9XJPUmIaeZue1fzRWZGxRlM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jQDIoKCIDM8EdvLzP3Iw/o1kMl8v/i8dkCsh9JNXNyNUVkhPg6CKiS1O31v/MjB2e
	 ta+gMWlAeUj4z5nvs4Lj1+x5dM1v0H10ZUEGVW9a4gpM/aUuOpNIRjyULNrnlkfbDA
	 1XUAhhFkluxIlVCXIxiOB8jTaAg4+qO9Z5ctPit2WeDlAqPGu4c8NTzn++z/Z2cE0B
	 9gqhIuVVXEueLnS5LpIQzKooxFTeMbqrN/4l3+OupUFsvWrU6/F6+vh1gyylTM0pjX
	 WfwMiZR17iGYZ3TClozoDUKIz4uii5jDodVuA69jb9poXouiRQ21yyrDiPjcEPjOtP
	 lUTmYf23nzZJA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 1/9] block: add BLK_STS_P2PDMA for unsupported
 peer-to-peer transfers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io, linux-pci@vger.kernel.org
In-Reply-To: <20260722185841.449934-2-mykola@meshstor.io>
References: <20260722185841.449934-1-mykola@meshstor.io>
 <20260722185841.449934-2-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 19:06:52 +0000
Message-Id: <20260722190653.0F6C21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

> From: Logan Gunthorpe <logang@deltatee.com>
>=20
> blk_dma_map_iter_start() reports BLK_STS_INVAL when a P2PDMA transfer
> is attempted between two devices whose PCIe topology cannot route it.
> blk_path_error() treats INVAL as retryable, so multipath requeues the
> I/O forever, and callers cannot tell it apart from an invalid request.
> md also ignores it for member failures, so a mirror silently diverges.
>=20
> Restoring the old BLK_STS_TARGET would stay ambiguous -- nvme maps
> NS_NOT_READY, LBA_RANGE and CMD_INTERRUPTED to it too.  Add a dedicated
> BLK_STS_P2PDMA, non-retryable in blk_path_error(), and return it from
> blk_dma_map_iter_start().
>=20
> Fixes: 858299dc6160 ("block: add scatterlist-less DMA mapping helpers")
> Fixes: 7ce3c1dd78fc ("nvme-pci: convert the data mapping to blk_rq_dma_ma=
p")
> Cc: stable@vger.kernel.org # v6.17
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722185841.4499=
34-1-mykola@meshstor.io?part=3D1

