From: Greg KH <gregkh@suse.de>
Subject: [patch 08/26] md: Fix bug in error handling during raid1 repair.
Date: Mon, 30 Jul 2007 21:32:01 -0700
Message-ID: <20070731043201.GI3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename="md-fix-bug-in-error-handling-during-raid1-repair.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>, Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, linux-raid@vger.kernel.org, neilb@suse.de, Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
List-Id: linux-raid.ids

-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mike Accetta <maccetta@laurelnetworks.com>

If raid1/repair (which reads all block and fixes any differences
it finds) hits a read error, it doesn't reset the bio for writing
before writing correct data back, so the read error isn't fixed,
and the device probably gets a zero-length write which it might
complain about.

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/md/raid1.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- linux-2.6.21.6.orig/drivers/md/raid1.c
+++ linux-2.6.21.6/drivers/md/raid1.c
@@ -1240,17 +1240,24 @@ static void sync_request_write(mddev_t *
 			}
 		r1_bio->read_disk = primary;
 		for (i=0; i<mddev->raid_disks; i++)
-			if (r1_bio->bios[i]->bi_end_io == end_sync_read &&
-			    test_bit(BIO_UPTODATE, &r1_bio->bios[i]->bi_flags)) {
+			if (r1_bio->bios[i]->bi_end_io == end_sync_read) {
 				int j;
 				int vcnt = r1_bio->sectors >> (PAGE_SHIFT- 9);
 				struct bio *pbio = r1_bio->bios[primary];
 				struct bio *sbio = r1_bio->bios[i];
-				for (j = vcnt; j-- ; )
-					if (memcmp(page_address(pbio->bi_io_vec[j].bv_page),
-						   page_address(sbio->bi_io_vec[j].bv_page),
-						   PAGE_SIZE))
-						break;
+
+				if (test_bit(BIO_UPTODATE, &sbio->bi_flags)) {
+					for (j = vcnt; j-- ; ) {
+						struct page *p, *s;
+						p = pbio->bi_io_vec[j].bv_page;
+						s = sbio->bi_io_vec[j].bv_page;
+						if (memcmp(page_address(p),
+							   page_address(s),
+							   PAGE_SIZE))
+							break;
+					}
+				} else
+					j = 0;
 				if (j >= 0)
 					mddev->resync_mismatches += r1_bio->sectors;
 				if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {

-- 
