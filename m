From: Amitoj Kaur Chawla <amitoj1606@gmail.com>
Subject: [PATCH] bcache: Use setup_timer and mod_timer
Date: Thu, 30 Jun 2016 17:15:20 +0530
Message-ID: <20160630114520.GA8025@amitoj-Inspiron-3542>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: kent.overstreet@gmail.com, shli@kernel.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
List-Id: linux-raid.ids

Convert a call to init_timer and accompanying intializations of
the timer's data and function fields to a call to setup_timer.

The Coccinelle semantic patch that fixes one part of this issue
is as follows:
@@
expression t,d,f,e1;
identifier x1;
statement S1;
@@

(
-t.data = d;
|
-t.function = f;
|
-init_timer(&t);
+setup_timer(&t,f,d);
|
-init_timer_on_stack(&t);
+setup_timer_on_stack(&t,f,d);
)
<... when != S1
t.x1 = e1;
...>

Also convert calls to add_timer and intialisation of timer's expire
field to a call to mod_timer which is more compact.

Signed-off-by: Amitoj Kaur Chawla <amitoj1606@gmail.com>
---
 drivers/md/bcache/stats.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/md/bcache/stats.c b/drivers/md/bcache/stats.c
index 0ca072c..094d6d6 100644
--- a/drivers/md/bcache/stats.c
+++ b/drivers/md/bcache/stats.c
@@ -233,9 +233,6 @@ void bch_cache_accounting_init(struct cache_accounting *acc,
 	kobject_init(&acc->day.kobj,		&bch_stats_ktype);
 
 	closure_init(&acc->cl, parent);
-	init_timer(&acc->timer);
-	acc->timer.expires	= jiffies + accounting_delay;
-	acc->timer.data		= (unsigned long) acc;
-	acc->timer.function	= scale_accounting;
-	add_timer(&acc->timer);
+	setup_timer(&acc->timer, scale_accounting, (unsigned long) acc);
+	mod_timer(&acc->timer, jiffies + accounting_delay);
 }
-- 
1.9.1
