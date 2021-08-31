Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A104C432BE
	for <linux-raid@archiver.kernel.org>; Tue, 31 Aug 2021 19:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59AE861075
	for <linux-raid@archiver.kernel.org>; Tue, 31 Aug 2021 19:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240551AbhHaTUp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 Aug 2021 15:20:45 -0400
Received: from mout.kundenserver.de ([217.72.192.75]:36215 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbhHaTUk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 Aug 2021 15:20:40 -0400
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1Mzhax-1nGZL53yWv-00vf58; Tue, 31 Aug 2021 21:19:35 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc:     =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        Song Liu <song@kernel.org>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v3 1/3] dm: introduce audit event module for device mapper
Date:   Tue, 31 Aug 2021 21:18:38 +0200
Message-Id: <20210831191845.7928-2-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210831191845.7928-1-michael.weiss@aisec.fraunhofer.de>
References: <20210831191845.7928-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:klw6jh8e9RmfyO/IREJGk8V5HZCuqw0K/fuFNMASZKQezy6lOyl
 qjSSCfb2cpQjibxbpWQwqMLNcHDfgZUHmeJ8uyP2+KG9SBfVcPube3wLiN+6AcdVmiFR27/
 iu2+1yFo9nF1g/1Y7OrMAsaQ5UZQoM4ZznvnyoZKHIB01jeVfspdBsJX2G7zlQqjsG0mKaY
 DbPWGeZLpQ/LpbSmM5BpQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ov+COH5sri4=:FLZuO5gl43eVQeCdGlqobZ
 yc36XcLPaTwPVcw6xaMy6ZsgyNZ8DhviYokRYtZm6c6to8UvVm8lw3lGCFoMgTxkD0xSPxreJ
 HlIZg69JO/MxVoKfIzaURs45C2wcNtHl0bM9G3oGMbPKzPR1VzjTioAP0YVJSQtzaqSvYygbD
 qmhU/ThXwFrQQpAeys5zTaZcSpIAbQvykPguniMi/ubCHvASHFfcAYOqYpwHM12BwgnEc/8dj
 seRguUTgeRW2/kTTSiJ9SM5ufW7kkIWLMSrTFWDGwAUXHbHBgwchefaNYwnvmXALfqea+ZF+d
 TWqMRzqJtrImVt3Cc2fsQCRpd4OsC/PMR8l2De6H0k9MxSFzl4usSsBMCIfEI+aBOtEuBYBd6
 HfQ9EOEhFNdG4f73d4IszE4zj86Ml9nHcwTpRzSKI3YaMnh4gLMLTexraWB8M2ghroPyILgxb
 OrRjuCtZRHJaGjqzNZ0hwEgyzkg/1Bx6lo9ZGiUHucHVjxC23XNT+7HRlTOdhQsNiewQO6g5s
 K0pgUuP+IM54pTnZGAmBmWZTO3Yv1goS/1zUOowozprYW91n5v4Jq2bjjceb9KWyyg8R3f2kv
 eZyBbCi7zgcH/unWUJPv3McFJxDQpPF9COlxqgkd60F4mtWtbib8U9jwTCNZQntJ2tCZSHgQK
 ZEh/X7Go3FRU3EURU+Rixo76WKz8ho3nVe0/25U0yBHFzN/Gl7DpaCfBJNLg8lhZyL0wh/fbX
 X7Q7AqXIPMKi6v2rKiTOSJ0QJ0TyLjWt5vd1yCaiJC3EFOb452uz2ADTmLw=
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

To be able to send auditing events to user space, we introduce a
generic dm-audit module. It provides helper functions to emit audit
events through the kernel audit subsystem. We claim the
AUDIT_DM_CTRL type=1336 and AUDIT_DM_EVENT type=1337 out of the
audit event messages range in the corresponding userspace api in
'include/uapi/linux/audit.h' for those events.

AUDIT_DM_CTRL is used to provide information about creation and
destruction of device mapper targets which are triggered by user space
admin control actions.
AUDIT_DM_EVENT is used to provide information about actual errors
during operation of the mapped device, showing e.g. integrity
violations in audit log.

Following commits to device mapper targets actually will make use of
this to emit those events in relevant cases.

The audit logs look like this if executing the following simple test:

 # dd if=/dev/zero of=test.img bs=1M count=1024
 # losetup -f test.img
 # integritysetup -vD format --integrity sha256 -t 32 /dev/loop0
 # integritysetup open -D /dev/loop0 --integrity sha256 integritytest
 # integritysetup status integritytest
 # integritysetup close integritytest
 # integritysetup open -D /dev/loop0 --integrity sha256 integritytest
 # integritysetup status integritytest
 # dd if=/dev/urandom of=/dev/loop0 bs=512 count=1 seek=100000
 # dd if=/dev/mapper/integritytest of=/dev/null

-------------------------
audit.log from auditd

type=UNKNOWN[1336] msg=audit(1630425039.363:184): module=integrity
op=ctr ppid=3807 pid=3819 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup"
exe="/sbin/integritysetup" subj==unconfined dev=254:3
error_msg='success' res=1
type=UNKNOWN[1336] msg=audit(1630425039.471:185): module=integrity
op=dtr ppid=3807 pid=3819 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup"
exe="/sbin/integritysetup" subj==unconfined dev=254:3
error_msg='success' res=1
type=UNKNOWN[1336] msg=audit(1630425039.611:186): module=integrity
op=ctr ppid=3807 pid=3819 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup"
exe="/sbin/integritysetup" subj==unconfined dev=254:3
error_msg='success' res=1
type=UNKNOWN[1336] msg=audit(1630425054.475:187): module=integrity
op=dtr ppid=3807 pid=3819 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup"
exe="/sbin/integritysetup" subj==unconfined dev=254:3
error_msg='success' res=1

type=UNKNOWN[1336] msg=audit(1630425073.171:191): module=integrity
op=ctr ppid=3807 pid=3883 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup"
exe="/sbin/integritysetup" subj==unconfined dev=254:3
error_msg='success' res=1

type=UNKNOWN[1336] msg=audit(1630425087.239:192): module=integrity
op=dtr ppid=3807 pid=3902 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup"
exe="/sbin/integritysetup" subj==unconfined dev=254:3
error_msg='success' res=1

type=UNKNOWN[1336] msg=audit(1630425093.755:193): module=integrity
op=ctr ppid=3807 pid=3906 auid=1000 uid=0 gid=0 euid=0 suid=0 fsuid=0
egid=0 sgid=0 fsgid=0 tty=pts2 ses=3 comm="integritysetup"
exe="/sbin/integritysetup" subj==unconfined dev=254:3
error_msg='success' res=1

type=UNKNOWN[1337] msg=audit(1630425112.119:194): module=integrity
op=integrity-checksum dev=254:3 sector 77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:195): module=integrity
op=integrity-checksum dev=254:3 sector 77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:196): module=integrity
op=integrity-checksum dev=254:3 sector 77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:197): module=integrity
op=integrity-checksum dev=254:3 sector 77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:198): module=integrity
op=integrity-checksum dev=254:3 sector 77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:199): module=integrity
op=integrity-checksum dev=254:3 sector 77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:200): module=integrity
op=integrity-checksum dev=254:3 sector 77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:201): module=integrity
op=integrity-checksum dev=254:3 sector 77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:202): module=integrity
op=integrity-checksum dev=254:3 sector 77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:203): module=integrity
op=integrity-checksum dev=254:3 sector 77480 res=0

Signed-off-by: Michael Weiß <michael.weiss@aisec.fraunhofer.de>
---
 drivers/md/Kconfig         | 10 +++++
 drivers/md/Makefile        |  4 ++
 drivers/md/dm-audit.c      | 79 ++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-audit.h      | 62 ++++++++++++++++++++++++++++++
 include/uapi/linux/audit.h |  2 +
 5 files changed, 157 insertions(+)
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
index a74aaf8b1445..2f83d649500d 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -103,3 +103,7 @@ endif
 ifeq ($(CONFIG_DM_VERITY_VERIFY_ROOTHASH_SIG),y)
 dm-verity-objs			+= dm-verity-verify-sig.o
 endif
+
+ifeq ($(CONFIG_DM_AUDIT),y)
+dm-mod-objs			+= dm-audit.o
+endif
diff --git a/drivers/md/dm-audit.c b/drivers/md/dm-audit.c
new file mode 100644
index 000000000000..761ecfdcd49a
--- /dev/null
+++ b/drivers/md/dm-audit.c
@@ -0,0 +1,79 @@
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
+static struct audit_buffer *dm_audit_log_start(int audit_type,
+					       const char *dm_msg_prefix,
+					       const char *op)
+{
+	struct audit_buffer *ab;
+
+	if (audit_enabled == AUDIT_OFF)
+		return NULL;
+
+	ab = audit_log_start(audit_context(), GFP_KERNEL, audit_type);
+	if (unlikely(!ab))
+		return NULL;
+
+	audit_log_format(ab, "module=%s op=%s", dm_msg_prefix, op);
+	return ab;
+}
+
+void dm_audit_log_ti(int audit_type, const char *dm_msg_prefix, const char *op,
+		     struct dm_target *ti, int result)
+{
+	struct audit_buffer *ab;
+	struct mapped_device *md = dm_table_get_md(ti->table);
+	int dev_major = dm_disk(md)->major;
+	int dev_minor = dm_disk(md)->first_minor;
+
+	ab = dm_audit_log_start(audit_type, dm_msg_prefix, op);
+	if (unlikely(!ab))
+		return;
+
+	switch (audit_type) {
+	case AUDIT_DM_CTRL:
+		audit_log_task_info(ab);
+		audit_log_format(ab, " dev=%d:%d error_msg='%s'", dev_major,
+				 dev_minor, !result ? ti->error : "success");
+		break;
+	case AUDIT_DM_EVENT:
+		audit_log_format(ab, " dev=%d:%d sector=?", dev_major,
+				 dev_minor);
+		break;
+	}
+	audit_log_format(ab, " res=%d", result);
+	audit_log_end(ab);
+}
+EXPORT_SYMBOL_GPL(dm_audit_log_ti);
+
+void dm_audit_log_bio(const char *dm_msg_prefix, const char *op,
+		      struct bio *bio, sector_t sector, int result)
+{
+	struct audit_buffer *ab;
+	int dev_major = MAJOR(bio->bi_bdev->bd_dev);
+	int dev_minor = MINOR(bio->bi_bdev->bd_dev);
+
+	ab = dm_audit_log_start(AUDIT_DM_EVENT, dm_msg_prefix, op);
+	if (unlikely(!ab))
+		return;
+
+	audit_log_format(ab, " dev=%d:%d sector %llu res=%d",
+			 dev_major, dev_minor, sector, result);
+	audit_log_end(ab);
+}
+EXPORT_SYMBOL_GPL(dm_audit_log_bio);
diff --git a/drivers/md/dm-audit.h b/drivers/md/dm-audit.h
new file mode 100644
index 000000000000..4e3fe8aab920
--- /dev/null
+++ b/drivers/md/dm-audit.h
@@ -0,0 +1,62 @@
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
+#include <linux/audit.h>
+
+#ifdef CONFIG_DM_AUDIT
+void dm_audit_log_bio(const char *dm_msg_prefix, const char *op,
+		      struct bio *bio, sector_t sector, int result);
+
+void dm_audit_log_ti(int audit_type, const char *dm_msg_prefix, const char *op,
+		     struct dm_target *ti, int result);
+
+static inline void dm_audit_log_ctr(const char *dm_msg_prefix,
+				    struct dm_target *ti, int result)
+{
+	dm_audit_log_ti(AUDIT_DM_CTRL, dm_msg_prefix, "ctr", ti, result);
+}
+
+static inline void dm_audit_log_dtr(const char *dm_msg_prefix,
+				    struct dm_target *ti, int result)
+{
+	dm_audit_log_ti(AUDIT_DM_CTRL, dm_msg_prefix, "dtr", ti, result);
+}
+
+static inline void dm_audit_log_target(const char *dm_msg_prefix, const char *op,
+				       struct dm_target *ti, int result)
+{
+	dm_audit_log_ti(AUDIT_DM_EVENT, dm_msg_prefix, op, ti, result);
+}
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
+static inline void dm_audit_log_ctr(const char *dm_msg_prefix,
+				    struct dm_target *ti, int result)
+{
+}
+
+static inline void dm_audit_log_dtr(const char *dm_msg_prefix,
+				    struct dm_target *ti, int result)
+{
+}
+#endif
+
+#endif
diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index daa481729e9b..6650ab6def2a 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -118,6 +118,8 @@
 #define AUDIT_TIME_ADJNTPVAL	1333	/* NTP value adjustment */
 #define AUDIT_BPF		1334	/* BPF subsystem */
 #define AUDIT_EVENT_LISTENER	1335	/* Task joined multicast read socket */
+#define AUDIT_DM_CTRL		1336	/* Device Mapper target control */
+#define AUDIT_DM_EVENT		1337	/* Device Mapper events */
 
 #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
-- 
2.20.1

