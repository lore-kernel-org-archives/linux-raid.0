Received: from va-2-16.ptr.blmpb.com (va-2-16.ptr.blmpb.com [209.127.231.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6413803C3
	for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 02:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776825236; cv=none; b=QIsMk29htbdCnlxW+UBS7Sd0j0wS8cZc8BNkJd21KiN33zyaYAQAdB154RU2g6ZsmK9+J4+tzn53Ry3AW7q1Vge05cYl1J9777kC1iLEL91fNmb6RGTiTs3fSpy36auIGual1LSKr1iH7gADFOM9fH+DiVIQHemRx/yVEaLw5vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776825236; c=relaxed/simple;
	bh=APVfJqSGetC/B84TMvxmuTzs8DRPhj981WldTSJV34Y=;
	h=From:Mime-Version:Cc:Content-Type:Date:Subject:Message-Id:To; b=s2Pi/5GrVkuIbmoyRBhDsMOo+OsQEvDI1nkO3CsmWJE/pKual1Px7CbLtGYvOIe8M+li+Q/Rs2zlVKG1W8EO2KWaWSHoBNGF48311rpctN15ZXNndLc+A3V1xxbHtSwmZApdNkkJ00RmeV9VUxFyqzVAArG5eeTXPziMrUJuisg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=AxdPy4p+; arc=none smtp.client-ip=209.127.231.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="AxdPy4p+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1776825211;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=l55Kzrd+Cks8kz1NQUEV6IGTfWlinbbd0ZaK9wahERU=;
 b=AxdPy4p+btVMX8/Gkua+hksj1srMcWpYhE0HQOJW40z2KwEZKZbx25nYb0+o4zS372dim+
 5P3PwnGXO4ewPItS2mmo+HAy/qNNnhD+a7hum9DbvoLLX4/gE6+DfLDh4A7aCTI4xOch76
 OHSXtZhVh5BjN7xaenAORQ1r17MiuMLH2PbQOOzKTS3Pu7UbwLoX4Uw2nZlZ9Ojxkx2xIR
 /Cghe9Hc8vjSi7bL16KydxEQFNk/TiwHaC3GU+RwK6dYzZ1OPIo3hSe7BYXPpEdQb3eE5D
 rYBeYeRUuJzaNKB4j84nfD1OsPSqAi3Tg2IOi9Ry01vxvKyrX4bZLvwdjOvsmw==
From: "Chen Cheng" <chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from localhost.localdomain ([113.111.140.171]) by smtp.feishu.cn with ESMTPS; Wed, 22 Apr 2026 10:33:28 +0800
Cc: <chencheng@fnnas.com>, <chenchneg33@gmail.com>
X-Original-From: chencheng@fnnas.com
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Date: Wed, 22 Apr 2026 10:33:14 +0800
Subject: [PATCH 1/4] md/raid10: prepare per-r10bio dev slot tracking
Message-Id: <20260422023317.796326-1-chencheng@fnnas.com>
To: <linux-raid@vger.kernel.org>, <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+269e83379+f50093+vger.kernel.org+chencheng@fnnas.com>
X-Mailer: git-send-email 2.53.0

From: Chen Cheng <chencheng@fnnas.com>

raid10 reuses r10bio objects from both r10bio_pool and r10buf_pool. Track
the number of devs[] slots used by each request in the r10bio itself and
initialize it whenever one of these objects is reused.

No functional change yet. A later patch will use this width when reshape
changes conf->geo.raid_disks.
---
 drivers/md/raid10.c | 4 ++++
 drivers/md/raid10.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0653b5d8545a..e93933632893 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1540,6 +1540,7 @@ static void __make_request(struct mddev *mddev, struct bio *bio, int sectors)
 	r10_bio->sector = bio->bi_iter.bi_sector;
 	r10_bio->state = 0;
 	r10_bio->read_slot = -1;
+	r10_bio->used_nr_devs = conf->geo.raid_disks;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) *
 			conf->geo.raid_disks);
 
@@ -1727,6 +1728,7 @@ static int raid10_handle_discard(struct mddev *mddev, struct bio *bio)
 	r10_bio->mddev = mddev;
 	r10_bio->state = 0;
 	r10_bio->sectors = 0;
+	r10_bio->used_nr_devs = geo->raid_disks;
 	memset(r10_bio->devs, 0, sizeof(r10_bio->devs[0]) * geo->raid_disks);
 	wait_blocked_dev(mddev, r10_bio);
 
@@ -3061,6 +3063,8 @@ static struct r10bio *raid10_alloc_init_r10buf(struct r10conf *conf)
 	else
 		nalloc = 2; /* recovery */
 
+	r10bio->used_nr_devs = nalloc;
+
 	for (i = 0; i < nalloc; i++) {
 		bio = r10bio->devs[i].bio;
 		rp = bio->bi_private;
diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
index ec79d87fb92f..92e8743023e6 100644
--- a/drivers/md/raid10.h
+++ b/drivers/md/raid10.h
@@ -127,6 +127,7 @@ struct r10bio {
 	 * if the IO is in READ direction, then this is where we read
 	 */
 	int			read_slot;
+	unsigned int		used_nr_devs;
 
 	struct list_head	retry_list;
 	/*
-- 
2.53.0
