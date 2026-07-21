Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD50846D0AD;
	Tue, 21 Jul 2026 18:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656808; cv=none; b=qdzWDepKCJmA9i89+KNv+2Xi8svCaixgRCOwqSX4pVSDwUS5qhycSA5cDRiRVxhcWDe8Xypak85blItDob2XUZK48oSxSNitROMIJFY7h1F7ium3slvIWzsd7l4O1D3f3yd753mOZtM0RT7HA/0obJhJkuE1ntd7510MMV574nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656808; c=relaxed/simple;
	bh=x6qUPND4EsBFDtBkQPc7ILPXZ/V/1zQgFNizpJGoMgk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=G0kB80tdaGs6GzkTvnvAgjZmEh6zLJdezKPrFZwhJ0rpEur96A8OMroRX+yl2RW68CFOsHwTUP1nvvlviS/Mfxe1zs8QHPBcMRFGdEw3hI9cv2uNZCKYx5Bo8kQZpZ/ZlY3ew3N8NR1hGLs932+m/JTDTPPWwamDbaBHr7/tTqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hCwDULOb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hCwDULOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8106A1F00A3A;
	Tue, 21 Jul 2026 18:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784656806;
	bh=wIBe5SQCTsnCl6yfRSxMN9eT8pG6EQI6rZzZMDO51ZU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hCwDULOby3Vx68x06pXCEDBaq4h8weVsz3Nld4kcmmJqJCYRtgt2rJYWqoqCLImUm
	 L0SmBhsG5gaI7c9KU2ZPh+GSgVXgf4RdfBU1VzMEK/pDz2w1g9PfI+bBgxjHfnfz6v
	 8IddZJ27icOHDuxdpbhppBcYey7ORT4O41AL7rbprnTDTtRoSCTstbcewkSPCYiguG
	 +ua6uorhSwAkihYazKLFpEt5do7Sq77D85sRaSEFgDw/qkXkvkjHGhwbFsSlbfk7mJ
	 fhDQNv78N/nTO7QrlQ0m4vF2Ukdw03Usr5+v6Y/xSP63AYcig3/ZrbvcZbIK/p6tGK
	 y6fu4dQKfqmog==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/8] blk-mq-dma: restore BLK_STS_TARGET for
 unsupported P2P transfers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, linux-pci@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260721174502.111503-2-mykola@meshstor.io>
References: <20260721174502.111503-1-mykola@meshstor.io>
 <20260721174502.111503-2-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 18:00:06 +0000
Message-Id: <20260721180006.8106A1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

> Unsupported P2P transfers used to fail with BLK_STS_TARGET, chosen
> by commit 91fb2b6052f7 ("nvme-pci: convert to using
> dma_map_sgtable()") for dma_map_sgtable()'s -EREMOTEIO: an I/O that
> can never succeed on this device must not be retried.  The
> blk_rq_dma_map conversion changed it to BLK_STS_INVAL, which
> blk_path_error() treats as retryable and md deliberately ignores
> for member failures -- a P2P write to a member the peer cannot
> reach is counted as written and the mirrors silently diverge.
>=20
> Restore BLK_STS_TARGET.  Hit e.g. with CMB memory of one NVMe
> device used as the data buffer for I/O to a second one behind a
> different host bridge.
>=20
> Fixes: 858299dc6160 ("block: add scatterlist-less DMA mapping helpers")
> Fixes: 7ce3c1dd78fc ("nvme-pci: convert the data mapping to blk_rq_dma_ma=
p")
> Cc: stable@vger.kernel.org # v6.17
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260721174502.1115=
03-1-mykola@meshstor.io?part=3D1

