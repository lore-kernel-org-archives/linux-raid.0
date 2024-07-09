Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394B15D8F0
	for <linux-raid@vger.kernel.org>; Tue,  9 Jul 2024 10:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720521695; cv=none; b=JP4u3goMOEnStQ4rzQ7UlN/kOUyMNbzteBZw2n2cW8MWxkSI7VAfQi6MmB12pdxQaXcV5Jg1ruUNS8yUKAwBBu8coY0Pe8lF5cR+Q4bwNuU2Ai51W56jcSRTcAJo4YJi7IxfW00cXAIRcc3hH9HS3WfG3Tz+DnYBu4bQVQc4cXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720521695; c=relaxed/simple;
	bh=D/7t/UmnKK9Pzw/SHNJEdXP4Zw5XJP0VLhwdcJTW3uA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l17Dzb+wZp/P8su9tB0XfxDiyuRrF7Ed4pbbLVSpFCtO3j+gXoVLA0I82JRoS5kD9XRXd7yOPJcQZvbqr/xJRr35oF6XUdPp1Fxd1zM8RAyicG+KaQl6mBpeQ5Mp/itcTuL7QZLRVLUpF24GtnYr2tgLqb3sqljvmwXYXDdlZXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MERUrdcF; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MERUrdcF"
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-52ea952ce70so3148333e87.3
        for <linux-raid@vger.kernel.org>; Tue, 09 Jul 2024 03:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720521691; x=1721126491; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zhk/lcEhttNnzIBkQ/lZbGReeO65FCN0Vw1eE0hBPHk=;
        b=MERUrdcFqr87EHSYR1LwGpEiCPBk+K6WR9TmksBD7x7Vr4MhjWqMwI/5FNDbSJW8yg
         Ia2kueUgbR+G4dzuhuZLf8kEn55ZkM1e0rFtK1DiK9iobW2x8Cht3YdzMfkwXa5U/9SV
         +TDAtzhmW32d5E0/PvIkS9EY1wXpX304jxIVd+Jzk11EMbZ9mR9cp7PW4NpfwjkheEYR
         uzigHTXYq/dZ0BXpUE/6sC9t0I5ov4vsWtvgn0Va3D4Rl5PyjGl9A9swhBEsALYpp8vl
         PRMaKIuaHvHY2CkIp+9WF4yqkC8IAKvZghVwboTHSmSnBXlXPP3YWPlmgQ304nKB3tZn
         8Uvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720521691; x=1721126491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zhk/lcEhttNnzIBkQ/lZbGReeO65FCN0Vw1eE0hBPHk=;
        b=kOKbOsc6UzemJcIaEG4e1Ml3ZCKaBrgIHXubhu4THELlA0CSwnQxhKa28r5I1o2RPB
         mCMrU1qw7QAgnCUyOlK8H2aEZtQijoVtXncS6ofEFeuN4aBThu0iioBzILkfXMV+oUg0
         qXZyWBu1EmsPVLMpySwBxf8mGhjJs1Pm28Z9vQnfVb4aINHF3tBOm4WI2muMmqJzSuIC
         S/MFxKTic6mETmNdINDiFKZ8VaaId1QLPAZLE38YUY14H43lAKifY4hAooB/R+JPiI1W
         Tt+Jk2mtwPNEffVDIRPP63QyXPvKZqWVVxcb6yJKDGAjpw0l/v+vHwUITxH/GndxwWfx
         tOIg==
X-Forwarded-Encrypted: i=1; AJvYcCV/Eav4+Q7zeVMYdUfruMFcAZ/urYv39+XJPu1AZKl5VB7lRI3hkclSFubDM90CLuWMplt8mTmn3iDYfrG0NlZJBvCwVjVbPCM59Q==
X-Gm-Message-State: AOJu0YwghkCsWhA+CZkCkp6pHpK7IZpac4n1a1bAHhp2K0907TxGTCky
	hVVFCbzTU24/2/5Z4aW+Si5vhVfJj4FbG3Lxl20XGm/B8x5p6wmImvNFVoTlE8E=
X-Google-Smtp-Source: AGHT+IFs/XfdR/X9t8I64MhhHZGp9YolOYaAIMF1UGPONTRAQDxZUONjoXhgMgGj3gjEujGdd489IQ==
X-Received: by 2002:a05:6512:3b82:b0:52c:fd49:d42 with SMTP id 2adb3069b0e04-52eb9990d58mr1302055e87.14.1720521690247;
        Tue, 09 Jul 2024 03:41:30 -0700 (PDT)
Received: from localhost.localdomain ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6a2a623sm13212475ad.69.2024.07.09.03.41.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 03:41:29 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: song@kernel.org,
	yukuai1@huaweicloud.com,
	xni@redhat.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	glass.su@suse.com,
	linux-raid@vger.kernel.org
Subject: [PATCH v2 2/2] md-cluster: fix no recovery job when adding/re-adding a disk
Date: Tue,  9 Jul 2024 18:41:20 +0800
Message-Id: <20240709104120.22243-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240709104120.22243-1-heming.zhao@suse.com>
References: <20240709104120.22243-1-heming.zhao@suse.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The commit db5e653d7c9f ("md: delay choosing sync action to
md_start_sync()") delays the start of the sync action. In a
clustered environment, this will cause another node to first
activate the spare disk and skip recovery. As a result, no
nodes will perform recovery when a disk is added or re-added.

Before db5e653d7c9f:

```
   node1                                node2
----------------------------------------------------------------
md_check_recovery
 + md_update_sb
 |  sendmsg: METADATA_UPDATED
 + md_choose_sync_action           process_metadata_update
 |  remove_and_add_spares           //node1 has not finished adding
 + call mddev->sync_work            //the spare disk:do nothing

md_start_sync
 starts md_do_sync

md_do_sync
 + grabbed resync_lockres:DLM_LOCK_EX
 + do syncing job

md_check_recovery
 sendmsg: METADATA_UPDATED
                                 process_metadata_update
                                   //activate spare disk

                                 ... ...

                                 md_do_sync
                                  waiting to grab resync_lockres:EX
```

After db5e653d7c9f:

(note: if 'cmd:idle' sets MD_RECOVERY_INTR after md_check_recovery
starts md_start_sync, setting the INTR action will exacerbate the
delay in node1 calling the md_do_sync function.)

```
   node1                                node2
----------------------------------------------------------------
md_check_recovery
 + md_update_sb
 |  sendmsg: METADATA_UPDATED
 + calls mddev->sync_work         process_metadata_update
                                   //node1 has not finished adding
                                   //the spare disk:do nothing

md_start_sync
 + md_choose_sync_action
 |  remove_and_add_spares
 + calls md_do_sync

md_check_recovery
 md_update_sb
  sendmsg: METADATA_UPDATED
                                  process_metadata_update
                                    //activate spare disk

  ... ...                         ... ...

                                  md_do_sync
                                   + grabbed resync_lockres:EX
                                   + raid1_sync_request skip sync under
				     conf->fullsync:0
md_do_sync
 1. waiting to grab resync_lockres:EX
 2. when node1 could grab EX lock,
    node1 will skip resync under recovery_offset:MaxSector
```

How to trigger:

```(commands @node1)
 # to easily watch the recovery status
echo 2000 > /proc/sys/dev/raid/speed_limit_max
ssh root@node2 "echo 2000 > /proc/sys/dev/raid/speed_limit_max"

mdadm -CR /dev/md0 -l1 -b clustered -n 2 /dev/sda /dev/sdb --assume-clean
ssh root@node2 mdadm -A /dev/md0 /dev/sda /dev/sdb
mdadm --manage /dev/md0 --fail /dev/sda --remove /dev/sda
mdadm --manage /dev/md0 --add /dev/sdc

=== "cat /proc/mdstat" on both node, there are no recovery action. ===
```

How to fix:

because md layer code logic is hard to restore for speeding up sync job
on local node, we add new cluster msg to pending the another node to
active disk.

Signed-off-by: Heming Zhao <heming.zhao@suse.com>
Reviewed-by: Su Yue <glass.su@suse.com>
---
v1 -> v2: no change in this patch
---
 drivers/md/md-cluster.c | 27 +++++++++++++++++++++++++++
 drivers/md/md-cluster.h |  2 ++
 drivers/md/md.c         | 17 ++++++++++++++---
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index b5a802ae17bb..bf6a0dd8dac7 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -57,6 +57,7 @@ struct resync_info {
 #define		MD_CLUSTER_ALREADY_IN_CLUSTER		6
 #define		MD_CLUSTER_PENDING_RECV_EVENT		7
 #define 	MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD		8
+#define		MD_CLUSTER_WAITING_FOR_SYNC		9
 
 struct md_cluster_info {
 	struct mddev *mddev; /* the md device which md_cluster_info belongs to */
@@ -92,6 +93,7 @@ struct md_cluster_info {
 	sector_t sync_hi;
 };
 
+/* For compatibility, add the new msg_type at the end. */
 enum msg_type {
 	METADATA_UPDATED = 0,
 	RESYNCING,
@@ -101,6 +103,7 @@ enum msg_type {
 	BITMAP_NEEDS_SYNC,
 	CHANGE_CAPACITY,
 	BITMAP_RESIZE,
+	RESYNCING_START,
 };
 
 struct cluster_msg {
@@ -461,6 +464,7 @@ static void process_suspend_info(struct mddev *mddev,
 		clear_bit(MD_RESYNCING_REMOTE, &mddev->recovery);
 		remove_suspend_info(mddev, slot);
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		clear_bit(MD_CLUSTER_WAITING_FOR_SYNC, &cinfo->state);
 		md_wakeup_thread(mddev->thread);
 		return;
 	}
@@ -531,6 +535,7 @@ static int process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
 		res = -1;
 	}
 	clear_bit(MD_CLUSTER_WAITING_FOR_NEWDISK, &cinfo->state);
+	set_bit(MD_CLUSTER_WAITING_FOR_SYNC, &cinfo->state);
 	return res;
 }
 
@@ -599,6 +604,9 @@ static int process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 	case CHANGE_CAPACITY:
 		set_capacity_and_notify(mddev->gendisk, mddev->array_sectors);
 		break;
+	case RESYNCING_START:
+		clear_bit(MD_CLUSTER_WAITING_FOR_SYNC, &mddev->cluster_info->state);
+		break;
 	case RESYNCING:
 		set_bit(MD_RESYNCING_REMOTE, &mddev->recovery);
 		process_suspend_info(mddev, le32_to_cpu(msg->slot),
@@ -1345,6 +1353,23 @@ static void resync_info_get(struct mddev *mddev, sector_t *lo, sector_t *hi)
 	spin_unlock_irq(&cinfo->suspend_lock);
 }
 
+static int resync_status_get(struct mddev *mddev)
+{
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+
+	return test_bit(MD_CLUSTER_WAITING_FOR_SYNC, &cinfo->state);
+}
+
+static int resync_start_notify(struct mddev *mddev)
+{
+	struct md_cluster_info *cinfo = mddev->cluster_info;
+	struct cluster_msg cmsg = {0};
+
+	cmsg.type = cpu_to_le32(RESYNCING_START);
+
+	return sendmsg(cinfo, &cmsg, 0);
+}
+
 static int resync_info_update(struct mddev *mddev, sector_t lo, sector_t hi)
 {
 	struct md_cluster_info *cinfo = mddev->cluster_info;
@@ -1579,6 +1604,8 @@ static struct md_cluster_operations cluster_ops = {
 	.resync_start = resync_start,
 	.resync_finish = resync_finish,
 	.resync_info_update = resync_info_update,
+	.resync_start_notify = resync_start_notify,
+	.resync_status_get = resync_status_get,
 	.resync_info_get = resync_info_get,
 	.metadata_update_start = metadata_update_start,
 	.metadata_update_finish = metadata_update_finish,
diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
index a78e3021775d..470bf18ffde5 100644
--- a/drivers/md/md-cluster.h
+++ b/drivers/md/md-cluster.h
@@ -14,6 +14,8 @@ struct md_cluster_operations {
 	int (*leave)(struct mddev *mddev);
 	int (*slot_number)(struct mddev *mddev);
 	int (*resync_info_update)(struct mddev *mddev, sector_t lo, sector_t hi);
+	int (*resync_start_notify)(struct mddev *mddev);
+	int (*resync_status_get)(struct mddev *mddev);
 	void (*resync_info_get)(struct mddev *mddev, sector_t *lo, sector_t *hi);
 	int (*metadata_update_start)(struct mddev *mddev);
 	int (*metadata_update_finish)(struct mddev *mddev);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index aff9118ff697..e393df55fc8b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8907,7 +8907,8 @@ void md_do_sync(struct md_thread *thread)
 	 * This will mean we have to start checking from the beginning again.
 	 *
 	 */
-
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->resync_start_notify(mddev);
 	do {
 		int mddev2_minor = -1;
 		mddev->curr_resync = MD_RESYNC_DELAYED;
@@ -9968,8 +9969,18 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
 			 */
 			if (rdev2->raid_disk == -1 && role != MD_DISK_ROLE_SPARE &&
 			    !(le32_to_cpu(sb->feature_map) &
-			      MD_FEATURE_RESHAPE_ACTIVE)) {
-				rdev2->saved_raid_disk = role;
+			      MD_FEATURE_RESHAPE_ACTIVE) &&
+			    !md_cluster_ops->resync_status_get(mddev)) {
+				/*
+				 * -1 to make raid1_add_disk() set conf->fullsync
+				 * to 1. This could avoid skipping sync when the
+				 * remote node is down during resyncing.
+				 */
+				if ((le32_to_cpu(sb->feature_map)
+				    & MD_FEATURE_RECOVERY_OFFSET))
+					rdev2->saved_raid_disk = -1;
+				else
+					rdev2->saved_raid_disk = role;
 				ret = remove_and_add_spares(mddev, rdev2);
 				pr_info("Activated spare: %pg\n",
 					rdev2->bdev);
-- 
2.35.3

