From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 02/23] md/raid10: remove unnecessary smp_mb() from
 end_sync_write
Date: Wed, 14 Mar 2012 15:40:39 +1100
Message-ID: <20120314044039.7978.67694.stgit@notabene.brown>
References: <20120314043555.7978.75486.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120314043555.7978.75486.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Recent commit 4ca40c2ce099e4f1ce3 (md/raid10: Allow replacement device ...)
added an smp_mb in end_sync_write.
This was to close a possible race with raid10_remove_disk.
However there is no such race as it is never attempted to remove a
disk while resync (or recovery) is happening.
so the smp_mb is just noise.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 58c44d6..1a19c96 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1682,10 +1682,8 @@ static void end_sync_write(struct bio *bio, int error)
 	d = find_bio_disk(conf, r10_bio, bio, &slot, &repl);
 	if (repl)
 		rdev = conf->mirrors[d].replacement;
-	if (!rdev) {
-		smp_mb();
+	else
 		rdev = conf->mirrors[d].rdev;
-	}
 
 	if (!uptodate) {
 		if (repl)


