Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 232E6C432BE
	for <linux-raid@archiver.kernel.org>; Sat, 14 Aug 2021 18:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0975560F39
	for <linux-raid@archiver.kernel.org>; Sat, 14 Aug 2021 18:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239016AbhHNSfX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 14 Aug 2021 14:35:23 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:44909 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239013AbhHNSfW (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 14 Aug 2021 14:35:22 -0400
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
 mrelayeu.kundenserver.de (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1MKsWr-1mVo140zoz-00LBjr; Sat, 14 Aug 2021 20:34:39 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v2 1/3] dm: introduce audit event module for device mapper
Date:   Sat, 14 Aug 2021 20:33:53 +0200
Message-Id: <20210814183359.4061-2-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de>
References: <20210814183359.4061-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:u2dVAf0ZtddTZ14NZnAn+TLJPTKr66gghVXqlc7nSaOPR30S8tm
 /vTMEXeV2herj/auuZ6GmRczRVzBiPpKjQGc3HvAWYhxvJJShSeSkPx91iykCtelfYg8lDA
 YpJXwh/MwmL51MPREQp7HSdH7LsYAoLdBKeQIJLf3xDddvO3k0YwU7TrbDp+Wi9ElfDaXZX
 HDZj9ZmzkSC4xejCor1lg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:CkJ2RcV9QeA=:gppEzhMPUmegmipNa1YRZH
 ucN+CHFumHwjl2GrAJ4bbktvXHpaITvXsNn3+Ru3Fd7k+wbaIA7EAu33GLy8FCKSul5so9BFZ
 7KaKciA9+Z0NLcJ8ltXdo8xi8cY3U71h5m6AeF4hcz4KqH2ZylCdro4V8NN+wDZpsTn9vg2FA
 v8mPfECg9nzmI/79jTut7eUEXkjzHH2FaCr+il8VFhZGw9C/1ejVvVb64Y8ZyVbjQ3NtyFqG4
 /y2vJKl1uqUrSesDlLgpE/q9SkmdRYHTXbpQQttIAXTmllnoHYihgr/TJ9rz45rIohSr3GudT
 4Glg5iZh2YroYcDFnXt6m6pIbXeP2iQnSD3/tMvZdW2yVainCGunklvyp6w+bqt/aWKju5u4g
 tSdqz+ORIhguxnbSZr78n/qTRprPggyKO70wTnGxeoqfbwlDbQ1pB+odImml0l08WtBmKb3sl
 f3297NSW6G2MoNoRXmjNLFVqlhVdDlVh7KV16WIpqarmDbYowSpJJyZb++J+UTb8tZ6e2PwzF
 7v7K4nsOwpSGEjCMYkx2hOATVLo1zyAE+2JT2HhtdI9jzxaByGsvXFFwD/TEw3lfuKdXZ39Xg
 N9DRMORDqLcnDACLk/AlOM/gH3wLBuWDkBG9onMVrCnzCxCtOPgtBKCH4/H+DRiZzEDeEqoCG
 1Wzzh5BvtXf3reJI8JdN7PeQtCv/nS0a9aMUEIrqPM3wL9z0gZVPJYEZUrmlVOPR2A+61mYdX
 MFyXWf/T4mbdfqoiXuzQLLE1nCGCood5RxGh8yydd41pWOdNz9Ezun1XGbIpcvG/c9TmGb1B4
 8kimHkR7aB1huKNnbAZEsu/vKF0UCi26gmKWOspi0h3/L9/wBiOtOdupYMNxkuWZXNDIxVTl6
 eELTIsvwvXrG2kpU0qaA==
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

To be able to send auditing events to user space, we introduce
a generic dm-audit module. It provides helper functions to emit
audit events through the kernel audit subsystem. We claim the
AUDIT_DM type=1336 out of the audit event messages range in the
corresponding userspace api in 'include/uapi/linux/audit.h' for
those events.

Following commits to device mapper targets actually will make
use of this to emit those events in relevant cases.

Signed-off-by: Michael Weiß <michael.weiss@aisec.fraunhofer.de>
---
 drivers/md/Kconfig         | 10 +++++++
 drivers/md/Makefile        |  4 +++
 drivers/md/dm-audit.c      | 59 ++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-audit.h      | 33 +++++++++++++++++++++
 include/uapi/linux/audit.h |  1 +
 5 files changed, 107 insertions(+)
 create mode 100644 drivers/md/dm-audit.c
 create mode 100644 drivers/md/dm-audit.h

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 0602e82a9516..48adbec12148 100644
--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -608,6 +608,7 @@ config DM_INTEGRITY
 	select CRYPTO
 	select CRYPTO_SKCIPHER
 	select ASYNC_XOR
+	select DM_AUDIT if AUDIT
 	help
 	  This device-mapper target emulates a block device that has
 	  additional per-sector tags that can be used for storing
@@ -640,4 +641,13 @@ config DM_ZONED
 
 	  If unsure, say N.
 
+config DM_AUDIT
+	bool "DM audit events"
+	depends on AUDIT
+	help
+	  Generate audit events for device-mapper.
+
+	  Enables audit logging of several security relevant events in the
+	  particular device-mapper targets, especially the integrity target.
+
 endif # MD
diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index a74aaf8b1445..4cd47623c742 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -103,3 +103,7 @@ endif
 ifeq ($(CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG),y)
 dm-verity-objs			+= dm-verity-verify-sig.o
 endif
+
+ifeq ($(CONFIG_DM_AUDIT),y)
+dm-mod-objs				+= dm-audit.o
+endif
diff --git a/drivers/md/dm-audit.c b/drivers/md/dm-audit.c
new file mode 100644
index 000000000000..c7e5824821bb
--- /dev/null
+++ b/drivers/md/dm-audit.c
@@ -0,0 +1,59 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Creating audit records for mapped devices.
+ *
+ * Copyright (C) 2021 Fraunhofer AISEC. All rights reserved.
+ *
+ * Authors: Michael Weiß <michael.weiss@aisec.fraunhofer.de>
+ */
+
+#include <linux/audit.h>
+#include <linux/module.h>
+#include <linux/device-mapper.h>
+#include <linux/bio.h>
+#include <linux/blkdev.h>
+
+#include "dm-audit.h"
+#include "dm-core.h"
+
+void dm_audit_log_bio(const char *dm_msg_prefix, const char *op,
+		      struct bio *bio, sector_t sector, int result)
+{
+	struct audit_buffer *ab;
+
+	if (audit_enabled == AUDIT_OFF)
+		return;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_DM);
+	if (unlikely(!ab))
+		return;
+
+	audit_log_format(ab, "module=%s dev=%d:%d op=%s sector=%llu res=%d",
+			 dm_msg_prefix, MAJOR(bio->bi_bdev->bd_dev),
+			 MINOR(bio->bi_bdev->bd_dev), op, sector, result);
+	audit_log_end(ab);
+}
+EXPORT_SYMBOL_GPL(dm_audit_log_bio);
+
+void dm_audit_log_target(const char *dm_msg_prefix, const char *op,
+			 struct dm_target *ti, int result)
+{
+	struct audit_buffer *ab;
+	struct mapped_device *md = dm_table_get_md(ti->table);
+
+	if (audit_enabled == AUDIT_OFF)
+		return;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_DM);
+	if (unlikely(!ab))
+		return;
+
+	audit_log_format(ab, "module=%s dev=%s op=%s",
+			 dm_msg_prefix, dm_device_name(md), op);
+
+	if (!result && !strcmp("ctr", op))
+		audit_log_format(ab, " error_msg='%s'", ti->error);
+	audit_log_format(ab, " res=%d", result);
+	audit_log_end(ab);
+}
+EXPORT_SYMBOL_GPL(dm_audit_log_target);
diff --git a/drivers/md/dm-audit.h b/drivers/md/dm-audit.h
new file mode 100644
index 000000000000..b9e31b9e3682
--- /dev/null
+++ b/drivers/md/dm-audit.h
@@ -0,0 +1,33 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Creating audit records for mapped devices.
+ *
+ * Copyright (C) 2021 Fraunhofer AISEC. All rights reserved.
+ *
+ * Authors: Michael Weiß <michael.weiss@aisec.fraunhofer.de>
+ */
+
+#ifndef DM_AUDIT_H
+#define DM_AUDIT_H
+
+#include <linux/device-mapper.h>
+
+#ifdef CONFIG_DM_AUDIT
+void dm_audit_log_bio(const char *dm_msg_prefix, const char *op,
+		      struct bio *bio, sector_t sector, int result);
+void dm_audit_log_target(const char *dm_msg_prefix, const char *op,
+			 struct dm_target *ti, int result);
+#else
+static inline void dm_audit_log_bio(const char *dm_msg_prefix, const char *op,
+				    struct bio *bio, sector_t sector,
+				    int result)
+{
+}
+static inline void dm_audit_log_target(const char *dm_msg_prefix,
+				       const char *op, struct dm_target *ti,
+				       int result)
+{
+}
+#endif
+
+#endif
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index daa481729e9b..aebfeee1c5b1 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -118,6 +118,7 @@
 #define AUDIT_TIME_ADJNTPVAL	1333	/* NTP value adjustment */
 #define AUDIT_BPF		1334	/* BPF subsystem */
 #define AUDIT_EVENT_LISTENER	1335	/* Task joined multicast read socket */
+#define AUDIT_DM		1336	/* Device Mapper events */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
-- 
2.20.1

