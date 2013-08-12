From: Shaohua Li <shli@kernel.org>
Subject: [patch 2/3] wait: add wait_event_cmd()
Date: Mon, 12 Aug 2013 10:24:36 +0800
Message-ID: <20130812022539.777546644@kernel.org>
References: <20130812022434.507702228@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=wait-add-new-function.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, djbw@fb.com
List-Id: linux-raid.ids

Add a new API wait_event_cmd(). It's a variant of wait_even() with two commands
executed. One is executed before sleep, another after sleep.

Signed-off-by: Shaohua Li <shli@fusionio.com>
---
 include/linux/wait.h |   36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

Index: linux/include/linux/wait.h
===================================================================
--- linux.orig/include/linux/wait.h	2013-08-12 09:13:45.972639924 +0800
+++ linux/include/linux/wait.h	2013-08-12 10:02:20.031998428 +0800
@@ -253,6 +253,42 @@ do {									\
 	__ret;								\
 })
 
+#define __wait_event_cmd(wq, condition, cmd1, cmd2)			\
+do {									\
+	DEFINE_WAIT(__wait);						\
+									\
+	for (;;) {							\
+		prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		cmd1;							\
+		schedule();						\
+		cmd2;							\
+	}								\
+	finish_wait(&wq, &__wait);					\
+} while (0)
+
+/**
+ * wait_event_cmd - sleep until a condition gets true
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * cmd1: the command will be executed before sleep
+ * cmd2: the command will be executed after sleep
+ *
+ * The process is put to sleep (TASK_UNINTERRUPTIBLE) until the
+ * @condition evaluates to true. The @condition is checked each time
+ * the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ */
+#define wait_event_cmd(wq, condition, cmd1, cmd2)			\
+do {									\
+	if (condition)							\
+		break;							\
+	__wait_event_cmd(wq, condition, cmd1, cmd2);			\
+} while (0)
+
 #define __wait_event_interruptible(wq, condition, ret)			\
 do {									\
 	DEFINE_WAIT(__wait);						\

