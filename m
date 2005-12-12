From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 001 of 20] Fix a use-after-free bug in raid1
Date: Mon, 12 Dec 2005 14:10:17 +1100
Message-ID: <1051212031017.4861@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Who would submit code with a FIXME like that in it !!!!



Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2005-12-12 10:45:16.000000000 +1100
+++ ./drivers/md/raid1.c	2005-12-12 10:45:22.000000000 +1100
@@ -323,7 +323,6 @@ static int raid1_end_write_request(struc
 		 * this branch is our 'one mirror IO has finished' event handler:
 		 */
 		r1_bio->bios[mirror] = NULL;
-		bio_put(bio);
 		if (!uptodate) {
 			md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
 			/* an I/O failed, we can't clear the bitmap */
@@ -380,7 +379,6 @@ static int raid1_end_write_request(struc
 		}
 		if (test_bit(R1BIO_BehindIO, &r1_bio->state)) {
 			/* free extra copy of the data pages */
-/* FIXME bio has been freed!!! */
 			int i = bio->bi_vcnt;
 			while (i--)
 				put_page(bio->bi_io_vec[i].bv_page);
@@ -394,6 +392,9 @@ static int raid1_end_write_request(struc
 		raid_end_bio_io(r1_bio);
 	}
 
+	if (r1_bio->bios[mirror]==NULL)
+		bio_put(bio);
+
 	rdev_dec_pending(conf->mirrors[mirror].rdev, conf->mddev);
 	return 0;
 }
