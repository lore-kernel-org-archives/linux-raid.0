From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 2/6] drivers/md/raid5: Do not disable irq on release_inactive_stripe_list() call
Date: Tue,  3 Jul 2018 22:01:37 +0200
Message-ID: <20180703200141.28415-3-bigeasy@linutronix.de>
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

There is no need to invoke release_inactive_stripe_list() with interrupts
disabled. All call sites, except raid5_release_stripe(), unlock
->device_lock and enable interrupts before invoking the function.

Make it consistent.

Cc: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/md/raid5.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e933bff9459e..ca1dd0cb04c5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -414,9 +414,8 @@ void raid5_release_stripe(struct stripe_head *sh)
 		INIT_LIST_HEAD(&list);
 		hash =3D sh->hash_lock_index;
 		do_release_stripe(conf, sh, &list);
-		spin_unlock(&conf->device_lock);
+		spin_unlock_irqrestore(&conf->device_lock, flags);
 		release_inactive_stripe_list(conf, &list, hash);
-		local_irq_restore(flags);
 	}
 }
=20
--=20
2.18.0
