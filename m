Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFDA3B19BC
	for <linux-raid@vger.kernel.org>; Tue, 24 Mar 2026 22:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774390116; cv=none; b=lDf5sjRPyrfe5KHTanJcYUMYTy7EHdf/1eWr4RqAzlvLNFGWFgcdwNCES16dQ+np7IejXPmmFw9rriOHp3wf4TSIqcwMyEQ0paIIc7+NXZk1mRP4xj0hmftQVyuBoFntX4S98+yXcUr/a7OZwjZVhQ0KGvU6wrpHi4QPcy7lyNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774390116; c=relaxed/simple;
	bh=582lj4Q0QSxQ7zL9ehprIYOP8OizZRoaVEMHubw+uL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fk7l2JtzYF6NM4BLd+2r6+D/4fvoctchAD0ZGCPvlFCRvM4hZQUQmoANu7SR9SUY1sZght+LZ1ddChSeqx2212ZEz8VqEOGqiECyplY8aMjUQOhbiHWuW5KQxBb+c2DPAliCkdNOhj+AVE40uqnH0hjtdoyz7TjrmKRXVtUIAW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QD4Reiq8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QD4Reiq8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08302C19424;
	Tue, 24 Mar 2026 22:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774390115;
	bh=582lj4Q0QSxQ7zL9ehprIYOP8OizZRoaVEMHubw+uL8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QD4Reiq8trHN+TxVedul3xM8RiSrBZBn5ViIefrkniy2BfPbUF4Jif0VjF1JGSdJT
	 buy+Vf3ySYwXbq9rup/MBG0rW8Sdqp1i8WSbwJ8/mf28mRGZd7bF1Swn9X9/dvUcLM
	 qE1gDiG+UDU3DERNhvhh+Pfsd4dMjnN6wPBZ/NbNFyehc3BnxhBPMnAz33GEfviAV+
	 j6X3+EvReM5GqL+OC6E7bYD/jOqBwQBXO1bCyoXl3ADCpSFcXLwO2+Rr4BS42vz21A
	 TVQFCHzGZr3sXKZD6P64Z029M0+CwBdxnX0By71NpYAeJlNsLrqkPlUJ21P989smqX
	 /brFN65X4q/Qw==
Date: Tue, 24 Mar 2026 16:08:33 -0600
From: Keith Busch <kbusch@kernel.org>
To: Kiran Modukuri <kmodukuri@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>, Chaitanya Kulkarni <kch@nvidia.com>,
	"song@kernel.org" <song@kernel.org>,
	"yukuai@fnnas.com" <yukuai@fnnas.com>,
	"linan122@huawei.com" <linan122@huawei.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"sagi@grimberg.me" <sagi@grimberg.me>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	"linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [PATCH 1/2] md: Add PCI_P2PDMA support for MD RAID volumes
Message-ID: <acMLYSsatGfMiFRA@kbusch-mbp>
References: <20260323234416.46944-1-kch@nvidia.com>
 <20260323234416.46944-2-kch@nvidia.com>
 <20260324064816.GA1409@lst.de>
 <DM4PR12MB8473B3907CAF51AEBAE573E5D548A@DM4PR12MB8473.namprd12.prod.outlook.com>
 <acMCQaEOAqZEfyyT@kbusch-mbp>
 <DM4PR12MB84736C00E876FD160464EB35D548A@DM4PR12MB8473.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DM4PR12MB84736C00E876FD160464EB35D548A@DM4PR12MB8473.namprd12.prod.outlook.com>

On Tue, Mar 24, 2026 at 09:43:15PM +0000, Kiran Modukuri wrote:
> Hi Keith,
> 
> So do you suggest we leave the current patch as is without restricting the P2PDMA support for RAID4/5 or restrict the support only for the RAID0, RAID1 and RAID10.

I think you currently have to remove it. If you want to do parity
against P2P memory (which sounds like like a nice feature to me), then
you'd have introduce a prep patch to detect that an xor dma offload
exists for the raid volume to use, and do something to ensure it will
always get offloaded for P2P memory instead of falling back to the CPU
driven synchronous implementation.

Unrelated suggestion, you need to change your email client settings to
plain text in order for the mailing list to accept the message.


> From: Keith Busch <kbusch@kernel.org>
> Date: Tuesday, March 24, 2026 at 2:29 PM
> To: Kiran Modukuri <kmodukuri@nvidia.com>
> Cc: Christoph Hellwig <hch@lst.de>, Chaitanya Kulkarni <kch@nvidia.com>, song@kernel.org <song@kernel.org>, yukuai@fnnas.com <yukuai@fnnas.com>, linan122@huawei.com <linan122@huawei.com>, axboe@kernel.dk <axboe@kernel.dk>, sagi@grimberg.me <sagi@grimberg.me>, linux-raid@vger.kernel.org <linux-raid@vger.kernel.org>, linux-nvme@lists.infradead.org <linux-nvme@lists.infradead.org>
> Subject: Re: [PATCH 1/2] md: Add PCI_P2PDMA support for MD RAID volumes
> 
> On Tue, Mar 24, 2026 at 09:13:55PM +0000, Kiran Modukuri wrote:
> > Hi Christoph,
> >
> > We tested with RAID0 , RAID1 and RAID10 only. You're right that parity RAID personalities
> > need CPU access to data pages for XOR/parity computation, which won't
> > work with P2P mappings.
> >
> >
> > We'll send a v2 that moves BLK_FEAT_PCI_P2PDMA out of
> > md_init_stacking_limits() and instead has raid0, raid1 and raid10
> > opt in individually during their queue limits setup. raid4/5/6 will
> > not set the flag.
> 
> I think the parity could work with P2P memory if the calculation is
> offloaded to a dma_aysnc_tx. It doesn't look like we necessarily know if
> any particular xor is going to get offloaded, though.
