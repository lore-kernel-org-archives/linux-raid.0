From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 3/5] kernel/user: Use irqsave variant of atomic_dec_and_lock()
Date: Fri,  4 May 2018 17:45:31 +0200
Message-ID: <20180504154533.8833-4-bigeasy@linutronix.de>
References: <20180504154533.8833-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180504154533.8833-1-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, linux-mm@kvack.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Anna-Maria Gleixner <anna-maria@linutronix.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: linux-raid.ids

From: Anna-Maria Gleixner <anna-maria@linutronix.de>

The irqsave variant of atomic_dec_and_lock handles irqsave/restore when
taking/releasing the spin lock. With this variant the call of
local_irq_save/restore is no longer required.

Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 kernel/user.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/user.c b/kernel/user.c
index 36288d840675..8959ad11d766 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -169,11 +169,8 @@ void free_uid(struct user_struct *up)
 	if (!up)
 		return;
=20
-	local_irq_save(flags);
-	if (atomic_dec_and_lock(&up->__count, &uidhash_lock))
+	if (atomic_dec_and_lock_irqsave(&up->__count, &uidhash_lock, flags))
 		free_user(up, flags);
-	else
-		local_irq_restore(flags);
 }
=20
 struct user_struct *alloc_uid(kuid_t uid)
--=20
2.17.0
