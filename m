From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 2 of 4] Erroneous sizeof use in raid1
Date: Tue, 08 Mar 2005 16:50:59 +1100
Message-ID: <E1D8XcR-0000zC-No@notabene.cse.unsw.edu.au>
References: <20050308165021.3745.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This isn't a real bug as the smallest slab-size is 32 bytes 
but please apply for consistency.

Found by the Coverity tool.

Signed-off-by: Alexander Nyberg <alexn@dsv.su.se>
Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid1.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-03-07 15:49:25.000000000 +1100
+++ ./drivers/md/raid1.c	2005-03-07 15:49:55.000000000 +1100
@@ -1494,7 +1494,7 @@ static int raid1_reshape(mddev_t *mddev,
 		if (conf->mirrors[d].rdev)
 			return -EBUSY;
 
-	newpoolinfo = kmalloc(sizeof(newpoolinfo), GFP_KERNEL);
+	newpoolinfo = kmalloc(sizeof(*newpoolinfo), GFP_KERNEL);
 	if (!newpoolinfo)
 		return -ENOMEM;
 	newpoolinfo->mddev = mddev;
