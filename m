From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 14/15] percpu-refcount: support synchronous switch to
 atomic mode.
Date: Wed, 15 Mar 2017 14:05:14 +1100
Message-ID: <148954711451.18641.16530335727683897485.stgit@noble>
References: <148954692173.18641.1294690639716682540.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148954692173.18641.1294690639716682540.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

percpu_ref_switch_to_atomic_sync() schedules the switch
to atomic mode, then waits for it to complete.

Also export percpu_ref_switch_to_* so they can be used from modules.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 include/linux/percpu-refcount.h |    1 +
 lib/percpu-refcount.c           |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/percpu-refcount.h b/include/linux/percpu-refcount.h
index 3a481a49546e..c13dceb87b60 100644
--- a/include/linux/percpu-refcount.h
+++ b/include/linux/percpu-refcount.h
@@ -99,6 +99,7 @@ int __must_check percpu_ref_init(struct percpu_ref *ref,
 void percpu_ref_exit(struct percpu_ref *ref);
 void percpu_ref_switch_to_atomic(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_switch);
+void percpu_ref_switch_to_atomic_sync(struct percpu_ref *ref);
 void percpu_ref_switch_to_percpu(struct percpu_ref *ref);
 void percpu_ref_kill_and_confirm(struct percpu_ref *ref,
 				 percpu_ref_func_t *confirm_kill);
diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 9ac959ef4cae..d133ed43a375 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -260,6 +260,23 @@ void percpu_ref_switch_to_atomic(struct percpu_ref *ref,
 
 	spin_unlock_irqrestore(&percpu_ref_switch_lock, flags);
 }
+EXPORT_SYMBOL_GPL(percpu_ref_switch_to_atomic);
+
+/**
+ * percpu_ref_switch_to_atomic_sync - switch a percpu_ref to atomic mode
+ * @ref: percpu_ref to switch to atomic mode
+ *
+ * Schedule switching the ref to atomic mode, and wait for the
+ * switch to complete.  Caller must ensure that no other thread
+ * will switch back to percpu mode.
+ *
+ */
+void percpu_ref_switch_to_atomic_sync(struct percpu_ref *ref)
+{
+	percpu_ref_switch_to_atomic(ref, NULL);
+	wait_event(percpu_ref_switch_waitq, !ref->confirm_switch);
+}
+EXPORT_SYMBOL_GPL(percpu_ref_switch_to_atomic_sync);
 
 /**
  * percpu_ref_switch_to_percpu - switch a percpu_ref to percpu mode
@@ -290,6 +307,7 @@ void percpu_ref_switch_to_percpu(struct percpu_ref *ref)
 
 	spin_unlock_irqrestore(&percpu_ref_switch_lock, flags);
 }
+EXPORT_SYMBOL_GPL(percpu_ref_switch_to_percpu);
 
 /**
  * percpu_ref_kill_and_confirm - drop the initial ref and schedule confirmation


