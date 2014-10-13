From: Anton Blanchard <anton@samba.org>
Subject: [PATCH] lib/raid6: Add log level to printks
Date: Mon, 13 Oct 2014 23:03:16 +1100
Message-ID: <20141013230316.1cbe1b7e@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: b/lib/raid6/algos.c
===================================================================
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -121,9 +121,9 @@ static inline const struct raid6_recov_c
 		raid6_2data_recov = best->data2;
 		raid6_datap_recov = best->datap;
 
-		printk("raid6: using %s recovery algorithm\n", best->name);
+		pr_info("raid6: using %s recovery algorithm\n", best->name);
 	} else
-		printk("raid6: Yikes! No recovery algorithm found!\n");
+		pr_err("raid6: Yikes! No recovery algorithm found!\n");
 
 	return best;
 }
@@ -157,18 +157,18 @@ static inline const struct raid6_calls *
 				bestperf = perf;
 				best = *algo;
 			}
-			printk("raid6: %-8s %5ld MB/s\n", (*algo)->name,
+			pr_info("raid6: %-8s %5ld MB/s\n", (*algo)->name,
 			       (perf*HZ) >> (20-16+RAID6_TIME_JIFFIES_LG2));
 		}
 	}
 
 	if (best) {
-		printk("raid6: using algorithm %s (%ld MB/s)\n",
+		pr_info("raid6: using algorithm %s (%ld MB/s)\n",
 		       best->name,
 		       (bestperf*HZ) >> (20-16+RAID6_TIME_JIFFIES_LG2));
 		raid6_call = *best;
 	} else
-		printk("raid6: Yikes!  No algorithm found!\n");
+		pr_err("raid6: Yikes!  No algorithm found!\n");
 
 	return best;
 }
@@ -194,7 +194,7 @@ int __init raid6_select_algo(void)
 	syndromes = (void *) __get_free_pages(GFP_KERNEL, 1);
 
 	if (!syndromes) {
-		printk("raid6: Yikes!  No memory available.\n");
+		pr_err("raid6: Yikes!  No memory available.\n");
 		return -ENOMEM;
 	}
 
