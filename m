From: Yufen Yu <yuyufen@huawei.com>
Subject: [PATCH v2] md: add mddev->pers to avoid potential NULL pointer dereference
Date: Tue, 2 Apr 2019 14:22:14 +0800
Message-ID: <20190402062214.136669-1-yuyufen@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: axboe@kernel.dk, songliubraving@fb.com
Cc: neilb@suse.com, xni@redhat.com, linux-raid@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-raid.ids

When doing re-add, we need to ensure rdev->mddev->pers is not NULL,
which can avoid potential NULL pointer derefence in fallowing
add_bound_rdev().

Fixes: a6da4ef85cef ("md: re-add a failed disk")
Cc: Xiao Ni <xni@redhat.com>
Cc: NeilBrown <neilb@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Yufen Yu <yuyufen@huawei.com>
---
 drivers/md/md.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 875b29ba5926..66b6bdf9f364 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2859,8 +2859,10 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 			err = 0;
 		}
 	} else if (cmd_match(buf, "re-add")) {
-		if (test_bit(Faulty, &rdev->flags) && (rdev->raid_disk == -1) &&
-			rdev->saved_raid_disk >= 0) {
+		if (!rdev->mddev->pers)
+			err = -EINVAL;
+		else if (test_bit(Faulty, &rdev->flags) && (rdev->raid_disk == -1) &&
+				rdev->saved_raid_disk >= 0) {
 			/* clear_bit is performed _after_ all the devices
 			 * have their local Faulty bit cleared. If any writes
 			 * happen in the meantime in the local node, they
-- 
2.16.2.dirty
