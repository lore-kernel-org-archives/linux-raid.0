From: Shaohua Li <shli@fb.com>
Subject: [PATCH 2/3] MD: add journal with array suspended
Date: Wed, 6 Jan 2016 14:37:14 -0800
Message-ID: <4b7fbe9c04dd99e58840ccf88a7cc121ab74a2d3.1452119479.git.shli@fb.com>
References: <55aef157bf27c1de417577f02b69944a277a0141.1452119479.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55aef157bf27c1de417577f02b69944a277a0141.1452119479.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Kernel-team@fb.com, songliubraving@fb.com, neilb@suse.de
List-Id: linux-raid.ids

Hot add journal disk in recovery thread context brings a lot of trouble
as IO could be running. Unlike spare disk hot add, adding journal disk
with array suspended makes more sense and implmentation is much easier.

Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e896320..dad9a25 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2464,15 +2464,20 @@ static int add_bound_rdev(struct md_rdev *rdev)
 {
 	struct mddev *mddev = rdev->mddev;
 	int err = 0;
+	bool add_journal = test_bit(Journal, &rdev->flags);
 
-	if (!mddev->pers->hot_remove_disk) {
+	if (!mddev->pers->hot_remove_disk || add_journal) {
 		/* If there is hot_add_disk but no hot_remove_disk
 		 * then added disks for geometry changes,
 		 * and should be added immediately.
 		 */
 		super_types[mddev->major_version].
 			validate_super(mddev, rdev);
+		if (add_journal)
+			mddev_suspend(mddev);
 		err = mddev->pers->hot_add_disk(mddev, rdev);
+		if (add_journal)
+			mddev_resume(mddev);
 		if (err) {
 			unbind_rdev_from_array(rdev);
 			export_rdev(rdev);
-- 
2.4.6

