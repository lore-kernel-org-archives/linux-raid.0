From: Michael Tokarev <mjt@tls.msk.ru>
Subject: "Robust Read" (was: [PATCH 1/2] md bitmap bug fixes)
Date: Sat, 19 Mar 2005 19:08:02 +0300
Message-ID: <423C4E62.4070704@tls.msk.ru>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <20050318171608.GA28494@percy.comedia.it> <423B4C4B.7070404@tls.msk.ru> <9phtg2-6c1.ln1@news.it.uc3m.es> <423C1C58.1090609@tls.msk.ru> <vvjtg2-t16.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000202040102070800090207"
In-Reply-To: <vvjtg2-t16.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------000202040102070800090207
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit

Peter T. Breuer wrote:
[]
> The patch was originally developed for 2.4, then ported to 2.6.3, and
> then to 2.6.8.1. Neil has recently been doing stuff, so I don't
> think it applies cleanly to 2.6.10, but somebody WAS porting it for me
> until they found that 2.6.10 didn't support their hardware ... and I
> recall discussing with him what to do about the change of map() to
> read_balance() in the code (essentially, put map() back). And finding
> that the spinlocks have changed too.

Well, it turns out current code is easier to modify, including spinlocks.

But now, with read_balance() in place, which can pick a "random" disk
to read from, we have to keep some sort of bitmap to mark disks which
we tried to read from.

For the hack below I've added r1_bio->tried_disk of type unsigned long
which has one bit per disk, so current scheme is limited to 32 disks
in array.  This is really a hack for now -- I don't know much about
kernel programming rules... ;)

> @@ -266,9 +368,19 @@
>  	/*
>  	 * this branch is our 'one mirror IO has finished' event handler:
>  	 */
> -	if (!uptodate)
> -		md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
> -	else
> +	if (!uptodate) {
> +#ifdef CONFIG_MD_RAID1_ROBUST_READ
> +	        /*
> +                 * Only fault disk out of array on write error, not read.
> +                 */
> +	        if (0)
> +#endif /* CONFIG_MD_RAID1_ROBUST_READ */
> +	        	md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
> +#ifdef DO_ADD_READ_WRITE_CORRECT

What's this?
Was it an attempt (incomplete) to do rewrite-after-failed-read?

> +	        else    /* tell next time we're here that we're a retry */
> +	                set_bit(R1BIO_ReadRetry, &r1_bio->state);
> +#endif /* DO_ADD_READ_WRITE_CORRECT */
> +        } else
>  		/*
>  		 * Set R1BIO_Uptodate in our master bio, so that
>  		 * we will return a good error code for to the higher
> @@ -285,8 +397,20 @@
>  	/*
>  	 * we have only one bio on the read side
>  	 */
> -	if (uptodate)
> -		raid_end_bio_io(r1_bio);
> +	if (uptodate
> +#ifdef CONFIG_MD_RAID1_ROBUST_READ
> +                /* Give up and error if we're last */
> +                || (atomic_dec_and_test(&r1_bio->remaining))
> +#endif /* CONFIG_MD_RAID1_ROBUST_READ */
> +                )
> +#ifdef DO_ADD_READ_WRITE_CORRECT
> +	        if (uptodate && test_bit(R1BIO_ReadRetry, &r1_bio->state)) {
> +	                /* Success at last - rewrite failed reads */
> +                        set_bit(R1BIO_IsSync, &r1_bio->state);
> +			reschedule_retry(r1_bio);
> +		} else
> +#endif /* DO_ADD_READ_WRITE_CORRECT */
> +			raid_end_bio_io(r1_bio);

Hmm.  Should we do actual write here, instead of rescheduling a
successeful read further, after finishing the original request?

/mjt

--------------000202040102070800090207
Content-Type: text/plain;
 name="raid1_robust_read-2.6.11.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="raid1_robust_read-2.6.11.diff"

--- ./include/linux/raid/raid1.h.orig	Wed Mar  2 10:38:10 2005
+++ ./include/linux/raid/raid1.h	Sat Mar 19 18:53:42 2005
@@ -83,6 +83,7 @@ struct r1bio_s {
 	 * if the IO is in READ direction, then this is where we read
 	 */
 	int			read_disk;
+	unsigned long		tried_disks;	/* bitmap, disks we had tried to read from */
 
 	struct list_head	retry_list;
 	/*
--- ./drivers/md/raid1.c.orig	Wed Mar  2 10:38:10 2005
+++ ./drivers/md/raid1.c	Sat Mar 19 18:57:16 2005
@@ -234,9 +234,13 @@ static int raid1_end_read_request(struct
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
-	if (!uptodate)
-		md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
-	else
+
+	update_head_pos(mirror, r1_bio);
+
+	/*
+	 * we have only one bio on the read side
+	 */
+	if (uptodate) {
 		/*
 		 * Set R1BIO_Uptodate in our master bio, so that
 		 * we will return a good error code for to the higher
@@ -247,14 +251,8 @@ static int raid1_end_read_request(struct
 		 * wait for the 'master' bio.
 		 */
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
-
-	update_head_pos(mirror, r1_bio);
-
-	/*
-	 * we have only one bio on the read side
-	 */
-	if (uptodate)
 		raid_end_bio_io(r1_bio);
+	}
 	else {
 		/*
 		 * oops, read error:
@@ -332,6 +330,10 @@ static int raid1_end_write_request(struc
  *
  * The rdev for the device selected will have nr_pending incremented.
  */
+
+#define disk_tried_before(r1_bio, disk)	((r1_bio)->tried_disks & (1<<(disk)))
+#define mark_disk_tried(r1_bio, disk)	((r1_bio)->tried_disks |= 1<<(disk))
+
 static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 {
 	const unsigned long this_sector = r1_bio->sector;
@@ -351,7 +353,8 @@ static int read_balance(conf_t *conf, r1
 		new_disk = 0;
 
 		while (!conf->mirrors[new_disk].rdev ||
-		       !conf->mirrors[new_disk].rdev->in_sync) {
+		       !conf->mirrors[new_disk].rdev->in_sync ||
+		       disk_tried_before(r1_bio, new_disk)) {
 			new_disk++;
 			if (new_disk == conf->raid_disks) {
 				new_disk = -1;
@@ -364,7 +367,8 @@ static int read_balance(conf_t *conf, r1
 
 	/* make sure the disk is operational */
 	while (!conf->mirrors[new_disk].rdev ||
-	       !conf->mirrors[new_disk].rdev->in_sync) {
+	       !conf->mirrors[new_disk].rdev->in_sync ||
+	       disk_tried_before(r1_bio, new_disk)) {
 		if (new_disk <= 0)
 			new_disk = conf->raid_disks;
 		new_disk--;
@@ -394,7 +398,8 @@ static int read_balance(conf_t *conf, r1
 		disk--;
 
 		if (!conf->mirrors[disk].rdev ||
-		    !conf->mirrors[disk].rdev->in_sync)
+		    !conf->mirrors[disk].rdev->in_sync ||
+		    disk_tried_before(r1_bio, new_disk))
 			continue;
 
 		if (!atomic_read(&conf->mirrors[disk].rdev->nr_pending)) {
@@ -415,6 +420,7 @@ rb_out:
 		conf->next_seq_sect = this_sector + sectors;
 		conf->last_used = new_disk;
 		atomic_inc(&conf->mirrors[new_disk].rdev->nr_pending);
+		mark_disk_tried(r1_bio, new_disk);
 	}
 	rcu_read_unlock();
 
@@ -545,6 +551,7 @@ static int make_request(request_queue_t 
 	r1_bio->sector = bio->bi_sector;
 
 	r1_bio->state = 0;
+	r1_bio->tried_disks = 0;
 
 	if (bio_data_dir(bio) == READ) {
 		/*

--------------000202040102070800090207--
