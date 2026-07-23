Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A269E299943;
	Thu, 23 Jul 2026 20:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839876; cv=none; b=jzcYL/k62DGdA28dErNEyKOxtNWWuo1nXYx6JTXCF5t/bFDChbPVJxhKG+0x0fe05KagIAk6EeL7eNBCyJCzbp5Tf4jZjlLg+zna/zkCjlcV136IucZxg4RRHAdprI7DlzEKb66hifoXxHvop8Tso9Pt6xzZW0aB063K+ZhMJds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839876; c=relaxed/simple;
	bh=E/86OnRUA+BvAmFyvNAo3LhPbleXjQ0YzDnctB07kcY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=L7WTAqu2nXWBiJMrA68d8aDqK2BfPZFnVvOJDHO+O0X8EGZTbE+jJ6fBQPAwdZrImze88TCNh9FpZnU5J7Tmg7VdBlXpDyPLcMOTKcsjlXMIHexvfjaJ1IHjzYDEmh2Cd5/W2ddKqwzV6hrVegNi0sKNcOhs+ek7RiFz9X71zUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SLLWhM+I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SLLWhM+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095991F000E9;
	Thu, 23 Jul 2026 20:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784839875;
	bh=SVFyxwFkTqJQ0K9BB1YFIt8n6g3vsjbSUyrW2uPXLaw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SLLWhM+IyYMqjI14/wVU53FDnlTlkhQ8/0/PKMc8qV1SMtq4woKl15BTd2ODsbJ2A
	 tuj6NhYOmkU0+84cgk5vePi7DJi2CTKKItDpLAEZXKMKDbqy+2Q6jVuZiv17NE2Lw8
	 +6y2B0Z9AhdwUSWGKx00OxX72jkqnQafYLSfEyc2pGgwKJNr3vLqb47utrfdPv/l3b
	 veBPx8hGtMiNePyTgJBPqL+zi8vPo/JA9N6hOUMuyOBkJGu595o/KucdtaQ5zKu/49
	 3o2ZTCFRlSONEcSYtNXxGZhJBVpUsU9NpDghGgcy7ZcMOEbz6Nmym58jqZAT+o5Bb3
	 WXie0RMSJg3sA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 01/10] block: add BLK_STS_P2PDMA for unsupported
 peer-to-peer transfers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-pci@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <20260723204206.76930-2-mykola@meshstor.io>
References: <20260723204206.76930-1-mykola@meshstor.io>
 <20260723204206.76930-2-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 20:51:14 +0000
Message-Id: <20260723205115.095991F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723204206.7693=
0-1-mykola@meshstor.io?part=3D1

