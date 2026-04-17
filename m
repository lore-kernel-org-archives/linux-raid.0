Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DC9330666
	for <linux-raid@vger.kernel.org>; Fri, 17 Apr 2026 07:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776412385; cv=none; b=f1hdvxDOS/VUXgukoJ81skcua0u2jpGrsAx0v8nThE7NJ8OUgejYda5XGEZWA36iMyZ8RATkySkz510zTusHhEHPApXiKj8cumOo7+UUYAzhQxM72cDBi4MfKpeuzy0sXyovOGU2ExgNfEkffe9yMTGojvsUXbz6GfSkbEoPLoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776412385; c=relaxed/simple;
	bh=1uM2eQBwg/A68d/gu0/Er8GkCOZt9grCziIvr+171uE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZvSW4fSv6tP4pHIF/ebxsgkjwF/UZzoa0ttctTA+U3nkVrod1bSeZDmR+F5EUvzm52HScih284A6dAJ67FxF5I8cBiGKs+5Wy7FzPsI0mjgnCGVkdzWvT/QqKj+cOmUSkqXUUv518qO+Q97j3lSix1lyLc6wmQNqQHHJzY9oCYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2D61F68C7B; Fri, 17 Apr 2026 09:52:50 +0200 (CEST)
Date: Fri, 17 Apr 2026 09:52:49 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chaitanya Kulkarni <kch@nvidia.com>
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
	kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	kmodukuri@nvidia.com
Subject: Re: [PATCH V3 1/3] block: clear BLK_FEAT_PCI_P2PDMA in
 blk_stack_limits() for non-supporting devices
Message-ID: <20260417075249.GA31524@lst.de>
References: <20260416212633.72650-1-kch@nvidia.com> <20260416212633.72650-2-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416212633.72650-2-kch@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Apr 16, 2026 at 02:26:31PM -0700, Chaitanya Kulkarni wrote:
> BLK_FEAT_NOWAIT and BLK_FEAT_POLL are cleared in blk_stack_limits()
> when an underlying device does not support them.  Apply the same
> treatment to BLK_FEAT_PCI_P2PDMA: stacking drivers set it
> unconditionally and rely on the core to clear it whenever a
> non-supporting member device is stacked.
> 
> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

