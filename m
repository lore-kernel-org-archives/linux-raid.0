Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAC72C86D;
	Sun, 19 Jul 2026 11:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784458926; cv=none; b=bbjg5kPJyJg2fjOKyJ2f7Ft0Dh+o4h2bFa4j4OELlM2oSSuzvs/lC+aUcRzRQNW7+kypjSecr3JivzvfnFTvKpSbXMST9rYQc6OMO/r+sU1RgsLi+MaW7f+3e6iqAsVbjqqJzZhydanXd9c5fYQJMwsBvA4tyLOxzCbl5cCDa0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784458926; c=relaxed/simple;
	bh=Ljk9kxgBzm7RBVRXmosuvf9gQkBy2K+C2O77mpq8uMs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Yl61dAcyRaSZ50pVRz/OYOGJNxYSmE5BQDlQOnSrMzz2/hEnDX6c2vHByevImXL+kgXg/l4hPebdReZP+UlguQOmJnj61pd3O0UKPLfI9Uba8SgbK+cSLXUNoYNBVSo9IV63NGlR/llWxEla8WAScrxKA+Ib1Bpud7KAeOmrK+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eMXWrn2n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eMXWrn2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4591D1F000E9;
	Sun, 19 Jul 2026 11:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784458925;
	bh=Ljk9kxgBzm7RBVRXmosuvf9gQkBy2K+C2O77mpq8uMs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=eMXWrn2nb4Drq/Mkv5SjadpO4qkcVAeH1qplfdtWPyKE+8tD41h+M45L+LgPCPK0J
	 DptleOzQQJTfsyGDj7XyTaBZ8xfzcpjhSxFO8rASf5tGySWoYblKn9cVvdEiI5AHPZ
	 /WXeZfGJ/W8yFfpi3ohLNFqvO1nFNEeRIL6VCFg6Z0s/3wuBPYwi9VOFY2TKdRpbyz
	 qDx4y0zrZUgVTClpca/N4D05nEnJlaVyELLIFopd/Wuj27URaVrMbEY4aw9RURNA4l
	 WqZwWMwJLV3ryvnLOYqvUjsoe4rg57nGxtn5Pnq/4ubJHmaeyeC+WB5BZvZRgbgej5
	 V8JWsOia1I2Lg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/7] md: ensure REQ_NOMERGE is set on P2PDMA bios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-pci@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <20260719105327.864949-3-mykola@meshstor.io>
References: <20260719105327.864949-1-mykola@meshstor.io>
 <20260719105327.864949-3-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 19 Jul 2026 11:02:04 +0000
Message-Id: <20260719110205.4591D1F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260719105327.8649=
49-1-mykola@meshstor.io?part=3D2

