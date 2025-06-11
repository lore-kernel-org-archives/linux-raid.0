Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D0DF3C1F;
	Wed, 11 Jun 2025 03:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749611061; cv=none; b=XgIimlofrZCyOsvPBnWronA0JiJsShhUVZEcLkhw2LQTmZ4iSkp0lqgfS7jDWG/8kpLJ6ygoVlBbeGQNIwpLEefK7QGt4SZhivWzxwqcy5cTFg87zHHiGncKPl/VN/F/tLrCISyDe6jqSZqWMJDdMFvGJXhKebkQgIs898K3lZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749611061; c=relaxed/simple;
	bh=OiBW/95ypMs1jzpRs5nVKszxpviCLaYsv96TgaCWrHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c68ZNj5y6cvff916vAnWchs+14HJHyrYVkJSsC9YjigFkOdZUq4RBEEW1LNLjeiROyOSQCe2Zb/p0verIVPUXuS9snfn14pq4e8vAdkLUYiZQRwJOsY4S1NcQxh0+yiAXLrdeORskiJHeFG34vAGAb9rn4HySHcS2jswQDm6rqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c/M6RnA7; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c/M6RnA7"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-2ea34731c5dso1879128fac.0;
        Tue, 10 Jun 2025 20:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749611056; x=1750215856; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h0vMZ6RS4KZgXTPFZZwfCCY/cIIcHwyiQtEt00FbCAs=;
        b=c/M6RnA7c3EquR01jmYSQus9bbZ3mh0jH0FZXoBX/bh+aG21J/Ne7syaIPSyfPKXR6
         B7PocccodiaF0w0bdfxwu46uOTJn/dJUG6hBh5B3L0lLDVo0wzCbKE13B3jbBhuqHE1P
         j4j7c54151oUDOhCZG39Sx7SbKWSvQES1WLe37FBLORCRHXQ6CUStgP1YS0U+y1/u9d5
         cd/4JZXhxIPOkTmcGjvtVDSNZBbqbIirOseeTnXgFaG/UD19QRl1kK3RgqWAlYLqUHRK
         qje5Wr0dK69CNNnpSpZJ+SzA4I6MbcQJG0iZ0g7h3kvJc9uLzVSR0MH0CKHfNhAxTVFU
         6GlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749611056; x=1750215856;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h0vMZ6RS4KZgXTPFZZwfCCY/cIIcHwyiQtEt00FbCAs=;
        b=domM3xG7kRNEPp8cTFBWz9KF+3fyvlNpdBOwTB7NdMFj5cJHtci6fdkmSQeE1W4wSa
         FNtuYsmYm6xsdm+usjyvQC3tSQ/1YxEd7Z1bpoRb+gVkdMjSf4tafV4rL8oaNMYrJn/3
         WFW6zPMo59xb8ZLIKd0PiPOPoL7YtUohXQ4Lh47V+EX4SLijrshca6V+xf9TN4zjEHcM
         qcWPL7R8TshF9GyJmlweRmC/Ek2rcC8diLLHGnpAaa3y7PCN/2EiX6E+ITCP1pRVIB78
         8cPPSRIJebbBwYxf30CEmZEAfYbmd3mlPN6Kg+nw0C9pwHKJ0PO8gtjQOJySwwrnxXHF
         6Sag==
X-Forwarded-Encrypted: i=1; AJvYcCUNQxC5pv61ENdFNC25g+uf9knR4oJlHBcpgBWEaiFGN2rzO3XHb9up2/DkwYcODSUCfsxg/Es8CR5uE6Q=@vger.kernel.org, AJvYcCXS4WxlcKQeGMbhelUHPB9TCV7rW/ABQ2Uu40f7uvfhAQJ4p71hoIbIvRCi/QxNnWQOUmLAUG0t4Uohtg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwtogX14xQ5vsCnMXRSWx+Y6FEmApt6zAyGFl7SMjy9vK2y1t8G
	lfcf06sfLJEzTYPrkStGYoq/7N034OyJsPFx3im5iw3+4QDTDRsAkrctyE0QV4oZhYVLluWA7li
	UQkGAXkr92TcKs0fczybP0OS5f1vG55k=
X-Gm-Gg: ASbGncvqZqeQ+tunyZbNuvrZc0CF6qHsjFMxd5CvCw9t/IR8TalcADxftpvZy9L1z3z
	AgEmrj4t8Q59jRktKzV0FFIy1LDJhaCNHgGnIwiPATPRY1o0OdrP76FmQqnK8G9JKg6qi3m9Cp8
	4EdhpBcyhxpdt5QIOI+5nsxPGV2quAaoUZdlTnnue8d7H0+fni/dAPMOKpHQYB+hZ2sWU5CFPDH
	VI=
X-Google-Smtp-Source: AGHT+IEvUsEISWdsBbdJKh0v2HGHrMV9/aTnXFIn2m1HfLsSUPoYUO446g2msReWU9yYxWavikvhooBoozIfxlox6UQ=
X-Received: by 2002:a05:6870:d189:b0:2c1:51f7:e648 with SMTP id
 586e51a60fabf-2ea99a3f908mr777187fac.35.1749611056568; Tue, 10 Jun 2025
 20:04:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250610101234.1100660-3-zhangchunyan@iscas.ac.cn> <mhng-8AD2A457-504F-4EF6-AB17-2CF316DFF6A0@palmerdabbelt-mac>
In-Reply-To: <mhng-8AD2A457-504F-4EF6-AB17-2CF316DFF6A0@palmerdabbelt-mac>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Wed, 11 Jun 2025 11:03:37 +0800
X-Gm-Features: AX0GCFsDnM8WxeSPLuep8sadI96fmUB9fnDpELth6QLXswhRYNm23160O-w3_Pk
Message-ID: <CAAfSe-sZLKCGdgHZjmAbwqsv0bUUkBcWeeXarMp7htRLCtArsA@mail.gmail.com>
Subject: Re: [PATCH 2/4] raid6: riscv: Fix NULL pointer dereference issue
To: Palmer Dabbelt <palmer@dabbelt.com>
Cc: zhangchunyan@iscas.ac.cn, Paul Walmsley <paul.walmsley@sifive.com>, 
	aou@eecs.berkeley.edu, Alexandre Ghiti <alex@ghiti.fr>, 
	Charlie Jenkins <charlie@rivosinc.com>, song@kernel.org, yukuai3@huawei.com, 
	linux-riscv@lists.infradead.org, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Palmer,

On Wed, 11 Jun 2025 at 06:00, Palmer Dabbelt <palmer@dabbelt.com> wrote:
>
> On Tue, 10 Jun 2025 03:12:32 PDT (-0700), zhangchunyan@iscas.ac.cn wrote:
> > When running the raid6 user-space test program on RISC-V QEMU, there's a
> > segmentation fault which seems caused by accessing a NULL pointer,
> > which is the pointer variable p/q in raid6_rvv*_gen/xor_syndrome_real(),
> > p/q should have been equal to dptr[x], but when I use GDB command to
> > see its value, which was 0x10 like below:
> >
> > "
> > Program received signal SIGSEGV, Segmentation fault.
> > 0x0000000000011062 in raid6_rvv2_xor_syndrome_real (disks=<optimized out>, start=0, stop=<optimized out>, bytes=4096, ptrs=<optimized out>) at rvv.c:386
> > (gdb) p p
> > $1 = (u8 *) 0x10 <error: Cannot access memory at address 0x10>
> > "
> >
> > The issue was found to be related with:
> > 1) Compile optimization
> >    There's no segmentation fault if compiling the raid6test program with
> >    the optimization flag -O0.
> > 2) The RISC-V vector command vsetvli
> >    If not used t0 as the first parameter in vsetvli, there's no
> >    segmentation fault either.
> >
> > This patch selects the 2nd solution to fix the issue.
>
> This code is super fragile, it's got a bunch of vector asm blocks in
> there that aren't declaring their cobbers.  At a bare minimum we should
> have something like
>
>     diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
>     index 99dfa16d37c7..3c9b3fd9f2ed 100644
>     --- a/lib/raid6/rvv.c
>     +++ b/lib/raid6/rvv.c
>     @@ -17,6 +17,10 @@
>      #define NSIZE  16
>      #endif
>
>     +#ifdef __riscv_vector
>     +#error "This code must be built without compiler support for vector"
>     +#endif
>     +

Ok, I will add this.

Thanks,
Chunyan

>      static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
>      {
>         u8 **dptr = (u8 **)ptrs;
>
> because it just won't work when built with a compiler that can use
> vector instructions.
>
> > Fixes: 6093faaf9593 ("raid6: Add RISC-V SIMD syndrome and recovery calculations")
> > Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> > ---
> >  lib/raid6/rvv.c | 48 ++++++++++++++++++++++++++++--------------------
> >  1 file changed, 28 insertions(+), 20 deletions(-)
> >
> > diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
> > index bf7d5cd659e0..b193ea176d5d 100644
> > --- a/lib/raid6/rvv.c
> > +++ b/lib/raid6/rvv.c
> > @@ -23,9 +23,9 @@ static int rvv_has_vector(void)
> >  static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
> >  {
> >       u8 **dptr = (u8 **)ptrs;
> > -     unsigned long d;
> > -     int z, z0;
> >       u8 *p, *q;
> > +     unsigned long vl, d;
> > +     int z, z0;
> >
> >       z0 = disks - 3;         /* Highest data disk */
> >       p = dptr[z0 + 1];               /* XOR parity */
> > @@ -33,8 +33,9 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
> >
> >       asm volatile (".option  push\n"
> >                     ".option  arch,+v\n"
> > -                   "vsetvli  t0, x0, e8, m1, ta, ma\n"
> > +                   "vsetvli  %0, x0, e8, m1, ta, ma\n"
> >                     ".option  pop\n"
> > +                   : "=&r" (vl)
> >       );
> >
> >        /* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
> > @@ -96,7 +97,7 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
> >  {
> >       u8 **dptr = (u8 **)ptrs;
> >       u8 *p, *q;
> > -     unsigned long d;
> > +     unsigned long vl, d;
> >       int z, z0;
> >
> >       z0 = stop;              /* P/Q right side optimization */
> > @@ -105,8 +106,9 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
> >
> >       asm volatile (".option  push\n"
> >                     ".option  arch,+v\n"
> > -                   "vsetvli  t0, x0, e8, m1, ta, ma\n"
> > +                   "vsetvli  %0, x0, e8, m1, ta, ma\n"
> >                     ".option  pop\n"
> > +                   : "=&r" (vl)
> >       );
> >
> >       /* v0:wp0, v1:wq0, v2:wd0/w20, v3:w10 */
> > @@ -192,9 +194,9 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
> >  static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
> >  {
> >       u8 **dptr = (u8 **)ptrs;
> > -     unsigned long d;
> > -     int z, z0;
> >       u8 *p, *q;
> > +     unsigned long vl, d;
> > +     int z, z0;
> >
> >       z0 = disks - 3;         /* Highest data disk */
> >       p = dptr[z0 + 1];               /* XOR parity */
> > @@ -202,8 +204,9 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
> >
> >       asm volatile (".option  push\n"
> >                     ".option  arch,+v\n"
> > -                   "vsetvli  t0, x0, e8, m1, ta, ma\n"
> > +                   "vsetvli  %0, x0, e8, m1, ta, ma\n"
> >                     ".option  pop\n"
> > +                   : "=&r" (vl)
> >       );
> >
> >       /*
> > @@ -284,7 +287,7 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
> >  {
> >       u8 **dptr = (u8 **)ptrs;
> >       u8 *p, *q;
> > -     unsigned long d;
> > +     unsigned long vl, d;
> >       int z, z0;
> >
> >       z0 = stop;              /* P/Q right side optimization */
> > @@ -293,8 +296,9 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
> >
> >       asm volatile (".option  push\n"
> >                     ".option  arch,+v\n"
> > -                   "vsetvli  t0, x0, e8, m1, ta, ma\n"
> > +                   "vsetvli  %0, x0, e8, m1, ta, ma\n"
> >                     ".option  pop\n"
> > +                   : "=&r" (vl)
> >       );
> >
> >       /*
> > @@ -410,9 +414,9 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
> >  static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
> >  {
> >       u8 **dptr = (u8 **)ptrs;
> > -     unsigned long d;
> > -     int z, z0;
> >       u8 *p, *q;
> > +     unsigned long vl, d;
> > +     int z, z0;
> >
> >       z0 = disks - 3; /* Highest data disk */
> >       p = dptr[z0 + 1];       /* XOR parity */
> > @@ -420,8 +424,9 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
> >
> >       asm volatile (".option  push\n"
> >                     ".option  arch,+v\n"
> > -                   "vsetvli  t0, x0, e8, m1, ta, ma\n"
> > +                   "vsetvli  %0, x0, e8, m1, ta, ma\n"
> >                     ".option  pop\n"
> > +                   : "=&r" (vl)
> >       );
> >
> >       /*
> > @@ -536,7 +541,7 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> >  {
> >       u8 **dptr = (u8 **)ptrs;
> >       u8 *p, *q;
> > -     unsigned long d;
> > +     unsigned long vl, d;
> >       int z, z0;
> >
> >       z0 = stop;              /* P/Q right side optimization */
> > @@ -545,8 +550,9 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> >
> >       asm volatile (".option  push\n"
> >                     ".option  arch,+v\n"
> > -                   "vsetvli  t0, x0, e8, m1, ta, ma\n"
> > +                   "vsetvli  %0, x0, e8, m1, ta, ma\n"
> >                     ".option  pop\n"
> > +                   : "=&r" (vl)
> >       );
> >
> >       /*
> > @@ -718,9 +724,9 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> >  static void raid6_rvv8_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)
> >  {
> >       u8 **dptr = (u8 **)ptrs;
> > -     unsigned long d;
> > -     int z, z0;
> >       u8 *p, *q;
> > +     unsigned long vl, d;
> > +     int z, z0;
> >
> >       z0 = disks - 3; /* Highest data disk */
> >       p = dptr[z0 + 1];       /* XOR parity */
> > @@ -728,8 +734,9 @@ static void raid6_rvv8_gen_syndrome_real(int disks, unsigned long bytes, void **
> >
> >       asm volatile (".option  push\n"
> >                     ".option  arch,+v\n"
> > -                   "vsetvli  t0, x0, e8, m1, ta, ma\n"
> > +                   "vsetvli  %0, x0, e8, m1, ta, ma\n"
> >                     ".option  pop\n"
> > +                   : "=&r" (vl)
> >       );
> >
> >       /*
> > @@ -912,7 +919,7 @@ static void raid6_rvv8_xor_syndrome_real(int disks, int start, int stop,
> >  {
> >       u8 **dptr = (u8 **)ptrs;
> >       u8 *p, *q;
> > -     unsigned long d;
> > +     unsigned long vl, d;
> >       int z, z0;
> >
> >       z0 = stop;              /* P/Q right side optimization */
> > @@ -921,8 +928,9 @@ static void raid6_rvv8_xor_syndrome_real(int disks, int start, int stop,
> >
> >       asm volatile (".option  push\n"
> >                     ".option  arch,+v\n"
> > -                   "vsetvli  t0, x0, e8, m1, ta, ma\n"
> > +                   "vsetvli  %0, x0, e8, m1, ta, ma\n"
> >                     ".option  pop\n"
> > +                   : "=&r" (vl)
> >       );
> >
> >       /*
