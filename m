Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD011386C9;
	Thu, 17 Jul 2025 02:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752718645; cv=none; b=CfWn7lq55o6VHFnkUR6Tx6MCfi1TJWsK4vJoMRMrgjTN96HPaB7GuD4dujtOROrtV//clkxonQHrtn1kVHNLSsYlurEvTZg3IskGoLj6UidezH/M13ZT/J+Q/K+++UCoWxlvBzgad7p+nIfDjMhwpvE5N6iagwzrhdaU8elMeBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752718645; c=relaxed/simple;
	bh=NgD9B4Uj9Xjw9oIamqYix7QC57u/TQSDeWE3C/Hd9WA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ax9Wp9W2kvoLms47MaykRpVXkFMDjQCrB4o4c8TJmNF1E5zy7UvLCYWikKS+RJDLcD39+qPGl3WV61g9ws5YGB0GcE1CSlLjPb2Em4im+knorU0OQ88c3YqutoId9uud31EoCDbHjBVe9n+Jn59us7WGzBXxhYf0VZCJyGogyuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fxRkJQPg; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fxRkJQPg"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-73e5d3916f7so214138a34.1;
        Wed, 16 Jul 2025 19:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752718643; x=1753323443; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yfhTBRXb2JdB3JZK5ErqTY9iJkcc2lm+jZagt7K/tLA=;
        b=fxRkJQPgwKwtxhhMdMTUvjpUns8s0Vk5ARw4ntRIhMptkTGT7P1Emc7WsJTVfulCuu
         wFTyApT7YK4ZjgXUv9u79hLTUX90o4AHph5rdrnhhhB/CAjmaR+8w6Sze6m3cbg2l8+M
         i8Yxo4MIHrLMh9HOm1V37dIhXFostBx0330TKEgKkX44+wPPdGuo5VFKZGPARo1BSdQt
         htHWgdP5DqzeSSiE4RtI6uQf0W5Osg/K5Vvbx2UoSH8fD6fcavQUOgZ3S9db5oVgrbEI
         NJsabNMimCEnrN+aLepnrUE9EAbKIWSXWspYnxc/afdYkHjs4eEcKw5jOryp8aKWuj8e
         P25Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752718643; x=1753323443;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yfhTBRXb2JdB3JZK5ErqTY9iJkcc2lm+jZagt7K/tLA=;
        b=wIUihjnjDS43uXlU1z7Q6pnbxNUR6RQYEr5DKGPBYIanz2pWFke+N4Ra05vNcHFyLU
         lhJ3GPQ/vjxQddvEMuBprlXK4LIRQx1nlpHR0VcGkqftb0UB1xrSRCwDNQUvSdd7AcsV
         iqt16FDXUP6AVcWYumQAKfP1UnPrB6GmBnKwu/8t5D8YYCfIoR+imaV0ph71nukGWdbP
         kyTpbQXoMexam8hWaI9Xa7k4i+Z1OPJ7B+r4ZHQE6XNmSOObeAOW4NuW+/j7yeEi5GQj
         iCJNQkpB3FufjSqk41OJNwDQSppMPaHmBH6v74JFOZ1dnS/facM6Hmo9gqTFm2/4X4rY
         ZgCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnjC7+t/DfUVFeRXk8kH3lG6ALdlGHOmWkZsmwxvr0OIvxhtECNBn2qMfRfxwGmDJuVbCXTqVRNTT8NPc=@vger.kernel.org, AJvYcCXCP/14ge3RGR2yRKwGzPAemc9LoZVHg+3+juEXzqB/oF0AjJPHDYWPMs7/6/U9EFeUsSL9LffKsAsPOQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzD5eDVFEjoJm3piMxJKTAAPnw0D5tQyqB25Q8QJTKu8BiLRYHh
	RgbvTY5Gm9LzJY6gDAl3ieuzBjFa3nKuJ/t3lwTKEY9Bxx1T/q4xqWVxQZKq5T4q8naRaKta8c+
	X//tKz6fAeUf8LrK1mzDD0tZesABeBsw=
X-Gm-Gg: ASbGncsaT9ISFD++Wkm4QB2mPqpxEEhGrSeTFEuXfhZ/JowQ8jhbxVYOM6TamWDCiaD
	0dngr+Tz1g8PydvcJ7TQKljP1LeYsQlQoeDfi+oGXI7vGBgZY7ehwPqR+aqa24NGqHMs9pVGOiy
	IG4oeevTZ8A3SWVCTXKy9q9twAj1Cg1r4ZCPfQiH27RWw3X+NdyTSAp9wjQhcNhDpoz5tZbyxyX
	71lfhk27FME32YTw8TudUb0bGNSXGotcppcUVQ=
X-Google-Smtp-Source: AGHT+IHdEPTCuurLTYS/CkOGkIb52Puht1nHGBkhakU7lzDF5huZwiMATLJoBREg7tEIXAwFgvN7w8MhSJDaIUhB3wY=
X-Received: by 2002:a05:6808:188d:b0:40b:9307:db19 with SMTP id
 5614622812f47-41e468a6e6dmr802856b6e.21.1752718642638; Wed, 16 Jul 2025
 19:17:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250711100930.3398336-1-zhangchunyan@iscas.ac.cn>
 <20250711100930.3398336-3-zhangchunyan@iscas.ac.cn> <8865f36d-c8a9-454b-aa55-741a82ca96b4@ghiti.fr>
In-Reply-To: <8865f36d-c8a9-454b-aa55-741a82ca96b4@ghiti.fr>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Thu, 17 Jul 2025 10:16:46 +0800
X-Gm-Features: Ac12FXzveb-RnXII_j1HVui31imert4VMFPIk7PmvaQcpWA2XDN1CctR9loF9iM
Message-ID: <CAAfSe-snJ3Z_p0UyS85AMiPWsCo976XAJREGN3V_UgisOKG3Sg@mail.gmail.com>
Subject: Re: [PATCH V2 2/5] raid6: riscv: replace one load with a move to
 speed up the caculation
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Charlie Jenkins <charlie@rivosinc.com>, Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	linux-riscv@lists.infradead.org, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 16 Jul 2025 at 21:40, Alexandre Ghiti <alex@ghiti.fr> wrote:
>
> On 7/11/25 12:09, Chunyan Zhang wrote:
> > Since wp$$==wq$$, it doesn't need to load the same data twice, use move
> > instruction to replace one of the loads to let the program run faster.
> >
> > Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
> > ---
> >   lib/raid6/rvv.c | 60 ++++++++++++++++++++++++-------------------------
> >   1 file changed, 30 insertions(+), 30 deletions(-)
> >
> > diff --git a/lib/raid6/rvv.c b/lib/raid6/rvv.c
> > index b193ea176d5d..89da5fc247aa 100644
> > --- a/lib/raid6/rvv.c
> > +++ b/lib/raid6/rvv.c
> > @@ -44,7 +44,7 @@ static void raid6_rvv1_gen_syndrome_real(int disks, unsigned long bytes, void **
> >               asm volatile (".option  push\n"
> >                             ".option  arch,+v\n"
> >                             "vle8.v   v0, (%[wp0])\n"
> > -                           "vle8.v   v1, (%[wp0])\n"
> > +                           "vmv.v.v  v1, v0\n"
> >                             ".option  pop\n"
> >                             : :
> >                             [wp0]"r"(&dptr[z0][d + 0 * NSIZE])
> > @@ -117,7 +117,7 @@ static void raid6_rvv1_xor_syndrome_real(int disks, int start, int stop,
> >               asm volatile (".option  push\n"
> >                             ".option  arch,+v\n"
> >                             "vle8.v   v0, (%[wp0])\n"
> > -                           "vle8.v   v1, (%[wp0])\n"
> > +                           "vmv.v.v  v1, v0\n"
> >                             ".option  pop\n"
> >                             : :
> >                             [wp0]"r"(&dptr[z0][d + 0 * NSIZE])
> > @@ -218,9 +218,9 @@ static void raid6_rvv2_gen_syndrome_real(int disks, unsigned long bytes, void **
> >               asm volatile (".option  push\n"
> >                             ".option  arch,+v\n"
> >                             "vle8.v   v0, (%[wp0])\n"
> > -                           "vle8.v   v1, (%[wp0])\n"
> > +                           "vmv.v.v  v1, v0\n"
> >                             "vle8.v   v4, (%[wp1])\n"
> > -                           "vle8.v   v5, (%[wp1])\n"
> > +                           "vmv.v.v  v5, v4\n"
> >                             ".option  pop\n"
> >                             : :
> >                             [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
> > @@ -310,9 +310,9 @@ static void raid6_rvv2_xor_syndrome_real(int disks, int start, int stop,
> >               asm volatile (".option  push\n"
> >                             ".option  arch,+v\n"
> >                             "vle8.v   v0, (%[wp0])\n"
> > -                           "vle8.v   v1, (%[wp0])\n"
> > +                           "vmv.v.v  v1, v0\n"
> >                             "vle8.v   v4, (%[wp1])\n"
> > -                           "vle8.v   v5, (%[wp1])\n"
> > +                           "vmv.v.v  v5, v4\n"
> >                             ".option  pop\n"
> >                             : :
> >                             [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
> > @@ -440,13 +440,13 @@ static void raid6_rvv4_gen_syndrome_real(int disks, unsigned long bytes, void **
> >               asm volatile (".option  push\n"
> >                             ".option  arch,+v\n"
> >                             "vle8.v   v0, (%[wp0])\n"
> > -                           "vle8.v   v1, (%[wp0])\n"
> > +                           "vmv.v.v  v1, v0\n"
> >                             "vle8.v   v4, (%[wp1])\n"
> > -                           "vle8.v   v5, (%[wp1])\n"
> > +                           "vmv.v.v  v5, v4\n"
> >                             "vle8.v   v8, (%[wp2])\n"
> > -                           "vle8.v   v9, (%[wp2])\n"
> > +                           "vmv.v.v  v9, v8\n"
> >                             "vle8.v   v12, (%[wp3])\n"
> > -                           "vle8.v   v13, (%[wp3])\n"
> > +                           "vmv.v.v  v13, v12\n"
> >                             ".option  pop\n"
> >                             : :
> >                             [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
> > @@ -566,13 +566,13 @@ static void raid6_rvv4_xor_syndrome_real(int disks, int start, int stop,
> >               asm volatile (".option  push\n"
> >                             ".option  arch,+v\n"
> >                             "vle8.v   v0, (%[wp0])\n"
> > -                           "vle8.v   v1, (%[wp0])\n"
> > +                           "vmv.v.v  v1, v0\n"
> >                             "vle8.v   v4, (%[wp1])\n"
> > -                           "vle8.v   v5, (%[wp1])\n"
> > +                           "vmv.v.v  v5, v4\n"
> >                             "vle8.v   v8, (%[wp2])\n"
> > -                           "vle8.v   v9, (%[wp2])\n"
> > +                           "vmv.v.v  v9, v8\n"
> >                             "vle8.v   v12, (%[wp3])\n"
> > -                           "vle8.v   v13, (%[wp3])\n"
> > +                           "vmv.v.v  v13, v12\n"
> >                             ".option  pop\n"
> >                             : :
> >                             [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
> > @@ -754,21 +754,21 @@ static void raid6_rvv8_gen_syndrome_real(int disks, unsigned long bytes, void **
> >               asm volatile (".option  push\n"
> >                             ".option  arch,+v\n"
> >                             "vle8.v   v0, (%[wp0])\n"
> > -                           "vle8.v   v1, (%[wp0])\n"
> > +                           "vmv.v.v  v1, v0\n"
> >                             "vle8.v   v4, (%[wp1])\n"
> > -                           "vle8.v   v5, (%[wp1])\n"
> > +                           "vmv.v.v  v5, v4\n"
> >                             "vle8.v   v8, (%[wp2])\n"
> > -                           "vle8.v   v9, (%[wp2])\n"
> > +                           "vmv.v.v  v9, v8\n"
> >                             "vle8.v   v12, (%[wp3])\n"
> > -                           "vle8.v   v13, (%[wp3])\n"
> > +                           "vmv.v.v  v13, v12\n"
> >                             "vle8.v   v16, (%[wp4])\n"
> > -                           "vle8.v   v17, (%[wp4])\n"
> > +                           "vmv.v.v  v17, v16\n"
> >                             "vle8.v   v20, (%[wp5])\n"
> > -                           "vle8.v   v21, (%[wp5])\n"
> > +                           "vmv.v.v  v21, v20\n"
> >                             "vle8.v   v24, (%[wp6])\n"
> > -                           "vle8.v   v25, (%[wp6])\n"
> > +                           "vmv.v.v  v25, v24\n"
> >                             "vle8.v   v28, (%[wp7])\n"
> > -                           "vle8.v   v29, (%[wp7])\n"
> > +                           "vmv.v.v  v29, v28\n"
> >                             ".option  pop\n"
> >                             : :
> >                             [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
> > @@ -948,21 +948,21 @@ static void raid6_rvv8_xor_syndrome_real(int disks, int start, int stop,
> >               asm volatile (".option  push\n"
> >                             ".option  arch,+v\n"
> >                             "vle8.v   v0, (%[wp0])\n"
> > -                           "vle8.v   v1, (%[wp0])\n"
> > +                           "vmv.v.v  v1, v0\n"
> >                             "vle8.v   v4, (%[wp1])\n"
> > -                           "vle8.v   v5, (%[wp1])\n"
> > +                           "vmv.v.v  v5, v4\n"
> >                             "vle8.v   v8, (%[wp2])\n"
> > -                           "vle8.v   v9, (%[wp2])\n"
> > +                           "vmv.v.v  v9, v8\n"
> >                             "vle8.v   v12, (%[wp3])\n"
> > -                           "vle8.v   v13, (%[wp3])\n"
> > +                           "vmv.v.v  v13, v12\n"
> >                             "vle8.v   v16, (%[wp4])\n"
> > -                           "vle8.v   v17, (%[wp4])\n"
> > +                           "vmv.v.v  v17, v16\n"
> >                             "vle8.v   v20, (%[wp5])\n"
> > -                           "vle8.v   v21, (%[wp5])\n"
> > +                           "vmv.v.v  v21, v20\n"
> >                             "vle8.v   v24, (%[wp6])\n"
> > -                           "vle8.v   v25, (%[wp6])\n"
> > +                           "vmv.v.v  v25, v24\n"
> >                             "vle8.v   v28, (%[wp7])\n"
> > -                           "vle8.v   v29, (%[wp7])\n"
> > +                           "vmv.v.v  v29, v28\n"
> >                             ".option  pop\n"
> >                             : :
> >                             [wp0]"r"(&dptr[z0][d + 0 * NSIZE]),
>
>
> Out of curiosity, did you notice a gain?

Yes, I can see ~3% gain on my BPI-F3.

>
> Anyway:
>
> Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
>
> Thanks,
>
> Alex
>
