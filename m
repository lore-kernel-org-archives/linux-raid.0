Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1AF4399E0
	for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 18:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746762; cv=none; b=Pw7ZQPhGo6XAn1em0RdsXNRGYcmKqh6X58EYmR1O5zwmcUPZ7F2rXvTunuEXPiX5su7nNselKYAw0VV3FeF1+g+spunps8K8uROQqKn7EIS7OVm2PGXDIBa6YiFC8smkYHSt3I8n9hP1off7vzG2ilorFc+emKkrTUY+iNEBCec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746762; c=relaxed/simple;
	bh=txEBr1MoU1y1mkJ/HHXFbnluQk+VRueyunkBGuSqgtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bL4vt1P4bZvq+bHHkNVuWpuecoGEq78bnAqLUx6feu8NwlwyShkM6r3D/0OWBBeNriwis1l9MgJMAo8q0UGISpuWtI/pTyh1trbTQM52hCfMjgR7slsSZ0FrrG6oCDPXzRcnY20f15W6FDdZ5bNlFQgMVLwvxWrYSTYbirJYT1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=H1wkgX05; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="H1wkgX05"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-493f6de72faso45305785e9.0
        for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 11:59:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784746754; x=1785351554; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XGlz7sxVhffzS6r4ROT44BH0oh58kUxNrwba0cAE+h4=;
        b=H1wkgX05RHJTUWYprRsuGf3VDGrnWdopU+EKgLmswxyGXuyAtX/JXr2Yuh5N2t/JOX
         Yh0EiRSzmOI3gHd3cQSaQLV4wPbLXSMrUo6vOhcssWWslM3ZDyZ1hGSA0kl7iRZpHciE
         +It5bRwc0temO8hUL1zEx9DO8Xq9U/LuG2bJFf1g3aI1PvTOOmamJeDG6WDSK9qarsa1
         4X43Tmrn6PTMlZ6pRckVGJ+DyfLyU9DVNtTgFFMEZ3ol3K5RJAtTOxOV8K8PxW8kXID+
         KARFNKDueTbGrLuXCiQl+vHl4HwyLNw8FyO8YBJRE8cY03Jz0ixbLwVZsByBskLVGcAN
         Pf5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746754; x=1785351554;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XGlz7sxVhffzS6r4ROT44BH0oh58kUxNrwba0cAE+h4=;
        b=ikr0lH9sestIO5Kr0N9iYh/ji3ymK1qemnfAl8xUJrMpa+btzHI38hBbEjn9y3310C
         76cIUujhe7V2XO9jL2Kq3B8LtsdE40LKolhOSFreQVjeW32clRSv4aIj0t3GFbT0mOwV
         729R63kD4GZ1FJKBqjAYcnmA51+kbIJF5xcGIxY6GUz49+OiyHTbNJsKAg1EtPNWi2Vv
         +pz9gTbbSNqVbOpiFvKhsQFfMu9Oed890gS/k0XJwFP0mJKt5emjOVfWvbc3hyaT8Pht
         iSRdsQu8Hc7qZotZlPcIUsQLMuA+ZPR2R7dUJgTpFztqp/lzpaSEIXTONP6iy9ecCSkT
         EVGA==
X-Forwarded-Encrypted: i=1; AHgh+RoAnUlT06SEktJbvsGYQgis9hpOQZqEjou3UKdnalq5fJ1ut6J5n07Fz4r2fUv4rMVAuT9v7iK6qeEW@vger.kernel.org
X-Gm-Message-State: AOJu0YxNWDBVvlxGtWFYgopXsEBzKiwVaPIlbb9/dV30B7sUxf1RFhrJ
	x791mjaEASGDTNSA9X2jKaWi8K+FluKuf25bu5UEldZmMWXjEPi0oFVfWtIoGaf8fA==
X-Gm-Gg: AR+sD12WhZ9F5aupGHTLMjmsJsSddrXmJMVLqLIlAkv8TV10yT6QY8h67k4tA1uDFPq
	n+cgUyvcBeKmN8grbSNL+viXXmxVpY9/8Pu+YmC3Mod6PGoaqL7NHw64daG+QchC6MXYuhhVjwN
	tG1Lin9HnAsXca9qvYuHiGu8Nm8NB41Rv+B02PY7rXIUALoGQqn10uyEr2uPd8yB7p7arTXD3gX
	5HVoQyhFb92Oc7XkJ1K3UJckQ3+GkmWMJ2FrjN5afNvi+NqCHLpGdf0qnSOMIfwMeLf3SU8iZFP
	Nx6an7Jkt0b+sbnlqJxiKIrrBiSQ5hYhmxtfdWHy4CVOyLo94/IL+cGoOgyzxNY5KTkR8M0GmN7
	CRd0bK0h9oIb/R3R9A15cmpR+lyw5vbumZoGgoR+iF1HIhkYgEz9dWIz/oTSXjwP+YA1CblALIe
	DJ85mfFBO3ttoU0tr4anWFFQmA3iJuN+uL7ohyjms043E6jnM=
X-Received: by 2002:a05:600c:1d23:b0:495:7016:b875 with SMTP id 5b1f17b1804b1-4957016c17dmr25808785e9.13.1784746753845;
        Wed, 22 Jul 2026 11:59:13 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495730353d9sm13740055e9.12.2026.07.22.11.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:59:13 -0700 (PDT)
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
Subject: [PATCH v4 7/9] md/raid1,raid10: skip futile retries on P2PDMA mapping failures
Date: Wed, 22 Jul 2026 20:58:39 +0200
Message-ID: <20260722185841.449934-8-mykola@meshstor.io>
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

From: Logan Gunthorpe <logang@deltatee.com>

BLK_STS_P2PDMA reflects the peer/member pairing, not member health:
retrying the same pages on the same member cannot succeed.  Keep
WriteErrorSeen so the range stays fenced, but skip WantReplacement and
FailFast eviction, as commit f7b24c7b41f2 ("md/raid1,raid10: don't fail
devices for invalid IO errors") did for BLK_STS_INVAL.

The failure is whole-range and deterministic, so narrow_write_error()'s
block-by-block submit_bio_wait() retries are pointless.  Record the
whole range as a bad block in the completion handler instead.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Co-developed-by: Mykola Marzhan <mykola@meshstor.io>
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
---
 drivers/md/raid1-10.c |  3 +++
 drivers/md/raid1.c    | 12 +++++++++---
 drivers/md/raid10.c   |  8 +++++++-
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index cee21452e066..89daf8558251 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -309,6 +309,9 @@ static inline void raid1_write_error(struct mddev *mddev, struct md_rdev *rdev,
 {
 	set_bit(WriteErrorSeen, &rdev->flags);
 
+	if (bio->bi_status == BLK_STS_P2PDMA)
+		return;
+
 	if (!test_and_set_bit(WantReplacement, &rdev->flags))
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 19c4dec450de..917d694ef401 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2624,10 +2624,16 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
 			 * narrow down and record precise write
 			 * errors.
 			 */
+			struct md_rdev *rdev = conf->mirrors[m].rdev;
+
 			fail = true;
-			narrow_write_error(r1_bio, m);
-			rdev_dec_pending(conf->mirrors[m].rdev,
-					 conf->mddev);
+			/* Mapping failures are whole-range and deterministic */
+			if (r1_bio->bios[m]->bi_status == BLK_STS_P2PDMA)
+				rdev_set_badblocks(rdev, r1_bio->sector,
+						   r1_bio->sectors, 0);
+			else
+				narrow_write_error(r1_bio, m);
+			rdev_dec_pending(rdev, conf->mddev);
 		}
 	if (fail) {
 		spin_lock_irq(&conf->device_lock);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 428bddddfe71..9045a3f02dae 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2940,7 +2940,13 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 				rdev_dec_pending(rdev, conf->mddev);
 			} else if (bio != NULL && bio->bi_status) {
 				fail = true;
-				narrow_write_error(r10_bio, m);
+				/* Mapping failures are whole-range and deterministic */
+				if (bio->bi_status == BLK_STS_P2PDMA)
+					rdev_set_badblocks(rdev,
+							   r10_bio->devs[m].addr,
+							   r10_bio->sectors, 0);
+				else
+					narrow_write_error(r10_bio, m);
 				rdev_dec_pending(rdev, conf->mddev);
 			}
 			bio = r10_bio->devs[m].repl_bio;
-- 
2.52.0

