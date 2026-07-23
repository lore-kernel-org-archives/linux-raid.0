Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A17345EDF;
	Thu, 23 Jul 2026 20:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839887; cv=none; b=PTc4BE0fKJfSuhb3JdO/5FqlSK3t49AoZ2r33zJN8yy1Q/w5psCCydzj3ZGEI5LnG6IazTlLLL5onoWGZE8rcvvPM/ysRLG2TAMzqhCStWMF/cge3t/ly84DpIhwCtwK8INyKNBfpcHEMK885RwjTqMJHidOxFMdca49Jt7nMUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839887; c=relaxed/simple;
	bh=0tBbsH93GkDbJJFzMgg4Ki/gf0iucNM8UGuJWFpkNhw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=o+tIghYXd4GkWGppDhsnDyBn0iPuaPdcwzx+BPslNXL9gJe4FhyI9KP1GExCeVTGDQyW39SjjAR8Vaxy0/xjX42u+dZJr2zzKL8URcht8tEkNxHTzI4K4XNu99bfkhkOtI491EXwbtzDdEv+aZdv+LFbCecCRLJs8b9msmf8f60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QJENTyqw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QJENTyqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9161F000E9;
	Thu, 23 Jul 2026 20:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784839885;
	bh=eWMD1tdmONx7zkB2aNwVOwd278lHO79hv5LmkjqMnM8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QJENTyqw3bif2BWnKSd41PfwLsNzKeAtTIjtJ4SfYGhyGRtTNSpOFHFgE7Wc8/5an
	 2o0UqL1tk7Bt2Npnh/WO5RNLGD9BtpdYxGdQqz3ReyVop3ZkOcZTCmKeY8XY6/MV9G
	 8HlhHpQToLxqzCm2Urg3YYGdqKJLOpagUK7fqbX8gZkIw+iBF5OVCn5pFqr+D1NvKT
	 jRzexeQIlQJ+vfYScY92qF4LNThOLuLobpRQEEo4nLhrJkcikAQ2j4p5r89YqcToTk
	 RQF6CZddUW0hPVGW7o+2+/Go3kkOjfLa9pEppdEopHE3+MeKFJrhBR65ATbWoaGDgs
	 1qWWf/MrSDXAw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 02/10] md: ensure REQ_NOMERGE is set on P2PDMA bios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-raid@vger.kernel.org, linux-pci@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260723204206.76930-3-mykola@meshstor.io>
References: <20260723204206.76930-1-mykola@meshstor.io>
 <20260723204206.76930-3-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 20:51:25 +0000
Message-Id: <20260723205125.AB9161F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

> md_submit_bio() strips REQ_NOMERGE from every bio.  For P2PDMA bios
> the flag is what keeps requests single-provider (see
> __bio_add_page()): merging a P2PDMA bio with one over a different
> pgmap, or over host memory, maps the merged request with the wrong
> bus address.  Set the flag on P2PDMA bios -- bios built via
> bio_iov_bvec_set() arrive without it -- and keep stripping it
> otherwise.
>=20
> Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devic=
es to RAID device")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723204206.7693=
0-1-mykola@meshstor.io?part=3D2

