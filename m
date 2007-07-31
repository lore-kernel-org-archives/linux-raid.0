From: Greg KH <gregkh@suse.de>
Subject: [patch 07/26] md: Fix two raid10 bugs.
Date: Mon, 30 Jul 2007 21:31:54 -0700
Message-ID: <20070731043154.GH3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename="md-fix-two-raid10-bugs.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>, Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, linux-raid@vger.kernel.org, neilb@suse.de, Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
List-Id: linux-raid.ids


-stable review patch.  If anyone has any objections, please let us know.

------------------

1/ When resyncing a degraded raid10 which has more than 2 copies of each block,
  garbage can get synced on top of good data.

2/ We round the wrong way in part of the device size calculation, which
  can cause confusion.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/md/raid10.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- linux-2.6.21.6.orig/drivers/md/raid10.c
+++ linux-2.6.21.6/drivers/md/raid10.c
@@ -1867,6 +1867,7 @@ static sector_t sync_request(mddev_t *md
 			int d = r10_bio->devs[i].devnum;
 			bio = r10_bio->devs[i].bio;
 			bio->bi_end_io = NULL;
+			clear_bit(BIO_UPTODATE, &bio->bi_flags);
 			if (conf->mirrors[d].rdev == NULL ||
 			    test_bit(Faulty, &conf->mirrors[d].rdev->flags))
 				continue;
@@ -2037,6 +2038,11 @@ static int run(mddev_t *mddev)
 	/* 'size' is now the number of chunks in the array */
 	/* calculate "used chunks per device" in 'stride' */
 	stride = size * conf->copies;
+
+	/* We need to round up when dividing by raid_disks to
+	 * get the stride size.
+	 */
+	stride += conf->raid_disks - 1;
 	sector_div(stride, conf->raid_disks);
 	mddev->size = stride  << (conf->chunk_shift-1);
 

-- 
