From: Mike Accetta <maccetta@laurelnetworks.com>
Subject: raid1 check/repair read error recovery in 2.6.20
Date: Thu, 24 May 2007 23:27:57 -0400
Message-ID: <6834.1180063677@mdt.dhcp.pit.laurelnetworks.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I believe I've come across a bug in the disk read error recovery logic
for raid1 check/repair operations in 2.6.20.  The raid1.c file looks
identical in 2.6.21 so the problem should still exist there as well.

This all surfaced when using a variant of CONFIG_FAIL_MAKE_REQUEST to
inject read errors on one of the mirrors of a raid1 array.  I noticed
that while this would ultimately fail the array, it would always seem
to generate

ata1.00: WARNING: zero len r/w req 
ata1.00: WARNING: zero len r/w req 
ata1.00: WARNING: zero len r/w req 
ata1.00: WARNING: zero len r/w req 
ata1.00: WARNING: zero len r/w req 
ata1.00: WARNING: zero len r/w req 

diagnostics at the same time (no clue why there are six of them).
Delving into this further I eventually settled on sync_request_write()
in raid1.c as a likely culprit and added the WARN_ON (below)

@@ -1386,6 +1393,7 @@
                atomic_inc(&r1_bio->remaining);
                md_sync_acct(conf->mirrors[i].rdev->bdev, wbio->bi_size >> 9);
 
+               WARN_ON(wbio->bi_size == 0);
                generic_make_request(wbio);
        }


to confirm that this code was indeed sending a zero size bio down to
the device layer in this circumstance.

Looking at the preceding code in sync_request_write() it appears that
the loop comparing the results of all reads just skips a mirror where
the read failed (BIO_UPTODATE is clear) without doing any of the sbio
prep or the memcpy() from the pbio.  There is other read/re-write logic
in the following if-clause but this seems to apply only if none of the
mirrors were readable.  Regardless, the fact that a zero length bio is
being issued in the "schedule writes" section is compelling evidence
that something is wrong somewhere.

I tried the following patch to raid1.c which short-ciruits the data
comparison in the read error case but otherwise does the rest of the
sbio prep for the mirror with the error.  It seems to have eliminated
the ATA warning at least.  Is it a correct thing to do?

@@ -1235,17 +1242,20 @@
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
+				if (test_bit(BIO_UPTODATE, &sbio->bi_flags)) {
+					for (j = vcnt; j-- ; )
+						if (memcmp(page_address(pbio->bi_io_vec[j].bv_page),
+							   page_address(sbio->bi_io_vec[j].bv_page),
+							   PAGE_SIZE))
+							break;
+				} else {
+					j = 0;
+				}
 				if (j >= 0)
 					mddev->resync_mismatches += r1_bio->sectors;
 				if (j < 0 || test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
--
Mike Accetta

ECI Telecom Ltd.
Data Networking Division (previously Laurel Networks)
