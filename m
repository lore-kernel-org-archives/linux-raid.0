From: NeilBrown <neilb@suse.de>
Subject: [PATCH 001 of 2] md: Make sure a re-add after a restart honours bitmap when resyncing.
Date: Thu, 16 Aug 2007 10:38:39 +1000
Message-ID: <1070816003839.32721@suse.de>
References: <20070816103626.32539.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Commit 1757128438d41670ded8bc3bc735325cc07dc8f9 was slightly bad.  If
an array has a write-intent bitmap, and you remove a drive, then readd
it, only the changed parts should be resynced.  However after the
above commit, this only works if the array has not been shut down and
restarted.

This is because it sets 'fullsync' at little more often
than it should.  This patch is more careful.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-08-16 10:27:57.000000000 +1000
+++ ./drivers/md/raid1.c	2007-08-16 10:27:57.000000000 +1000
@@ -1972,7 +1972,8 @@ static int run(mddev_t *mddev)
 		    !test_bit(In_sync, &disk->rdev->flags)) {
 			disk->head_position = 0;
 			mddev->degraded++;
-			conf->fullsync = 1;
+			if (disk->rdev)
+				conf->fullsync = 1;
 		}
 	}
 	if (mddev->degraded == conf->raid_disks) {
