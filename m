Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4537A550DA1;
	Tue, 22 Sep 2026 14:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790086991; cv=none; b=qda8B+0LsaZI7+MjBXLEzn0kSB3uyVHR3gGJERxm3PpdOd5hJ92yMOQ+S1TMRy4UYR3HgZ/QdKZRwV14z0fHMjIZP/8vVQBinu69lg4kPpzzJw47CoQEVTXSzFuCfgbwqJer7ngpjZmPiq5r8DY5oU8ByVc72KUp4hZVFBaWxzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790086991; c=relaxed/simple;
	bh=0LjiP5mx9SqbIxrHSaayBapTA007ZJ2QEvgCiNEyJMs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YqRdOzDEx5CcI6C39qDjo5r0Ar2IHSpfTrQQVnHWjexE3UZjD6EDu2MVap+7JXVPsRpGtfI4c5M7dfehcaFqCn1GIkrPnzrbBx4xk9lPB3+JqcY6wywyR7XL2iWpbVEuBXCdGkCOtOU3KVs4HRVZmwqyAfsAlzN9o+zdX99JJLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=LpOlzp8q; arc=none smtp.client-ip=113.46.200.219
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
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hq28x5qCrz1prNF;
	Tue, 22 Sep 2026 22:12:01 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 8FA374056E;
	Tue, 22 Sep 2026 22:23:05 +0800 (CST)
Received: from huawei.com (10.50.85.155) by whupemo200011.china.huawei.com
 (7.152.185.179) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 22 Sep
 2026 22:23:04 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <song@kernel.org>, <yukuai@fygo.io>, <shli@kernel.org>, <neil@brown.name>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<chengzhihao1@huawei.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH v2 3/4] md/raid5: Don't free conf on raid5_run failure
Date: Tue, 22 Sep 2026 22:14:55 +0800
Message-ID: <20260922141456.738937-4-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260922141456.738937-1-chengzhihao1@huawei.com>
References: <20260922141456.738937-1-chengzhihao1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
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

