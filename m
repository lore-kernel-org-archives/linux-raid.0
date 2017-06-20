From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md/bitmap: don't read page from device with Bitmap_sync
Date: Mon, 19 Jun 2017 17:41:58 -0700
Message-ID: <20170620004158.lrry5ig5epvmcqfc@kernel.org>
References: <20170616091927.12959-1-gqjiang@suse.com>
 <20170616173613.c2cp6qt2hmoebgct@kernel.org>
 <87h8zc51t0.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87h8zc51t0.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jun 19, 2017 at 09:11:23AM +1000, Neil Brown wrote:
> On Fri, Jun 16 2017, Shaohua Li wrote:
> 
> > On Fri, Jun 16, 2017 at 05:19:27PM +0800, Guoqing Jiang wrote:
> >> The device owns Bitmap_sync flag needs recovery
> >> to become in sync, and read page from this type
> >> device could get stale status.
> >> 
> >> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> >> ---
> >> When develop for clustered raid10 feature, if add a
> >> disk under grow mode in master node, I could get
> >> the "bitmap superblock UUID mismatch" warning due
> >> to the page is read from Bitmap_sync device.
> >> 
> >>  drivers/md/bitmap.c | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> >> index bf7419a..bf34cd8 100644
> >> --- a/drivers/md/bitmap.c
> >> +++ b/drivers/md/bitmap.c
> >> @@ -156,7 +156,8 @@ static int read_sb_page(struct mddev *mddev, loff_t offset,
> >>  
> >>  	rdev_for_each(rdev, mddev) {
> >>  		if (! test_bit(In_sync, &rdev->flags)
> >
> > Why In_sync is set for the rdev? I think it shoudn't.
> 
> There are several states a device can be in.
> If ->raid_disk is < 0, then the device is a spare, and doesn't contain
>     and valid data.
> Otherwise ->raid_disk >=0 and:
>    In_sync is clear, which means that blocks before ->recovery_offset
>        contain valid data, and blocks after there don't
>    In_sync is set, which means ->recovery_offset is irrelevant and
>        should be treated as MaxSector
>    Bitmap_sync is set, which could apply in either of the above cases,
>        and means blocks corresponding to bits that are set in the bitmap
>        may not be up to date.
> 
> Bitmap_sync is only relevant before a device has been handed to the
> personality.  After it has been added, ->recovery_cp ensures that the
> blocks that might be wrong are not read until until the bitmap-based
> recovery has fixed them up.
> 
> Bitmap_sync is only use to stop the device from being given to the
> personality if a recovery won't be started because the array is
> read-only.
> 
> So it is perfectly valid for both In_sync and Bitmap_sync to be set.
> If they are, it makes sense to avoid reading bitmap information from the
> Bitmap_sync device, as that will be out-of-date.
> 
> I'm not quite sure why Guoqing is getting a UUID mismatch ... it
> suggests that the new device wasn't initialized properly.  So there
> might be another bug.  But I think this is definitely a bug.

Can you describe a scenario a disk has both bits set? I had hard time to
imagine it.

md_update_sb will update super and bitmap super at almost the same time. It's
possible we update super but not bitmap super and there is power loss. Is this
the case we have the both bits set? There seems no mechanism to prevent the
first disk has older bitmap super than the second disk in this scenario.
 
> >
> >> -		    || test_bit(Faulty, &rdev->flags))
> >> +		    || test_bit(Faulty, &rdev->flags)
> >> +		    || test_bit(Bitmap_sync, &rdev->flags))
> >
> > I didn't see code clears the Bitmap_sync bit after disk is synced, so likely
> > there is bug in this side.
> 
> There is no need to clear Bitmap_sync.  It stays set until it becomes
> irrelevant.

Hmm, if we use in this way, we should add comments there to declare this bit
can only be used very early.

Thanks,
Shaohua
