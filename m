Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687AE21B19E;
	Thu,  8 May 2025 07:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746688530; cv=none; b=IRRggk1yc5WLcivWJqJm7MtR8OY1yKLc95+3pFnx5oCs76TxYK8930VliSo9HbN6C5NlVqHAXUMbJ/wToLUQUA66LfwWDPv0Aj6OFkZOpywy5N5JceUUNF2cnDdDoQchLE/wDf5R7YSvI0DpH6yK4njwu9rSDZ47XvF/ehio+UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746688530; c=relaxed/simple;
	bh=9CJgYF+m7a3hBLPx/CB3JOZ6LoM9LEM8RXJiBJ1Ob3s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KVEJD3ckJYqdYVnNLSe2+OS+Mi0EN2SuB5wGqFo486aXQLXdtsCcYjg+Y1QTVUAOuD93iL9G9h8lDYrpaC2VRIdQx9To7CKcpeoYzqMUmcglUlsEZAaqjs/elQVgrmGzAVdN+h10mCKN+ExMc7/pAx5BdVXlTOKezKBjfx2XEEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PYcQsW0z; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PYcQsW0z"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-60638c07cabso432548eaf.3;
        Thu, 08 May 2025 00:15:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746688527; x=1747293327; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+6hEwmNbvDrX8ZUAsqAq49EAFin/5oOteZQpulus6Tc=;
        b=PYcQsW0z2SzPRJOFPnAe8d+NtMLEt/ez8fmIVKYcgi23rEhw2LAVxoxX1q0HZY2ZKG
         i+OmdrLoRYHdYlYWapjgh4O/RZcCum0HXfiu/5GP2G4xkpaxTlIgKatiBXPGz3lHId7j
         wyxy/Cy78lYvMiz4uYKkpeL9wxWxuTBipAXadU7OrupK4QAkeJ2yIqnMNyNItv3XCxW/
         GFbw5QjbsRK9Xu37MvQsqlucJPjr8cKVCF7vNVmXvGXXK547hqurAKGtaZ6+Cbg17vKH
         ogjX4FcbrGzRs5uuzSyll49H3cpP8X6ZYtCKrjOSUAXGd/CC/a54uM5HaTTWhGM9tt5O
         4Avg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746688527; x=1747293327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+6hEwmNbvDrX8ZUAsqAq49EAFin/5oOteZQpulus6Tc=;
        b=wlXIAA/2oxFV5CxkSaVpTEPECRR2FcKHJL/WzYTUuD11nKU2nvt0guszzK8lZrixhj
         3Xe4kfHRsDAiQuHdclxKdabVuQlnnvl0RneOqcv1DAfCkS52rX2zKp6wVSEbvEk6uYdb
         O8EJcMuB/f+h7YnoYksai5WY9bzT+4Qvu0J1j7ahOBg8uR/JJxOZyzSqafyqkEwQZvf0
         TbkInmset8SDGRe3jWXyybooUSkgGy61h2vJeWCHXX1QSMmUICt8DCyMD5Jm1c+d16Z9
         kmVgPIPSbR3KpETUyhaocs2SqRRtrcDgdhyTDuFB4HdJoQwXIQcROVIRm4pfpt7Mgmqe
         t4yA==
X-Forwarded-Encrypted: i=1; AJvYcCU/aCStPBb9POatu5vYaMUd6IDLiENMH7LwBdbUCWPT1Upz58Sbmt43kJ0XbN0eC74hBmtRz26FH34+Zg==@vger.kernel.org, AJvYcCWmUnH09k5GwhhA64CSceHFCmD6hp9rQ5FMoWu2qDi67haz+sJY91lqTjLxrg6NQ2Yl9xvKCQ406sjHp1s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwRL1IQNQd/y9jhQGu4dRyqdGoZ3ooJchI4mZCLSdvHId57FDRg
	RM76Z2sMcd94la7hDEe2jiEfLjZ3Yd8KNPD7tnDE3S8J76KOX9Q2L5NWxpUkzGQCv4gZxwvJAcP
	AHx+fEu4wBSEyHmG0YFtdVVFpZGU=
X-Gm-Gg: ASbGncvKL1becr6Tp0tUzOhv9MuF+/odbdr9fPCYvOh+vWGWjAATsHod723TmMEgaBu
	oLnGzxAtOzdZzMMX9/JV4ePW3/6u9Ot5DqjIYWk8f814v3xNfyX0vFDN9LbW9ikmW65NdW16FE4
	wx7LCdS8lXGYiX7Ny3irMwKr5DOHOmR+TkWCktZLBu8nZ626jemtxWoQ==
X-Google-Smtp-Source: AGHT+IH2EyRJKsRob0eFF+uoEduxPFeAuaPWyoQOX+ekx3T7de4gceRUCwFsPI+rPxKDLq8u+Ohe4WJ4VNimGAumXD4=
X-Received: by 2002:a05:6820:203:b0:607:e15c:be07 with SMTP id
 006d021491bc7-60828d4dcf9mr4371937eaf.7.1746688527253; Thu, 08 May 2025
 00:15:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250305083707.74218-1-zhangchunyan@iscas.ac.cn> <mhng-63c49bc7-0f86-47f7-bc41-0186f77b9d6f@palmer-ri-x1c9>
In-Reply-To: <mhng-63c49bc7-0f86-47f7-bc41-0186f77b9d6f@palmer-ri-x1c9>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Thu, 8 May 2025 15:14:50 +0800
X-Gm-Features: ATxdqUHZ_WeGypQ24ll_k9Tlw-2jyRAQMCglZpNZhX8QH-tmXjBcBV4g9oFBEAg
Message-ID: <CAAfSe-vD_37uihLjGwOqQKnyKJaJ36OwxDeocMOhK4s6-cpzAA@mail.gmail.com>
Subject: Re: [PATCH V5] raid6: Add RISC-V SIMD syndrome and recovery calculations
To: Palmer Dabbelt <palmer@dabbelt.com>
Cc: zhangchunyan@iscas.ac.cn, Paul Walmsley <paul.walmsley@sifive.com>, 
	aou@eecs.berkeley.edu, Charlie Jenkins <charlie@rivosinc.com>, song@kernel.org, 
	yukuai3@huawei.com, linux-riscv@lists.infradead.org, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Palmer,

On Mon, 31 Mar 2025 at 23:55, Palmer Dabbelt <palmer@dabbelt.com> wrote:
>
> On Wed, 05 Mar 2025 00:37:06 PST (-0800), zhangchunyan@iscas.ac.cn wrote:
> > The assembly is originally based on the ARM NEON and int.uc, but uses
> > RISC-V vector instructions to implement the RAID6 syndrome and
> > recovery calculations.
> >
> > The functions are tested on QEMU running with the option "-icount shift=0":
>
> Does anyone have hardware benchmarks for this?  There's a lot more code
> here than the other targets have.  If all that unrolling is necessary for
> performance on real hardware then it seems fine to me, but just having
> it for QEMU doesn't really tell us much.

I made tests on Banana Pi BPI-F3 and Canaan K230.

BPI-F3 is designed with SpacemiT K1 8-core RISC-V chip, the test
result on BPI-F3 was:

  raid6: rvvx1    gen()  2916 MB/s
  raid6: rvvx2    gen()  2986 MB/s
  raid6: rvvx4    gen()  2975 MB/s
  raid6: rvvx8    gen()  2763 MB/s
  raid6: int64x8  gen()  1571 MB/s
  raid6: int64x4  gen()  1741 MB/s
  raid6: int64x2  gen()  1639 MB/s
  raid6: int64x1  gen()  1394 MB/s
  raid6: using algorithm rvvx2 gen() 2986 MB/s
  raid6: .... xor() 2 MB/s, rmw enabled
  raid6: using rvv recovery algorithm

The K230 uses the XuanTie C908 dual-core processor, with the larger
core C908 featuring the RVV1.0 extension, the test result on K230 was:

  raid6: rvvx1    gen()  1556 MB/s
  raid6: rvvx2    gen()  1576 MB/s
  raid6: rvvx4    gen()  1590 MB/s
  raid6: rvvx8    gen()  1491 MB/s
  raid6: int64x8  gen()  1142 MB/s
  raid6: int64x4  gen()  1628 MB/s
  raid6: int64x2  gen()  1651 MB/s
  raid6: int64x1  gen()  1391 MB/s
  raid6: using algorithm int64x2 gen() 1651 MB/s
  raid6: .... xor() 879 MB/s, rmw enabled
  raid6: using rvv recovery algorithm

We can see the fastest unrolling algorithm was rvvx2 on BPI-F3 and
rvvx4 on K230 compared with other rvv algorithms.

I have only these two RVV boards for now, so no more testing data on
more different systems, I'm not sure if rvv8 will be needed on some
hardware or some other system environments.

Thanks,
Chunyan
