From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Question about recovery via mdadm
Date: Mon, 17 Feb 2003 09:09:53 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15952.3121.511942.788471@notabene.cse.unsw.edu.au>
References: <A5974D8E5F98D511BB910002A50A66470580D627@hdsmsx103.hd.intel.com>
	<15948.9979.534439.238616@notabene.cse.unsw.edu.au>
	<28330000.1045391539@shieldbreaker.l33tskillz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from James Ralston on Sunday February 16
To: James Ralston <qralston+ml.linux-raid@andrew.cmu.edu>
Cc: "Cress, Andrew R" <andrew.r.cress@intel.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 16, qralston+ml.linux-raid@andrew.cmu.edu wrote:
> On 2003-02-14 at 10:15:07+1100 Neil Brown <neilb@cse.unsw.edu.au> wrote:
> 
> > On Thursday February 13, andrew.r.cress@intel.com wrote:
> > 
> > > Solving why I got into this is another issue, but: Is there any
> > > way, once I'm in this predicament, to force a recovery to the
> > > spare, from userland (via mdadm)?
> > 
> > No.  Reconstrution should start automatically.  There is no
> > mechanism to start it from user-space.  You could try to hot-remove
> > and hot-add again, but if it didn't work the first time it is
> > unlikely to work the second time.
> > 
> > It would appear to be a kernel bug.  Are there any kernel messages?
> > An Oops or something?
> 
> I'll bet that if Andrew checks his syslog carefully, he'll find that
> the mdrecovery process generated a kernel Oops:
> 
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=82815

Thanks...
I think that bug should be fixed by the follow patch which has been
submitted and accepted and should be in 2.4.21.

NeilBrown


-----------------------------------------
Avoid races by never  releasing rdev->sb for faulty devices.

There are races relating to the superblocks being written out
just as a device has failed, and the rdev->sb getting freeing while
it is being written out.  This patch tries to avoid one of the
races by testing the faulty bit in the superblock (which gets set
early) as well as rdev->faulty (which gets set late), and does not
free rdev->sb until the rdev is fully removed, thus making the races
less critical.




 ----------- Diffstat output ------------
 ./drivers/md/md.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2003-01-03 10:25:44.000000000 +1100
+++ ./drivers/md/md.c	2003-01-03 10:25:43.000000000 +1100
@@ -1048,7 +1048,11 @@ repeat:
 			printk("(skipping faulty ");
 		if (rdev->alias_device)
 			printk("(skipping alias ");
-
+		if (disk_faulty(&rdev->sb->this_disk)) {
+			printk("(skipping new-faulty %s )\n",
+			       partition_name(rdev->dev));
+			continue;
+		}
 		printk("%s ", partition_name(rdev->dev));
 		if (!rdev->faulty && !rdev->alias_device) {
 			printk("[events: %08lx]",
@@ -1075,7 +1079,6 @@ repeat:
  *   - the device is nonexistent (zero size)
  *   - the device has no valid superblock
  *
- * a faulty rdev _never_ has rdev->sb set.
  */
 static int md_import_device(kdev_t newdev, int on_disk)
 {
@@ -1147,8 +1150,6 @@ static int md_import_device(kdev_t newde
 	md_list_add(&rdev->all, &all_raid_disks);
 	MD_INIT_LIST_HEAD(&rdev->pending);
 
-	if (rdev->faulty && rdev->sb)
-		free_disk_sb(rdev);
 	return 0;
 
 abort_free:
@@ -3062,7 +3063,6 @@ int md_error(mddev_t *mddev, kdev_t rdev
 		return 0;
 	if (!mddev->pers->error_handler
 			|| mddev->pers->error_handler(mddev,rdev) <= 0) {
-		free_disk_sb(rrdev);
 		rrdev->faulty = 1;
 	} else
 		return 1;
