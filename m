Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795416996;
	b=Nk31/g6rjFw4raTgmLgiVs+ZMsrcfb4B6VSLmVLt8pb1MLOMpahQNyVCY5hvPoFW32Yi
	 ZrhOD4ngOHrFI8BdkY9SbL4tsoItHVz+GYGlB7D3aQmyn+3o50SWmr3G47KpsOD8/aFSk
	 128IYPCMd4YRLBCmDXmWTJY6nRK5kOPhNW150lyKbATyyGBj9Mxw4Q2GDWw3sb+icf1uk
	 53P9wILRFNLhHQmuc0azJCUlf3n+UC2+wqZHMTZFwYJu0pDNH+VVa09o684gC+EmBmRPQ
	 u48RVf1zhdziMHpHF53HHnTDLcNyKasReLdMH0pkEE49a4mRvwtd20lhymCNqzJeacA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795416996;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=whKi47fa5tp/DFm7GtACTeh3cYy+YIxx3ir1mzl2A3fQx3vVRNTUuEa6/jBdvsiWWbH5
	 Z6DcUecw6+2B+UziUzGGYkjQueKP3pGDk7uKS5kzy37Z7spdfzmxDunrtYB0yYBHRptip
	 e7tRvMMSCtaq/++mB1AnKCs7eyyBN5smoI5jhuBoRElj3PCQjn/jK8FC0b2Hu6FnEMX+E
	 BWtgUMZqNH78O4p4fg+NT4HM0onktFmNSzCBLpx8fDD1rJJHmFP3aIgiN6pzR4IywaAKq
	 eU3nv9gVrCGXFa9jmRkY/0Lv5ETzKnI98GkukArOXjZcajp5EDs3TFofkC0Dwvo/JmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC3A606A31A;
	Mon, 23 Nov 2026 06:56:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5CC3A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 1261768AFE; Mon, 23 Nov 2026 07:56:33 +0100 (CET)
Date: Mon, 23 Nov 2026 07:56:32 +0100
From: Christoph Hellwig <hch@lst.de>
To: Miroslav Cimerman <mc@raidlab.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>, Christoph Hellwig <hch@lst.de>,
	David Laight <david.laight.linux@gmail.com>,
	Markus Stockhausen <markus.stockhausen@collogia.de>,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] raid6: prefetch Q with prefetcht0 in the x86 x4
 xor_syndrome functions
Message-ID: <20261123065632.GC17691@lst.de>
References: <20261122032933.2306875-1-mc@raidlab.org> <20261122032933.2306875-4-mc@raidlab.org>
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
In-Reply-To: <20261122032933.2306875-4-mc@raidlab.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

