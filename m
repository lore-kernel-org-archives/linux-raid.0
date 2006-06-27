From: NeilBrown <neilb@suse.de>
Subject: [PATCH 002 of 12] md: Set desc_nr correctly for version-1 superblocks.
Date: Tue, 27 Jun 2006 17:05:15 +1000
Message-ID: <1060627070515.25974@suse.de>
References: <20060627170010.25835.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


This has to be done in ->load_super, not ->validate_super

Without this, hot-adding devices to an array doesn't always
work right - though there is a work around in mdadm-2.5.2 to
make this less of an issue.

### Diffstat output
 ./drivers/md/md.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2006-06-27 12:15:17.000000000 +1000
+++ ./drivers/md/md.c	2006-06-27 12:17:32.000000000 +1000
@@ -1064,6 +1064,11 @@ static int super_1_load(mdk_rdev_t *rdev
 	if (rdev->sb_size & bmask)
 		rdev-> sb_size = (rdev->sb_size | bmask)+1;
 
+	if (sb->level == cpu_to_le32(LEVEL_MULTIPATH))
+		rdev->desc_nr = -1;
+	else
+		rdev->desc_nr = le32_to_cpu(sb->dev_number);
+
 	if (refdev == 0)
 		ret = 1;
 	else {
@@ -1173,7 +1178,6 @@ static int super_1_validate(mddev_t *mdd
 	}
 	if (mddev->level != LEVEL_MULTIPATH) {
 		int role;
-		rdev->desc_nr = le32_to_cpu(sb->dev_number);
 		role = le16_to_cpu(sb->dev_roles[rdev->desc_nr]);
 		switch(role) {
 		case 0xffff: /* spare */
