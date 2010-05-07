From: Neil Brown <neilb@suse.de>
Subject: Re: raid1.c read_balance() LBD issue?
Date: Sat, 8 May 2010 08:22:09 +1000
Message-ID: <20100508082209.72ade819@notabene.brown>
References: <4BD09399.4090901@quo.to>
	<4BE44FC8.4010508@quo.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BE44FC8.4010508@quo.to>
Sender: linux-raid-owner@vger.kernel.org
To: Jordan Russell <jr-list-2010@quo.to>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 07 May 2010 12:37:12 -0500
Jordan Russell <jr-list-2010@quo.to> wrote:

> On 4/22/2010 1:21 PM, I wrote:
> > raid1.c's read_balance() function has:
> > 
> >         const unsigned long this_sector = r1_bio->sector;
> > 
> > Doesn't that need to be:
> > 
> >         const sector_t this_sector = r1_bio->sector;
> > 
> > for compatibility with LBD on 32-bit platforms?
> 
> Any comments on this?
> 
> At very least it appears the truncation to 32 bits will break the "disk
> whose head is closest" logic.
> 

Thanks for the reminder.

Yes, it should be sector_t.  I've queued up a patch for the next merge window.

This bug will only affect devices greater than 2TB and as you say it will
upset the read-balancing logic.  During a resync, it could possibly cause a
read to be served from a non-primary device which might have different data
than the primary device.  It is fairly unlikely that this will actually cause
a problem though (if the array is recoverying to a spare, rather than
resyncing after a crash, there is no such risk).

Thanks,
NeilBrown


commit eba3d84bb8d7692edc3eaa4d3589e6e4a692e50f
Author: NeilBrown <neilb@suse.de>
Date:   Sat May 8 08:20:17 2010 +1000

    md: Fix read balancing in RAID1 and RAID10 on drives > 2TB
    
    read_balance uses a "unsigned long" for a sector number which
    will get truncated beyond 2TB.
    This will cause read-balancing to be non-optimal, and can cause
    data to be read from the 'wrong' branch during a resync.  This has a
    very small chance of returning wrong data.
    
    Reported-by: Jordan Russell <jr-list-2010@quo.to>
    Cc: stable@kernel.org
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 49a2219..7d22838 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -418,7 +418,7 @@ static void raid1_end_write_request(struct bio *bio, int error)
  */
 static int read_balance(conf_t *conf, r1bio_t *r1_bio)
 {
-	const unsigned long this_sector = r1_bio->sector;
+	const sector_t this_sector = r1_bio->sector;
 	int new_disk = conf->last_used, disk = new_disk;
 	int wonly_disk = -1;
 	const int sectors = r1_bio->sectors;
@@ -434,7 +434,7 @@ static int read_balance(conf_t *conf, r1bio_t *r1_bio)
  retry:
 	if (conf->mddev->recovery_cp < MaxSector &&
 	    (this_sector + sectors >= conf->next_resync)) {
-		/* Choose the first operation device, for consistancy */
+		/* Choose the first operational device, for consistancy */
 		new_disk = 0;
 
 		for (rdev = rcu_dereference(conf->mirrors[new_disk].rdev);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e843e12..f6a9885 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -495,7 +495,7 @@ static int raid10_mergeable_bvec(struct request_queue *q,
  */
 static int read_balance(conf_t *conf, r10bio_t *r10_bio)
 {
-	const unsigned long this_sector = r10_bio->sector;
+	const sector_t this_sector = r10_bio->sector;
 	int disk, slot, nslot;
 	const int sectors = r10_bio->sectors;
 	sector_t new_distance, current_distance;
