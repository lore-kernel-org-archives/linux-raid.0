From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 1 of 4] Fix typo in super_1_sync
Date: Tue, 08 Mar 2005 16:50:59 +1100
Message-ID: <E1D8XcR-0000z8-Mk@notabene.cse.unsw.edu.au>
References: <20050308165021.3745.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Instead of setting one value lots of times, let's
set lots of values once each, as we should..

From: Paul Clements <paul.clements@steeleye.com>
Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-03-07 11:32:41.000000000 +1100
+++ ./drivers/md/md.c	2005-03-07 11:32:41.000000000 +1100
@@ -1010,7 +1010,7 @@ static void super_1_sync(mddev_t *mddev,
 	
 	sb->max_dev = cpu_to_le32(max_dev);
 	for (i=0; i<max_dev;i++)
-		sb->dev_roles[max_dev] = cpu_to_le16(0xfffe);
+		sb->dev_roles[i] = cpu_to_le16(0xfffe);
 	
 	ITERATE_RDEV(mddev,rdev2,tmp) {
 		i = rdev2->desc_nr;
