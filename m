Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA54156E8
	for <linux-raid@vger.kernel.org>; Thu, 11 Jan 2024 12:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4T9k2k6pfWz4f3jYs
	for <linux-raid@vger.kernel.org>; Thu, 11 Jan 2024 20:08:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id EA0D51A0C91
	for <linux-raid@vger.kernel.org>; Thu, 11 Jan 2024 20:08:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgBHGBEv2p9lrwAPAg--.20108S4;
	Thu, 11 Jan 2024 20:08:16 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: linux-raid@vger.kernel.org,
	mariusz.tkaczyk@linux.intel.com,
	jes@trained-monkey.org,
	song@kernel.org
Cc: yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yangerkun@huawei.com
Subject: [PATCH] mdadm: stop using 'idle' for sysfs api "sync_action" to wake up sync_thread
Date: Thu, 11 Jan 2024 20:05:05 +0800
Message-Id: <20240111120505.4135257-1-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHGBEv2p9lrwAPAg--.20108S4
X-Coremail-Antispam: 1UD129KBjvJXoWxWFWxAF4xKryxZF1rWFyrtFb_yoW5ZryUpr
	WSvw1UCr1ktrs5tw45AFWkCry8Was5Jw1rKrWFkw4jyw4Yq3ykKr1qv39FkryUZrZ8Za1U
	X3yjkFWrAF1jkrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7Cj
	xVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Echo 'idle' to "sync_action" is supposed to stop sync_thread while new
sync_thread can still start. However, currently this behaviour is not
correct, echo 'idle' will actually try to stop sync_thread and then
start a new sync_thread. And mdadm relies on this wrong behaviour in
some places.

In kernel, if resync is not done yet, then recovery/reshape/check/repair
can't not start in the first place, and if resync is done, echo 'resync'
behaves the same as echo 'idle' for now.

Hence replace echo 'idle' with echo 'resync/reshape' when trying to
continue frozed sync_thread. There should be no functional changes and
prevent regressions after fixing that echo 'idle' will start new
sync_thread in kernel.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 Grow.c   | 2 +-
 Manage.c | 8 ++++----
 msg.c    | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/Grow.c b/Grow.c
index 8fa97875..05498c6f 100644
--- a/Grow.c
+++ b/Grow.c
@@ -843,7 +843,7 @@ static void unfreeze(struct supertype *st)
 		if (sra &&
 		    sysfs_get_str(sra, NULL, "sync_action", buf, 20) > 0 &&
 		    strcmp(buf, "frozen\n") == 0)
-			sysfs_set_str(sra, NULL, "sync_action", "idle");
+			sysfs_set_str(sra, NULL, "sync_action", "reshape");
 		sysfs_free(sra);
 	}
 }
diff --git a/Manage.c b/Manage.c
index 91532266..91483112 100644
--- a/Manage.c
+++ b/Manage.c
@@ -344,7 +344,7 @@ int Manage_stop(char *devname, int fd, int verbose, int will_retry)
 			backwards = 1;
 		if (sysfs_get_ll(mdi, NULL, "reshape_position", &position) != 0) {
 			/* reshape must have finished now */
-			sysfs_set_str(mdi, NULL, "sync_action", "idle");
+			sysfs_set_str(mdi, NULL, "sync_action", "resync");
 			goto done;
 		}
 		sysfs_get_two(mdi, NULL, "chunk_size", &chunk1, &chunk2);
@@ -386,7 +386,7 @@ int Manage_stop(char *devname, int fd, int verbose, int will_retry)
 		 * the reshape monitor */
 		if (sync_max < old_sync_max)
 			sysfs_set_num(mdi, NULL, "sync_max", sync_max);
-		sysfs_set_str(mdi, NULL, "sync_action", "idle");
+		sysfs_set_str(mdi, NULL, "sync_action", "resync");
 
 		/* That should have set things going again.  Now we
 		 * wait a little while (3 second max) for sync_completed
@@ -1717,7 +1717,7 @@ int Manage_subdevs(char *devname, int fd,
 	}
 	free(tst);
 	if (frozen > 0)
-		sysfs_set_str(&info, NULL, "sync_action","idle");
+		sysfs_set_str(&info, NULL, "sync_action", "resync");
 	if (test && count == 0)
 		return 2;
 	return 0;
@@ -1725,7 +1725,7 @@ int Manage_subdevs(char *devname, int fd,
 abort:
 	free(tst);
 	if (frozen > 0)
-		sysfs_set_str(&info, NULL, "sync_action","idle");
+		sysfs_set_str(&info, NULL, "sync_action", "resync");
 	return !test && busy ? 2 : 1;
 }
 
diff --git a/msg.c b/msg.c
index 45cd4504..d9f08ebf 100644
--- a/msg.c
+++ b/msg.c
@@ -252,7 +252,7 @@ int unblock_subarray(struct mdinfo *sra, const int unfreeze)
 	    sysfs_set_str(sra, NULL, "metadata_version", buf) ||
 	    (unfreeze &&
 	     sysfs_attribute_available(sra, NULL, "sync_action") &&
-	     sysfs_set_str(sra, NULL, "sync_action", "idle")))
+	     sysfs_set_str(sra, NULL, "sync_action", "resync")))
 		rc = -1;
 	return rc;
 }
-- 
2.39.2

