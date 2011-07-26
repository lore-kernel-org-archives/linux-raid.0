From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 01/36] md: beginnings of bad block management.
Date: Tue, 26 Jul 2011 13:20:37 +1000
Message-ID: <20110726132037.6156054e@notabene.brown>
References: <20110721024556.8422.99443.stgit@notabene.brown>
	<20110721025847.8422.29443.stgit@notabene.brown>
	<87r55i45rt.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87r55i45rt.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 23 Jul 2011 01:52:22 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> NeilBrown <neilb@suse.de> writes:
> 
> > This the first step in allowing md to track bad-blocks per-device so
> > that we can fail individual blocks rather than the whole device.
> >
> > This patch just adds a data structure for recording bad blocks, with
> > routines to add, remove, search the list.
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
> > ---
> >
> >  drivers/md/md.c |  457 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/md/md.h |   49 ++++++
> >  2 files changed, 502 insertions(+), 4 deletions(-)
> >

> > @@ -2819,8 +2837,11 @@ static mdk_rdev_t *md_import_device(dev_t newdev, int super_format, int super_mi
> >  		return ERR_PTR(-ENOMEM);
> >  	}
> >  
> > -	md_rdev_init(rdev);
> > -	if ((err = alloc_disk_sb(rdev)))
> > +	err = md_rdev_init(rdev);
> > +	if (err)
> > +		goto abort_free;
> > +	err = alloc_disk_sb(rdev);
> > +	if (err)
> >  		goto abort_free;
> >  
> >  	err = lock_rdev(rdev, newdev, super_format == -2);
> 
> Now error path at abort_free needs to free rdev->badblocks.page
> otherwise there will be memory leaks.


Yep, I've fixed that thanks.

I'll revisit when to allocate the badblocks.page in a subsequent patch.
Then I'll push it all out to for-next and give it 48 hours for any further
review and for me to do some more testing - particularly after the locking
change.

So I hope to push all this to Linus in about 48 hours.  Any other
Reviewed-by:s (including any I might have missed) welcome before then.

Thanks,

NeilBrown

