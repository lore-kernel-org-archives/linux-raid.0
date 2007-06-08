From: Chris Wright <chrisw@sous-sol.org>
Subject: [patch 05/54] md: Avoid overflow in raid0 calculation with large components.
Date: Fri, 08 Jun 2007 00:21:32 -0700
Message-ID: <20070608072148.719845000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline; filename=md-avoid-overflow-in-raid0-calculation-with-large-components.patch
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@kernel.org, akpm@linux-foundation.org
Cc: Justin Forbes <jmforbes@linuxtx.org>, Zwane Mwaikambo <zwane@arm.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>, Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>, Chris Wedgwood <reviews@ml.cw.f00f.org>, Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>, Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Jeff Zheng <Jeff.Zheng@endace.com>, Greg Kroah-Hartman <gregkh@suse.de>
List-Id: linux-raid.ids

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: NeilBrown <neilb@suse.de>

If a raid0 has a component device larger than 4TB, and is accessed on
a 32bit machines, then as 'chunk' is unsigned lock,
   chunk << chunksize_bits
can overflow (this can be as high as the size of the device in KB).
chunk itself will not overflow (without triggering a BUG).

So change 'chunk' to be 'sector_t, and get rid of the 'BUG' as it becomes
impossible to hit.

Cc: "Jeff Zheng" <Jeff.Zheng@endace.com>
Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 drivers/md/raid0.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff .prev/drivers/md/raid0.c ./drivers/md/raid0.c
--- linux-2.6.21.4.orig/drivers/md/raid0.c
+++ linux-2.6.21.4/drivers/md/raid0.c
@@ -415,7 +415,7 @@ static int raid0_make_request (request_q
 	raid0_conf_t *conf = mddev_to_conf(mddev);
 	struct strip_zone *zone;
 	mdk_rdev_t *tmp_dev;
-	unsigned long chunk;
+	sector_t chunk;
 	sector_t block, rsect;
 	const int rw = bio_data_dir(bio);
 
@@ -470,7 +470,6 @@ static int raid0_make_request (request_q
 
 		sector_div(x, zone->nb_dev);
 		chunk = x;
-		BUG_ON(x != (sector_t)chunk);
 
 		x = block >> chunksize_bits;
 		tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];

-- 
