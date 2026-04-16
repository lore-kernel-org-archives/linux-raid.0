Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4195B34F489
	for <linux-raid@vger.kernel.org>; Thu, 16 Apr 2026 12:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776343247; cv=pass; b=qp66Aak3PwWZRK3Az5SH7w5byQ6z/OFbGaBt9p8L37cwmXciKMXYogMguPvji4SqkPEF76ce6zLKXAlpfSQdngYZuXTKHCXHfNvIJfczFRzeaEhG6c0K3z72+bX2/lBiQWgmYaiXW0Uwpi4oRbwhTu7Nv3auc45L+mvVT25Ctrs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776343247; c=relaxed/simple;
	bh=Mx2zYxmDMwUrhINuPKnWXJIVHbOx3j8kHh6rlp7z4BI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h7vz3LEn/vmmAAwmnmdOvy0bLU7tnI1+yojrTuNy0TpOZBTwnozT6qvdqS64x6n8lrU4pum2+ZTaXCCGMT8RbZAGcdKooHuqh9AblEjAWJ3jj/H4sFf5Ux0cX10FU8PyKauYoL5DxQF0ARgMkjn3Towwm3e7XswajrVus+68XI4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=plh8zFDH; arc=pass smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="plh8zFDH"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43eada6d900so1548262f8f.0
        for <linux-raid@vger.kernel.org>; Thu, 16 Apr 2026 05:40:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776343244; cv=none;
        d=google.com; s=arc-20240605;
        b=kW+FgTd+f8E/HRxkVsArLiGl1CoYCDD/WbJrI9emcEvO7wLaOlzzJh83MBYw/kOh3D
         NjU1oqimlChZTn6McC2Fm2gW/p7+YqjT6sVUz/ydPKquviKYuoVv7lOw7FFdLEq+BjxW
         HEyYiTdwhBef2J5CWbyqLUBagrNYyv9OQ3rDpf6pRBjFXLr3oC4j0qGMtogVAhuwpYE6
         DLkkTYeHJBKhV4E9GxZ48bv1W2VYrTx8lgenqc6Uu3RDCBBPLdKxT07AAm/i7WWC+/wU
         q5LtVH7XebtBRT1THPJ20/KKa9d5K3Ds7pZqlFeZlhGCxoLJ9oGwoHK7Fa4URemKRyNT
         1Xxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Gt5UxFqFmposyiXB67dSfbbvPP7N/0sqBvz1FsBQ0nY=;
        fh=hNLtfHCfvYS68I7zPq6hlOUNtvIMuavV+uFPv/jq1pg=;
        b=C1S+//rnviBewAzjbOViYOwhLymiKE1PdQojirZG4UE3mzxQU0vmgY6yC8MegMxxus
         4DWXlvOEeIkqiaWJXZ91ZPo4dBEU/ylT5OfDQm1pFic8MpnTAiN7tbdN5n6fDiICo6gh
         UanqxWo8CP1WUU04O84pMBJ6zb6qW6qZ7dPu8MzRKbHj7oOMYXuGZhUxwV2T5YnrJHeb
         oMWp4/mUKlRR4/+X7IylLx8sbcgWNof/WBL28hBAUy7G4abNo7QjrDxg+YK2yT9Wy0gW
         nFViyZkE+b+vEzaaZP9uC8iV5qVw3QbegihDec5G3ffA3059FwI+jOpUESb81+psDLOp
         +UJw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776343244; x=1776948044; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gt5UxFqFmposyiXB67dSfbbvPP7N/0sqBvz1FsBQ0nY=;
        b=plh8zFDHKB1ZxhtH/MX5Sd6TC/iRr8B8lvQVMETYMZTvs8rpEz+vLhCb6wdItCBon8
         upjM7vz4FYfd1A6aGbVG6mRXOHblkGiG8ApUapTZCQpBCgq8aCgMipZsdcITLpjLGKcL
         DYqee85C3++bpbkr8i0euyypTljdF0WpgcWuWNdYb6eDANjzizMtuUtvc/mmSo4hrLOt
         o4n2RUbcS+L0p023uiAdvwOObOyjBo3sAZdGMUNU20VeAbwbV7t30wIsFULPt6xxP3GF
         M1pJmyNHL6HCGHsUxh80OTgKLyZiTa+GXZdMJYK5+RotAwG+kG2voYmKqr7Mx5iocGU0
         HEYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776343244; x=1776948044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Gt5UxFqFmposyiXB67dSfbbvPP7N/0sqBvz1FsBQ0nY=;
        b=CBbhElCJUqKZ5l+9FgVjmzkEIJvR2uMPERqpjOa/peZJFIYMTBxo/wo9wlDY61Zw9D
         CAsVQM0H4bNNhg8pJnOBWmh29sj+tA8bTC0tRNRQqnnFP4seqm6L8inCik11NT+br7QI
         f70m1RlzXTDZNQzG/UaL/0rN92mJO/qfFTnD8q5zi2Fy/XhVLlvSuxc8DM/0vyYTv8zn
         fQ8fzattb15duER22d3PL1HWZOrpyisUloAjcVX/THjvrVudxsrv0/ChpuMlKTup4+uM
         oGJq59ZTk5tnF7bQcOZjl2K1dw0tZUYPqjDFIeelIaHTWWFcNWmHPCAGTMcpZjcncqKX
         IOLw==
X-Forwarded-Encrypted: i=1; AFNElJ8bqPBosjE4CA3U5+kkveGBkeanuI7qVuCiiQz5FmTW4EfHXT2ibh9Qtl0A785TV54vWRB2TQf/TsVo@vger.kernel.org
X-Gm-Message-State: AOJu0YyooSJkPHHYVbEDuqhkNvMT75f+Pw8ZiUd3r/1nr6PJPYg8nOms
	P7wuC3nuv8Um9y3KMwnZNcoa79c3go5P07CZe2hmiZ9Q8InsebQF0k6zLJc6p+2WpB8TRCJ+jOY
	X1pnHChIj394iIHU3YdrRRGgEEKeUhSw=
X-Gm-Gg: AeBDieveVvz6ww24w4Zfrw/QLJyM9Mr6BbhjxnWLLN+JU9iskpLkvyUQj5pRSGmkeY+
	a3OMi9Whp3PBlcsdVRd9JPG/MzLPRgMsIapM1efxV6cPZOk+ngyX8MiyNb6x+o7Xp/eTyrmTLBd
	bWIjJzkqcghcr7m7DmxbHuDvgYDfyyFyIFpEc24VbUCps6nEXOSyeGVGkx4uU0JE+XWGcrWo9mC
	08aU3i1550iBmuBhBh4IE6g+GY5hxmuJO+4vgczVM6HtpdEo8yigRYqcVMdL53+GqHCmzcEmRW0
	6AzG8KtN3c0Fn1KXDA==
X-Received: by 2002:a05:6000:2888:b0:43b:3d44:6624 with SMTP id
 ffacd0b85a97d-43d6427bad1mr38790937f8f.2.1776343242885; Thu, 16 Apr 2026
 05:40:42 -0700 (PDT)
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
In-Reply-To: <CAOLeWCtnZz=kHGk4C2f9Mbfi3tEBE100iCkMBhcG47dmR9eDWw@mail.gmail.com>
From: Demian Shulhan <demyansh@gmail.com>
Date: Thu, 16 Apr 2026 15:40:30 +0300
X-Gm-Features: AQROBzBfLRqpsaS7WIxbfvj5ZmxrkpyJ_BsR2KBilP4YLw0uKGQ6RYk7R3C9d8U
Message-ID: <CAOLeWCtxPk7q_bVvrcKaipSKr+_=57Auobcj0cFRvXxXMdH58g@mail.gmail.com>
Subject: Re: [PATCH v2] raid6: arm64: add SVE optimized implementation for
 syndrome generation
To: Christoph Hellwig <hch@lst.de>
Cc: Ard Biesheuvel <ardb@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Song Liu <song@kernel.org>, 
	Yu Kuai <yukuai@fnnas.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Mark Brown <broonie@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, robin.murphy@arm.com, 
	Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

Sorry for the delay. The tests became more complex than I initially
thought, so I needed to gather more data and properly validate the
results across different hardware configurations.

Firstly, I want to clarify the results from my March 29 tests. I found
a flaw in my initial custom benchmark. The massive 2x throughput gap on
24 disks wasn't solely due to SVE's superiority, but rather a severe L1
D-Cache thrashing issue that disproportionately penalized NEON.

My custom test lacked memset() initialization, causing all data buffers
to map to the Linux Zero Page (Virtually Indexed, Physically Tagged
cache aliasing). Furthermore, even with memset(), allocating contiguous
page-aligned buffers can causes severe Cache Address Sharing (a known
issue that Andrea Mazzoleni solved in SnapRAID 13 years ago using
RAID_MALLOC_DISPLACEMENT).

Because SVE (svex4) uses 256-bit registers on Neoverse-V1, it performs
exactly half the number of memory load instructions compared to 128-bit
NEON. This dramatically reduced the L1 cache alias thrashing, allowing
SVE to survive the memory bottleneck while NEON choked:

Custom test without memset (4kb block):
 | algo=3Dneonx4 ndisks=3D24 iterations=3D1M time=3D11.014s MB/s=3D7802.57
 | algo=3Dsvex4  ndisks=3D24 iterations=3D1M time=3D5.719s  MB/s=3D15026.92

Custom test with memset (4kb block):
 | algo=3Dneonx4 ndisks=3D24 iterations=3D1M time=3D6.165s  MB/s=3D13939.08
 | algo=3Dsvex4  ndisks=3D24 iterations=3D1M time=3D5.839s  MB/s=3D14718.23

Even with the corrected memory setup, the throughput gap narrowed, but
the fundamental CPU-efficiency result remained fully intact.

To completely isolate these variables and provide accurate real-world
data, the following test campaigns were done based on the SnapRAID
project (https://github.com/amadvance/snapraid) using its
perf_bench.c tool with proper memory displacement and a 256 KiB block
size.

Test configurations:
- c7g.medium (AWS Graviton3, 1 vCPU): Neoverse-V1, 256-bit SVE
- c7g.xlarge (AWS Graviton3, 4 vCPUs): Neoverse-V1, 256-bit SVE
- c8g.xlarge (AWS Graviton4, 4 vCPUs): Neoverse-V2, 128-bit SVE


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
Section 1: SnapRAID Validation on Graviton3 / Neoverse-V1
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D

These runs are the most representative userspace validation. The tests
were run with standard -O2 optimizations.

1.1 SnapRAID speedtest, O2, c7g.xlarge (Raw Throughput)

 disks  neonx4  neonx8   svex4  delta(nx4)  delta(nx8)
 -----  ------  ------  ------  ----------  ----------
     8   21394   21138   23601      +10.3%      +11.6%
    24   20368   19850   21009       +3.1%       +5.8%
    48   16727   19290   20222      +20.9%       +4.8%
    96   15562   18925   17549      +12.8%       -7.3%

1.2 perf_bench, O2, c7g.xlarge (Hardware Efficiency)

 disks  neonx4 inst  svex4 inst  reduction | neonx4 cyc  svex4 cyc | MB/s (=
N/S)
 -----  -----------  ----------  --------- | ----------  --------- | ------=
-----
     8       4.02 B      2.61 B     -35.1% |     1.01 B     0.92 B | 20304/=
22346
    24      12.16 B      8.00 B     -34.2% |     3.20 B     3.11 B | 19354/=
19933
    48      24.37 B     16.08 B     -34.0% |     7.73 B     6.51 B | 16048/=
19047
    96      48.80 B     32.24 B     -33.9% |    16.94 B    15.11 B | 14638/=
16421

1.3 Main Graviton3 Conclusions
 - On 256-bit SVE hardware, svex4 consistently retires about ~34% fewer
   instructions and ~10-15% fewer CPU cycles than neonx4.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
Section 2: SnapRAID Validation on Graviton4 / Neoverse-V2
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D

2.1 SnapRAID speedtest, O2, c8g.xlarge (Raw Throughput)

 disks  neonx4  neonx8   svex4  delta(nx4)  delta(nx8)
 -----  ------  ------  ------  ----------  ----------
     8   24802   25409   20451      -17.5%      -19.5%
    24   22607   24026   18577      -17.8%      -22.7%
    48   20984   22171   18019      -14.1%      -18.7%
    96   21254   21690   17108      -19.5%      -21.1%

2.2 perf_bench, O2, c8g.xlarge (Hardware Efficiency)

 disks  neonx4 inst  svex4 inst   overhead | neonx4 cyc  svex4 cyc | MB/s (=
N/S)
 -----  -----------  ----------  --------- | ----------  --------- | ------=
-----
     8       4.02 B      5.22 B     +29.9% |     0.95 B     1.14 B | 23529/=
19512
    24      12.16 B     15.98 B     +31.4% |     3.11 B     3.79 B | 21621/=
17777
    48      24.37 B     32.12 B     +31.8% |     6.70 B     7.81 B | 20000/=
17204
    96      48.78 B     64.40 B     +32.0% |    13.24 B    16.32 B | 20253/=
16410

2.3 Main Graviton4 Conclusions
 - On Neoverse-V2, SVE vector length is 128-bit (same as NEON).
 - Without the 256-bit width, NEON outperforms SVE.
 - svex4 retires ~32% MORE instructions here and is consistently slower.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
Section 3: Validation on c7g.medium (1 vCPU)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D

3.1 SnapRAID speedtest, O2, c7g.medium (Raw Throughput)

 disks  neonx4  neonx8   svex4  delta(nx4)  delta(nx8)
 -----  ------  ------  ------  ----------  ----------
     8   16768   17466   17310       +3.2%       -0.9%
    24   15843   16684   16205       +2.3%       -2.9%
    48   14032   14475   15389       +9.7%       +6.3%
    96   13404   13045   14677       +9.5%      +12.5%

3.2 perf_bench, O2, c7g.medium (Hardware Efficiency)

 disks  neonx4 inst  svex4 inst  reduction | neonx4 cyc  svex4 cyc | MB/s (=
N/S)
 -----  -----------  ----------  --------- | ----------  --------- | ------=
-----
     8       3.99 B      2.61 B     -34.6% |     1.30 B     1.25 B | 16000/=
16666
    24      12.13 B      8.00 B     -34.0% |     4.08 B     4.02 B | 15189/=
15483
    48      24.34 B     16.08 B     -33.9% |     9.23 B     8.35 B | 13445/=
14860
    96      48.76 B     32.24 B     -33.9% |    19.34 B    17.92 B | 12834/=
13852

3.3 Main c7g.medium Conclusions
 - The instruction count reduction (~34%) perfectly matches the 4-vCPU
   instance.
 - The single vCPU is heavily memory-bandwidth constrained (cycle counts
   are much higher waiting for RAM).

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
Section 4: The Pitfalls of the Current Kernel Benchmark
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D

As Christoph pointed out, the current in-kernel benchmark setup
(hardcoded to 8 disks and a PAGE_SIZE buffer) can be not representative
of real-life arrays.

Because 8 disks * 4 KiB =3D 32 KiB total data, the entire benchmark fits
into the 64 KiB L1 D-Cache of Neoverse-V1, masking memory bandwidth limits
and register spilling. This leads to objectively wrong selections.

---------------------------------------------------
Case 1: Wrong NEON unrolling selection (Graviton3)
--------------------------------------------------
The kernel benchmark tests 8 disks and locks in neonx4. However, on
real-world wide arrays (48-96 disks), neonx8 is significantly faster.

 disks     neonx4 MB/s    neonx8 MB/s    Actual Winner  Kernel's Choice
 --------  -------------  -------------  -------------  ---------------
  8 (Boot) 21,394         21,138         neonx4         neonx4 (Locked)
 48        16,727         19,290         neonx8         neonx4 (-15.3%)
 96        15,562         18,925         neonx8         neonx4 (-21.6%)

Result: Users lose up to 21% NEON throughput because of the 8-disk test.

---------------------------------------------------
Case 2: Wrong SVE vs NEON selection (Graviton3)
--------------------------------------------------
If SVE is enabled, the 8-disk benchmark strongly prefers svex4. But on
extreme wide arrays (96 disks), the heavily unrolled neonx8 actually
overtakes SVE.

 disks     neonx8 MB/s    svex4 MB/s     Actual Winner  Kernel's Choice
 --------  -------------  -------------  -------------  ---------------
  8 (Boot) 21,138         23,601         svex4          svex4 (Locked)
 96        18,925         17,549         neonx8         svex4 (-7.8%)

Result: On extreme workloads, forcing svex4 loses ~7.8% throughput.

Conclusion: The kernel benchmark requires testing with larger buffers
(exceeding L1 capacity) or simulated wide arrays to guarantee the optimal
algorithm is chosen for actual storage workloads.

---------------------------------------------------
Case 3: Buffer size distortion (Graviton3, 8 disks)
---------------------------------------------------
Even on the exact same 8-disk array, testing with a 4 KiB buffer (which
fits entirely in the L1 cache) yields a completely different winner than
testing with 256 KiB buffer (which exercises L2/L3/RAM).

 buffer      neonx4 MB/s    svex4 MB/s     Actual Winner  Kernel's Choice
 ----------  -------------  -------------  -------------  ---------------
 4 KiB       20211          19818          neonx4         neonx4 (Locked)
 256 KiB     21394          23601          svex4          neonx4 (-9.3%)

Result: By benchmarking exclusively in the L1 cache (4 KiB buffer), the
kernel incorrectly chooses neonx4, losing ~9.3% throughput for
larger I/O block sizes.


Thanks again for your time and review!

=D0=B2=D1=82, 31 =D0=B1=D0=B5=D1=80. 2026=E2=80=AF=D1=80. =D0=BE 16:18 Demi=
an Shulhan <demyansh@gmail.com> =D0=BF=D0=B8=D1=88=D0=B5:

>
> Hi all,
>
> Ard, your questions regarding real-world I/O bottlenecks and SVE power
> efficiency versus raw throughput are entirely valid. I agree that
> introducing SVE support requires solid real-world data to justify the
> added complexity.
>
> Due to my current workload, I won't be able to run the necessary
> hardware tests and prepare the benchmark code immediately. I will get
> back to the list in about 1 week with the requested source code,
> unmangled test results, and further analysis.
>
> Thanks!
>
>
> =D0=B2=D1=82, 31 =D0=B1=D0=B5=D1=80. 2026=E2=80=AF=D1=80. =D0=BE 09:37 Ch=
ristoph Hellwig <hch@lst.de> =D0=BF=D0=B8=D1=88=D0=B5:
> >
> > On Mon, Mar 30, 2026 at 06:39:49PM +0200, Ard Biesheuvel wrote:
> > > I think the results are impressive, but I'd like to better understand
> > > its implications on a real-world scenario. Is this code only a
> > > bottleneck when rebuilding an array?
> >
> > The syndrome generation is run every time you write data to a RAID6
> > array, and if you do partial stripe writes it (or rather the XOR
> > variant) is run twice.  So this is the most performance critical
> > path for writing to RAID6.
> >
> > Rebuild usually runs totally different code, but can end up here as wel=
l
> > when both parity disks are lost.
> >
> > > > Furthermore, as Christoph suggested, I tested scalability on wider
> > > > arrays since the default kernel benchmark is hardcoded to 8 disks,
> > > > which doesn't give the unrolled SVE loop enough data to shine. On a
> > > > 16-disk array, svex4 hits 15.1 GB/s compared to 8.0 GB/s for neonx4=
.
> > > > On a 24-disk array, while neonx4 chokes and drops to 7.8 GB/s, svex=
4
> > > > maintains a stable 15.0 GB/s =E2=80=94 effectively doubling the thr=
oughput.
> > >
> > > Does this mean the kernel benchmark is no longer fit for purpose? If
> > > it cannot distinguish between implementations that differ in performa=
nce
> > > by a factor of 2, I don't think we can rely on it to pick the optimal=
 one.
> >
> > It is not good, and we should either fix it or run more than one.
> > The current setup is not really representative of real-life array.
> > It also leads to wrong selections on x86, but only at the which unroll
> > level to pick level, and only for minor differences so far.  I plan
> > to add this to the next version of the raid6 lib patches.
> >
