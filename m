From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 002 of 7] Make 'md' and alias for 'md-mod'
Date: Tue, 02 Aug 2005 19:53:41 +1000
Message-ID: <E1DztSv-0004VP-Fc@notabene.cse.unsw.edu.au>
References: <20050802193525.12307.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Until the bitmap code was added, 
   modprobe md
would load the md module.  But now the md module is called 'md-mod',
so we really need an alias for backwards comparability.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    1 +
 1 files changed, 1 insertion(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-08-02 15:22:11.000000000 +1000
+++ ./drivers/md/md.c	2005-08-02 15:22:22.000000000 +1000
@@ -4006,3 +4006,4 @@ EXPORT_SYMBOL(md_wakeup_thread);
 EXPORT_SYMBOL(md_print_devices);
 EXPORT_SYMBOL(md_check_recovery);
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("md");
