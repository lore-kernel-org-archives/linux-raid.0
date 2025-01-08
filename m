Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DC32594BE;
	Wed,  8 Jan 2025 18:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736362683; cv=none; b=TzxlzYHFfr1R3voNlj1RgQQ365FQWCe++ypXxShOEMEPwhSzj3kvam6gy4N4DdjndQM1SDlOvOSV6kiG3rk+AQzKqMJ+n/cX7L8U0D4MNMxsNdHDPVDDucMPUxuDSCEKUavJviRBE7mMycOM4cfvUh/IVUqHJctxLNH1ECsEiAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736362683; c=relaxed/simple;
	bh=+4THUFAjfCj1EoFB1yrHVFqBlzZR//IKz2CqdRiCC/0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UsTg7XNUEDjvd2MO5Vvn9M+IY01Z+iyfZMS6yfpTsLz22t9zlDtr6VPNFi0LDB5STI7I+fEPTjf3BcREUXY4ElkCjvR6vnizpia8okNJp+AdLIfnYMxdm5Nqx1M/384TL1BeIA0sg8WNpA+Hq834gDrA0hiPipfB5JP74NqAKjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TxLSMpZg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TxLSMpZg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DDB8C4CED3;
	Wed,  8 Jan 2025 18:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736362683;
	bh=+4THUFAjfCj1EoFB1yrHVFqBlzZR//IKz2CqdRiCC/0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TxLSMpZgKhiBvox1qlugsIsfFr9oPcvytxI5JcT+oMvy0EX1NDqMzWImaSAt3UoXa
	 JUmCUigyBDfugMALUGWHREnvnPYJKjIrw2zFw+c1W0e6i0OZ+gjh05GEwzvioOdFuo
	 wkLsV6lNRN4sKMMCgLaM07kqZVi1xbrqPrQYeDXoysF09ohGPkeF9jYSlJMibUDO4G
	 mO2/dnC/DtJoIVS70LkKGqZ5dr4ya+YuSdThdUM60nwLjYX7GrG2mkoYxnTIUFJbk0
	 LamYrJFTb17nPFIbkgzFk7wfNOOqdrlTey662GunRBYJGnEEd/sk7kwO+QxIUWjOF3
	 Yqr/OCN7naH1A==
Date: Wed, 8 Jan 2025 18:57:58 +0000
From: Conor Dooley <conor@kernel.org>
To: Chunyan Zhang <zhang.lyra@gmail.com>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>, linux-riscv@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] raid6: Add RISC-V SIMD syndrome and recovery
 calculations
Message-ID: <20250108-worsening-hacksaw-c1e970f1c4e3@spud>
References: <20241220114023.667347-1-zhangchunyan@iscas.ac.cn>
 <20241220-chaste-mundane-5514462147b6@spud>
 <CAAfSe-tT7f3to0CPyF-DK09E+NNwN+tRpmuNwtTqbe3=_y3sFg@mail.gmail.com>
 <20241223-bunch-deceased-33c10c5b3dc4@spud>
 <CAAfSe-sPBHY_AUCksMj2qxHi2PchWpkV4JH0DzXF56Kvpwm0bg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="EUYL6HV+5k8+gg39"
Content-Disposition: inline
In-Reply-To: <CAAfSe-sPBHY_AUCksMj2qxHi2PchWpkV4JH0DzXF56Kvpwm0bg@mail.gmail.com>


--EUYL6HV+5k8+gg39
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 23, 2024 at 10:16:46AM +0800, Chunyan Zhang wrote:
> On Mon, 23 Dec 2024 at 09:35, Conor Dooley <conor@kernel.org> wrote:
> >
> > On Mon, Dec 23, 2024 at 09:16:38AM +0800, Chunyan Zhang wrote:
> > > Hi Conor,
> > >
> > > On Sat, 21 Dec 2024 at 06:52, Conor Dooley <conor@kernel.org> wrote:
> > > >
> > > > On Fri, Dec 20, 2024 at 07:40:23PM +0800, Chunyan Zhang wrote:
> > > > > The assembly is originally based on the ARM NEON and int.uc, but =
uses
> > > > > RISC-V vector instructions to implement the RAID6 syndrome and
> > > > > recovery calculations.
> > > > >
> > > > > The functions are tested on QEMU.
> > > > >
> > > > > Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> > > > > ---
> > > > >  include/linux/raid/pq.h |   4 +
> > > > >  lib/raid6/Makefile      |   3 +
> > > > >  lib/raid6/algos.c       |   8 +
> > > > >  lib/raid6/recov_rvv.c   | 229 +++++++++++++
> > > > >  lib/raid6/rvv.c         | 715 ++++++++++++++++++++++++++++++++++=
++++++
> > > > >  5 files changed, 959 insertions(+)
> > > > >  create mode 100644 lib/raid6/recov_rvv.c
> > > > >  create mode 100644 lib/raid6/rvv.c
> > > > >
> > > > > diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
> > > > > index 98030accf641..4c21f06c662a 100644
> > > > > --- a/include/linux/raid/pq.h
> > > > > +++ b/include/linux/raid/pq.h
> > > > > @@ -108,6 +108,9 @@ extern const struct raid6_calls raid6_vpermxo=
r4;
> > > > >  extern const struct raid6_calls raid6_vpermxor8;
> > > > >  extern const struct raid6_calls raid6_lsx;
> > > > >  extern const struct raid6_calls raid6_lasx;
> > > > > +extern const struct raid6_calls raid6_rvvx1;
> > > > > +extern const struct raid6_calls raid6_rvvx2;
> > > > > +extern const struct raid6_calls raid6_rvvx4;
> > > > >
> > > > >  struct raid6_recov_calls {
> > > > >       void (*data2)(int, size_t, int, int, void **);
> > > > > @@ -125,6 +128,7 @@ extern const struct raid6_recov_calls raid6_r=
ecov_s390xc;
> > > > >  extern const struct raid6_recov_calls raid6_recov_neon;
> > > > >  extern const struct raid6_recov_calls raid6_recov_lsx;
> > > > >  extern const struct raid6_recov_calls raid6_recov_lasx;
> > > > > +extern const struct raid6_recov_calls raid6_recov_rvv;
> > > > >
> > > > >  extern const struct raid6_calls raid6_neonx1;
> > > > >  extern const struct raid6_calls raid6_neonx2;
> > > > > diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
> > > > > index 29127dd05d63..e62fb7cd773e 100644
> > > > > --- a/lib/raid6/Makefile
> > > > > +++ b/lib/raid6/Makefile
> > > > > @@ -10,6 +10,9 @@ raid6_pq-$(CONFIG_ALTIVEC) +=3D altivec1.o alti=
vec2.o altivec4.o altivec8.o \
> > > > >  raid6_pq-$(CONFIG_KERNEL_MODE_NEON) +=3D neon.o neon1.o neon2.o =
neon4.o neon8.o recov_neon.o recov_neon_inner.o
> > > > >  raid6_pq-$(CONFIG_S390) +=3D s390vx8.o recov_s390xc.o
> > > > >  raid6_pq-$(CONFIG_LOONGARCH) +=3D loongarch_simd.o recov_loongar=
ch_simd.o
> > > > > +raid6_pq-$(CONFIG_RISCV_ISA_V) +=3D rvv.o recov_rvv.o
> > > > > +CFLAGS_rvv.o +=3D -march=3Drv64gcv
> > > > > +CFLAGS_recov_rvv.o +=3D -march=3Drv64gcv
> > > >
> > > > I'm curious - why do you need this when you're using .option arch,+v
> > > > below?
> > >
> > > Compiler would complain the errors like below without this flag:
> > >
> > > Error: unrecognized opcode `vle8.v v0,(a3)', extension `v' or `zve64x'
> > > or `zve32x' required
> >
> > Right, but the reason for using .option arch,+v elsewhere in the kernel
> > is because we don't want the compiler to generate vector code at all,
> > and the directive lets the assembler handle the vector instructions. If
> > I recall correctly, the error you pasted above is from the assembler,
>=20
> Yes, it is from the assembler.
>=20
> > not the compiler. You should be able to just set AFLAGS, given that all
>=20
> It complains the same errors after simply replacing CFLAGS with AFLAGS
> here. What am I missing?
>=20

I don't know what you're missing unfortunately, sorry.

--EUYL6HV+5k8+gg39
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZ37KtgAKCRB4tDGHoIJi
0lz4AP9WW3T+gpJIBriewt2vHd4nKo1ARYA09e0XbDmFGgY9KwD+JC0wE7oCVRn2
7nRTXAzIjGI0ASXSINoFY9mWAz4yJwQ=
=h75i
-----END PGP SIGNATURE-----

--EUYL6HV+5k8+gg39--
