Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72696146A97
	for <linux-raid@vger.kernel.org>; Tue,  4 Jun 2024 17:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717521979; cv=none; b=gGcSUla8IrI4N1LoJ0m+OcHP+UVmnKpfzcrm/jayp8nGIQuIkKAa8NfpSeCtLCya7MMwlRc2UC69pu8INigTP+vqIeLHzM8yydun1XoPMxd2lPUyQgOF2N+LQ8vHAxVp3NvDUPH/FLgFpO4Lc/6s86IW86zmLsh3Wq478yckeBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717521979; c=relaxed/simple;
	bh=0AmtyARSaCfpKYoEJ5CCQgZ2tTPFVkXy8IxqhQ0K9zY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=el+kJJouauBtBzkcd19q1UORfdemOTEVWnfg/vj9v7gfHWROQB5Fz+FDcN7crvsPNItftyyk0ASJglmVXmJxTgbUdHsFu1TP3jhHrRKkQbwTNG//zT6l1Bzh7Y/tTXQhNFA7jZJKyBSMAQG5lvu65yFMAngRbI8Eib8LDrfDbvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=McrKA5c/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="McrKA5c/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=xt/cEzI4CksO34TKlgliy2AxvKCGUtTFve6xzQi8/jQ=; b=McrKA5c/2lFGtZtuQfYNhly9E6
	kCPaGLMYkiFUEVfDwvhPfmM2oB2wJgf35t0nYmDXLoKf10ttxceJhjtQngWkt+fvhk8DXFEZ/J/14
	LAlr75un/LYYUKcjyWVPTeIP2a163SFTNzmxNyioq5MtwNhj5tCBsVHZZ3H7fWQGLAI//teuiP+32
	LIp4sdkvXULVNr+Gjo6ztoPBjilu6+gGtZdmUqcwo375oD/zGsvNQEK2Ch6WPSdFyO5OLcwCwE69s
	J8eehYiVcVbVkXR9AaExfsZnMZ+a4vXr+Ths18QWcjixtpPrTIrXioCMwpFeDCEDnV0GHD5nHBrcP
	uHypqynA==;
Received: from 2a02-8389-2341-5b80-cd42-c32a-c155-c812.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:cd42:c32a:c155:c812] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEXvK-00000003Hr1-1td6;
	Tue, 04 Jun 2024 17:26:15 +0000
From: Christoph Hellwig <hch@lst.de>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org
Subject: [PATCH 1/2] md/raid0: don't free conf on raid0_run failure
Date: Tue,  4 Jun 2024 19:25:28 +0200
Message-ID: <20240604172607.3185916-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240604172607.3185916-1-hch@lst.de>
References: <20240604172607.3185916-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The core md code calls the ->free method which already frees conf.

Fixes: 0c031fd37f69 ("md: Move alloc/free acct bioset in to personality")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid0.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c5d4aeb68404c9..81c01347cd24e6 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -365,18 +365,13 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
 	return array_sectors;
 }
 
-static void free_conf(struct mddev *mddev, struct r0conf *conf)
-{
-	kfree(conf->strip_zone);
-	kfree(conf->devlist);
-	kfree(conf);
-}
-
 static void raid0_free(struct mddev *mddev, void *priv)
 {
 	struct r0conf *conf = priv;
 
-	free_conf(mddev, conf);
+	kfree(conf->strip_zone);
+	kfree(conf->devlist);
+	kfree(conf);
 }
 
 static int raid0_set_limits(struct mddev *mddev)
@@ -415,7 +410,7 @@ static int raid0_run(struct mddev *mddev)
 	if (!mddev_is_dm(mddev)) {
 		ret = raid0_set_limits(mddev);
 		if (ret)
-			goto out_free_conf;
+			return ret;
 	}
 
 	/* calculate array device size */
@@ -427,13 +422,7 @@ static int raid0_run(struct mddev *mddev)
 
 	dump_zones(mddev);
 
-	ret = md_integrity_register(mddev);
-	if (ret)
-		goto out_free_conf;
-	return 0;
-out_free_conf:
-	free_conf(mddev, conf);
-	return ret;
+	return md_integrity_register(mddev);
 }
 
 /*
-- 
2.43.0

