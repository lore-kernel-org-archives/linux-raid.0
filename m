Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FD142188D
	for <linux-raid@vger.kernel.org>; Wed,  4 Feb 2026 14:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217162; cv=none; b=hxRQTT5kYmK3gh7KHnJ+OyQB//Gu4p5AtemSQ9csaCTnGVik5Kf+0yE5e0npbsEEOEW8NXILmgNnVg2BAZsvQm3QQpDFgMOqh8MDBZhBflQpogSp968j2gVXwztGCLdo29o2LeMvDwv+6jCRke9L2IBF/FIzye8Z1s0qgNZyMdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217162; c=relaxed/simple;
	bh=IvswgPQoaKf/WtaTeqfecPt7nM5fripVu8Kxt4ddAuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRVQhlkG4A9+LBJrCJuaIF5Oz8u9SxHaB6YVhDa00e1PsY92E7GRUAzhhgBOrOKB2FrTVkMcUFzni/5BDVMBCyWOYKmA96Yy+limsoU/XfqCzcu6rjEseBiTJOaqsB1u7KkuqMGt1pfk/e3k53QYY5QJDlqpPVX2hDyqb6U67mQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P5XKTLRJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P5XKTLRJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770217161;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tBiLDoJmozM+sFoioBr9RmEnyFKwiMdy2FX6VsTGvNM=;
	b=P5XKTLRJKCGGgW10Tlcmcv4b12uCaEgBfrI+MSUBUVkJ46lgRS8X9teg36L7iykhcWt22G
	tJ1pNl52tmVlpBDMg0km7zea1zSG26JusS16kaJlK8hxDmq/Mw5RHtf8uxCnOcbJkfZuck
	ljhYAQqBDEoeuXihEJBiiCcx1zx2c6w=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-518-J4o-lcA-NligLUjILPMC7Q-1; Wed,
 04 Feb 2026 09:59:20 -0500
X-MC-Unique: J4o-lcA-NligLUjILPMC7Q-1
X-Mimecast-MFC-AGG-ID: J4o-lcA-NligLUjILPMC7Q_1770217159
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0ED221955F45;
	Wed,  4 Feb 2026 14:59:19 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.112.66])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 710B219560A3;
	Wed,  4 Feb 2026 14:59:17 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org
Subject: [PATCH RFC 1/3] md: add return value of mddev_create_serial_pool
Date: Wed,  4 Feb 2026 22:58:55 +0800
Message-ID: <20260204145912.9463-2-xni@redhat.com>
In-Reply-To: <20260204145912.9463-1-xni@redhat.com>
References: <20260204145912.9463-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Prepare for the next patch.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md-bitmap.c | 28 ++++++++++++++++++++++------
 drivers/md/md.c        | 30 +++++++++++++++++++++---------
 drivers/md/md.h        |  2 +-
 3 files changed, 44 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 84b7e2af6dba..1c82961833ba 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2213,8 +2213,11 @@ static int bitmap_load(struct mddev *mddev)
 	if (!bitmap)
 		goto out;
 
-	rdev_for_each(rdev, mddev)
-		mddev_create_serial_pool(mddev, rdev);
+	rdev_for_each(rdev, mddev) {
+		err = mddev_create_serial_pool(mddev, rdev);
+		if (err)
+			goto out;
+	}
 
 	if (mddev_is_clustered(mddev))
 		mddev->cluster_ops->load_bitmaps(mddev, mddev->bitmap_info.nodes);
@@ -2253,9 +2256,15 @@ static int bitmap_load(struct mddev *mddev)
 
 	bitmap_update_sb(bitmap);
 
-	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags))
+	if (test_bit(BITMAP_WRITE_ERROR, &bitmap->flags)) {
 		err = -EIO;
+		goto out;
+	}
+
+	return err;
+
 out:
+	mddev_destroy_serial_pool(mddev, NULL);
 	return err;
 }
 
@@ -2806,19 +2815,26 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 		return -EINVAL;
 	}
 
-	mddev->bitmap_info.max_write_behind = backlog;
 	if (!backlog && mddev->serial_info_pool) {
 		/* serial_info_pool is not needed if backlog is zero */
 		if (!mddev->serialize_policy)
 			mddev_destroy_serial_pool(mddev, NULL);
 	} else if (backlog && !mddev->serial_info_pool) {
 		/* serial_info_pool is needed since backlog is not zero */
-		rdev_for_each(rdev, mddev)
-			mddev_create_serial_pool(mddev, rdev);
+		rdev_for_each(rdev, mddev) {
+			rv = mddev_create_serial_pool(mddev, rdev);
+			if (rv) {
+				mddev_destroy_serial_pool(mddev, NULL);
+				goto unlock;
+			}
+		}
 	}
+
+	mddev->bitmap_info.max_write_behind = backlog;
 	if (old_mwb != backlog)
 		bitmap_update_sb(mddev->bitmap);
 
+unlock:
 	mddev_unlock_and_resume(mddev);
 	return len;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6d73f6e196a9..115df70354ed 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -232,20 +232,20 @@ static int rdev_need_serial(struct md_rdev *rdev)
  * 1. rdev is the first device which return true from rdev_enable_serial.
  * 2. rdev is NULL, means we want to enable serialization for all rdevs.
  */
-void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
+int mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 {
 	int ret = 0;
 
 	if (rdev && !rdev_need_serial(rdev) &&
 	    !test_bit(CollisionCheck, &rdev->flags))
-		return;
+		return ret;
 
 	if (!rdev)
 		ret = rdevs_init_serial(mddev);
 	else
 		ret = rdev_init_serial(rdev);
 	if (ret)
-		return;
+		return ret;
 
 	if (mddev->serial_info_pool == NULL) {
 		/*
@@ -258,8 +258,11 @@ void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 		if (!mddev->serial_info_pool) {
 			rdevs_uninit_serial(mddev);
 			pr_err("can't alloc memory pool for serialization\n");
+			ret = -ENOMEM;
 		}
 	}
+
+	return ret;
 }
 
 /*
@@ -2600,8 +2603,13 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 	rdev->mddev = mddev;
 	pr_debug("md: bind<%s>\n", b);
 
-	if (mddev->raid_disks)
-		mddev_create_serial_pool(mddev, rdev);
+	if (mddev->raid_disks) {
+		err = mddev_create_serial_pool(mddev, rdev);
+		if (err) {
+			pr_err("failed to create serial pool\n");
+			return err;
+		}
+	}
 
 	if ((err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
 		goto fail;
@@ -3114,7 +3122,9 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		}
 	} else if (cmd_match(buf, "writemostly")) {
 		set_bit(WriteMostly, &rdev->flags);
-		mddev_create_serial_pool(rdev->mddev, rdev);
+		err = mddev_create_serial_pool(rdev->mddev, rdev);
+		if (err)
+			return err;
 		need_update_sb = true;
 		err = 0;
 	} else if (cmd_match(buf, "-writemostly")) {
@@ -5924,9 +5934,11 @@ serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
 		goto unlock;
 	}
 
-	if (value)
-		mddev_create_serial_pool(mddev, NULL);
-	else
+	if (value) {
+		err = mddev_create_serial_pool(mddev, NULL);
+		if (err)
+			goto unlock;
+	} else
 		mddev_destroy_serial_pool(mddev, NULL);
 	mddev->serialize_policy = value;
 unlock:
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6985f2829bbd..3c4edc6ed50e 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -956,7 +956,7 @@ extern void md_frozen_sync_thread(struct mddev *mddev);
 extern void md_unfrozen_sync_thread(struct mddev *mddev);
 
 extern void md_update_sb(struct mddev *mddev, int force);
-extern void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev);
+extern int mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev);
 extern void mddev_destroy_serial_pool(struct mddev *mddev,
 				      struct md_rdev *rdev);
 struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr);
-- 
2.50.1 (Apple Git-155)

