From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 1 of 6] Fix problems with verion-1 superblock code
Date: Mon, 07 Feb 2005 13:44:19 +1100
Message-ID: <E1Cxyst-0004fa-De@notabene.cse.unsw.edu.au>
References: <20050207133555.17870.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


- off-by-one error
- missing recalc of checksum

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-02-07 13:31:05.000000000 +1100
+++ ./drivers/md/md.c	2005-02-07 13:31:08.000000000 +1100
@@ -980,8 +980,8 @@ static void super_1_sync(mddev_t *mddev,
 
 	max_dev = 0;
 	ITERATE_RDEV(mddev,rdev2,tmp)
-		if (rdev2->desc_nr > max_dev)
-			max_dev = rdev2->desc_nr;
+		if (rdev2->desc_nr+1 > max_dev)
+			max_dev = rdev2->desc_nr+1;
 	
 	sb->max_dev = cpu_to_le32(max_dev);
 	for (i=0; i<max_dev;i++)
@@ -998,6 +998,7 @@ static void super_1_sync(mddev_t *mddev,
 	}
 
 	sb->recovery_offset = cpu_to_le64(0); /* not supported yet */
+	sb->sb_csum = calc_sb_1_csum(sb);
 }
 
 
