From: Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 29/61] md: Fix calculation of ->degraded for multipath and raid10
Date: Tue, 31 Oct 2006 21:34:09 -0800
Message-ID: <20061101054018.139620000@sous-sol.org>
References: <20061101053340.305569000@sous-sol.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=md-fix-calculation-of-degraded-for-multipath-and-raid10.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, Andrew Morton <akpm@osdl.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, torvalds@osdl.org, alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
List-Id: linux-raid.ids

-stable review patch.  If anyone has any objections, please let us know.
------------------

From: NeilBrown <neilb@suse.de>

Two less-used md personalities have bugs in the calculation of 
 ->degraded (the extent to which the array is degraded).

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>

---
 drivers/md/multipath.c |    2 +-
 drivers/md/raid10.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.18.1.orig/drivers/md/multipath.c
+++ linux-2.6.18.1/drivers/md/multipath.c
@@ -480,7 +480,7 @@ static int multipath_run (mddev_t *mddev
 			mdname(mddev));
 		goto out_free_conf;
 	}
-	mddev->degraded = conf->raid_disks = conf->working_disks;
+	mddev->degraded = conf->raid_disks - conf->working_disks;
 
 	conf->pool = mempool_create_kzalloc_pool(NR_RESERVED_BUFS,
 						 sizeof(struct multipath_bh));
--- linux-2.6.18.1.orig/drivers/md/raid10.c
+++ linux-2.6.18.1/drivers/md/raid10.c
@@ -2042,7 +2042,7 @@ static int run(mddev_t *mddev)
 		disk = conf->mirrors + i;
 
 		if (!disk->rdev ||
-		    !test_bit(In_sync, &rdev->flags)) {
+		    !test_bit(In_sync, &disk->rdev->flags)) {
 			disk->head_position = 0;
 			mddev->degraded++;
 		}

--
