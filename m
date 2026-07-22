Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E218473C61
	for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 18:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746769; cv=none; b=uYMMM52yDCz/vTRNpP+JDC+Lrujk3lsIyHs1t2bVt9wyCXRKljshWPe0lr3bCfKJtocIUSbqpkesbJcNYmNcpaM/QgM22Z1FFi+LECU2kt+7GZJR6hOTs0+l2OkrMTjXStcBwlix8R/kkxs+iiHOaKBxuITpa2QyfC/shUrCzRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746769; c=relaxed/simple;
	bh=PFyLWHE9pTJ4175QPKDcNHyfOtGQRFYQNlkqnpPL1lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKzgadynzAvairuzUXBPlnmmWbPYKOg55v2Ger86b5Z3gND+8Pq5n6X3hdPl9K6D/c04GtQkR2WjKwcfTwEILq9LU6axupx74gmHNHl2iMGArZ8sZk+t1jUA+55ELTD4aPbvNBUJAqXtXseJBjCQTG/D2O9v5M8ILTCOPjP++u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=gFkA1PYc; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="gFkA1PYc"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493f6de72faso45306225e9.0
        for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 11:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784746759; x=1785351559; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZyX4ma10pC/frHu+Y/NUZniwvhp9EvBkdSwrv0doV3k=;
        b=gFkA1PYcdgJBj7Vk0LpWIXQdy5xoIr7JDJ4V6i5w+Cvel3qWwN8RjqopjcOvvtLeMM
         uBqArxT30CfTjh0676/kjNn2ppFN731beeq9rT71vPCEeMveVlDaadsU54BS0g55Vd9i
         rAYDk044Y5AnWmYPGvtkJtk3GSJ8Yr8SRmpRQK1DkmZEcGTlkXrF5dLRlooBfwJI5eLH
         6fsDprOXAb51C2TyF8cYKU5NK5+jJi4SjQq5AYe0ragqMg7YykVIzzSw9P39yIym5uVr
         1aK+008mvyyLPI8ftiReDk5SFbPVFZ2UnJ09yY1ZYjvjB1rVitvOviOPkHiza7yzEJeV
         WKRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746759; x=1785351559;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZyX4ma10pC/frHu+Y/NUZniwvhp9EvBkdSwrv0doV3k=;
        b=rF5fwMZIt79HFFNFyze1t/thWHHMU2397AX1XD+qj95zJY8yZs34d4cLVYUpDHcd/J
         hj5nDebArswFebTgAJ0nXP9rSN4vQ8YKf9K6k7Qbs2GI7mBePgbTmrtEtPn8ze6np5YJ
         mlkhs9drP+yIujzrf2nwAbBQoN/gMTUfTiT8xcUKd+CaCX4Fz74z1BgNg4JQeKIZXPy6
         1SnsLP+iaUyvgk/HXrp4U9pfVrynczZKQHVkFo00N0KQYvCFDyUXJYAFbAH2Tc9K3tNP
         Z+NskFCWiD70Xwyq37t+oyAzZr+II0EixnmV+OOz7GcmMPTpejPeUpKFvGZ+mbYzqMsD
         Wtpg==
X-Forwarded-Encrypted: i=1; AHgh+RqkjwWkGyixuPsBMsnerWBhMsjuyOGUWsB35hH9MLLMkofiiREnEvDsB4zRqISygN7mhf+/LyzCOuXa@vger.kernel.org
X-Gm-Message-State: AOJu0YzGmZ163NRz7pSOHyFpji5Bsq/C2MBrAADgswbgfC89Ztw8IStd
	W6WP/igJYGY/Vr+IZtqDEYo/nieBcLF3D0R5dtrehjKw6hqGZes0RmfhzsPL07Y58w==
X-Gm-Gg: AR+sD13VMMEGQiXkPKtWG15udeWls22w7gkoljeB9ONuJiT3gDF8oqaC/0yo/S7Vfgb
	VTQsDjvYdZQQUOK41ZMugHHReepxgz1gy7F/igC84zuFcghJtRc5YhrbpnEpEOZ8jhqoBoKb0H4
	Dps95lA3J+o/y14d78FYCI1Izj4t0UHW1LyVb1WQ0S6fFohTyHdmPMV4l1eVuGb6ndZckL8H0BJ
	zSuralhm/blxwWZQk4N/4f/fwWc0qRjtHyB+iw8jOygWIOsXk51K9euaTBnHHyXbYX3Cxl5wvKc
	ViKC6hxljTqMaE0nEPCbR6Yu5ybpblnIpWzkAHLpQkjVy3ub9YCyIqeqZJ0nL8blmtKt9L4HxwO
	uFqKvmHE01i4A2tjbhgZqmlO1xZHq+ZMHHNQ9R/hsxEjf7kEYj6Xwl+cuGHI2H5Rh4MPFWPEBIW
	L3z0X+7tp4VAac6TjczQXdGx0WLfnMD6RSpzlGVHNk4ud1HTA=
X-Received: by 2002:a05:600c:6610:b0:492:6f5c:fd8c with SMTP id 5b1f17b1804b1-4956a511b49mr53704175e9.15.1784746758682;
        Wed, 22 Jul 2026 11:59:18 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495730353d9sm13740055e9.12.2026.07.22.11.59.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:59:18 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Jens Axboe <axboe@kernel.dk>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaji Kant <shivajikant@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH v4 9/9] nvme-rdma: return BLK_STS_P2PDMA for unsupported P2P transfers
Date: Wed, 22 Jul 2026 20:58:41 +0200
Message-ID: <20260722185841.449934-10-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260722185841.449934-1-mykola@meshstor.io>
References: <20260722185841.449934-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the PCIe topology cannot route a P2P transfer between two devices,
the DMA layer fails the mapping with -EREMOTEIO, but ib_dma_map_sg()
returns 0 and the error is lost. nvme-rdma then fails the I/O with a
retryable status, so multipath requeues it forever and a single path
wastes its whole retry budget on an I/O that can never succeed.

Map the data and metadata scatterlists with ib_dma_map_sgtable_attrs(),
which preserves the error, and translate -EREMOTEIO to the new
BLK_STS_P2PDMA status so the request fails fast instead of being
retried. While at it, call nvme_start_request() only after mapping
succeeds and ratelimit the map-failure message.

Fixes: 23528aa3320a ("nvme: enable PCI P2PDMA support for RDMA transport")
Cc: stable@vger.kernel.org # v7.1
Assisted-by: Claude:claude-fable-5
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/nvme/host/rdma.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 6909e3542794..2f50509a7a61 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1469,6 +1469,7 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
 		int *count, int *pi_count)
 {
 	struct nvme_rdma_request *req = blk_mq_rq_to_pdu(rq);
+	struct sg_table sgt;
 	int ret;
 
 	req->data_sgl.sg_table.sgl = (struct scatterlist *)(req + 1);
@@ -1480,12 +1481,14 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
 
 	req->data_sgl.nents = blk_rq_map_sg(rq, req->data_sgl.sg_table.sgl);
 
-	*count = ib_dma_map_sg(ibdev, req->data_sgl.sg_table.sgl,
-			       req->data_sgl.nents, rq_dma_dir(rq));
-	if (unlikely(*count <= 0)) {
-		ret = -EIO;
+	sgt = (struct sg_table) {
+		.sgl		= req->data_sgl.sg_table.sgl,
+		.orig_nents	= req->data_sgl.nents,
+	};
+	ret = ib_dma_map_sgtable_attrs(ibdev, &sgt, rq_dma_dir(rq), 0);
+	if (unlikely(ret))
 		goto out_free_table;
-	}
+	*count = sgt.nents;
 
 	if (blk_integrity_rq(rq)) {
 		req->metadata_sgl->sg_table.sgl =
@@ -1501,14 +1504,14 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
 
 		req->metadata_sgl->nents = blk_rq_map_integrity_sg(rq,
 				req->metadata_sgl->sg_table.sgl);
-		*pi_count = ib_dma_map_sg(ibdev,
-					  req->metadata_sgl->sg_table.sgl,
-					  req->metadata_sgl->nents,
-					  rq_dma_dir(rq));
-		if (unlikely(*pi_count <= 0)) {
-			ret = -EIO;
+		sgt = (struct sg_table) {
+			.sgl		= req->metadata_sgl->sg_table.sgl,
+			.orig_nents	= req->metadata_sgl->nents,
+		};
+		ret = ib_dma_map_sgtable_attrs(ibdev, &sgt, rq_dma_dir(rq), 0);
+		if (unlikely(ret))
 			goto out_free_pi_table;
-		}
+		*pi_count = sgt.nents;
 	}
 
 	return 0;
@@ -2026,8 +2029,6 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 	if (ret)
 		goto unmap_qe;
 
-	nvme_start_request(rq);
-
 	if (IS_ENABLED(CONFIG_BLK_DEV_INTEGRITY) &&
 	    queue->pi_support &&
 	    (c->common.opcode == nvme_cmd_write ||
@@ -2039,11 +2040,13 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	err = nvme_rdma_map_data(queue, rq, c);
 	if (unlikely(err < 0)) {
-		dev_err(queue->ctrl->ctrl.device,
-			     "Failed to map data (%d)\n", err);
+		dev_err_ratelimited(queue->ctrl->ctrl.device,
+				    "Failed to map data (%d)\n", err);
 		goto err;
 	}
 
+	nvme_start_request(rq);
+
 	sqe->cqe.done = nvme_rdma_send_done;
 
 	ib_dma_sync_single_for_device(dev, sqe->dma,
@@ -2063,6 +2066,9 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 		ret = nvme_host_path_error(rq);
 	else if (err == -ENOMEM || err == -EAGAIN)
 		ret = BLK_STS_RESOURCE;
+	/* Peer memory unreachable from this device: don't retry. */
+	else if (err == -EREMOTEIO)
+		ret = BLK_STS_P2PDMA;
 	else
 		ret = BLK_STS_IOERR;
 	nvme_cleanup_cmd(rq);
-- 
2.52.0

