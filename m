Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ACCB46D0B4
	for <linux-raid@vger.kernel.org>; Tue, 21 Jul 2026 17:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655980; cv=none; b=neNwUWjbZ1AcmuHoAH6boLyoBZ0Y33e8MsOAmidvqjIRSLXDBs9fN9grGJ2QEnqFsuu2XBGkUDdmcASVneawQp8cYHZrVG7rEsG/6yWExg+Eo/KYsy780VFmMnZOajBbC+hAPVcSEFTf4XP86VWk80tGhIUGpjaKFrQSu0TGZY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655980; c=relaxed/simple;
	bh=gyTrkaup4Ks5bfaG/FoabYF4rN440J0V60i2qS5Yijs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bzoL7JYltfFw27HeavGwxZFUjUvbi71guwkI4zON/G6PzN/cgfOSiJuzscbId7RslFqKtoT298cNmAubgH2VXfm+3Og6SXRGEa/heHVLYKuUaEo5GI5k0iwi6uSuYSqVhnbUIgSta/mEpyXgdwITksqr59AAoAEbpV6GDQ6LxUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=NjrQ99bM; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="NjrQ99bM"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47f703a9d05so1867744f8f.0
        for <linux-raid@vger.kernel.org>; Tue, 21 Jul 2026 10:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784655977; x=1785260777; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AadYXUkLInAYH0JaK/HqdbVk2juyzp5yk+Dx6h3Mv+o=;
        b=NjrQ99bMf3IJfIqwLL+iZ4YUDFQ9yYv1rfZV+XAbFeUCMZ0Dj+3xjWKK/s4gkXyf8K
         WTHUNJ9WHftTSjNO/b98ZD11mOoHTLTBjrqjYzsHdoDjKM3qPTDWrdTU0NwowVa/n7J7
         s7QyXB/PaTTftO8jJM5CMRsIJ2gXZ05oUIYuGfkhyk2xc/TMKoUDw6vpPguIhLLrV6te
         z1h8Yg7MzK3HXxN/ixLzMyUq1SSH/0zxwoZ2hLjoUZUnFda6NZI6U5fRYt6tnA/AuyyJ
         R1IBNjyePCxdbZerUX8r+QpnfuorkoPJY82FOlOvi53qRrdY6Ac3qo59c68QijhUugqD
         2ouA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784655977; x=1785260777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AadYXUkLInAYH0JaK/HqdbVk2juyzp5yk+Dx6h3Mv+o=;
        b=daF9p9tHxI19WeIjJFUekz752G4BMFjIRKhGgOug9LKm8jTfp3m1RI5VK3NQSwytkK
         qxJztTOov4tdTBGKIPkS37B41WhDTDNKlmNR11oMScjhHVmhzAfcLHLmhYREkNsE3eEt
         bIzvRkDnt4VklihFwgYzTvc3hnNfyjV4QjLSOC6zTmtW5Tlucb7qYFxj9S8hL9iG+/kH
         wI5zuiyNn4yuGGbfGNVWEb0xUCcc/mf2v1T557/YZuQmxEX87LYEV31GhVs46ssiJjEe
         9Ql+ZZwQ4ITr28NZdEU7vJfbaQmvjSJLNVUlQDhpkYZgECrGeGo4So8Y6qkqqApmAJd2
         AUAQ==
X-Forwarded-Encrypted: i=1; AHgh+RpTkC/kyDwJ7pdJPNpbIQutnSKEQVmPFqVtRBjfLepWs6lNDT3VEhTjywuxmfq5dBrQxbD1S/3HH4rl@vger.kernel.org
X-Gm-Message-State: AOJu0YxhiqirnmlYdLH36URMnhZBPy+SR/sZDIMD7R6M+gAzen9ulz5T
	uY6+yhySGEa8QjZS5Hcr1VnkKOm9rAix86i0z9V/TozfOjuAbHDXOHG2tOk0OolUIA==
X-Gm-Gg: AR+sD10OxxBmz8bXNxmixkK1NekDdqE3y38Wnct0laYC+D0KiM/6Dx7o/OgEM68GR/X
	Qx4+sh3VaM5wPvQuAC+SDKIAp8rX2b8edcIGj+eTcf+QvQw6ZPKFC/1RoyohWeJoLky2Kwt8MUj
	ptpxH8wNbgDmahQME81PPN09Pl8qd6HIkyOwU+AzoIBTUYWLDr+sMRkE4DE+4EtGcG/T5h9vMRP
	/uhV11ftQITQBku2NdLmQakitgMQSsExbVa1gSzC3Y87z0HsYPy/EuDdo5uj5kXA2LdUR4qAkNI
	HE3qktl12B3NAEMJOeLo6xwKT5jBdYkjEUicNXrb3SMrpmT+wCjvlFOJs3t/JhY60HvLbRM3uu8
	OH7wSTK/ezzRPqv4XRcHZQEzUT/6j9g+YgZMrDWURXTT+Ezx7ENK4VNvYhOs7dNi/GkAzLZxYEs
	/ehSozaah1t5lOa94qdOLCCxSCn9qH6PTxym1wl9FPKgXzXBs=
X-Received: by 2002:a05:6000:1ace:b0:477:71ef:5d81 with SMTP id ffacd0b85a97d-47f62305373mr23603687f8f.6.1784655976544;
        Tue, 21 Jul 2026 10:46:16 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f63eddd27sm40860513f8f.28.2026.07.21.10.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 10:46:16 -0700 (PDT)
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
Subject: [PATCH v3 8/8] nvme-rdma: return BLK_STS_TARGET for unsupported P2P transfers
Date: Tue, 21 Jul 2026 19:45:02 +0200
Message-ID: <20260721174502.111503-9-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260721174502.111503-1-mykola@meshstor.io>
References: <20260721174502.111503-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ib_dma_map_sg() returns 0 on a P2P mapping failure, losing the DMA
layer's -EREMOTEIO, so nvme-rdma reports a path error.
Default multipath requeues the I/O forever, and without multipath
it burns nvme_max_retries requeues, then completes as retryable
BLK_STS_TRANSPORT.

Map the data and metadata scatterlists with
ib_dma_map_sgtable_attrs() and return BLK_STS_TARGET for -EREMOTEIO,
matching nvme-pci (commit 91fb2b6052f7 ("nvme-pci: convert to using
dma_map_sgtable()")).
Scatterlists stay: ib_map_mr_sg() consumes them, so blk_rq_dma_map
does not apply.

Start the request only after mapping succeeds so multipath
accounting is never taken for an unmapped request, and ratelimit
the map-failure message.

Fixes: 23528aa3320a ("nvme: enable PCI P2PDMA support for RDMA transport")
Cc: stable@vger.kernel.org # v7.1
Assisted-by: Claude:claude-fable-5
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/nvme/host/rdma.c | 38 ++++++++++++++++++++++----------------
 1 file changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 6909e3542794..f8edb23552ad 100644
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
+		ret = BLK_STS_TARGET;
 	else
 		ret = BLK_STS_IOERR;
 	nvme_cleanup_cmd(rq);
-- 
2.52.0

