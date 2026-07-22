Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A598938D40F
	for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 18:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746751; cv=none; b=BNBlLoaiBkIFJTmhyFyG1so3XHp/PCHZUahl7/BB2oX7z3taSOevpCZwZEG6gfy8hRSY4u7mJpWLdnroRVJ+KJqRhV1UOsIVVVAtAaAKNPTjWstteZY5FTBMJhOA2UW9rRB4qN8HicUOKeLDqZ1tp0yoZPK66cCAyLM4XV3hTGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746751; c=relaxed/simple;
	bh=UmHDQ8Avh88213YFsBTKp7WY9yAPzXpx6PsDprJSvWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWEOboNG/k7cpNpTgHo9mZOWnUgvmceP7arBGym1zefi1yvR29pFLALEmOVr/46wm154ingsjf/PuZhyzY4a/+AuSWuaxiUjFvLPTZ/xRwZSh+sKpNEOljT172ZcetNDd1ID8fiMQHN/sLEAQ45Q7ZNSJQ9ngFBuTNM2K6qPntI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=pO2ctPAC; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="pO2ctPAC"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4954a32cf1eso24596255e9.3
        for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 11:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784746743; x=1785351543; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V5hliKyCAPWFZqHS5mW2T1dJRPt4J/vTka7mcNCHq10=;
        b=pO2ctPAC573zzwGSfqULFeBA/5OYTJ9IkLMmUQ1RrtLSK3KfQS67DoOTO1kXRMVcya
         ACKo1PTnFejVlqK1mJ2B7lvLgQjhUUIz10hXfa3KGkvobunjwH6ccIGlqZtzITEUKLGo
         K9jTdr8MlsILiYfBr76Tfr4iOEOOXEXRgam3mpvmRrDutTw87yV0VAeAtxL7pA+B7WCZ
         mWoqdrMEA0gIJbX29W85S8v/qNcw3urPkU1GbNFi2T+jfYpMwqWoyuEBsCAdAh5SR3I9
         OeVFWeaX4uwA6M0Nd+EQszydv0AU6zpsVxdwRx49or6g1yrsqNGgpKFlu1ORIke9WuSX
         GLpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746743; x=1785351543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V5hliKyCAPWFZqHS5mW2T1dJRPt4J/vTka7mcNCHq10=;
        b=PTjSp+EMRN5AV6iCZg8FnwDQ9GNze8Asp0EuVqzU8Lbl1u2S892pXNZA7cPIxMLz6S
         FS0c1QpRv/+FSdM8Xqmjd4aM8q/8XCL2LhbkuaoCR6IRneR2bXOOcsjo0LO/o0fXfcm+
         AbDkNj/ZMSEg6yvrcpW0fXnSt0qBdBr5poSDRDPbuqblsmffWWqGngbE7PqG4HEy7IBW
         LpIk1uFkjWh8kEgWUZoBe+QR2RUFQPrY69hDZvwe5lMgiCMzuzAo42HgiNha/bvV3qss
         4zpNmAtUXWKrMA4y5ixTn17ZK1ZAxBV+it54N6C5SGkNHpSjyJtGcKwZh/z27Nb7LlTM
         xSsg==
X-Forwarded-Encrypted: i=1; AHgh+RqhfdFzY+0suFFCLZixqQcfgDGmZb2FWDhGUw/RVn3SOGmcOUrfPigGGq6pp/rcgnFsYEIJqckB0Rs0@vger.kernel.org
X-Gm-Message-State: AOJu0YyZXXyld0tRAJcHGi3lMxdcW6VivX022WBAp6Eaz2QNoeNRP61y
	7kmYuhelrZT0KWOysxs184yFWZjt/pTomXbZC+BGaSt/wcjFvJgNh36yReNFPXf6VQ==
X-Gm-Gg: AR+sD11jUUh3eVZiAuy88Qrgm36dcJYonzNGC3kXEgEbDZrNY+KmX8Ly3nLwss4JcT1
	g0X7g9IGwYufMSbdHAvRRpUPvOfhn68ThVbFM+lQBtfu+2xz0rQjeLtq3zVOgpyAF4LeDu1uUyG
	YaFev8LleU/pWx9z31lh53hc86UohXTzKHuMpUsj8rM9/Efubv5oHqCZpyPZlg8wLe8b4/cteZf
	EYaLwNu7bpK01CmWVjrXTEuOZvo13tGSIGnsqe3ThbtPvhtrhNMD5qAapbtN+ZAo/cnaNSBW7cT
	d6+SDy7BdtXYyYq2PdR1ImbLqE+Yy54vTA9YkV9T78ch1dnoC/osSG7lKcBPGSjACnKHZ/DocUx
	aC/awPJlrV/RGDAcATWUmPnGGweQ7RKzjHhcCbJXEx1DLSAAthXOBrhEV37mxOqbVw5uiSpneFu
	iBgIKiEfSnCEBANcYD3lO7L6oT5Ucs10HsiL3XhtHg89pJTX0=
X-Received: by 2002:a05:600c:c174:b0:495:63e4:7f78 with SMTP id 5b1f17b1804b1-49563e47fa7mr133877135e9.10.1784746742455;
        Wed, 22 Jul 2026 11:59:02 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495730353d9sm13740055e9.12.2026.07.22.11.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:59:02 -0700 (PDT)
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
Subject: [PATCH v4 2/9] md: ensure REQ_NOMERGE is set on P2PDMA bios
Date: Wed, 22 Jul 2026 20:58:34 +0200
Message-ID: <20260722185841.449934-3-mykola@meshstor.io>
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

md_submit_bio() strips REQ_NOMERGE from every bio.  For P2PDMA bios
the flag is what keeps requests single-provider (see
__bio_add_page()): merging a P2PDMA bio with one over a different
pgmap, or over host memory, maps the merged request with the wrong
bus address.  Set the flag on P2PDMA bios -- bios built via
bio_iov_bvec_set() arrive without it -- and keep stripping it
otherwise.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/md/md.c | 10 ++++++++--
 drivers/md/md.h | 15 +++++++++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d1465bcd86c8..3770bdb4d4b2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -451,8 +451,14 @@ static void md_submit_bio(struct bio *bio)
 		return;
 	}
 
-	/* bio could be mergeable after passing to underlayer */
-	bio->bi_opf &= ~REQ_NOMERGE;
+	/*
+	 * A bio md split may merge again below md -- except P2PDMA bios,
+	 * which must stay single-provider (see __bio_add_page()).
+	 */
+	if (md_bio_is_p2pdma(bio))
+		bio->bi_opf |= REQ_NOMERGE;
+	else
+		bio->bi_opf &= ~REQ_NOMERGE;
 
 	md_handle_request(mddev, bio);
 }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d8daf0f75cbb..73df1a6eccd8 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -11,8 +11,10 @@
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
 #include <linux/badblocks.h>
+#include <linux/bio.h>
 #include <linux/kobject.h>
 #include <linux/list.h>
+#include <linux/memremap.h>
 #include <linux/mm.h>
 #include <linux/mutex.h>
 #include <linux/timer.h>
@@ -22,6 +24,19 @@
 #include <trace/events/block.h>
 
 #define MaxSector (~(sector_t)0)
+
+/*
+ * P2P and host pages never mix within a bio, so the first bvec is
+ * representative.  Read bi_io_vec directly: bio_first_bvec_all()
+ * WARNs on the split clones md handles, and data-less bios have no
+ * bi_io_vec.  Not valid after the bio's iterator is consumed.
+ */
+static inline bool md_bio_is_p2pdma(struct bio *bio)
+{
+	return bio_has_data(bio) && bio->bi_io_vec &&
+	       is_pci_p2pdma_page(bio->bi_io_vec->bv_page);
+}
+
 /*
  * Number of guaranteed raid bios in case of extreme VM load:
  */
-- 
2.52.0

