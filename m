From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 3 of 4] Initialise sync_blocks in raid1 resync
Date: Tue, 08 Mar 2005 16:50:59 +1100
Message-ID: <E1D8XcR-0000zG-PM@notabene.cse.unsw.edu.au>
References: <20050308165021.3745.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Otherwise it could have a random value and might BUG.
This fixes a BUG during resync problem in raid1 introduced
by the bitmap-based-intent-loggin patches.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid1.c |    1 +
 1 files changed, 1 insertion(+)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-03-07 15:49:55.000000000 +1100
+++ ./drivers/md/raid1.c	2005-03-07 15:53:55.000000000 +1100
@@ -1235,6 +1235,7 @@ static sector_t sync_request(mddev_t *md
 	}
 
 	nr_sectors = 0;
+	sync_blocks = 0;
 	do {
 		struct page *page;
 		int len = PAGE_SIZE;
