Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBEF2470E88;
	Wed, 22 Jul 2026 19:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784747427; cv=none; b=rsyB8PvXPWPr1luXIcwL8KCezD41Q5H+fJnwaNTIyltLh9hvKrApdTjldUvpI3ZSTwPB6HDonXuVbgtaKlD1hSfLy9shYUEENI2N0A3tT5nIy8tUODS2jJcblQjkB2cCyPcdnmvkOCfLI2ocMoosRut0z/5fnwQtH8OwlkBP1/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784747427; c=relaxed/simple;
	bh=ZtJTdAsCCytmbsw2oXaS49t/mi4RgMznuOrlt9oufn8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BrQGE1TuwC9uziCJZIsuaHmko9wqRfdqzSqpOA/MtwHk32myQmz6UTE5xhXYU4AHNKrMDK/e784NftEXBGC2APJMukO67O4tIPsXUaYk6u3mO2kkj3hGGCV4uZ9XMQwL7e89A+L2pqj134yiAji9vVH5qrDe4kg6RDRQPvNrAL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XanppyIm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XanppyIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A551F000E9;
	Wed, 22 Jul 2026 19:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784747425;
	bh=vTpO37yCMzPSPJNTl8TT2QsAUzYSywnGvNIJjSXE//0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XanppyIml9wn9aRrgoTImCr3Gjal9Wk1s89wYfwfIXgdWMdJLptsC7ZkTqjDSs4YW
	 FW0za92Z6WC7uwFXFJ/SZEIKP1V8IJqz5M3VkWwfGoeraJt6G3GewPVXuPtrRry0Io
	 3Hh26+H77NuorhHrChsHxNEcNa8DTv9EJ47yThNAnoF7E98UG0GIwisqpYQKi7as8M
	 8AgWa+XrTYB32AecYQ0G9e/v3BsAJh08cAvXOo2zUdUpPrmUS6FSEeqwK96ax/EoMS
	 cGOc4ObFxJrAlH4MlDwkw6WP5HXPlF1sbTak8oczdIKXicIGB+dQMyNz4HZPGW5fl4
	 dWXibMLa7EI4A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 7/9] md/raid1,raid10: skip futile retries on P2PDMA
 mapping failures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260722185841.449934-8-mykola@meshstor.io>
References: <20260722185841.449934-1-mykola@meshstor.io>
 <20260722185841.449934-8-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 22 Jul 2026 19:10:25 +0000
Message-Id: <20260722191025.95A551F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

> From: Logan Gunthorpe <logang@deltatee.com>
>=20
> BLK_STS_P2PDMA reflects the peer/member pairing, not member health:
> retrying the same pages on the same member cannot succeed.  Keep
> WriteErrorSeen so the range stays fenced, but skip WantReplacement and
> FailFast eviction, as commit f7b24c7b41f2 ("md/raid1,raid10: don't fail
> devices for invalid IO errors") did for BLK_STS_INVAL.
>=20
> The failure is whole-range and deterministic, so narrow_write_error()'s
> block-by-block submit_bio_wait() retries are pointless.  Record the
> whole range as a bad block in the completion handler instead.
>=20
> Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devic=
es to RAID device")
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Co-developed-by: Mykola Marzhan <mykola@meshstor.io>
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260722185841.4499=
34-1-mykola@meshstor.io?part=3D7

