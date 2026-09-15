Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A07481657;
	Tue, 15 Sep 2026 08:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789460787; cv=none; b=ay8oP+cDU6/L92r4clRb+88KGeJoZEZWJgVZ0hPIN1xEFRgaevzwW8LsLHq0l1zvaNPZUvmgQYRQAy3Nyx9ax4mb11DrPe0rS2sqSCPvAz2s+4zKLFbtGhLvT2xb9EknTbJcB49fM+xqgTvT0UihHJcelvKFL7lGHJis6TvH6xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789460787; c=relaxed/simple;
	bh=1ckF/L3urk2n6oHITPJi0BcW5E39fkQSC+zncpJCzso=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=loG0J6TmgX+ib/MctPXBosgJ1wlFxHWLgjz8QbD2sTd/YNl9fo9OOkm0fFVq75gxC1ZlQWbm03aIrA4k0CjeKugrY7rM9X1362GwZXEOBVjq16b8ZF2lptdR7v0frZkUKpuS16xbCnOZF3Z7i8FF7f5IXhzpVhtsMlBf98iFQ3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ob55COYR; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ob55COYR"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=b8FfZtbdk0pD+jldYTWN4mi2ipQ+Z6OiTFztjZe4500=;
	b=ob55COYRPCLBJiU35z2yECpdJZ6rV+hRLeyP5hZ4MAAeGRLy0v1t8WoGa0Z1GADbl9gQpJiw1
	+nRLmoOVkB/n+2KtD65a5SKIP5ULDXattvPlskB8C1Eexa7XZKpGp1Nr6+UTTKUUf4NMRpmV7Ah
	SiFvxxcUjbJzAnlpxoyjUE4=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hkZZX2ZW5z1cyVL;
	Tue, 15 Sep 2026 16:15:16 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id B1AD140565;
	Tue, 15 Sep 2026 16:26:13 +0800 (CST)
Received: from huawei.com (10.50.85.155) by whupemo200011.china.huawei.com
 (7.152.185.179) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 15 Sep
 2026 16:26:12 +0800
From: Zhihao Cheng <chengzhihao1@huawei.com>
To: <song@kernel.org>, <yukuai@fygo.io>, <artur.paszkiewicz@intel.com>,
	<shli@fb.com>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<chengzhihao1@huawei.com>, <yangerkun@huawei.com>, <yi.zhang@huawei.com>
Subject: [PATCH] md/raid5: setup_conf: Fix null-ptr-def in error handling path
Date: Tue, 15 Sep 2026 16:17:31 +0800
Message-ID: <20260915081731.122933-1-chengzhihao1@huawei.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 whupemo200011.china.huawei.com (7.152.185.179)

For raid5 setup_conf, if an error(eg. bioset_init fails) happens before
'conf->mddev = mddev', following error handling path could trigger a
null-ptr-def problem:

 free_conf
  log_exit
   raid5_has_ppl
    test_bit(MD_HAS_PPL, &conf->mddev->flags) // conf->mddev is NULL !

Fix it by initializing conf->mddev in advance.

Fixes: 3418d036c81d ("raid5-ppl: Partial Parity Log write logging implementation")
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
---
 drivers/md/raid5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b91545ce090d..c091bba95c31 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7675,6 +7675,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	if (conf == NULL)
 		goto abort;
 
+	conf->mddev = mddev;
 #if PAGE_SIZE != DEFAULT_STRIPE_SIZE
 	conf->stripe_size = DEFAULT_STRIPE_SIZE;
 	conf->stripe_shift = ilog2(DEFAULT_STRIPE_SIZE) - 9;
@@ -7743,7 +7744,6 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	ret = bioset_init(&conf->bio_split, BIO_POOL_SIZE, 0, 0);
 	if (ret)
 		goto abort;
-	conf->mddev = mddev;
 
 	ret = -ENOMEM;
 	conf->stripe_hashtbl = kzalloc(PAGE_SIZE, GFP_KERNEL);
-- 
2.52.0

