Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D8BBC4338F
	for <linux-raid@archiver.kernel.org>; Thu, 12 Aug 2021 14:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EED4C6108C
	for <linux-raid@archiver.kernel.org>; Thu, 12 Aug 2021 14:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238220AbhHLO6w (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 Aug 2021 10:58:52 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:47435 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238208AbhHLO6t (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 12 Aug 2021 10:58:49 -0400
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1M3lgJ-1mET0X338V-000uGk; Thu, 12 Aug 2021 16:58:14 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     michael.weiss@aisec.fraunhofer.de
Cc:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH 1/3] dm: introduce audit event module for device mapper
Date:   Thu, 12 Aug 2021 16:57:42 +0200
Message-Id: <20210812145748.4460-2-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210812145748.4460-1-michael.weiss@aisec.fraunhofer.de>
References: <20210812145748.4460-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:VRlAlfDB5Lnf+BVBMonU0Eg2eot1RoGDcs0IiBT5nDnqj9aaHft
 dcSLO6WONK888uP9aJqK6Aqb7ZQiPNlpUJu7M7xc4+bfDDsm3kxMGF1syUIKvVExAOAS0zo
 nwfgdVRl4NvB4ox9dfl4dEhENW7JEr4Vv4lV6bu39wfwADLoMcUIPK0LFtBy2DC9O/Mppvk
 /3X0q9IUYsRk56eLtLtbA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:XEuBaLgKtlg=:6Y8ena4XNNNq+d6+jP0hUp
 cffg6GK1Y0O7eOPCiEFa7mtksC49kyfeSXaDonQfXfERuI7ZnVz4vKvCRslBk8iFV7vN2vk/v
 Zr2dcXjz4ChVoaYfepXI7NzeBMl2C+y4wJUPdGLnVWARX12Bw3DSD5wk2zRgoTuUPnPCo2iyL
 Wz+d7fAMxktL0LAlmwJOChUeD9U7kQsNhq1rGEySScxTbj8dhj4kOSZOV+/b3DD3j47lo3JWE
 hhkxxXJxlVFmdur8jPZDG8bjv0CvqaITNmnvIhg5A46Sv90ZXO5uU/k5st+cv1RmKJxmfaYMN
 UzGIvptGr+ihN7JQDELpiUWQIYgEugDWZCXGr8jEvhWzqHjQsyP2cg8nLjIT2KKd3DSzuMi9H
 wUWTPbTpysnb3hLwBGbrmZYqWzCIaQqlCSf3qLuKAB1m6rxACCyvW/jYHDeWu0S3pSHoqqV+b
 HK4tny9EuiQtBHgIzicubr4+ezBeF3YqZ6pQmaw5/eWDE+rVeMF7BE4LiZE/fKlB7hxH1v7fv
 ziWkUbgdIlufYxYxM3usmOJE0rwPD0dN7RfRRb+xOEA8JWo1qMuicTXzUnqVEOJE+Tbv9tQbH
 SMARpm/b+3uz7qwbAuW0lsMSWNVweZ8PpJVnuQrhme6r8pUZncsEf86MfXf2yd85z1RAtpwhG
 KnipjDWS5L52FN8afdiwnlfylRL7Q/LjvkAm/Bm1ucEllWTLoJ6Myd6AxLZvOwBaXhnA9XlCE
 fCEldGfffSrAEpXaBtSlWslxfa6+5JAR9N6jtlPCFtxnZvvL62uEw/Xk6rxmUsguA/2mOAQsH
 clpnh7w86cvlb+/xx2dZKGlB3POrX0LN9TAMpBL7QQ6CtfMnO8pzLdR61B/FkWkdzyS2P0y0+
 dC54/aicLcU5VocDVaYA==
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
 include/uapi/linux/audit.h |  2 ++
 5 files changed, 108 insertions(+)
 create mode 100644 drivers/md/dm-audit.c
 create mode 100644 drivers/md/dm-audit.h

diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
index 0602e82a9516..fd54c713a03e 100644
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
+	  Enables audit loging of several security relevant events in the
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
index 000000000000..9db4955d32e1
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
+				    int result);
+{
+}
+static inline void dm_audit_log_target(const char *dm_msg_prefix,
+				       const char *op, struct dm_target *ti,
+				       int result);
+{
+}
+#endif
+
+#endif
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index daa481729e9b..9d766fcbcf62 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -118,6 +118,7 @@
 #define AUDIT_TIME_ADJNTPVAL	1333	/* NTP value adjustment */
 #define AUDIT_BPF		1334	/* BPF subsystem */
 #define AUDIT_EVENT_LISTENER	1335	/* Task joined multicast read socket */
+#define AUDIT_DM		1336	/* Device Mapper events */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
@@ -140,6 +141,7 @@
 #define AUDIT_MAC_CALIPSO_ADD	1418	/* NetLabel: add CALIPSO DOI entry */
 #define AUDIT_MAC_CALIPSO_DEL	1419	/* NetLabel: del CALIPSO DOI entry */
 
+
 #define AUDIT_FIRST_KERN_ANOM_MSG   1700
 #define AUDIT_LAST_KERN_ANOM_MSG    1799
 #define AUDIT_ANOM_PROMISCUOUS      1700 /* Device changed promiscuous mode */
-- 
2.20.1

