Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C752882A9
	for <linux-raid@vger.kernel.org>; Tue, 10 Jun 2025 22:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749592827; cv=none; b=nEyBT3IQckSqXTPoU9++RXoEzQtcgW67q+8v1csfx+QL34hjHrD8pVP77Pav4x0Dwu3xt9uvsuzwlQCl8tzJTywcMNN5mgYClRoESBF2D7NVTAe1rPlNNVAR3XoV6TakWvvPTJZy6RFoz8WiD8aS5lpbIFESjI+yPXRO7HsWarw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749592827; c=relaxed/simple;
	bh=pTiM9bJvPjnlaFYkxrDbLpKWeiHciRh2fI7Hta0Crmo=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=Bl9IQ8KYVdGFs5GjlxAaaoIVVJw3zKwRQleX7lMrF2p8GgbCS0mQmABPPwk4nv0fSOuLZMYSBPxXFQ54xI9rS7sqgtxA4THTP8MQ780CQJziyESWOZeSv7RmFUszmqx3zmmGDWp68TtTIdZla5OOGUnKdEycvfm6r8dFHMF83f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=Je7iSVtB; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="Je7iSVtB"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7399a2dc13fso6578043b3a.2
        for <linux-raid@vger.kernel.org>; Tue, 10 Jun 2025 15:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1749592825; x=1750197625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fbom0xG9ol+fr/AajJO7nHL/1uYibOAQ7MGdWD28twQ=;
        b=Je7iSVtBq516YyUAh8zC4wSXYMUOveSCPJLEql4PPxZj+hWcVlSgXKdvEAHKN9Bgzn
         mnxtoDeE+JupVws85vcQt4M/2X++sq+gAXdHEg0fGbGLUazBWOAIN0+vKH4MXMKYOPO6
         6lQfQzykpEmoJ+jz9GAslSGKMNM82vYYbJd6ucUlwVYsw85ZcMv7738AUnk1GFFL+/Qx
         1TlJmHYmQbtEwXEEu/sboFPWdGYyCgJG3Jlij7dCGMS4eXwlvdBSV7Lk1v0axpyWrNho
         b+W2qm1vH841dUnSCjwvuP/u/t+BbaURUuRfb0A/93SOCzXMO9Xq0YyIUqDRVZbTJpbB
         ft+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749592825; x=1750197625;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fbom0xG9ol+fr/AajJO7nHL/1uYibOAQ7MGdWD28twQ=;
        b=MXtyT5iLfZxPsyJVRYtcwxLKSSaT/eeQQfFr977fiSuVzL/qXt399NJRZ2XYMqDFUR
         TAmHWKswdiS+8tCIYdI4Zp90spIQYxxivzBJpMqJdNVPUrnmCkzUfuhLnBYN+UTelNY0
         Wd89ioH1UMXzfam7tNRi/I43LGZ7IkaaTUgTRinakk0/IDekg9sqLngCChYYCG/2FA9b
         LIwc60nsT/rGCbtF+AFq2/zVdpXnKge4H6BiLp4h8VQwHlH1C2mJnFSzFMjPcbMwU5bA
         /Ht8oWgrM3Mb5Fyr1187HN9+n8AxSzPa8YNbbVEYRZXzOp8TSBrXM377YmJwcDNY4gtG
         0ODg==
X-Forwarded-Encrypted: i=1; AJvYcCW32zjIvuxs3UMSdshjh0iYQj4RPIYJ5rC0/CAcT+zjL8SqEzd/jx3MCi8aGdm/1WxvMBikpSNoJ6Hh@vger.kernel.org
X-Gm-Message-State: AOJu0YzM8kW66a5sKVMk+IHm7DWZNxBjaRKaphQmKEMK2iXImC1tMw5c
	WNhv3iKt6lY7wRG0+E8mHLF/TSJ/e7qCtf6Q8FvuMzqX11ubTwq8H9UTc8DbpOdyzOM=
X-Gm-Gg: ASbGnctxIWd5Rs0EIuNdBxsStFXaDvKHoHncKzX1XNjqc2f+bFZFVjAuodCa4p1mWpq
	mqyxm0RMLvgvSn1yvL7wJt/BKgdnvDEiKUwXOSOYxIqD/oVcfHR3P27LHO9h0HeAcKgA/mmdf5p
	ryUkDfUflG2LdoQmmiizy8T6IDPfSa3t74TpuiveCgAwLjLv1t/2fcJEdPWHBdInybUz2/OdAOQ
	q0sJZaG4L47ABrNVpPiGlohDIX7y38oDMCw8feTHSDsIn0PeIvTcjXhfjSAkBF9NXJ7tRdZPxZm
	T2CTEKnO7S17CnT4fcHMYQCvGbrD+8EtROxrmnqWhZ4cXwIMJqBTzu7eoVWr
X-Google-Smtp-Source: AGHT+IGD3U6t86T21li6GwG2NgEvYoKN8WsucswfC21Sdfl2qIBCx1kf6qW6YPkuGZVyS6OyrNQOlQ==
X-Received: by 2002:a05:6a00:848:b0:73e:598:7e5b with SMTP id d2e1a72fcca58-7486facfb03mr502222b3a.1.1749592825023;
        Tue, 10 Jun 2025 15:00:25 -0700 (PDT)
Received: from localhost ([2620:10d:c090:500::7:116a])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-7482b0ea2a7sm7897643b3a.156.2025.06.10.15.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jun 2025 15:00:24 -0700 (PDT)
Date: Tue, 10 Jun 2025 15:00:24 -0700 (PDT)
X-Google-Original-Date: Tue, 10 Jun 2025 15:00:11 PDT (-0700)
Subject:     Re: [PATCH 0/4] Fix a segmentation fault also add raid6test for RISC-V support
In-Reply-To: <d052f010-410a-4405-9ae6-f679649851ea@ghiti.fr>
CC: zhangchunyan@iscas.ac.cn, Paul Walmsley <paul.walmsley@sifive.com>,
  aou@eecs.berkeley.edu, Charlie Jenkins <charlie@rivosinc.com>, song@kernel.org, yukuai3@huawei.com,
  linux-riscv@lists.infradead.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, zhang.lyra@gmail.com
From: Palmer Dabbelt <palmer@dabbelt.com>
To: Alexandre Ghiti <alex@ghiti.fr>
Message-ID: <mhng-D97D0B5D-7948-49C6-8F55-C0836E41DA3C@palmerdabbelt-mac>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Tue, 10 Jun 2025 12:23:18 PDT (-0700), Alexandre Ghiti wrote:
> Hi Chunyan,
>
> On 6/10/25 12:12, Chunyan Zhang wrote:
>> The first two patches are fixes.
>> The last two are for userspace raid6test support on RISC-V.
>>
>> The issue fixed in patch 2/4 was probably the same which was spotted by
>> Charlie [1], I couldn't reproduce it at that time.
>>
>> When running raid6test in userspace on RISC-V, I saw a segmentation fault,
>> I used gdb command to print pointer p, it was an unaccessible address.
>
>
> Can you give me your config, kernel and toolchain versions? I can't
> reproduce the segfault on my machine.

It's probably going to be super fragile to reproduce.  The code is just 
scrubbing over t0 without a clobber, so it's just going to break stuff 
somewhat arbitrarily.

>
> Thanks for the fixes and the test, I'll take a look this week.
>
> Alex
>
>
>>
>> With patch 2/4, the issue didn't appear anymore.
>>
>> [1] https://lore.kernel.org/lkml/Z5gJ35pXI2W41QDk@ghost/
>>
>> Chunyan Zhang (4):
>>    raid6: riscv: clean up unused header file inclusion
>>    raid6: riscv: Fix NULL pointer dereference issue
>>    raid6: riscv: Allow code to be compiled in userspace
>>    raid6: test: add support for RISC-V
>>
>>   lib/raid6/recov_rvv.c   |  9 +-----
>>   lib/raid6/rvv.c         | 62 +++++++++++++++++++++--------------------
>>   lib/raid6/rvv.h         | 15 ++++++++++
>>   lib/raid6/test/Makefile |  8 ++++++
>>   4 files changed, 56 insertions(+), 38 deletions(-)
>>
