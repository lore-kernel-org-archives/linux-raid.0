From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] md - 8 of 8 - Support reshaping raid1 arrays - adding
 or removing drives.
Date: Fri, 28 May 2004 18:41:30 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16566.64314.889124.856138@cse.unsw.edu.au>
References: <20040528163700.9426.patches@notabene>
	<E1BTb7N-0002U9-H3@notabene.cse.unsw.edu.au>
	<20040528003116.6ed21a94.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andrew Morton on Friday May 28
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 28, akpm@osdl.org wrote:
> NeilBrown <neilb@cse.unsw.edu.au> wrote:
> >
> > This requires allocating a new pool of "r1bio" structures which a different
> >  number of bios, suspending IO, and swapping the new pool in place of the old.
> >  (and a few other related changes).
> 
> Wanna send me the missing hunk?
> 

Blush. thats what you get for writing your own patch management
software...




diff ./include/linux/raid/raid1.h~current~ ./include/linux/raid/raid1.h
--- ./include/linux/raid/raid1.h~current~	2004-05-28 18:30:13.000000000 +1000
+++ ./include/linux/raid/raid1.h	2004-05-28 18:36:52.000000000 +1000
@@ -10,6 +10,20 @@ struct mirror_info {
 	sector_t	head_position;
 };
 
+/*
+ * memory pools need a pointer to the mddev, so they can force an unplug
+ * when memory is tight, and a count of the number of drives that the
+ * pool was allocated for, so they know how much to allocate and free.
+ * mddev->raid_disks cannot be used, as it can change while a pool is active
+ * These two datums are stored in a kmalloced struct.
+ */
+
+struct pool_info {
+	mddev_t *mddev;
+	int	raid_disks;
+};
+
+
 typedef struct r1bio_s r1bio_t;
 
 struct r1_private_data_s {
@@ -31,6 +45,8 @@ struct r1_private_data_s {
 	wait_queue_head_t	wait_idle;
 	wait_queue_head_t	wait_resume;
 
+	struct pool_info	*poolinfo;
+
 	mempool_t *r1bio_pool;
 	mempool_t *r1buf_pool;
 };

