From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 001 of 2] Create a MODULE_ALIAS for md corresponding to it's block major number.
Date: Fri, 26 Aug 2005 17:25:19 +1000
Message-ID: <E1E8YaV-0004FM-Mf@notabene.cse.unsw.edu.au>
References: <20050826172148.16280.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I just discoverred this is needed for module auto-loading.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    1 +
 1 files changed, 1 insertion(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-08-26 17:00:40.000000000 +1000
+++ ./drivers/md/md.c	2005-08-26 17:01:48.000000000 +1000
@@ -4102,3 +4102,4 @@ EXPORT_SYMBOL(md_print_devices);
 EXPORT_SYMBOL(md_check_recovery);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("md");
+MODULE_ALIAS_BLOCKDEV_MAJOR(MD_MAJOR);
