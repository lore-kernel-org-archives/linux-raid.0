From: Lars Ellenberg <Lars.Ellenberg@linbit.com>
Subject: [patch] latency problem in md driver
Date: Fri, 22 Dec 2006 15:32:16 +0100
Message-ID: <20061222143215.GD7477@soda.linbit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Ingo Molnar <mingo@redhat.com>, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


md raidX make_request functions strip off the BIO_RW_SYNC flag,
this introducing additional latency.

below is a suggested patch for the raid1.c .
other suggested solutions would be to let the bio_clone do its work,
and not reassign thereby stripping off all flags.
at most strip off known unwanted flags (the BARRIER flag).

similar pattern in the other raid versions.

cheers,

	Lars


--- /mnt/kernel-src/linux-2.6.19/drivers/md/raid1.c.orig	2006-12-11 10:06:17.661776243 +0100
+++ /mnt/kernel-src/linux-2.6.19/drivers/md/raid1.c	2006-12-12 11:09:55.975762364 +0100
@@ -776,6 +776,7 @@ static int make_request(request_queue_t 
 	struct page **behind_pages = NULL;
 	const int rw = bio_data_dir(bio);
 	int do_barriers;
+	int do_sync = bio_sync(bio);
 
 	/*
 	 * Register the new request and wait if the reconstruction
@@ -835,7 +836,7 @@ static int make_request(request_queue_t 
 		read_bio->bi_sector = r1_bio->sector + mirror->rdev->data_offset;
 		read_bio->bi_bdev = mirror->rdev->bdev;
 		read_bio->bi_end_io = raid1_end_read_request;
-		read_bio->bi_rw = READ;
+		read_bio->bi_rw = READ | do_sync;
 		read_bio->bi_private = r1_bio;
 
 		generic_make_request(read_bio);
@@ -906,7 +907,7 @@ static int make_request(request_queue_t 
 		mbio->bi_sector	= r1_bio->sector + conf->mirrors[i].rdev->data_offset;
 		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
 		mbio->bi_end_io	= raid1_end_write_request;
-		mbio->bi_rw = WRITE | do_barriers;
+		mbio->bi_rw = WRITE | do_barriers | do_sync;
 		mbio->bi_private = r1_bio;
 
 		if (behind_pages) {


-- 
: Lars Ellenberg                            Tel +43-1-8178292-55 :
: LINBIT Information Technologies GmbH      Fax +43-1-8178292-82 :
: Vivenotgasse 48, A-1120 Vienna/Europe    http://www.linbit.com :
