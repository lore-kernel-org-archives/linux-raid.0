From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 001 of 7] Remove a stray debugging printk.
Date: Tue, 02 Aug 2005 19:53:41 +1000
Message-ID: <E1DztSv-0004VL-1N@notabene.cse.unsw.edu.au>
References: <20050802193525.12307.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    1 -
 1 files changed, 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-08-02 15:22:11.000000000 +1000
+++ ./drivers/md/md.c	2005-08-02 15:22:11.000000000 +1000
@@ -3484,7 +3484,6 @@ static void md_do_sync(mddev_t *mddev)
 			goto skip;
 		}
 		ITERATE_MDDEV(mddev2,tmp) {
-			printk(".");
 			if (mddev2 == mddev)
 				continue;
 			if (mddev2->curr_resync && 
