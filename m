From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 002 of 2] Make sure recovery happens when add_new_disk is used for hot_add
Date: Fri, 13 May 2005 14:51:35 +1000
Message-ID: <E1DWS99-00014N-En@notabene.cse.unsw.edu.au>
References: <20050513144946.4066.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Currently if add_new_disk is used to hot-add a drive to a degraded
array, recovery doesn't start ... because we didn't tell it to.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    2 ++
 1 files changed, 2 insertions(+)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-05-13 14:47:35.000000000 +1000
+++ ./drivers/md/md.c	2005-05-13 14:48:22.000000000 +1000
@@ -2232,6 +2232,8 @@ static int add_new_disk(mddev_t * mddev,
 		err = bind_rdev_to_array(rdev, mddev);
 		if (err)
 			export_rdev(rdev);
+
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 		if (mddev->thread)
 			md_wakeup_thread(mddev->thread);
 		return err;
