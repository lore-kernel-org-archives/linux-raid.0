From: Doug Ledford <dledford@redhat.com>
Subject: Re: Raid 1 - md "Total Disks" question
Date: Thu, 16 Sep 2004 18:34:26 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1095374065.4196.22.camel@compaq.xsintricity.com>
References: <019801c499ab$405f20d0$6800a8c0@Agus>
	 <16710.16837.832998.503557@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-MG0gM+bLuM4kwGXodZ+t"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16710.16837.832998.503557@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: =?ISO-8859-1?Q?Agust=EDn?= Ciciliani <agustin@maderonet.net.ar>, linux-raid@vger.kernel.org, Marcelo Tosatti <marcelo.tosatti@cyclades.com>
List-Id: linux-raid.ids


--=-MG0gM+bLuM4kwGXodZ+t
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2004-09-13 at 20:56, Neil Brown wrote:
> On Monday September 13, agustin@maderonet.net.ar wrote:
> > Hi Everybody,
> > 
> > I was wondering if you could take a look to the following and give some advice... I just
> > have TWO SATA WD800 disks and "mdadm" says I have "three" and one of
> > them has "failed"!!!
> 
> It's just some odd accounting in the kernel.  Don't worry about it.

It is just some odd accounting stuff, but it's hardly something I would
say "don't worry about it".  I had to chase a similar looking problem
down in our RHEL3 product line.  In fact, it was raid1 where I was
seeing this problem.  I've attached the email I sent about the problem
to the internal kernel people, the patch I originally sent in for it,
and the update patch that catches a couple spots I originally missed in
my first patch (apologies if my mailer horks this up, haven't tried to
send sent mail in exactly the way I'm trying it now).

           From: 
Doug Ledford
<dledford@redhat.com>
             To: 

        Subject: 
[Taroon patch]
RAID1 oops fix
           Date: 
Mon, 21 Jun 2004
10:14:09 -0400

Relevant bz121616

OK, basic problem is that if you use mdadm to fail a device in a raid1
array and then immediately remove that device, you can end up triggering
a race condition in the raid1 code.  This only shows up on SMP systems
(and the one I have here which is a 2 physical, 4 logical processor
system shows it very easily, but for some reason nmi_watchdog didn't
ever help and the system always just locked hard and refused to do
anything, so I didn't have an oops to work from, just a hardlock).

In the raid1 code, we keep an array of devices that are part of the
raid1 array.  Each of these devices can have multiple states, but for
the most part we check the operational bit of a device before deciding
to use it.  If we decide to use that device, then we grab the device
number from the array (kdev_t, aka this is the device's major/minor and
is what we are going to pass to generic_make_request in order to pass
the buffer head on to the underlying device).

When we fail a device, we set that operational bit to 0.  When we remove
a device, we also set the dev item in the struct to MKDEV(0,0).

There is no locking whatsoever between the failing of a device (setting
the operational bit to 0) and the make_request functions in the raid1
code.  So, even though it's safe to fail a device without this locking,
before we can safely remove the device we need to know that every
possible context that might be checking that operational bit has in fact
seen the failed operational bit.  If not, then we can end up setting the
dev to 0, then the other context grabs it and tries to pass that off to
generic_make_request, unnice things ensue.

So, this patch does these things:

     1. Whenever we are calling mark_disk_bad(), hold the
        conf->device_lock
     2. Whenever we are walking the device array looking for an
        operational device, always grab the conf->device_lock first and
        hold it until after we have gotten not only the operational bit
        but also the dev number for the device
     3. Correct an accounting problem in the superblock.  If we fail a
        device and it's currently counted as a spare device instead of
        an active device, then we failed to decrement the superblocks
        spare disk count.  This accounting error is preserved across
        shutdown and restart of the array, and although it doesn't oops
        the kernel (the kernel will refuse to try and read beyond disk
        26 even if the spare count indicates it should, although I'm not
        sure it doesn't try and write past 26 so this could be a disk
        corruptor when the spare count + active counts exceeds the
        amount of space available in the on disk superblock format) it
        does in fact cause mdadm to segfault on trying to read the
        superblock.

So, that's the description.  Testing.  Well, without this patch, my test
machine dies on the following command *very* quickly:

while true; do mdadm /dev/md0 -f /dev/sdc1 -r /dev/sdc1 -a /dev/sdc1;
sleep 1; done

In addition, without the patch you can watch the superblock's spare
count go up with every single invocation of that command.

With my patch, the same machine survived the above command running over
the weekend, and in addition I mounted the raid1 array and ran a
continuous loop of bonnie++ sessions to generate as much load as
possible.  I've verified that the spare count stays consistent when
failing a spare device, and I've verfied that once a device is synced up
then the spare count is also decremented as the device is switched to
being accounted as an active device.

-- 
Doug Ledford <dledford@redhat.com>

--=-MG0gM+bLuM4kwGXodZ+t
Content-Disposition: attachment; filename=bz121616.patch
Content-Type: text/x-patch; name=bz121616.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -Nru a/drivers/md/raid1.c b/drivers/md/raid1.c
--- a/drivers/md/raid1.c	2004-06-21 09:27:24 -04:00
+++ b/drivers/md/raid1.c	2004-06-21 09:27:24 -04:00
@@ -325,18 +325,22 @@
 {
 	raid1_conf_t *conf = mddev_to_conf(mddev);
 	int i, disks = MD_SB_DISKS;
+	unsigned long flags;
 
 	/*
 	 * Later we do read balancing on the read side 
 	 * now we use the first available disk.
 	 */
 
+	md_spin_lock_irqsave(&conf->device_lock, flags);
 	for (i = 0; i < disks; i++) {
 		if (conf->mirrors[i].operational) {
 			*rdev = conf->mirrors[i].dev;
+			md_spin_unlock_irqrestore(&conf->device_lock, flags);
 			return (0);
 		}
 	}
+	md_spin_unlock_irqrestore(&conf->device_lock, flags);
 
 	printk (KERN_ERR "raid1_map(): huh, no more operational devices?\n");
 	return (-1);
@@ -581,6 +585,7 @@
 	int disks = MD_SB_DISKS;
 	int i, sum_bhs = 0;
 	struct mirror_info *mirror;
+	kdev_t dev;
 
 	if (!buffer_locked(bh))
 		BUG();
@@ -624,13 +629,16 @@
 		/*
 		 * read balancing logic:
 		 */
+		spin_lock_irq(&conf->device_lock);
 		mirror = conf->mirrors + raid1_read_balance(conf, bh);
+		dev = mirror->dev;
+		spin_unlock_irq(&conf->device_lock);
 
 		bh_req = &r1_bh->bh_req;
 		memcpy(bh_req, bh, sizeof(*bh));
 		bh_req->b_blocknr = bh->b_rsector;
-		bh_req->b_dev = mirror->dev;
-		bh_req->b_rdev = mirror->dev;
+		bh_req->b_dev = dev;
+		bh_req->b_rdev = dev;
 	/*	bh_req->b_rsector = bh->n_rsector; */
 		bh_req->b_end_io = raid1_end_request;
 		bh_req->b_private = r1_bh;
@@ -643,6 +651,7 @@
 	 */
 
 	bhl = raid1_alloc_bh(conf, conf->raid_disks);
+	spin_lock_irq(&conf->device_lock);
 	for (i = 0; i < disks; i++) {
 		struct buffer_head *mbh;
 		if (!conf->mirrors[i].operational) 
@@ -691,6 +700,7 @@
 		r1_bh->mirror_bh_list = mbh;
 		sum_bhs++;
 	}
+	spin_unlock_irq(&conf->device_lock);
 	if (bhl) raid1_free_bh(conf,bhl);
 	if (!sum_bhs) {
 		/* Gag - all mirrors non-operational.. */
@@ -760,6 +770,8 @@
 	mark_disk_inactive(sb->disks+mirror->number);
 	if (!mirror->write_only)
 		sb->active_disks--;
+	else
+		sb->spare_disks--;
 	sb->working_disks--;
 	sb->failed_disks++;
 	mddev->sb_dirty = 1;
@@ -776,6 +788,7 @@
 	struct mirror_info * mirrors = conf->mirrors;
 	int disks = MD_SB_DISKS;
 	int i;
+	unsigned long flags;
 
 	/* Find the drive.
 	 * If it is not operational, then we have already marked it as dead
@@ -797,7 +810,9 @@
 
 		return 1;
 	}
+	md_spin_lock_irqsave(&conf->device_lock, flags);
 	mark_disk_bad(mddev, i);
+	md_spin_unlock_irqrestore(&conf->device_lock, flags);
 	return 0;
 }
 
@@ -865,7 +880,6 @@
 	mdp_disk_t *failed_desc, *spare_desc, *added_desc;
 	mdk_rdev_t *spare_rdev, *failed_rdev;
 
-	print_raid1_conf(conf);
 
 	switch (state) {
 	case DISKOP_SPARE_ACTIVE:
@@ -876,6 +890,10 @@
 
 	md_spin_lock_irq(&conf->device_lock);
 	/*
+	 * Need the conf lock when printing out state else we get BUG()s
+	 */
+	print_raid1_conf(conf);
+	/*
 	 * find the disk ...
 	 */
 	switch (state) {
@@ -1125,12 +1143,12 @@
 		goto abort;
 	}
 abort:
+	print_raid1_conf(conf);
 	md_spin_unlock_irq(&conf->device_lock);
 	if (state == DISKOP_SPARE_ACTIVE || state == DISKOP_SPARE_INACTIVE)
 		/* should move to "END_REBUILD" when such exists */
 		raid1_shrink_buffers(conf);
 
-	print_raid1_conf(conf);
 	return err;
 }
 
@@ -1362,6 +1380,7 @@
 	int disk;
 	int block_nr;
 	int buffs;
+	kdev_t dev;
 
 	if (!sector_nr) {
 		/* we want enough buffers to hold twice the window of 128*/
@@ -1415,6 +1434,7 @@
 	 * could dedicate one to rebuild and others to
 	 * service read requests ..
 	 */
+	spin_lock_irq(&conf->device_lock);
 	disk = conf->last_used;
 	/* make sure disk is operational */
 	while (!conf->mirrors[disk].operational) {
@@ -1426,6 +1446,8 @@
 	conf->last_used = disk;
 	
 	mirror = conf->mirrors+conf->last_used;
+	dev = mirror->dev;
+	spin_unlock_irq(&conf->device_lock);
 	
 	r1_bh = raid1_alloc_buf (conf);
 	r1_bh->master_bh = NULL;
@@ -1442,8 +1464,8 @@
 	}
 	bh->b_size = bsize;
 	bh->b_list = BUF_LOCKED;
-	bh->b_dev = mirror->dev;
-	bh->b_rdev = mirror->dev;
+	bh->b_dev = dev;
+	bh->b_rdev = dev;
 	bh->b_state = (1<<BH_Req) | (1<<BH_Mapped) | (1<<BH_Lock);
 	if (!bh->b_page)
 		BUG();

--=-MG0gM+bLuM4kwGXodZ+t
Content-Disposition: attachment; filename=raid1oopsupdate.patch
Content-Type: text/x-patch; name=raid1oopsupdate.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -Nru a/drivers/md/raid1.c b/drivers/md/raid1.c
--- a/drivers/md/raid1.c	2004-06-23 23:41:54 -04:00
+++ b/drivers/md/raid1.c	2004-06-23 23:41:54 -04:00
@@ -1203,6 +1203,7 @@
 				
 				conf = mddev_to_conf(mddev);
 				bhl = raid1_alloc_bh(conf, conf->raid_disks); /* don't really need this many */
+				spin_lock_irq(&conf->device_lock);
 				for (i = 0; i < disks ; i++) {
 					if (!conf->mirrors[i].operational)
 						continue;
@@ -1245,6 +1246,7 @@
 
 					sum_bhs++;
 				}
+				spin_unlock_irq(&conf->device_lock);
 				md_atomic_set(&r1_bh->remaining, sum_bhs);
 				if (bhl) raid1_free_bh(conf, bhl);
 				mbh = r1_bh->mirror_bh_list;

--=-MG0gM+bLuM4kwGXodZ+t--

