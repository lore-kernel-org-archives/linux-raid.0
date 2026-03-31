Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAE31990C7;
	Tue, 31 Mar 2026 06:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774939025; cv=none; b=tipPbEHAXPN6UD0MQTg+qXznuVTYMksJs1e8UddbquqskZuexvR1CuF0+voAt65VGKRIuc123Z6k7knYiKEx5VrtOiPgEE8+Ag81XFguZLdTtug4WOuXDJKViO/jFNAo0dIC7iWo5fUJqLRPK5PBp6yNhOD5aFsnvqYo2flJ2k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774939025; c=relaxed/simple;
	bh=x2ocXIFEqXQ8SrB0cs1oq1giEjf4kVDT4z8YdRMzKVE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YyOn1D/vR1K+IYN1d0LzfIRQ/qTu3jpvX+0OfaSEGTGozYv+WzVB00EULanvHvBcNIvMEhwqnF4b5WgNvS7H76iEtlWq8FpJzJczWO33sZeNhNunt6qR/0mdT/Zb92UV1V6PCVKl9ApQRIngeoptzSbMVjgHLGFIYcjyAr3klaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B9A6168B05; Tue, 31 Mar 2026 08:36:59 +0200 (CEST)
Date: Tue, 31 Mar 2026 08:36:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Demian Shulhan <demyansh@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>, Christoph Hellwig <hch@lst.de>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Mark Brown <broonie@kernel.org>,
	linux-arm-kernel@lists.infradead.org, robin.murphy@arm.com,
	Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] raid6: arm64: add SVE optimized implementation for
 syndrome generation
Message-ID: <20260331063659.GA2061@lst.de>
References: <20260318150245.3080719-1-demyansh@gmail.com> <f9bc0534-4b7a-4b14-974b-4d7811ccd899@app.fastmail.com> <acJhCCPfVxjFUZ5R@J2N7QTR9R3> <CAOLeWCsxhzdxQviizJ4X4VOp_28LCtO-RjWoCcZG29rQw86NVg@mail.gmail.com> <9a12e043-8200-4650-bfe2-cbece57a4f87@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9a12e043-8200-4650-bfe2-cbece57a4f87@app.fastmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 30, 2026 at 06:39:49PM +0200, Ard Biesheuvel wrote:
> I think the results are impressive, but I'd like to better understand
> its implications on a real-world scenario. Is this code only a
> bottleneck when rebuilding an array?

The syndrome generation is run every time you write data to a RAID6
array, and if you do partial stripe writes it (or rather the XOR
variant) is run twice.  So this is the most performance critical
path for writing to RAID6.

Rebuild usually runs totally different code, but can end up here as well
when both parity disks are lost.

> > Furthermore, as Christoph suggested, I tested scalability on wider
> > arrays since the default kernel benchmark is hardcoded to 8 disks,
> > which doesn't give the unrolled SVE loop enough data to shine. On a
> > 16-disk array, svex4 hits 15.1 GB/s compared to 8.0 GB/s for neonx4.
> > On a 24-disk array, while neonx4 chokes and drops to 7.8 GB/s, svex4
> > maintains a stable 15.0 GB/s — effectively doubling the throughput.
> 
> Does this mean the kernel benchmark is no longer fit for purpose? If
> it cannot distinguish between implementations that differ in performance
> by a factor of 2, I don't think we can rely on it to pick the optimal one.

It is not good, and we should either fix it or run more than one.
The current setup is not really representative of real-life array.
It also leads to wrong selections on x86, but only at the which unroll
level to pick level, and only for minor differences so far.  I plan
to add this to the next version of the raid6 lib patches.

