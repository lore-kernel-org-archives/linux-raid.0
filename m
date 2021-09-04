Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF7CDC433F5
	for <linux-raid@archiver.kernel.org>; Sat,  4 Sep 2021 10:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C369B61054
	for <linux-raid@archiver.kernel.org>; Sat,  4 Sep 2021 10:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235808AbhIDKBO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 4 Sep 2021 06:01:14 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:33375 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235527AbhIDKBK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 4 Sep 2021 06:01:10 -0400
Received: from weisslap.aisec.fraunhofer.de ([178.27.102.95]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1MQPVR-1mZKVm0Xib-00MKNG; Sat, 04 Sep 2021 11:59:55 +0200
From:   =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>
To:     Paul Moore <paul@paul-moore.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc:     =?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Song Liu <song@kernel.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-audit@redhat.com
Subject: [PATCH v4 1/3] dm: introduce audit event module for device mapper
Date:   Sat,  4 Sep 2021 11:59:28 +0200
Message-Id: <20210904095934.5033-2-michael.weiss@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de>
References: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:F7jaxNLYZmcHF31SeDO+/f2fM6Km0AGZZ2iZRrudUczWZW+SkYM
 RZb7OceToHw+2fUZRitGde1LH2HkEKoUmCu7+PMBTKs+bSx5Ezybz6c8/3MXK53+Oavx5dQ
 S6t+OPa2RU7SyEMuVip10b5CwlUZeU7XGVblBW0U2plg3stgW33kIczyUpHzefS9hPs1ZK6
 xZp8RYrhh4uCWo8+csVUw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:OxiizS/gnH0=:CaGTwi+Ugena1QurnT762+
 QqmfZdY8PzDAjAMDec35CKLQI05fYiMvRp53xLD7kPpzuUDLfR3VFh0hP4bVlgC5EsfXCtGIU
 S87OSj11tV5kUZm1kQNcr4WNGtX6+T25JDvvZSCuQkZ2tSxdChQ8luWvkiCt8R/clMQpxMn+j
 2HN0s2C53zYq4gim3qK7U24KfNtIXB82X0v4PxADWWY9zcR5PWSMzbqRi4gK3dFaeLKdDG0bv
 LJuGnWln0gNpw5t6c/7G8k6lj/YSnHXAWgpYYSBZyALPRostrjbBgJXLLqDRKYsr6JNp1G9UC
 RbtWubJt17nKfX7gNSk1anjylaGJxQP5LXa6Z//PGehue68cK+crn43zP7wAmDwXXeMP5EGKV
 XIyQpYV/2AscZyweUeLl1p9NK7I/B48BROgSW3LwziOchsB5V4dC8tysW4/T6O2YISKwz50Nw
 AHR1ET2rpyYJh2Pqm515IUyeIVYMtfn0XCY/ts9AWB41oNbnB3qFx65Vu/J5MWXcbjAJRkxLY
 pP74ILtG501tlJNbgwXrOxC1cWfMJlLjWo5kWUn9LcKpVH9pOEM5o2g88jhQJND9eBRkp0MzD
 kHPoIgwnJCl3vOdCt5GiJP45gFnn7OCw46jkeEaxACYbu4GsEafTCEVEWCszreFPiEr6oQU08
 ajEP/WWkiLX4s0fQa+aLD9I2VL5WdYik4jpIewWq7pAcVfGf2JSr3SSvoFnlwX+LZpXAAlMS/
 ge4lTc98AsqYjGpZ3oNn2DIat383MeQ7tRou/z5Ok8//OV9f7iYdiyWluFo=
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
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:195): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:196): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:197): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:198): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:199): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:200): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:201): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:202): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0
type=UNKNOWN[1337] msg=audit(1630425112.119:203): module=integrity
op=integrity-checksum dev=254:3 sector=77480 res=0

Signed-off-by: Michael Weiß <michael.weiss@aisec.fraunhofer.de>
---
 drivers/md/Kconfig         | 10 +++++
 drivers/md/Makefile        |  4 ++
 drivers/md/dm-audit.c      | 84 ++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-audit.h      | 66 ++++++++++++++++++++++++++++++
 include/uapi/linux/audit.h |  2 +
 5 files changed, 166 insertions(+)
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
index 000000000000..3049dfe67e50
--- /dev/null
+++ b/drivers/md/dm-audit.c
@@ -0,0 +1,84 @@
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
+	struct audit_buffer *ab = NULL;
+	struct mapped_device *md = dm_table_get_md(ti->table);
+	int dev_major = dm_disk(md)->major;
+	int dev_minor = dm_disk(md)->first_minor;
+
+	switch (audit_type) {
+	case AUDIT_DM_CTRL:
+		ab = dm_audit_log_start(audit_type, dm_msg_prefix, op);
+		if (unlikely(!ab))
+			return;
+		audit_log_task_info(ab);
+		audit_log_format(ab, " dev=%d:%d error_msg='%s'", dev_major,
+				 dev_minor, !result ? ti->error : "success");
+		break;
+	case AUDIT_DM_EVENT:
+		ab = dm_audit_log_start(audit_type, dm_msg_prefix, op);
+		if (unlikely(!ab))
+			return;
+		audit_log_format(ab, " dev=%d:%d sector=?", dev_major,
+				 dev_minor);
+		break;
+	default: /* unintended use */
+		return;
+	}
+
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
+	audit_log_format(ab, " dev=%d:%d sector=%llu res=%d",
+			 dev_major, dev_minor, sector, result);
+	audit_log_end(ab);
+}
+EXPORT_SYMBOL_GPL(dm_audit_log_bio);
diff --git a/drivers/md/dm-audit.h b/drivers/md/dm-audit.h
new file mode 100644
index 000000000000..2385f2b659be
--- /dev/null
+++ b/drivers/md/dm-audit.h
@@ -0,0 +1,66 @@
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
+/*
+ * dm_audit_log_ti() is not intended to be used directly in dm modules,
+ * the wrapper functions below should be called by dm modules instead.
+ */
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

