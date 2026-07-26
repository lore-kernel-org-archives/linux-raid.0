Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E11369219
	for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 11:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785065563; cv=none; b=iKoUZ5Z2jeebMC1MTLS31QpT6IJS9RsYJ5QfOg+FyZ1U3NmwvlCqCfg8paqkJKSDX1dJqZaVWLRQTgT5Q9/grxbGEs1nfgVa546bEuW+Ah9i3xmZ1i7fw9XjBWKYbx6RbeQaEpRks9YgBuQXinTM93GWPoRjJrpOoiBbuHlZ5oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785065563; c=relaxed/simple;
	bh=UmHDQ8Avh88213YFsBTKp7WY9yAPzXpx6PsDprJSvWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efjxY8FJ93XJAHDWPStX3NpON6bqGocsg3m7wOZXiX8y7XP7O448PMKeTYgPDcDb6UFqR34h7rxZBdyq37JUh/7vMnEwWknV9y6IzGxw873SY2K8Y0WKecfr3laQbGkto+LgaZKj56TGnu9S4Xae82DyjUsok9wXEfg5t0r04OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=NvQ8//bf; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="NvQ8//bf"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-495635a85d2so15255765e9.0
        for <linux-raid@vger.kernel.org>; Sun, 26 Jul 2026 04:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1785065559; x=1785670359; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V5hliKyCAPWFZqHS5mW2T1dJRPt4J/vTka7mcNCHq10=;
        b=NvQ8//bfQJuzp7j3yL6gGGLYRLnOCIWXp9Tvdo/+924SfpBfJNqUZbLQ/g52q/t3IP
         EIMETlmWs5z4+GPI7G9faNf0w/VzoWTgtPV003H4FOTYAkbA8/VncXQq+0VjYU0fx3EW
         W6k7VMG/U1W00FFP64RodffPkWcQX6C4WrqnPoTE7X48uA5BvZtLcjeyriHB4OvsZTug
         VDWon6KhNPTPrdv5OgErtQAFkMuTKEUU9G6gIIjPCbUKjLUqk0bzCqnnJCz4ScP85sbn
         nr+DIJD/zcANqYHkcoigNe/Jtl+6UY1MQ8B74D3cVc51Y96cXwxVP5uVswIDnDmV4/it
         FF6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785065559; x=1785670359;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V5hliKyCAPWFZqHS5mW2T1dJRPt4J/vTka7mcNCHq10=;
        b=kGxnRVnlIc1a5tTBlGEnWthzRctB4ikP8WauSzSYRuftvJ1uUa+tLUBZgVbVl7EEKH
         avQH6v8fBWCfxFqjAoNDq6B9vnqo7xSwhffaMQN+az+I9hOyAXXTXFe72+YZ9+fzeSH5
         t9Esk47c4SxVepojqcrez5AYGu2fKVLyKm5Z0KDiJBlty2YRamieo0aywt+frtJLnolj
         3FMlhBI2sljCRi4ek47ozYOGzl2hMl2QAnmimLqFfP1yj2tMNaaYUAJq36CQnCCDaMQA
         uEOdBYwCmqXrym2xPoV5/7Or8kN+7HOBt/0GDGEXysSsLllL0iYU1L/rPvtD6WSCKp5G
         UkbQ==
X-Forwarded-Encrypted: i=1; AHgh+RphhcnyxO+mOEomj5eeUaIOhUlKhpeTEqvjI/SIm0tT6bREU/i1a4VErEbf4E6Ji8q0tPFbq61bCMn+@vger.kernel.org
X-Gm-Message-State: AOJu0YwW3c+/LDkO4WSZt0I02DLaC8JUjUHOz8J/8t15Ih+elZtqkQD7
	7KiBaNJPBMF8D051vZQix43zghNgi6yF64hLhfWtfSkkFr+vs5YYp4KsCafv3APN1g==
X-Gm-Gg: AR+sD11uyVm8dkzkjfPhS+vN8zBVa4yZGYc2eWSGeuoVnt+KKhzfsoFu++OZeDhk69v
	uJY5Ir5rj8hR/Q9NMFgtZsB2C6Qsjhc4JFtK0AwWqDKIkDvnLgRTAt+5PPVwruNJBTswYeqAHBW
	H54FgSzwC6ShgzBQA8lx7nmVbT5pu+4ju0rhlvoeDi7IR7AM/ErOTuyhD5+8HuNuLmZoYoAzwyg
	rL2dUzGeNBh0fCbU76MVuqrLF1TTwlOcTv6K/+k12sFBoJiaxT8H7q1XZYMVkgO6BcxJ3AzU7S0
	b6p+zJazuZn8dRL+ZDgkfZW+dTz6hYjAUGkTXghTrAmDzDSvIZs1trp8LeJGP9Yy3XFnI5bFYsW
	er07a034xvVwUtJAa9ll+hqvnSO3M/SyUFPv8nI0squTuNc+HpPIXHu1rfISH1b2BpigErkSvyN
	GmoCXajIrxDN/fK+QAWQH4GnkYJbP8P4jzeHkg06Q54RiJXsmRSXQxj91U6E3i7Y93dtz2hxTeP
	bKVWodPHJ0+NJCApjLMj49Yev0CcrCqU2Rs+cAUbA==
X-Received: by 2002:a05:600c:1d0d:b0:493:c8c6:4989 with SMTP id 5b1f17b1804b1-496b56bbc65mr64847835e9.6.1785065559344;
        Sun, 26 Jul 2026 04:32:39 -0700 (PDT)
Received: from meshstor-pc ([185.87.42.56])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85bb57cfsm40533083f8f.11.2026.07.26.04.32.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 04:32:38 -0700 (PDT)
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
Subject: [PATCH v6 02/12] md: ensure REQ_NOMERGE is set on P2PDMA bios
Date: Sun, 26 Jul 2026 13:32:19 +0200
Message-ID: <20260726113229.2154269-3-mykola@meshstor.io>
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

