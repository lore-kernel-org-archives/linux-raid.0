From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Wed, 27 Apr 2011 18:17:14 +1000
Message-ID: <20110427181714.219212ce@notabene.brown>
References: <201103251725.21180.thomas.jarosch@intra2net.com>
	<201104121605.52443.thomas.jarosch@intra2net.com>
	<20110413084408.390c7ad1@notabene.brown>
	<201104261051.09464.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201104261051.09464.thomas.jarosch@intra2net.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: Tejun Heo <tj@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 26 Apr 2011 10:51:09 +0200 Thomas Jarosch
<thomas.jarosch@intra2net.com> wrote:

> Hello Neil,
> 
> On Wednesday, 13. April 2011 00:44:08 NeilBrown wrote:
> > Could you try this?
> > 
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index a0ccaab..07c97b1 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -6175,6 +6175,8 @@ static int md_open(struct block_device *bdev,
> > fmode_t mode) mddev_t *mddev = mddev_find(bdev->bd_dev);
> >  	int err;
> > 
> > +	BUG_ON(!mddev->gendisk);
> > +
> >  	if (mddev->gendisk != bdev->bd_disk) {
> >  		/* we are racing with mddev_put which is discarding this
> >  		 * bd_disk.
> > 
> > 
> > It don't know how it could get to the state where gendisk was NULL, but
> > it is the only way I can see that the looping could happen.
> > 
> > If the BUG_ON does trigger I'll probably be able to find out why it
> > happens. If it doesn't then I'll still be at a loss.
> 
> Sorry for the late reply, I somehow missed your message.
> 
> Your intuition was right, the BUG_ON is triggered.
> Attached you'll find a screenshot of the call trace.
> 
> Best regards,
> Thomas

Thanks.

I manage to reproduce something very similar and I think I know what is
happening.  It appears to be fixed by this change to driver/md/md.c

@@ -4340,8 +4344,8 @@ static int md_alloc(dev_t dev, char *name)
 	 * remove it now.
 	 */
 	disk->flags |= GENHD_FL_EXT_DEVT;
-	add_disk(disk);
 	mddev->gendisk = disk;
+	add_disk(disk);
 	error = kobject_init_and_add(&mddev->kobj, &md_ktype,
 				     &disk_to_dev(disk)->kobj, "%s", "md");
 	if (error) {


However I need to think through the sequence of events in the morning and
make sure it all makes sense and there isn't some other race hiding in there.

Thanks again for the report.

NeilBrown
