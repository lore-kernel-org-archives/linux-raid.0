From: NeilBrown <neilb@suse.de>
Subject: [PATCH 003 of 6] md: Remove an unused variable.
Date: Fri, 17 Mar 2006 18:21:36 +1100
Message-ID: <1060317072136.28638@suse.de>
References: <20060317181912.28543.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid5.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2006-03-17 18:18:32.000000000 +1100
+++ ./drivers/md/raid5.c	2006-03-17 18:18:35.000000000 +1100
@@ -2186,7 +2186,7 @@ static int run(mddev_t *mddev)
 		 * increase, and we must be past the point where
 		 * a stripe over-writes itself
 		 */
-		sector_t here_new, here_old, there_new;
+		sector_t here_new, here_old;
 		int old_disks;
 
 		if (mddev->new_level != mddev->level ||
