Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40E33148A7
	for <linux-raid@vger.kernel.org>; Thu,  9 Apr 2026 06:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775716025; cv=none; b=MWu1twUwObEuBMR4nz+Nd20Hn/Fk98MG4c3Uclis+UrZbC2ngHonVIS7O8ai8ySKU+EVbQwlouGX15xe+pq+zlQcOgYOW0rjHAE3rjhm71BxrSnzBswEn5lFd7OYhUDPm8kJQ2vnzXMLqQ3FsSI/UF4wx85GnHuM+SOSQbvV/Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775716025; c=relaxed/simple;
	bh=TLoUm5Nnzen86sFZO7R/0mGxUkouU1mD1wo+sEm8dr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=di4M0Fa5qg1Bo7Rk27ryOHSw83V72GR3kXbU5t+X/7eQAty0F+CVx5OpB7PBGi0JbM3aDRWQOLh3/xnLGxgR1i57ReQKikxY+melZZtAt+aR+PwrWlkJr+PKnJ+emEfLhm+t6Y9M9Ak1ZvJoH5aVHhDlZOAKMFVqSLwVdg6XXSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 996B368BFE; Thu,  9 Apr 2026 08:26:59 +0200 (CEST)
Date: Thu, 9 Apr 2026 08:26:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: Chaitanya Kulkarni <kch@nvidia.com>
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
	kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	kmodukuri@nvidia.com
Subject: Re: [PATCH V2 2/2] nvme-multipath: enable PCI P2PDMA for multipath
 devices
Message-ID: <20260409062659.GA7335@lst.de>
References: <20260408072537.46540-1-kch@nvidia.com> <20260408072537.46540-3-kch@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408072537.46540-3-kch@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Apr 08, 2026 at 12:25:37AM -0700, Chaitanya Kulkarni wrote:
> From: Kiran Kumar Modukuri <kmodukuri@nvidia.com>
> 
> NVMe multipath does not expose BLK_FEAT_PCI_P2PDMA on the head disk
> even when the underlying controller supports it.
> 
> Set BLK_FEAT_PCI_P2PDMA in nvme_mpath_alloc_disk() when the controller
> advertises P2PDMA support via ctrl->ops->supports_pci_p2pdma.
> 
> Since multipath can match paths across different transports (e.g. PCIe
> and FC), not all paths are guaranteed to support P2PDMA. Clear
> BLK_FEAT_PCI_P2PDMA from the head disk in nvme_mpath_add_disk() if the
> newly added path does not support it, ensuring the feature is only
> advertised when every member supports it.
> 
> Signed-off-by: Kiran Kumar Modukuri <kmodukuri@nvidia.com>
> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>  drivers/nvme/host/multipath.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
> index ba00f0b72b85..48d920ce803f 100644
> --- a/drivers/nvme/host/multipath.c
> +++ b/drivers/nvme/host/multipath.c
> @@ -737,6 +737,9 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
>  		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
>  	if (head->ids.csi == NVME_CSI_ZNS)
>  		lim.features |= BLK_FEAT_ZONED;
> +	if (ctrl->ops && ctrl->ops->supports_pci_p2pdma &&
> +	    ctrl->ops->supports_pci_p2pdma(ctrl))
> +		lim.features |= BLK_FEAT_PCI_P2PDMA;

I think we can just add this unconditionally here, similar to all the
other feaures above the ZNS conditional as any non-supporting controller
will clear it later.

>  
>  void nvme_mpath_add_disk(struct nvme_ns *ns, __le32 anagrpid)
>  {
> +	struct nvme_ns_head *head = ns->head;
> +
> +	/*
> +	 * Clear BLK_FEAT_PCI_P2PDMA on the head disk if this path does not
> +	 * support it. Multipath may span different transports (e.g. PCIe and
> +	 * FC), so every member must support P2PDMA for it to be safe on the
> +	 * head disk.
> +	 */
> +	if (head->disk && !blk_queue_pci_p2pdma(ns->queue)) {
> +		struct queue_limits lim =
> +			queue_limits_start_update(head->disk->queue);
> +		lim.features &= ~BLK_FEAT_PCI_P2PDMA;
> +		queue_limits_commit_update(head->disk->queue, &lim);
> +	}

And this really should go into the core block code in blk_stack_limits,
so that BLK_FEAT_PCI_P2PDMA is cleared whenever a non-confirming
device is added, similar to BLK_FEAT_NOWAIT and BLK_FEAT_POLL.

