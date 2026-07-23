Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96AE43B6FD
	for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 20:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839383; cv=none; b=Zdho+IjHpxXPOhDcx4/skfgzsegtIQqJQxfS4VG5mD2k07yrG/KbONg8dm4MNroCRC4xOf7Dd5xkbD6KtUVfAEP0enN4VHMU6F/Zh6rNCNqbYeXkjN/mnsnb4yoRMqmqJZFKt3RNtvH7Ed5eiUMAo9Ggp3NdKDCyA6B4uqXitME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839383; c=relaxed/simple;
	bh=duiRRHdzIykrisUAseIhJOxQn/X2Aiz678fZQ0WGdro=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZnuqHqtsXT4pI1ClcB8s8aRD2gczxt0BzfGcmLFhqxuGA72Vre9GAF1HGlbydZNAlzCnZZXjIVADPEA/G92ASSH1+J671cjn4k3apyniyGGa4HWfuhsIogio8FScMpByIiUGK3nmES7Ell5HLWNORVbz1zJZFxUOBW6ZtKbXAaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=GRRp3Z9O; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="GRRp3Z9O"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47c2b362ee2so947931f8f.1
        for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 13:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784839373; x=1785444173; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=E5idRe2CDp786J3ag0YcRdkJhpW3jRwxGiXDWMRNXt4=;
        b=GRRp3Z9OchYW9aYVO2Z5s4bG+ngjTlLw9V/1GOLi/ER7ZRSMR1kDntz2NBmZW6UdsX
         A423uxBjPyl5vs8fDoa3yGtnSmrTO2LPBDV3GYHtDwOzSowGDBbMl56bY+yLeuc3L4+a
         N83TaUE92jVEeDeHQE2vmzszgdY2pXLvM81SCH0KqhE5QdnLZmlMcxugU/96mFYgcuKE
         k3E5ZeBQltBrS0HVv0Q299axZhbfr21TF8stCmc7a1n2e2CtRK5dUDAP2+tidTk0iDgJ
         SQBkUEjHEwSuWPr/lrAcbCRy/8LSHn4Leya87/Ayt/4ZnVEECxuu/wkzsRy6FyF6kCbR
         D2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839373; x=1785444173;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=E5idRe2CDp786J3ag0YcRdkJhpW3jRwxGiXDWMRNXt4=;
        b=NXsAckIXyOk9NDO2FPLpU04nj+voj+VeqbRqGT3dD8JSGFgfjyHLSQF0m57MarZ6LO
         wRxnn1mhAekLO6ARCrpMm6JXjdoXPnJiP2xU/i0/MH0mx0atl8QHvfDx1Mh9z3BF3N5H
         ysXYzRnXGDsJMfjAH3jJGb+BeODg985hV/76gcKkg7xa+63mCfGLvTX3PtxVGN9Kn716
         iE4+m3MQ/lJPkxczyVZLHANWJXR2QSGn61Q4TvU0NSB/y+trKs/VgPggThrP2H+y8/wn
         esKUQdl7iORpPjsaXlK/uWsr5hVXpZRUGZDxMFn2+Z1QPC6wL+7zAnwva4lGPeeSUV1q
         iP0Q==
X-Forwarded-Encrypted: i=1; AHgh+RraGUbwwcsm57Rvj/2m5DZvnTkPf93xecQsaSQ6NOQVacFix8ABxmt02R8e+bPtvrmMCPqWSvQ5rOjN@vger.kernel.org
X-Gm-Message-State: AOJu0YzE6R9pPA/8crPllD4NkrjrDQ7Waxe4RFDDuvmIQzYECNc+9BGd
	ae57ug8ffDAw4MMkimkRjy2qFSGrAWLhRV05paWu8d0gkyXVy3Q2MZ1tAMaLca0hAg==
X-Gm-Gg: AR+sD13Hv2SC8T4m1cZij0o2eUpEeLhxl3wTOoQ5qfb/G24pZAPI4H7JdgBzsKxuv/l
	aBzoCXzUladW31XSO305KQCSFnnaOWYOfG4Pu8zmnX1k8lCpkrOz7W54mHgv1GrJVfmPp8YoiN0
	1/RlB93sktjqZG9bQayBfiw9uceIKP1HP/3Xt6394CaQ9rFlzdC0YZiB9/1LLu+nbYHwfnzrpJn
	ekWUBZ1FJ6vyylvYfbckr+upOZXAWu105v76KBi76v+WHx6evvrUZr4q7HX1oDrvWlUm1vHmdhX
	tr3SUKCVTLUGJSbEGEuyjP7sPxBdsA0HaxVKs2T3uzuG+zHkqPB6HWpBmXfFwDimQWEhTd8TJ7+
	bNC1klds0dLXLcLsz54Zwrn+H1v2jGKnVkRKpIkKpLQ9TNlJvwBmGS+mwxyNeBT+Mo4YV2jzScV
	So/MPYeuoHB7iGilAWGYg8Da7Gfb+m9ena35p5GyuHXzLROVOAXzPZMiqPsrkGcE8PPwC6IA7AB
	7tGd6N7MwWV1jQyNFEvGIeO5sGiACjdLXmyTjiTxA==
X-Received: by 2002:a05:6000:46d4:b0:47f:93b9:b76c with SMTP id ffacd0b85a97d-47f93b9b770mr1881409f8f.56.1784839373145;
        Thu, 23 Jul 2026 13:42:53 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c52fc0sm18268192f8f.23.2026.07.23.13.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 13:42:52 -0700 (PDT)
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
Subject: [PATCH v5 00/10] block,md,nvme: correct handling of unsupported P2PDMA transfers
Date: Thu, 23 Jul 2026 22:41:56 +0200
Message-ID: <20260723204206.76930-1-mykola@meshstor.io>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

md treats an unsupported P2PDMA transfer to a member as success, and
nvme-rdma retries one forever.  Whether peer memory can be DMA-mapped
depends on the PCIe topology between the two devices, and since v6.17
the failure completes as BLK_STS_INVAL: retryable for multipath and
deliberately ignored by md for member failures, so mirrors silently
diverge.

v1-v3 restored BLK_STS_TARGET for these failures and tagged P2PDMA
bios in md.  Logan Gunthorpe proposed a dedicated BLK_STS_P2PDMA
instead, so no consumer needs to know whether an I/O was P2P, and
wrote the core patches; v5 is built on them.  Patches 1 and 5 are
his and keep his authorship.

  1  block: add BLK_STS_P2PDMA (stable, v6.17)
  2  md: ensure REQ_NOMERGE is set on P2PDMA bios
  3  md/raid1: serialize non-write-behind writes on CollisionCheck
     rdevs (pre-existing bug patch 4 would widen; stable)
  4  md/raid1: no write-behind for P2PDMA bios
  5  md/raid1,raid10: factor out raid1_write_error() helper
  6  md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error()
     retry clones
  7  md/raid1,raid10: skip futile retries on P2PDMA mapping
     failures
  8  md/raid1,raid10: set IO_BLOCKED in case of BLK_STS_P2PDMA
  9  nvme-rdma: use ib_dma_map_sgtable_attrs() (stable, v7.1;
     dependency of patch 10)
 10  nvme-rdma: return BLK_STS_P2PDMA (stable, v7.1; needs patches
     1 and 9)

Routing: patch 1 block, 2-8 md, 9-10 nvme; 7, 8 and 10 use the new
status.  Patch 1 alone stops the divergence and the dm-multipath
requeue loop; the nvme-rdma loop also needs 9-10; everything else
refines the fallout, so the series bisects safely.  The md patches
fix a v7.2-rc1 regression (02666132403a), except 3 (older bug,
stable) and 5 (refactor).

Tested with the QEMU raid1/raid10 error matrix and a ConnectX-4 Lx.
After patch 1, block-layer error injection accepts status=P2PDMA, so
the md completion paths can be exercised on any member with no P2P
hardware.  The patches were developed with AI assistance (see the
Assisted-by trailers); all code was human-reviewed and tested.

Against v7.2-rc4 (Logan's base).

Changes in v5:
 - patches 7, 8: From: is now Mykola (Logan's request)
   Logan keeps Signed-off-by on both, Co-developed-by on 8
 - patch 8: raid10 declares bio up front and bi_status sits in a
   blk_status_t local in both files.
 - old patch 9 split: 9 is the mechanical sgtable conversion,
   10 the -EREMOTEIO -> BLK_STS_P2PDMA translation; both stable
   since 10 needs 9

Changes in v4:
 - new BLK_STS_P2PDMA (Logan) replaces restoring BLK_STS_TARGET; the
   R1BIO_P2PDMA/R10BIO_P2PDMA state bits are gone and the md changes
   shrink to completion-time status tests
 - blk_dma_map_iter_start() gets the explicit
   PCI_P2PDMA_MAP_NOT_SUPPORTED case (Logan's patch; v3 kept
   default: only)
 - write completions record the whole failed range as bad blocks
   instead of narrow_write_error()'s per-block retries; v3's coarse
   retry is gone -- the new status is deterministic, nothing to
   re-attempt
 - read path: bi_status is evaluated before bio_put()

Link: https://lore.kernel.org/linux-raid/20260718162547.448892-1-mykola@meshstor.io/ [v1]
Link: https://lore.kernel.org/linux-raid/20260719105327.864949-1-mykola@meshstor.io/ [v2]
Link: https://lore.kernel.org/linux-raid/20260721174502.111503-1-mykola@meshstor.io/ [v3]
Link: https://lore.kernel.org/linux-raid/20260722185841.449934-1-mykola@meshstor.io/ [v4]
Link: https://lore.kernel.org/linux-raid/9f846c85-f427-433a-b87d-8e9e3a4406e7@deltatee.com/ [Logan's proposal]

Logan Gunthorpe (2):
  block: add BLK_STS_P2PDMA for unsupported peer-to-peer transfers
  md/raid1,raid10: factor out raid1_write_error() helper

Mykola Marzhan (8):
  md: ensure REQ_NOMERGE is set on P2PDMA bios
  md/raid1: serialize non-write-behind writes on CollisionCheck rdevs
  md/raid1: don't use write-behind for P2PDMA bios
  md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error() retry clones
  md/raid1,raid10: skip futile retries on P2PDMA mapping failures
  md/raid1,raid10: set IO_BLOCKED in case of BLK_STS_P2PDMA
  nvme-rdma: use ib_dma_map_sgtable_attrs()
  nvme-rdma: return BLK_STS_P2PDMA for unsupported P2P transfers

 block/blk-core.c          |  3 +++
 block/blk-mq-dma.c        |  3 ++-
 drivers/md/md.c           | 10 +++++++--
 drivers/md/md.h           | 15 +++++++++++++
 drivers/md/raid1-10.c     | 16 +++++++++++++
 drivers/md/raid1.c        | 47 +++++++++++++++++++++++----------------
 drivers/md/raid10.c       | 27 +++++++++++-----------
 drivers/nvme/host/rdma.c  | 38 ++++++++++++++++++-------------
 include/linux/blk_types.h | 10 +++++++++
 9 files changed, 118 insertions(+), 51 deletions(-)


base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
-- 
2.52.0

