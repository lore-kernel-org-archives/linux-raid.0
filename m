Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4463750AC
	for <linux-raid@vger.kernel.org>; Fri, 17 Apr 2026 10:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776422824; cv=none; b=Eyp0/wpkXYCi41CWr54kDqB105PlC+HsUpx5qQpQEle53ebkKtmtsizJ3ARgm5Le2BUzbtkOC8pzD0SaPXRecboEpDIfF/cEbFumai5oGAtIKM9k6YuFAnzCr5phtHMaYVM9gEpVuFdXGRTLLo8TlqMTK3zL5n02Y3tclCfvdRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776422824; c=relaxed/simple;
	bh=YNqPKUFsNx81yu4lOB/abs66pom24Pxcyg4ckzluDpc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=tncRV8jC3mw8UhKAijbDsapLLqDzerdYkbMNn/AMiMtqHR5CCERJycIZO6VCqM2Ol1LXDnSDJZPD8OyyBntz6fC4rOuJ0El4h8L6CBrQGGKNgU75YDhe2XLuuU69nxkv3FIqsuAb5jt/asG1q/ovhPhwr4TDjI8KxuQ7tj63m6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bctg9cIq; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bctg9cIq"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20260417104658epoutp01b52393be7a1af3bdb6eedb9caa731ada~nHyRTuN9r0542805428epoutp01i
	for <linux-raid@vger.kernel.org>; Fri, 17 Apr 2026 10:46:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20260417104658epoutp01b52393be7a1af3bdb6eedb9caa731ada~nHyRTuN9r0542805428epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1776422818;
	bh=/AzM7p18opdrIRbQiJ7D1n4Cz94lVxIsTHGwVc/LYY8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bctg9cIq0eRdtKQNdQWMtNWAu3WDjSWIs/TtvZIRuKuIOOCbFHLCuNjyH8Dy2oLYl
	 a9F0sMEQ1wj/t4fhZZwESkBmHj4AanyZnEbZEyuoCiR0BClBcvqhXMNUcRt/tUi11z
	 h2ztlaNXeyyhMB/YusOn3LhFTgJ/HtdipcPM+evA=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260417104658epcas5p3f24729feff0e9b8e24512c70182dbace~nHyQhq_rX2126821268epcas5p3B;
	Fri, 17 Apr 2026 10:46:58 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.86]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4fxs5F0MqJz6B9m5; Fri, 17 Apr
	2026 10:46:57 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260417104656epcas5p1d1b8733d39ab67f94114159c03ad41a0~nHyPMaw9l1400214002epcas5p1u;
	Fri, 17 Apr 2026 10:46:56 +0000 (GMT)
Received: from green245.gost (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260417104654epsmtip2a8d99659d3a44407c3d070e0caf7cc46~nHyNY8MHv3196031960epsmtip2G;
	Fri, 17 Apr 2026 10:46:54 +0000 (GMT)
Date: Fri, 17 Apr 2026 16:12:16 +0530
From: Nitesh Shetty <nj.shetty@samsung.com>
To: Chaitanya Kulkarni <kch@nvidia.com>
Cc: song@kernel.org, yukuai@fnnas.com, linan122@huawei.com,
	kbusch@kernel.org, axboe@kernel.dk, hch@lst.de, sagi@grimberg.me,
	linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
	kmodukuri@nvidia.com
Subject: Re: [PATCH V3 3/3] nvme-multipath: enable PCI P2PDMA for multipath
 devices
Message-ID: <20260417104216.3tdvmfq43uok2ulu@green245.gost>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260416212633.72650-4-kch@nvidia.com>
X-CMS-MailID: 20260417104656epcas5p1d1b8733d39ab67f94114159c03ad41a0
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----njBzzhCGtS-aHlIth.2Pj0w1Th4tsb8PwJn50ZNtPKFt4kYn=_21b21_"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260417104656epcas5p1d1b8733d39ab67f94114159c03ad41a0
References: <20260416212633.72650-1-kch@nvidia.com>
	<20260416212633.72650-4-kch@nvidia.com>
	<CGME20260417104656epcas5p1d1b8733d39ab67f94114159c03ad41a0@epcas5p1.samsung.com>

------njBzzhCGtS-aHlIth.2Pj0w1Th4tsb8PwJn50ZNtPKFt4kYn=_21b21_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 16/04/26 02:26PM, Chaitanya Kulkarni wrote:
>From: Kiran Kumar Modukuri <kmodukuri@nvidia.com>
>
>NVMe multipath does not expose BLK_FEAT_PCI_P2PDMA on the head disk
>even when all underlying controllers support it.
>
>Set BLK_FEAT_PCI_P2PDMA unconditionally in nvme_mpath_alloc_disk()
>alongside the other features.  nvme_update_ns_info_block() already
>calls queue_limits_stack_bdev() to stack each path's limits onto the
>head disk, which routes through blk_stack_limits().  The core now
>clears BLK_FEAT_PCI_P2PDMA automatically if any path (e.g., FC) does
>not support it, consistent with how BLK_FEAT_NOWAIT and BLK_FEAT_POLL
>are handled.
>
>Signed-off-by: Kiran Kumar Modukuri <kmodukuri@nvidia.com>
>Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
>---
> drivers/nvme/host/multipath.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
>index ba00f0b72b85..957e39c4795d 100644
>--- a/drivers/nvme/host/multipath.c
>+++ b/drivers/nvme/host/multipath.c
>@@ -734,7 +734,7 @@ int nvme_mpath_alloc_disk(struct nvme_ctrl *ctrl, struct nvme_ns_head *head)
> 	blk_set_stacking_limits(&lim);
> 	lim.dma_alignment = 3;
> 	lim.features |= BLK_FEAT_IO_STAT | BLK_FEAT_NOWAIT |
>-		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES;
>+		BLK_FEAT_POLL | BLK_FEAT_ATOMIC_WRITES | BLK_FEAT_PCI_P2PDMA;
> 	if (head->ids.csi == NVME_CSI_ZNS)
> 		lim.features |= BLK_FEAT_ZONED;

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>

------njBzzhCGtS-aHlIth.2Pj0w1Th4tsb8PwJn50ZNtPKFt4kYn=_21b21_
Content-Type: text/plain; charset="utf-8"


------njBzzhCGtS-aHlIth.2Pj0w1Th4tsb8PwJn50ZNtPKFt4kYn=_21b21_--
