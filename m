From: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Subject: RE: [PATCH] Create.c: Try few more times to stop array after failed
 creation
Date: Tue, 9 Sep 2014 10:04:38 +0000
Message-ID: <84A53BEA6EAC69439B7E311E9B17A76F1A69724E@IRSMSX110.ger.corp.intel.com>
References: <20140905142612.10761.82358.stgit@gklab-154-222.intel.com>
 <20140908163337.6129ef3e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140908163337.6129ef3e@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

> On: Monday, September 08, 2014 8:34 AM NeilBrown wrote:
> To: Baldysiak, Pawel
> Cc: linux-raid@vger.kernel.org; Paszkiewicz, Artur
> Subject: Re: [PATCH] Create.c: Try few more times to stop array after failed
> creation
> 
> On Fri, 05 Sep 2014 16:26:13 +0200 Pawel Baldysiak
> <pawel.baldysiak@intel.com> wrote:
> 
> > Sometimes after failure in creation (exp. due to duplicate devices in
> > create command) newly created empty md array will not be stopped due
> > to openers>1 (create_mddev will not manage to drop lock).
> > In this case ioctl() will return error - this needs to be checked and
> > if occurs - sending STOP_ARRAY should be repeat after delay to make
> > sure that mddev is stopped correctly.
> >
> > Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> > ---
> >  Create.c |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/Create.c b/Create.c
> > index 330c5b4..7c8e53e 100644
> > --- a/Create.c
> > +++ b/Create.c
> > @@ -904,7 +904,12 @@ int Create(struct supertype *st, char *mddev,
> >  				if (st->ss->add_to_super(st, &inf->disk,
> >  							 fd, dv->devname,
> >  							 dv->data_offset)) {
> > -					ioctl(mdfd, STOP_ARRAY, NULL);
> > +					int count = 5;
> > +					while (count &&
> > +					       (ioctl(mdfd, STOP_ARRAY, NULL)
> < 0)) {
> > +						usleep(100000);
> > +						count--;
> > +					}
> >  					goto abort_locked;
> >  				}
> >  				st->ss->getinfo_super(st, inf, NULL);
> 
> I don't like this.  I don't really like any of the other loops like this that are
> already in the code either.  I wonder if we can avoid the need for it.
> 
> Given that the array hasn't been started yet, no other process can actually be
> *using* the array.  And given that we have an O_EXCL open at this point, no
> other process can be trying to stop/start the array.
> So it should be safe to change the kernel to not fail in this situation.
> 
> If you apply this kernel patch:
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c index
> 1294238610df..1bf3fe1ecc79 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5362,7 +5362,7 @@ static int do_md_stop(struct mddev * mddev, int
> mode,
>  	mddev_lock_nointr(mddev);
> 
>  	mutex_lock(&mddev->open_mutex);
> -	if (atomic_read(&mddev->openers) > !!bdev ||
> +	if ((mddev->pers && atomic_read(&mddev->openers) > !!bdev) ||
>  	    mddev->sysfs_active ||
>  	    mddev->sync_thread ||
>  	    (bdev && !test_bit(MD_STILL_CLOSED, &mddev->flags))) {
> 
> 
> does that fir your problem?  Can you see any reason not to allow
> STOP_ARRAY to succeed in this situation?
> 
Hi Neil
Thanks for your answer.
To fix this problem same thing needs to be added in one more place in kernel:

@@ -6454,7 +6454,7 @@ static int md_ioctl(struct block_device *bdev, fmode_t mode,
 		 * and writes
 		 */
 		mutex_lock(&mddev->open_mutex);
-		if (atomic_read(&mddev->openers) > 1) {
+		if (mddev->pers && (atomic_read(&mddev->openers) > 1)) {
 			mutex_unlock(&mddev->open_mutex);
 			err = -EBUSY;
 			goto abort;

Should I prepare the patch, or you can do it?

Thanks,
Pawel Baldysiak

> Thanks,
> NeilBrown
