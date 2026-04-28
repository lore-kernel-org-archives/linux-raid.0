Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C89E313539
	for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 23:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777418424; cv=none; b=rv2gxqLD/++WCJOjjk1djBfxJjbgTR2PpqXiC6ILQlKu816LoE0fYfwsSOY1PwKIsgTJC1LpOXdR2W+ZiK2OXAUJNGDrysHZzY+/XtBjma0gHqTY9yegcc528Xkox6XBXaTQpuEB+ncaqAC8SOfzl/xDzI3Csd5jc5Pqvzilbdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777418424; c=relaxed/simple;
	bh=MUygkXLebJKUNNORN49qoiGYrdigq3CfCx6GdS+hXQE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AoW8P9dzJ7CB2Q/LJzjq3U9P2B6px454328TY9YXk8juannm878hUO60n0+x44JP66DRKC9bFZcI2yXUuP0YHwgLBhTI+CabMhvPn3tU+TPdefjWODwU5o3NfwB2vvH9F69HdhwReHejXvWZC771KFllaFh+sydiIZDhEWHYOiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QX7TKkWz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QX7TKkWz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777418422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Ch9Fpl2PF7WWGPGtx9SgS7sBArmGqVayqAhOWYb7zb0=;
	b=QX7TKkWzCTpWJs1IyZq0QtLdAjqAuB6pD14A4RiTL+2OxjYnmbrkgNipjuY9UJRa3Mc4Fb
	tfRvQTUiAHv3F/MOcrWmvJe6hN20LezorOmC3KCiEZgnfA4DKJXig3PT7tjZA8W3L1099N
	tdHHFwsTNJDM9BLKx8FuTlfFZ3jw4AI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-646-6r2CAUpYNNixlBnTLNu1ew-1; Tue,
 28 Apr 2026 19:20:16 -0400
X-MC-Unique: 6r2CAUpYNNixlBnTLNu1ew-1
X-Mimecast-MFC-AGG-ID: 6r2CAUpYNNixlBnTLNu1ew_1777418415
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 72449195608E;
	Tue, 28 Apr 2026 23:20:14 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7EDCD1800352;
	Tue, 28 Apr 2026 23:20:13 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.17.1) with ESMTPS id 63SNKCqC2785523
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 28 Apr 2026 19:20:12 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.18.1/8.18.1/Submit) id 63SNKAUF2785522;
	Tue, 28 Apr 2026 19:20:10 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Yu Kuai <yukuai@alb-78bjiv52429oh8qptp.cn-shenzhen.alb.aliyuncs.com>,
        Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, dm-devel@lists.linux.dev,
        Yang Xiuwei <yangxiuwei@kylinos.cn>, Xiao Ni <xiao@kernel.org>,
        Li Nan <linan122@huawei.com>, Nigel Croxon <ncroxon@redhat.com>
Subject: [PATCH v2] dm-raid: only requeue bios when dm is suspending.
Date: Tue, 28 Apr 2026 19:20:10 -0400
Message-ID: <20260428232010.2785514-1-bmarzins@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

returning DM_MAPIO_REQUEUE from the target map() function only requeues
the bio during noflush suspends. During regular operations or during
flushing suspends, it fails the bio. Failing the bio during flushing
suspends is the correct behavior here. We cannot handle the bio, and we
cannot suspends while it is outstanding. But during normal operations,
we should not push the bio back to dm. Instead, wait for the reshape
to be resumed.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---

Changes from v1:
- Track the dm device's suspending state in mddev->flags instead of
  adding a new integer to mddev.

 drivers/md/dm-raid.c | 6 ++++++
 drivers/md/md.h      | 2 ++
 drivers/md/raid5.c   | 7 +++++--
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index c5dc083c7244..8f5a5e1342a9 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3831,6 +3831,7 @@ static void raid_presuspend(struct dm_target *ti)
 	 * resume, raid_postsuspend() is too late.
 	 */
 	set_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
+	set_bit(MD_DM_SUSPENDING, &mddev->flags);
 
 	if (!reshape_interrupted(mddev))
 		return;
@@ -3847,13 +3848,16 @@ static void raid_presuspend(struct dm_target *ti)
 static void raid_presuspend_undo(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
+	struct mddev *mddev = &rs->md;
 
+	clear_bit(MD_DM_SUSPENDING, &mddev->flags);
 	clear_bit(RT_FLAG_RS_FROZEN, &rs->runtime_flags);
 }
 
 static void raid_postsuspend(struct dm_target *ti)
 {
 	struct raid_set *rs = ti->private;
+	struct mddev *mddev = &rs->md;
 
 	if (!test_and_set_bit(RT_FLAG_RS_SUSPENDED, &rs->runtime_flags)) {
 		/*
@@ -3864,6 +3868,8 @@ static void raid_postsuspend(struct dm_target *ti)
 		mddev_suspend(&rs->md, false);
 		rs->md.ro = MD_RDONLY;
 	}
+	clear_bit(MD_DM_SUSPENDING, &mddev->flags);
+
 }
 
 static void attempt_restore_of_faulty_devices(struct raid_set *rs)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 52c378086046..9e5100609d12 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -346,6 +346,7 @@ struct md_cluster_operations;
  * @MD_HAS_SUPERBLOCK: There is persistence sb in member disks.
  * @MD_FAILLAST_DEV: Allow last rdev to be removed.
  * @MD_SERIALIZE_POLICY: Enforce write IO is not reordered, just used by raid1.
+ * @MD_DM_SUSPENDING: This DM raid device is suspending.
  *
  * change UNSUPPORTED_MDDEV_FLAGS for each array type if new flag is added
  */
@@ -365,6 +366,7 @@ enum mddev_flags {
 	MD_HAS_SUPERBLOCK,
 	MD_FAILLAST_DEV,
 	MD_SERIALIZE_POLICY,
+	MD_DM_SUSPENDING,
 };
 
 enum mddev_sb_flags {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0d76e82f4506..65ae7d8930fc 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6042,8 +6042,11 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
 	raid5_release_stripe(sh);
 out:
 	if (ret == STRIPE_SCHEDULE_AND_RETRY && reshape_interrupted(mddev)) {
-		bi->bi_status = BLK_STS_RESOURCE;
-		ret = STRIPE_WAIT_RESHAPE;
+		if (!mddev_is_dm(mddev) ||
+		    test_bit(MD_DM_SUSPENDING, &mddev->flags)) {
+			bi->bi_status = BLK_STS_RESOURCE;
+			ret = STRIPE_WAIT_RESHAPE;
+		}
 		pr_err_ratelimited("dm-raid456: io across reshape position while reshape can't make progress");
 	}
 	return ret;
-- 
2.53.0

