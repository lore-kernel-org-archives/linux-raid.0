Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276EF7E9;
	Mon, 23 Dec 2024 01:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734917700; cv=none; b=BQ+6ecZ5yOOpsojA6jD4KcEa+eR+pHmNK3Op6DA/wg3IXFE8NOJDULHMEhavFMmuTkyvTDsoBKETxrielIyotOADOUldpUN3a8fX23V+y+9du7uemffwS8OlPS+e0n1pJWZrDcK51siaKAIj+VWIw3nEn3oDmdFjxwLjpdyblrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734917700; c=relaxed/simple;
	bh=URB6qCujm49yW3B1VURRqAoRpBET7QkQ5R171zxF6RE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cYNonB84JMjiigtiFYMPxL7+ZL9TavPQP0/zDzbfwL1St1wGl30YCOZ//Fv8pKHbPe6e5RgevE7zZqgmdYk12C+p1rNxck3sYSh/fbHTurTtR23Ju1lNEJGePhUKmmp7KEsYeIg4+PRGzVEiCtvye97vGUv9eKZyLNVSOyLOUZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GMdl7CXr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GMdl7CXr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD913C4CECD;
	Mon, 23 Dec 2024 01:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734917699;
	bh=URB6qCujm49yW3B1VURRqAoRpBET7QkQ5R171zxF6RE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GMdl7CXrHBK7R+2fbCmPAZMGd+BH1vmXG9KRQH61gg0rDRQgh784NFHZQRyhMbtd3
	 ldNcqPHm2Rk7l0v837ppyw7poVYT2GK4ylEPk0eJ/7Rk4EQW7Z1xVUmseFAnBS8Wjp
	 LQ7aBxJzOuC/AS4D7GBj70gzPV9c7vm04HfFpCoy520mcuoQyZa+m8Ed2HLswBHfro
	 nKl4R3nbc/PEkDFfQJcScXqwtg7kaMCg/szvuKqmWqi/Yq3DkODyqi8stdugFCDLbb
	 EOG1n1YTyZd4NxWzXenrK9jy/z1e/2/9SPz8nDYeq73VaDoT82Hx6Bp9hYjxan55hz
	 1X88yctdSsUUg==
Date: Mon, 23 Dec 2024 01:34:55 +0000
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
Message-ID: <20241223-bunch-deceased-33c10c5b3dc4@spud>
References: <20241220114023.667347-1-zhangchunyan@iscas.ac.cn>
 <20241220-chaste-mundane-5514462147b6@spud>
 <CAAfSe-tT7f3to0CPyF-DK09E+NNwN+tRpmuNwtTqbe3=_y3sFg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="KdM69FlWqeJbBi+8"
Content-Disposition: inline
In-Reply-To: <CAAfSe-tT7f3to0CPyF-DK09E+NNwN+tRpmuNwtTqbe3=_y3sFg@mail.gmail.com>


--KdM69FlWqeJbBi+8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 23, 2024 at 09:16:38AM +0800, Chunyan Zhang wrote:
> Hi Conor,
>=20
> On Sat, 21 Dec 2024 at 06:52, Conor Dooley <conor@kernel.org> wrote:
> >
> > On Fri, Dec 20, 2024 at 07:40:23PM +0800, Chunyan Zhang wrote:
> > > The assembly is originally based on the ARM NEON and int.uc, but uses
> > > RISC-V vector instructions to implement the RAID6 syndrome and
> > > recovery calculations.
> > >
> > > The functions are tested on QEMU.
> > >
> > > Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> > > ---
> > >  include/linux/raid/pq.h |   4 +
> > >  lib/raid6/Makefile      |   3 +
> > >  lib/raid6/algos.c       |   8 +
> > >  lib/raid6/recov_rvv.c   | 229 +++++++++++++
> > >  lib/raid6/rvv.c         | 715 ++++++++++++++++++++++++++++++++++++++=
++
> > >  5 files changed, 959 insertions(+)
> > >  create mode 100644 lib/raid6/recov_rvv.c
> > >  create mode 100644 lib/raid6/rvv.c
> > >
> > > diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
> > > index 98030accf641..4c21f06c662a 100644
> > > --- a/include/linux/raid/pq.h
> > > +++ b/include/linux/raid/pq.h
> > > @@ -108,6 +108,9 @@ extern const struct raid6_calls raid6_vpermxor4;
> > >  extern const struct raid6_calls raid6_vpermxor8;
> > >  extern const struct raid6_calls raid6_lsx;
> > >  extern const struct raid6_calls raid6_lasx;
> > > +extern const struct raid6_calls raid6_rvvx1;
> > > +extern const struct raid6_calls raid6_rvvx2;
> > > +extern const struct raid6_calls raid6_rvvx4;
> > >
> > >  struct raid6_recov_calls {
> > >       void (*data2)(int, size_t, int, int, void **);
> > > @@ -125,6 +128,7 @@ extern const struct raid6_recov_calls raid6_recov=
_s390xc;
> > >  extern const struct raid6_recov_calls raid6_recov_neon;
> > >  extern const struct raid6_recov_calls raid6_recov_lsx;
> > >  extern const struct raid6_recov_calls raid6_recov_lasx;
> > > +extern const struct raid6_recov_calls raid6_recov_rvv;
> > >
> > >  extern const struct raid6_calls raid6_neonx1;
> > >  extern const struct raid6_calls raid6_neonx2;
> > > diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
> > > index 29127dd05d63..e62fb7cd773e 100644
> > > --- a/lib/raid6/Makefile
> > > +++ b/lib/raid6/Makefile
> > > @@ -10,6 +10,9 @@ raid6_pq-$(CONFIG_ALTIVEC) +=3D altivec1.o altivec2=
=2Eo altivec4.o altivec8.o \
> > >  raid6_pq-$(CONFIG_KERNEL_MODE_NEON) +=3D neon.o neon1.o neon2.o neon=
4.o neon8.o recov_neon.o recov_neon_inner.o
> > >  raid6_pq-$(CONFIG_S390) +=3D s390vx8.o recov_s390xc.o
> > >  raid6_pq-$(CONFIG_LOONGARCH) +=3D loongarch_simd.o recov_loongarch_s=
imd.o
> > > +raid6_pq-$(CONFIG_RISCV_ISA_V) +=3D rvv.o recov_rvv.o
> > > +CFLAGS_rvv.o +=3D -march=3Drv64gcv
> > > +CFLAGS_recov_rvv.o +=3D -march=3Drv64gcv
> >
> > I'm curious - why do you need this when you're using .option arch,+v
> > below?
>=20
> Compiler would complain the errors like below without this flag:
>=20
> Error: unrecognized opcode `vle8.v v0,(a3)', extension `v' or `zve64x'
> or `zve32x' required

Right, but the reason for using .option arch,+v elsewhere in the kernel
is because we don't want the compiler to generate vector code at all,
and the directive lets the assembler handle the vector instructions. If
I recall correctly, the error you pasted above is from the assembler,
not the compiler. You should be able to just set AFLAGS, given that all
of the vector code you're adding is hand written as far as I can see.

> > >  hostprogs    +=3D mktables
> > >
> > > diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> > > index cd2e88ee1f14..0a388a605131 100644
> > > --- a/lib/raid6/algos.c
> > > +++ b/lib/raid6/algos.c
> > > @@ -80,6 +80,11 @@ const struct raid6_calls * const raid6_algos[] =3D=
 {
> > >  #ifdef CONFIG_CPU_HAS_LSX
> > >       &raid6_lsx,
> > >  #endif
> > > +#endif
> > > +#ifdef CONFIG_RISCV_ISA_V
> > > +     &raid6_rvvx1,
> > > +     &raid6_rvvx2,
> > > +     &raid6_rvvx4,
> > >  #endif
> > >       &raid6_intx8,
> > >       &raid6_intx4,
> > > @@ -115,6 +120,9 @@ const struct raid6_recov_calls *const raid6_recov=
_algos[] =3D {
> > >  #ifdef CONFIG_CPU_HAS_LSX
> > >       &raid6_recov_lsx,
> > >  #endif
> > > +#endif
> > > +#ifdef CONFIG_RISCV_ISA_V
> > > +     &raid6_recov_rvv,
> > >  #endif
> > >       &raid6_recov_intx1,
> > >       NULL
> > > diff --git a/lib/raid6/recov_rvv.c b/lib/raid6/recov_rvv.c
> > > new file mode 100644
> > > index 000000000000..8ae74803ea7f
> > > --- /dev/null
> > > +++ b/lib/raid6/recov_rvv.c
> > > @@ -0,0 +1,229 @@
> > > +// SPDX-License-Identifier: GPL-2.0-only
> > > +/*
> > > + * Copyright 2024 Institute of Software, CAS.
> > > + * Author: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> > > + */
> > > +
> > > +#include <asm/simd.h>
> > > +#include <asm/vector.h>
> > > +#include <crypto/internal/simd.h>
> > > +#include <linux/raid/pq.h>
> > > +
> > > +static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
> > > +                           u8 *dq, const u8 *pbmul,
> > > +                           const u8 *qmul)
> > > +{
> > > +     asm volatile (
> > > +             ".option        push\n"
> > > +             ".option        arch,+v\n"

--KdM69FlWqeJbBi+8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZ2i+PwAKCRB4tDGHoIJi
0mZeAP9uByn/w9kikgdO9NiXQzDZdEKRaktcNcO/xiUXKyH3xgD/fWvHpABqNBx2
1A/h3jK/wiLa/nIpNPl1yemMyuyf6Ag=
=1a26
-----END PGP SIGNATURE-----

--KdM69FlWqeJbBi+8--
