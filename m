From: Helge Deller <deller@gmx.de>
Subject: [PATCH 06/14] md/bcache: Use %pS printk format for direct addresses
Date: Wed,  6 Sep 2017 22:27:53 +0200
Message-ID: <1504729681-3504-7-git-send-email-deller@gmx.de>
References: <1504729681-3504-1-git-send-email-deller@gmx.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1504729681-3504-1-git-send-email-deller@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Petr Mladek <pmladek@suse.com>, Andrew Morton <akpm@linux-foundation.org>, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Use the %pS instead of the %pF printk format specifier for printing symbols
from direct addresses. This is needed for the ia64, ppc64 and parisc64
architectures.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: linux-bcache@vger.kernel.org
Cc: linux-raid@vger.kernel.org
---
 drivers/md/bcache/closure.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bcache/closure.c b/drivers/md/bcache/closure.c
index 864e673..0b0c9bc 100644
--- a/drivers/md/bcache/closure.c
+++ b/drivers/md/bcache/closure.c
@@ -175,7 +175,7 @@ static int debug_seq_show(struct seq_file *f, void *data)
 	list_for_each_entry(cl, &closure_list, all) {
 		int r = atomic_read(&cl->remaining);
 
-		seq_printf(f, "%p: %pF -> %pf p %p r %i ",
+		seq_printf(f, "%p: %pS -> %pf p %p r %i ",
 			   cl, (void *) cl->ip, cl->fn, cl->parent,
 			   r & CLOSURE_REMAINING_MASK);
 
@@ -187,7 +187,7 @@ static int debug_seq_show(struct seq_file *f, void *data)
 			   r & CLOSURE_SLEEPING	? "Sl" : "");
 
 		if (r & CLOSURE_WAITING)
-			seq_printf(f, " W %pF\n",
+			seq_printf(f, " W %pS\n",
 				   (void *) cl->waiting_on);
 
 		seq_printf(f, "\n");
-- 
2.1.0
