Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A593D47C3
	for <linux-raid@vger.kernel.org>; Tue, 24 Mar 2026 06:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774334991; cv=none; b=IH8ax+KwJrWzAOK9nE9ysPU1uOyWkcTdyh6JhAjfJh145KjN+ju1SwgVUdwPi33e68LenE4l/qhjybdUeLhZZAq3ek8iDYrGFQb89sWDPtfVHdmuH2SWPpb2m32vOaSqZekiGjGL07ZDeGBE7AR7bSaEReiSMGnPNKfxl2oSV+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774334991; c=relaxed/simple;
	bh=jSnYqHw1PQwi8/Y6Tk9TJdjGO4tjHmBWaoSyV0wYMCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q3/piBTEKdwa6ut38p25rhhPFzAWhA4fK90EXYzURlESWrHRQkHDU//UW8hN/HcNSg9jAborPNGraRNg5P490IBwIe/Itvo4Z5SugYkxiUWPk1aRH/pN8s1T+3dJ+6033tbvRS0Kc5IgOQ8vShPnYjHfzzrtg82o063UMqAdNNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 867C66732A; Tue, 24 Mar 2026 07:49:37 +0100 (CET)
Date: Tue, 24 Mar 2026 07:49:37 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chaitanya Kulkarni <kch@nvidia.com>
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
	kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>
Subject: Re: [PATCH 2/2] nvme-multipath: enable PCI P2PDMA for multipath
 devices
Message-ID: <20260324064937.GB1409@lst.de>
References: <20260323234416.46944-1-kch@nvidia.com> <20260323234416.46944-3-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323234416.46944-3-kch@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Mar 23, 2026 at 04:44:16PM -0700, Chaitanya Kulkarni wrote:
> NVMe multipath does not expose BLK_FEAT_PCI_P2PDMA on the head disk
> even when the underlying controller supports it.
> 
> Set BLK_FEAT_PCI_P2PDMA in nvme_mpath_alloc_disk() when the controller
> advertises P2PDMA support via ctrl->ops->supports_pci_p2pdma.
> 
> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
> Signed-off-by: Kiran Kumar Modukuri <kmodukuri@nvidia.com>

This signoff chain is wrong - you are both author and patch submitter,
so other signoffs should not appear.

Otherwise looks good:

> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index ba00f0b72b85..c49fca43ef19 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
> @@ -737,6 +737,9 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
>  		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
>  	if (head->ids.csi == NVME_CSI_ZNS)
>  		lim.features |= BLK_FEAT_ZONED;
> +	if (ctrl->ops && ctrl->ops->supports_pci_p2pdma &&
> +	    ctrl->ops->supports_pci_p2pdma(ctrl))
> +		lim.features |= BLK_FEAT_PCI_P2PDMA;

This assumes all controllers support P2P, but we allow matching
over different transports.  So you'll need to do the same scheme
as for MD RAID that checks that every member supports P2P.

