Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2858A3AEB37
	for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 11:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785065584; cv=none; b=p1AoLGUCg1s59Kj49vWFS6G0N74FHHcEintgJQKStu5eWNMixEKCXZ17UFCc6X+oid58SnoN4yNdWHTVPHX6ntJXMmXhFBiM6B2YIYJXvuRWowSbhKqpal69hm2wOb2DuBL8eF2m2idBWK/k6YSGNsdAZjBn670ReAbslF0xx00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785065584; c=relaxed/simple;
	bh=zFBDec2TRFEalsjq0AVcfDV7Wl85mnPHWjbfYz706rA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JTdUN8WeWKgvdaTzqgC6kYL40UgpC66HBJAV4bTBvQvmGM1E7rZyKLW3pWu1IaatRTrSCOXn+8mFipH8bZdWleaPSgEcs44fiZbk6AJUY9THnTWEceOO4A1rOQlYOvNjLJloY87np0ilKCRNvTC9cvhMAUvBKxVhxveW83bJly0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=iATe8DHP; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="iATe8DHP"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-495757ccbc1so16614485e9.2
        for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 04:33:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785065579; x=1785670379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Q14+SU3ApPQKeuQJQq5srmD2x1GZ50vyxARH6EmniXo=;
        b=iATe8DHPHsEM5s3ocUncNSL6Nw/3pJ3sBRQoDcQDMvhQEndIEXKmHcC5HiRfyBr+S5
         wVye1TLuoMAJWPoKi7jxbcztOt1HybUlDvmQZntEURXL8hZVjYUFm/vD7njk0BfJM84h
         YHyMmA9iwBebLQIxQlDIsBmiqe//2z7dPzMW2eDlNfB44yEtjc/qUPxkN3x8R/suBpe+
         u9639UuTLzAdwem5dd7RW4F45JA2dok5+zZx/r75SuiRg6yebB4fU/maVC/3MuTlYgd1
         gm4Ao2w39D80itQyIB/ETTn4lmbChoFTsXdRzoBDxwK+IByQUijEzhrTvA5kxUAiJ+D2
         YNag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785065579; x=1785670379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Q14+SU3ApPQKeuQJQq5srmD2x1GZ50vyxARH6EmniXo=;
        b=YDJOde5t+Q8Rv01YN68oKb0F6hdZkd6O0eQO9TWjcneljX7bd0ZUuNBZ6SVQQAwYAq
         RpznqAYOOeBmBYkPHInInrPDug3hoXWJpLosY+ayfR+mYE1k6d7jm3ZoFEKEjRUxdcIG
         +OgDGFRbfTg3PZTBUFMRuAp/JXgchV2LXUm2w3Publ3c3I7WMtLG4KrdWVjUltwS3iFt
         aU2ACOx01SThGZHLBD0bml/f6qiQOv+1gg0Y5UWeHNq9GZ+sVAl0Dn9HSOD7rP7bKzfL
         vkxqljh/blwaHWqlMRWs4S2/W6/0+I2PzzNTTwfVBw4pDO0eL03TqqV7aHKemtiMUmG/
         cdEA==
X-Forwarded-Encrypted: i=1; AHgh+Ro8LUjwBr0GiLZiRmnBiytSheLhgAyLP5fRphIrPxTekYJt8aObtIzi3zFtzbWjLSaxNPl8yptpWnzv@vger.kernel.org
X-Gm-Message-State: AOJu0YwH5gpe1TtxtQlPHIsOpcV/lKfLgJXwylrEc3ywOi6q/lXnD9ax
	LKHYQayfTj1Ec1+Db/JtWaK69ax9w7VeRgTc4pnKeG5ifV9CRe1vCgBLc89Z9AncOA==
X-Gm-Gg: AR+sD13fvO4py+ibcc9Pgg9LjwfeAlPagzGfa+9BVvv8hfTRm9/VFnLnwjaupWyTnuq
	VtfqY7KbAMr+GZkgP0GQ4u92GGglfuCD4M0U1NPdiJSQeCTZZhg9/pFFECs7YOu4rxi123aK+kH
	1XTfzNSuTa30gwJjiHzHtVkARRTCi0SCEK9y6jCnjIQBSz0yn5aZvP+34GuDNMBqreUW5XgaWS2
	ziymxYMYmWTeS7thEUNJRfkttZQylkNhg3bLlhcjPU3iRqgCfm+WzOSHV1nAtHYYagPC166xovj
	oEQL3PnS9MQhGrPPIYkFbPv56IyzzU70mSUV6sH98x0crsBPnSkVTCTnNNSwjYT6Yh8FcsLPH74
	J8q8kx8DB1CtFbKnRmivpU22OrmrFxmEvfncyFAiVu0dRGYviBj2lueySILkvioQnh8HI1/srAP
	3hM+bEUDUc/5Cc28Vqgz8OyTUUPuhw0g262dsSmvrPflb320M0jwJgbCfNSxivOGQQi7Mk/j4ja
	yOuCwbNMTxm8l5UEeBts8E76T+K2/gQ2GKkXqJ9FQ==
X-Received: by 2002:a05:600c:c87:b0:495:69eb:27fe with SMTP id 5b1f17b1804b1-496b56c58bfmr55527435e9.11.1785065579344;
        Sun, 26 Jul 2026 04:32:59 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb57cfsm40533083f8f.11.2026.07.26.04.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 04:32:58 -0700 (PDT)
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
Subject: [PATCH v6 11/12] nvme-rdma: ratelimit the map-failure error message
Date: Sun, 26 Jul 2026 13:32:28 +0200
Message-ID: <20260726113229.2154269-12-mykola@meshstor.io>
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

A mapping failure is per-request and, for an unroutable P2P transfer,
deterministic: a workload that keeps issuing one turns this into a
log line per I/O.  Ratelimit it, as nvme's per-I/O error logging
(nvme_log_error()) already is.

Assisted-by: Claude:claude-fable-5
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/nvme/host/rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index c38d949502b7..2f50509a7a61 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -2040,8 +2040,8 @@ static blk_status_t nvme_rdma_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	err = nvme_rdma_map_data(queue, rq, c);
 	if (unlikely(err < 0)) {
-		dev_err(queue->ctrl->ctrl.device,
-			     "Failed to map data (%d)\n", err);
+		dev_err_ratelimited(queue->ctrl->ctrl.device,
+				    "Failed to map data (%d)\n", err);
 		goto err;
 	}
 
-- 
2.52.0

