From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 7/8] md: raid5: Use irqsave variant of refcount_dec_and_lock()
Date: Wed,  9 May 2018 21:36:44 +0200
Message-ID: <20180509193645.830-8-bigeasy@linutronix.de>
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

The irqsave variant of refcount_dec_and_lock handles irqsave/restore when
taking/releasing the spin lock. With this variant the call of
local_irq_save is no longer required.

Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
[bigeasy: s@atomic_dec_and_lock@refcount_dec_and_lock@g ]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/md/raid5.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 57ea0ae8c7ff..28453264c3eb 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -409,16 +409,15 @@ void raid5_release_stripe(struct stripe_head *sh)
 		md_wakeup_thread(conf->mddev->thread);
 	return;
 slow_path:
-	local_irq_save(flags);
 	/* we are ok here if STRIPE_ON_RELEASE_LIST is set or not */
-	if (refcount_dec_and_lock(&sh->count, &conf->device_lock)) {
+	if (refcount_dec_and_lock_irqsave(&sh->count, &conf->device_lock, &flags)=
) {
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
2.17.0
