Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020A5285CBA;
	Tue, 24 Mar 2026 07:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774338314; cv=none; b=MCzxr0egJFIa/CUDsDRW89n3QIaCXWkekPFJG7BDvbSLRe3OsIpGaZedLuwd77Yz8YVswo7mAS43STl0C8dwxrDyAMhijbARfubUGxZTazKeA/oSuNN4xYmgV2oC1DV6ZLeIae5GKt1BMTdxse+5njaH7RtQiTfgG1ConZQlAe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774338314; c=relaxed/simple;
	bh=lxOWCm1F35wYwofnbwFFFSQPpDADaGR9cTKmLbuTRLk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fMRgFozRKmX1ldPLZJgyh7nkmen9SazVE1nUBrOTz9PRj254D8/XF6UzKO8OQDjQDST4UokZRNGoes4WVB8VJeD0ptTCUjXrafBpAGXz9iogys02Wneqf8YWCx21+b0uSy2gjqBWL6SjqQ+cbW81zxa1Nl0IADo1noL4BisQ8g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=WUg4jpmv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="WUg4jpmv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZscMz3/ltsM4mEec+3AAbOOemJ3tvro+id7tm9uXfzQ=; b=WUg4jpmvME6wGjYrhTmnYki5Hn
	spRSvTVZVCjFP4eAPtSMw4uGWPb1KuOG1YWEJ2KIhkJGMx3dLt+xXIwoHR50BF6B7b0ihCP0Jasd/
	kpt5JjXyGXPue2u7fm0BiqpWT1FkRO/tMauV+AIhKcAMeXXJgIEh2ByzejgjUnZvq5R6MSpmkY5qW
	hpMHzkAJKat7KnC5qcc4Fwm7ybJjY68r7oUICTUMuOnDRbsr3OxInEVkPiHFLCfKAC7YLfowlBXEm
	3cO7x/lGMxhdvKC9pZdEyRzUewe2rOhOkOC6Z7p21FYvLsvV67HwTtfYgTYPafVlTY+gmknWj6Tmi
	om5hX2ng==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w4wRi-00000000um6-0wsL;
	Tue, 24 Mar 2026 07:45:02 +0000
Date: Tue, 24 Mar 2026 00:45:02 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Demian Shulhan <demyansh@gmail.com>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] raid6: arm64: add SVE optimized implementation for
 syndrome generation
Message-ID: <acJA_s2gfKhiRxXF@infradead.org>
References: <20260318150245.3080719-1-demyansh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318150245.3080719-1-demyansh@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Damian,

thanks for looking into this.

I've added the arm64 maintainers and arm list as that's your best bet
for someone actually understanding the low-level assembly code.

On Wed, Mar 18, 2026 at 03:02:45PM +0000, Demian Shulhan wrote:
> Note that for the recovery path (`xor_syndrome`), NEON may still be
> selected dynamically by the algorithm benchmark, as the recovery
> workload is heavily memory-bound.

The recovery side has no benchmarking, you need to manually select
a priority.

Note that I just sent out a "cleanup the RAID6 P/Q library" series that
make this more explicit.  It also make it clear by prioritizing
implementations using better instructions available we can short-cut
the generation side probing path a lot, which might be worth looking
into for this.

I'm also curious if you looked why the 4x unroll is slower than
the lesser unroll, and if that is inherent in the implementation.  Or
just an effect of the small number of disks in that we don't actually
have 4 disks to unroll for every other iteration.  I.e. what would the
numbers be if RAID6_TEST_DISKS was increased to 10 or 18?

I plan into potentially select the unrolling variants based on the
number of "disks" to calculate over as a follow-on.

We'll have to wait for review on my series, but I'd love to just rebase
this ontop if possible.  I can offer to do the work, but I'd need to
run it past you for testing and final review.

> +static void raid6_sve1_gen_syndrome_real(int disks, unsigned long bytes, void **ptrs)

Overly long line.

> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	long z0 = disks - 3;
> +
> +	p = dptr[z0 + 1];
> +	q = dptr[z0 + 2];

I know all this is derived from existing code, but as I started to hate
that I'll add my cosmetic comments:

This would read nicer by initializing at declaration time:

	u8 **dptr = (u8 **)ptrs;
	long z0 = disks - 3;
	u8 *p = dptr[z0 + 1];
	u8 *q = dptr[z0 + 2];

Also z0 might better be named z_last or last_disk, or stop as in the
_xor variant routines.

> +	asm volatile(

But I wonder if just implementing the entire routine as assembly in a
.S file would make more sense than this anyway?

> +static void raid6_sve1_xor_syndrome_real(int disks, int start, int stop,
> +					 unsigned long bytes, void **ptrs)
> +{
> +	u8 **dptr = (u8 **)ptrs;
> +	u8 *p, *q;
> +	long z0 = stop;
> +
> +	p = dptr[disks - 2];
> +	q = dptr[disks - 1];
> +
> +	asm volatile(

Same comments here, plus just dropping z0 vs using stop directly.

> +#define RAID6_SVE_WRAPPER(_n)						\
> +	static void raid6_sve ## _n ## _gen_syndrome(int disks,		\
> +					size_t bytes, void **ptrs)	\
> +	{								\
> +		scoped_ksimd()						\
> +		raid6_sve ## _n ## _gen_syndrome_real(disks,		\
> +					(unsigned long)bytes, ptrs);	\

Missing indentation after the scoped_ksimd().  A lot of other code uses
separate compilation units for the SIMD code, which seems pretty useful
to avoid mixing SIMD with non-SIMD code.  That would also combine nicely
with the suggestion above to implement the low-level routines entirely
in assembly.

I'll leave comments on the actual assembly details to people that
actually know ARM64 assembly.
