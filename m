From: NeilBrown <neilb@suse.de>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Wed, 13 Apr 2011 08:44:08 +1000
Message-ID: <20110413084408.390c7ad1@notabene.brown>
References: <201103251725.21180.thomas.jarosch@intra2net.com>
	<20110405134629.664b946c@notabene.brown>
	<20110406101600.GB4142@mtj.dyndns.org>
	<201104121605.52443.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201104121605.52443.thomas.jarosch@intra2net.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: Tejun Heo <tj@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 12 Apr 2011 16:05:52 +0200 Thomas Jarosch
<thomas.jarosch@intra2net.com> wrote:

> Hello Neil,
> 
> On Wednesday, 6. April 2011 12:16:00 Tejun Heo wrote:
> > > To put it another way matching your description Tejun, the put path has
> > > a chance to run firstly while mddev_find is waiting for the spinlock,
> > > and then while flush_workqueue is waiting for the rest of the put path
> > > to complete.
> > 
> > I don't think the logic is wrong per-se.  It's more likely that the
> > implemented code doesn't really follow the model described by the
> > logic.
> > 
> > Probably the best way would be reproducing the problem and throwing in
> > some diagnostic code to tell the sequence of events?  If work is being
> > queued first but it still ends up busy looping, that would be a bug in
> > flush_workqueue(), but I think it's more likely that the restart
> > condition somehow triggers in an unexpected way without the work item
> > queued as expected.
> 
> I can test any debug patch you want, the box is in a test lab anyway.
> 
> Best regards,
> Thomas

Could you try this?

diff --git a/drivers/md/md.c b/drivers/md/md.c
index a0ccaab..07c97b1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6175,6 +6175,8 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 	mddev_t *mddev = mddev_find(bdev->bd_dev);
 	int err;
 
+	BUG_ON(!mddev->gendisk);
+
 	if (mddev->gendisk != bdev->bd_disk) {
 		/* we are racing with mddev_put which is discarding this
 		 * bd_disk.


It don't know how it could get to the state where gendisk was NULL, but it is
the only way I can see that the looping could happen.

If the BUG_ON does trigger I'll probably be able to find out why it happens.
If it doesn't then I'll still be at a loss.

NeilBrown

