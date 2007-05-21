From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 39/69] md: Avoid a possibility that a read error can wrongly propagate through md/raid1 to a filesystem.
Date: Mon, 21 May 2007 12:16:51 -0700
Message-ID: <20070521191734.512551000@sous-sol.org>
References: <20070521191612.800400000@sous-sol.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=md-avoid-a-possibility-that-a-read-error-can-wrongly-propagate-through-md-raid1-to-a-filesystem.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: NeilBrown <neilb@suse.de>

When a raid1 has only one working drive, we want read error to
propagate up to the filesystem as there is no point failing the last
drive in an array.

Currently the code perform this check is racy.  If a write and a read
a both submitted to a device on a 2-drive raid1, and the write fails
followed by the read failing, the read will see that there is only one
working drive and will pass the failure up, even though the one
working drive is actually the *other* one.

So, tighten up the locking.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

 drivers/md/raid1.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- linux-2.6.21.1.orig/drivers/md/raid1.c
+++ linux-2.6.21.1/drivers/md/raid1.c
@@ -271,21 +271,25 @@ static int raid1_end_read_request(struct
 	 */
 	update_head_pos(mirror, r1_bio);
 
-	if (uptodate || (conf->raid_disks - conf->mddev->degraded) <= 1) {
-		/*
-		 * Set R1BIO_Uptodate in our master bio, so that
-		 * we will return a good error code for to the higher
-		 * levels even if IO on some other mirrored buffer fails.
-		 *
-		 * The 'master' represents the composite IO operation to
-		 * user-side. So if something waits for IO, then it will
-		 * wait for the 'master' bio.
+	if (uptodate)
+		set_bit(R1BIO_Uptodate, &r1_bio->state);
+	else {
+		/* If all other devices have failed, we want to return
+		 * the error upwards rather than fail the last device.
+		 * Here we redefine "uptodate" to mean "Don't want to retry"
 		 */
-		if (uptodate)
-			set_bit(R1BIO_Uptodate, &r1_bio->state);
+		unsigned long flags;
+		spin_lock_irqsave(&conf->device_lock, flags);
+		if (r1_bio->mddev->degraded == conf->raid_disks ||
+		    (r1_bio->mddev->degraded == conf->raid_disks-1 &&
+		     !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags)))
+			uptodate = 1;
+		spin_unlock_irqrestore(&conf->device_lock, flags);
+	}
 
+	if (uptodate)
 		raid_end_bio_io(r1_bio);
-	} else {
+	else {
 		/*
 		 * oops, read error:
 		 */
@@ -992,13 +996,14 @@ static void error(mddev_t *mddev, mdk_rd
 		unsigned long flags;
 		spin_lock_irqsave(&conf->device_lock, flags);
 		mddev->degraded++;
+		set_bit(Faulty, &rdev->flags);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
 		/*
 		 * if recovery is running, make sure it aborts.
 		 */
 		set_bit(MD_RECOVERY_ERR, &mddev->recovery);
-	}
-	set_bit(Faulty, &rdev->flags);
+	} else
+		set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	printk(KERN_ALERT "raid1: Disk failure on %s, disabling device. \n"
 		"	Operation continuing on %d devices\n",

-- 
