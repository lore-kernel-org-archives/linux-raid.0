From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 5/8] bdi: Use irqsave variant of refcount_dec_and_lock()
Date: Wed,  9 May 2018 21:36:42 +0200
Message-ID: <20180509193645.830-6-bigeasy@linutronix.de>
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
local_irq_save/restore is no longer required.

Signed-off-by: Anna-Maria Gleixner <anna-maria@linutronix.de>
[bigeasy: s@atomic_dec_and_lock@refcount_dec_and_lock@g ]
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 mm/backing-dev.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 7984a872073e..520aa092f7b2 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -485,11 +485,8 @@ void wb_congested_put(struct bdi_writeback_congested *=
congested)
 {
 	unsigned long flags;
=20
-	local_irq_save(flags);
-	if (!refcount_dec_and_lock(&congested->refcnt, &cgwb_lock)) {
-		local_irq_restore(flags);
+	if (!refcount_dec_and_lock_irqsave(&congested->refcnt, &cgwb_lock, &flags=
))
 		return;
-	}
=20
 	/* bdi might already have been destroyed leaving @congested unlinked */
 	if (congested->__bdi) {
--=20
2.17.0
