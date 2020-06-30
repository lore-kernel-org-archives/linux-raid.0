From: "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [PATCH v3 15/20] raid5: Use sequence counter with associated spinlock
Date: Tue, 30 Jun 2020 07:44:47 +0200
Message-ID: <20200630054452.3675847-16-a.darwish@linutronix.de>
References: <20200519214547.352050-1-a.darwish@linutronix.de>
 <20200630054452.3675847-1-a.darwish@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200630054452.3675847-1-a.darwish@linutronix.de>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@kernel.org>, "Sebastian A. Siewior" <bigeasy@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>, "Ahmed S. Darwish" <a.darwish@linutronix.de>, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A sequence counter write side critical section must be protected by some
form of locking to serialize writers. A plain seqcount_t does not
contain the information of which lock must be held when entering a write
side critical section.

Use the new seqcount_spinlock_t data type, which allows to associate a
spinlock with the sequence counter. This enables lockdep to verify that
the spinlock used for writer serialization is held when the write side
critical section is entered.

If lockdep is disabled this lock association is compiled out and has
neither storage size nor runtime overhead.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
---
 drivers/md/raid5.c | 2 +-
 drivers/md/raid5.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index ab8067f9ce8c..892aefe88fa7 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6935,7 +6935,7 @@ static struct r5conf *setup_conf(struct mddev *mddev)
 	} else
 		goto abort;
 	spin_lock_init(&conf->device_lock);
-	seqcount_init(&conf->gen_lock);
+	seqcount_spinlock_init(&conf->gen_lock, &conf->device_lock);
 	mutex_init(&conf->cache_size_mutex);
 	init_waitqueue_head(&conf->wait_for_quiescent);
 	init_waitqueue_head(&conf->wait_for_stripe);
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index f90e0704bed9..a2c9e9e9f5ac 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -589,7 +589,7 @@ struct r5conf {
 	int			prev_chunk_sectors;
 	int			prev_algo;
 	short			generation; /* increments with every reshape */
-	seqcount_t		gen_lock;	/* lock against generation changes */
+	seqcount_spinlock_t	gen_lock;	/* lock against generation changes */
 	unsigned long		reshape_checkpoint; /* Time we last updated
 						     * metadata */
 	long long		min_offset_diff; /* minimum difference between
-- 
2.20.1
