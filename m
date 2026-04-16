Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623613C2784
	for <linux-raid@vger.kernel.org>; Thu, 16 Apr 2026 14:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776351603; cv=pass; b=jdsDUagJ48fKRVMfr7+mh+KbPWU5YM5cD4GM+cGHagA+RES1hQFZ3qHx9n7t/0ye8kWfML5gMjWuUkzCgaAB8NtXsTMv+cq9J1dZum4J+KLzZVwFvyGW+QGX70yPb3PBFc42IximP/Irg1OPDMANE6JPA/4fU8WSMBsc+naaJY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776351603; c=relaxed/simple;
	bh=Y5tBrdjp06Wyc+KeuZucI/ISJmRfU7VehHTOb5xfHzo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qrlc6QSDQnk4/fgXRXiDsqBW9aEvbuEY3MsOm0ZqhYrAA2vX2r8JrIvpTEtQcrIJZt+uwUHaNf6pK/6Ud3kyL6T1TYkNTa+OwN4rom/Ua0y2kFMhhgeSPN5Go+pN4bLC92H+JiuY9nGRdFesBWAUt179YSovRds94wYAoautcxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l87TvhYP; arc=pass smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l87TvhYP"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43cfac48bc7so5684510f8f.0
        for <linux-raid@vger.kernel.org>; Thu, 16 Apr 2026 07:59:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776351598; cv=none;
        d=google.com; s=arc-20240605;
        b=LCCd/SmyEMXfLQY05o17W8rzinMaiRe98GAKRIEpF7VyKfrTpUMfkbUqHyJmNNI4Ob
         efi2k0aaRLAQsEd5NU+Dv49B/lzUQq0PP1g1DWT6hDlzWNQNfldcjTMqax1K9E2474s+
         u+MVQeBWyaS2n16q2901DAIbqrf5pxkST4tdFLWtw52XMfKockAdb1Cj8lhWOTRubptF
         EhIgYHj7DVBhg5vL3vjLOz7C7YwvlQ+a1poBdjXWhoH/al8/GfYC+IK94VPfQ16V/Z6y
         cZEnwImZdmX/+bKRWsXB6jlE3AW+w5LgQ8oTzU0Fti8/tDmreo4+hdl4E/2tdM1Rgy62
         T6kA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YwtiaVNwpk1mGr4uhGnta3V8KmyM12FpBeR731AKa1U=;
        fh=hxavORu1tK7B58Iq4HYqJR/d9TQ6JR6b8wkn0uPPqUo=;
        b=lxE3F9UzKlQp5AaEnsxLKReNlwtlPMbTYx8P0G2/SzinYaVyIdopSMLV0KP7V0Z55O
         T+UQZoRLzSr/nXc9iA9sIPgdcirhuZ16iAeU8uOt12scOCA9/Dtg/ceiZ4khldXcq8y4
         o7TNIm0P1T8sL+mwQVgqamjgbs267MMK1Q1jbfbV+3otg8fyHeIxZfCO66fIqa/on/2k
         r5bFbgQXsS0FrH0vjzm/EF49+JT1G8GEOTH+tclW41H+EPaNyY8oOvY1HMxi5mIsPMyt
         bM/VfzdaUg0BhZRytJ+c9IHIsIXUbWIcRxN4zO2tAEZOa4i9D/bDh0zLFzkTqhn37A5O
         nilw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776351598; x=1776956398; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YwtiaVNwpk1mGr4uhGnta3V8KmyM12FpBeR731AKa1U=;
        b=l87TvhYPus86kP+4iR1ea1V24FFLrkXWXBtvYsKhtbfe9BOFhVNXbVORhr8jwaWMZK
         ZXgiJNuq+AxnkkV99gEumBam1RuRWEWVnqLyfF86Ugni5cOUgsXC5g0ArrQr7cdgrEWm
         crTPbGJuSw79OyknDNxFNiL9zZLbSSYga2OTFYJG8gU8iYUtc+i5mRMNMHOmzl3R8842
         WjHaFrSYxrT96FD2rr6ElF1keGgIe/PcMOWa50O/m8pdHWESVsPJ+qdxEVDTCredEab5
         E0AMJF7Gk5g4yWdoUTumbVPLRppHBVp3az/ygskDmYK8wZyEkt/E/UMsSDUl+hfSLL68
         +uPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776351598; x=1776956398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YwtiaVNwpk1mGr4uhGnta3V8KmyM12FpBeR731AKa1U=;
        b=lbLiSYGQFyadpOnB6R5j9fT39FQtBHKMmtjUyj+B7KChEXNN5rQCTypwF6A0P4N+7L
         6lTevUInK2CEhjBiF2UoYVNIqRa3lP9Ht05/HeUsc1I08KOehpzqjFURSGXdPIjmZkgT
         /DCAXxTGEnbN6iCBujQk1wdG+kZayc+UQ1ZFT6H81lYEJ3yTXaOy1K4w0GY7pIKRbCh4
         rZHM45/2cKk0LbceyGHu1gqSI+fFM73q7meWfF/vy3OtgB/8I8pqH6mBBg5WjYsZJm12
         oDI2G3BGaPgsgUZiWSZXLYlz/AmI6D3meTfdh6CfFBRNZa7NINlGdg1I2gam3jyc4IIe
         D4eg==
X-Forwarded-Encrypted: i=1; AFNElJ9dqNp+GzmKyEwAf9wxsZSw/pwXgMYDuxOPDb8D+m+p4kbyLYDY/JnET7B5XQlEJlQ6/lxdTMAYXuKw@vger.kernel.org
X-Gm-Message-State: AOJu0YyYwhsf/FUL5j8z35+Uq7UTDg9S2pSEweP32+mGHUX0LIueYc1x
	Jgrvr62esPaD3IA2ZRzOTY/D2ZJzehLD/33y1IqIhxSKFycJ95jIMwADLM5B/eO03lbZ1JV8+4E
	UWcwimoLUKkTNIHJnMwb5Ci7IxFWf4zk=
X-Gm-Gg: AeBDietWlrJSZR4yTfl4915i9BXExlLjATu9AWhP4xDZ/LHAAK4zMDuYjeGthXq1Sbi
	oGwvXxYm2EG/jXaJQQoui8JFZ6bhuvlVDiCjV0iPRDLUXKypcSMJJluwnnb2+HXQ5zR/m5TycNv
	ft6PRLWzpaTiF44Y1wzA3ipUXCc9AUs4aMEKtZ+CBrJfpkwSs1FeYAnI3eqamRANa6Atwf4UfvV
	l6RsPY9VMHOJXsj/FB9PCDwtP/jCd+6dFdybYKpndAohnJMLB4AH9s6eHpJC++OKsY3hZ+weIVA
	NzY4Fdw=
X-Received: by 2002:a5d:5304:0:b0:43d:7783:c67e with SMTP id
 ffacd0b85a97d-43d7783c7f7mr17786998f8f.36.1776351597405; Thu, 16 Apr 2026
 07:59:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260318150245.3080719-1-demyansh@gmail.com> <f9bc0534-4b7a-4b14-974b-4d7811ccd899@app.fastmail.com>
 <acJhCCPfVxjFUZ5R@J2N7QTR9R3> <CAOLeWCsxhzdxQviizJ4X4VOp_28LCtO-RjWoCcZG29rQw86NVg@mail.gmail.com>
 <9a12e043-8200-4650-bfe2-cbece57a4f87@app.fastmail.com> <20260331063659.GA2061@lst.de>
 <CAOLeWCtnZz=kHGk4C2f9Mbfi3tEBE100iCkMBhcG47dmR9eDWw@mail.gmail.com>
 <CAOLeWCtxPk7q_bVvrcKaipSKr+_=57Auobcj0cFRvXxXMdH58g@mail.gmail.com> <5158e4e0-3275-4c29-a8fc-2dfabc13a69d@app.fastmail.com>
In-Reply-To: <5158e4e0-3275-4c29-a8fc-2dfabc13a69d@app.fastmail.com>
From: Demian Shulhan <demyansh@gmail.com>
Date: Thu, 16 Apr 2026 17:59:44 +0300
X-Gm-Features: AQROBzDLy0IwEiyidCbsFQDNqZsyt5uOErIxdzrMPPdDqO5qPcJrPEd_3UcAqSQ
Message-ID: <CAOLeWCtf2rZyPeJH-LuZ2A+c7mC9M2r-Ya0VjyOJFpun3TFMnw@mail.gmail.com>
Subject: Re: [PATCH v2] raid6: arm64: add SVE optimized implementation for
 syndrome generation
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Mark Rutland <mark.rutland@arm.com>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai@fnnas.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Ard!

> So what exactly did you fix in your test case?

I just added the missing memset. You're right, "aliasing" was the
wrong term for PIP.

> This is the result where all data buffer pointers point to the same
> memory, right? I.e., the zero page? So this is an unrealistic use
> case that we can disregard.

Yes, that's right. It was a flaw in my previous test setup.

> Sorry but your result that SVE is 2x faster does not remain fully intact,
> right? Given that the speedup is now 5.5%?
> Should we just disregard the above results (and explanations) and focus
> on the stuff below?

Yes, it's better to focus on the data from SnapRAID. It was made on
larger blocks and a wider range of disks, providing more realistic
metrics.

> OK, so the takeaway here is that SVE is only worth the hassle if the vect=
or
> length is at least 256 bits. This is not entirely surprising, but given t=
hat
> Graviton4 went back to 128 bit vectors from 256, I wonder what the future
> expectation is here.

I agree. The results from the SnapRAID tests are not as impressive as
I hoped, and the fact that Neoverse-V2 went back to 128-bit is a red
flag. It suggests that wide SVE registers might not be a priority in
future architecture versions.

> These results seem very relevant - perhaps Christoph can give some guidan=
ce
> on how we might use these to improve the built-in benchmarks to be more
> accurate.

This is the most important part of this report, I think. SVE looks
good only like my first idea on paper but in the real scenario it
brings more problems than benefits.

I=E2=80=99m happy to drop the SVE implementation for now and instead focus =
on
modernizing the built-in benchmarks to ensure the kernel chooses the
best available NEON path for actual storage workloads.

If you give me the green flag for it, I can start working on improving
these built-in tests.

Best regards,
Demian


=D1=87=D1=82, 16 =D0=BA=D0=B2=D1=96=D1=82. 2026=E2=80=AF=D1=80. =D0=BE 16:4=
0 Ard Biesheuvel <ardb@kernel.org> =D0=BF=D0=B8=D1=88=D0=B5:
>
> Hi Demian,
>
> On Thu, 16 Apr 2026, at 14:40, Demian Shulhan wrote:
> > Hi all,
> >
> > Sorry for the delay. The tests became more complex than I initially
> > thought, so I needed to gather more data and properly validate the
> > results across different hardware configurations.
> >
> > Firstly, I want to clarify the results from my March 29 tests. I found
> > a flaw in my initial custom benchmark. The massive 2x throughput gap on
> > 24 disks wasn't solely due to SVE's superiority, but rather a severe L1
> > D-Cache thrashing issue that disproportionately penalized NEON.
> >
> > My custom test lacked memset() initialization, causing all data buffers
> > to map to the Linux Zero Page (Virtually Indexed, Physically Tagged
> > cache aliasing).
>
> D-caches always behave as PIPT on arm64. This is complex stuff, so please
> don't present conjecture as fact.
>
> > Furthermore, even with memset(), allocating contiguous
> > page-aligned buffers can causes severe Cache Address Sharing (a known
> > issue that Andrea Mazzoleni solved in SnapRAID 13 years ago using
> > RAID_MALLOC_DISPLACEMENT).
> >
> > Because SVE (svex4) uses 256-bit registers on Neoverse-V1, it performs
> > exactly half the number of memory load instructions compared to 128-bit
> > NEON. This dramatically reduced the L1 cache alias thrashing, allowing
> > SVE to survive the memory bottleneck while NEON choked:
> >
>
> You are drawing some conclusions here without disclosing the actual
> information that you based this on. D-caches are non-aliasing on arm64.
>
> So what exactly did you fix in your test case?
>
> > Custom test without memset (4kb block):
> >  | algo=3Dneonx4 ndisks=3D24 iterations=3D1M time=3D11.014s MB/s=3D7802=
.57
> >  | algo=3Dsvex4  ndisks=3D24 iterations=3D1M time=3D5.719s  MB/s=3D1502=
6.92
> >
>
> This is the result where all data buffer pointers point to the same
> memory, right? I.e., the zero page? So this is an unrealistic use
> case that we can disregard.
>
> > Custom test with memset (4kb block):
> >  | algo=3Dneonx4 ndisks=3D24 iterations=3D1M time=3D6.165s  MB/s=3D1393=
9.08
> >  | algo=3Dsvex4  ndisks=3D24 iterations=3D1M time=3D5.839s  MB/s=3D1471=
8.23
> >
> > Even with the corrected memory setup, the throughput gap narrowed, but
> > the fundamental CPU-efficiency result remained fully intact.
> >
>
> Sorry but your result that SVE is 2x faster does not remain fully intact,
> right? Given that the speedup is now 5.5%?
>
> Should we just disregard the above results (and explanations) and focus
> on the stuff below?
>
> > To completely isolate these variables and provide accurate real-world
> > data, the following test campaigns were done based on the SnapRAID
> > project (https://github.com/amadvance/snapraid) using its
> > perf_bench.c tool with proper memory displacement and a 256 KiB block
> > size.
> >
> > Test configurations:
> > - c7g.medium (AWS Graviton3, 1 vCPU): Neoverse-V1, 256-bit SVE
> > - c7g.xlarge (AWS Graviton3, 4 vCPUs): Neoverse-V1, 256-bit SVE
> > - c8g.xlarge (AWS Graviton4, 4 vCPUs): Neoverse-V2, 128-bit SVE
> >
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Section 1: SnapRAID Validation on Graviton3 / Neoverse-V1
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> ...
> >
> > 1.3 Main Graviton3 Conclusions
> >  - On 256-bit SVE hardware, svex4 consistently retires about ~34% fewer
> >    instructions and ~10-15% fewer CPU cycles than neonx4.
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Section 2: SnapRAID Validation on Graviton4 / Neoverse-V2
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> ...
> >
> > 2.3 Main Graviton4 Conclusions
> >  - On Neoverse-V2, SVE vector length is 128-bit (same as NEON).
> >  - Without the 256-bit width, NEON outperforms SVE.
> >  - svex4 retires ~32% MORE instructions here and is consistently slower=
.
> >
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Section 3: Validation on c7g.medium (1 vCPU)
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> ...
> > 3.3 Main c7g.medium Conclusions
> >  - The instruction count reduction (~34%) perfectly matches the 4-vCPU
> >    instance.
> >  - The single vCPU is heavily memory-bandwidth constrained (cycle count=
s
> >    are much higher waiting for RAM).
> >
>
> OK, so the takeaway here is that SVE is only worth the hassle if the vect=
or
> length is at least 256 bits. This is not entirely surprising, but given t=
hat
> Graviton4 went back to 128 bit vectors from 256, I wonder what the future
> expectation is here.
>
> But having these numbers is definitely a good first step. Now we need to
> quantify the overhead associated with having kernel mode SVE state that
> needs to be preserved/restored.
>
> However, 10%-15% speedup that can only be achieved on SVE implementations
> with 256 bit vectors or more may not be that enticing in the end. (The
> fact that you are retiring 34% instructions less does not really matter
> here unless there is some meaningful SMT-like sharing of functional units
> going on in the meantime, which seems unlikely on a CPU that is maxed out
> on the data side)
>
>
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Section 4: The Pitfalls of the Current Kernel Benchmark
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
>
> These results seem very relevant - perhaps Christoph can give some guidan=
ce
> on how we might use these to improve the built-in benchmarks to be more
> accurate.
>
>
> Thanks,
>
