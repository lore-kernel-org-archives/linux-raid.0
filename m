From: Neil Brown <neilb@suse.de>
Subject: Re: change strip_cache_size freeze the whole raid
Date: Thu, 25 Jan 2007 13:29:00 +1100
Message-ID: <17848.5612.67226.874822@notabene.brown>
References: <001801c73e14$c3177170$28df0f3d@kylecea1512a3f>
	<17845.7488.24108.298825@notabene.brown>
	<Pine.LNX.4.64.0701241822040.16771@p34.internal.lan>
	<17847.63039.766387.855859@notabene.brown>
	<Pine.LNX.4.64.0701241915550.4070@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Justin Piszcz on Wednesday January 24
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: kyle <kylewong@southa.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday January 24, jpiszcz@lucidpixels.com wrote:
> 
> Okay-- thanks for the explanation and I will await a future patch..
> 

This would be that patch.  It doesn't seem to break anything, but I
haven't reproduced he bug yet (I think I need to reduce the amount of
memory I have available) so I haven't demonstrated that this fixes it.

Thanks,
NeilBrown


---------------------
Fix potential memalloc deadlock in md

If a GFP_KERNEL allocation is attempted in md while the mddev_lock is
held, it is possible for a deadlock to eventuate.
This happens if the array was marked 'clean', and the memalloc triggers 
a write-out to the md device.
For the writeout to succeed, the array must be marked 'dirty', and that 
requires getting the mddev_lock.

So, before attempting a GFP_KERNEL alloction while holding the lock,
make sure the array is marked 'dirty' (unless it is currently read-only).


Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c         |   29 +++++++++++++++++++++++++++++
 ./drivers/md/raid1.c      |    2 ++
 ./drivers/md/raid5.c      |    3 +++
 ./include/linux/raid/md.h |    2 +-
 4 files changed, 35 insertions(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-01-23 11:23:58.000000000 +1100
+++ ./drivers/md/md.c	2007-01-25 12:47:58.000000000 +1100
@@ -3564,6 +3564,8 @@ static int get_bitmap_file(mddev_t * mdd
 	char *ptr, *buf = NULL;
 	int err = -ENOMEM;
 
+	md_allow_write(mddev);
+
 	file = kmalloc(sizeof(*file), GFP_KERNEL);
 	if (!file)
 		goto out;
@@ -5032,6 +5034,33 @@ void md_write_end(mddev_t *mddev)
 	}
 }
 
+/* md_allow_write(mddev)
+ * Calling this ensures that the array is marked 'active' so that writes
+ * may proceed without blocking.  It is important to call this before
+ * attempting a GFP_KERNEL allocation while holding the mddev lock.
+ * Must be called with mddev_lock held.
+ */
+void md_allow_write(mddev_t *mddev)
+{
+	if (!mddev->pers)
+		return;
+	if (mddev->ro)
+		return;
+
+	spin_lock_irq(&mddev->write_lock);
+	if (mddev->in_sync) {
+		mddev->in_sync = 0;
+		set_bit(MD_CHANGE_CLEAN, &mddev->flags);
+		if (mddev->safemode_delay &&
+		    mddev->safemode == 0)
+			mddev->safemode = 1;
+		spin_unlock_irq(&mddev->write_lock);
+		md_update_sb(mddev, 0);
+	} else
+		spin_unlock_irq(&mddev->write_lock);
+}
+EXPORT_SYMBOL_GPL(md_allow_write);
+
 static DECLARE_WAIT_QUEUE_HEAD(resync_wait);
 
 #define SYNC_MARKS	10

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2007-01-23 11:23:43.000000000 +1100
+++ ./drivers/md/raid1.c	2007-01-25 12:09:43.000000000 +1100
@@ -2050,6 +2050,8 @@ static int raid1_reshape(mddev_t *mddev)
 		return -EINVAL;
 	}
 
+	md_allow_write(mddev);
+
 	raid_disks = mddev->raid_disks + mddev->delta_disks;
 
 	if (raid_disks < conf->raid_disks) {

diff .prev/drivers/md/raid5.c ./drivers/md/raid5.c
--- .prev/drivers/md/raid5.c	2007-01-23 11:13:44.000000000 +1100
+++ ./drivers/md/raid5.c	2007-01-25 12:18:04.000000000 +1100
@@ -399,6 +399,8 @@ static int resize_stripes(raid5_conf_t *
 	if (newsize <= conf->pool_size)
 		return 0; /* never bother to shrink */
 
+	md_allow_write(conf->mddev);
+
 	/* Step 1 */
 	sc = kmem_cache_create(conf->cache_name[1-conf->active_name],
 			       sizeof(struct stripe_head)+(newsize-1)*sizeof(struct r5dev),
@@ -3195,6 +3197,7 @@ raid5_store_stripe_cache_size(mddev_t *m
 		else
 			break;
 	}
+	md_allow_write(mddev);
 	while (new > conf->max_nr_stripes) {
 		if (grow_one_stripe(conf))
 			conf->max_nr_stripes++;

diff .prev/include/linux/raid/md.h ./include/linux/raid/md.h
--- .prev/include/linux/raid/md.h	2007-01-25 12:16:57.000000000 +1100
+++ ./include/linux/raid/md.h	2007-01-25 12:17:18.000000000 +1100
@@ -93,7 +93,7 @@ extern int sync_page_io(struct block_dev
 			struct page *page, int rw);
 extern void md_do_sync(mddev_t *mddev);
 extern void md_new_event(mddev_t *mddev);
-
+extern void md_allow_write(mddev_t *mddev);
 
 #endif /* CONFIG_MD */
 #endif 
