From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 001 of 3] Really get sb_size setting right in all cases.
Date: Tue, 6 Sep 2005 13:53:02 +1000
Message-ID: <1050906035302.19309@suse.de>
References: <20050906134923.19249.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


There was another case where sb_size wasn't being set, so
instead do the sensible thing and set if when filling in the
content of a superblock.  That ensures that whenever we
write a superblock, the sb_size MUST be set.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-09-02 19:29:31.000000000 +1000
+++ ./drivers/md/md.c	2005-09-05 14:47:45.000000000 +1000
@@ -712,6 +712,8 @@ static void super_90_sync(mddev_t *mddev
 	int i;
 	int active=0, working=0,failed=0,spare=0,nr_disks=0;
 
+	rdev->sb_size = MD_SB_BYTES;
+
 	sb = (mdp_super_t*)page_address(rdev->sb_page);
 
 	memset(sb, 0, sizeof(*sb));
@@ -2303,8 +2305,6 @@ static int add_new_disk(mddev_t * mddev,
 		else
 			rdev->in_sync = 0;
 
-		rdev->sb_size = MD_SB_BYTES;
-
 		if (info->state & (1<<MD_DISK_WRITEMOSTLY))
 			set_bit(WriteMostly, &rdev->flags);
 
