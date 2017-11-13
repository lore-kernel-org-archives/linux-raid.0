From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH] managemon: Don't add disk to the array after it has started
Date: Mon, 13 Nov 2017 14:16:52 +0100
Message-ID: <1510579012-3909-1-git-send-email-tomasz.majchrzak@intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: jsorensen@fb.com, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

If disk has disappeared from the system and appears again, it is added to the
corresponding container as long the metadata matches and disk number is set.
This code had no effect on imsm until commit 20dc76d15b40 ("imsm: Set disk slot
number"). Now the disk is added to container but not to the array - it is
correct as the disk is out-of-sync. Rebuild should start for the disk but it
doesn't. There is the same behaviour for both imsm and ddf metadata.

There is no point to handle out-of-sync disk as "good member of array" so
remove that part of code. There are no scenarios when monitor is already
running and disk can be safely added to the array. Just write initial metadata
to the disk so it's taken for rebuild.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 managemon.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/managemon.c b/managemon.c
index 4e85398..101231c 100644
--- a/managemon.c
+++ b/managemon.c
@@ -266,9 +266,7 @@ static void add_disk_to_container(struct supertype *st, struct mdinfo *sd)
 {
 	int dfd;
 	char nm[20];
-	struct supertype *st2;
 	struct metadata_update *update = NULL;
-	struct mdinfo info;
 	mdu_disk_info_t dk = {
 		.number = -1,
 		.major = sd->disk.major,
@@ -287,25 +285,6 @@ static void add_disk_to_container(struct supertype *st, struct mdinfo *sd)
 	if (dfd < 0)
 		return;
 
-	/* Check the metadata and see if it is already part of this
-	 * array
-	 */
-	st2 = dup_super(st);
-	if (st2->ss->load_super(st2, dfd, NULL) == 0) {
-		st2->ss->getinfo_super(st2, &info, NULL);
-		if (st->ss->compare_super(st, st2) == 0 &&
-		    info.disk.raid_disk >= 0) {
-			/* Looks like a good member of array.
-			 * Just accept it.
-			 * mdadm will incorporate any parts into
-			 * active arrays.
-			 */
-			st2->ss->free_super(st2);
-			return;
-		}
-	}
-	st2->ss->free_super(st2);
-
 	st->update_tail = &update;
 	st->ss->add_to_super(st, &dk, dfd, NULL, INVALID_SECTORS);
 	st->ss->write_init_super(st);
-- 
1.8.3.1

