From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH 1/3 v2] wait: introduce wait_event_exclusive_cmd
Date: Wed, 29 Apr 2015 10:48:53 +0800
Message-ID: <1430275735-20290-1-git-send-email-yuanhan.liu@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-raid.ids

It's just a variant of wait_event_cmd(), with exclusive flag being set.

For cases like RAID5, which puts many processes to sleep until 1/4
resources are free, a wake_up wakes up all processes to run, but
there is one process being able to get the resource as it's protected
by a spin lock. That ends up introducing heavy lock contentions, and
hurts performance badly.

Here introduce wait_event_exclusive_cmd to relieve the lock contention
naturally by letting wake_up just wake up one process.

Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
v2: its assumed that wait*() and __wait*() have the same arguments - peterz

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 include/linux/wait.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index 2db8334..db78c72 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -358,6 +358,19 @@ do {									\
 	__ret;								\
 })
 
+#define __wait_event_exclusive_cmd(wq, condition, cmd1, cmd2)		\
+	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 1, 0,	\
+			    cmd1; schedule(); cmd2)
+/*
+ * Just like wait_event_cmd(), except it sets exclusive flag
+ */
+#define wait_event_exclusive_cmd(wq, condition, cmd1, cmd2)		\
+do {									\
+	if (condition)							\
+		break;							\
+	__wait_event_exclusive_cmd(wq, condition, cmd1, cmd2);		\
+} while (0)
+
 #define __wait_event_cmd(wq, condition, cmd1, cmd2)			\
 	(void)___wait_event(wq, condition, TASK_UNINTERRUPTIBLE, 0, 0,	\
 			    cmd1; schedule(); cmd2)
-- 
1.9.0
