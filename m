Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC3A343D72
	for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 20:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784839382; cv=none; b=CLS2oVGfY1CyiJ1PzFO5ddFMxViHp8yB7XvfA+UZgiEMinCHnEi3VvYPOTxsSzTvL3mPRBQkcWzJ18Lsh3ywhtseVEosXxA/U3Dm5EnbaSLZh/Q9IHR/8xNUXaJ9C5V8M2v7nsA7gUukrZZoDj3Mnv63f+enrGO46CiujChAUvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784839382; c=relaxed/simple;
	bh=cRH7W6syefYxFA3VhhN4QvzFBoE55r52A/E6t9wrD1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfRtI9O3Pnxon5NbknSSZpmv5TVc9Su2CX9negAFBlnmPWJ8zFlVTMXP7XobDj3Rc96KALiPqUi5KG92bLXGWQ0dx4DIppStNCIjpceYiy2wAT/AUrwAVY8qT3B/akR3RgwZDIRbrzfGPpMA/KAHRq1j6JN1cR70f2AFS00PNZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=SesB9aK6; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="SesB9aK6"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47f84023916so1008446f8f.3
        for <linux-raid@vger.kernel.org>; Thu, 23 Jul 2026 13:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784839375; x=1785444175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LNWXk+rlZiNRYyXRDGVV7qCvY4AZPHPO/XYCzCCpSWs=;
        b=SesB9aK6CHrwPAFEI1B193p8OPva428cDKaNqpizhHiUhewUqHwqrmjD/xRwufSFok
         C0QIDvLbdC9pPZ+CEdXlIOyILZKCt6tsMZk99YsEvzEVMMXsNcXjvcShGE7KV9h62HlJ
         oyLFTnuqUYUO/StJAprXzTVNjytYoEhdeRDI21Aw4klritgm4+4yPAYSIaUwQVxtIrAr
         U+vpIpCu+rXzhzxyPyWR2tBGmf/yyfgr1Pw3Vt60fpaT+bjvDrn5gmUldtn9AlpfwEOR
         YUhDPe/enCYSdSa5Bm/9KVvO/O4FfEjHycGze1EOP2z7Zz1ZeqgPV1ph5RSwUjsi9PbK
         eQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784839375; x=1785444175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LNWXk+rlZiNRYyXRDGVV7qCvY4AZPHPO/XYCzCCpSWs=;
        b=GK4SMXs1kX7oU1PFskTl+i+N/U6kump9W9bl/BavtcLf9w3I0oUEquioxsQyFYvFF1
         /ckOzKn1xEUSyYzqzwHUKoEdeRy8ZA8rq0HNzO/yfyQMNIays2yUCFNlSDPFtn4D5RTQ
         ASbfAoshhkDTcc8B8/4/R18PHoiMiRSQ+9ob8gmjTorzcP+57NTTDv2sFDXKiouWAu7J
         DaGdY0UxGHqfN5T6ArylhUf37w2iJWmRJn2HaNM4BSpa8nG3VHsKr17gTv+osWlFGiN5
         oXI2bZoIt5APOdeDtyZpALaC+pUJZg/0AWYbZjLbL3Gl9ZqzOtafzbhBnyizh8yGkCym
         +cYA==
X-Forwarded-Encrypted: i=1; AHgh+RqvQQM//zToJI7Mm/A4D8e9xiF0D4Att2vLfbKmdc/BXGtUZjFVFDto4aLI8QD8m2oye1m034gIx/Ok@vger.kernel.org
X-Gm-Message-State: AOJu0YyJtSkmjT1kgL5BZI1va3WqRZb2BBTHil4e8hFMWhn29sYc/as0
	vXRKZQeftbEAhI3aUIs3zlKFvd7iyaLx6d+zHc4gTHs8TY1XsA1Cm1WUAsMjwsn8eA==
X-Gm-Gg: AR+sD10JI70kqumWUStwPrnk4owLKpUrqmn4mmmwnv2eEKNUwg1JVo8JbyOlAqwLfo+
	giNyuyiAQU2eWeiLREDU/HSOEuWcjPDIp9FGScA9Fb9gTSdfQYTllO2+yvrCaoplRsu0IP+Le+V
	gUjOvhF30OroWY2uoZnBwA2tVO6fgj3f+E9ffBiagpdE51zA/ttGEADYmoOkU28cCP6xiyGhDjw
	0T//9pWXK7GrwYOPuBmlqWHx/iGXuCVTZY/S9ZK/b6nvvLa1vaHNQaBTnE3Z15y46XCSmecUqul
	vnXgrcqZ3UCqtyemRxLj31w29r3I5kKH+gfwhdZ4EVJIzasvYeUFxP/9NTrRIBOQXX0NQoFGc5X
	veBw08DnM632nKec3DyuQQORkzT7pPDbLACikS0tnNbiUKZCGjlaY26tl3J1ELwATEHlWu5rhPi
	+7GJNFa8W5ydlrE6PLWciZdcaeWxMMp3LZ5DTQt/Aaeie0M27Mh1uN416M1sUV8UyAn/SL0zRMa
	tWPEaiB4D6z/f/FZ5sTAFbjzg0jk5a9arxjPkANfA==
X-Received: by 2002:a05:6000:240b:b0:47f:87f9:6d06 with SMTP id ffacd0b85a97d-47f8da5e25bmr5949800f8f.61.1784839375286;
        Thu, 23 Jul 2026 13:42:55 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c52fc0sm18268192f8f.23.2026.07.23.13.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 13:42:54 -0700 (PDT)
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
Subject: [PATCH v5 01/10] block: add BLK_STS_P2PDMA for unsupported peer-to-peer transfers
Date: Thu, 23 Jul 2026 22:41:57 +0200
Message-ID: <20260723204206.76930-2-mykola@meshstor.io>
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

From: Logan Gunthorpe <logang@deltatee.com>

blk_dma_map_iter_start() reports BLK_STS_INVAL when a P2PDMA transfer
is attempted between two devices whose PCIe topology cannot route it.
blk_path_error() treats INVAL as retryable, so multipath requeues the
I/O forever, and callers cannot tell it apart from an invalid request.
md also ignores it for member failures, so a mirror silently diverges.

Restoring the old BLK_STS_TARGET would stay ambiguous -- nvme maps
NS_NOT_READY, LBA_RANGE and CMD_INTERRUPTED to it too.  Add a dedicated
BLK_STS_P2PDMA, non-retryable in blk_path_error(), and return it from
blk_dma_map_iter_start().

Fixes: 858299dc6160 ("block: add scatterlist-less DMA mapping helpers")
Fixes: 7ce3c1dd78fc ("nvme-pci: convert the data mapping to blk_rq_dma_map")
Cc: stable@vger.kernel.org # v6.17
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 block/blk-core.c          |  3 +++
 block/blk-mq-dma.c        |  3 ++-
 include/linux/blk_types.h | 10 ++++++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 365641266c9e..83cb5464265f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -177,6 +177,9 @@ static const struct {
 
 	/* Command duration limit device-side timeout */
 	ENT(DURATION_LIMIT,	-ETIME,		"duration limit exceeded"),
+
+	/* no PCIe P2PDMA route between initiator and target */
+	ENT(P2PDMA,		-EREMOTEIO,	"peer-to-peer transfer unroutable"),
 	ENT(INVAL,		-EINVAL,	"invalid"),
 
 	/* everything else not covered above: */
diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index bfdb9ed70741..e88d6b3524e6 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -189,8 +189,9 @@ static bool blk_dma_map_iter_start(struct request *req, struct device *dma_dev,
 		 */
 	case PCI_P2PDMA_MAP_NONE:
 		break;
+	case PCI_P2PDMA_MAP_NOT_SUPPORTED:
 	default:
-		iter->status = BLK_STS_INVAL;
+		iter->status = BLK_STS_P2PDMA;
 		return false;
 	}
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8808ee76e73c..c8de7809320a 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -165,6 +165,15 @@ typedef u16 blk_short_t;
  */
 #define BLK_STS_DURATION_LIMIT	((__force blk_status_t)17)
 
+/*
+ * BLK_STS_P2PDMA is returned when a peer-to-peer DMA transfer cannot be
+ * mapped (typically because there is no route between the initiator and the
+ * target that the platform's PCIe topology and ACS settings allow). This
+ * is a property of the initiator/target pair, not of the target device's
+ * health. This error should never be retried.
+ */
+#define BLK_STS_P2PDMA	((__force blk_status_t)18)
+
 /*
  * Invalid size or alignment.
  */
@@ -188,6 +197,7 @@ static inline bool blk_path_error(blk_status_t error)
 	case BLK_STS_NOTSUPP:
 	case BLK_STS_NOSPC:
 	case BLK_STS_TARGET:
+	case BLK_STS_P2PDMA:
 	case BLK_STS_RESV_CONFLICT:
 	case BLK_STS_MEDIUM:
 	case BLK_STS_PROTECTION:
-- 
2.52.0

