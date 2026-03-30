Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399A336C9CD;
	Mon, 30 Mar 2026 05:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774848612; cv=none; b=dohKSGP3RrHWkmmaQZ1zAjvt1eKSFW5Ix+KPmpjAHi4XKokLfkZu+AlkwA8OD2whrVt+Dlio8aGhDqUoFdq454GhPSMeTM56nc2Xd27Lc/k3aoIHVG3n6Wlzb8vrwjWbGlheWx5WX9ZNW6+TZBagjkqAKgb6dL2qbAZuwLC1xs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774848612; c=relaxed/simple;
	bh=84XjIfnzGCYMKd24CivdlI0WvAwd5jcNO36KeMRUSW0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mTDh8fr8qgObHxDOsfk8C2+rB/dISYyJBryRAltmkfu4YQac6FM3diGqTyn1QjoghvtaxU57MAsgc3nxmXgloUjaUzNfLlnobDJO7ZpDO+fjcOZdI8ZKbVxXLYj/xPov8iaKWP8iy8EOBoiO4N9LNm6NawF4kP2bQXM3V73AVJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2EBDF68B05; Mon, 30 Mar 2026 07:30:04 +0200 (CEST)
Date: Mon, 30 Mar 2026 07:30:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Demian Shulhan <demyansh@gmail.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fnnas.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>, broonie@kernel.org,
	linux-arm-kernel@lists.infradead.org, robin.murphy@arm.com,
	Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] raid6: arm64: add SVE optimized implementation for
 syndrome generation
Message-ID: <20260330053003.GA4736@lst.de>
References: <20260318150245.3080719-1-demyansh@gmail.com> <f9bc0534-4b7a-4b14-974b-4d7811ccd899@app.fastmail.com> <acJhCCPfVxjFUZ5R@J2N7QTR9R3> <CAOLeWCsxhzdxQviizJ4X4VOp_28LCtO-RjWoCcZG29rQw86NVg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOLeWCsxhzdxQviizJ4X4VOp_28LCtO-RjWoCcZG29rQw86NVg@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Mar 29, 2026 at 04:01:06PM +0300, Demian Shulhan wrote:
> Furthermore, as Christoph suggested, I tested scalability on wider
> arrays since the default kernel benchmark is hardcoded to 8 disks,
> which doesn't give the unrolled SVE loop enough data to shine. On a
> 16-disk array, svex4 hits 15.1 GB/s compared to 8.0 GB/s for neonx4.
> On a 24-disk array, while neonx4 chokes and drops to 7.8 GB/s, svex4
> maintains a stable 15.0 GB/s — effectively doubling the throughput.I
> agree this patch should be put on hold for now. My intention is to
> leave these numbers here as evidence that implementing SVE context
> preservation in the kernel (the "good use case") is highly justifiable
> from both a power-efficiency and a wide-array throughput perspective
> for modern ARM64 hardware.
> 
> Thanks again for your time and time and review!

To me this sounds like an interesting case for a SVE kernel API.
But I'm not relly knowledgeable enough to provide one to help
with testing this further.

