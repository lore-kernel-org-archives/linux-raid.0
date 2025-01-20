Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C065363D;
	Mon, 20 Jan 2025 03:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737344074; cv=none; b=MjOlHl5uMfi9EwFX975Zf2tpkl446iWHmKmk/ljKjODNeYHL09Pxw56ZruDu4Y+zyopkphCj1v0IaC479FeSD2uYtZh6aIsqg0BBR3eMd9po6l45apXlC30cJNk6mwZD52DgpF4cHObTuZIUo46A7al+NrbTADE4iTgtuSidBt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737344074; c=relaxed/simple;
	bh=k6yOoH9TnM0etpljN9F/e0Sno7tGl1MjI7lVxTze52E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f/wP/ybSsvwiIrTpYsxMuzve2dbSzBmgIphtjG7a4t+K7Fslylym9sjIR948Sy7Z/palySLbgujULSOKwHVs8KR3YkDgovtN6CmGN7AaEUv3HWXKvrYg0eXhrlSETUBtc4bjSVcfaj0OreHHINl5b6tf5ayf514ACHDKioXigLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nRzio/jn; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nRzio/jn"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-71e15d9629bso1185915a34.1;
        Sun, 19 Jan 2025 19:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737344071; x=1737948871; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yowUNjsdA9gBoPlsgyEjR6zfOcRIuPlXBAyusT/Sjug=;
        b=nRzio/jnzFH/J/1qrTvFRdFqqFGFe005Tt3dMaHRtq/eI0MNv+mnW9FBbBXdW3L7EO
         IZpMN8OH8hmjh768OLmCq/oownnwBlIWq12yxAawe13JOUKpxxk+F2h5dS0f6cZ9TEd/
         tlYOoXzgiJ5AdJVXTrYRrMwjn4DOZSnfkzXWavI8/OYXFCZlUDpnJf+Gj4oeyBh5Fa5F
         VjgIdpaySQbmZq3VtA/QYfKTuUu8gUzRgdod3wrPZNiAJOx0QQNlL0Q+SYYPddUweb9Z
         xA/CvYmbmB2o09L3TktzAQ4LTWYRC9HQFfXW3ShMOmfKR/ruV3MQ5Dqjp1SB9dByVtV5
         BXsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737344071; x=1737948871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yowUNjsdA9gBoPlsgyEjR6zfOcRIuPlXBAyusT/Sjug=;
        b=V6XXRsohPfNU7hp1dK65/wXR2bg2KSnO/4taHHu2hpmHFDFb/dUV+Ec8Y70EJm1saG
         sukwT0pmR0CqgqYkpYxQeu/kkcy/VbUiY+qPllWdGud/1gFxfxmuWJdOL0JeQkE6cw/f
         xe+XPwjpyQRC9VFw9SA2eJAZOCoWWqTrq4zmoFfJUa3GKPUspRUZ9uYf1eiKTogH8GNA
         K/NwohtxmvdGgBgxd1vizIUD0px/wDIkkBtgr/ClyE0SxECeXjMGgP1qurBs/U1Vy8dP
         TVyp1zmhaAtVY7ZIErKX7bmrtYjXtoutF1WhcCC974ul56maqvUgvV0g0673s1D+/tLJ
         37IA==
X-Forwarded-Encrypted: i=1; AJvYcCUibkYrlQrInj9t3H/db12SiSYcymJSF3dGQyKUk6jxoI8a3bLzVERubYT0c9kSScV2ooN5g/fnyfsPd3w=@vger.kernel.org, AJvYcCWmQnqKjX4oO2tpY8CYYIQH6+odHS866+6mRglrU2WgjAQuxUZ1dF8ltQkc+VGTJUltbxs0hzzv2eltJg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwkNcm5KEHfZ0Ae8Z8fiYP6EJliIi4vfitYYoIr75tRX/VdXME0
	E4vM9z2lPwYQQV0mEa8mBQvrudT8mQ4VZrUTa1MRt6wOuADYPXhEHFJZeBKYUc38IhKKvqiAAUc
	yeMYDp0vt6Z1Bx9heVKE4NcpCRsI=
X-Gm-Gg: ASbGncuNM+3PrHnZk8FcaRAnK7mCKmS8w80eJ/tHkgI1ioWDlS3mia+htHevVBaVisy
	5vV0yuKA1d8jkObnkk9cgpPsf1Qj3bz4z0p2lUtYwTs2athnCgJPHaIx5tmEvthwTaVTTNOzhJ4
	p1Fbrg6BY=
X-Google-Smtp-Source: AGHT+IHv/4qc1YiLdolzHnRNj455vRyIdQOXfu6OIcRq3UN0WRYk3qVB0tL1fB0AfIq7JDNJxJpFV+jjHXyOZO0KLGY=
X-Received: by 2002:a05:6870:ae93:b0:29e:362b:2162 with SMTP id
 586e51a60fabf-2b1c0ace53cmr6217986fac.20.1737344070582; Sun, 19 Jan 2025
 19:34:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241220114023.667347-1-zhangchunyan@iscas.ac.cn> <Z38OCF7cMqz6z7p3@ghost>
In-Reply-To: <Z38OCF7cMqz6z7p3@ghost>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Mon, 20 Jan 2025 11:33:52 +0800
X-Gm-Features: AbW1kvaLZzbfqy80nrNqzFib1UN50PgYfzSszfiVcFsD1ufYX1XMtwWWiAu8iW4
Message-ID: <CAAfSe-sJ7Hwc6mdn492FZupdBL9PPBksGO=VACg34W1owY253A@mail.gmail.com>
Subject: Re: [RFC PATCH] raid6: Add RISC-V SIMD syndrome and recovery calculations
To: Charlie Jenkins <charlie@rivosinc.com>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai3@huawei.com>, linux-riscv@lists.infradead.org, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Charlie,

On Thu, 9 Jan 2025 at 07:45, Charlie Jenkins <charlie@rivosinc.com> wrote:
>
> On Fri, Dec 20, 2024 at 07:40:23PM +0800, Chunyan Zhang wrote:
[snip]
> > +static void raid6_2data_recov_rvv(int disks, size_t bytes, int faila,
> > +             int failb, void **ptrs)
> > +{
> > +     u8 *p, *q, *dp, *dq;
> > +     const u8 *pbmul;        /* P multiplier table for B data */
> > +     const u8 *qmul;         /* Q multiplier table (for both) */
> > +
> > +     p =3D (u8 *)ptrs[disks - 2];
> > +     q =3D (u8 *)ptrs[disks - 1];
> > +
> > +     /*
> > +      * Compute syndrome with zero for the missing data pages
> > +      * Use the dead data pages as temporary storage for
> > +      * delta p and delta q
> > +      */
> > +     dp =3D (u8 *)ptrs[faila];
> > +     ptrs[faila] =3D (void *)raid6_empty_zero_page;
> > +     ptrs[disks - 2] =3D dp;
> > +     dq =3D (u8 *)ptrs[failb];
> > +     ptrs[failb] =3D (void *)raid6_empty_zero_page;
> > +     ptrs[disks - 1] =3D dq;
> > +
> > +     raid6_call.gen_syndrome(disks, bytes, ptrs);
> > +
> > +     /* Restore pointer table */
> > +     ptrs[faila]     =3D dp;
> > +     ptrs[failb]     =3D dq;
> > +     ptrs[disks - 2] =3D p;
> > +     ptrs[disks - 1] =3D q;
> > +
> > +     /* Now, pick the proper data tables */
> > +     pbmul =3D raid6_vgfmul[raid6_gfexi[failb-faila]];
> > +     qmul  =3D raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila] ^
> > +                                      raid6_gfexp[failb]]];
> > +
> > +     if (crypto_simd_usable()) {
>
> There should be an alternate recovery mechanism if it's not currently
> usable right? I don't know what case could happen when this function is
> called but crypto_simd_usable() returns false.

crypto_simd_usable() looks like not needed here.
The callers would call preempt_disable() before calling this function.
And I will add .valid callback like you commented below.

>
> > +             kernel_vector_begin();
> > +             __raid6_2data_recov_rvv(bytes, p, q, dp, dq, pbmul, qmul)=
;
> > +             kernel_vector_end();
> > +     }
> > +}
> > +
> > +static void raid6_datap_recov_rvv(int disks, size_t bytes, int faila,
> > +             void **ptrs)
> > +{
> > +     u8 *p, *q, *dq;
> > +     const u8 *qmul;         /* Q multiplier table */
> > +
> > +     p =3D (u8 *)ptrs[disks - 2];
> > +     q =3D (u8 *)ptrs[disks - 1];
> > +
> > +     /*
> > +      * Compute syndrome with zero for the missing data page
> > +      * Use the dead data page as temporary storage for delta q
> > +      */
> > +     dq =3D (u8 *)ptrs[faila];
> > +     ptrs[faila] =3D (void *)raid6_empty_zero_page;
> > +     ptrs[disks - 1] =3D dq;
> > +
> > +     raid6_call.gen_syndrome(disks, bytes, ptrs);
> > +
> > +     /* Restore pointer table */
> > +     ptrs[faila]     =3D dq;
> > +     ptrs[disks - 1] =3D q;
> > +
> > +     /* Now, pick the proper data tables */
> > +     qmul =3D raid6_vgfmul[raid6_gfinv[raid6_gfexp[faila]]];
> > +
> > +     if (crypto_simd_usable()) {
>
> Same here
>
> > +             kernel_vector_begin();
> > +             __raid6_datap_recov_rvv(bytes, p, q, dq, qmul);
> > +             kernel_vector_end();
> > +     }
> > +}
> > +
> > +const struct raid6_recov_calls raid6_recov_rvv =3D {
> > +     .data2          =3D raid6_2data_recov_rvv,
> > +     .datap          =3D raid6_datap_recov_rvv,
> > +     .valid          =3D NULL,
>
> These functions should only be called if vector is enabled, so this
> valid bit should call has_vector(). has_vector() returns a bool and
> valid expects an int so you can wrap it in something like:

Ok, will add.
>
> static int check_vector(void)
> {
>         return has_vector();
> }
>
> Just casting has_vector to int (*)(void) doesn't work, I get:
>
> warning: cast between incompatible function types from =E2=80=98bool (*)(=
void)=E2=80=99 {aka =E2=80=98_Bool (*)(void)=E2=80=99} to =E2=80=98int (*)(=
void)=E2=80=99 [-Wcast-function-type]
>
>
[snip]
> > +#define RAID6_RVV_WRAPPER(_n)                                         =
       \
> > +     static void raid6_rvv ## _n ## _gen_syndrome(int disks,         \
> > +                                     size_t bytes, void **ptrs)      \
> > +     {                                                               \
> > +             void raid6_rvv ## _n  ## _gen_syndrome_real(int,        \
> > +                                             unsigned long, void**); \
> > +             if (crypto_simd_usable()) {                             \
>
> Same note about crypto_simd_usable as above

Ok.

>
> > +                     kernel_vector_begin();                          \
> > +                     raid6_rvv ## _n ## _gen_syndrome_real(disks,    \
> > +                                     (unsigned long)bytes, ptrs);    \
> > +                     kernel_vector_end();                            \
> > +             }                                                       \
> > +     }                                                               \
> > +     static void raid6_rvv ## _n ## _xor_syndrome(int disks,         \
> > +                                     int start, int stop,            \
> > +                                     size_t bytes, void **ptrs)      \
> > +     {                                                               \
> > +             void raid6_rvv ## _n  ## _xor_syndrome_real(int,        \
> > +                             int, int, unsigned long, void**);       \
> > +             if (crypto_simd_usable()) {                             \
>
> ... and here

Ok.

>
> > +                     kernel_vector_begin();                          \
> > +             raid6_rvv ## _n ## _xor_syndrome_real(disks,            \
> > +                     start, stop, (unsigned long)bytes, ptrs);       \
> > +                     kernel_vector_end();                            \
> > +             }                                                       \
> > +     }                                                               \
> > +     struct raid6_calls const raid6_rvvx ## _n =3D {                  =
 \
> > +             raid6_rvv ## _n ## _gen_syndrome,                       \
> > +             raid6_rvv ## _n ## _xor_syndrome,                       \
> > +             NULL,                                                   \
>
> Same note about calling has_vector here.

Yes.

>
> > +             "rvvx" #_n,                                             \
> > +             0                                                       \
> > +     }
> > +
> > +RAID6_RVV_WRAPPER(1);
> > +RAID6_RVV_WRAPPER(2);
> > +RAID6_RVV_WRAPPER(4);
> > --
> > 2.34.1
> >
> >
> > _______________________________________________
> > linux-riscv mailing list
> > linux-riscv@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-riscv
>
> Some interesting results, on QEMU (vlen=3D256) these vectorized versions
> are around 6x faster on my CPU. Vector in QEMU is not optimized so I am
> surprised that there is this much speedup.

Which version of QEMU did you use? What options were used when running QEMU=
?

I want to try on my side, since this test didn't run as fast like your
test result on my QEMU (I'm using v9.0.0, vlen=3D128).

>
> # modprobe raid6_pq
> [   36.238377] raid6: rvvx1    gen()  2668 MB/s
> [   36.306381] raid6: rvvx2    gen()  3097 MB/s
> [   36.374376] raid6: rvvx4    gen()  3366 MB/s
> [   36.442385] raid6: int64x8  gen()   548 MB/s
> [   36.510397] raid6: int64x4  gen()   600 MB/s
> [   36.578388] raid6: int64x2  gen()   585 MB/s
> [   36.646384] raid6: int64x1  gen()   518 MB/s
> [   36.646395] raid6: using algorithm rvvx4 gen() 3366 MB/s
> [   36.714377] raid6: .... xor() 1942 MB/s, rmw enabled
> [   36.714387] raid6: using rvv recovery algorithm
>
> I also ran the raid6tests:
>
> raid6test: complete (2429 tests, 0 failures)
>
> I am not familiar with this algorithm, but since it passed all of the
> test cases and shows a remarkable speedup, this patch seems like a great
> improvement.
>
> As Jessica pointed out, please put the vector pop/push in the same block
> as your vector instructions. While testing this code, I threw together a
> patch for this that you can squash:

Ok, will do.

>
> From 32117c0a5b2bbba7439af37e55631e0e38b63a7c Mon Sep 17 00:00:00 2001
> From: Charlie Jenkins <charlie@rivosinc.com>
> Date: Wed, 8 Jan 2025 14:32:26 -0800
> Subject: [PATCH] Fixup vector options
>
> Signed-off-by: Charlie Jenkins <charlie@rivosinc.com>

Thanks for the test, review and the patch.
Chunyan

> ---
>  lib/raid6/Makefile    |  2 --
>  lib/raid6/recov_rvv.c | 12 ++++---
>  lib/raid6/rvv.c       | 81 ++++++++++++++++++++++++++++++++++++-------
>  3 files changed, 77 insertions(+), 18 deletions(-)
>
> diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
> index e62fb7cd773e..5be0a4e60ab1 100644
> --- a/lib/raid6/Makefile
> +++ b/lib/raid6/Makefile
> @@ -11,8 +11,6 @@ raid6_pq-$(CONFIG_KERNEL_MODE_NEON) +=3D neon.o neon1.o=
 neon2.o neon4.o neon8.o re
>  raid6_pq-$(CONFIG_S390) +=3D s390vx8.o recov_s390xc.o
>  raid6_pq-$(CONFIG_LOONGARCH) +=3D loongarch_simd.o recov_loongarch_simd.=
o
>  raid6_pq-$(CONFIG_RISCV_ISA_V) +=3D rvv.o recov_rvv.o
> -CFLAGS_rvv.o +=3D -march=3Drv64gcv
> -CFLAGS_recov_rvv.o +=3D -march=3Drv64gcv
>
>  hostprogs      +=3D mktables
>
> diff --git a/lib/raid6/recov_rvv.c b/lib/raid6/recov_rvv.c
> index 8ae74803ea7f..02b97d885510 100644
> --- a/lib/raid6/recov_rvv.c
> +++ b/lib/raid6/recov_rvv.c
> @@ -17,6 +17,7 @@ static void __raid6_2data_recov_rvv(int bytes, u8 *p, u=
8 *q, u8 *dp,
>                 ".option        push\n"
>                 ".option        arch,+v\n"
>                 "vsetvli        x0, %[avl], e8, m1, ta, ma\n"
> +               ".option        pop\n"
>                 : :
>                 [avl]"r"(16)
>         );
> @@ -42,6 +43,8 @@ static void __raid6_2data_recov_rvv(int bytes, u8 *p, u=
8 *q, u8 *dp,
>                  * v14:p/qm[vx], v15:p/qm[vy]
>                  */
>                 asm volatile (
> +                       ".option        push\n"
> +                       ".option        arch,+v\n"
>                         "vle8.v         v0, (%[px])\n"
>                         "vle8.v         v1, (%[dp])\n"
>                         "vxor.vv        v0, v0, v1\n"
> @@ -67,6 +70,7 @@ static void __raid6_2data_recov_rvv(int bytes, u8 *p, u=
8 *q, u8 *dp,
>                         "vxor.vv        v1, v3, v0\n" /* v1 =3D db ^ px; =
*/
>                         "vse8.v         v3, (%[dq])\n"
>                         "vse8.v         v1, (%[dp])\n"
> +                       ".option        pop\n"
>                         : :
>                         [px]"r"(p),
>                         [dp]"r"(dp),
> @@ -84,8 +88,6 @@ static void __raid6_2data_recov_rvv(int bytes, u8 *p, u=
8 *q, u8 *dp,
>                 dp +=3D 16;
>                 dq +=3D 16;
>         }
> -
> -       asm volatile (".option pop\n");
>  }
>
>  static void __raid6_datap_recov_rvv(int bytes, uint8_t *p, uint8_t *q, u=
int8_t *dq,
> @@ -95,6 +97,7 @@ static void __raid6_datap_recov_rvv(int bytes, uint8_t =
*p, uint8_t *q, uint8_t *
>                 ".option        push\n"
>                 ".option        arch,+v\n"
>                 "vsetvli        x0, %[avl], e8, m1, ta, ma\n"
> +               ".option        pop\n"
>                 : :
>                 [avl]"r"(16)
>         );
> @@ -113,6 +116,8 @@ static void __raid6_datap_recov_rvv(int bytes, uint8_=
t *p, uint8_t *q, uint8_t *
>                  * v10:m[vx], v11:m[vy]
>                  */
>                 asm volatile (
> +                       ".option        push\n"
> +                       ".option        arch,+v\n"
>                         "vle8.v         v0, (%[vx])\n"
>                         "vle8.v         v2, (%[dq])\n"
>                         "vxor.vv        v0, v0, v2\n"
> @@ -127,6 +132,7 @@ static void __raid6_datap_recov_rvv(int bytes, uint8_=
t *p, uint8_t *q, uint8_t *
>                         "vxor.vv        v1, v0, v1\n"
>                         "vse8.v         v0, (%[dq])\n"
>                         "vse8.v         v1, (%[vy])\n"
> +                       ".option        pop\n"
>                         : :
>                         [vx]"r"(q),
>                         [vy]"r"(p),
> @@ -140,8 +146,6 @@ static void __raid6_datap_recov_rvv(int bytes, uint8_=
t *p, uint8_t *q, uint8_t *
>                 q +=3D 16;
>                 dq +=3D 16;
>         }
> -
> -       asm volatile (".option pop\n");
>  }
>
>
> diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
> index 21f5432506da..81b38dcafeb6 100644
> --- a/lib/raid6/rvv.c
> +++ b/lib/raid6/rvv.c
> @@ -31,14 +31,18 @@ static void raid6_rvv1_gen_syndrome_real(int disks, u=
nsigned long bytes, void **
>                 ".option        push\n"
>                 ".option        arch,+v\n"
>                 "vsetvli        t0, x0, e8, m1, ta, ma\n"
> +               ".option        pop\n"
>         );
>
>          /* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
>         for (d =3D 0 ; d < bytes ; d +=3D NSIZE*1) {
>                 /* wq$$ =3D wp$$ =3D *(unative_t *)&dptr[z0][d+$$*NSIZE];=
 */
>                 asm volatile (
> +                       ".option        push\n"
> +                       ".option        arch,+v\n"
>                         "vle8.v v0, (%[wp0])\n"
>                         "vle8.v v1, (%[wp0])\n"
> +                       ".option        pop\n"
>                         : :
>                         [wp0]"r"(&dptr[z0][d+0*NSIZE])
>                 );
> @@ -54,6 +58,8 @@ static void raid6_rvv1_gen_syndrome_real(int disks, uns=
igned long bytes, void **
>                          * wp$$ ^=3D wd$$;
>                          */
>                         asm volatile (
> +                               ".option        push\n"
> +                               ".option        arch,+v\n"
>                                 "vsra.vi        v2, v1, 7\n"
>                                 "vsll.vi        v3, v1, 1\n"
>                                 "vand.vx        v2, v2, %[x1d]\n"
> @@ -61,6 +67,7 @@ static void raid6_rvv1_gen_syndrome_real(int disks, uns=
igned long bytes, void **
>                                 "vle8.v         v2, (%[wd0])\n"
>                                 "vxor.vv        v1, v3, v2\n"
>                                 "vxor.vv        v0, v0, v2\n"
> +                               ".option        pop\n"
>                                 : :
>                                 [wd0]"r"(&dptr[z][d+0*NSIZE]),
>                                 [x1d]"r"(0x1d)
> @@ -72,15 +79,16 @@ static void raid6_rvv1_gen_syndrome_real(int disks, u=
nsigned long bytes, void **
>                  * *(unative_t *)&q[d+NSIZE*$$] =3D wq$$;
>                  */
>                 asm volatile (
> +                       ".option        push\n"
> +                       ".option        arch,+v\n"
>                         "vse8.v         v0, (%[wp0])\n"
>                         "vse8.v         v1, (%[wq0])\n"
> +                       ".option        pop\n"
>                         : :
>                         [wp0]"r"(&p[d+NSIZE*0]),
>                         [wq0]"r"(&q[d+NSIZE*0])
>                 );
>         }
> -
> -       asm volatile (".option pop\n");
>  }
>
>  static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
> @@ -98,14 +106,18 @@ static void raid6_rvv1_xor_syndrome_real(int disks, =
int start, int stop,
>                 ".option push\n"
>                 ".option arch,+v\n"
>                 "vsetvli        t0, x0, e8, m1, ta, ma\n"
> +               ".option        pop\n"
>         );
>
>         /* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
>         for (d =3D 0 ; d < bytes ; d +=3D NSIZE*1) {
>                 /* wq$$ =3D wp$$ =3D *(unative_t *)&dptr[z0][d+$$*NSIZE];=
 */
>                 asm volatile (
> +                       ".option        push\n"
> +                       ".option        arch,+v\n"
>                         "vle8.v v0, (%[wp0])\n"
>                         "vle8.v v1, (%[wp0])\n"
> +                       ".option        pop\n"
>                         : :
>                         [wp0]"r"(&dptr[z0][d+0*NSIZE])
>                 );
> @@ -122,6 +134,8 @@ static void raid6_rvv1_xor_syndrome_real(int disks, i=
nt start, int stop,
>                          * wp$$ ^=3D wd$$;
>                          */
>                         asm volatile (
> +                               ".option        push\n"
> +                               ".option        arch,+v\n"
>                                 "vsra.vi        v2, v1, 7\n"
>                                 "vsll.vi        v3, v1, 1\n"
>                                 "vand.vx        v2, v2, %[x1d]\n"
> @@ -129,6 +143,7 @@ static void raid6_rvv1_xor_syndrome_real(int disks, i=
nt start, int stop,
>                                 "vle8.v         v2, (%[wd0])\n"
>                                 "vxor.vv        v1, v3, v2\n"
>                                 "vxor.vv        v0, v0, v2\n"
> +                               ".option        pop\n"
>                                 : :
>                                 [wd0]"r"(&dptr[z][d+0*NSIZE]),
>                                 [x1d]"r"(0x1d)
> @@ -144,10 +159,13 @@ static void raid6_rvv1_xor_syndrome_real(int disks,=
 int start, int stop,
>                          * wq$$ =3D w1$$ ^ w2$$;
>                          */
>                         asm volatile (
> +                               ".option        push\n"
> +                               ".option        arch,+v\n"
>                                 "vsra.vi        v2, v1, 7\n"
>                                 "vsll.vi        v3, v1, 1\n"
>                                 "vand.vx        v2, v2, %[x1d]\n"
>                                 "vxor.vv        v1, v3, v2\n"
> +                               ".option        pop\n"
>                                 : :
>                                 [x1d]"r"(0x1d)
>                         );
> @@ -159,19 +177,20 @@ static void raid6_rvv1_xor_syndrome_real(int disks,=
 int start, int stop,
>                  * v0:wp0, v1:wq0, v2:p0, v3:q0
>                  */
>                 asm volatile (
> +                       ".option        push\n"
> +                       ".option        arch,+v\n"
>                         "vle8.v         v2, (%[wp0])\n"
>                         "vle8.v         v3, (%[wq0])\n"
>                         "vxor.vv        v2, v2, v0\n"
>                         "vxor.vv        v3, v3, v1\n"
>                         "vse8.v         v2, (%[wp0])\n"
>                         "vse8.v         v3, (%[wq0])\n"
> +                       ".option        pop\n"
>                         : :
>                         [wp0]"r"(&p[d+NSIZE*0]),
>                         [wq0]"r"(&q[d+NSIZE*0])
>                 );
>         }
> -
> -       asm volatile (".option pop\n");
>  }
>
>  static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes,=
 void **ptrs)
> @@ -188,6 +207,7 @@ static void raid6_rvv2_gen_syndrome_real(int disks, u=
nsigned long bytes, void **
>                 ".option        push\n"
>                 ".option        arch,+v\n"
>                 "vsetvli        t0, x0, e8, m1, ta, ma\n"
> +               ".option        pop\n"
>         );
>
>         /*
> @@ -197,10 +217,13 @@ static void raid6_rvv2_gen_syndrome_real(int disks,=
 unsigned long bytes, void **
>         for (d =3D 0 ; d < bytes ; d +=3D NSIZE*2) {
>                 /* wq$$ =3D wp$$ =3D *(unative_t *)&dptr[z0][d+$$*NSIZE];=
 */
>                 asm volatile (
> +                       ".option        push\n"
> +                       ".option        arch,+v\n"
>                         "vle8.v v0, (%[wp0])\n"
>                         "vle8.v v1, (%[wp0])\n"
>                         "vle8.v v4, (%[wp1])\n"
>                         "vle8.v v5, (%[wp1])\n"
> +                       ".option        pop\n"
>                         : :
>                         [wp0]"r"(&dptr[z0][d+0*NSIZE]),
>                         [wp1]"r"(&dptr[z0][d+1*NSIZE])
> @@ -217,6 +240,8 @@ static void raid6_rvv2_gen_syndrome_real(int disks, u=
nsigned long bytes, void **
>                          * wp$$ ^=3D wd$$;
>                          */
>                         asm volatile (
> +                               ".option        push\n"
> +                               ".option        arch,+v\n"
>                                 "vsra.vi        v2, v1, 7\n"
>                                 "vsll.vi        v3, v1, 1\n"
>                                 "vand.vx        v2, v2, %[x1d]\n"
> @@ -232,6 +257,7 @@ static void raid6_rvv2_gen_syndrome_real(int disks, u=
nsigned long bytes, void **
>                                 "vle8.v         v6, (%[wd1])\n"
>                                 "vxor.vv        v5, v7, v6\n"
>                                 "vxor.vv        v4, v4, v6\n"
> +                               ".option        pop\n"
>                                 : :
>                                 [wd0]"r"(&dptr[z][d+0*NSIZE]),
>                                 [wd1]"r"(&dptr[z][d+1*NSIZE]),
> @@ -244,10 +270,13 @@ static void raid6_rvv2_gen_syndrome_real(int disks,=
 unsigned long bytes, void **
>                  * *(unative_t *)&q[d+NSIZE*$$] =3D wq$$;
>                  */
>                 asm volatile (
> +                       ".option        push\n"
> +                       ".option        arch,+v\n"
>                         "vse8.v         v0, (%[wp0])\n"
>                         "vse8.v         v1, (%[wq0])\n"
>                         "vse8.v         v4, (%[wp1])\n"
>                         "vse8.v         v5, (%[wq1])\n"
> +                       ".option        pop\n"
>                         : :
>                         [wp0]"r"(&p[d+NSIZE*0]),
>                         [wq0]"r"(&q[d+NSIZE*0]),
> @@ -255,8 +284,6 @@ static void raid6_rvv2_gen_syndrome_real(int disks, u=
nsigned long bytes, void **
>                         [wq1]"r"(&q[d+NSIZE*1])
>                 );
>         }
> -
> -       asm volatile (".option pop\n");
>  }
>
>  static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
> @@ -274,6 +301,7 @@ static void raid6_rvv2_xor_syndrome_real(int disks, i=
nt start, int stop,
>                 ".option push\n"
>                 ".option arch,+v\n"
>                 "vsetvli        t0, x0, e8, m1, ta, ma\n"
> +               ".option        pop\n"
>         );
>
>         /*
> @@ -283,10 +311,13 @@ static void raid6_rvv2_xor_syndrome_real(int disks,=
 int start, int stop,
>         for (d =3D 0 ; d < bytes ; d +=3D NSIZE*2) {
>                  /* wq$$ =3D wp$$ =3D *(unative_t *)&dptr[z0][d+$$*NSIZE]=
; */
>                 asm volatile (
> +                       ".option        push\n"
> +                       ".option        arch,+v\n"
>                         "vle8.v v0, (%[wp0])\n"
>                         "vle8.v v1, (%[wp0])\n"
>                         "vle8.v v4, (%[wp1])\n"
>                         "vle8.v v5, (%[wp1])\n"
> +                       ".option        pop\n"
>                         : :
>                         [wp0]"r"(&dptr[z0][d+0*NSIZE]),
>                         [wp1]"r"(&dptr[z0][d+1*NSIZE])
> @@ -304,6 +335,8 @@ static void raid6_rvv2_xor_syndrome_real(int disks, i=
nt start, int stop,
>                          * wp$$ ^=3D wd$$;
>                          */
>                         asm volatile (
> +                               ".option push\n"
> +                               ".option arch,+v\n"
>                                 "vsra.vi        v2, v1, 7\n"
>                                 "vsll.vi        v3, v1, 1\n"
>                                 "vand.vx        v2, v2, %[x1d]\n"
> @@ -319,6 +352,7 @@ static void raid6_rvv2_xor_syndrome_real(int disks, i=
nt start, int stop,
>                                 "vle8.v         v6, (%[wd1])\n"
>                                 "vxor.vv        v5, v7, v6\n"
>                                 "vxor.vv        v4, v4, v6\n"
> +                               ".option        pop\n"
>                                 : :
>                                 [wd0]"r"(&dptr[z][d+0*NSIZE]),
>                                 [wd1]"r"(&dptr[z][d+1*NSIZE]),
> @@ -335,6 +369,8 @@ static void raid6_rvv2_xor_syndrome_real(int disks, i=
nt start, int stop,
>                          * wq$$ =3D w1$$ ^ w2$$;
>                          */
>                         asm volatile (
> +                               ".option push\n"
> +                               ".option arch,+v\n"
>                                 "vsra.vi        v2, v1, 7\n"
>                                 "vsll.vi        v3, v1, 1\n"
>                                 "vand.vx        v2, v2, %[x1d]\n"
> @@ -344,6 +380,7 @@ static void raid6_rvv2_xor_syndrome_real(int disks, i=
nt start, int stop,
>                                 "vsll.vi        v7, v5, 1\n"
>                                 "vand.vx        v6, v6, %[x1d]\n"
>                                 "vxor.vv        v5, v7, v6\n"
> +                               ".option        pop\n"
>                                 : :
>                                 [x1d]"r"(0x1d)
>                         );
> @@ -356,6 +393,8 @@ static void raid6_rvv2_xor_syndrome_real(int disks, i=
nt start, int stop,
>                  * v4:wp1, v5:wq1, v6:p1, v7:q1
>                  */
>                 asm volatile (
> +                       ".option push\n"
> +                       ".option arch,+v\n"
>                         "vle8.v         v2, (%[wp0])\n"
>                         "vle8.v         v3, (%[wq0])\n"
>                         "vxor.vv        v2, v2, v0\n"
> @@ -369,6 +408,7 @@ static void raid6_rvv2_xor_syndrome_real(int disks, i=
nt start, int stop,
>                         "vxor.vv        v7, v7, v5\n"
>                         "vse8.v         v6, (%[wp1])\n"
>                         "vse8.v         v7, (%[wq1])\n"
> +                       ".option        pop\n"
>                         : :
>                         [wp0]"r"(&p[d+NSIZE*0]),
>                         [wq0]"r"(&q[d+NSIZE*0]),
> @@ -376,8 +416,6 @@ static void raid6_rvv2_xor_syndrome_real(int disks, i=
nt start, int stop,
>                         [wq1]"r"(&q[d+NSIZE*1])
>                 );
>         }
> -
> -       asm volatile (".option pop\n");
>  }
>
>  static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes,=
 void **ptrs)
> @@ -394,6 +432,7 @@ static void raid6_rvv4_gen_syndrome_real(int disks, u=
nsigned long bytes, void **
>                 ".option        push\n"
>                 ".option        arch,+v\n"
>                 "vsetvli        t0, x0, e8, m1, ta, ma\n"
> +               ".option        pop\n"
>         );
>
>         /*
> @@ -405,6 +444,8 @@ static void raid6_rvv4_gen_syndrome_real(int disks, u=
nsigned long bytes, void **
>         for (d =3D 0 ; d < bytes ; d +=3D NSIZE*4) {
>                 /* wq$$ =3D wp$$ =3D *(unative_t *)&dptr[z0][d+$$*NSIZE];=
 */
>                 asm volatile (
> +                       ".option push\n"
> +                       ".option arch,+v\n"
>                         "vle8.v v0, (%[wp0])\n"
>                         "vle8.v v1, (%[wp0])\n"
>                         "vle8.v v4, (%[wp1])\n"
> @@ -413,6 +454,7 @@ static void raid6_rvv4_gen_syndrome_real(int disks, u=
nsigned long bytes, void **
>                         "vle8.v v9, (%[wp2])\n"
>                         "vle8.v v12, (%[wp3])\n"
>                         "vle8.v v13, (%[wp3])\n"
> +                       ".option        pop\n"
>                         : :
>                         [wp0]"r"(&dptr[z0][d+0*NSIZE]),
>                         [wp1]"r"(&dptr[z0][d+1*NSIZE]),
> @@ -431,6 +473,8 @@ static void raid6_rvv4_gen_syndrome_real(int disks, u=
nsigned long bytes, void **
>                          * wp$$ ^=3D wd$$;
>                          */
>                         asm volatile (
> +                               ".option push\n"
> +                               ".option arch,+v\n"
>                                 "vsra.vi        v2, v1, 7\n"
>                                 "vsll.vi        v3, v1, 1\n"
>                                 "vand.vx        v2, v2, %[x1d]\n"
> @@ -462,6 +506,7 @@ static void raid6_rvv4_gen_syndrome_real(int disks, u=
nsigned long bytes, void **
>                                 "vle8.v         v14, (%[wd3])\n"
>                                 "vxor.vv        v13, v15, v14\n"
>                                 "vxor.vv        v12, v12, v14\n"
> +                               ".option        pop\n"
>                                 : :
>                                 [wd0]"r"(&dptr[z][d+0*NSIZE]),
>                                 [wd1]"r"(&dptr[z][d+1*NSIZE]),
> @@ -476,6 +521,8 @@ static void raid6_rvv4_gen_syndrome_real(int disks, u=
nsigned long bytes, void **
>                  * *(unative_t *)&q[d+NSIZE*$$] =3D wq$$;
>                  */
>                 asm volatile (
> +                       ".option push\n"
> +                       ".option arch,+v\n"
>                         "vse8.v v0, (%[wp0])\n"
>                         "vse8.v v1, (%[wq0])\n"
>                         "vse8.v v4, (%[wp1])\n"
> @@ -484,6 +531,7 @@ static void raid6_rvv4_gen_syndrome_real(int disks, u=
nsigned long bytes, void **
>                         "vse8.v v9, (%[wq2])\n"
>                         "vse8.v v12, (%[wp3])\n"
>                         "vse8.v v13, (%[wq3])\n"
> +                       ".option        pop\n"
>                         : :
>                         [wp0]"r"(&p[d+NSIZE*0]),
>                         [wq0]"r"(&q[d+NSIZE*0]),
> @@ -495,8 +543,6 @@ static void raid6_rvv4_gen_syndrome_real(int disks, u=
nsigned long bytes, void **
>                         [wq3]"r"(&q[d+NSIZE*3])
>                 );
>         }
> -
> -       asm volatile (".option pop\n");
>  }
>
>  static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> @@ -514,6 +560,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, i=
nt start, int stop,
>                 ".option push\n"
>                 ".option arch,+v\n"
>                 "vsetvli        t0, x0, e8, m1, ta, ma\n"
> +               ".option        pop\n"
>         );
>
>         /*
> @@ -525,6 +572,8 @@ static void raid6_rvv4_xor_syndrome_real(int disks, i=
nt start, int stop,
>         for (d =3D 0 ; d < bytes ; d +=3D NSIZE*4) {
>                  /* wq$$ =3D wp$$ =3D *(unative_t *)&dptr[z0][d+$$*NSIZE]=
; */
>                 asm volatile (
> +                       ".option push\n"
> +                       ".option arch,+v\n"
>                         "vle8.v v0, (%[wp0])\n"
>                         "vle8.v v1, (%[wp0])\n"
>                         "vle8.v v4, (%[wp1])\n"
> @@ -533,6 +582,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, i=
nt start, int stop,
>                         "vle8.v v9, (%[wp2])\n"
>                         "vle8.v v12, (%[wp3])\n"
>                         "vle8.v v13, (%[wp3])\n"
> +                       ".option        pop\n"
>                         : :
>                         [wp0]"r"(&dptr[z0][d+0*NSIZE]),
>                         [wp1]"r"(&dptr[z0][d+1*NSIZE]),
> @@ -552,6 +602,8 @@ static void raid6_rvv4_xor_syndrome_real(int disks, i=
nt start, int stop,
>                          * wp$$ ^=3D wd$$;
>                          */
>                         asm volatile (
> +                               ".option push\n"
> +                               ".option arch,+v\n"
>                                 "vsra.vi        v2, v1, 7\n"
>                                 "vsll.vi        v3, v1, 1\n"
>                                 "vand.vx        v2, v2, %[x1d]\n"
> @@ -583,6 +635,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, i=
nt start, int stop,
>                                 "vle8.v         v14, (%[wd3])\n"
>                                 "vxor.vv        v13, v15, v14\n"
>                                 "vxor.vv        v12, v12, v14\n"
> +                               ".option        pop\n"
>                                 : :
>                                 [wd0]"r"(&dptr[z][d+0*NSIZE]),
>                                 [wd1]"r"(&dptr[z][d+1*NSIZE]),
> @@ -601,6 +654,8 @@ static void raid6_rvv4_xor_syndrome_real(int disks, i=
nt start, int stop,
>                          * wq$$ =3D w1$$ ^ w2$$;
>                          */
>                         asm volatile (
> +                               ".option push\n"
> +                               ".option arch,+v\n"
>                                 "vsra.vi        v2, v1, 7\n"
>                                 "vsll.vi        v3, v1, 1\n"
>                                 "vand.vx        v2, v2, %[x1d]\n"
> @@ -620,6 +675,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, i=
nt start, int stop,
>                                 "vsll.vi        v15, v13, 1\n"
>                                 "vand.vx        v14, v14, %[x1d]\n"
>                                 "vxor.vv        v13, v15, v14\n"
> +                               ".option        pop\n"
>                                 : :
>                                 [x1d]"r"(0x1d)
>                         );
> @@ -634,6 +690,8 @@ static void raid6_rvv4_xor_syndrome_real(int disks, i=
nt start, int stop,
>                  * v12:wp3, v13:wq3, v14:p3, v15:q3
>                  */
>                 asm volatile (
> +                       ".option push\n"
> +                       ".option arch,+v\n"
>                         "vle8.v         v2, (%[wp0])\n"
>                         "vle8.v         v3, (%[wq0])\n"
>                         "vxor.vv        v2, v2, v0\n"
> @@ -661,6 +719,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, i=
nt start, int stop,
>                         "vxor.vv        v15, v15, v13\n"
>                         "vse8.v         v14, (%[wp3])\n"
>                         "vse8.v         v15, (%[wq3])\n"
> +                       ".option        pop\n"
>                         : :
>                         [wp0]"r"(&p[d+NSIZE*0]),
>                         [wq0]"r"(&q[d+NSIZE*0]),
> @@ -672,8 +731,6 @@ static void raid6_rvv4_xor_syndrome_real(int disks, i=
nt start, int stop,
>                         [wq3]"r"(&q[d+NSIZE*3])
>                 );
>         }
> -
> -       asm volatile (".option pop\n");
>  }
>
>  #define RAID6_RVV_WRAPPER(_n)                                          \
> --
> 2.34.1
>
>
> - Charlie
>
