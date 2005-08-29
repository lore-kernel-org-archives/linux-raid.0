From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 006 of 7] Ensure bitmap_writeback_daemon handles shutdown properly.
Date: Mon, 29 Aug 2005 17:33:39 +1000
Message-ID: <E1E9e9D-0003Wr-Ih@notabene.cse.unsw.edu.au>
References: <20050829172936.12848.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


mddev->bitmap gets clearred before the writeback daemon is stopped.
So the write_back daemon needs to be careful not to dereference
the 'bitmap' if it is NULL.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/bitmap.c |    3 +++
 1 file changed, 3 insertions(+)

diff ./drivers/md/bitmap.c~current~ ./drivers/md/bitmap.c
--- ./drivers/md/bitmap.c~current~	2005-08-29 16:32:20.000000000 +1000
+++ ./drivers/md/bitmap.c	2005-08-29 16:46:50.000000000 +1000
@@ -1156,6 +1156,9 @@ static void bitmap_writeback_daemon(mdde
 		err = -EINTR;
 		goto out;
 	}
+	if (bitmap == NULL)
+		/* about to be stopped. */
+		return;
 
 	PRINTK("%s: bitmap writeback daemon woke up...\n", bmname(bitmap));
 	/* wait on bitmap page writebacks */
