Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6832E06E6
	for <linux-raid@vger.kernel.org>; Thu,  9 Apr 2026 06:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775716072; cv=none; b=jrudKjK+hV9Vai5p7S5JhTWQMMrU3EF1tuV8U6nWP0nmr+NWViQKvfw2l4bmeTJyhzcf0T0uf/ypjz4TGu5m2L9rA+PRo1B+FAEyc2UttL4KPnxP1ZPoGkOBKBulM+D9wqeMZNaKM5tliheoTRYvSCYnx2+3dXJ995Kzf9G6WrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775716072; c=relaxed/simple;
	bh=m9TNRjk0ZRPvyNoIUf2RrE9c6DmnaIx78J2KswlLbcE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QKOdVIXb/9aY9PT/VaFynp4mF/fLD7bPVuifN3wpMhVr7mWLsoFYjOrmxzRKGodmvsJAkZP6dSRIwcHvo7bhMZHiSQSvGhLMZbhPYKAu4DymErS5M2tRAkPk5NEtj/ROfr70VMfq/uC1v4kxRo0N6k6enLiQG6PQ6DD9wey5bkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id F23B768BFE; Thu,  9 Apr 2026 08:27:48 +0200 (CEST)
Date: Thu, 9 Apr 2026 08:27:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chaitanya Kulkarni <kch@nvidia.com>
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
	kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	kmodukuri@nvidia.com
Subject: Re: [PATCH V2 1/2] md: propagate BLK_FEAT_PCI_P2PDMA from member
 devices
Message-ID: <20260409062748.GB7335@lst.de>
References: <20260408072537.46540-1-kch@nvidia.com> <20260408072537.46540-2-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408072537.46540-2-kch@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 08, 2026 at 12:25:36AM -0700, Chaitanya Kulkarni wrote:
> From: Kiran Kumar Modukuri <kmodukuri@nvidia.com>
> 
> MD RAID does not propagate BLK_FEAT_PCI_P2PDMA from member devices to
> the RAID device, preventing peer-to-peer DMA through the RAID layer even
> when all underlying devices support it.
> 
> Enable BLK_FEAT_PCI_P2PDMA in raid0, raid1 and raid10 personalities
> during queue limits setup and clear it in mddev_stack_rdev_limits()
> during array init and mddev_stack_new_rdev() during hot-add if any
> member device lacks support. Parity RAID personalities (raid4/5/6) are
> excluded because they need CPU access to data pages for parity
> computation, which is incompatible with P2P mappings.
> 
> Tested with RAID0/1/10 arrays containing multiple NVMe devices with P2PDMA
> support, confirming that peer-to-peer transfers work correctly through
> the RAID layer.

Same thing as for nvme-multipath applies here - just set
BLK_FEAT_PCI_P2PDMA unconditionally at setup time for the personality
that support it, and then rely on an updated blk_stack_limits to clear
it.

