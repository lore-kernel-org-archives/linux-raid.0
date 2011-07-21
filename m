From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 01/34] md/raid10: get rid of duplicated conditional
 expression
Date: Thu, 21 Jul 2011 12:32:24 +1000
Message-ID: <20110721023224.6728.71252.stgit@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110721022537.6728.90204.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Namhyung Kim <namhyung@gmail.com>
List-Id: linux-raid.ids

From: Namhyung Kim <namhyung@gmail.com>

Variable 'first' is initialized to zero and updated to @rdev->raid_disk
only if it is greater than 0. Thus condition '>= first' always implies
'>= 0' so the latter is not needed.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 6e84668..d55ae12 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1093,8 +1093,7 @@ static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 	if (rdev->raid_disk >= 0)
 		first = last = rdev->raid_disk;
 
-	if (rdev->saved_raid_disk >= 0 &&
-	    rdev->saved_raid_disk >= first &&
+	if (rdev->saved_raid_disk >= first &&
 	    conf->mirrors[rdev->saved_raid_disk].rdev == NULL)
 		mirror = rdev->saved_raid_disk;
 	else


