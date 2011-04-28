From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Thu, 28 Apr 2011 11:23:28 +1000
Message-ID: <20110428112328.07cf4578@notabene.brown>
References: <201103251725.21180.thomas.jarosch@intra2net.com>
	<20110427181714.219212ce@notabene.brown>
	<20110427200513.5f6a79fb@notabene.brown>
	<201104271700.58894.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201104271700.58894.thomas.jarosch@intra2net.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: Tejun Heo <tj@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 27 Apr 2011 17:00:58 +0200 Thomas Jarosch
<thomas.jarosch@intra2net.com> wrote:

> On Wednesday, 27. April 2011 12:05:13 NeilBrown wrote:
> > > Thanks again for the report.
> > 
> > On reflection over dinner, I think I should move the add_disk right to
> > the end just before the mutex_unlock.
> > I'm not sure it makes a big practical difference but it will be easier to
> > justify.
> > 
> > So if you could test this one instead please that would be great.
> > 
> > The rationale is that as soon as we call add_disk, get_gendisk will
> > return the disk rather than coming through to md_probe and blocking on
> > the mutex. So we want everything set up properly before calling
> > add_disk.
> 
> Unfortunately the kernel oopses now. Attached you'll find screenshots
> of the oops. I can bring back the serial console if needed.
> 
> I've double verified with "git diff" that I only have your
> latest change in the tree.
> 
> Hope that helps,
> Thomas


Yes it helps, thanks.

I do need to add_disk before I kobject_init_and_add the mddev object
otherwise it will try to create something in sysfs in a non-existent
directory.

So the sysfs stuff needs to come last.

Could you try this one please?

Thanks,
NeilBrown


diff --git a/drivers/md/md.c b/drivers/md/md.c
index 818313e..9f9fa54 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4335,13 +4335,15 @@ static int md_alloc(dev_t dev, char *name)
 	disk->fops = &md_fops;
 	disk->private_data = mddev;
 	disk->queue = mddev->queue;
+	blk_queue_flush(mddev->queue, REQ_FLUSH | REQ_FUA);
 	/* Allow extended partitions.  This makes the
 	 * 'mdp' device redundant, but we can't really
 	 * remove it now.
 	 */
 	disk->flags |= GENHD_FL_EXT_DEVT;
-	add_disk(disk);
 	mddev->gendisk = disk;
+	add_disk(disk);
+
 	error = kobject_init_and_add(&mddev->kobj, &md_ktype,
 				     &disk_to_dev(disk)->kobj, "%s", "md");
 	if (error) {
@@ -4355,8 +4357,6 @@ static int md_alloc(dev_t dev, char *name)
 	if (mddev->kobj.sd &&
 	    sysfs_create_group(&mddev->kobj, &md_bitmap_group))
 		printk(KERN_DEBUG "pointless warning\n");
-
-	blk_queue_flush(mddev->queue, REQ_FLUSH | REQ_FUA);
  abort:
 	mutex_unlock(&disks_mutex);
 	if (!error && mddev->kobj.sd) {
