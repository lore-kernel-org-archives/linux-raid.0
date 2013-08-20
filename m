From: Dave Jones <davej@redhat.com>
Subject: Fix apparent cut-and-paste error in super_90_validate
Date: Mon, 19 Aug 2013 22:26:32 -0400
Message-ID: <20130820022632.GA12899@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Setting a variable to itself probably wasn't the intention here.

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9f13e13..b9cb9e4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1180,7 +1180,7 @@ static int super_90_validate(struct mddev *mddev, struct md_rdev *rdev)
 			mddev->bitmap_info.offset =
 				mddev->bitmap_info.default_offset;
 			mddev->bitmap_info.space =
-				mddev->bitmap_info.space;
+				mddev->bitmap_info.default_space;
 		}
 
 	} else if (mddev->pers == NULL) {
