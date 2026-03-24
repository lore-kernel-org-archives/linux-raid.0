Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404C33E0C77
	for <linux-raid@vger.kernel.org>; Tue, 24 Mar 2026 06:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774334912; cv=none; b=OOGOQVho8d4AEeIUg0fgZ/AEDbXpd226d0AlzjX/kQdIK8VS/Z2sh3NOjGy+9AnkqxIqFUEjrL3MrAKFHV3UZf4o6Z3IzZYWqKvC6cCz2bFBaYTR9/ljsvMNs5yqliZr4Km3uUqNi0C0vwR92zjTpGYkmmCYlSTsZsC8KrM4jvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774334912; c=relaxed/simple;
	bh=d2VYGamdYB/e4sm0OgmcMknTRz2SeoBdIJpYLUblzHc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YzLqZJUHTRy3b37uVhwnAshH6mrClMj+mKPWBqjrpGWFqk/O11dO+MYmeEOF+0+xrHXypE6oT+6+3zmHGeqh6uLJAjr6qWh50Ixq1lVC4b+S90fOp1O+H4+IjtCguhcr3ss+L3B4WuHf9f4NgHz4TYw4im7g68c4Fbz/XlYgdq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 067386732A; Tue, 24 Mar 2026 07:48:17 +0100 (CET)
Date: Tue, 24 Mar 2026 07:48:16 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chaitanya Kulkarni <kch@nvidia.com>
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
	kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>
Subject: Re: [PATCH 1/2] md: Add PCI_P2PDMA support for MD RAID volumes
Message-ID: <20260324064816.GA1409@lst.de>
References: <20260323234416.46944-1-kch@nvidia.com> <20260323234416.46944-2-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323234416.46944-2-kch@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 23, 2026 at 04:44:15PM -0700, Chaitanya Kulkarni wrote:
> MD RAID does not propagate BLK_FEAT_PCI_P2PDMA from member devices to
> the RAID device, preventing peer-to-peer DMA through the RAID layer even
> when all underlying devices support it.
> 
> Enable BLK_FEAT_PCI_P2PDMA by default in md_init_stacking_limits() and
> clear it in mddev_stack_rdev_limits() during array init and 
> mddev_stack_new_rdev() during hot-add if any member device lacks support.
> 
> Tested with RAID arrays containing multiple NVMe devices with P2PDMA
> support, confirming that peer-to-peer transfers work correctly through
> the RAID layer.

Which personalities did you test this with?  Parity RAID needs to
copy from the data payload, which is not going to work very well
with P2P mappings.

