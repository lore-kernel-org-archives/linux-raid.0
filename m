Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCE848380D
	for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 20:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839404; cv=none; b=HlCfLDWECSLdlqvVhWqyww1fLlCAPDD2fb2+SiU9NIGC3VnIgdIygruphXTxZQkCkH7flViojpwimtPGzsUJ5bwE+6hHSsMfni0KbuzcxnfhfsZ0kgkvYeNYmdCHBrZvNxlOaH6CftmnIms4ENGtvegGMU+hnyBbpsjF/qL/lSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839404; c=relaxed/simple;
	bh=sQcSSX/jufOA+fic/HSdeMNwwQDiSrn4ZEB0dsr0Z0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTAX43pTO2Hu/fEvcBTBqwcK7ECA647YqlpkFIKllMhEnylj/2ITGq2/9C1x+yEE+UVEqxGdWGCgsG4mrqBvYfjnSDsmw8mM1gy4lGZxqLAH58/ioGz4loJtaG5VMGbsdH2SUldTS5RzS//K2PQGZrAyTYCiabZ2QJEdHR0EaUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=A0PhEHmn; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="A0PhEHmn"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-47c2b362ee2so948102f8f.1
        for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 13:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784839393; x=1785444193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wlFyTwpdvsIeETeN6SJHO+G4KnBBWZplfaizFoTi1JY=;
        b=A0PhEHmnTJ9+QVVolXbcvu7kUytNNzkuhnHI49ebvWjAT6aQC68XJXaZrWn7EYoFv5
         UIO5jsHccWyUmv7Nv/1ttGqpO6WGslxxl0LC7v3d2+kqu8O6A4jeX57CmWsLOJU5+l07
         JUMPQJJdBfPptyNw5ZmEZpCs6++PzJKMUNnrMRAA6hdTyIF/T/F4TH/OpLZvYP8EtPdH
         axSjIMMIRo/9Qv11/Sq3CpM7Sp/JMxKM93gVOS9NxH9ur9U9e2WTf5uKUKO+kc1gb6gb
         DoXu81Q0TiGqj9JO1cZDqx/lBMgNGlBkDNSOWle9RU93/xX2Cd5Xm0D106GZydDPVLmQ
         bwfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839393; x=1785444193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wlFyTwpdvsIeETeN6SJHO+G4KnBBWZplfaizFoTi1JY=;
        b=KFJ328OCFtJOa/1jWjHsNuoBS+s15rdywSwoSiHZooWpLTrHY9LbQUkYUadTmA6rfB
         uyKV3Ql+l2mj6ZVnZtvIqIIkJqc1kqn2BqXhTnj+5DbBbEnVgn1tkvqcG4F3+d90r1iE
         E0ODK1txkQNA4DYBtXGEhGlTbuPi8ycNlqAXbs32a/JCaQfXY2KBtnrJEeclE0pluQNh
         XC+uC4Xtpb5zyZqrCZrR4Ig5TtvrUkWIkiwP4t9FjZi4iKwZtqnFdnN9rWpsnko8+oy5
         Q4K5d3jnoX2ToUkHQX5SnA1eA77dT4U5S0jpmTv2FjhNlcZFN38amoJU7CYH+o1p2cNr
         An0A==
X-Forwarded-Encrypted: i=1; AHgh+Rq0//JAdGxKNBlzLrpwsY4FPNCC/qEXciWfZoV9EWDcsAwoVvcnvQl6XYVki5mg7RUN+T2SXgAZDv2T@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1mcZo6vN2hOeGpr3jWOzYrelnXpTGia1UDp8jMW5nkgN7w72H
	hZCUVqKacOPlWKpih+hrQ7b4uZA1rY1n88Ria7NlIRab6WXv1iklQf8rPMVkUaeNkQ==
X-Gm-Gg: AR+sD12iKZ2rg/alAIS7AsyU68tyLf3OiJHswhjyrFJ6tGMEz+S3Z4zU/0vSQKqXaLC
	BMUVJZ438nhG9lv0mjd0Wf4SyOuldEI+pxOtKsVBeR/RkYmhqJuFmzeolXifxGHF6w6gNWJ7PUu
	kdKPHXsCcH2rE9zmT2FkB6Nk0BGx0dkE4MfziaEOos/A23O4PfnUBgZD4gpXL2Q+3qTH35jZlFw
	qoGwJTR3JZyV6YVXdWEowLBstVv3HPDQeBG1RIPuekj4OYFaOs4sAUroCs68J3J+H29LrHZ9+i4
	aW4Dohl1TJ1RSz+kCsZaGBDZPUxsvBB/5lnqIMbjzle64q0FyK5oDxUQxTOC9mSgHtMclVaaSqP
	xuIYg6ToEIX3MtcoV2D7ra4Y6Qkaurk9tq5HJ+TJXqGxN1IfA2bOBr+ycI73ASr5BwkneJGklPw
	EUH/rCvOdwy9T07z6hF1b2DImOmyaNFp6PYBF8W5O+fxV+PFCZ0Kz46rkGB96+Gnsb5FSLnkDaQ
	OUSRKevJuaWP/gP/517hkMGIQ77aS5CVM07DVmqjw==
X-Received: by 2002:a05:6000:4203:b0:47f:7b75:61a with SMTP id ffacd0b85a97d-47f8d71f494mr6221114f8f.15.1784839392888;
        Thu, 23 Jul 2026 13:43:12 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c52fc0sm18268192f8f.23.2026.07.23.13.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 13:43:12 -0700 (PDT)
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
	linux-pci@vger.kernel.org
Subject: [PATCH v5 09/10] nvme-rdma: use ib_dma_map_sgtable_attrs()
Date: Thu, 23 Jul 2026 22:42:05 +0200
Message-ID: <20260723204206.76930-10-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260723204206.76930-1-mykola@meshstor.io>
References: <20260723204206.76930-1-mykola@meshstor.io>
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

