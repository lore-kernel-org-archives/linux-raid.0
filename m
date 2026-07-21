Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BDE47043F;
	Tue, 21 Jul 2026 17:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656470; cv=none; b=ar/Rob5dr2xXwGrkECWAMoeeA0qM1tE4VrRgIXW16b+37gY6JGPEzDus7gYYR4YjIytCa/FDCdhXZtMB+R+mO0K0Wsav1PNQqLdgyGCFyDTi3g54Wcak81yW2NbpZKH2uRJ9SOHQojY/C9lzO4xi2wMhdPAPkuFYLR/piw5z8K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656470; c=relaxed/simple;
	bh=5M3JbevceqazJSdYYlKzF+406GVDuxn1u71qU5HMRZU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=upwN5HSzfORNUyIbrwwJdEDIEblKf7uEoG+Qe9tFShiVrBU9e7VYSn9eRwc6MSMils6vgFLIxcThplgP7gSSqIi/4LMJq8VZIRGscctnAl2+U3b6+9uk5q9OGSDQYL+uZMtiM5hCShklKsfnvWR5GpSZffQ8NkHXAzyaltVDdGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ihC3i7P1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ihC3i7P1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C1B1F00A3A;
	Tue, 21 Jul 2026 17:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784656468;
	bh=zhgWQSsMN5TVqskMCy6IYVk9EOUz16oUnJ/UtEdUt7A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ihC3i7P13ZQFxR7Tso4qyaGsI9jE+2v17Md3VrqnSediOeDhoF57deY2XooZiUFqF
	 u9injbFgnYq3Z7dRBVYbGgW+rShLM3dmSIacYXyKTljwEwTqQ5oOHhqxyfthGk0jMq
	 G1JWHngTCFPyz3MfNdicQ1u5z10hD4cVTonsVeW7B2znrnSFE1esyXmSYTAVQxuKIk
	 ZFSQaHtdybKV7r1C40DbFL+otxBX+AV1DSdtLeRaXYk3w1eQSS/5Npy25TfHsB2nqQ
	 3N744YSsyzGqcNJXM8TakdCeE3KBLE4VcIAs9OTfDwSVsIE7dQUZYcFq8UfrE2NOCK
	 wBay3SuG2xC4A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/8] md: ensure REQ_NOMERGE is set on P2PDMA bios
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-pci@vger.kernel.org, yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260721174502.111503-3-mykola@meshstor.io>
References: <20260721174502.111503-1-mykola@meshstor.io>
 <20260721174502.111503-3-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 21 Jul 2026 17:54:27 +0000
Message-Id: <20260721175428.65C1B1F00A3A@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260721174502.1115=
03-1-mykola@meshstor.io?part=3D2

