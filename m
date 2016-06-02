From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 01/18] md: disconnect device from personality before
 trying to remove it.
Date: Thu, 02 Jun 2016 16:19:52 +1000
Message-ID: <20160602061952.2939.77544.stgit@noble>
References: <20160602061319.2939.72280.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160602061319.2939.72280.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When the HOT_REMOVE_DISK ioctl is used to remove a device, we
call remove_and_add_spares() which will remove it from the personality
if possible.  This improves the chances that the removal will succeed.

When writing "remove" to dev-XX/state, we don't.  So that can fail more easily.

So add the remove_and_add_spares() into "remove" handling.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 866825f10b4c..2d26099e1160 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2596,6 +2596,8 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		else
 			err = -EBUSY;
 	} else if (cmd_match(buf, "remove")) {
+		clear_bit(Blocked, &rdev->flags);
+		remove_and_add_spares(rdev->mddev, rdev);
 		if (rdev->raid_disk >= 0)
 			err = -EBUSY;
 		else {


