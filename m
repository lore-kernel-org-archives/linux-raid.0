From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 005 of 20] Fix typo in comment.
Date: Mon, 12 Dec 2005 14:14:01 +1100
Message-ID: <1051212031401.4980@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-12-12 10:45:26.000000000 +1100
+++ ./drivers/md/raid10.c	2005-12-12 10:45:34.000000000 +1100
@@ -712,7 +712,7 @@ static void allow_barrier(conf_t *conf)
 static void freeze_array(conf_t *conf)
 {
 	/* stop syncio and normal IO and wait for everything to
-	 * go quite.
+	 * go quiet.
 	 * We increment barrier and nr_waiting, and then
 	 * wait until barrier+nr_pending match nr_queued+2
 	 */
