Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BA23955E0
	for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 18:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784746757; cv=none; b=S1xVKQdSAlNpQXeJF/n1BQ7W0qO/ikq05gRQ/PpPGzZv4epNvSzYYMhJqeEinQlaewYXM52NQet/BR4oLPKxSa7jVOtHX4wi0JN8JKYCvMpjs3bCt2KTj30x2qk+4/Su9DznPZZzn+Ymzlm5w/P4F09Y2iw/e5CAhF5zWTscgNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784746757; c=relaxed/simple;
	bh=tb87IS5YwxWP0/pdiRmCvUCzVsNHu9wl18O2iixHy6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LDQBN76U3tLV/SzyRPc3AbsShtUXYslKhwEHdsiMLINlY1brZFdEEbscsbp0bDN4wjampUCwlxtTvhOd9e0dPEP+nZm54l+AEgY8NzbzicsftsTvtvbynVcNdUgi6wwMSKf0O8ryBAlinRO9RJIrBiR3kxvu2E3MMJRM8atc668=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=ke96zD1A; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="ke96zD1A"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4954f5e8020so23309465e9.2
        for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 11:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784746747; x=1785351547; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jvUC0Lia0it+LgLYsOXSPjeMnXEhLq3Hqn52LEDkVn4=;
        b=ke96zD1AV2KN7/+6dDmPKBnVJGHdbbiVVwXnekYtUt5RKh8NxsEXdLh4Uhrtj3OP+z
         Qa5Tjtwp+zgHtPjbmH3sLbPAuREYsRuyEi64W2NwBdnsmMmAk6WQ7+qwFI7D272BVQcX
         +4x7jTG20yYoO5cuGmCNe/+2tylFSiszgDYajx4OjtF9KyTRz0yLQqTUUYwHiHxpTAT4
         RWdrCIx2RSbWF6yp2I+Adi8w+y0/CWUUFbEkOqc4fXhCR1L3uydeMAZZiLN3IZS9fQv4
         qUxQzbQxifQSHcmfu3kGAYb1Sk1hGER4swGw2xx0wzQnRi+IYx0e3kS98iq0ytplswMF
         JBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784746747; x=1785351547;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jvUC0Lia0it+LgLYsOXSPjeMnXEhLq3Hqn52LEDkVn4=;
        b=HAAozTXm80SfRVzOVphUK/yTeKnmfnLEbo7e2jlxiy1vHYhUbxjS/XaZJITK+dddE2
         bqVPDmgT66qoqyrIy2a7E1MpqifrgXxpfC1xUFPBrF7TqX7vRK2HXuGmafLLjbw2JsWr
         +NbiWCPaqt7FngcZZ6mHdur0O69N2WcBoJCHkGGjwKmnmVAfHuJ1LtCmETin+y08N69J
         TtycyZwFvtNaf0EicbmxaFvCmN3oqCaSFeq+hkFnPeNbRNftSjSOmnAuUpBJ4mCcUBmQ
         JG9UXoQKI4WEaBpngJnR3gVvtjCnunnz5Pj6M9LA9QN5dqT59ImtkguLzo+EcjVtH2AD
         MbOQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqh0V+O0SDV/1a0SzXgFRE/DJ5LgRu+zaRMCHFfEdMe9mo00uQGQmkwH7ZC8romvTp70LVrG2nW325d@vger.kernel.org
X-Gm-Message-State: AOJu0YwuLmwiQsG6995IE0yHQ9IE2Fk4o+0JDKeuODtwoPO4igkXW5D6
	FvZ1gm5DLOc6/qbU8joQS54jHYbs3VgbCUkP5eaUim2ivyEJUOLDIXXQUGruYmna0A==
X-Gm-Gg: AR+sD10cvkPaFJPWV+yTUfMpEf7Daglzf4worHbKneusBTAgeSi77RF+SJWh1GE16Mp
	iz9sNwLiD625vQ2S7mH3X/tfaYyzOn0yf7ladA2y+C7Z1VcvIAAn1UePNuzZ5VI/CNRGiGBlXGm
	f8lT3KK6IYaoWQK9nkcZ6fC+8Cj5b0lb1OCdaHe4ykuZ/GzrGoJlXsI5MsbG5aiZ8j7CvyXJ1oQ
	6Td8RMwB89vfPOrFOGIV0hkPyuR3Cv3wX+igFaHLBbzQDYJcJGriD6GCZOhEDQNbVx0JLpHDUAo
	Bzq5OFLt20+BXyfjoae0ri7wqJNzdM4vipSgRYvz6uboq2ezbLxmR87tv69lA+/o/yLFfrChybr
	tpEwXMxK6lWtPCYvio6bjqhnDahbS/3no7uxjNTuI/WrzeHp2DadAEHx6k5KllFPj+iqYtF6CeE
	JPBdgxZgy0V+y1IXDDF34f5Ty+AfITLbnrDJRMTqQqe8m94LQ=
X-Received: by 2002:a05:600c:2049:b0:495:6397:14b1 with SMTP id 5b1f17b1804b1-495639714bfmr108525535e9.34.1784746746655;
        Wed, 22 Jul 2026 11:59:06 -0700 (PDT)
Received: from ai-pc ([46.172.241.174])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-495730353d9sm13740055e9.12.2026.07.22.11.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:59:06 -0700 (PDT)
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
Subject: [PATCH v4 4/9] md/raid1: don't use write-behind for P2PDMA bios
Date: Wed, 22 Jul 2026 20:58:36 +0200
Message-ID: <20260722185841.449934-5-mykola@meshstor.io>
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

alloc_behind_master_bio() copies the bio's data with bio_copy_data(),
a CPU copy. P2PDMA pages are peer device (BAR) memory; generic code
must not assume CPU load/store access to them is safe or fast on
every architecture, and bouncing peer memory through the CPU defeats
the point of a peer-to-peer transfer.

Skip write-behind for P2PDMA bios: they are written directly to all
members, including write-mostly ones.  Ordering against write-behind
I/O in flight to overlapping sectors is preserved: the non-behind
clone path serializes on CollisionCheck rdevs (see the preceding
fix), which covers these bios like any other write that bypasses
write-behind.

Fixes: 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA from member devices to RAID device")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
---
 drivers/md/raid1.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 997f79c05db7..7d769b6460ca 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1523,6 +1523,7 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 	bool write_behind = false;
 	bool nowait = bio->bi_opf & REQ_NOWAIT;
 	bool is_discard = op_is_discard(bio->bi_opf);
+	bool is_p2pdma = md_bio_is_p2pdma(bio);
 	sector_t sector = bio->bi_iter.bi_sector;
 
 	if (mddev_is_clustered(mddev) &&
@@ -1575,9 +1576,12 @@ static bool raid1_write_request(struct mddev *mddev, struct bio *bio,
 		/*
 		 * The write-behind io is only attempted on drives marked as
 		 * write-mostly, which means we could allocate write behind
-		 * bio later.
+		 * bio later. P2PDMA bios are excluded: write-behind copies
+		 * the data with bio_copy_data(), a CPU copy that cannot be
+		 * assumed safe or fast on P2PDMA (device BAR) pages.
 		 */
-		if (!is_discard && rdev && test_bit(WriteMostly, &rdev->flags))
+		if (!is_discard && !is_p2pdma && rdev &&
+		    test_bit(WriteMostly, &rdev->flags))
 			write_behind = true;
 
 		r1_bio->bios[i] = NULL;
-- 
2.52.0

