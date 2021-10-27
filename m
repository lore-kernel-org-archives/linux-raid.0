Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2943EC433F5
	for <linux-raid@archiver.kernel.org>; Wed, 27 Oct 2021 12:23:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13E1160F9B
	for <linux-raid@archiver.kernel.org>; Wed, 27 Oct 2021 12:23:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241879AbhJ0M0O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 27 Oct 2021 08:26:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52679 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235184AbhJ0M0L (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Wed, 27 Oct 2021 08:26:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635337426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=l8gznGUrtW/Z2HE0RkrdQdZnZnkSmCH46JPQMjzWtCs=;
        b=LVTvPmGCqpfnkf+i3a15Vw2ha4cyJpDZfmcM21+vwTL6kRjN8I+XMxEO+wtOT1ub1rsRYp
        6m9LHwHDVADqtUlsQiGX94kWPaW72BULq99lpWz4Z0oMRkqTshF8dnAP7fx7p5tUsULNtj
        /qfJKJ3f2tFSA2CHLptWA6zFr4j6F0g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-nR4hO0L1Me-oJpciIaq3XA-1; Wed, 27 Oct 2021 08:23:43 -0400
X-MC-Unique: nR4hO0L1Me-oJpciIaq3XA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15A83809CDB;
        Wed, 27 Oct 2021 12:23:42 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-102.pek2.redhat.com [10.72.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D007C5C1B4;
        Wed, 27 Oct 2021 12:23:26 +0000 (UTC)
From:   Xiao Ni <xni@redhat.com>
To:     jes@trained-monkey.org
Cc:     ncroxon@redhat.com, ffan@redhat.com,
        mariusz.tkaczyk@linux.intel.com, linux-raid@vger.kernel.org
Subject: [PATCH 1/2] mdadm/lib: Define a new helper function is_dev_alived
Date:   Wed, 27 Oct 2021 20:23:13 +0800
Message-Id: <1635337394-4782-2-git-send-email-xni@redhat.com>
In-Reply-To: <1635337394-4782-1-git-send-email-xni@redhat.com>
References: <1635337394-4782-1-git-send-email-xni@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

The function is used to check if one member disk is alive.

Signed-off-by: Xiao Ni <xni@redhat.com>
Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
---
 lib.c   | 11 +++++++++++
 mdadm.h |  2 ++
 2 files changed, 13 insertions(+)

diff --git a/lib.c b/lib.c
index 76d1fbb..7e3e3d4 100644
--- a/lib.c
+++ b/lib.c
@@ -27,6 +27,17 @@
 #include	<ctype.h>
 #include	<limits.h>
 
+bool is_dev_alive(char *path)
+{
+	if (!path)
+		return false;
+
+	if (access(path, R_OK) == 0)
+		return true;
+
+	return false;
+}
+
 /* This fill contains various 'library' style function.  They
  * have no dependency on anything outside this file.
  */
diff --git a/mdadm.h b/mdadm.h
index 53ea0de..4e483bf 100644
--- a/mdadm.h
+++ b/mdadm.h
@@ -45,6 +45,7 @@ extern __off64_t lseek64 __P ((int __fd, __off64_t __offset, int __whence));
 #include	<errno.h>
 #include	<string.h>
 #include	<syslog.h>
+#include	<stdbool.h>
 /* Newer glibc requires sys/sysmacros.h directly for makedev() */
 #include	<sys/sysmacros.h>
 #ifdef __dietlibc__
@@ -1499,6 +1500,7 @@ extern int check_partitions(int fd, char *dname,
 extern int fstat_is_blkdev(int fd, char *devname, dev_t *rdev);
 extern int stat_is_blkdev(char *devname, dev_t *rdev);
 
+extern bool is_dev_alive(char *path);
 extern int get_mdp_major(void);
 extern int get_maj_min(char *dev, int *major, int *minor);
 extern int dev_open(char *dev, int flags);
-- 
2.7.5

