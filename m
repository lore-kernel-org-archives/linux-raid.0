From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 5 of 12] Print correct pid for newly created  bitmap-writeback-daemon.
Date: Wed, 23 Mar 2005 16:47:11 +1100
Message-ID: <E1DDyhz-0004Ge-6R@notabene.cse.unsw.edu.au>
References: <20050323164208.16240.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


The debugging message printed the wrong pid, which didn't help
remove bugs....

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-03-22 17:19:19.000000000 +1100
+++ ./drivers/md/bitmap.c	2005-03-22 17:20:08.000000000 +1100
@@ -1107,7 +1107,7 @@ static int bitmap_start_daemon(struct bi
 	md_wakeup_thread(daemon); /* start it running */
 
 	PRINTK("%s: %s daemon (pid %d) started...\n",
-		bmname(bitmap), name, bitmap->daemon->tsk->pid);
+		bmname(bitmap), name, daemon->tsk->pid);
 out_unlock:
 	spin_unlock_irqrestore(&bitmap->lock, flags);
 	return 0;
