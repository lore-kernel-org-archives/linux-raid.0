From: Zhilong Liu <zlliu@suse.com>
Subject: [PATCH v2 1/4] test/00readonly: Add unit case for testing readonly/readwrite
Date: Wed, 19 Jul 2017 19:37:23 +0800
Message-ID: <1500464243-6811-1-git-send-email-zlliu@suse.com>
References: <1500462675-6463-2-git-send-email-zlliu@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1500462675-6463-2-git-send-email-zlliu@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org, Zhilong Liu <zlliu@suse.com>
List-Id: linux-raid.ids

This is a test case for testing --readonly and
--readwrite feature, it covers common metadata
versions and raid levels.

Signed-off-by: Zhilong Liu <zlliu@suse.com>
---

Changing from v1:
improve checking sysfs configure.

 tests/00readonly | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)
 create mode 100644 tests/00readonly

diff --git a/tests/00readonly b/tests/00readonly
new file mode 100644
index 0000000..28b0fa1
--- /dev/null
+++ b/tests/00readonly
@@ -0,0 +1,22 @@
+#!/bin/bash
+
+for metadata in 0.9 1.0 1.1 1.2
+do
+	for level in linear raid0 raid1 raid4 raid5 raid6 raid10
+	do
+		mdadm -CR $md0 -l $level -n 4 --metadata=$metadata \
+			$dev1 $dev2 $dev3 $dev4 --assume-clean
+		check nosync
+		check $level
+		mdadm -ro $md0
+		check readonly
+		state=$(cat /sys/block/md0/md/array_state)
+		[ "$state" == "readonly" ] ||
+			die "array_state should be 'readonly', but is $state"
+		mdadm -w $md0
+		check $level
+		mdadm -S $md0
+	done
+done
+
+exit 0
-- 
2.6.6

