From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 1/6] drivers/md/raid5: Use irqsave variant of atomic_dec_and_lock()
Date: Tue,  3 Jul 2018 22:01:36 +0200
Message-ID: <20180703200141.28415-2-bigeasy@linutronix.de>
References: <20180703200141.28415-1-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180703200141.28415-1-bigeasy@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: linux-raid.ids

From: Anna-Maria Gleixner <anna-maria@linutronix.de>

The irqsave variant of atomic_dec_and_lock handles irqsave/restore when
taking/releasing the spin lock. With this variant the call of
local_irq_save is no longer required.

Cc: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/md/raid5.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2031506a0ecd..e933bff9459e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -409,16 +409,15 @@ void raid5_release_stripe(struct stripe_head *sh)
 		md_wakeup_thread(conf->mddev->thread);
 	return;
 slow_path:
-	local_irq_save(flags);
 	/* we are ok here if STRIPE_ON_RELEASE_LIST is set or not */
-	if (atomic_dec_and_lock(&sh->count, &conf->device_lock)) {
+	if (atomic_dec_and_lock_irqsave(&sh->count, &conf->device_lock, flags)) {
 		INIT_LIST_HEAD(&list);
 		hash =3D sh->hash_lock_index;
 		do_release_stripe(conf, sh, &list);
 		spin_unlock(&conf->device_lock);
 		release_inactive_stripe_list(conf, &list, hash);
+		local_irq_restore(flags);
 	}
-	local_irq_restore(flags);
 }
=20
 static inline void remove_hash(struct stripe_head *sh)
--=20
2.18.0
