From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 2 of 6] Prevent oops when drive set faulty in inactive md array.
Date: Mon, 07 Feb 2005 13:44:19 +1100
Message-ID: <E1Cxyst-0004fe-HX@notabene.cse.unsw.edu.au>
References: <20050207133555.17870.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


hot_add_disk and hot_remove_disk check mddev->pers before proceeding.
set_disk_faulty should too.


Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    3 +++
 1 files changed, 3 insertions(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-02-07 13:31:08.000000000 +1100
+++ ./drivers/md/md.c	2005-02-07 13:32:00.000000000 +1100
@@ -2489,6 +2489,9 @@ static int set_disk_faulty(mddev_t *mdde
 {
 	mdk_rdev_t *rdev;
 
+	if (mddev->pers == NULL)
+		return -ENODEV;
+
 	rdev = find_rdev(mddev, dev);
 	if (!rdev)
 		return -ENODEV;
