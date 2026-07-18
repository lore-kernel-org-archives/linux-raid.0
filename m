Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C773E0235;
	Sat, 18 Jul 2026 16:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784393449; cv=none; b=DaWdDl6Z6eBo1iscZe9O/o+SJT54kaT3I4vo1PEr4MKXk94BENCYzec8LhD92Wn/iKpSadJ3H20yUGdHjlKzizirY98e2khgKcRzgURg1mSKJ82QkMq1htfPLzVPL6xbeMR4zEptVsCfksX6AfMRm4zgVgHHdKcan5Kv2IolDU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784393449; c=relaxed/simple;
	bh=rmowBj76+42V3azo8sckdfWeSV7hqBXbHebGX1d1S7g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lyJnIPOjM+0n72/seTkQAmW4z5CRTTKDcL05HJfl6hTLLYGNzpZ96JnJyxqKte0ZxgxppzFNBY4e2/lLlXk2+6EpKrV8FwmRosZUWpxgYA1XBpOuVmi3n/MFk/iqyK+DY5U0Oka1Xe3op4JM0yA9mLs5o8rIAT9VB7Cmfe24i2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JD5H8rGo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JD5H8rGo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565481F000E9;
	Sat, 18 Jul 2026 16:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784393444;
	bh=rmowBj76+42V3azo8sckdfWeSV7hqBXbHebGX1d1S7g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JD5H8rGo970rXXz9p7e2SvG3Z4HFGnjy+LoNK50iJSR/9ePBN0UuHI8uhNzzf81fk
	 qjd5VIebGHHTOr5apfDmsESo8OA3vYkjolYE7zpF8CJGhBT73vIwDCIkGN3UCARJwM
	 FgCZ93gK33rXJLWXOtsQmQmjNp62S5jW9wlSh0pinDembQ8Z4hWvRGVPxXTQ5ddEnn
	 Z09RAsOkbm1VEcSqXfhr9vQJOtQvU3lkwQK+OIaEkwK9qbBo133w7w9LzZ+z+CJogv
	 uUQYFu+Y2lHP86YsZwmT1M50yDs5Af+BkNOpPkUI+nLveBqL1gwbq1Ksf99L0y/khs
	 H6WPZG/Op+SiQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/6] md: ensure REQ_NOMERGE is set on P2PDMA bios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-pci@vger.kernel.org, yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260718162547.448892-3-mykola@meshstor.io>
References: <20260718162547.448892-1-mykola@meshstor.io>
 <20260718162547.448892-3-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 18 Jul 2026 16:50:43 +0000
Message-Id: <20260718165044.565481F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

> md_submit_bio() unconditionally strips REQ_NOMERGE before passing the
> bio to the personality, an optimization from commit 9c573de3283a ("MD:
> make bio mergeable"): a bio that md has split may become mergeable
> again below md.
>=20
> For PCI P2PDMA bios the flag is load-bearing, not a hint. The block
> layer sets REQ_NOMERGE on P2PDMA bios (__bio_add_page(), and the
> extraction path of bio_iov_iter_get_pages()) because the DMA mapping
> type of a request is resolved once, from its first segment
> (blk_dma_map_iter_start()), and request-level merging is prevented
> only by REQ_NOMERGE. Stripping it allows the member queue to merge a
> P2PDMA bio with a bio carrying pages of a different pgmap, or host
> memory, mapping the merged segments with the wrong bus address:
> silent data corruption on the member.
>=20
> Set the flag for P2PDMA bios instead of merely preserving it. No
> in-tree path currently submits P2PDMA pages through the bvec-iter
> path (bio_iov_bvec_set()), which skips the flagging -- but nothing
> structural prevents one, so setting rather than preserving hardens
> md against that gap at the cost of one branch. Everything else keeps
> the original optimization of clearing the flag. This covers every
> personality that advertises BLK_FEAT_PCI_P2PDMA (raid0, raid1,
> raid10), which is why the fix lives in the shared md_submit_bio()
> path.
>=20
> Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devic=
es to RAID device")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260718162547.4488=
92-1-mykola@meshstor.io?part=3D2

