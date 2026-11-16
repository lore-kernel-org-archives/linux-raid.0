Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794809476;
	b=fOlVxGnRxbyMc/nqaBaPAfOO/9ZRKw4TOg/fe9FMhjxMqDoENq9Bv6AwHatCM5v4ZMgz
	 lGwczOYeMmCvok9dWgPc7Qe6O3JlNZ/YgFktYEln0alUl8i2IU/T2nHF6fuxdIa+dJEs4
	 GABkAMllaZ82HrJt1ogjl9k0xV8fCQBxVILXk8/bxu/YJoeKX95jSxsNYKsxWJtstk6f0
	 WnBRvv12mIZiplk2G0+gmedlq2toUA1JGu75SEYiAdkhQshq230phaU/EsHPkWwluktTV
	 4Uv6DGTGHEF3jthQC06+hgJHJd8Ta9YYla3kDXix0LlxGyfguxWpeQynclaj+ZkshpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794809476;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-SRS-Rewrite;
	bh=MPd4pZJYXRdLwgYttFxn4aXXY1gb3aP+H41TDipbCho=;
	b=p8FpmefYDGigF/1FDhEfKC4E+AHeVBJ/Cw4PTqq2MObFvwlKzYDULtcrQ1yn5G23uMl1
	 XndRrNV2gNlIAeN7fDpuwdTrwo2/r878NTVJprfeMfl5P/ZwjVsct4J/o8GL6alBLMdo9
	 +4gb5ggqRDJSgsEbWdvtUTmESGzsPTZu8PPzNGUAKoFSOntwKiUntV73ZKOhWzHqasW7W
	 MaaZGFy7uQvx/SpKnb6o5dJ/0tmb5hBCuCSV9N/RSldhCTIOd15KQlr2PA8kje1cr1NeO
	 t8kpb/v2Ko2ycPrAc/z1hPTm41Vn8C0jkA2xq31ygwn4c2KgGcOhqed9qkdDviW8FIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=none smtp.mailfrom=bombadil.srs.infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=c9mwc2wA;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05F3C606A31C;
	Mon, 16 Nov 2026 06:11:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05F3C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=c9mwc2wA
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MPd4pZJYXRdLwgYttFxn4aXXY1gb3aP+H41TDipbCho=; b=c9mwc2wADHZv5elZ8l8CkIYMV4
	qdH6FKLk2ZruTT44EpmRQnmD03tFX0BkFk/LIpKht1j4muDs8nQ2pSBljsi6Jeb8LrLqub0JKABpb
	rbw8vnhwChd0IlSh1BHAHf6WncyJnf7gNHoYxMsJfcBLYP7uWbxL9jF5JSH9FdHfunDffWcRwdq8l
	VZe26yRp+dDJnU31z0WCedbgt82WK37Wz48Vxn3mYMyrqhBVrFGEUoAjGZ6+p/JSZSOQjf5YjBkba
	XouTdV7GTeOJn2u7ZpP9L2Y6XUUVQe82/xxLQxFJxpaimwr73zPgB5weRw5H+th6Wif+ZPjW+DPmO
	BggqAk7A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xSpvt-00000001Dgt-45Tx;
	Mon, 16 Nov 2026 06:11:13 +0000
Date: Sun, 15 Nov 2026 22:11:13 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Miroslav Cimerman <mc@raidlab.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Markus Stockhausen <stockhausen@collogia.de>
Subject: Re: [PATCH] raid6: use normal stores in the x86 x4 xor_syndrome
 functions
Message-ID: <avqegZd_W0kce0UA@infradead.org>
References: <20261109030805.25709-1-mc@raidlab.org>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109030805.25709-1-mc@raidlab.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Nov 09, 2026 at 03:08:05AM +0000, Miroslav Cimerman wrote:
> xor_syndrome() updates P and Q in place for a read-modify-write. md
> calls it twice on the same P/Q page per write, to remove the old data
> and to add the new data. The x1 and x2 unrolled versions write P and Q
> with normal stores since commit a582564b24be ("md/raid6 algorithms:
> xor_syndrome() for SSE2"), which argued that non-temporal stores of
> less than a cache line are slow, but kept non-temporal stores in the
> x4 version, as it writes whole cache lines. The AVX2 and AVX-512
> versions followed the same pattern.

Adding Markus as the author of that commit.

> The non-temporal stores evict P and Q from the cache and the sfence
> waits until they are written to memory, just before the second call
> reads the same P and Q again, now from memory.
> 
> Use normal aligned stores in the x4 unrolled versions too, like the x1
> and x2 versions and the other architectures.
> 
> md RAID-6, 4 KiB random writes, md thread on one core, Xeon E5-2699 v3:
> 
>   8+2 on null_blk (dm-raid):     85.6k -> 98.1k IOPS (+15%)
>   6+2 on 8 Intel Optane M10:     57.3k -> 62.1k IOPS (+8%)

That's pretty nice numbers.

Note that for the new xraid code we'd actually use the XOR code in a
single pass, so non-temporal stores might make some sense.  But
I can't good heatedly argue that mainline should care for this right
now.

> - The sfence at the end of the xor_syndrome() functions (x1, x2 versions
>   since 2014, x4 with this patch) is no longer needed, as it no longer
>   orders any non-temporal stores. Removing it made no measurable
>   difference. I am happy to send a follow-up patch that removes it from
>   all xor_syndrome() variants.

This probably should go away.

Reviewed-by: Christoph Hellwig <hch@lst.de>
