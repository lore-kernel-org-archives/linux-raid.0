From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and
 async writes
Date: Tue, 12 Oct 2004 17:16:48 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <416C49C0.8070906@steeleye.com>
References: <40198E85.29EBC8E0@SteelEye.com>	<16422.62911.755570.855200@notabene.cse.unsw.edu.au>	<4027E342.D02202F1@SteelEye.com>	<16424.8182.876520.280031@notabene.cse.unsw.edu.au>	<402D3A86.97CF894F@SteelEye.com>	<16456.2775.641721.204171@notabene.cse.unsw.edu.au>	<4048F9AA.1BBD67F@SteelEye.com>	<406B1024.7BF88C@SteelEye.com>	<16528.49083.998593.199805@cse.unsw.edu.au>	<40C6273B.2060200@steeleye.com>	<16590.38597.170409.499394@cse.unsw.edu.au>	<40D9FA9E.9010003@steeleye.com>	<40F7E50F.2040308@steeleye.com>	<16649.61212.310271.36561@cse.unsw.edu.au>	<4119400A.40307@steeleye.com>	<16668.12228.187383.596856@cse.unsw.edu.au>	<414F9FD4.4070308@steeleye.com>	<41507EA7.1000905@steeleye.com> <16747.15933.68499.915859@cse.unsw.edu.au> <416BE4DA.1040408@steeleye.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030700060809060405070208"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <416BE4DA.1040408@steeleye.com>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: jejb@steeleye.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------030700060809060405070208
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Neil,

patch to fix the issues mentioned below has been tested and is attached. 
Should apply on top of 2.6.9-rc2 + md_bitmap.

--
Paul


Paul Clements wrote:
> Neil Brown wrote:
> 
>>> Paul Clements wrote:
> 
> 
>>> itself. Check out the new patch here:
>>>
>>> http://parisc-linux.org/~jejb/md_bitmap/md_bitmap_2_37_2_6_9_rc2.diff
>>>
> 
>> Further comments.
>>
>> bitmap_events
>>   1/  You have inserted bitmap_event_hi/lo *before* recovery_cp, thus
>>       moving recovery_cp, and thus breaking backwards comparability.
> 
> 
> Yes. I guess when recovery_cp came along I failed to notice that...
> 
>>   2/ The test in hot_add_disk:
>> +        if (refsb && sb && uuid_equal(sb, refsb) &&
>> +            sb->events_hi >= refsb->bitmap_events_hi &&
>> +            sb->events_lo >= refsb->bitmap_events_lo) {
>> +            bitmap_invalidate = 0;
>>    is wrong.  The events count must be compared as a 64bit
>>   number. e.g. it is only meaningful to compare events_lo if both
>>   events_hi are equal.
> 
> 
> Yes, that is broken.
> 
>> pending_bio_list
>>   1/ Do you really need a separate pending_bio_lock, or would
>>      the current device_lock be adequate to the task.
> 
> 
> Probably so...especially with the following change...
> 
>>   2/  I think there can be a race with new requests being added to
>>      this list while bitmap_unplug is running in unplug_slaves.
>>      I think you should "bio_get_list" before calling bitmap_unplug,
>>      So that you only then submit requests that were made definitely
>>      *before* the call the bitmap_unplug.  This would have the added
>>      advantage that you don't need to keep claiming and dropping
>>      pending_bio_lock. 
> 
> 
> Yes, that would make sense.

--------------030700060809060405070208
Content-Type: text/plain;
 name="md_bitmap_bugfix_2_37_2_6_9_rc2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_bitmap_bugfix_2_37_2_6_9_rc2.diff"

diff -purN --exclude-from /export/public/clemep/tmp/dontdiff linux-2.6.9-rc2-BITMAP/drivers/md/md.c linux-2.6.9-rc2-BITMAP-NEW/drivers/md/md.c
--- linux-2.6.9-rc2-BITMAP/drivers/md/md.c	Tue Sep 14 14:11:07 2004
+++ linux-2.6.9-rc2-BITMAP-NEW/drivers/md/md.c	Tue Oct 12 12:23:13 2004
@@ -2375,8 +2375,9 @@ static int hot_add_disk(mddev_t * mddev,
 		if (rdev->sb_loaded)
 			sb = (mdp_super_t *)page_address(rdev->sb_page);
 		if (refsb && sb && uuid_equal(sb, refsb) &&
-		    sb->events_hi >= refsb->bitmap_events_hi &&
-		    sb->events_lo >= refsb->bitmap_events_lo) {
+		    (sb->events_hi > refsb->bitmap_events_hi ||
+		    (sb->events_hi == refsb->bitmap_events_hi &&
+		    sb->events_lo >= refsb->bitmap_events_lo))) {
 			bitmap_invalidate = 0;
 		} else if (!mddev->persistent) { /* assume bitmap is valid */
 			bitmap_invalidate = 0;
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff linux-2.6.9-rc2-BITMAP/drivers/md/raid1.c linux-2.6.9-rc2-BITMAP-NEW/drivers/md/raid1.c
--- linux-2.6.9-rc2-BITMAP/drivers/md/raid1.c	Tue Sep 14 14:13:47 2004
+++ linux-2.6.9-rc2-BITMAP-NEW/drivers/md/raid1.c	Tue Oct 12 16:23:54 2004
@@ -455,18 +455,21 @@ static void unplug_slaves(mddev_t *mddev
 	struct bio *bio;
 	unsigned long flags;
 
+	/* pull writes off the pending queue and (later) submit them */
+	spin_lock_irqsave(&conf->device_lock, flags);
+	bio = bio_list_get(&conf->pending_bio_list);
+	spin_unlock_irqrestore(&conf->device_lock, flags);
+
 	/* flush any pending bitmap writes to disk before proceeding w/ I/O */
 	if (bitmap_unplug(mddev->bitmap) != 0)
 		printk("%s: bitmap file write failed!\n", mdname(mddev));
 
-	/* pull writes off the pending queue and submit them */
-	spin_lock_irqsave(&conf->pending_bio_lock, flags);
-	while ((bio = bio_list_pop(&conf->pending_bio_list))) {
-		spin_unlock_irqrestore(&conf->pending_bio_lock, flags);
+	while (bio) { /* submit pending writes */
+		struct bio *next = bio->bi_next;
+		bio->bi_next = NULL;
 		generic_make_request(bio);
-		spin_lock_irqsave(&conf->pending_bio_lock, flags);
+		bio = next;
 	}
-	spin_unlock_irqrestore(&conf->pending_bio_lock, flags);
 
 	spin_lock_irqsave(&conf->device_lock, flags);
 	for (i=0; i<mddev->raid_disks; i++) {
@@ -666,9 +669,9 @@ static int make_request(request_queue_t 
 
 		atomic_inc(&r1_bio->remaining);
 		/* queue the write...it will be submitted when we unplug */
-		spin_lock_irqsave(&conf->pending_bio_lock, flags);
+		spin_lock_irqsave(&conf->device_lock, flags);
 		bio_list_add(&conf->pending_bio_list, mbio);
-		spin_unlock_irqrestore(&conf->pending_bio_lock, flags);
+		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
 
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
@@ -965,9 +968,9 @@ static void sync_request_write(mddev_t *
 				"while resyncing!\n", mdname(mddev), err);
 
 		/* queue the write...it will be submitted when we unplug */
-		spin_lock_irqsave(&conf->pending_bio_lock, flags);
+		spin_lock_irqsave(&conf->device_lock, flags);
 		bio_list_add(&conf->pending_bio_list, wbio);
-		spin_unlock_irqrestore(&conf->pending_bio_lock, flags);
+		spin_unlock_irqrestore(&conf->device_lock, flags);
 	}
 
 	if (atomic_dec_and_test(&r1_bio->remaining)) {
@@ -1307,7 +1310,6 @@ static int run(mddev_t *mddev)
 	init_waitqueue_head(&conf->wait_idle);
 	init_waitqueue_head(&conf->wait_resume);
 
-	conf->pending_bio_lock = SPIN_LOCK_UNLOCKED;
 	bio_list_init(&conf->pending_bio_list);
 
 	if (!conf->working_disks) {
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff linux-2.6.9-rc2-BITMAP/include/linux/raid/md_p.h linux-2.6.9-rc2-BITMAP-NEW/include/linux/raid/md_p.h
--- linux-2.6.9-rc2-BITMAP/include/linux/raid/md_p.h	Tue Sep 14 12:12:55 2004
+++ linux-2.6.9-rc2-BITMAP-NEW/include/linux/raid/md_p.h	Tue Oct 12 12:21:12 2004
@@ -133,17 +133,20 @@ typedef struct mdp_superblock_s {
 	__u32 events_lo;	/*  8 low-order of superblock update count    */
 	__u32 cp_events_hi;	/*  9 high-order of checkpoint update count   */
 	__u32 cp_events_lo;	/* 10 low-order of checkpoint update count    */
-	__u32 bitmap_events_hi;	/* 11 high-order of bitmap update count       */
-	__u32 bitmap_events_lo;	/* 12 low-order of bitmap update count        */
 #else
 	__u32 events_lo;	/*  7 low-order of superblock update count    */
 	__u32 events_hi;	/*  8 high-order of superblock update count   */
 	__u32 cp_events_lo;	/*  9 low-order of checkpoint update count    */
 	__u32 cp_events_hi;	/* 10 high-order of checkpoint update count   */
-	__u32 bitmap_events_lo;	/* 11 low-order of bitmap update count        */
+#endif
+	__u32 recovery_cp;	/* 11 recovery checkpoint sector count	      */
+#ifdef __BIG_ENDIAN
 	__u32 bitmap_events_hi;	/* 12 high-order of bitmap update count       */
+	__u32 bitmap_events_lo;	/* 13 low-order of bitmap update count        */
+#else
+	__u32 bitmap_events_lo;	/* 12 low-order of bitmap update count        */
+	__u32 bitmap_events_hi;	/* 13 high-order of bitmap update count       */
 #endif
-	__u32 recovery_cp;	/* 13 recovery checkpoint sector count	      */
 	__u32 gstate_sreserved[MD_SB_GENERIC_STATE_WORDS - 14];
 
 	/*
diff -purN --exclude-from /export/public/clemep/tmp/dontdiff linux-2.6.9-rc2-BITMAP/include/linux/raid/raid1.h linux-2.6.9-rc2-BITMAP-NEW/include/linux/raid/raid1.h
--- linux-2.6.9-rc2-BITMAP/include/linux/raid/raid1.h	Tue Sep 14 14:09:11 2004
+++ linux-2.6.9-rc2-BITMAP-NEW/include/linux/raid/raid1.h	Tue Oct 12 12:30:03 2004
@@ -37,7 +37,6 @@ struct r1_private_data_s {
 
 	/* queue pending writes and submit them on unplug */
 	struct bio_list		pending_bio_list;
-	spinlock_t		pending_bio_lock;
 
 	/* for use when syncing mirrors: */
 

--------------030700060809060405070208--
