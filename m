Received: from forward202a.mail.yandex.net (forward202a.mail.yandex.net [178.154.239.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C4E2566
	for <linux-raid@vger.kernel.org>; Tue,  5 Aug 2025 10:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754390668; cv=none; b=XiLJuAlnZzCXfJza8Ohw9HG//kIwMd5URgSRZCI2Shlc5L9eHNUQKtLaG80khQ6himL1MUxOhz55BY3ssIwfdV4+p/7cAsNaaUN2rDU7N+6CGcRSl0xgG7WQWkLenyd6CjrTgmskYmdDjG6JQfU6+Y3V2C1+CDq9xh2Rw2c74Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754390668; c=relaxed/simple;
	bh=TaxIRiqnW4pvBvj7X66uKXwZ5HO2Hk3IkgDVqBomauY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uXujqDgyEKU/scoHhZB0jUpbs+vvfL3dvk2nmwvV0g7o3pLJ3bzhm/JGks9vO8h4iHtE1PfZg7AHv5sr3C4A7TtoIt2xXnVGARWCEl9vf+qht5phxflx2/cKHukPxl4IjJnaSJheWSnynsgcNRwoxbCvFg9hsHBk5XmqdDD3hq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=Su83G19U; arc=none smtp.client-ip=178.154.239.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="Su83G19U"
Received: from forward103a.mail.yandex.net (forward103a.mail.yandex.net [IPv6:2a02:6b8:c0e:500:1:45:d181:d103])
	by forward202a.mail.yandex.net (Yandex) with ESMTPS id AB35885CCD
	for <linux-raid@vger.kernel.org>; Tue, 05 Aug 2025 13:37:30 +0300 (MSK)
Received: from mail-nwsmtp-smtp-production-main-60.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-60.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:1f21:0:640:a2e6:0])
	by forward103a.mail.yandex.net (Yandex) with ESMTPS id D443080453;
	Tue, 05 Aug 2025 13:37:22 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-60.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id LbdmGi3MrKo0-fGcmbKoP;
	Tue, 05 Aug 2025 13:37:22 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1754390242; bh=uoF525NLZcPHuc+Dkq1eJyBF4juyM9crT/PZbY6ZNEQ=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=Su83G19UW/fDWr7dU/xi0wYgCPW9so9gjxGsaBy/yqUh1PkLtl2r3N7iGGX9jnG+E
	 c4QLWqsFuPdq5tbPXWKQqQemsyiFk3xW7WF57aKNFVaWcZzyvb4nFwTJMM6JnRmxCZ
	 +HZlhUgO9jepN9dXwovRa+QHUYIlqCc5pm2xE/18=
Authentication-Results: mail-nwsmtp-smtp-production-main-60.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: linux-raid@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] md/md-cluster: use union for cluster messages
Date: Tue,  5 Aug 2025 13:37:08 +0300
Message-ID: <20250805103708.490429-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

As suggested by TODO note, convert 'struct cluster_msg' to
use union for message-specific arguments and so reduce the
memory footprint of the aforementioned structure from 48
to 32 bytes. Compile tested only.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 drivers/md/md-cluster.c | 56 +++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 25 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 94221d964d4f..d9902bcd92c7 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -109,11 +109,17 @@ enum msg_type {
 struct cluster_msg {
 	__le32 type;
 	__le32 slot;
-	/* TODO: Unionize this for smaller footprint */
-	__le64 low;
-	__le64 high;
-	char uuid[16];
-	__le32 raid_slot;
+	union {
+		__le64 size;			/* BITMAP_RESIZE */
+		struct {
+			__le64 low;
+			__le64 high;
+		} resync;			/* RESYNCING */
+		struct {
+			char uuid[16];          /* NEWDISK */
+			__le32 raid_slot;
+		} other;			/* others */
+	} u;
 };
 
 static void sync_ast(void *arg)
@@ -522,8 +528,8 @@ static int process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
 	int res = 0;
 
 	len = snprintf(disk_uuid, 64, "DEVICE_UUID=");
-	sprintf(disk_uuid + len, "%pU", cmsg->uuid);
-	snprintf(raid_slot, 16, "RAID_DISK=%d", le32_to_cpu(cmsg->raid_slot));
+	sprintf(disk_uuid + len, "%pU", cmsg->u.other.uuid);
+	snprintf(raid_slot, 16, "RAID_DISK=%d", le32_to_cpu(cmsg->u.other.raid_slot));
 	pr_info("%s:%d Sending kobject change with %s and %s\n", __func__, __LINE__, disk_uuid, raid_slot);
 	init_completion(&cinfo->newdisk_completion);
 	set_bit(MD_CLUSTER_WAITING_FOR_NEWDISK, &cinfo->state);
@@ -545,7 +551,7 @@ static void process_metadata_update(struct mddev *mddev, struct cluster_msg *msg
 	int got_lock = 0;
 	struct md_thread *thread;
 	struct md_cluster_info *cinfo = mddev->cluster_info;
-	mddev->good_device_nr = le32_to_cpu(msg->raid_slot);
+	mddev->good_device_nr = le32_to_cpu(msg->u.other.raid_slot);
 
 	dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_CR);
 
@@ -564,7 +570,7 @@ static void process_remove_disk(struct mddev *mddev, struct cluster_msg *msg)
 	struct md_rdev *rdev;
 
 	rcu_read_lock();
-	rdev = md_find_rdev_nr_rcu(mddev, le32_to_cpu(msg->raid_slot));
+	rdev = md_find_rdev_nr_rcu(mddev, le32_to_cpu(msg->u.other.raid_slot));
 	if (rdev) {
 		set_bit(ClusterRemove, &rdev->flags);
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -572,7 +578,7 @@ static void process_remove_disk(struct mddev *mddev, struct cluster_msg *msg)
 	}
 	else
 		pr_warn("%s: %d Could not find disk(%d) to REMOVE\n",
-			__func__, __LINE__, le32_to_cpu(msg->raid_slot));
+			__func__, __LINE__, le32_to_cpu(msg->u.other.raid_slot));
 	rcu_read_unlock();
 }
 
@@ -581,12 +587,12 @@ static void process_readd_disk(struct mddev *mddev, struct cluster_msg *msg)
 	struct md_rdev *rdev;
 
 	rcu_read_lock();
-	rdev = md_find_rdev_nr_rcu(mddev, le32_to_cpu(msg->raid_slot));
+	rdev = md_find_rdev_nr_rcu(mddev, le32_to_cpu(msg->u.other.raid_slot));
 	if (rdev && test_bit(Faulty, &rdev->flags))
 		clear_bit(Faulty, &rdev->flags);
 	else
 		pr_warn("%s: %d Could not find disk(%d) which is faulty",
-			__func__, __LINE__, le32_to_cpu(msg->raid_slot));
+			__func__, __LINE__, le32_to_cpu(msg->u.other.raid_slot));
 	rcu_read_unlock();
 }
 
@@ -610,8 +616,8 @@ static int process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 	case RESYNCING:
 		set_bit(MD_RESYNCING_REMOTE, &mddev->recovery);
 		process_suspend_info(mddev, le32_to_cpu(msg->slot),
-				     le64_to_cpu(msg->low),
-				     le64_to_cpu(msg->high));
+				     le64_to_cpu(msg->u.resync.low),
+				     le64_to_cpu(msg->u.resync.high));
 		break;
 	case NEWDISK:
 		if (process_add_new_disk(mddev, msg))
@@ -627,9 +633,9 @@ static int process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 		__recover_slot(mddev, le32_to_cpu(msg->slot));
 		break;
 	case BITMAP_RESIZE:
-		if (le64_to_cpu(msg->high) != mddev->pers->size(mddev, 0, 0))
+		if (le64_to_cpu(msg->u.size) != mddev->pers->size(mddev, 0, 0))
 			ret = mddev->bitmap_ops->resize(mddev,
-							le64_to_cpu(msg->high),
+							le64_to_cpu(msg->u.size),
 							0, false);
 		break;
 	default:
@@ -1111,7 +1117,7 @@ static int metadata_update_finish(struct mddev *mddev)
 			break;
 		}
 	if (raid_slot >= 0) {
-		cmsg.raid_slot = cpu_to_le32(raid_slot);
+		cmsg.u.other.raid_slot = cpu_to_le32(raid_slot);
 		ret = __sendmsg(cinfo, &cmsg);
 	} else
 		pr_warn("md-cluster: No good device id found to send\n");
@@ -1134,7 +1140,7 @@ static int update_bitmap_size(struct mddev *mddev, sector_t size)
 	int ret;
 
 	cmsg.type = cpu_to_le32(BITMAP_RESIZE);
-	cmsg.high = cpu_to_le64(size);
+	cmsg.u.size = cpu_to_le64(size);
 	ret = sendmsg(cinfo, &cmsg, 0);
 	if (ret)
 		pr_err("%s:%d: failed to send BITMAP_RESIZE message (%d)\n",
@@ -1309,7 +1315,7 @@ static void update_size(struct mddev *mddev, sector_t old_dev_sectors)
 			break;
 		}
 	if (raid_slot >= 0) {
-		cmsg.raid_slot = cpu_to_le32(raid_slot);
+		cmsg.u.other.raid_slot = cpu_to_le32(raid_slot);
 		/*
 		 * We can only change capiticy after all the nodes can do it,
 		 * so need to wait after other nodes already received the msg
@@ -1402,8 +1408,8 @@ static int resync_info_update(struct mddev *mddev, sector_t lo, sector_t hi)
 	/* Re-acquire the lock to refresh LVB */
 	dlm_lock_sync(cinfo->bitmap_lockres, DLM_LOCK_PW);
 	cmsg.type = cpu_to_le32(RESYNCING);
-	cmsg.low = cpu_to_le64(lo);
-	cmsg.high = cpu_to_le64(hi);
+	cmsg.u.resync.low = cpu_to_le64(lo);
+	cmsg.u.resync.high = cpu_to_le64(hi);
 
 	/*
 	 * mddev_lock is held if resync_info_update is called from
@@ -1463,8 +1469,8 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
 
 	memset(&cmsg, 0, sizeof(cmsg));
 	cmsg.type = cpu_to_le32(NEWDISK);
-	memcpy(cmsg.uuid, uuid, 16);
-	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
+	memcpy(cmsg.u.other.uuid, uuid, 16);
+	cmsg.u.other.raid_slot = cpu_to_le32(rdev->desc_nr);
 	if (lock_comm(cinfo, 1))
 		return -EAGAIN;
 	ret = __sendmsg(cinfo, &cmsg);
@@ -1527,7 +1533,7 @@ static int remove_disk(struct mddev *mddev, struct md_rdev *rdev)
 	struct cluster_msg cmsg = {0};
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 	cmsg.type = cpu_to_le32(REMOVE);
-	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
+	cmsg.u.other.raid_slot = cpu_to_le32(rdev->desc_nr);
 	return sendmsg(cinfo, &cmsg, 1);
 }
 
@@ -1592,7 +1598,7 @@ static int gather_bitmaps(struct md_rdev *rdev)
 	struct md_cluster_info *cinfo = mddev->cluster_info;
 
 	cmsg.type = cpu_to_le32(RE_ADD);
-	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
+	cmsg.u.other.raid_slot = cpu_to_le32(rdev->desc_nr);
 	err = sendmsg(cinfo, &cmsg, 1);
 	if (err)
 		goto out;
-- 
2.50.1

