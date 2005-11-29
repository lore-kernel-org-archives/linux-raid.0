From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH md 014 of 18] Attempt to auto-correct read errors in raid1.
Date: Wed, 30 Nov 2005 10:21:07 +1100
Message-ID: <17292.57955.829374.682151@cse.unsw.edu.au>
References: <20051128102824.14498.patches@notabene>
	<1051127234048.14901@suse.de>
	<438C841B.7000405@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Tuesday November 29
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 29, paul.clements@steeleye.com wrote:
> Hi Neil,
> 
> Glad to see this patch is making its way to mainline. I have a couple of 
> questions on the patch, though...

Thanks for reviewing the code - I really value that!

> 
> NeilBrown wrote:
> 
> > +	if (uptodate || conf->working_disks <= 1) {
> 
> Is it valid to mask a read error just because we have only 1 working disk?
> 

The purpose of this was that if there is only one working disk, there
is nothing we can do in the face of a read error, except return it
upstream.  However I did get the logic immediately after that wrong as
I discovered when I was porting it across to raid10.  Patch will be
out shortly.

> 
> 
> > +				do {
> > +					rdev = conf->mirrors[d].rdev;
> > +					if (rdev &&
> > +					    test_bit(In_sync, &rdev->flags) &&
> > +					    sync_page_io(rdev->bdev,
> > +							 sect + rdev->data_offset,
> > +							 s<<9,
> > +							 conf->tmppage, READ))
> > +						success = 1;
> > +					else {
> > +						d++;
> > +						if (d == conf->raid_disks)
> > +							d = 0;
> > +					}
> > +				} while (!success && d != r1_bio->read_disk);
> > +
> > +				if (success) {
> > +					/* write it back and re-read */
> > +					while (d != r1_bio->read_disk) {
> 
> Here, it looks like if we retry the read on the same disk that just gave 
> the read error, then we will not do any re-writes? I assume that is 
> intentional? I guess it's a judgment call whether the sector is really 
> bad at that point.

The read that failed was quite possibly a very large multipage read -
64K maybe (depends a lot on the filesystem).
What I do is walk through that one page at a time and retry the read.
If the re-read succeeds, then I assume the failure that stopped the
original (possibly larger) request was somewhere else, and I move on.

So yes, if a block sometimes fails, and then succeeds again on the
next read, we might not try to 'fix' it.  Is that likely to happen I
wonder?? 

> 
> > +						if (d==0)
> > +							d = conf->raid_disks;
> > +						d--;
> > +						rdev = conf->mirrors[d].rdev;
> > +						if (rdev &&
> > +						    test_bit(In_sync, &rdev->flags)) {
> > +							if (sync_page_io(rdev->bdev,
> > +									 sect + rdev->data_offset,
> > +									 s<<9, conf->tmppage, WRITE) == 0 ||
> > +							    sync_page_io(rdev->bdev,
> > +									 sect + rdev->data_offset,
> > +									 s<<9, conf->tmppage, READ) == 0) {
> > +								/* Well, this device is dead */
> > +								md_error(mddev, rdev);
> 
> Here, we might have gotten garbage back from the sync_page_io(..., 
> READ), if it failed. So don't we have to quit the re-write loop at this 
> point? Otherwise, aren't we potentially writing bad data over other 
> disks? Granted, this particular case might never actually happen in the 
> real world.

Yes, you are right.  I guess I really should be reading back into a
different buffer just in case something goes screwy...
Or maybe I could do all the writes, and then do all the reads in a
separate loop - that would be just as safe.

I see which one looks neatest.

Thank again,
NeilBrown
