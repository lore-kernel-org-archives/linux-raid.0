From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 4/8] locking/refcount: implement refcount_dec_and_lock_irqsave()
Date: Wed,  9 May 2018 21:36:41 +0200
Message-ID: <20180509193645.830-5-bigeasy@linutronix.de>
References: <20180509193645.830-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180509193645.830-1-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Anna-Maria Gleixner <anna-maria@linutronix.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: linux-raid.ids

From: Anna-Maria Gleixner <anna-maria@linutronix.de>

There are in-tree users of refcount_dec_and_lock() which must acquire the
spin lock with interrupts disabled. To workaround the lack of an irqsave
variant of refcount_dec_and_lock() they use local_irq_save() at the call
site. This causes extra code and creates in some places unneeded long
interrupt disabled times. These places need also extra treatment for
PREEMPT_RT due to the disconnect of the irq disabling and the lock
function.

Implement the missing irqsave variant of the function.

Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
[bigeasy: s@atomic_dec_and_lock@refcount_dec_and_lock@g]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/refcount.h |  4 +++-
 lib/refcount.c           | 28 ++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index 4193c41e383a..a685da2c4522 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -98,5 +98,7 @@ extern __must_check bool refcount_dec_if_one(refcount_t *=
r);
 extern __must_check bool refcount_dec_not_one(refcount_t *r);
 extern __must_check bool refcount_dec_and_mutex_lock(refcount_t *r, struct=
 mutex *lock);
 extern __must_check bool refcount_dec_and_lock(refcount_t *r, spinlock_t *=
lock);
-
+extern __must_check bool refcount_dec_and_lock_irqsave(refcount_t *r,
+						       spinlock_t *lock,
+						       unsigned long *flags);
 #endif /* _LINUX_REFCOUNT_H */
diff --git a/lib/refcount.c b/lib/refcount.c
index 0eb48353abe3..d3b81cefce91 100644
--- a/lib/refcount.c
+++ b/lib/refcount.c
@@ -350,3 +350,31 @@ bool refcount_dec_and_lock(refcount_t *r, spinlock_t *=
lock)
 }
 EXPORT_SYMBOL(refcount_dec_and_lock);
=20
+/**
+ * refcount_dec_and_lock_irqsave - return holding spinlock with disabled
+ *                                 interrupts if able to decrement refcoun=
t to 0
+ * @r: the refcount
+ * @lock: the spinlock to be locked
+ * @flags: saved IRQ-flags if the is acquired
+ *
+ * Same as refcount_dec_and_lock() above except that the spinlock is acqui=
red
+ * with disabled interupts.
+ *
+ * Return: true and hold spinlock if able to decrement refcount to 0, false
+ *         otherwise
+ */
+bool refcount_dec_and_lock_irqsave(refcount_t *r, spinlock_t *lock,
+				   unsigned long *flags)
+{
+	if (refcount_dec_not_one(r))
+		return false;
+
+	spin_lock_irqsave(lock, *flags);
+	if (!refcount_dec_and_test(r)) {
+		spin_unlock_irqrestore(lock, *flags);
+		return false;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(refcount_dec_and_lock_irqsave);
--=20
2.17.0
