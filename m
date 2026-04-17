Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDE42D73A6;
	Fri, 17 Apr 2026 15:36:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776440210; cv=none; b=KpKyZ6Rf3MFymyF1te0mb6ZorQpt2DYaR3KwI7m7PhOmN9Qgap/GnG83ZyCFd1jf+ebN6xkJdBiVeU4IURN76axtCJhnm/63WSZiNXXHapuGgHouhCUv++5sf4rw36nAITccrMiwfbdc5muR+y1CZNSq3RiFfsmCOb+AFhrD4VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776440210; c=relaxed/simple;
	bh=FcCWGPrk9R7P1cPiUZKS/mKU1dNaQ59sANhzcCbnuFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b1VpoTZMv06C3DjizpxOJf3sl9qizpV6XYUkE1zVVI9JvIrwWipmZScxNxwhVd7kDl5rTuxmVmM2/OmRKLlowog++TsRxTr2yKYxwzzgI9LvsbJexC2vaVqVVtKbw2PxdTTbw/S19mmurPDeETsSqjo1iiTUgK4YYyGBhLHCxD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cl9GvVzW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cl9GvVzW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57671C19425;
	Fri, 17 Apr 2026 15:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776440209;
	bh=FcCWGPrk9R7P1cPiUZKS/mKU1dNaQ59sANhzcCbnuFQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cl9GvVzWvXXyBspphHKbtR9Jla4/6r+9qD3boEHEa7N7GXm/jzvQmjv0+2ElM1oSf
	 7ft4o+c6anFmHwLaXK9JHIpy/gmSHbb+z3dznRq+xAuxRN7PScBO4ACYvafevJ3SIk
	 VGrF39ngUkh6sgG6wOIB/xdbgGhh5ev/NbXACAIm1m+Whw1jm9VVyfDnYl8d0j61t3
	 x9J7GSDxdn73gJjWUCahrQv+LCzB2VkPy4L8lkD0akswdkqFm9XWC/z97jIXLQOhV8
	 5rpt5afyRv5C1EmwCW+vhtP216j6AcfWHfMAQQ8Jv2x9Mfb3EJ/HoyPZS7MtSscd9x
	 28GPeqfhvnw4g==
Date: Fri, 17 Apr 2026 16:36:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Demian Shulhan <demyansh@gmail.com>, Christoph Hellwig <hch@lst.de>,
	Mark Rutland <mark.rutland@arm.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org, Li Nan <linan122@huawei.com>,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] raid6: arm64: add SVE optimized implementation for
 syndrome generation
Message-ID: <2c2eb793-c0a4-4b65-93f1-0ece5cf820d7@sirena.org.uk>
References: <acJhCCPfVxjFUZ5R@J2N7QTR9R3>
 <CAOLeWCsxhzdxQviizJ4X4VOp_28LCtO-RjWoCcZG29rQw86NVg@mail.gmail.com>
 <9a12e043-8200-4650-bfe2-cbece57a4f87@app.fastmail.com>
 <20260331063659.GA2061@lst.de>
 <CAOLeWCtnZz=kHGk4C2f9Mbfi3tEBE100iCkMBhcG47dmR9eDWw@mail.gmail.com>
 <CAOLeWCtxPk7q_bVvrcKaipSKr+_=57Auobcj0cFRvXxXMdH58g@mail.gmail.com>
 <5158e4e0-3275-4c29-a8fc-2dfabc13a69d@app.fastmail.com>
 <CAOLeWCtf2rZyPeJH-LuZ2A+c7mC9M2r-Ya0VjyOJFpun3TFMnw@mail.gmail.com>
 <8db4defe-8b5e-4cc3-880b-72d46510b034@arm.com>
 <c9362db6-1fef-4e70-9525-29b2936f4887@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="h+PLrOwUQ0SPNQK2"
Content-Disposition: inline
In-Reply-To: <c9362db6-1fef-4e70-9525-29b2936f4887@app.fastmail.com>
X-Cookie: Uh-oh!!  I'm having TOO MUCH FUN!!


--h+PLrOwUQ0SPNQK2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 17, 2026 at 04:43:06PM +0200, Ard Biesheuvel wrote:

> On arm64, kernel mode NEON is mostly used to gain access to AES and SHA
> instructions, and only to a lesser degree to speed up ordinary
> arithmetic, and so XOR is somewhat of an outlier here.

> Given that Neoverse V1 apparently already carves up ordinary arithmetic
> performed on 256-bit vectors and operates on 128 bits at a time, I am
> rather skeptical that we're likely to see any SVE implementations of the
> crypto extensions soon that are meaningfully faster, given that these
> are presumably much costlier to implement in terms of gate count, and
> therefore likely to be split up even on SVE implementations that can
> perform ordinary arithmetic on 256+ bit vectors in a single cycle. Note
> that even the arm64 SIMD accelerated CRC implementations rely heavily on
> 64x64->128 polynomial multiplication.

I'd not be surprised to see something that delivers useful benefits
using SVE at some point.

> IOW, before we consider kernel mode SVE, I'd like to see some benchmarks
> for other algorithms too.

Definitely, it needs a solid win to merge anything.  I do want to get
back to the situation where we've got out of tree infrastructure patches
so that people working on algorithms have something to base their work
on (and see the overheads using SVE incurs) but unless theres's a
practical user they should stay out of tree.

--h+PLrOwUQ0SPNQK2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmniU4sACgkQJNaLcl1U
h9B/2Af/TY2x6C29q51viQsIQR8AqsXh0E7IX7IOqJXFpXWDc29gFjdyz/b+ScmF
hJBLBAq0+VL99Fqm2/uwLs0yvgU6xhfzSqLy7Y/eZ8BAFMthU+BAyt2FwXYcFv7b
lWjyhddMsXJG341/X4k8WsqQ6R8O89UAyZ3apu9rAPZAPXJgkFxXQmypikpEqU+M
5FIbf7mTZZicf9/uWcbK8qayKuUIc/NAtET3IZidHsLkQPalICs2Zv5ae6DWZ1dk
ELeHqZCLdrKq+KaoH4kXqomFfway1oEFOYQqHsdrcL1tHB7EvP6Y7ISsa/0LTL0q
AUuF65vn4L4sYBXPoYdpOg2asYgTvA==
=Z3VX
-----END PGP SIGNATURE-----

--h+PLrOwUQ0SPNQK2--
