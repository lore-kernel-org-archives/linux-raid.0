From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 6 of 12] Call bitmap_daemon_work regularly
Date: Wed, 23 Mar 2005 16:47:11 +1100
Message-ID: <E1DDyhz-0004Gi-8Y@notabene.cse.unsw.edu.au>
References: <20050323164208.16240.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


bitmap_daemon_work clears bits in the bitmap for blocks
that haven't been written to for a while.
It needs to be called regularly to make sure the bitmap
doesn't endup full of ones .... but it wasn't.

So call it from the increasingly-inaptly-named md_check_recovery

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-03-22 17:11:00.000000000 +1100
+++ ./drivers/md/md.c	2005-03-22 17:20:16.000000000 +1100
@@ -3682,7 +3682,8 @@ void md_check_recovery(mddev_t *mddev)
 	struct list_head *rtmp;
 
 
-	dprintk(KERN_INFO "md: recovery thread got woken up ...\n");
+	if (mddev->bitmap)
+		bitmap_daemon_work(mddev->bitmap);
 
 	if (mddev->ro)
 		return;
