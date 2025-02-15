Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D2519CC3D;
	Sat, 15 Feb 2025 09:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739611562; cv=none; b=r260/bnVzdvNtn7dp4sewDlrruHLppB5x3BiyBuikuYNi7qGMZqu3DiI8kpmm98PIVKkUvxqlgRutCbHydXEwrQyW2RAaOJp/dIX/GvBQNq01i/Cmk/OANfsJpAG+RdoCFoc23khoWJYYIlIcg7l6U7YTwctpHuMdBTZn/Zow7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739611562; c=relaxed/simple;
	bh=mUILkePBFpIIgQf9yJ9Y+gJ70NkpBnuxcjxqCKXkZCE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=My7Svh5zibbQmmi1Rpi/z5y1qbm3QmicBAE566uaPJeq9Oz7CAAUnnJnmhHCxD8fAAg0RMxalfZBVNhGkxlwSwnZgRKJO5RxpU5XZ1CmmQHWnKhapYffQ8hJm9s/WKb2JUnkOuZwbF0L77zuJ88P47LgwGQdhEVu1aABJOC3ZxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Yw3Ry21hfz4f3jqN;
	Sat, 15 Feb 2025 17:25:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6D3011A1333;
	Sat, 15 Feb 2025 17:25:50 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAni1+bXbBn+Q+iDw--.49525S7;
	Sat, 15 Feb 2025 17:25:50 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.15 3/7] md: introduce struct md_submodule_head and APIs
Date: Sat, 15 Feb 2025 17:22:21 +0800
Message-Id: <20250215092225.2427977-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250215092225.2427977-1-yukuai1@huaweicloud.com>
References: <20250215092225.2427977-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAni1+bXbBn+Q+iDw--.49525S7
X-Coremail-Antispam: 1UD129KBjvJXoWxuF45KrW5tw1DuFyUtFWUArb_yoW5tryDpF
	WDW343CrW5Xr42gw4fC3W8uFy5Kry8KrWj9a4ay39IkF1jgrW8Aa1UGa98AFn5GF9xZrsr
	Zw15Ga1Du34UJw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBG14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY1x0262kKe7AKxVWUAVWUtw
	CF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j
	6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64
	vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0x
	vEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU9J5rUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Prepare to unify registration and unregistration of md personalities
and md-cluster, also prepare for add kconfig for md-bitmap.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-cluster.h |  2 ++
 drivers/md/md.c         | 14 ++++++++++++++
 drivers/md/md.h         | 31 +++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index 6c7aad00f5da..4e842af11fb4 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -10,6 +10,8 @@ struct mddev;
 struct md_rdev;
 
 struct md_cluster_operations {
+	struct md_submodule_head head;
+
 	int (*join)(struct mddev *mddev, int nodes);
 	int (*leave)(struct mddev *mddev);
 	int (*slot_number)(struct mddev *mddev);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 37f3a89eba94..6b83039a3dcc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -79,6 +79,8 @@ static const char *action_name[NR_SYNC_ACTIONS] = {
 	[ACTION_IDLE]		= "idle",
 };
 
+static DEFINE_XARRAY(md_submodule);
+
 /* pers_list is a list of registered personalities protected by pers_lock. */
 static LIST_HEAD(pers_list);
 static DEFINE_SPINLOCK(pers_lock);
@@ -8522,6 +8524,18 @@ static const struct proc_ops mdstat_proc_ops = {
 	.proc_poll	= mdstat_poll,
 };
 
+int register_md_submodule(struct md_submodule_head *msh)
+{
+	return xa_insert(&md_submodule, msh->id, msh, GFP_KERNEL);
+}
+EXPORT_SYMBOL_GPL(register_md_submodule);
+
+void unregister_md_submodule(struct md_submodule_head *msh)
+{
+	xa_erase(&md_submodule, msh->id);
+}
+EXPORT_SYMBOL_GPL(unregister_md_submodule);
+
 int register_md_personality(struct md_personality *p)
 {
 	pr_debug("md: %s personality registered for level %d\n",
diff --git a/drivers/md/md.h b/drivers/md/md.h
index c9bc70e6d5b4..4807fa0d0362 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -18,10 +18,37 @@
 #include <linux/timer.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
+#include <linux/raid/md_u.h>
 #include <trace/events/block.h>
 
 #define MaxSector (~(sector_t)0)
 
+enum md_submodule_type {
+	MD_PERSONALITY = 0,
+	MD_CLUSTER,
+	MD_BITMAP, /* TODO */
+};
+
+enum md_submodule_id {
+	ID_LINEAR	= LEVEL_LINEAR,
+	ID_RAID0	= 0,
+	ID_RAID1	= 1,
+	ID_RAID4	= 4,
+	ID_RAID5	= 5,
+	ID_RAID6	= 6,
+	ID_RAID10	= 10,
+	ID_CLUSTER,
+	ID_BITMAP,	/* TODO */
+	ID_LLBITMAP,	/* TODO */
+};
+
+struct md_submodule_head {
+	enum md_submodule_type	type;
+	enum md_submodule_id	id;
+	const char		*name;
+	struct module		*owner;
+};
+
 /*
  * These flags should really be called "NO_RETRY" rather than
  * "FAILFAST" because they don't make any promise about time lapse,
@@ -698,6 +725,7 @@ static inline void md_sync_acct_bio(struct bio *bio, unsigned long nr_sectors)
 
 struct md_personality
 {
+	struct md_submodule_head head;
 	char *name;
 	int level;
 	struct list_head list;
@@ -842,6 +870,9 @@ static inline void safe_put_page(struct page *p)
 	if (p) put_page(p);
 }
 
+int register_md_submodule(struct md_submodule_head *msh);
+void unregister_md_submodule(struct md_submodule_head *msh);
+
 extern int register_md_personality(struct md_personality *p);
 extern int unregister_md_personality(struct md_personality *p);
 extern struct md_thread *md_register_thread(
-- 
2.39.2

