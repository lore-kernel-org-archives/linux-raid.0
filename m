Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65013AA1A8
	for <linux-raid@vger.kernel.org>; Tue, 31 Mar 2026 13:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774963146; cv=pass; b=GUU9mWrEC6GDtn+jn0sGpaJz8ChndCUtRqPWrrcJPao+aNfcCY0wKhRAvInfueNHcx7alPYDbzR9fX4mVlV9g+Am8AKJuxZOGM+b/jgdPJMJzzleawx9ygdaosFw3gmiS9lxSLN0yivAhO9LsyiwWFixwZ9k/mutvsclCkWEBl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774963146; c=relaxed/simple;
	bh=7rT+I8QyDXF9Df6dugoNHHmyTj2ADKqONGvQ0fTSM+s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EoUQ5nBsTy9T5pnCj9Jdja0XbEsYT0SmL6f4hpCRe1uyhF5VvjK9dtyKSJFFP8Aam2G0Lk8HnX8g7uUDJLZ2HfahcvrHM9jHx3zwZgQl4ExdN0MPd17cvUu2rm0G8042yPjBj1uVfm1Gt6L/i7m1UJUq2SpPXPP2VeAZMyc2FFI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mBFaAFx3; arc=pass smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mBFaAFx3"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43cfd832155so1455396f8f.1
        for <linux-raid@vger.kernel.org>; Tue, 31 Mar 2026 06:19:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774963143; cv=none;
        d=google.com; s=arc-20240605;
        b=X65GgYsAva25v7hnEY+m7xP/jQEoWUPopI4qQiP25hZ8hK2+cSfmnqRRQ1GETEDlN3
         pVY1qyW3Lx3JxbmwjhNU/7YYvs9VPkMmeDY/nZye5Jp8jCMq7PYTaTluiiGR9iQ3UC8G
         3Diqq9/ensmq5/ZdFzCVblGErTVT/BNe4zhJr7lBHrxqRagvwsKMU1Zk/gdBDt9Qb2Rq
         uPdgVpe2TBUZ3tCjlyM64Va1V59klu3KIHrwPsFQIsJjX8nzvIKHOHbw10xIjs3Wk2of
         BytNYt6q9/KOECXmukU7DkD/Rxlm8v04HjP1KZM6apGLtTYvrtWGo/KJGM+mERsgqRR/
         BEwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lyzcvyaYCGVUi9yrNol1TrvSRR8R4hP2IEaQrhe4x1w=;
        fh=dph0DahXSxjpM3mbBlJ/b2U3+dwFxzjE8WAQm0LJiZY=;
        b=kUq8FfwkURoXXTz7nnl/jKkzy4io0LwuZzKsMbAi3pMUfJe6QyIuf11qfE9RFJDjoT
         /A69mQdmaOCPhFOECqc16U9da236QSyCzzqjrhL5i3Kf7QORE6KdFageIIS8l+Lk38qY
         Ne/kipCVP0zIUbo9wC2fyJjDsklVjSLMIuGKlVQs+SycHaocQn2G/3lOtGldC41OchfI
         D03lcHWBGd7q0dSvn7oym/4ELjTvIeZPK4qekMlsCjCc81B5s/lDZ71lcL8+Ji1IddTu
         /CzhLAZAp56xrQn9ETTxYW5aSPv9+W89PAhLDlw8G7THvVXpizI2+b1D0ZyqtsDZ8Qdw
         TetQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774963143; x=1775567943; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lyzcvyaYCGVUi9yrNol1TrvSRR8R4hP2IEaQrhe4x1w=;
        b=mBFaAFx3Ysrf8oEpzP5DmTgyWlJxCjxJ8yLkXMiCyEjHLvLxqsai1UmwV3BOMxGXq+
         WgLmrdLwU4DFKIDlLB17my8O0vF7B6JLfELRjw8URMSc4uY8LS57ErvqYefRyJPRegOb
         ZYoXPNR2WUJbsNVQ8wOn72PtjzE7Lw0oIWT/J/VmFiwoKOTLPQXSFnAyCHJUeXASG6Tr
         CM6y03O5POn+JUFsTNDX5TzqXq1w0X/yMQ7tCvcr1yV+YVczVT6JZ4HVcnc+SwsmLvGc
         Wg9wZt/tT+75MG6O3HvmErsfHhVsSw6z9ZCX8utIGdgrjlOGqdVTZBW3CNcyGSSB6WKi
         nUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774963143; x=1775567943;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lyzcvyaYCGVUi9yrNol1TrvSRR8R4hP2IEaQrhe4x1w=;
        b=tEKUyexcqnGpSt8MaxP8YNnF68VMJjUe5RYjjZ1VF2nmbAlyGHImTdMtdVuCw/ITJr
         iatmofjCH0kXrfPxYBPSmCbUN09BYDTVVbxZuxeDHTR9aP/DVPG0ZMj6v36XsqhgoKRQ
         zndYbACZc4BxgSktYxsGYwGvqG+d5LFnKvdqBJUUYq/BL0Y4TCEZYhaYRwoQDx8k3EL3
         WilxG50pzzU9D7Db4qCWLDZLnhGTRTK/DhbRz63Y8esM6deKJOE9kWVwm7hgMZm8DaCB
         QXntdvcLUNl6DLLJ0jh5OP6ToocwWroUXPs4uMqqupV/B9IDuT+Cus1bkqyN8DrS6V6j
         6Itg==
X-Forwarded-Encrypted: i=1; AJvYcCXv2UNc0Jcr658TSvjycYSx1DBOISmGUyuvXUfBvdUjgJBU2Ax2JbEFV2ieYbP3sTrVgSSem8uTVjsk@vger.kernel.org
X-Gm-Message-State: AOJu0YzCE3/bMdII/zQdstndiko4b+3rG0FjbvXaw5xPk2qXX7gU7PP7
	0hImlRwEmZBR8jwjyyulLqJVTtkXJBNjiESmxTlRG7vTCDj3LUQdhmh2pGYc+k1jRWIh3L/uVpX
	0zimNKTXcqO468GvbBiBKY220HjWbmIM=
X-Gm-Gg: ATEYQzwtuwusNPJWzRktTdYP5FrFgkt80FM2jdX6TaOv68rxb2UsZb6pseflpQ1lF59
	A+Ogp7wOToOP5pfxXEBQFs31nZy6Q5PtYr8C42j5Q9fDGuDiIypPAHE/AMTx7u5uaotWKINpA5c
	k5Z5rWvmmAGBpTmCP+xHPOWAlTefdUEGAuRtf6pT+RhtC9SVJdwQBsdhlHgW1NMeaLtiQnLcZ14
	AtjFqPpC8W4t7xpS4UM+qE/FjaqGf1iOnql5GhOOd9YrO5qdbUYuz4J9HYJbJaoLuoy6XrQxjbT
	Hm1jDOY=
X-Received: by 2002:a05:6000:26ce:b0:43b:3e34:7fe with SMTP id
 ffacd0b85a97d-43b9e9e8cf7mr28614862f8f.21.1774963142825; Tue, 31 Mar 2026
 06:19:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260318150245.3080719-1-demyansh@gmail.com> <f9bc0534-4b7a-4b14-974b-4d7811ccd899@app.fastmail.com>
 <acJhCCPfVxjFUZ5R@J2N7QTR9R3> <CAOLeWCsxhzdxQviizJ4X4VOp_28LCtO-RjWoCcZG29rQw86NVg@mail.gmail.com>
 <9a12e043-8200-4650-bfe2-cbece57a4f87@app.fastmail.com> <20260331063659.GA2061@lst.de>
In-Reply-To: <20260331063659.GA2061@lst.de>
From: Demian Shulhan <demyansh@gmail.com>
Date: Tue, 31 Mar 2026 16:18:51 +0300
X-Gm-Features: AQROBzBaGepPtd_VWMHro3KW-LD9dB2qVKP_uq1I2sDMcGkC9q030qEeq5iFVi0
Message-ID: <CAOLeWCtnZz=kHGk4C2f9Mbfi3tEBE100iCkMBhcG47dmR9eDWw@mail.gmail.com>
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

Ard, your questions regarding real-world I/O bottlenecks and SVE power
efficiency versus raw throughput are entirely valid. I agree that
introducing SVE support requires solid real-world data to justify the
added complexity.

Due to my current workload, I won't be able to run the necessary
hardware tests and prepare the benchmark code immediately. I will get
back to the list in about 1 week with the requested source code,
unmangled test results, and further analysis.

Thanks!


=D0=B2=D1=82, 31 =D0=B1=D0=B5=D1=80. 2026=E2=80=AF=D1=80. =D0=BE 09:37 Chri=
stoph Hellwig <hch@lst.de> =D0=BF=D0=B8=D1=88=D0=B5:
>
> On Mon, Mar 30, 2026 at 06:39:49PM +0200, Ard Biesheuvel wrote:
> > I think the results are impressive, but I'd like to better understand
> > its implications on a real-world scenario. Is this code only a
> > bottleneck when rebuilding an array?
>
> The syndrome generation is run every time you write data to a RAID6
> array, and if you do partial stripe writes it (or rather the XOR
> variant) is run twice.  So this is the most performance critical
> path for writing to RAID6.
>
> Rebuild usually runs totally different code, but can end up here as well
> when both parity disks are lost.
>
> > > Furthermore, as Christoph suggested, I tested scalability on wider
> > > arrays since the default kernel benchmark is hardcoded to 8 disks,
> > > which doesn't give the unrolled SVE loop enough data to shine. On a
> > > 16-disk array, svex4 hits 15.1 GB/s compared to 8.0 GB/s for neonx4.
> > > On a 24-disk array, while neonx4 chokes and drops to 7.8 GB/s, svex4
> > > maintains a stable 15.0 GB/s =E2=80=94 effectively doubling the throu=
ghput.
> >
> > Does this mean the kernel benchmark is no longer fit for purpose? If
> > it cannot distinguish between implementations that differ in performanc=
e
> > by a factor of 2, I don't think we can rely on it to pick the optimal o=
ne.
>
> It is not good, and we should either fix it or run more than one.
> The current setup is not really representative of real-life array.
> It also leads to wrong selections on x86, but only at the which unroll
> level to pick level, and only for minor differences so far.  I plan
> to add this to the next version of the raid6 lib patches.
>
