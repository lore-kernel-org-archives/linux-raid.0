From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Wed, 27 Apr 2011 20:05:13 +1000
Message-ID: <20110427200513.5f6a79fb@notabene.brown>
References: <201103251725.21180.thomas.jarosch@intra2net.com>
	<201104121605.52443.thomas.jarosch@intra2net.com>
	<20110413084408.390c7ad1@notabene.brown>
	<201104261051.09464.thomas.jarosch@intra2net.com>
	<20110427181714.219212ce@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110427181714.219212ce@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: Tejun Heo <tj@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 27 Apr 2011 18:17:14 +1000 NeilBrown <neilb@suse.de> wrote:

> I manage to reproduce something very similar and I think I know what is
> happening.  It appears to be fixed by this change to driver/md/md.c
> 
> @@ -4340,8 +4344,8 @@ static int md_alloc(dev_t dev, char *name)
>  	 * remove it now.
>  	 */
>  	disk->flags |= GENHD_FL_EXT_DEVT;
> -	add_disk(disk);
>  	mddev->gendisk = disk;
> +	add_disk(disk);
>  	error = kobject_init_and_add(&mddev->kobj, &md_ktype,
>  				     &disk_to_dev(disk)->kobj, "%s", "md");
>  	if (error) {
> 
> 
> However I need to think through the sequence of events in the morning and
> make sure it all makes sense and there isn't some other race hiding in there.
> 
> Thanks again for the report.
> 

On reflection over dinner, I think I should move the add_disk right to the
end just before the mutex_unlock.
I'm not sure it makes a big practical difference but it will be easier to
justify.

So if you could test this one instead please that would be great.

The rationale is that as soon as we call add_disk, get_gendisk will return
the disk rather than coming through to md_probe and blocking on the mutex.
So we want everything set up properly before calling add_disk.

Thanks,
NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 818313e..6ab5bfb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4340,7 +4340,6 @@ static int md_alloc(dev_t dev, char *name)
 	 * remove it now.
 	 */
 	disk->flags |= GENHD_FL_EXT_DEVT;
-	add_disk(disk);
 	mddev->gendisk = disk;
 	error = kobject_init_and_add(&mddev->kobj, &md_ktype,
 				     &disk_to_dev(disk)->kobj, "%s", "md");
@@ -4357,6 +4356,7 @@ static int md_alloc(dev_t dev, char *name)
 		printk(KERN_DEBUG "pointless warning\n");
 
 	blk_queue_flush(mddev->queue, REQ_FLUSH | REQ_FUA);
+	add_disk(disk);
  abort:
 	mutex_unlock(&disks_mutex);
 	if (!error && mddev->kobj.sd) {
