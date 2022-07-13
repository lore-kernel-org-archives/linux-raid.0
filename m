Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A37EC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 13 Jul 2022 07:17:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbiGMHRM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 13 Jul 2022 03:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbiGMHRL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 13 Jul 2022 03:17:11 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 164EE675B7;
        Wed, 13 Jul 2022 00:17:11 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C9D4967373; Wed, 13 Jul 2022 09:17:07 +0200 (CEST)
Date:   Wed, 13 Jul 2022 09:17:07 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Logan Gunthorpe <logang@deltatee.com>
Cc:     Christoph Hellwig <hch@lst.de>, Song Liu <song@kernel.org>,
        linux-raid@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 2/8] md: implement ->free_disk
Message-ID: <20220713071707.GA14903@lst.de>
References: <20220712070331.1390700-1-hch@lst.de> <20220712070331.1390700-3-hch@lst.de> <85666118-cbb0-83e2-5c27-c3be8c5c6688@deltatee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85666118-cbb0-83e2-5c27-c3be8c5c6688@deltatee.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Jul 12, 2022 at 05:13:48PM -0600, Logan Gunthorpe wrote:
> > +
> > +	percpu_ref_exit(&mddev->writes_pending);
> > +	bioset_exit(&mddev->bio_set);
> > +	bioset_exit(&mddev->sync_set);
> > +
> > +	kfree(mddev);
> > +}
> 
> I still don't think this is entirely correct. There are error paths that
> will put the kobject before the disk is created and if they get hit then
> the kfree(mddev) will never be called and the memory will be leaked.

True.

> Instead of creating an ugly special path for that, I came up with a solution 
> that I think  makes a bit more sense: the kobject is still freed in it's 
> own free  function, but the disk holds a reference to the kobject and drops
> it in its free function. The sysfs puts and del_gendisk are then moved
> into mddev_delayed_delete() so they happen earlier.

I'm not sure this is a good idea.  The mddev kobject hangs off the
disk, so I don't think that it should in any way control the life
time of the disk, as that just creates potential problems down the
road.

Moreover we actually need the special kfree path anyway for the
add_disk failure, something that I had missed.  Something like
the untested patch below on top of my series.  I'll look into folding
and testing it.

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 53a92b306b1fc..62f40c49344e4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5641,7 +5641,7 @@ static int md_alloc(dev_t dev, char *name)
 			    strcmp(mddev2->gendisk->disk_name, name) == 0) {
 				spin_unlock(&all_mddevs_lock);
 				error = -EEXIST;
-				goto out_unlock_disks_mutex;
+				goto out_free_mddev;
 			}
 		spin_unlock(&all_mddevs_lock);
 	}
@@ -5654,7 +5654,7 @@ static int md_alloc(dev_t dev, char *name)
 	error = -ENOMEM;
 	disk = blk_alloc_disk(NUMA_NO_NODE);
 	if (!disk)
-		goto out_unlock_disks_mutex;
+		goto out_free_mddev;
 
 	disk->major = MAJOR(mddev->unit);
 	disk->first_minor = unit << shift;
@@ -5674,26 +5674,35 @@ static int md_alloc(dev_t dev, char *name)
 	disk->events |= DISK_EVENT_MEDIA_CHANGE;
 	mddev->gendisk = disk;
 	error = add_disk(disk);
-	if (error) {
-		mddev->gendisk = NULL;
-		put_disk(disk);
-		goto out_unlock_disks_mutex;
-	}
+	if (error)
+		goto out_put_disk;
 
 	error = kobject_add(&mddev->kobj, &disk_to_dev(disk)->kobj, "%s", "md");
-	if (error)
+	if (error) {
+		/*
+		 * The disk is already live at this point.  Clear the hold flag
+		 * and let mddev_put take care of the deletion, as it isn't any
+		 * different from a normal close on last release now.
+		 */
+		mddev->hold_active = 0;
 		goto out_unlock_disks_mutex;
+	}
 
 	kobject_uevent(&mddev->kobj, KOBJ_ADD);
 	mddev->sysfs_state = sysfs_get_dirent_safe(mddev->kobj.sd, "array_state");
 	mddev->sysfs_level = sysfs_get_dirent_safe(mddev->kobj.sd, "level");
 
 out_unlock_disks_mutex:
-	if (error)
-		mddev->hold_active = 0;
 	mutex_unlock(&disks_mutex);
 	mddev_put(mddev);
 	return error;
+
+out_put_disk:
+	put_disk(disk);
+out_free_mddev:
+	mutex_unlock(&disks_mutex);
+	kfree(mddev);
+	return error;
 }
 
 static void md_probe(dev_t dev)
