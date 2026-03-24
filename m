Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633D735F182
	for <linux-raid@vger.kernel.org>; Tue, 24 Mar 2026 21:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774387780; cv=none; b=AraZaSb2wRhpWd+sHd4aQUpT6BcS3QDD1pKujJI3AspcY1IU0FIlF489TJYrjM84fPaOjK20McEdrCvttecW3cEsQJGPv/24/ooAiNinNQjs+c1tGrI1FOPcvILFImOQit99TYys9rn98BsnZ02aDoBrD605qINDv58j6r6ViJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774387780; c=relaxed/simple;
	bh=u5/JBwfDXGvNqTWVPuFo0bB9nPHgweRS2A8ofbk3anE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fuk6vP844fszH1IMrmEfYVOrMXi/7V+dMJYkfg7JObjmBhVPwkpi2CtnkGER+udCTa5qoodYQmCW87Q6odniL1e3CRBRlg5+cEjojImcN7fJEa/6pMbq5irbNBf/lK23glgiGh55lbnDfFmEZkafHx4REYfkCMSRzI+Qrb/DnBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j3n+HMLc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j3n+HMLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED46C19424;
	Tue, 24 Mar 2026 21:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774387779;
	bh=u5/JBwfDXGvNqTWVPuFo0bB9nPHgweRS2A8ofbk3anE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j3n+HMLcWcBDA1xwtxPBKSsyNo7kCRij22d7lJyXjqnX8Oaqqic6ujJogGFevjmR1
	 EWFjEh/mxxXftRtpUpnnj4UZ6Mz4Wtq1HxQAZSWgn9T2VdrJjtQn1YJY4NmY6AST5x
	 csJOubrm4P7VakSKBb2RtAjjaaTLitu7AgHJ6WFzNaIfBk7Ivv7P3l4NelOM1i6yhd
	 V0dGgy28y/5nZmpJdOue/48fongIqSmzklKbs4NUXxKLU0DGo3jEROuFSw/y5ur0XS
	 rrQyf3JiOdHceDrM4Tf+vvfU7JhLGxvbXK7uhxWy7H8cIyBXxchONECQOZFfaIdW7Y
	 sZJT6BNNWqT3w==
Date: Tue, 24 Mar 2026 15:29:37 -0600
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
Message-ID: <acMCQaEOAqZEfyyT@kbusch-mbp>
References: <20260323234416.46944-1-kch@nvidia.com>
 <20260323234416.46944-2-kch@nvidia.com>
 <20260324064816.GA1409@lst.de>
 <DM4PR12MB8473B3907CAF51AEBAE573E5D548A@DM4PR12MB8473.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM4PR12MB8473B3907CAF51AEBAE573E5D548A@DM4PR12MB8473.namprd12.prod.outlook.com>

On Tue, Mar 24, 2026 at 09:13:55PM +0000, Kiran Modukuri wrote:
> Hi Christoph,
> 
> We tested with RAID0 , RAID1 and RAID10 only. You're right that parity RAID personalities
> need CPU access to data pages for XOR/parity computation, which won't
> work with P2P mappings.
> 
> 
> We'll send a v2 that moves BLK_FEAT_PCI_P2PDMA out of
> md_init_stacking_limits() and instead has raid0, raid1 and raid10
> opt in individually during their queue limits setup. raid4/5/6 will
> not set the flag.

I think the parity could work with P2P memory if the calculation is
offloaded to a dma_aysnc_tx. It doesn't look like we necessarily know if
any particular xor is going to get offloaded, though.
