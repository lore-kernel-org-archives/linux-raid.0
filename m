Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4193DA5CD
	for <linux-raid@vger.kernel.org>; Sat, 18 Jul 2026 16:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784391978; cv=none; b=JcgnxfKdMauTzThjKdNjkZ4tQvsfwcdPcAPXqVRu5uZbYvZaVUs7zFn5V0oIEc5bV7ymkp+DN2M61x/wXdlgZexbz0pLeDKj8mamIFIdNERvfZmAkL/T2zOJP+WjS7DhbDZs/hhmwW1+MXvWaOxgE/TK0rAuXNoEcgFO5CgyOMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784391978; c=relaxed/simple;
	bh=vQcr8xq5kWGZvugjiEEaiZG5UL1l4rnSHXCuTtt66Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7GpYQyiRbCNbHita1XC37HluAAeRn81A8OksuuG0BWVQW4adCigOOpZ+YCBu93iBUnp2Rbvg3TZBCg9ljbET63DEftaWjJk2QUB9YdQjc7pZDthUGZ6v4PUfEXPEFMVWHJYrBi288MLmml0zocW7LqLubKLdwqGjxkM9X4nGZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=raDKZ11L; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="raDKZ11L"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49556f97a9dso605815e9.1
        for <linux-raid@vger.kernel.org>; Sat, 18 Jul 2026 09:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784391975; x=1784996775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v4Dvf1BFTy/Vc0nJhWIM7SPA1tR6TPAktef7abvXxvQ=;
        b=raDKZ11LisN1xvciqBKE3E4FmiVh6k0JJw3aZiG3DmFsTUGeGF/UIj48Q4QvywzYYw
         Xku4DGrRIZGL/YTY1lIogmT5AetVNkE9zmydJKhtiiAG4i1T5j9UdTolimwQDBp4pN1A
         bsO0tjG3cNv0sM0ltGjqTipr5kd1zAsBC5ET38abxseD+cXyokkuYQvVJ9GMsfYacuSL
         f0C7qZPhFAwW6ZX4qwQXs5gbQlCYaVIgd0FlXCgmigADVJjmA3m5dTIymz+X6WDjiBE1
         cUtLrWI3hLUQPz7MWhF4wKCuJ+AbOfBQjOFOs/XDKAad6NhIzyicMLc7Ee/Hc42SZIII
         deLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784391975; x=1784996775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v4Dvf1BFTy/Vc0nJhWIM7SPA1tR6TPAktef7abvXxvQ=;
        b=Qdlv6jVBzkZewnB+8rrLk+SuGGTLRUqiJHgs1YiZDCB8cfAOu1KKQvtkPLz8IuWDrF
         /3Q8C0Chw99e0d818rCYowpVoeGkk88Ss3vjLcRYx6JeobCKlsNM+6lKvMM/DF33iLmj
         qvlaI36xjsaoHk8WdF9fRtiFoY6mrF4PiMiaZPnXL63OMCm57xaXkXD/6XgWYYbG4v+2
         5ctVPW3Q19JYShhxn4dFepMFjkgGfBBO9+2C+HLWWZTZcu6nBzn6JF7lsRVwl2jsP0Of
         UeJvjY4N9FTPI8pm8tTc9dLcms0926J9l+pLvkrnoq3x1nAmJRHb1AIHRApH4PaLvFVi
         iMcg==
X-Forwarded-Encrypted: i=1; AHgh+Ro85ZYSPDyUl/msRGDJKvT9f6QvZR9K1KkCvCIF/xbv11wiPhNYH5WDWCnZZjkydCg9ETQvMyuhS3DH@vger.kernel.org
X-Gm-Message-State: AOJu0YzSG7AdlkfabdpNVuWtR5TMd6z8dkYmiS2h8a/0lJzzWLpAm7bi
	PurKyR0orNg+jeT3hlHo8aoTBdtCXNAtjvQM/FJSx7BV4Ko/PMkHFKPQc8rP3brWQg==
X-Gm-Gg: AfdE7cmrB6b2LISwRPtcMxYCeJFHRYmuT/uJsoatcdGElUtbtK/DZLIjIpEoxiuOiP8
	PiDz9tNK82/4pQQF+KBFr9WlnxeBB0843U4hCaF4p71atpNBNUMIkxrA8vk4IYvnhnsbXGLrXF+
	iBaahSgD5Bg44LRwTsXOJQpvrg4Gn9h6R03bxOEqBcWLJdev2pz0vPuF0BvVnGKVg3v80sWZSKG
	8uieX5q6YmF/AUPuAc9Wz3UPzX6AZi7Ll+Nnpz2NhKSEvyIcAFcB2uAdrGbBD8VAqajgVGmV4q3
	QyhNjqj3zMMOXpp91zRKBojRMIyBoszsuxAw8ay642lr40s8nTHLajHsP41Cp7Kv8aZTDuM5Zkf
	F4RerbxzdSUb5JtJ+ipVhH+YZV0kFlAbdY5iXso3DVwdBtI+mpwgGiDZiunXUZQ==
X-Received: by 2002:a05:600c:6b69:b0:493:e583:7053 with SMTP id 5b1f17b1804b1-4954a41431cmr58900345e9.35.1784391974915;
        Sat, 18 Jul 2026 09:26:14 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2eddb8sm266444085e9.14.2026.07.18.09.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 09:26:14 -0700 (PDT)
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
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
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
Subject: [PATCH 1/6] blk-mq-dma: restore BLK_STS_TARGET for unsupported P2P transfers
Date: Sat, 18 Jul 2026 16:25:42 +0000
Message-ID: <20260718162547.448892-2-mykola@meshstor.io>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260718162547.448892-1-mykola@meshstor.io>
References: <20260718162547.448892-1-mykola@meshstor.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 91fb2b6052f7 ("nvme-pci: convert to using dma_map_sgtable()")
deliberately mapped unsupported P2PDMA transfers to BLK_STS_TARGET,
matching dma_map_sgtable()'s -EREMOTEIO: "When this happens, return
BLK_STS_TARGET so the request isn't retried." The conversion to
blk_rq_dma_map silently changed the status to BLK_STS_INVAL, which
regresses two consumers:

 - md/raid1 and raid10 ignore BLK_STS_INVAL leg failures
   (commit f7b24c7b41f2 ("md/raid1,raid10: don't fail devices for
   invalid IO errors"), where it means a request-shaped error that
   fails identically on every member).  Since commit 02666132403a
   ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
   P2PDMA bios reach md arrays: a peer-memory write to a member the
   peer cannot reach is counted as written, the master bio reports
   success, mirrors silently diverge, and on a topology where no
   member is reachable the write reports success with zero copies on
   stable storage.

 - the failure's classification flips: for direct NVMe consumers
   (nvme advertises BLK_FEAT_PCI_P2PDMA) the mapping failure has
   surfaced as EINVAL instead of the documented -EREMOTEIO since
   v6.17, and blk_path_error(BLK_STS_INVAL) is true, so a stacking
   consumer would treat it as a retryable path error (dm-mpath is
   the only in-tree blk_path_error() caller; P2P bios cannot
   currently reach it, but the classification is wrong on its face).

Restore BLK_STS_TARGET.  md then routes an unreachable leg through
its per-device error handling (badblocks, WantReplacement, mirror
retry for reads); a follow-up patch teaches raid1/raid10 to handle
mapping failures without the retry storms that machinery was built
around.

Fixes: 858299dc6160 ("block: add scatterlist-less DMA mapping helpers")
Fixes: 7ce3c1dd78fc ("nvme-pci: convert the data mapping to blk_rq_dma_map")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 block/blk-mq-dma.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index bfdb9ed70741..2eed06bfe791 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -190,7 +190,15 @@ static bool blk_dma_map_iter_start(struct request *req, struct device *dma_dev,
 	case PCI_P2PDMA_MAP_NONE:
 		break;
 	default:
-		iter->status = BLK_STS_INVAL;
+		/*
+		 * P2P transfers that the mapping layer cannot support
+		 * report BLK_STS_TARGET, matching dma_map_sgtable()'s
+		 * -EREMOTEIO and the pre-blk_rq_dma_map nvme behavior:
+		 * the failure is a property of this device pairing, so
+		 * it must not be retried on another path (blk_path_error)
+		 * nor be mistaken for an invalid request.
+		 */
+		iter->status = BLK_STS_TARGET;
 		return false;
 	}
 
-- 
2.43.0

