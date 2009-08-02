From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 4/8] md: avoid array overflow with bad v1.x metadata
Date: Mon, 03 Aug 2009 07:58:18 +1000
Message-ID: <20090802215818.4198.19159.stgit@notabene.brown>
References: <20090802215444.4198.83094.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090802215444.4198.83094.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

We trust the 'desc_nr' field in v1.x metadata enough to use it
as an index in an array.  This isn't really safe.
So range-check the value first.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5bd7896..fc04963 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1308,7 +1308,12 @@ static int super_1_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 	}
 	if (mddev->level != LEVEL_MULTIPATH) {
 		int role;
-		role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
+		if (rdev->desc_nr < 0 ||
+		    rdev->desc_nr >= le32_to_cpu(sb->max_dev)) {
+			role = 0xffff;
+			rdev->desc_nr = -1;
+		} else
+			role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
 		switch(role) {
 		case 0xffff: /* spare */
 			break;


