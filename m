Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822123112B2;
	Mon, 17 Aug 2026 03:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786937993; cv=none; b=mfZAgKtjQNjywE0MmPsaVOc8ThLnfjUGgrjtKyOOcnuV8sGWir736ipgQNTUAdaInjCxWtEbSV8pyvm0GJKQIhz+9NdpPswKI0YqNQp7SWzeOQCz/5EPeTG2nmcQudrWitCeFy+kJBrq3PUmbFw9J/lll/+CTwsF5uKInr9qAYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786937993; c=relaxed/simple;
	bh=Yf18fPn/EFoNmAu1Ovv86K/pAYUmLkYZFlGm1b3I3ho=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hRUVeWb0oL2vFhPvB8WE4/ZnafwwpIqp6qqHXj6HbB4kCHorVeQQjxcmSYF44LMi+gT5tlGseK6dMkd64k2vRX1biQkRtkWngbkhs4f/hc/yrsNLPoUFXhwwYQZkMDDoBNsAMWQU92F4/O9UJ9LgywQzMIAglRvXM/mICSLOCwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=qf6j7aV9; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="qf6j7aV9"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=sFQix3HaAxxhtqyNdoSbUtgSIFhJraZV6JC9JomQCdQ=;
	b=qf6j7aV9SC9qaWkpe+gHaIke5UULdn129HnMkp+GZLADgy8Kl6SMeQToWgqa7vxEQtWn76UPW
	/jy3ZAzLVQIZdEyu0SfXlRtS36IZ2O88ngnwB3h7qQkKUlBtLcfqRaTKdSjexHY2m0J86rY4/uA
	rQX/I7079jGqIcNZB+VlML8=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hNdc95Tn3zcbMk;
	Mon, 17 Aug 2026 11:29:29 +0800 (CST)
Received: from kwepemf100017.china.huawei.com (unknown [7.202.181.16])
	by mail.maildlp.com (Postfix) with ESMTPS id A8E84202E6;
	Mon, 17 Aug 2026 11:39:45 +0800 (CST)
Received: from localhost.localdomain (10.50.85.155) by
 kwepemf100017.china.huawei.com (7.202.181.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Mon, 17 Aug 2026 11:39:45 +0800
From: Zizhi Wo <wozizhi@huawei.com>
To: <song@kernel.org>, <yukuai@fygo.io>, <magiclinan@didiglobal.com>,
	<xiao@kernel.org>, <linux-raid@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>,
	<chengzhihao1@huawei.com>, <wozizhi@huawei.com>
Subject: [PATCH V2 1/2] md/raid10: annotate lockless access to array_freeze_pending
Date: Mon, 17 Aug 2026 11:33:39 +0800
Message-ID: <20260817033340.418119-2-wozizhi@huawei.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260817033340.418119-1-wozizhi@huawei.com>
References: <20260817033340.418119-1-wozizhi@huawei.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemf100017.china.huawei.com (7.202.181.16)

conf->array_freeze_pending is updated under conf->resync_lock in
freeze_array(), but read locklessly in allow_barrier(). Annotate these
accesses with READ_ONCE()/WRITE_ONCE() to document the intentional lockless
access and to prevent load/store tearing or fusing by the compiler. No
functional change.

Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
---
 drivers/md/raid10.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 0a3cfdd3f5df..dc40110a6736 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1031,11 +1031,11 @@ static bool wait_barrier(struct r10conf *conf, bool nowait)
 }
 
 static void allow_barrier(struct r10conf *conf)
 {
 	if ((atomic_dec_and_test(&conf->nr_pending)) ||
-			(conf->array_freeze_pending))
+	    READ_ONCE(conf->array_freeze_pending))
 		wake_up_barrier(conf);
 }
 
 static void freeze_array(struct r10conf *conf, int extra)
 {
@@ -1050,16 +1050,16 @@ static void freeze_array(struct r10conf *conf, int extra)
 	 * Thus the number queued (nr_queued) plus this request (extra)
 	 * must match the number of pending IOs (nr_pending) before
 	 * we continue.
 	 */
 	write_seqlock_irq(&conf->resync_lock);
-	conf->array_freeze_pending++;
+	WRITE_ONCE(conf->array_freeze_pending, conf->array_freeze_pending + 1);
 	WRITE_ONCE(conf->barrier, conf->barrier + 1);
 	conf->nr_waiting++;
 	wait_event_barrier_cmd(conf, atomic_read(&conf->nr_pending) ==
 			conf->nr_queued + extra, flush_pending_writes(conf));
-	conf->array_freeze_pending--;
+	WRITE_ONCE(conf->array_freeze_pending, conf->array_freeze_pending - 1);
 	write_sequnlock_irq(&conf->resync_lock);
 }
 
 static void unfreeze_array(struct r10conf *conf)
 {
-- 
2.52.0

