Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9689A3ABD8D
	for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 11:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785065578; cv=none; b=XMRXCboTPMAvXEVAmEn0nDt0JSw3IpeFQ/f/DNxzkBDeK6v+2lnuSnQKWfaa9VB52VkAbGRFumYV3E/nPtuHecrGfLy7a0O1XpFPRh8lD5XYaNjvD+Hb6QWsloMdmrhQ/mhyEY4mOlBzX5vrvt3TuRBoK3GvMJ7SlhxI6Jo7QVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785065578; c=relaxed/simple;
	bh=k8p26WkV8yppHusL3y+jBuuoZ4KH1m/7UvNpr9ifj8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bA7nKVbDr5wLhEYkEnLjQ0ABln2dMLnBKQqpmS/3uN+przEikrCncWmU2G1T79EAjVykglvh1BpoipP93FtyCjnVP6Ueu069Vh/DnKjPLuJxq6tRYIE3urByGC6fMHdcy4/VIqGwMsR0EN5TKLogB/+msW2LNZf6jV9C73FAjpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=k/bYnuPP; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="k/bYnuPP"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-4798bea72f9so1106691f8f.1
        for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 04:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785065575; x=1785670375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oTKfzdoHRmbK0b3PUxeuF9crncxafNJvwFc9FNFZP5k=;
        b=k/bYnuPP48pir7rE37mlrhKAXwf28oqwMSy9lScuF+wAna59o00v29RFx6/4gLo4Pi
         7lNLPY/wBZQhMAaG9ZlPhayiC69e0EE45qFLmariUiT1N0Y6pmSBYAfi9XPTYQBplO3i
         CRICOgifSe+V6NWj8uo8yHcND5gRqN1GAzgK3moihv5eVd0NGS9g4p8xjkVjl7ZVWJPM
         tV0bv9zxEWOXIxzDKnI2hjRH/fBc1dI3Bzd+DW/8bv5Od+2qSTg8kPClpnJAtcQ3TRbI
         FnYQcSH0QnbyL7KY0tPxMo1DR8TceJrT9QFFmjU5dOp9fYUVE0z5zEoC8Qfv0VWiivBB
         Wr6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785065575; x=1785670375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oTKfzdoHRmbK0b3PUxeuF9crncxafNJvwFc9FNFZP5k=;
        b=XQoh/aiFRU//khl5xxBGwBEmUCi8niUN9EvJ8FPds6VQWqafQacjVkAVsEi+5VMPa0
         T2SOyI2vQOsHkKJhfHUCL9/HU7YvemEeNkrNXPjx/BJnLB9asNB/4SO0nGfSdYD9F5AQ
         ZDBDkxSE8qD4SYtviiyCI+PcPtlVApUB6rnqXmbbMhyLOwLmC9I6FVLT7oYbJW5+Yuux
         Q0zXKOSaw+FOB8zO0no7Bjj3LH69NkROGTiYl2DpVUSnLtqQByuSqbHTk8T35sAfeXHt
         gyJk2fxUZgX2HYdnbpUYEkMrHRBxY09OKw/HHovv8LaklWUs8iYChNzm4uPyzolC35/z
         bboQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr4MpxyOlW1E2T7RSNpI/rmGy8zvcaM4y5S6Max5Ptvj3vJrxacuNDgB6UA4qL+0BQ+vppbbTBdaMeZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yxl140tKKiUF0kEp0qo4PElMfA9k2qN5SRwGvnKCBo0P0EpJRwC
	IzbrDJkUmvMFNGm7iJgBidVqZ7+RoFU0WV2W21Jm8vLe868yDHiHhMcU36MOz6VEQQ==
X-Gm-Gg: AR+sD11pWqCOU/E6jufSwgPdvBDba5uzQMclB5GJn/VUKpft4vOO9nu9VGx16s4tlPd
	/ZGCXdk+JAUAeKLlx2rD6bRxjGGlO8+F6qRWpLlLVDU7l3Eq2QbkJJgeuvNHzVAx16RBLYtn0jL
	6B1fNw+ciUpYRVZdLRquHedjePXP0gKz9Mnk5utt3YEDbjSaLvrgnaNuuRqnPLr6yNQWckGqEGZ
	3c91PsxXSgq3bm6xBuHsLQeeSyCVnp6gHo6XBLHh+XTWU2w8dlbn4FS5Ii1X3a7MWPlU/QGJcNr
	8Ip+JjSiz1uUyDWkiIbwNs+q9cC3tOsCylpzVg2Iqtmr+g+tWosOJX+y8Bo01/kOKSmUd9mk+UC
	sb/ieZ8vfdgHn8vajwfqvM0GTQl2gDCuuZ6n4QU3TFhNn8Eyyz9BCj4P23ZBhkxRqX5t1EsirZD
	W6HiG2/A2e6UE9+mZqYvuHjQN0XOwYjeokfP6zAl9YcW/FB/PpvTp43mE/jjd6jbjUAeX5lpEYt
	q5ORNpz7BRHnrXre9cMGDtkXFHOS2FV0ixeuPUt6Q==
X-Received: by 2002:a05:6000:4b15:b0:47f:81c6:5a38 with SMTP id ffacd0b85a97d-47f9fc995a0mr6140837f8f.18.1785065574895;
        Sun, 26 Jul 2026 04:32:54 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb57cfsm40533083f8f.11.2026.07.26.04.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 04:32:54 -0700 (PDT)
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
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org,
	Thorsten Leemhuis <regressions@leemhuis.info>,
	Martin Wilck <mwilck@suse.com>
Subject: [PATCH v6 09/12] nvme-rdma: use ib_dma_map_sgtable_attrs()
Date: Sun, 26 Jul 2026 13:32:26 +0200
Message-ID: <20260726113229.2154269-10-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260726113229.2154269-1-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ib_dma_map_sg() folds every mapping error into a zero return, losing
the DMA layer's error code.  Switch both scatterlist mappings to
ib_dma_map_sgtable_attrs(), which preserves it for the next patch to
act on.  No behavior change: failures are still reported as -EIO.

A local sg_table is needed: dma_map_sgtable() maps orig_nents
entries, and the embedded table's orig_nents is the allocated count,
not the count blk_rq_map_sg() produced.  rdma_rw_ctx_init() does the
same.

Assisted-by: Claude:claude-fable-5
Cc: stable@vger.kernel.org # v7.1
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/nvme/host/rdma.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 6909e3542794..63830334c73e 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1469,6 +1469,7 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
 		int *count, int *pi_count)
 {
 	struct nvme_rdma_request *req = blk_mq_rq_to_pdu(rq);
+	struct sg_table sgt;
 	int ret;
 
 	req->data_sgl.sg_table.sgl = (struct scatterlist *)(req + 1);
@@ -1480,12 +1481,16 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
 
 	req->data_sgl.nents = blk_rq_map_sg(rq, req->data_sgl.sg_table.sgl);
 
-	*count = ib_dma_map_sg(ibdev, req->data_sgl.sg_table.sgl,
-			       req->data_sgl.nents, rq_dma_dir(rq));
-	if (unlikely(*count <= 0)) {
+	sgt = (struct sg_table) {
+		.sgl		= req->data_sgl.sg_table.sgl,
+		.orig_nents	= req->data_sgl.nents,
+	};
+	ret = ib_dma_map_sgtable_attrs(ibdev, &sgt, rq_dma_dir(rq), 0);
+	if (unlikely(ret)) {
 		ret = -EIO;
 		goto out_free_table;
 	}
+	*count = sgt.nents;
 
 	if (blk_integrity_rq(rq)) {
 		req->metadata_sgl->sg_table.sgl =
@@ -1501,14 +1506,16 @@ static int nvme_rdma_dma_map_req(struct ib_device *ibdev, struct request *rq,
 
 		req->metadata_sgl->nents = blk_rq_map_integrity_sg(rq,
 				req->metadata_sgl->sg_table.sgl);
-		*pi_count = ib_dma_map_sg(ibdev,
-					  req->metadata_sgl->sg_table.sgl,
-					  req->metadata_sgl->nents,
-					  rq_dma_dir(rq));
-		if (unlikely(*pi_count <= 0)) {
+		sgt = (struct sg_table) {
+			.sgl		= req->metadata_sgl->sg_table.sgl,
+			.orig_nents	= req->metadata_sgl->nents,
+		};
+		ret = ib_dma_map_sgtable_attrs(ibdev, &sgt, rq_dma_dir(rq), 0);
+		if (unlikely(ret)) {
 			ret = -EIO;
 			goto out_free_pi_table;
 		}
+		*pi_count = sgt.nents;
 	}
 
 	return 0;
-- 
2.52.0

