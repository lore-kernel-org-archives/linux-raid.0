From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: "Robust Read"
Date: Sun, 20 Mar 2005 01:05:19 +0300
Message-ID: <423CA21F.9060503@tls.msk.ru>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <20050318171608.GA28494@percy.comedia.it> <423B4C4B.7070404@tls.msk.ru> <9phtg2-6c1.ln1@news.it.uc3m.es> <423C1C58.1090609@tls.msk.ru> <vvjtg2-t16.ln1@news.it.uc3m.es> <423C4E62.4070704@tls.msk.ru> <gj2ug2-9q3.ln1@news.it.uc3m.es> <423C897B.1030100@tls.msk.ru> <19gug2-0bj.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060108060107090806050509"
In-Reply-To: <19gug2-0bj.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------060108060107090806050509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Peter T. Breuer wrote:
> Michael Tokarev <mjt@tls.msk.ru> wrote:
[]
> But your approach is fine - it's just that (a) I don't like to mess
> with the struct sizes, as that makes modules binary incompatible,
> instead of just having extra functionalities, and (b) I really think
> it's not going to be easily maintainable to subvert read_balance, and
> (c), it fragments the patch more, and (d), I really think you only need
> to count and pray, not keep an exact map.

The point a) is moot, because this whole structure is used in raid1.c ONLY.
(I don't know why it is placed into raid1.h header file instead of into
raid1.c directly, but that's a different topic).

> Maybe if you were to use the existing "remaining" field for the birmap,
> you would get rid of objection (a)! :-). You could even rename it via a
> #define :-).

atomic_t has its own API, it can't be used for &= and |= operations for
example.

>>BTW, what's the reason to use raid1d for retries in the first place?
>>Why not just resubmit the request in reschedule_retry() directly,
>>the same way it is done in raid1d?
> 
> No reason that I recall.  Isn't raid1d going to do it offline?  You want
> to do it sync instead?  Anyway, the rerite code is completely
> uninvestigated, so please try anything you like!

I asked about retrying failed read, not about re-writes.

[]
>>>>+       r1_bio->tried_disks = 0;
>>>
>>>Hmm. Ditto. I suppose we are making the read request here. Yes we are.
>>>I had set the "remaining" count instead.

Note in your version you have a chance to request a read from
first disk again, in case you have some failed/missing disks.

So i think that instead of usage of "remaining" field, it's better
to remember the disk from which we did the first read, and loop
over all disks up to the first one.

/mjt

--------------060108060107090806050509
Content-Type: text/plain;
 name="raid1_robust_read-2.6.11.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="raid1_robust_read-2.6.11.diff"

--- ./include/linux/raid/raid1.h.orig	Wed Mar  2 10:38:10 2005
+++ ./include/linux/raid/raid1.h	Sun Mar 20 00:50:59 2005
@@ -83,6 +83,7 @@ struct r1bio_s {
 	 * if the IO is in READ direction, then this is where we read
 	 */
 	int			read_disk;
+	unsigned long		first_disk;	/* disk we started read from */
 
 	struct list_head	retry_list;
 	/*
--- ./drivers/md/raid1.c.orig	Wed Mar  2 10:38:10 2005
+++ ./drivers/md/raid1.c	Sun Mar 20 00:51:57 2005
@@ -231,12 +231,13 @@ static int raid1_end_read_request(struct
 		return 1;
 	
 	mirror = r1_bio->read_disk;
+
+	update_head_pos(mirror, r1_bio);
+
 	/*
-	 * this branch is our 'one mirror IO has finished' event handler:
+	 * we have only one bio on the read side
 	 */
-	if (!uptodate)
-		md_error(r1_bio->mddev, conf->mirrors[mirror].rdev);
-	else
+	if (uptodate) {
 		/*
 		 * Set R1BIO_Uptodate in our master bio, so that
 		 * we will return a good error code for to the higher
@@ -247,14 +248,8 @@ static int raid1_end_read_request(struct
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
@@ -421,6 +416,42 @@ rb_out:
 	return new_disk;
 }
 
+/*
+ * This routine returns the disk from which the requested read should
+ * be done in case previous read failed.  We don't try to optimize
+ * read positions here as in read_balance().
+ *
+ * The rdev for the device selected will have nr_pending incremented.
+ */
+static int read_remap(conf_t *conf, r1bio_t *r1_bio)
+{
+	int disk;
+	int first_disk;
+
+	rcu_read_lock();
+
+	/* Choose the next operation device */
+	first_disk = r1_bio->first_disk;
+	disk = r1_bio->read_disk;
+
+	do {
+		++disk;
+		if (disk >= conf->raid_disks)
+			disk = 0;
+		if (disk == first_disk) {
+			rcu_read_unlock();
+			return -1;
+		}
+	} while (!conf->mirrors[disk].rdev ||
+	         !conf->mirrors[disk].rdev->in_sync);
+
+	/* don't bother updating last position */
+	atomic_inc(&conf->mirrors[disk].rdev->nr_pending);
+	rcu_read_unlock();
+
+	return disk;
+}
+
 static void unplug_slaves(mddev_t *mddev)
 {
 	conf_t *conf = mddev_to_conf(mddev);
@@ -560,6 +591,7 @@ static int make_request(request_queue_t 
 		mirror = conf->mirrors + rdisk;
 
 		r1_bio->read_disk = rdisk;
+		r1_bio->first_disk = rdisk;
 
 		read_bio = bio_clone(bio, GFP_NOIO);
 
@@ -934,7 +966,7 @@ static void raid1d(mddev_t *mddev)
 		} else {
 			int disk;
 			bio = r1_bio->bios[r1_bio->read_disk];
-			if ((disk=read_balance(conf, r1_bio)) == -1) {
+			if ((disk=read_remap(conf, r1_bio)) < 0) {
 				printk(KERN_ALERT "raid1: %s: unrecoverable I/O"
 				       " read error for block %llu\n",
 				       bdevname(bio->bi_bdev,b),

--------------060108060107090806050509--
