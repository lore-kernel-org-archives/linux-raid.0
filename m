Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFEC390C94;
	Sun, 19 Jul 2026 11:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784458881; cv=none; b=GrYDPvq4zaU1xA2kwJwSvN6RuCLsZOKsSXAXEaYwlhRa3mTXs/mjXHRvj8WCfKkY+A5NunzBSyORBpPlI2iBKDviJ7Nn60diCUKfsB5r1zxXUtRKJWXNW0XPx5h18kHf2KN7QVdxQYxuR0z4QRlmvtDH38U0yGkJlddppm4j5fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784458881; c=relaxed/simple;
	bh=i/76fWBfh7D3mpgP+AHgdnzeWUFqp4yEppAwHL4ct6g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=c3safNNYblFOtNmoktQKPk/+W51tVdQhhdOtqcOooBkSmrz9qePrnwTQryq3e2laf0GHnOHbNnwqOn3fPqQBrb92RMVPC2ip3e92Dci2nrb8Znf5H+k+2uyvi+qnyUXuZRJmiypO8y3ee6rNyAs7sUzrzqyQpLxnnmFVnkZeRs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H0FWKpk8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H0FWKpk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9CE51F000E9;
	Sun, 19 Jul 2026 11:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784458878;
	bh=xYNx1R2GN4RPpaw3M6ZGZ5RZr2AchcK8qQYQakJ2p7I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=H0FWKpk8G0DTjYnR+yGIetmky+bmCXttEFOT8myazaCFbzezmCVLch1fFF2a2eHOQ
	 U4I7cvb493kczSW2wQIr0JdYD6df3Yl+jVEvDqqAmUHLNyIxJC+7iBXMEHcOn9D6mk
	 YopA8P+oDiVg7N4I2k52NttPX5UjkuBxAI4u+yv/CJ3wx/xqVfqDdt5Jr62xsbUxaj
	 xujnPnQMeliAnx1Ig+RwSYi/LYLacPd815HlhpnezYoIgr3UM4AOckyCgm6XoJEWDW
	 J4ysknj/FF0otGHAP7t5pNfQWbZrjLeZdwisfjtImGq/SHrmkqK26fBdiK8dFaStHU
	 ARqW+tU5QrnWw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/7] blk-mq-dma: restore BLK_STS_TARGET for
 unsupported P2P transfers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-pci@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <20260719105327.864949-2-mykola@meshstor.io>
References: <20260719105327.864949-1-mykola@meshstor.io>
 <20260719105327.864949-2-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 19 Jul 2026 11:01:18 +0000
Message-Id: <20260719110118.A9CE51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

> Commit 91fb2b6052f7 ("nvme-pci: convert to using dma_map_sgtable()")
> deliberately mapped unsupported P2PDMA transfers to BLK_STS_TARGET,
> matching dma_map_sgtable()'s -EREMOTEIO: "When this happens, return
> BLK_STS_TARGET so the request isn't retried." The conversion to
> blk_rq_dma_map silently changed the status to BLK_STS_INVAL, which
> regresses two consumers:
>=20
>  - md/raid1 and raid10 ignore BLK_STS_INVAL leg failures
>    (commit f7b24c7b41f2 ("md/raid1,raid10: don't fail devices for
>    invalid IO errors"), where it means a request-shaped error that
>    fails identically on every member).  Since commit 02666132403a
>    ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device=
")
>    P2PDMA bios reach md arrays: a peer-memory write to a member the
>    peer cannot reach is counted as written, the master bio reports
>    success, mirrors silently diverge, and on a topology where no
> [ ... ]
> Fixes: 858299dc6160 ("block: add scatterlist-less DMA mapping helpers")
> Fixes: 7ce3c1dd78fc ("nvme-pci: convert the data mapping to blk_rq_dma_ma=
p")
> Cc: stable@vger.kernel.org # v6.17
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260719105327.8649=
49-1-mykola@meshstor.io?part=3D1

