Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A9E17CA06;
	Tue, 11 Jun 2024 13:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112203; cv=none; b=lk8VO5YIHdawKNtlp4PmwH8OrHSzWs1JmZZpS5RickmXCsBOJBAM4YBKHyjNCKxPnLDwqSoIn1qZq1D2/NeX76+qJW83r9sgRulR+ZYaRQPMgviULOLpSMjL71yEG8XgChQUTMH2pABGE/e4YpUEuOQHUa9QEYNIqkLDmDUrSIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112203; c=relaxed/simple;
	bh=rWZtzcpzDpV/4ia5hBpVlrOtLmUJOWal4baZD/yF5xs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=g8b8P8iMmBXPOB3y1wALsLZBXZEjn1nsBfhQ8HnQmKU+b/s/oJ2Ivh8pZ5yTT7mPRT8Xlv3BsJzfPGFwqxMUHLMtkiYhB7JCpnZ789KpwDC9Gd6/Wel4Sbp0tyjDdCOnTLNQuVaabkLPxPCS+j2McNA17Kr/27yGRdLDpdewOxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Vz8W32VDXz4f3jkB;
	Tue, 11 Jun 2024 21:23:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id D8A3F1A0ED4;
	Tue, 11 Jun 2024 21:23:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxDBT2hmsVPEPA--.1557S8;
	Tue, 11 Jun 2024 21:23:17 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	xni@redhat.com,
	mariusz.tkaczyk@linux.intel.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2 md-6.11 04/12] md: factor out helper to start reshape from action_store()
Date: Tue, 11 Jun 2024 21:22:43 +0800
Message-Id: <20240611132251.1967786-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240611132251.1967786-1-yukuai1@huaweicloud.com>
References: <20240611132251.1967786-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDHlxDBT2hmsVPEPA--.1557S8
X-Coremail-Antispam: 1UD129KBjvJXoWxur1UJF4rCr1fZr1UKrW3KFg_yoW5Xw1fpa
	yftFn5JrWUJr9xXw43tw1kWa4Ykr1xtrWDtrW7Wa4xAF1Syr4xC3WYg3Z7XrykJayvyF4Y
	qa15JFWUCFyjgaUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr
	1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
	M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
	v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
	F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
	IY04v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
	wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc4
	0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AK
	xVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQSdkU
	UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

There are no functional changes, just to make code cleaner and prepare
for following refactor.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 65 +++++++++++++++++++++++++++++++------------------
 1 file changed, 41 insertions(+), 24 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4ce8d164cde9..b34ae9fbd246 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5071,6 +5071,45 @@ static void frozen_sync_thread(struct mddev *mddev)
 	mutex_unlock(&mddev->sync_mutex);
 }
 
+static int mddev_start_reshape(struct mddev *mddev)
+{
+	int ret;
+
+	if (mddev->pers->start_reshape == NULL)
+		return -EINVAL;
+
+	ret = mddev_lock(mddev);
+	if (ret)
+		return ret;
+
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
+		mddev_unlock(mddev);
+		return -EBUSY;
+	}
+
+	if (mddev->reshape_position == MaxSector ||
+	    mddev->pers->check_reshape == NULL ||
+	    mddev->pers->check_reshape(mddev)) {
+		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+		ret = mddev->pers->start_reshape(mddev);
+		if (ret) {
+			mddev_unlock(mddev);
+			return ret;
+		}
+	} else {
+		/*
+		 * If reshape is still in progress, and md_check_recovery() can
+		 * continue to reshape, don't restart reshape because data can
+		 * be corrupted for raid456.
+		 */
+		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	}
+
+	mddev_unlock(mddev);
+	sysfs_notify_dirent_safe(mddev->sysfs_degraded);
+	return 0;
+}
+
 static ssize_t
 action_store(struct mddev *mddev, const char *page, size_t len)
 {
@@ -5090,32 +5129,10 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 	} else if (cmd_match(page, "reshape")) {
-		int err;
-		if (mddev->pers->start_reshape == NULL)
-			return -EINVAL;
-		err = mddev_lock(mddev);
-		if (!err) {
-			if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-				err =  -EBUSY;
-			} else if (mddev->reshape_position == MaxSector ||
-				   mddev->pers->check_reshape == NULL ||
-				   mddev->pers->check_reshape(mddev)) {
-				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-				err = mddev->pers->start_reshape(mddev);
-			} else {
-				/*
-				 * If reshape is still in progress, and
-				 * md_check_recovery() can continue to reshape,
-				 * don't restart reshape because data can be
-				 * corrupted for raid456.
-				 */
-				clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-			}
-			mddev_unlock(mddev);
-		}
+		int err = mddev_start_reshape(mddev);
+
 		if (err)
 			return err;
-		sysfs_notify_dirent_safe(mddev->sysfs_degraded);
 	} else {
 		if (cmd_match(page, "check"))
 			set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
-- 
2.39.2

