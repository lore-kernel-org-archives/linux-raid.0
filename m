Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6A221D00D;
	Fri, 20 Dec 2024 22:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734735128; cv=none; b=XTF5oqVv0P56f6RflNX3wv2W2zmaKxxbkGduuI+sK61f1hx+6AWBUg8fBXwUiJumvZR8ePNfYoTEq8yiRfaupun7wyGfPPg+kMB2HTSpP05siLXnNHAUpyIKYg5+oDckP5XvM2njc74z4SafY0ugEgNhxzupaw0PR7Zvvl6OIDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734735128; c=relaxed/simple;
	bh=x1geHJyvQYUlT46aSui9lC9h1O8kJQ2tWCiN2ftRs8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kXE3riz5p0gXDuZzKcJTZXG4dAauSGjygISOMt4mGJ4EAgsZwV3/sDwF79YcBh2QrQuwrYxlb5dOVEXKCqNmxNF2p1L07L0+jxgqmcAu+Rc1Qmb9Wxpp1kKx6xKm4b/ahDWH3Ek8GZzAbRgUdRUpVc59qAnFJpIBLrycXkxOo/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CfyihGSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CfyihGSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C934FC4CECD;
	Fri, 20 Dec 2024 22:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734735127;
	bh=x1geHJyvQYUlT46aSui9lC9h1O8kJQ2tWCiN2ftRs8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CfyihGSewCwhcz7Wc7zqoROYOoRhuDUYDgw5oaur+eitWwHOMR6B86/Rb4qtePu9w
	 ibtFKq+K1IGQ9aDgRDXXlUtOoeTv0/ijM00mBrzr2gdXirqwXv7N4aM5B7eMHdbqu8
	 NzNCBXiEO2T5SqYBTbpV7vj8BWVHaPxJyYAhxKhxdeQRQfajj1+854cydZidF0YAh/
	 1Q9nuX+EaM/pTv/2TR9bfc9Sbw4OwioGGu6oWaptQCsZkjWQzijTMavGI/p0I1mEcm
	 ugF+icYp1iWlcyMAxlo3nZurHBC4/XA2u+vvXAj+BUmJx3FgxOdtxpkVN4Y2BbVv0E
	 mx6EyLIpCkMUA==
Date: Fri, 20 Dec 2024 22:52:03 +0000
From: Conor Dooley <conor@kernel.org>
To: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
Cc: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>, linux-riscv@lists.infradead.org,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: Re: [RFC PATCH] raid6: Add RISC-V SIMD syndrome and recovery
 calculations
Message-ID: <20241220-chaste-mundane-5514462147b6@spud>
References: <20241220114023.667347-1-zhangchunyan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="grfA220Fqa9N1N7V"
Content-Disposition: inline
In-Reply-To: <20241220114023.667347-1-zhangchunyan@iscas.ac.cn>


--grfA220Fqa9N1N7V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 20, 2024 at 07:40:23PM +0800, Chunyan Zhang wrote:
> The assembly is originally based on the ARM NEON and int.uc, but uses
> RISC-V vector instructions to implement the RAID6 syndrome and
> recovery calculations.
>=20
> The functions are tested on QEMU.
>=20
> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> ---
>  include/linux/raid/pq.h |   4 +
>  lib/raid6/Makefile      |   3 +
>  lib/raid6/algos.c       |   8 +
>  lib/raid6/recov_rvv.c   | 229 +++++++++++++
>  lib/raid6/rvv.c         | 715 ++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 959 insertions(+)
>  create mode 100644 lib/raid6/recov_rvv.c
>  create mode 100644 lib/raid6/rvv.c
>=20
> diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
> index 98030accf641..4c21f06c662a 100644
> --- a/include/linux/raid/pq.h
> +++ b/include/linux/raid/pq.h
> @@ -108,6 +108,9 @@ extern const struct raid6_calls raid6_vpermxor4;
>  extern const struct raid6_calls raid6_vpermxor8;
>  extern const struct raid6_calls raid6_lsx;
>  extern const struct raid6_calls raid6_lasx;
> +extern const struct raid6_calls raid6_rvvx1;
> +extern const struct raid6_calls raid6_rvvx2;
> +extern const struct raid6_calls raid6_rvvx4;
> =20
>  struct raid6_recov_calls {
>  	void (*data2)(int, size_t, int, int, void **);
> @@ -125,6 +128,7 @@ extern const struct raid6_recov_calls raid6_recov_s39=
0xc;
>  extern const struct raid6_recov_calls raid6_recov_neon;
>  extern const struct raid6_recov_calls raid6_recov_lsx;
>  extern const struct raid6_recov_calls raid6_recov_lasx;
> +extern const struct raid6_recov_calls raid6_recov_rvv;
> =20
>  extern const struct raid6_calls raid6_neonx1;
>  extern const struct raid6_calls raid6_neonx2;
> diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
> index 29127dd05d63..e62fb7cd773e 100644
> --- a/lib/raid6/Makefile
> +++ b/lib/raid6/Makefile
> @@ -10,6 +10,9 @@ raid6_pq-$(CONFIG_ALTIVEC) +=3D altivec1.o altivec2.o a=
ltivec4.o altivec8.o \
>  raid6_pq-$(CONFIG_KERNEL_MODE_NEON) +=3D neon.o neon1.o neon2.o neon4.o =
neon8.o recov_neon.o recov_neon_inner.o
>  raid6_pq-$(CONFIG_S390) +=3D s390vx8.o recov_s390xc.o
>  raid6_pq-$(CONFIG_LOONGARCH) +=3D loongarch_simd.o recov_loongarch_simd.o
> +raid6_pq-$(CONFIG_RISCV_ISA_V) +=3D rvv.o recov_rvv.o
> +CFLAGS_rvv.o +=3D -march=3Drv64gcv
> +CFLAGS_recov_rvv.o +=3D -march=3Drv64gcv

I'm curious - why do you need this when you're using .option arch,+v
below?

>  hostprogs	+=3D mktables
> =20
> diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
> index cd2e88ee1f14..0a388a605131 100644
> --- a/lib/raid6/algos.c
> +++ b/lib/raid6/algos.c
> @@ -80,6 +80,11 @@ const struct raid6_calls * const raid6_algos[] =3D {
>  #ifdef CONFIG_CPU_HAS_LSX
>  	&raid6_lsx,
>  #endif
> +#endif
> +#ifdef CONFIG_RISCV_ISA_V
> +	&raid6_rvvx1,
> +	&raid6_rvvx2,
> +	&raid6_rvvx4,
>  #endif
>  	&raid6_intx8,
>  	&raid6_intx4,
> @@ -115,6 +120,9 @@ const struct raid6_recov_calls *const raid6_recov_alg=
os[] =3D {
>  #ifdef CONFIG_CPU_HAS_LSX
>  	&raid6_recov_lsx,
>  #endif
> +#endif
> +#ifdef CONFIG_RISCV_ISA_V
> +	&raid6_recov_rvv,
>  #endif
>  	&raid6_recov_intx1,
>  	NULL
> diff --git a/lib/raid6/recov_rvv.c b/lib/raid6/recov_rvv.c
> new file mode 100644
> index 000000000000..8ae74803ea7f
> --- /dev/null
> +++ b/lib/raid6/recov_rvv.c
> @@ -0,0 +1,229 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright 2024 Institute of Software, CAS.
> + * Author: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> + */
> +
> +#include <asm/simd.h>
> +#include <asm/vector.h>
> +#include <crypto/internal/simd.h>
> +#include <linux/raid/pq.h>
> +
> +static void __raid6_2data_recov_rvv(int bytes, u8 *p, u8 *q, u8 *dp,
> +			      u8 *dq, const u8 *pbmul,
> +			      const u8 *qmul)
> +{
> +	asm volatile (
> +		".option	push\n"
> +		".option	arch,+v\n"

--grfA220Fqa9N1N7V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZ2X1EwAKCRB4tDGHoIJi
0mXZAQDfjM9V3rIhJVGhXkMjfFty2/1Wrdhq04Nw9AUbBmnhpwEAvLQDtV3Oza7Q
Jpt6rzwTK9vccV2D0feN9rrSOlDxQwM=
=4fKU
-----END PGP SIGNATURE-----

--grfA220Fqa9N1N7V--
