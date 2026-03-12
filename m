Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A988383C75
	for <linux-raid@vger.kernel.org>; Thu, 12 Mar 2026 08:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773304746; cv=none; b=PrmqdAUHYlM8yBYDXaUGjrZ1VX9YAde7bwMXRQvbdFHiKxc3jQMM12UAaAJ4yE1RxPcqq0U0jaIrOgd5m25pmx+wXyQ8FSI39q9tmgMcPdEKDmf5uC5q1mtBQiChC1lGJMJwMFJikiMqAIUdHPu97vjmrMu1Evaal55w3wH/6lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773304746; c=relaxed/simple;
	bh=2rASbAMEw5ZRlubXhkcWPIGmcIGEBmzjA5ymOU3qhqE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YaPRsyty0DZD/K9QkaF7W1wvkcY2xk4l5R2Gx2i4VSRTHu26GQiZmHV4ceZy8NCPO3n4wMMtkfyq1DoEThJ9KyQE2qckv3yRO6OxvrRsLxmWGFVJmXSHOTYNGF2A0HRYRRujyeyR8QLDzWBgHRPxRjCdmwGL/+lLLlAPQ5qM2Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wj+rWY6m; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wj+rWY6m"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4852fdb36a8so7910545e9.2
        for <linux-raid@vger.kernel.org>; Thu, 12 Mar 2026 01:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773304736; x=1773909536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tXrAFYR5bIhSumOFjuc1G0swOeqj6K0Pq1d0oWdhjWU=;
        b=Wj+rWY6m6+UCfo2x6AIjTqdw9g4ImHxiulaT1RQNuBOH7Wi+or6HuP175SMxDPofb/
         0376Rddavr2FkBzhUM+dzwRfAtr2UHVpIHWK9TPE6PQsJVgW4HCASac/7ZOSZ9Ou5ano
         16E3zcEXnQ0/A2y27KVdOIADss3J/fB3GsjHarBVmVx9BCxOh1aWg5dMH5Enxd/Nb46W
         9AglMk8NL68i2W2cAncjuexUGaJ3jPDvt4O4XdErAcXqflOZ16c6cxTL3c3uCUoxDSXb
         971dm2O+mnDzK7t4q2fa1HFxJZ+rEQUnpR9uFoZKu5H1hiA6V6UPe1KtLFSnN3N5tGah
         XJZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773304736; x=1773909536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tXrAFYR5bIhSumOFjuc1G0swOeqj6K0Pq1d0oWdhjWU=;
        b=RGUARcJefP3TlJ4FH5PSLthP9QU28VM/WoYD3/ahcpW0ys3Z2cCSh5ENcuQJGSGfiS
         Ysqg7epIbfChzm1S9cM0A6+fCj8cKRKnNVcOiT90nTTIHv/c9DhhuRbXRViH+2nDObRT
         b/S8PvSSiV4CrwTfSi3nQM+go7scYusBL4hXtkjYnivy4DvoSk2+f2kWgxUXq4m9ROw1
         cWRyXCcKsEYV7H269ynBPBr0KC+nhM7NJJsZILCjDA/k1KLMYvPnqWVBXBMY3u+Q1LJl
         QJyW+AUfjqSgXK8ELLelQaTEkEC+JyOH3eW5hvUuU/0fgovOajYPtlSfr8mADTyuU2kY
         FvIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWn44wvORqvbm9zIwDsefF6FsSyp7HkjIreKhED1GT+/4lbMU3x3KwTTX/tIbYTlB5HawdnYX6kwUbs@vger.kernel.org
X-Gm-Message-State: AOJu0Yws9dJbIkAst+iJgK4cyVG485YAvHhd7vJ/dDHOWWopL6iE1RKm
	w/a2HYXd9fyoh79nKcBXS3NiUWSjANELcNDqXhU3a/+ajyb2M9Krlkas
X-Gm-Gg: ATEYQzypdDUkEdqq3KKw4nz0hQrvhkiW2ZMm8YswmssCmp83PGeP2xc1BW31sLhQwXJ
	Zy62UsWFg/hPLMj8ARV24DnttMgEmK/II3LPg3Byek+7ATy1dnPG1jjG3r3AN1DHqnfzaubrkPJ
	C6de7WwvJuIdqO+LBFFbE7uv5dPHC9M1Uld+/ufk9+r61eHq9bFasHpv74MqmKBgQbx7mADWTza
	44kRffytzdCSUyguwzpN+IZBHtm0G3Msz4h5kATOGD3QyCv3qC4+2yTyFXMmBUetNXZxuKDAUpk
	IBB0PvALZMpuBm0mXUn4lwLW4YyPuhfE1gQb39MxzzeCU1YxdfEDlDdujBU9n4cT5Nyai1QYUK9
	juVIuMvs47vYDMw91Rvzc+k5N1yGPZcIBFR9kh5gLtBzKNoxs8kZcJv7zqPtjfFON8LDivYu5Ct
	0JhjCHxbnA7tXyoCLTR2D//wrOUQMTOnS7JifVkAYUULm7GXTDnxYhQ95d8FpxudV2
X-Received: by 2002:a05:600c:3551:b0:477:7b16:5fb1 with SMTP id 5b1f17b1804b1-4854b0cbe81mr96719315e9.7.1773304735965;
        Thu, 12 Mar 2026 01:38:55 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b5f6bb4sm111774365e9.4.2026.03.12.01.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 01:38:55 -0700 (PDT)
Date: Thu, 12 Mar 2026 08:38:53 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Richard Henderson
 <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, Magnus
 Lindholm <linmag7@gmail.com>, Russell King <linux@armlinux.org.uk>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Huacai
 Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti
 <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Christian
 Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, "David S. Miller" <davem@davemloft.net>, Andreas
 Larsson <andreas@gaisler.com>, Richard Weinberger <richard@nod.at>, Anton
 Ivanov <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Herbert Xu <herbert@gondor.apana.org.au>, Dan Williams
 <dan.j.williams@intel.com>, Chris Mason <clm@fb.com>, David Sterba
 <dsterba@suse.com>, Arnd Bergmann <arnd@arndb.de>, Song Liu
 <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, Li Nan
 <linan122@huawei.com>, Theodore Ts'o <tytso@mit.edu>, "Jason A. Donenfeld"
 <Jason@zx2c4.com>, linux-alpha@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 sparclinux@vger.kernel.org, linux-um@lists.infradead.org,
 linux-crypto@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 26/27] random: factor out a __limit_random_u32_below
 helper
Message-ID: <20260312083853.01dc18d3@pumpkin>
In-Reply-To: <20260311222935.GA3161@quark>
References: <20260311070416.972667-1-hch@lst.de>
	<20260311070416.972667-27-hch@lst.de>
	<20260311222935.GA3161@quark>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Mar 2026 15:29:35 -0700
Eric Biggers <ebiggers@kernel.org> wrote:

> On Wed, Mar 11, 2026 at 08:03:58AM +0100, Christoph Hellwig wrote:
> > Factor out the guts of __get_random_u32_below into a new helper,
> > so that callers with their own prng state can reuse this code.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>  
> 
> I think I'd prefer that the test just uses the mod operation instead,
> like many of the existing tests do:
> 
>     prandom_u32_state(&rng) % ceil

Or possibly what the old code used:
	(prandom_u32_state(&rnd) * (u64)ceil) >> 32

Which distributes the values evenly across the range although
some values happen 1 more time than others.
I suspect that is good enough for a lot of the users of the cryptographic
random number generator as well.

	David

> 
> Yes, when ceil isn't a power of 2 the result isn't uniformly
> distributed.  But that's perfectly fine for these tests, especially with
> the values of ceil being used being far smaller than U32_MAX.
> 
> There's been an effort to keep the cryptographic random number generator
> (drivers/char/random.c and include/linux/random.h) separate from the
> non-cryptographic random number generator (lib/random32.c and
> include/linux/prandom.h).  This patch feels like it's going in a
> slightly wrong direction, where random.c gains a function that's used
> with both cryptographic and non-cryptographic random numbers.
> 
> And if someone actually needs a fully unform distribution, then they'd
> probably want cryptographic random numbers as well.
> 
> So I'm not sure the proposed combination of "fully uniform
> non-cryptographic random numbers" makes much sense.
> 
> Plus the '% ceil' implementation is much easier to understand.
> 
> - Eric
> 

