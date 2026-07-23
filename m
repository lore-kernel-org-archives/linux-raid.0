Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7A4389114;
	Thu, 23 Jul 2026 20:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784840089; cv=none; b=co+ukw94+B7/7D0M2zxRWcGd7x8i9h1vaKvxdD61bHwflSXHb1gNXw5dgmmEqZ08hGgFIq7fgaYEBHAxu4/XLzDpG+mtjeDpnhwbDOtmZwk+yszJtcZxeoqNn4+ZSMjJBqrwJDfRi+2eWP7IQFdZ/dkRM8BF0BjfIkRxO2TlVUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784840089; c=relaxed/simple;
	bh=VJmFWNpkpyWSMSMvcDm5H9ZEhbT721dFXTo+KQoKeOM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=rNxD066M3kOj+jCuZ0JeYyg1MXk40v8Gh+QeQWXsL5TEMkBo+OAxEZqdXlTym9zgXWBP96/oe/XmRdNmthI4YP5IAULDahAig9v7HDVASvJAIdAysBWzGQBbpbtkJMeDw4ON/lA6G6AYu7w5jQSDHsg8C97lKqWgGRBy6PJGSOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uxc73gRq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uxc73gRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853151F000E9;
	Thu, 23 Jul 2026 20:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784840087;
	bh=VJmFWNpkpyWSMSMvcDm5H9ZEhbT721dFXTo+KQoKeOM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Uxc73gRq0siT4Bk0okXRLJsVp5weCzSvcBgOvKgnFxLsFdwFNxNGEFKgEaAJtyatj
	 Qu7a+L75zm/BV23suQlBm0j/LK7ADhFVv6jAfXe34R2scj0pH+hMoIoFCKmezsCOGN
	 1SXIEAh5C4sxCkyHYXbgyyrMW6ak2HXT0pv7BDpopmKxFAgIllCI5l40rTt0YzIGHx
	 zlQCW9t0N5SRkX1B9qr9jQ5Dib9H1LdrKV3r0rM4mVCgDfdpRfmF1k21ym58WDvdY5
	 t6gIlphi9xyAkgajqkt5HjlkYU3J0TzUeC/+FYHuot1d0U2b6x27tKUQLXuFY90kNS
	 xJT3il0wPUWtg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 05/10] md/raid1,raid10: factor out
 raid1_write_error() helper
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: linux-pci@vger.kernel.org, linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260723204206.76930-6-mykola@meshstor.io>
References: <20260723204206.76930-1-mykola@meshstor.io>
 <20260723204206.76930-6-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 20:54:47 +0000
Message-Id: <20260723205447.853151F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

> From: Logan Gunthorpe <logang@deltatee.com>
>=20
> Factor out a common raid1_write_error() helper from raid1.c and
> raid10.c.
>=20
> This will help reduce code duplication in subsequent patches.
>=20
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723204206.7693=
0-1-mykola@meshstor.io?part=3D5

