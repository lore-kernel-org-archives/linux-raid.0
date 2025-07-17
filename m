Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142594C9D;
	Thu, 17 Jul 2025 04:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752727939; cv=none; b=SFNjsKlbzJhg2nRsYXM0quqM7uGUPl+3EQBR30BomfANGltWeOlmC2xL/vGNm5LptO3KGi9+X7Rijv4gxdEQioLG6n7In4rP/enCi1W99IxG5npsvUfAjAgj8pG6u6YWJ1/MpiI2KwiEzMsoj2Z+k5ohTX5IOagvFcmAtEJ3v8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752727939; c=relaxed/simple;
	bh=1DHr20168nm4djO5OBO8XISMQPBKPH9fESyvyeP1R1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t0aQH2BCYF5MEDCCwiMQrBKs4uDWvVmb2b6rVz48JdnbNrCDUYTieTiHTvBCsjF8vZ/NUWYNELGPdlZT2Pe07XAOd5hzOuqmF3EUgELDeBfxNTYmJP9zqjkL1zlVkFabijHUXXgHfk9qp6RVYxGr4emKmJ20HIv0FHW8jitH4PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id E6955227A87; Thu, 17 Jul 2025 06:52:10 +0200 (CEST)
Date: Thu, 17 Jul 2025 06:52:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: Yu Kuai <yukuai@kernel.org>
Cc: Coly Li <i@coly.li>, Christoph Hellwig <hch@lst.de>,
	Coly Li <colyli@kernel.org>, linux-raid@vger.kernel.org,
	linux-block@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
	Xiao Ni <xni@redhat.com>, Hannes Reinecke <hare@suse.de>,
	Martin Wilck <mwilck@suse.com>, Keith Busch <kbusch@kernel.org>
Subject: Re: [RFC PATCH] md: split bio by io_opt size in md_submit_bio()
Message-ID: <20250717045210.GA27227@lst.de>
References: <437E98DD-7D64-49BF-9F2C-04CB0A142A88@coly.li> <20250716114121.GA32207@lst.de> <D12A8BDA-5C2B-4FA7-9C92-731BD321A611@coly.li> <20250716114533.GA32631@lst.de> <danlsghtalte7sku3vlfxkgngujgwzspanfayaxy4jfnk54jbf@yfvmr5plavmp> <20250716121449.GB2043@lst.de> <DE36C995-4014-44DC-A998-1C4FF9AFD7F9@coly.li> <20250716121745.GA2700@lst.de> <109C6212-FE63-4FD2-ACC3-F64C44C7D227@coly.li> <284433c9-c11d-401f-8015-41faa9d0fde1@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <284433c9-c11d-401f-8015-41faa9d0fde1@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 17, 2025 at 12:29:27AM +0800, Yu Kuai wrote:
>> If opt_io_size is (chunk_size * data_disks), setting new max_hw_sectors as rounddown(current max_hw_sectors, opt_io_size) is good idea.
>
> I think round down max_hw_sectors to io_opt(chunk_size * data_disks) will 
> really
> make things much easier, perhaps Christoph means this way. All you need to 
> do is to
> handle not aligned bio and split that part, and for aligned bio fall back 
> to use
> bio_split_to_limits().

If the raid5 code can handle multiple stripes per I/O, than you
just need to round it down, yes.  I assumed it could only handle
a single full or partial stripe at a time, but I guess I was wrong.

