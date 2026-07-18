Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA3943F0A1;
	Sat, 18 Jul 2026 16:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784393588; cv=none; b=gq7rnytuxiqZ47h4qLtgj/oQEFOJwN8ZH+R0rJJfoJpejHBuTTY56Fr3FvC8SERWcycyhe6tKcjjjq3yFMqhFa6lO6VKrQmFdmvaeglJMGVW8tjujrboId3d3qdMaQ5ax8LdEoknJeqQQ6aKJk/W3/cy/FRD9GOyn5STFuXNzZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784393588; c=relaxed/simple;
	bh=y/jy0+tlJVcfxy/IrVLPGk5f0vF4Q0fdXUOgLj6erz8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u0scxlFanWruAIXM3GLn0VzBK4Pynyuo1Hz57gpLDigb3GxRaZrDvghR2jqN4akEHcoAZepShxwYYjdl/s1/DHJzPXO8vicN309eXcoftO1KvW1Lkt3arn7eHCywsXDLFK7poYhkJTFxI1LT0TO7m7PpvomY4YePCgO4V2hOk9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g2kfs0lm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g2kfs0lm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5C11F000E9;
	Sat, 18 Jul 2026 16:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784393586;
	bh=39qqjVVaNLqK6N/UVxGrLqereMqf2je4dN78N2Qm7ME=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g2kfs0lm/JTvGjVdpfJEVYPuzTXbj8trpnsIzzg+xo1Il54YKq8LG38N09phygRTi
	 jK/uf6sGPcx6SwLn/+fkA0LbmLHdPJvS04m0vr/VlcC6T3ixwPdtJkZ4+v5hU0kvII
	 LT35bBHfeog80NKX3VMNHdIm68cRh+6cVaEE7IYseVm3IKAtWU+ph3k2wh2sWO2Owi
	 BTfJEmLnSp8i7/0c3zjU4jtIoa8k8jWFu4w1S2w7vWkZljnp7rFirxXmiU/dkllF7f
	 M925VGmV17A0yb6uQFwAkz6DPZWBT58u9Sp7WY/K9VHDxmOlSt/Jc9FTW3Ybnft1Mo
	 z6HYJj2dg2w9Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/6] blk-mq-dma: restore BLK_STS_TARGET for unsupported
 P2P transfers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-pci@vger.kernel.org, yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260718162547.448892-2-mykola@meshstor.io>
References: <20260718162547.448892-1-mykola@meshstor.io>
 <20260718162547.448892-2-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 18 Jul 2026 16:53:05 +0000
Message-Id: <20260718165306.3C5C11F000E9@smtp.kernel.org>
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
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260718162547.4488=
92-1-mykola@meshstor.io?part=3D1

