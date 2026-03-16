Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2008B331A65;
	Mon, 16 Mar 2026 16:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773677604; cv=none; b=EMy9DuRROeiupYr024bcjZss8nXNEbrXVldKWm24RDKu/7pUi8nVx+o8AmjBRDebxxgWVvOz4hZ8MDKPEAoTbSobHmgDSiy7p8sKUXnjP21Yf0XBw39ZfSX2DNHrTuF2XW0W0HB+Dhd5f8n+vnZ86+XCG0lUYdWRTlPMI3lro/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773677604; c=relaxed/simple;
	bh=HaLo1MxPCTE0mwCHEdDYaGby4QVd3bmAMHfj6AlTveA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oKasWMZGlbiKGIOig2O/WIIqlxaNNm1VRzGhQ70K+DEIDZcX8fKVP3GwdcKKtbkEeDLB50a+1Ee1MWUp4MrZ7JK5wmTiupBSgBvbSH9NMDIuDRGwB7q5jeIHVSzx2MOQhApsT5tDJT5ZP2KIVCy/scXExux9d2S1RJw+jzRPM8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D5E9968BEB; Mon, 16 Mar 2026 17:13:13 +0100 (CET)
Date: Mon, 16 Mar 2026 17:13:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: kernel test robot <oliver.sang@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, oe-lkp@lists.linux.dev, lkp@intel.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andreas Larsson <andreas@gaisler.com>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>, Chris Mason <clm@fb.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Sterba <dsterba@suse.com>, Heiko Carstens <hca@linux.ibm.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Huacai Chen <chenhuacai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Li Nan <linan122@huawei.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Matt Turner <mattst88@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Richard Weinberger <richard@nod.at>,
	Russell King <linux@armlinux.org.uk>, Song Liu <song@kernel.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>, WANG Xuerui <kernel@xen0n.name>,
	Will Deacon <will@kernel.org>, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org
Subject: Re: [linux-next:master] [xor]  ebbbf58989:
 BUG:KASAN:slab-out-of-bounds_in_xor_gen_avx
Message-ID: <20260316161313.GA20842@lst.de>
References: <202603131751.7ba6ffc8-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202603131751.7ba6ffc8-lkp@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Note that this is the v1 series, and this is the case that Eric
mentioned and which thus got fixed.
