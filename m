From: Neil Brown <neilb@suse.de>
Subject: RE: Software raid0 will crash the file-system, when each disk is 5TB
Date: Fri, 18 May 2007 10:21:53 +1000
Message-ID: <17996.61857.486525.172950@notabene.brown>
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
	<6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com>
	<17994.19043.771733.453896@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com>
	<17995.42562.870806.396617@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B33ED@gazelle.ad.endace.com>
	<17995.49602.427417.500049@notabene.brown>
	<Pine.LNX.4.64.0705162145060.31624@asgard.lang.hm>
	<17995.57891.56738.592100@notabene.brown>
	<17995.59547.368508.202596@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B348A@gazelle.ad.endace.com>
	<659F626D666070439A4A5965CD6EBF406B352A@gazelle.ad.endace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jeff Zheng on Friday May 18
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Zheng <Jeff.Zheng@endace.com>
Cc: david@lang.hm, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, Ingo Molnar <mingo@elte.hu>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 18, Jeff.Zheng@endace.com wrote:
>  Fix confirmed, filled the whole 11T hard disk, without crashing.
> I presume this would go into 2.6.22

Yes, and probably 2.6.21.y, though the patch will be slightly
different, see below.
> 
> Thanks again.

And thank-you for pursuing this with me.

NeilBrown


---------------------------
Avoid overflow in raid0 calculation with large components.

If a raid0 has a component device larger than 4TB, and is accessed on
a 32bit machines, then as 'chunk' is unsigned lock,
   chunk << chunksize_bits
can overflow (this can be as high as the size of the device in KB).
chunk itself will not overflow (without triggering a BUG).

So change 'chunk' to be 'sector_t, and get rid of the 'BUG' as it becomes
impossible to hit.

Cc: "Jeff Zheng" <Jeff.Zheng@endace.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid0.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff .prev/drivers/md/raid0.c ./drivers/md/raid0.c
--- .prev/drivers/md/raid0.c	2007-05-17 10:33:30.000000000 +1000
+++ ./drivers/md/raid0.c	2007-05-17 16:14:12.000000000 +1000
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
