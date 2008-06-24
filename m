From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/2] use bio_endio instead of a call to bi_end_io
Date: Tue, 24 Jun 2008 01:28:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0806240122340.24220@engineering.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Cc: axboe@kernel.dk, mingo@redhat.com
List-Id: linux-raid.ids

Hi

The is sequel to my previous patch to avoid bio_endio recursion. raid5 
bypasses bio_endio and calls the method directly (although it does the 
same as bio_endio). I changed bio_endio to avoid recursion, so it should 
be used instead of calling the method.

Mikulas

--

Turn calls to bi->bi_end_io() into bio_endio(). Apparently bio_endio does
exactly the same error processing as is hardcoded at these places.

bio_endio() avoids recursion, so it should be used.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6.26-rc7-devel/drivers/md/raid5.c
===================================================================
--- linux-2.6.26-rc7-devel.orig/drivers/md/raid5.c	2008-06-24 07:28:15.000000000 +0200
+++ linux-2.6.26-rc7-devel/drivers/md/raid5.c	2008-06-24 07:28:53.000000000 +0200
@@ -115,9 +115,7 @@
  		return_bi = bi->bi_next;
  		bi->bi_next = NULL;
  		bi->bi_size = 0;
-		bi->bi_end_io(bi,
-			      test_bit(BIO_UPTODATE, &bi->bi_flags)
-			        ? 0 : -EIO);
+		bio_endio(bi, 0);
  		bi = return_bi;
  	}
  }
@@ -3689,9 +3687,7 @@
  		if ( rw == WRITE )
  			md_write_end(mddev);

-		bi->bi_end_io(bi,
-			      test_bit(BIO_UPTODATE, &bi->bi_flags)
-			        ? 0 : -EIO);
+		bio_endio(bi, 0);
  	}
  	return 0;
  }
@@ -3994,12 +3990,8 @@
  	spin_lock_irq(&conf->device_lock);
  	remaining = --raid_bio->bi_phys_segments;
  	spin_unlock_irq(&conf->device_lock);
-	if (remaining == 0) {
-
-		raid_bio->bi_end_io(raid_bio,
-			      test_bit(BIO_UPTODATE, &raid_bio->bi_flags)
-			        ? 0 : -EIO);
-	}
+	if (remaining == 0)
+		bio_endio(raid_bio, 0);
  	if (atomic_dec_and_test(&conf->active_aligned_reads))
  		wake_up(&conf->wait_for_stripe);
  	return handled;
