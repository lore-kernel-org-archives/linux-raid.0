Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C9C14900F
	for <linux-raid@vger.kernel.org>; Tue,  4 Jun 2024 17:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717521980; cv=none; b=hK4J1VJ9qbPqjtyihxj6H6JuMbtpaUufa0C25TSyMAU5UVTLLioteb/pEv3Xe2ha3x5lOsBn361rvX5CW+xutGFSbjdcBA4gjKc4uBDyjR8Z8SfgiqqmxhNR6WKMVFfyLAJaatLP3djELn4tatWgIOty7Dbc+rWP09Z/txCuFwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717521980; c=relaxed/simple;
	bh=+BjGuLr/gI1Gue5e119TjF+mdnq/PomOY8egq7ncYII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mazaQ6MJPVriC0PJ/07R0q6etBa16iKkcXLsDemijyfJUUOekikT5UAdHZbH9cwTQtzXbzrPr7NCAt0Udltg0Bj6hzOawzk9YUMOOLPJhZpkuSFCyc09s6qQXHWcYgzSkDSmIFkBhq20qMhm1GDd2gn0Fc5vvpA/ZCxUGmowIRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QJKF0329; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QJKF0329"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mKcyvM4r/2P84aZxmwMfKhF19qmlYUHCRYKugbswj8M=; b=QJKF0329Rfbx+s76i18mrqohhL
	aAPvyQtWxUc6GoHtjaRRNsqCfnR8VSXv7lvt5aAYWKRlJBR5CQYmkkmZg85OgxplI9TB/4Rv4SrPy
	ahfVXO7gChLGaO1Qw/KGpvNWLVzV/k95PPsEf/lAjVNhIaf+Qlj9er/FhSeVLrW2A/186hr2EPev5
	qC670xCSK3ioI5NNO+ILMir9fu7mwvZuu4AHA/4XUOXjMs0etXHeQY2oJJHA2+JdkwqqAL3VkuANP
	mUkKRGDzeZo5HT8Q6FQvTtKp0DLODLtR97UO4k+h6PM730xXah0E/z7GyuqIiqWxMvu2gBwcZTUrS
	cVSIUngg==;
Received: from 2a02-8389-2341-5b80-cd42-c32a-c155-c812.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:cd42:c32a:c155:c812] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sEXvO-00000003HrX-10Be;
	Tue, 04 Jun 2024 17:26:18 +0000
From: Christoph Hellwig <hch@lst.de>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org
Subject: [PATCH 2/2] md/raid1: don't free conf on raid0_run failure
Date: Tue,  4 Jun 2024 19:25:29 +0200
Message-ID: <20240604172607.3185916-3-hch@lst.de>
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

Fixes: 07f1a6850c5d ("md/raid1: fail run raid1 array when active disk less than one")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid1.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7b8a71ca66dde0..1f321826ef02ba 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3204,7 +3204,6 @@ static int raid1_set_limits(struct mddev *mddev)
 	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
-static void raid1_free(struct mddev *mddev, void *priv);
 static int raid1_run(struct mddev *mddev)
 {
 	struct r1conf *conf;
@@ -3238,7 +3237,7 @@ static int raid1_run(struct mddev *mddev)
 	if (!mddev_is_dm(mddev)) {
 		ret = raid1_set_limits(mddev);
 		if (ret)
-			goto abort;
+			return ret;
 	}
 
 	mddev->degraded = 0;
@@ -3252,8 +3251,7 @@ static int raid1_run(struct mddev *mddev)
 	 */
 	if (conf->raid_disks - mddev->degraded < 1) {
 		md_unregister_thread(mddev, &conf->thread);
-		ret = -EINVAL;
-		goto abort;
+		return -EINVAL;
 	}
 
 	if (conf->raid_disks - mddev->degraded == 1)
@@ -3277,14 +3275,8 @@ static int raid1_run(struct mddev *mddev)
 	md_set_array_sectors(mddev, raid1_size(mddev, 0, 0));
 
 	ret = md_integrity_register(mddev);
-	if (ret) {
+	if (ret)
 		md_unregister_thread(mddev, &mddev->thread);
-		goto abort;
-	}
-	return 0;
-
-abort:
-	raid1_free(mddev, conf);
 	return ret;
 }
 
-- 
2.43.0

