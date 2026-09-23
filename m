Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2118149E5FC;
	Wed, 23 Sep 2026 11:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790163032; cv=none; b=hmPnpYpQrLD5VcSohl8/2rkYaClCUCExxU+7hek2rAi/zvm3U7G4SfOKQqd4FF4XP/tSiolq68hQweLK6LWl7+SDrj6qWEGoQgXbn/FHYm0yy70RrdzuzfnSu1hHhMGOYKZsL1nGe/VzKwNudNTc+LyVF1TNyl9vI6mUYZDIzWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790163032; c=relaxed/simple;
	bh=0LjiP5mx9SqbIxrHSaayBapTA007ZJ2QEvgCiNEyJMs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l2NW83VdWRCiMe3KXdw24hVueAA8s1WL8cQclDeX0LzVr3NfrLnU2tlk21j78GOrnzRu4u8vnKcw0lnfTvfVoLysKDyLcnuhMmcKWw8MFSfT3wkdDZ4/kmtJACdunVpO5pMOHb9UHEWvr6mGV3Xs1ey1gjxqzsT6JTwlSzR6ZQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=LpOlzp8q; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="LpOlzp8q"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NzOtn3tBf+IKrIpGZ3g0Fl8IX2FSpQr3yYzI9WihiKE=;
	b=LpOlzp8qODo5ZOSf5oPrd/b0JQ4IbY0PvJNGgAnh0rHwvQj6Qz4l0J6EqxVqssGNZYDUXTCC4
	qB/HPeDqhzjXj/UuoWjH2JUeAtV6qEp2O5Uh6SoGz65WvRLlbFbF2RWAAGF8l0UzW4b3T29bVmL
	ke27vbkcgnPV0pH66jrKJ90=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hqZG30fCvz1T4LY;
	Wed, 23 Sep 2026 19:18:19 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id A23C84058C;
	Wed, 23 Sep 2026 19:30:10 +0800 (CST)
Received: from huawei.com (10.50.85.155) by whupemo200011.china.huawei.com
 (7.152.185.179) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 23 Sep
 2026 19:30:09 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <song@kernel.org>, <yukuai@fygo.io>, <shli@kernel.org>, <neil@brown.name>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<chengzhihao1@huawei.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH v3 3/4] md/raid5: Don't free conf on raid5_run failure
Date: Wed, 23 Sep 2026 19:21:57 +0800
Message-ID: <20260923112159.94175-4-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260923112159.94175-1-chengzhihao1@huawei.com>
References: <20260923112159.94175-1-chengzhihao1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 whupemo200011.china.huawei.com (7.152.185.179)

Since all pers->run() callers handle the error case, no need to free
conf when raid5_run() fails.

Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 drivers/md/raid5.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7e87e8a60f5f..913e5a709e35 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8263,8 +8263,6 @@ static int raid5_run(struct mddev *mddev)
 abort:
 	md_unregister_thread(mddev, &mddev->thread);
 	print_raid5_conf(conf);
-	free_conf(conf);
-	mddev->private = NULL;
 	pr_warn("md/raid:%s: failed to run raid set.\n", mdname(mddev));
 	return ret;
 }
-- 
2.52.0

