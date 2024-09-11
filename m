Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EE817F500
	for <linux-raid@vger.kernel.org>; Wed, 11 Sep 2024 08:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726044908; cv=none; b=YiyVjdcI26ld/xpbIIPLc8JjOVfEVVG2jvCBSNCAr1lRQ+xFB+4T9zkhYkKvgSn/gSGJij+2kBJyMh+Z8IIbOqQuXq+wUMufuOAttt+oKbwQ4q6YstWGtsmDxVfLx/eBn9IZp6zKF/1EpbVrZlL1Lncmy6jy1f28fSOWR0nPgX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726044908; c=relaxed/simple;
	bh=3R5bjZW2k+13MxV8qtgaazliryK+LB595Y/ZnuaZfu0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tSU3s6rUGWHlIjQ4ZBqA4OdrBZRZQ+ji2J6teh3YWZPNfd4dhjtZmPp9+K3XtD5ahfuFhCARsU0AIwLzyKd6MLDW/uQ4ecPJLjJoWOwJNa7Aha/WEbCAAd1JrM7kFtMkkyxBUHsZUJT49ySSeiiMqk06Qut45pB6UGhuA8jCbEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hn1umpI+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hn1umpI+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1726044906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qOjV1DD5nLgIPRR5RHA+HtBbJtXk+/9yuAPgArD0GCU=;
	b=hn1umpI++JNZdvQhV6gJ0GuRRVauxK+wpbIu9saS1HbiMGargMJKb0f35sKLKTS/myT+nn
	OXAu0ZxRPsBtuXWpcyiKBafJbFF0ZK8ekskjAIDZBXpEIyOES7QNDlFmZ0Fdob7GLhZc+H
	38RHlkeaoBhO45Di56Adobvhke2tn1Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-681-hHRQ29k0PMm3KdE71Phpgg-1; Wed,
 11 Sep 2024 04:55:04 -0400
X-MC-Unique: hHRQ29k0PMm3KdE71Phpgg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A9C5A1955D47;
	Wed, 11 Sep 2024 08:55:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.25])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 245DC1956086;
	Wed, 11 Sep 2024 08:54:59 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: mariusz.tkaczyk@linux.intel.com
Cc: linux-raid@vger.kernel.org,
	ncroxon@redhat.com
Subject: [PATCH 07/10] mdadm/tests: Remove 07reshape5intr.broken
Date: Wed, 11 Sep 2024 16:54:29 +0800
Message-Id: <20240911085432.37828-8-xni@redhat.com>
In-Reply-To: <20240911085432.37828-1-xni@redhat.com>
References: <20240911085432.37828-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

07reshape5intr can run successfully now.

Signed-off-by: Xiao Ni <xni@redhat.com>
---
 tests/07reshape5intr.broken | 45 -------------------------------------
 1 file changed, 45 deletions(-)
 delete mode 100644 tests/07reshape5intr.broken

diff --git a/tests/07reshape5intr.broken b/tests/07reshape5intr.broken
index efe52a667172..000000000000
--- a/tests/07reshape5intr.broken
+++ /dev/null
@@ -1,45 +0,0 @@
-always fails
-
-This patch, recently added to md-next causes the test to always fail:
-
-7e6ba434cc60 ("md: don't unregister sync_thread with reconfig_mutex
-held")
-
-The new error is simply:
-
-   ERROR: no reshape happening
-
-Before the patch, the error seen is below.
-
---
-
-fails infrequently
-
-Fails roughly 1 in 4 runs with errors:
-
-    mdadm: Merging with already-assembled /dev/md/0
-    mdadm: cannot re-read metadata from /dev/loop6 - aborting
-
-    ERROR: no reshape happening
-
-Also have seen a random deadlock:
-
-     INFO: task mdadm:109702 blocked for more than 30 seconds.
-           Not tainted 5.18.0-rc3-eid-vmlocalyes-dbg-00095-g3c2b5427979d #2040
-     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
-     task:mdadm           state:D stack:    0 pid:109702 ppid:     1 flags:0x00004000
-     Call Trace:
-      <TASK>
-      __schedule+0x67e/0x13b0
-      schedule+0x82/0x110
-      mddev_suspend+0x2e1/0x330
-      suspend_lo_store+0xbd/0x140
-      md_attr_store+0xcb/0x130
-      sysfs_kf_write+0x89/0xb0
-      kernfs_fop_write_iter+0x202/0x2c0
-      new_sync_write+0x222/0x330
-      vfs_write+0x3bc/0x4d0
-      ksys_write+0xd9/0x180
-      __x64_sys_write+0x43/0x50
-      do_syscall_64+0x3b/0x90
-      entry_SYSCALL_64_after_hwframe+0x44/0xae
-- 
2.32.0 (Apple Git-132)

