Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439923DB645
	for <linux-raid@vger.kernel.org>; Wed, 17 Jun 2026 10:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781690727; cv=none; b=WB0cyFbpZ9z/R7neDDWHjHyZ0YehCbveTAL2VjRAcdwOsGiJKFnP9QXt+e3JMZTrrysBzsC+I2aOoDbLWkYYbBBmZmblIaknA43zss4S+iT3SH8FesFKtfU0XGAPWzVAsoD9cn7ariyEhfRBdWxHZmG7BeFC7IsPX91KP70l+FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781690727; c=relaxed/simple;
	bh=GRels6+00DOfhtua/SMwmdOjxdx+1fjruBc3u5+ohXk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KM384lRSgfXvCgnJoPr0sxssKiI7Co6k/z1oFv9W3PHMJDBGr95IMEiy5VogEZsHqf/+nYF4qfzt5rkrYZyb/joHtP+E0Kw7G5MkwuAoCuOTpHUCrAB2DZcTAaOE4p1qBVS3v7YgPbdUbecywnRBKfOzzinS7hbUGpcfnRBTP7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KHVdx7Fs; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KHVdx7Fs"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-4629324e170so514279f8f.0
        for <linux-raid@vger.kernel.org>; Wed, 17 Jun 2026 03:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781690720; x=1782295520; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f2OPmLF096KqR20zLR2fjLEx0fdz7L4iVkInjy+NLrw=;
        b=KHVdx7FsSUX70y3nKbzgeoG+EGfzuN1tVtPT9iW1MdcrPaD+DmOKUZZzWJ7/TKiUNw
         LAIgDSl/dhkhFfZ8N8B0kFHVKw6XH4kD3FnQzzMxOXzCVtvjTGpRjYNq0ollIURBJgWH
         c/blhzVx+wytjXV6FkmHdZ6X+6Kgyay6SRM8RNcfDnRkadFc18p8QEic7dBGKn4ssFRR
         N2D4QhBJm9ZVz7Ww3B9g+fRM6nEZhI2k4e68uz7NXOYaM3MTZpgQ99W6Sog49cNuQDZt
         c27kTW0qz6uz4tEckDe/lVI3UP99ejgTQtSNgxZVvmjEh5yTk5fqRmQ+jwh/42CWKn1Q
         stiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781690720; x=1782295520;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f2OPmLF096KqR20zLR2fjLEx0fdz7L4iVkInjy+NLrw=;
        b=JtRc+qF+fotkZ4BuGFiK5+5JK+pLALP2UeKTC5vmLGvIil/pHp51yjOxA/iVC+IpIb
         zqjUEKqqNAbqS1v0jyeCq5csjNXG2sV6sE8MwNgC2P8b3C1UDJWKqchmT9thuNHC1soj
         dC6um4GDOcUOw/IGaiBQ0q1FvbX9XwRoyAmWDocvzvI7HSnAP+3QraHHD49rglX68ToA
         PYrSPFaQF32JneWjMywKK5PTsxuL9FfsN8PynCQocyLnzEvzCNwXLSEeQ0lmQWLhmoHr
         nlKv6jSJkAEtIgwrLo2vUZbwq10srndHjOgypYpy/rhApJbxwvPEkEZlJGPDS/adlxWg
         nIEA==
X-Forwarded-Encrypted: i=1; AFNElJ85P+Pa8xMByxQtOahsd07w9xn+5MiSXBg/uXTelb8M1lLmQNFgnlCJDmW3O7JC/UtC/YuSVhTYYlez@vger.kernel.org
X-Gm-Message-State: AOJu0YwKt+/dK9shI1xlomK6m3C1u2duyYFL5vudjBliq06DN5Du8fb+
	kHQsy+ueT2XujvI0lAe+yeE+YlEAQusmTSpywXa3MNP68jbFaE/eTg1w
X-Gm-Gg: AfdE7ckqniUvB1jSQ8lZhaMFYzu9iki23QcrxeIsWG5ualgcjw7/lC1oRuIqS5+zNcY
	I9VcvyfF+GGyOoBfdmhZKXaPO1yF++txn1C+pNxyw7YtbuAJyROOLP4l4j0mc2nIq6iZcw6wOfr
	OIZrnV9OEoQWjmU1Dx7qSgi6CrpkTRSzr+GGScrBS5iWEsLgltLyDqVAtWk7YudSAlCO4q0pNW4
	Ikw/T2i87lD6S6kfBtgVE3CqE6Y/2mHZ0LuxrQBEOUHGbkNCG4wMH8FwYgoBjgJbgbO8k2rZOTI
	iQ8QK5HXHjbHeK+r+WjrCDGvzpPuEjFlQaSjcMmx182yZ42yapImXG1dtjDfsXARyT2UaCgbutf
	eTrydSnJjRhyzxY3U8E4FAXd5mQ/rwOjyWDDrHQi7Qvk2HfvoiQhHCkeHpkgXCU1Up/NiB55nz9
	Mqd/oll2RFVW9odzQnWaPdxXLBNCF0FpNt97BOVIE9wqAdKDJZvg==
X-Received: by 2002:a05:6000:461e:b0:45e:f2bd:2b17 with SMTP id ffacd0b85a97d-46238acb523mr5897596f8f.21.1781690720067;
        Wed, 17 Jun 2026 03:05:20 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2dbfb1sm55720157f8f.35.2026.06.17.03.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 03:05:19 -0700 (PDT)
Date: Wed, 17 Jun 2026 11:05:16 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Eric Biggers <ebiggers@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, x86@kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH v3] lib/raid/xor: x86: Add AVX-512 optimized xor_gen()
Message-ID: <20260617110516.0a70950e@pumpkin>
In-Reply-To: <20260617055653.GB19218@lst.de>
References: <20260615190338.26581-1-ebiggers@kernel.org>
	<20260617055653.GB19218@lst.de>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 Jun 2026 07:56:53 +0200
Christoph Hellwig <hch@lst.de> wrote:

> Can use the xor: prefix used for all other commits to lib/raid/xor?
> 
> > Benchmark on AMD Ryzen 9 9950X (Zen 5):
> > 
> >     src_cnt    avx          avx512       Improvement
> >     =======    ==========   ==========   ===========
> >     1          56353 MB/s   75388 MB/s   33%
> >     2          54274 MB/s   68409 MB/s   26%
> >     3          44649 MB/s   64042 MB/s   43%
> >     4          41315 MB/s   55002 MB/s   33%  
> 
> On my Zen 5 mobile (AMD Ryzen AI 7 PRO 350) both the existing
> AVX2 and this AVX512 code give numbers in the 200+ GB/s range.  Not
> sure if is just the different benchmarking or something else going on.

I'd expect benchmarking of the xor loop to show that it is doing
2 memory reads every clock.
At 5GHz (I'm sure my zen5 will reach that single threaded) that
is 320 GB/s for src_cnt == 1 and 160 GB/s for src_cnt == 3.

200 GB/s with 32 byte cache reads would need a 200/32 = 6GHz cpu
just for the reads.

But I expect Eric is benchmarking more code and may be limited
by data cache refills.

> 
> FYI, one or 2 sources are basically useless as they RAID5 configs
> that have no benefits over simple mirroring and thus the numbers
> aren't too interesting.

With three disks you xor two buffers (src_count == 1) to get the parity
to write to the third - so that is a valid RAID5 config.

> 
> > +DO_XOR_BLOCKS(avx512_inner, xor_avx512_2, xor_avx512_3, xor_avx512_4,
> > +	      xor_avx512_5);  
> 
> Is there really much of a benefit of doing the historic DO_XOR_BLOCKS
> vs doing the loop manually?  Especially as the common cases for a
> modern RAID will usually loop over more disks than this was built
> for.  I.e., in practice one or two source buffers only happen at the
> end of a loop over more disks.

I stopped looking at what was being tested at that point :-)

	David

