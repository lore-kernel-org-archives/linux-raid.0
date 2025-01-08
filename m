Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584DC204087
	for <linux-raid@vger.kernel.org>; Wed,  8 Jan 2025 21:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736370602; cv=none; b=FTFwKv9pzNXB9S2TO/CXWYpL5jfMYGNJXKybpNgpdGIYurCogHIrVFmosOzPrenw5OTcN0uP/Ie8WIetjIHvR+67YHR6FafgvJ7m9RMtRPOa/neLU0Lglo757AT9msBBCF1NnvtcsjUe16kgA+AzF7ZgqfwtV3fmMVlLeuIFPFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736370602; c=relaxed/simple;
	bh=kXqt5OKPMJSBu3hq90biieHYyTqdkaB8FqPc9OiItMY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=jxuIZxBKqI+oe7W8+R+9Af7/R+vtJvowDzmsjAruVBev8D5KOu/TPZjwe/kee/sF+rthnYC8yWAtvIL1cQLb9yEI/sTrHt9DtU+kchJv8PguEDMUvzExvnvYZLCNL0pQsB5RhTNG/VyknXCgLgTMwR33qMtif3Boarj+kNx9jb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrtc27.com; spf=pass smtp.mailfrom=jrtc27.com; dkim=pass (2048-bit key) header.d=jrtc27.com header.i=@jrtc27.com header.b=WcDgOGaN; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=jrtc27.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jrtc27.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jrtc27.com header.i=@jrtc27.com header.b="WcDgOGaN"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-38a88ba968aso187959f8f.3
        for <linux-raid@vger.kernel.org>; Wed, 08 Jan 2025 13:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jrtc27.com; s=gmail.jrtc27.user; t=1736370598; x=1736975398; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lo3JCIHzeaUFwKuziaH+GtfOr8z8ugw2AVRwTDWsU5k=;
        b=WcDgOGaNU+f+G30jr7I/X8KQn/jFDOR8NucNlU4wFmvTm7WoD+yUrDuMXMVMu4ZMLq
         70sVAvJeau8Fuv2ZJuq/41+hlStBiXTOHxNYlGjIfPi4XMpjzLxWUMguvo8ia83T9UyC
         VfN3UXkqrBZaoP1euJQUBP89o8BIartR7EGwqJW+pPhISkZ3KGwhTy/2WZfnM4a4VpbV
         TRlZnjpbhAtdx6y58kEMhKXa04qob9vbNCb11m05vtUS+e2uqzv4O4uxNh+7poOWWOwi
         CKcinhsNYsQ6ciGmrZRYTBVPAsJBpv5xPKq2oJrO4gn25BmVoNtpL+XtUWKPlzWbStT4
         fQfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736370598; x=1736975398;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lo3JCIHzeaUFwKuziaH+GtfOr8z8ugw2AVRwTDWsU5k=;
        b=Cyl23iOPNq6TiQtpwDUnPk5i5GJKZR8VOA9KuSxqi/1ZTk8TW5VXM6H3WhqSqMuI2m
         x9dWQjyROebeMOFEMWnxVp79/jAMkAHVl3IsF2jD9cFM37ndk9mQNs+vqdMIjZsmaBP6
         TxNSF+Mzd8UtqsZyfeD9v/BxCjIBt0xxgVdAUM++NF/76O4wjGcirkzWi8quf/CYTw2R
         M+gaCsKVomMw/pW7L7KeThyEBAGuEKMM0/qoFg7qZV5GR1abcgAwt/Mfd/oimYBPWgW2
         bxeT8x/0WlynlGsZ1htSUWkAd2PCdcoRxSQGoY+YRl44VLZ/4RFCFnxXV76aPQc4cPT4
         93Hw==
X-Forwarded-Encrypted: i=1; AJvYcCVs7FPLGNqz+qlhSl97poIgFVMRSOOpDMdQ+6bHMkO6KwR4BbkC/J/Yg4hZjwkOIvWg7Ab8wgsvAnIt@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1GPlgqktzbnvKq0h9pZ1U5k4mJTMp5TDpit6L0/qQmjK5bHaE
	O6HHYzTx3udol8DgTKmTCqSlS6JjzkbMbucxQdc4k0KpYF6eMgWzzKvTeUKcI/o=
X-Gm-Gg: ASbGncvLweEpxjaKRJGpsl0qtVVpa1d0XboGrg1ku1cFR6LO0BNG4i2TY4GFdP1foQm
	NvKA+ncPqJSm2RLKm8AfPNC+Y8vCH8JcZK9m4fFxFWR1elM9KDT0fGkRtSyHwugRWYeW9nYsOzb
	Hlu453VVuFp2QxL9jtzLMzRDQe9lpwruPdX5igeccDxno049D111jWcz4eBe4lJoYhKwjcXdDSG
	TfRMBAaVwR5fSWlUtyXgGkd834THhq0iJvP1YBazflDfPP4b2X8EL5PgqijUXl/kCn4Dw==
X-Google-Smtp-Source: AGHT+IHy6wrVklWqdRFvNxI7BI7z3mAZOGyzxhkml/LFj2PQwykJDd3EJzJMrpOuFg2hziQqqjQ/dQ==
X-Received: by 2002:a05:6000:2a3:b0:385:fb8d:865b with SMTP id ffacd0b85a97d-38a8735649cmr4123579f8f.48.1736370598444;
        Wed, 08 Jan 2025 13:09:58 -0800 (PST)
Received: from smtpclient.apple ([131.111.5.201])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a2311b3c8sm50854142f8f.25.2025.01.08.13.09.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jan 2025 13:09:57 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.300.87.4.3\))
Subject: Re: [RFC PATCH] raid6: Add RISC-V SIMD syndrome and recovery
 calculations
From: Jessica Clarke <jrtc27@jrtc27.com>
In-Reply-To: <20250108-worsening-hacksaw-c1e970f1c4e3@spud>
Date: Wed, 8 Jan 2025 21:09:46 +0000
Cc: Chunyan Zhang <zhang.lyra@gmail.com>,
 Chunyan Zhang <zhangchunyan@iscas.ac.cn>,
 Paul Walmsley <paul.walmsley@sifive.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>,
 linux-riscv@lists.infradead.org,
 linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E0E58901-5DCF-46A2-9B96-8FFEF9C0EB64@jrtc27.com>
References: <20241220114023.667347-1-zhangchunyan@iscas.ac.cn>
 <20241220-chaste-mundane-5514462147b6@spud>
 <CAAfSe-tT7f3to0CPyF-DK09E+NNwN+tRpmuNwtTqbe3=_y3sFg@mail.gmail.com>
 <20241223-bunch-deceased-33c10c5b3dc4@spud>
 <CAAfSe-sPBHY_AUCksMj2qxHi2PchWpkV4JH0DzXF56Kvpwm0bg@mail.gmail.com>
 <20250108-worsening-hacksaw-c1e970f1c4e3@spud>
To: Conor Dooley <conor@kernel.org>
X-Mailer: Apple Mail (2.3826.300.87.4.3)

On 8 Jan 2025, at 18:57, Conor Dooley <conor@kernel.org> wrote:
>=20
> On Mon, Dec 23, 2024 at 10:16:46AM +0800, Chunyan Zhang wrote:
>> On Mon, 23 Dec 2024 at 09:35, Conor Dooley <conor@kernel.org> wrote:
>>>=20
>>> On Mon, Dec 23, 2024 at 09:16:38AM +0800, Chunyan Zhang wrote:
>>>> Hi Conor,
>>>>=20
>>>> On Sat, 21 Dec 2024 at 06:52, Conor Dooley <conor@kernel.org> =
wrote:
>>>>>=20
>>>>> On Fri, Dec 20, 2024 at 07:40:23PM +0800, Chunyan Zhang wrote:
>>>>>> The assembly is originally based on the ARM NEON and int.uc, but =
uses
>>>>>> RISC-V vector instructions to implement the RAID6 syndrome and
>>>>>> recovery calculations.
>>>>>>=20
>>>>>> The functions are tested on QEMU.
>>>>>>=20
>>>>>> Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
>>>>>> ---
>>>>>> include/linux/raid/pq.h |   4 +
>>>>>> lib/raid6/Makefile      |   3 +
>>>>>> lib/raid6/algos.c       |   8 +
>>>>>> lib/raid6/recov_rvv.c   | 229 +++++++++++++
>>>>>> lib/raid6/rvv.c         | 715 =
++++++++++++++++++++++++++++++++++++++++
>>>>>> 5 files changed, 959 insertions(+)
>>>>>> create mode 100644 lib/raid6/recov_rvv.c
>>>>>> create mode 100644 lib/raid6/rvv.c
>>>>>>=20
>>>>>> diff --git a/include/linux/raid/pq.h b/include/linux/raid/pq.h
>>>>>> index 98030accf641..4c21f06c662a 100644
>>>>>> --- a/include/linux/raid/pq.h
>>>>>> +++ b/include/linux/raid/pq.h
>>>>>> @@ -108,6 +108,9 @@ extern const struct raid6_calls =
raid6_vpermxor4;
>>>>>> extern const struct raid6_calls raid6_vpermxor8;
>>>>>> extern const struct raid6_calls raid6_lsx;
>>>>>> extern const struct raid6_calls raid6_lasx;
>>>>>> +extern const struct raid6_calls raid6_rvvx1;
>>>>>> +extern const struct raid6_calls raid6_rvvx2;
>>>>>> +extern const struct raid6_calls raid6_rvvx4;
>>>>>>=20
>>>>>> struct raid6_recov_calls {
>>>>>>      void (*data2)(int, size_t, int, int, void **);
>>>>>> @@ -125,6 +128,7 @@ extern const struct raid6_recov_calls =
raid6_recov_s390xc;
>>>>>> extern const struct raid6_recov_calls raid6_recov_neon;
>>>>>> extern const struct raid6_recov_calls raid6_recov_lsx;
>>>>>> extern const struct raid6_recov_calls raid6_recov_lasx;
>>>>>> +extern const struct raid6_recov_calls raid6_recov_rvv;
>>>>>>=20
>>>>>> extern const struct raid6_calls raid6_neonx1;
>>>>>> extern const struct raid6_calls raid6_neonx2;
>>>>>> diff --git a/lib/raid6/Makefile b/lib/raid6/Makefile
>>>>>> index 29127dd05d63..e62fb7cd773e 100644
>>>>>> --- a/lib/raid6/Makefile
>>>>>> +++ b/lib/raid6/Makefile
>>>>>> @@ -10,6 +10,9 @@ raid6_pq-$(CONFIG_ALTIVEC) +=3D altivec1.o =
altivec2.o altivec4.o altivec8.o \
>>>>>> raid6_pq-$(CONFIG_KERNEL_MODE_NEON) +=3D neon.o neon1.o neon2.o =
neon4.o neon8.o recov_neon.o recov_neon_inner.o
>>>>>> raid6_pq-$(CONFIG_S390) +=3D s390vx8.o recov_s390xc.o
>>>>>> raid6_pq-$(CONFIG_LOONGARCH) +=3D loongarch_simd.o =
recov_loongarch_simd.o
>>>>>> +raid6_pq-$(CONFIG_RISCV_ISA_V) +=3D rvv.o recov_rvv.o
>>>>>> +CFLAGS_rvv.o +=3D -march=3Drv64gcv
>>>>>> +CFLAGS_recov_rvv.o +=3D -march=3Drv64gcv
>>>>>=20
>>>>> I'm curious - why do you need this when you're using .option =
arch,+v
>>>>> below?
>>>>=20
>>>> Compiler would complain the errors like below without this flag:
>>>>=20
>>>> Error: unrecognized opcode `vle8.v v0,(a3)', extension `v' or =
`zve64x'
>>>> or `zve32x' required
>>>=20
>>> Right, but the reason for using .option arch,+v elsewhere in the =
kernel
>>> is because we don't want the compiler to generate vector code at =
all,
>>> and the directive lets the assembler handle the vector instructions. =
If
>>> I recall correctly, the error you pasted above is from the =
assembler,
>>=20
>> Yes, it is from the assembler.
>>=20
>>> not the compiler. You should be able to just set AFLAGS, given that =
all
>>=20
>> It complains the same errors after simply replacing CFLAGS with =
AFLAGS
>> here. What am I missing?
>>=20
>=20
> I don't know what you're missing unfortunately, sorry.

.option push should be paired with .option pop within the same inline
asm statement. You cannot generally split them up, as the compiler will
not guarantee that the inline asm statements appear in that order
textually, since it may reorder blocks, and may even clone or delete
them. Plus in some cases you could end up affecting the compiler=E2=80=99s=
 own
generated code, although that shouldn=E2=80=99t matter here.

Jess

