From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 2 of 2] Correct "working_disk" counts for raid5 and raid6
Date: Fri, 03 Sep 2004 12:27:31 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1C33nX-00040m-Fl@notabene.cse.unsw.edu.au>
References: <20040903122034.15346.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This error only affects two message (and sysadmin heart-rate).
It does not risk data.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid5.c     |    2 +-
 ./drivers/md/raid6main.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-09-03 11:34:26.000000000 +1000
+++ ./drivers/md/raid5.c	2004-09-03 11:37:56.000000000 +1000
@@ -477,8 +477,8 @@ static void error(mddev_t *mddev, mdk_rd
 
 	if (!rdev->faulty) {
 		mddev->sb_dirty = 1;
-		conf->working_disks--;
 		if (rdev->in_sync) {
+			conf->working_disks--;
 			mddev->degraded++;
 			conf->failed_disks++;
 			rdev->in_sync = 0;

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-09-03 11:34:26.000000000 +1000
+++ ./drivers/md/raid6main.c	2004-09-03 11:37:56.000000000 +1000
@@ -498,8 +498,8 @@ static void error(mddev_t *mddev, mdk_rd
 
 	if (!rdev->faulty) {
 		mddev->sb_dirty = 1;
-		conf->working_disks--;
 		if (rdev->in_sync) {
+			conf->working_disks--;
 			mddev->degraded++;
 			conf->failed_disks++;
 			rdev->in_sync = 0;
