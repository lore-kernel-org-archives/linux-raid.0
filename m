Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4EFAC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 14:21:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97324610F8
	for <linux-raid@archiver.kernel.org>; Wed, 13 Oct 2021 14:21:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbhJMOXJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Oct 2021 10:23:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20693 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236050AbhJMOXF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 13 Oct 2021 10:23:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634134860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=iKf+zWvP47eic4ZFotliJ/1LD8EDG1LdAvkuB7yuYMc=;
        b=EjCKyHpo8IsiAwDiFgiY4x8RGnGTqfuxI5Y3rjwEPIInoNixmT9D6YwQiXglJ+uLIT88J8
        +vJEoqT9xuiyR0vGWXJ+avzZVpOVfrjT8VJxZacg9eGjxNsgXp7svXUk5Tc83f6UK/l8RI
        UYCrYEcntbkwOyQDtiAg70yRmXIJVIY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-n-kMy7kHO3CzdkUjvWuL7A-1; Wed, 13 Oct 2021 10:20:57 -0400
X-MC-Unique: n-kMy7kHO3CzdkUjvWuL7A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B029C801FCE;
        Wed, 13 Oct 2021 14:20:56 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB0C760FB8;
        Wed, 13 Oct 2021 14:20:53 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     song@kernel.org
Cc:     fengli@smartx.com, linux-raid@vger.kernel.org
Subject: [PATCH 1/1] md: Need to update superblock after changing rdev sb_flags
Date:   Wed, 13 Oct 2021 22:20:51 +0800
Message-Id: <1634134851-4275-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

It doesn't update rdev superblock flags to disk after changing these flags.
This patch does this job. In the process of creating a raid, it creates per
device sysfs files and then sets value to mddev->pers. There is a interval
between the two events. If someone changes rdev flags in this interval, it
needs to record this. So it sets MD_SB_CHANGE_DEVS first. If mddev->pers is
NULL, it can update superblock after creating mddev->thread.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 drivers/md/md.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6c0c3d0..40d0f50 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2976,7 +2976,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 	 *  -write_error - clears WriteErrorSeen
 	 *  {,-}failfast - set/clear FailFast
 	 */
+
+	struct mddev *mddev = rdev->mddev;
 	int err = -EINVAL;
+	bool need_update_sb = false;
+
 	if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
 		md_error(rdev->mddev, rdev);
 		if (test_bit(Faulty, &rdev->flags))
@@ -2991,7 +2995,6 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		if (rdev->raid_disk >= 0)
 			err = -EBUSY;
 		else {
-			struct mddev *mddev = rdev->mddev;
 			err = 0;
 			if (mddev_is_clustered(mddev))
 				err = md_cluster_ops->remove_disk(mddev, rdev);
@@ -3008,10 +3011,12 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 	} else if (cmd_match(buf, "writemostly")) {
 		set_bit(WriteMostly, &rdev->flags);
 		mddev_create_serial_pool(rdev->mddev, rdev, false);
+		need_update_sb = true;
 		err = 0;
 	} else if (cmd_match(buf, "-writemostly")) {
 		mddev_destroy_serial_pool(rdev->mddev, rdev, false);
 		clear_bit(WriteMostly, &rdev->flags);
+		need_update_sb = true;
 		err = 0;
 	} else if (cmd_match(buf, "blocked")) {
 		set_bit(Blocked, &rdev->flags);
@@ -3037,9 +3042,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		err = 0;
 	} else if (cmd_match(buf, "failfast")) {
 		set_bit(FailFast, &rdev->flags);
+		need_update_sb = true;
 		err = 0;
 	} else if (cmd_match(buf, "-failfast")) {
 		clear_bit(FailFast, &rdev->flags);
+		need_update_sb = true;
 		err = 0;
 	} else if (cmd_match(buf, "-insync") && rdev->raid_disk >= 0 &&
 		   !test_bit(Journal, &rdev->flags)) {
@@ -3118,6 +3125,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		clear_bit(ExternalBbl, &rdev->flags);
 		err = 0;
 	}
+	if (need_update_sb) {
+		set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
+		if (mddev->pers)
+			md_wakeup_thread(mddev->thread);
+	}
 	if (!err)
 		sysfs_notify_dirent_safe(rdev->sysfs_state);
 	return err ? err : len;
-- 
2.7.5

