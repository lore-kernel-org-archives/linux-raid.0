From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [patch] md superblock update failures
Date: Wed, 16 Mar 2005 14:22:46 +0100
Message-ID: <20050316132246.GM5305@marowsky-bree.de>
References: <20050316130512.GK5305@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="lEGEL1/lMxI0MVQ2"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
In-Reply-To: <20050316130512.GK5305@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On 2005-03-16T14:05:12, Lars Marowsky-Bree <lmb@suse.de> wrote:

> Mark found a bug where md doesn't handle write failures when trying to
> update the superblock.
> 
> Attached is the fix he sent to us, and which seems to apply fine to
> 2.6.11 too.

Oops, sorry. Broken diff due to yours truely. Attached patch actually
compiles.


Sincerely,
    Lars Marowsky-Brée <lmb@suse.de>

-- 
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX Products GmbH - A Novell Business


--lEGEL1/lMxI0MVQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=md-superblock-failures

From: Mark Rustad
Subject: md does not handle write failures for the superblock
Patch-mainline: 2.6.12
References: 65306

Description by Mark:

I have found that superblock updates that experience write failures to a
raid component device, do not fail the device out of the raid. This
results in the raid superblock being updated 100 times and ultimately
simply fails. It takes a different type of failing access to the failed
device to finally fail the device out of the raid. This can be seen by
simply pulling out a raid device in an idle system (but with sgraidmon &
mdadmd running).

The following patch will fail the failing device out of the raid after
the attempted superblock update and then retry the update with one fewer
device.  This seems to work very well in our system.
 
 
Acked-by: Jens Axboe <axboe@suse.de>
Signed-off-by: Lars Marowsky-Bree <lmb@suse.de>

Index: linux-2.6.5/drivers/md/md.c
===================================================================
--- linux-2.6.5.orig/drivers/md/md.c	2005-03-16 13:57:10.381445927 +0100
+++ linux-2.6.5/drivers/md/md.c	2005-03-16 13:57:10.714396523 +0100
@@ -1115,6 +1115,7 @@ static void export_array(mddev_t *mddev)
 {
 	struct list_head *tmp;
 	mdk_rdev_t *rdev;
+	mdk_rdev_t *frdev;
 
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		if (!rdev->mddev) {
@@ -1288,6 +1289,7 @@ repeat:
 		mdname(mddev),mddev->in_sync);
 
 	err = 0;
+	frdev = 0;
 	ITERATE_RDEV(mddev,rdev,tmp) {
 		char b[BDEVNAME_SIZE];
 		dprintk(KERN_INFO "md: ");
@@ -1296,13 +1298,21 @@ repeat:
 
 		dprintk("%s ", bdevname(rdev->bdev,b));
 		if (!rdev->faulty) {
-			err += write_disk_sb(rdev);
+			int ret;
+			ret = write_disk_sb(rdev);
+			if (ret) {
+				frdev = rdev;	/* Save failed device */
+				err += ret;
+			}
 		} else
 			dprintk(")\n");
 		if (!err && mddev->level == LEVEL_MULTIPATH)
 			/* only need to write one superblock... */
 			break;
 	}
+	if (frdev)
+		md_error(mddev, frdev);	/* Fail the failed device */
+
 	if (err) {
 		if (--count) {
 			printk(KERN_ERR "md: errors occurred during superblock"

--lEGEL1/lMxI0MVQ2--
