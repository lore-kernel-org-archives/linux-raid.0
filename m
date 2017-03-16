From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 10/15] md/raid1: stop using bi_phys_segment
Date: Wed, 15 Mar 2017 20:36:37 -0700
Message-ID: <20170316033637.n35segx3lu2qv6nh@kernel.org>
References: <148954692173.18641.1294690639716682540.stgit@noble>
 <148954711389.18641.6044680366998154084.stgit@noble>
 <20170316001355.lyhq7lkyvndsocwo@kernel.org>
 <8737eedjfu.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8737eedjfu.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

On Thu, Mar 16, 2017 at 01:49:57PM +1100, Neil Brown wrote:
> On Wed, Mar 15 2017, Shaohua Li wrote:
> 
> > On Wed, Mar 15, 2017 at 02:05:14PM +1100, Neil Brown wrote:
> >> Change to use bio->__bi_remaining to count number of r1bio attached
> >> to a bio.
> >> See precious raid10 patch for more details.
> >> 
> >> Like the raid10.c patch, this fixes a bug as nr_queued and nr_pending
> >> used to measure different things, but were being compared.
> >> 
> >> This patch fixes another bug in that nr_pending previously did not
> >> could write-behind requests, so behind writes could continue while
> >> resync was happening.  How that nr_pending counts all r1_bio,
> >> the resync cannot commence until the behind writes have completed.
> >> 
> >> Signed-off-by: NeilBrown <neilb@suse.com>
> >> ---
> >>  drivers/md/raid1.c |   87 +++++++++++++---------------------------------------
> >>  1 file changed, 22 insertions(+), 65 deletions(-)
> >> 
> >> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> >> index 7e509a894f15..e566407b196f 100644
> >> --- a/drivers/md/raid1.c
> >> +++ b/drivers/md/raid1.c
> >> @@ -246,35 +246,18 @@ static void reschedule_retry(struct r1bio *r1_bio)
> >>  static void call_bio_endio(struct r1bio *r1_bio)
> >>  {
> >>  	struct bio *bio = r1_bio->master_bio;
> >> -	int done;
> >>  	struct r1conf *conf = r1_bio->mddev->private;
> >>  	sector_t bi_sector = bio->bi_iter.bi_sector;
> >>  
> >> -	if (bio->bi_phys_segments) {
> >> -		unsigned long flags;
> >> -		spin_lock_irqsave(&conf->device_lock, flags);
> >> -		bio->bi_phys_segments--;
> >> -		done = (bio->bi_phys_segments == 0);
> >> -		spin_unlock_irqrestore(&conf->device_lock, flags);
> >> -		/*
> >> -		 * make_request() might be waiting for
> >> -		 * bi_phys_segments to decrease
> >> -		 */
> >> -		wake_up(&conf->wait_barrier);
> >> -	} else
> >> -		done = 1;
> >> -
> >>  	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
> >>  		bio->bi_error = -EIO;
> >>  
> >> -	if (done) {
> >> -		bio_endio(bio);
> >> -		/*
> >> -		 * Wake up any possible resync thread that waits for the device
> >> -		 * to go idle.
> >> -		 */
> >> -		allow_barrier(conf, bi_sector);
> >> -	}
> >> +	bio_endio(bio);
> >> +	/*
> >> +	 * Wake up any possible resync thread that waits for the device
> >> +	 * to go idle.
> >> +	 */
> >> +	allow_barrier(conf, bi_sector);
> >
> > I think this one should be r1_bio->sector instead of master_bio->sector,
> > because multiple r1_bio could be attached to a master_bio. Maybe not change
> > anything, because both sector should be in the same barrier unit, but we'd
> > better to be consistent.
> 
> Yes, I agree.  Both that it won't make a practical difference and that
> it should be changed.
> I just noticed another little problem with this patch.
> The chunk in handle_read_error() should have added inc_pending()
> near where it added bio_inc_remaining().
> 
> Shall I just resend the individual patch (and the raid5 one?).

Please send a fix, I'll integrate it to original patches.


Thanks,
Shaohua
