From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md ] XOR template selection redo
Date: Thu, 24 Jun 2004 14:58:34 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1BdMJm-0002Uv-Mt@notabene.cse.unsw.edu.au>
References: <20040624145809.9583.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


From: Josh Litherland <josh@emperorlinux.com>

The XOR routine selection process is often confusing as it
often doesn't choose the routine that measures the fastest,
as sometime one routine is known to have better cache
performance.

This patch avoids the comparison when there is a known best choice,
and makes the report more meaningful.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/xor.c |   39 +++++++++++++++++++++++++--------------
 1 files changed, 25 insertions(+), 14 deletions(-)

diff ./drivers/md/xor.c~current~ ./drivers/md/xor.c
--- ./drivers/md/xor.c~current~	2004-06-24 14:53:51.000000000 +1000
+++ ./drivers/md/xor.c	2004-06-24 14:53:51.000000000 +1000
@@ -108,29 +108,40 @@ calibrate_xor_block(void)
 	}
 	b2 = b1 + 2*PAGE_SIZE + BENCH_SIZE;
 
-	printk(KERN_INFO "raid5: measuring checksumming speed\n");
+	/*
+	 * If this arch/cpu has a short-circuited selection, don't loop through all
+	 * the possible functions, just test the best one
+	 */
 
+	fastest = NULL;
+
+#ifdef XOR_SELECT_TEMPLATE
+		fastest = XOR_SELECT_TEMPLATE(fastest);
+#endif
+	
 #define xor_speed(templ)	do_xor_speed((templ), b1, b2)
 
-	XOR_TRY_TEMPLATES;
+	if (fastest) {
+		printk(KERN_INFO "raid5: automatically using best checksumming function: %s\n",
+			fastest->name);
+		xor_speed(fastest);
+	} else {
+		printk(KERN_INFO "raid5: measuring checksumming speed\n");
+		XOR_TRY_TEMPLATES;
+		fastest = template_list;
+		for (f = fastest; f; f = f->next) 
+			if (f->speed > fastest->speed)
+				fastest = f;
+	}
+
+	printk("raid5: using function: %s (%d.%03d MB/sec)\n",
+	       fastest->name, fastest->speed / 1000, fastest->speed % 1000);
 
 #undef xor_speed
 
 	free_pages((unsigned long)b1, 2);
 
-	fastest = template_list;
-	for (f = fastest; f; f = f->next)
-		if (f->speed > fastest->speed)
-			fastest = f;
-
-#ifdef XOR_SELECT_TEMPLATE
-	fastest = XOR_SELECT_TEMPLATE(fastest);
-#endif
-
 	active_template = fastest;
-	printk("raid5: using function: %s (%d.%03d MB/sec)\n",
-	       fastest->name, fastest->speed / 1000, fastest->speed % 1000);
-
 	return 0;
 }
 
