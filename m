Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEE53B2FC6
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 14:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782136979; cv=none; b=MUDmhJUDgrjUsxCKheFabos8gMSkhxqro/6ZVr5CCFxiahSpXP3LMKhg+MZq7zED6GZMrNqfLexVTA4bvne1QbSsd2dUYtnSyFG+Vln3QfpqXMOkBUlIowz5Q3Kx9QjSV1CCwrCB7NnbJYeS06JoqIq52Eam/Z7odeKaYLdyG0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782136979; c=relaxed/simple;
	bh=wwBxear/sfAe4FH9n66Y3I5iJZoW4KFOjHsNKnHI0go=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NKf7an2z6VBhJyA4IcotLcRRA5BNprI4RO3LMR2C9uZaYiPShEXekcT1tVgBg4FPcjIMGlgmVJzzX7sw0bokN5OC1gKmPDlcq5knIhkHB8Ym9a+5d1Lpa7HLs3lKn4yE1v4bC84/ibNxA3lMJIm82G3Fmk7eh8iKJ7koCsmHCvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g/FrPKhd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g/FrPKhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF4781F000E9;
	Mon, 22 Jun 2026 14:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782136978;
	bh=8vkaGexevGE87CWT6cnb4GcDnw8NuhDUGWOo9HNe9aI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=g/FrPKhdGzQ2M8U6+kAOa+FBVOzVb6YQA3lnC/3rEcNo/2vCC4ww9jGPWIxaevqTm
	 J0NjllPCteXRnrtdFzO2WmeYbrKtAc7YY+Zk7fMqJm260d4EFZ+ImgZyzpwJYrCScb
	 PfQPMfIrieYGIxL7xKUI/t2G937z9sd4Fm47Lu0EP7wXMrkZqMSNZR6kHi7b3cfpuP
	 8ZxYNLiA0GjB7p7m6h4wNWaTlNyhUL7QHecFkTB4xsrjWgWLcmnTH17pRs+bpFPdcX
	 MIYwmdDaIPXUipnt+jHAEfUPPIbGaNOHsYfcqvnguOuFSOZK7ySMm3i3e1a9LrqlbL
	 djIcbvqDU3uFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] raid6: fix riscv symbol undeclared warnigns
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ben Dooks" <ben.dooks@codethink.co.uk>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260622135207.480540-1-ben.dooks@codethink.co.uk>
References: <20260622135207.480540-1-ben.dooks@codethink.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 22 Jun 2026 14:02:57 +0000
Message-Id: <20260622140257.CF4781F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Including `pq_arch.h` in `rvv.c` misuses an initialization fragment=
 as a header, creating a brittle include dependency and violating architect=
ural boundaries.
--

commit 0d7480a95df3baf577ec13b2b5aec7d36d11ee3f
Author: Ben Dooks <ben.dooks@codethink.co.uk>

raid6: fix riscv symbol undeclared warnigns

This commit attempts to resolve sparse warnings about undeclared raid6_rvvx
symbols in the RISC-V RAID6 implementation by including pq_arch.h in rvv.c.

> raid6: fix riscv symbol undeclared warnigns

This isn't a bug, but there's a typo (warnigns) in the subject line.

> diff --git a/lib/raid/raid6/riscv/rvv.c b/lib/raid/raid6/riscv/rvv.c
> index 75c9dafedb284..4ac50606f3dc1 100644
> --- a/lib/raid/raid6/riscv/rvv.c
> +++ b/lib/raid/raid6/riscv/rvv.c
> @@ -10,6 +10,7 @@
>   */
> =20
>  #include "rvv.h"
> +#include "pq_arch.h"

[Severity: Low]
Is it appropriate to include pq_arch.h here to fix the sparse warnings?

The pq_arch.h file appears to be designed as an initialization fragment mea=
nt
to be conditionally included by the generic algos.c, since it contains the
arch_raid6_init() static inline function. Including it here inappropriately
injects unused initialization functions into the backend implementation.

Does this also create a brittle include order dependency? The pq_arch.h file
uses functions like raid6_algo_add_default and raid6_algo_add but does not
include algos.h where they are declared. The build only succeeds because rv=
v.c
happens to include rvv.h (which includes algos.h) immediately before pq_arc=
h.h.
Any reordering of these includes could break the build.

Would it be safer to place the extern declarations for these symbols in a
shared internal header like rvv.h?

> =20
>  #ifdef __riscv_vector
>  #error "This code must be built without compiler support for vector"

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260622135207.4805=
40-1-ben.dooks@codethink.co.uk?part=3D1
