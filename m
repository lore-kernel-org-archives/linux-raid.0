Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DD4B1C860B
	for <linux-raid@vger.kernel.org>; Wed, 13 Aug 2025 03:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755055785; cv=none; b=RSa7LrIkMlOzeJN7ZmSzfbIo2zru5hdWrvpgVdcETiT/34IVraBhAyAYuHaev/UoIFKs8If206xKT6hFctx1v2QUZlemETlGNuxqji/4UR6wLlALTPQHwRIWh/bWGzBYCZ2Cck96ca8ZDHYY2F9iB4G5YBlkd8UBbQ+S5fNQ/gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755055785; c=relaxed/simple;
	bh=DAJXMt91DEvbfd1BKJrBUv1tqIvGBatIUcCTLkpmxqA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ghK230zRHsk+11rHXqwHujQhFKMIGMnoHA5bjsPlD+gBW0kGmAGym8yQe92MUrj2JmSXwya4H2FGDASOmx19VInRjmJ+B2I0uhC3sVl2hHcNxKsT8BRovxQw8M+NMVN2NsifrZ+nW9ZmYJ7p/5wqwOGk0ivkYJ7XqkrpJRlF9fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DPj8TTtj; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DPj8TTtj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755055781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jH1XbO7/J3V18HWNoaO3kGHM3xwh4EZKD9MD4+B2DoU=;
	b=DPj8TTtjO6LqbkxIGfvf2fFXUsoee1P0MW7LlcwyjQzfOGawQZjKQlIw69QdNJC8buFvIj
	ZoKTb8YMbox07w6Ju934CvQmIDQL9m06YKMv/f7537TL5tfgBxLuE2gcv7PuNEuUBciKrU
	LbgC2PlkwzAdba8PNTrTjXJ1uID2xpk=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-456-cWSuWoo0M4aClRsVa8G5NQ-1; Tue,
 12 Aug 2025 23:29:37 -0400
X-MC-Unique: cWSuWoo0M4aClRsVa8G5NQ-1
X-Mimecast-MFC-AGG-ID: cWSuWoo0M4aClRsVa8G5NQ_1755055776
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 489021800340;
	Wed, 13 Aug 2025 03:29:36 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8106D195608F;
	Wed, 13 Aug 2025 03:29:31 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai1@huaweicloud.com
Cc: linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	mpatocka@redhat.com,
	luca.boccassi@gmail.com
Subject: [PATCH v4 1/1] md: add legacy_async_del_gendisk mode
Date: Wed, 13 Aug 2025 11:29:29 +0800
Message-Id: <20250813032929.54978-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

commit 9e59d609763f ("md: call del_gendisk in control path") changes the
async way to sync way of calling del_gendisk. But it breaks mdadm
--assemble command. The assemble command runs like this:
1. create the array
2. stop the array
3. access the sysfs files after stopping

The sync way calls del_gendisk in step 2, so all sysfs files are removed.
Now to avoid breaking mdadm assemble command, this patch adds the parameter
legacy_async_del_gendisk that can be used to choose which way. The default
is async way. In future, we plan to change default to sync way in kernel
7.0. Then users need to upgrade to mdadm 4.5+ which removes step 2.

Fixes: 9e59d609763f ("md: call del_gendisk in control path")
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Closes: https://lore.kernel.org/linux-raid/CAMw=ZnQ=ET2St-+hnhsuq34rRPnebqcXqP1QqaHW5Bh4aaaZ4g@mail.gmail.com/T/#t
Suggested-and-reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Xiao Ni <xni@redhat.com>
---
v2: minor changes on format and log content
v3: changes in commit message and log content
v4: choose to change to sync way as default first in commit message
 drivers/md/md.c | 56 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 42 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index ac85ec73a409..772cffe02ff5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -339,6 +339,7 @@ static int start_readonly;
  * so all the races disappear.
  */
 static bool create_on_open = true;
+static bool legacy_async_del_gendisk = true;
 
 /*
  * We have a system wide 'event count' that is incremented
@@ -877,15 +878,18 @@ void mddev_unlock(struct mddev *mddev)
 		export_rdev(rdev, mddev);
 	}
 
-	/* Call del_gendisk after release reconfig_mutex to avoid
-	 * deadlock (e.g. call del_gendisk under the lock and an
-	 * access to sysfs files waits the lock)
-	 * And MD_DELETED is only used for md raid which is set in
-	 * do_md_stop. dm raid only uses md_stop to stop. So dm raid
-	 * doesn't need to check MD_DELETED when getting reconfig lock
-	 */
-	if (test_bit(MD_DELETED, &mddev->flags))
-		del_gendisk(mddev->gendisk);
+	if (!legacy_async_del_gendisk) {
+		/*
+		 * Call del_gendisk after release reconfig_mutex to avoid
+		 * deadlock (e.g. call del_gendisk under the lock and an
+		 * access to sysfs files waits the lock)
+		 * And MD_DELETED is only used for md raid which is set in
+		 * do_md_stop. dm raid only uses md_stop to stop. So dm raid
+		 * doesn't need to check MD_DELETED when getting reconfig lock
+		 */
+		if (test_bit(MD_DELETED, &mddev->flags))
+			del_gendisk(mddev->gendisk);
+	}
 }
 EXPORT_SYMBOL_GPL(mddev_unlock);
 
@@ -5818,6 +5822,13 @@ static void md_kobj_release(struct kobject *ko)
 {
 	struct mddev *mddev = container_of(ko, struct mddev, kobj);
 
+	if (legacy_async_del_gendisk) {
+		if (mddev->sysfs_state)
+			sysfs_put(mddev->sysfs_state);
+		if (mddev->sysfs_level)
+			sysfs_put(mddev->sysfs_level);
+		del_gendisk(mddev->gendisk);
+	}
 	put_disk(mddev->gendisk);
 }
 
@@ -6021,6 +6032,9 @@ static int md_alloc_and_put(dev_t dev, char *name)
 {
 	struct mddev *mddev = md_alloc(dev, name);
 
+	if (legacy_async_del_gendisk)
+		pr_warn("md: async del_gendisk mode will be removed in future, please upgrade to mdadm-4.5+\n");
+
 	if (IS_ERR(mddev))
 		return PTR_ERR(mddev);
 	mddev_put(mddev);
@@ -6431,10 +6445,22 @@ static void md_clean(struct mddev *mddev)
 	mddev->persistent = 0;
 	mddev->level = LEVEL_NONE;
 	mddev->clevel[0] = 0;
-	/* if UNTIL_STOP is set, it's cleared here */
-	mddev->hold_active = 0;
-	/* Don't clear MD_CLOSING, or mddev can be opened again. */
-	mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
+
+	/*
+	 * For legacy_async_del_gendisk mode, it can stop the array in the
+	 * middle of assembling it, then it still can access the array. So
+	 * it needs to clear MD_CLOSING. If not legacy_async_del_gendisk,
+	 * it can't open the array again after stopping it. So it doesn't
+	 * clear MD_CLOSING.
+	 */
+	if (legacy_async_del_gendisk && mddev->hold_active) {
+		clear_bit(MD_CLOSING, &mddev->flags);
+	} else {
+		/* if UNTIL_STOP is set, it's cleared here */
+		mddev->hold_active = 0;
+		/* Don't clear MD_CLOSING, or mddev can be opened again. */
+		mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
+	}
 	mddev->sb_flags = 0;
 	mddev->ro = MD_RDWR;
 	mddev->metadata_type[0] = 0;
@@ -6658,7 +6684,8 @@ static int do_md_stop(struct mddev *mddev, int mode)
 
 		export_array(mddev);
 		md_clean(mddev);
-		set_bit(MD_DELETED, &mddev->flags);
+		if (!legacy_async_del_gendisk)
+			set_bit(MD_DELETED, &mddev->flags);
 	}
 	md_new_event();
 	sysfs_notify_dirent_safe(mddev->sysfs_state);
@@ -10392,6 +10419,7 @@ module_param_call(start_ro, set_ro, get_ro, NULL, S_IRUSR|S_IWUSR);
 module_param(start_dirty_degraded, int, S_IRUGO|S_IWUSR);
 module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
 module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
+module_param(legacy_async_del_gendisk, bool, 0600);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("MD RAID framework");
-- 
2.32.0 (Apple Git-132)

