Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C643B1A3
	for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 02:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718158768; cv=none; b=WKJH+iMv3tK4woNqhSvhW5XqXMlJwxkKGqQ+gVLpIqmg7K3tFjEjf59QZcbnOdsWzIFfLMDCmhKYVc1M+bawUb64w+58ibWekNA+H7yFRgAVcV+A6QMeL/59fYXICyq5m15++y3CDgCIGGCHBnH8gd6R4CLJzuZFWeRmLBUAIII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718158768; c=relaxed/simple;
	bh=ntIa5wHwF1OmzjcXIlxxYpmo06FQS279lJsIE+g9soI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EQNPqZuTkyk0wKPPVRDAMmRUcenZDg9P9+BJWp1H8WCAE2uqHiT22skdlTEQnv5icSv1u/BnsrmWphTnjEfHifnU1VtuUk5a3TxfoT8t9xHXTOF5kMxolTumXhe13GevOq4/eyaQX70HfkuJn+tDHl/QxknfoAD6x+NoQBI3O8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WINQ1LdH; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WINQ1LdH"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2ebe3bac6c6so20221581fa.1
        for <linux-raid@vger.kernel.org>; Tue, 11 Jun 2024 19:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1718158763; x=1718763563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=48VjDX6wOjneyKDE2EIebu2UTcxC1BG8LGwmfNYHIpY=;
        b=WINQ1LdH//LDkJSYS0qMYf8PzE40aiHQStwaunFui24VTqjESY9WW3+abnsQq5JMkK
         e42g8g2Yg33+5XrwgGDVU1pby/FClhawE70F9Oya7dpRKl9VD6AL/YCPb/SEgr4eI+QN
         3rMmZBtsDmP729OxdJoyrfaD+UiLZxE3X2jKbkRS0rxiV8ViLnsD+24ekH0zccyAxj/N
         Ag62Ce5mNEH180DvONmhcJFFxZyW+GSvWv8gx5lZjbqn4kAz1sVOLn6hvT2/bBIoPypx
         bJ8Z1dFTfHoGgQMqPJTsvSlpf5Cp2zNVwM3wABfUse0AIphv8vFFLUuFz0jJE3mU42t2
         l7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718158763; x=1718763563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=48VjDX6wOjneyKDE2EIebu2UTcxC1BG8LGwmfNYHIpY=;
        b=OeM+QwRC7m6u6pYnRVRkGCBG6LZWE4DydS+u9MjoCkajmVv85Y6Krl6EObyUuKGnD1
         Bf5YggJ5n0+PEU4/ZWpnbXMiKomlTLdPZG4JPD+TOtNz37NTzMfw5gBfJAWAq/Nk0wmP
         8UTq649qeDfDFndwQJ/UKOx4lTco4v7m+tBE7jwaeka+oq2adueyfIdnok1drVvv+I8o
         x4/DydH9ywWTFne7Nyyjs+SdrNVUal08n2bX1koSXOOOvCXv2d2UTSu4v1EAHcOn79sv
         QjMCYpplmxqiEKX9oYHmLKjm+cWSUH8qW5n51DDZSGImuKx6KJOt7oCRNaTJkrNj2+9F
         FqCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVsCRrtCwAtfvlQi/4YDZBK7O1XPY3fmITr0yKk371YQIx5T5w9mdvNb69uSTe0Nq0VC3ofGv463O+D90XaMM1cVjMwxj394TZ+vw==
X-Gm-Message-State: AOJu0YwT2qPzMHtlg2mOF4p06tcNAhQnMo3cwuJoNkZbS6DssYjDxNYc
	hZDfwCsFTi3ql3hivp0PQacz/eCvyaQiUeOluIUc5cEqvbKhvmbKXCyfzYJHSEk=
X-Google-Smtp-Source: AGHT+IGe/cn/fgrF4Us8G1Gdc6M1p8lrZLZS71Vuj6tcbEBZI5r8oDco2f9qSoWINnDKYkQO1VOPSw==
X-Received: by 2002:a05:651c:543:b0:2eb:fca8:7f19 with SMTP id 38308e7fff4ca-2ebfca88181mr4671131fa.36.1718158763472;
        Tue, 11 Jun 2024 19:19:23 -0700 (PDT)
Received: from p15.suse.cz ([114.254.76.16])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c4a75f0afbsm353054a91.14.2024.06.11.19.19.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jun 2024 19:19:22 -0700 (PDT)
From: Heming Zhao <heming.zhao@suse.com>
To: song@kernel.org,
	yukuai1@huaweicloud.com,
	xni@redhat.com
Cc: Heming Zhao <heming.zhao@suse.com>,
	glass.su@suse.com,
	linux-raid@vger.kernel.org
Subject: [PATCH 2/2] md-cluster: fix no recovery job when adding/re-adding a disk
Date: Wed, 12 Jun 2024 10:19:11 +0800
Message-Id: <20240612021911.11043-2-heming.zhao@suse.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20240612021911.11043-1-heming.zhao@suse.com>
References: <20240612021911.11043-1-heming.zhao@suse.com>
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
 drivers/md/md-cluster.c | 27 +++++++++++++++++++++++++++
 drivers/md/md-cluster.h |  2 ++
 drivers/md/md.c         | 17 ++++++++++++++---
 3 files changed, 43 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 27eaaf9fef94..ab1e3c490279 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -56,6 +56,7 @@ struct resync_info {
 #define		MD_CLUSTER_ALREADY_IN_CLUSTER		6
 #define		MD_CLUSTER_PENDING_RECV_EVENT		7
 #define 	MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD		8
+#define		MD_CLUSTER_WAITING_FOR_SYNC		9
 
 struct md_cluster_info {
 	struct mddev *mddev; /* the md device which md_cluster_info belongs to */
@@ -91,6 +92,7 @@ struct md_cluster_info {
 	sector_t sync_hi;
 };
 
+/* For compatibility, add the new msg_type at the end. */
 enum msg_type {
 	METADATA_UPDATED = 0,
 	RESYNCING,
@@ -100,6 +102,7 @@ enum msg_type {
 	BITMAP_NEEDS_SYNC,
 	CHANGE_CAPACITY,
 	BITMAP_RESIZE,
+	RESYNCING_START,
 };
 
 struct cluster_msg {
@@ -460,6 +463,7 @@ static void process_suspend_info(struct mddev *mddev,
 		clear_bit(MD_RESYNCING_REMOTE, &mddev->recovery);
 		remove_suspend_info(mddev, slot);
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		clear_bit(MD_CLUSTER_WAITING_FOR_SYNC, &cinfo->state);
 		md_wakeup_thread(mddev->thread);
 		return;
 	}
@@ -530,6 +534,7 @@ static int process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
 		res = -1;
 	}
 	clear_bit(MD_CLUSTER_WAITING_FOR_NEWDISK, &cinfo->state);
+	set_bit(MD_CLUSTER_WAITING_FOR_SYNC, &cinfo->state);
 	return res;
 }
 
@@ -598,6 +603,9 @@ static int process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 	case CHANGE_CAPACITY:
 		set_capacity_and_notify(mddev->gendisk, mddev->array_sectors);
 		break;
+	case RESYNCING_START:
+		clear_bit(MD_CLUSTER_WAITING_FOR_SYNC, &mddev->cluster_info->state);
+		break;
 	case RESYNCING:
 		set_bit(MD_RESYNCING_REMOTE, &mddev->recovery);
 		process_suspend_info(mddev, le32_to_cpu(msg->slot),
@@ -1353,6 +1361,23 @@ static void resync_info_get(struct mddev *mddev, sector_t *lo, sector_t *hi)
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
@@ -1587,6 +1612,8 @@ static struct md_cluster_operations cluster_ops = {
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
index e575e74aabf5..97d7e96d1d5e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8902,7 +8902,8 @@ void md_do_sync(struct md_thread *thread)
 	 * This will mean we have to start checking from the beginning again.
 	 *
 	 */
-
+	if (mddev_is_clustered(mddev))
+		md_cluster_ops->resync_start_notify(mddev);
 	do {
 		int mddev2_minor = -1;
 		mddev->curr_resync = MD_RESYNC_DELAYED;
@@ -9963,8 +9964,18 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
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

