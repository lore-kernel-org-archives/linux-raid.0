From: NeilBrown <neilb@suse.de>
Subject: [PATCH 1/5] md/raid1: be more cautious where we read-balance during
 resync.
Date: Wed, 10 Sep 2014 16:20:44 +1000
Message-ID: <20140910062044.26400.79939.stgit@notabene.brown>
References: <20140910062039.26400.36745.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140910062039.26400.36745.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Eivind Sarto <eivindsarto@gmail.com>, Brassow Jonathan <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, majianpeng <majianpeng@gmail.com>
List-Id: linux-raid.ids

commit 79ef3a8aa1cb1523cc231c9a90a278333c21f761 made
it possible for reads to happen concurrently with resync.
This means that we need to be more careful where read_balancing
is allowed during resync - we can no longer be sure that any
resync that has already started will definitely finish.

So keep read_balancing to before recovery_cp, which is conservative
but safe.

This bug makes it possible to read from a device that doesn't
have up-to-date data, so it can cause data corruption.
So it is suitable for any kernel since 3.11.

Fixes: 79ef3a8aa1cb1523cc231c9a90a278333c21f761
cc: stable@vger.kernel.org (v3.11+)
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/raid1.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index d7690f86fdb9..f66f67e5a423 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -540,11 +540,7 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 	has_nonrot_disk = 0;
 	choose_next_idle = 0;
 
-	if (conf->mddev->recovery_cp < MaxSector &&
-	    (this_sector + sectors >= conf->next_resync))
-		choose_first = 1;
-	else
-		choose_first = 0;
+	choose_first = (conf->mddev->recovery_cp < this_sector + sectors);
 
 	for (disk = 0 ; disk < conf->raid_disks * 2 ; disk++) {
 		sector_t dist;


