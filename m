Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7319F279DCC;
	Thu, 16 Apr 2026 16:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776358075; cv=none; b=mh5FTtK/d4Zbf70xvz2ERbypn/OnNvMqoV8SBdb6Pamgt2HDqpK6pP7xVPo5CbnBVg3/en1jSEQY3hULJlEhsknQKrht7QOPwLIbXKdC5kYhlg7vSVysZDiJ1fqFTcNT/UakRzXniWLCeMIi+9tGo2WKEkGrfuLzxeGcgva2J34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776358075; c=relaxed/simple;
	bh=azLf1jjvVZCDjMDcCYo2UoiktVd0HigQaP/VVbjL8aY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oiAhEa5WrDni966+B94OmgAR2CbINEnWJSCl5YpCK1NJnlj7dRqKhq+qV0ywGNrXs6Gv3Dex5jzgDobCmmp46lJ7ae552Efq4e/YE2i4Momdylpd7jzmyWzf7Uy7bdmSPWBg3Tdnl7c30zfmgQrLrVvxepI1TLk9NI8Gv9hXb9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q0k0dF+7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q0k0dF+7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B35C2BCAF;
	Thu, 16 Apr 2026 16:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776358075;
	bh=azLf1jjvVZCDjMDcCYo2UoiktVd0HigQaP/VVbjL8aY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q0k0dF+7MRawEKljfyRvFly0XbnirNtW/luj4NP3M1ywvzu+avuee09+Z1hQ1ZSZH
	 Igx6vj8foYSmKJ2lqvdZfLfnW9yoyPzhYVIL/cjCmSpEABc0+oAurUskM+UVLHg2Z3
	 4QN02EGV5X7bdBZ8tON1rA4ghZILI5nLKqpK99IxKzaD0Y5Ws/JRSwO34WwnL080hr
	 o33byAF4WQEbQGQVJJ36VJ/2feUrw/XjdjA7CyWdW/jBVpBJ2SjdlLkZO+Q1MmddQM
	 B+dtofo4A9Hg6EMESLlWHeWuqiZlJjwTRdZrGYDmTiz8i0SEvDZ5ip/1tRuU+fUEmm
	 cv1zrbEvdHQWg==
Date: Thu, 16 Apr 2026 17:47:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Demian Shulhan <demyansh@gmail.com>, Ard Biesheuvel <ardb@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Mark Rutland <mark.rutland@arm.com>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, Li Nan <linan122@huawei.com>,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] raid6: arm64: add SVE optimized implementation for
 syndrome generation
Message-ID: <acc15515-4c43-402c-9800-c9b5e3da9891@sirena.org.uk>
References: <f9bc0534-4b7a-4b14-974b-4d7811ccd899@app.fastmail.com>
 <acJhCCPfVxjFUZ5R@J2N7QTR9R3>
 <CAOLeWCsxhzdxQviizJ4X4VOp_28LCtO-RjWoCcZG29rQw86NVg@mail.gmail.com>
 <9a12e043-8200-4650-bfe2-cbece57a4f87@app.fastmail.com>
 <20260331063659.GA2061@lst.de>
 <CAOLeWCtnZz=kHGk4C2f9Mbfi3tEBE100iCkMBhcG47dmR9eDWw@mail.gmail.com>
 <CAOLeWCtxPk7q_bVvrcKaipSKr+_=57Auobcj0cFRvXxXMdH58g@mail.gmail.com>
 <5158e4e0-3275-4c29-a8fc-2dfabc13a69d@app.fastmail.com>
 <CAOLeWCtf2rZyPeJH-LuZ2A+c7mC9M2r-Ya0VjyOJFpun3TFMnw@mail.gmail.com>
 <8db4defe-8b5e-4cc3-880b-72d46510b034@arm.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="JOYyU/fvxy0ErnXa"
Content-Disposition: inline
In-Reply-To: <8db4defe-8b5e-4cc3-880b-72d46510b034@arm.com>
X-Cookie: Process promptly.


--JOYyU/fvxy0ErnXa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 16, 2026 at 05:26:08PM +0100, Robin Murphy wrote:

> Unless you've got a CPU with truly big wide vector units that _can't_ be
> fully utilised by ASMID ops, then SVE is only really offering whatever
> incidental benefits fall out of smaller code size. However, if you do have
> those wider vectors, then the cost of correctly saving/restoring the SVE
> state - of which a userspace benchmark isn't likely to be very
> representative - is also going to scale up significantly.

The other case will be when there's some SVE only extension that
accelerates something that's relevant for the algorithm.  That's not
really a thing at present but I imagine that we'll run into that at some
point.

--JOYyU/fvxy0ErnXa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmnhErQACgkQJNaLcl1U
h9BKKgf/eJp0wWu49gmu4M9de/lTRZUet1gGlzyUoJAzvATBfXECQC0f1VLvsw98
13g+QN+RZj9mnDqVXn0p/00v9HlZIAnBv3ZNJRc1kTPe6Vt5FfKmkSgRO6FJFq00
fnYyh3V52OvDzIBakSYa6e6OOkLstfLotmjS3uxaxbcKNu40DE/jHLSbfXtp+G4a
RyJUtwSNu6+CGwVXZF4wbtxuUzNZGl92amfglEYxaAr2ACx/2OaX4eN93HELX1Ng
xZpkvLpXmw3xfm7V1tFEiMfUBukTzZrd4u0hunBKiTmnfbSEJV9AES/qVMdky8sS
JiqPGtz55Nh0Qvlx5X7hWk7hFD8Vcw==
=XqGr
-----END PGP SIGNATURE-----

--JOYyU/fvxy0ErnXa--
