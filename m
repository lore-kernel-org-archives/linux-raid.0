Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC0F3F4101;
	Thu, 23 Jul 2026 21:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840992; cv=none; b=bEtMMnAPL4avuigD1ixkIrcKAHpsyULuHyZXqvyiYYqLKlfclm3cF8+PXd/x/++BCMfnOMMviV/uUh5067tz1Hcvq++WLcL2JGQ2e5A4EwDSGHQrM0Cth0k2sVmLXViO2GR9ODVUvopQ7UBTkGg/xaw6R+82F43sp9tuBwUhkUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840992; c=relaxed/simple;
	bh=FXvoU4YOWMsgWQUk6N2UB4KaAOTYhkdHcD36bZIsGTk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=O2/tV6xxXHCuVUt4TloURvbkrPuOkEACcYZlWYWtCsKERaR8IamKKJBDvEye8XoqMveRwByfLbuV7QknU8lw0bEWzzywal1DmIudnt2BXW5LPwdAQo8ddbgZZ2Rz9h+B/D53k3k/yPscU1XTh+juj22wZ80xdfHaqRfKzCOYOPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RVB6UkZm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RVB6UkZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272F01F000E9;
	Thu, 23 Jul 2026 21:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840987;
	bh=VAmqNjSQYZWk5HehzNC6pHYiUSZX8GqqiLmdK8Lmi/o=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RVB6UkZmj2LD8oShAjSkJJxsSSUjCdnMiaqRg14Gwo7cPpHDtyCfRpTvSFM2kCeWT
	 MreJytQLYpNdPzyMe4+696uSZDwFAkVpPSUB5UMEKkQ0a3j2xRoi7vHO7HVcg/VIZW
	 nBn3xoi11a7FLbC+NX2ahLNT0sgOeG5Yozb2EF4JC8hhQOrFQ34U429y36A11uFzYM
	 jVdDZbALDoJKRa1Tua+GA91Q/aGQaC5ODHBBc/g1xwJD52fJEwUtfl5tUFc2wXABU6
	 bbDas2TzVIHx32m8xCIIe6UHdhzA15l4q7zcaeeZvcyeJIzHzebuS/66L8xsUSNFTn
	 I6wN0bTpNkclA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 09/10] nvme-rdma: use ib_dma_map_sgtable_attrs()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io, linux-pci@vger.kernel.org
In-Reply-To: <20260723204206.76930-10-mykola@meshstor.io>
References: <20260723204206.76930-1-mykola@meshstor.io>
 <20260723204206.76930-10-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 21:09:46 +0000
Message-Id: <20260723210947.272F01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

> ib_dma_map_sg() folds every mapping error into a zero return, losing
> the DMA layer's error code.  Switch both scatterlist mappings to
> ib_dma_map_sgtable_attrs(), which preserves it for the next patch to
> act on.  No behavior change: failures are still reported as -EIO.
>=20
> A local sg_table is needed: dma_map_sgtable() maps orig_nents
> entries, and the embedded table's orig_nents is the allocated count,
> not the count blk_rq_map_sg() produced.  rdma_rw_ctx_init() does the
> same.
>=20
> Assisted-by: Claude:claude-fable-5
> Cc: stable@vger.kernel.org # v7.1
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723204206.7693=
0-1-mykola@meshstor.io?part=3D9

