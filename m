From: "Dorau, Lukasz" <lukasz.dorau@intel.com>
Subject: RE: [PATCH] imsm: fix checking completion of RAID10 resync
Date: Thu, 1 Aug 2013 12:32:50 +0000
Message-ID: <D9FFE20C522965449E182ACE73889AEB1A5381ED@IRSMSX105.ger.corp.intel.com>
References: <20130730135925.30168.91570.stgit@localhost.localdomain>
 <20130731092240.3230bf7f@notabene.brown>
 <D9FFE20C522965449E182ACE73889AEB1A537C60@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <D9FFE20C522965449E182ACE73889AEB1A537C60@IRSMSX105.ger.corp.intel.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday, August 01, 2013 10:47 AM Lukasz Dorau <lukasz.dorau@intel.com> wrote:
> On Wednesday, July 31, 2013 1:23 AM NeilBrown <neilb@suse.de> wrote:
> > On Tue, 30 Jul 2013 15:59:25 +0200 Pawel Baldysiak
> > <pawel.baldysiak@intel.com> wrote:
> >
> > > If one creates RAID10 with IMSM metadata the is_resync_complete
> > > function returns '1' just when initial resync reaches 50%
> > >
> > > IMSM version of the is_resync_complete function has been added
> > > that handles the case of IMSM RAID10 correctly.
> > >
> > >
> > > Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> > > ---
> > >  super-intel.c |   20 ++++++++++++++++++--
> > >  1 file changed, 18 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/super-intel.c b/super-intel.c
> > > index 4df33f4..0371713 100644
> > > --- a/super-intel.c
> > > +++ b/super-intel.c
> > > @@ -1021,6 +1021,22 @@ static int is_failed(struct imsm_disk *disk)
> > >  	return (disk->status & FAILED_DISK) == FAILED_DISK;
> > >  }
> > >
> > > +/* IMSM version of is_resync_complete helper routine
> > > + * to determine resync completion
> > > + * since MaxSector is a moving target
> > > + */
> > > +static int imsm_is_resync_complete(struct mdinfo *array)
> > > +{
> > > +	if (array->array.level != 10) {
> > > +		if (array->resync_start >= array->component_size)
> > > +			return 1;
> > > +	} else {
> > > +		if (array->resync_start >= 2*array->component_size)
> > > +			return 1;
> > > +	}
> > > +	return 0;
> > > +}
> > > +
> > >  /* try to determine how much space is reserved for metadata from
> > >   * the last get_extents() entry on the smallest active disk,
> > >   * otherwise fallback to the default
> > > @@ -7119,12 +7135,12 @@ static int imsm_set_array_state(struct
> > active_array *a, int consistent)
> > >  		handle_missing(super, dev);
> > >
> > >  	if (consistent == 2 &&
> > > -	    (!is_resync_complete(&a->info) ||
> > > +	    (!imsm_is_resync_complete(&a->info) ||
> > >  	     map_state != IMSM_T_STATE_NORMAL ||
> > >  	     dev->vol.migr_state))
> > >  		consistent = 0;
> > >
> > > -	if (is_resync_complete(&a->info)) {
> > > +	if (imsm_is_resync_complete(&a->info)) {
> > >  		/* complete intialization / resync,
> > >  		 * recovery and interrupted recovery is completed in
> > >  		 * ->set_disk
> >
> >
> > Thanks.
> > However the bug is not specific to intel, so should be fixed in common code.
> > And "2*" is not really very general.
> >
> > The following patch should fix it properly.  If you can confirm that it fixes
> > the problem for you I would appreciate it.
> >
> 
> Hi
> 
> Since Pawel is out of office I am responding instead of him.
> Your patch does not work for IMSM now, because ncopies is equal 0 and
> mdmon crashes after dividing by zero - see details below:
> 
> > Thanks,
> > NeilBrown
> >
> > From 71d68ff62f945254240575cd836f5f2a09ced5d2 Mon Sep 17 00:00:00
> 2001
> > From: NeilBrown <neilb@suse.de>
> > Date: Wed, 31 Jul 2013 09:18:57 +1000
> > Subject: [PATCH] Fix is_resync_complete for RAID10
> >
> > For RAID10, 'sync' numbers go up to the array size rather than the
> > component size.  is_resync_complete() needs to allow for this.
> >
> > Reported-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >
> > diff --git a/mdmon.h b/mdmon.h
> > index 60fda38..5a8e120 100644
> > --- a/mdmon.h
> > +++ b/mdmon.h
> > @@ -91,7 +91,21 @@ extern int monitor_loop_cnt;
> >   */
> >  static inline int is_resync_complete(struct mdinfo *array)
> >  {
> > -	if (array->resync_start >= array->component_size)
> > -		return 1;
> > -	return 0;
> > +	unsigned long long sync_size = 0;
> > +	int ncopies, l;
> > +	switch(array->array.level) {
> > +	case 1:
> > +	case 4:
> > +	case 5:
> > +	case 6:
> > +		sync_size = array->component_size;
> > +		break;
> > +	case 10:
> > +		l = array->array.layout;
> > +		ncopies = (l & 0xff) * ((l >> 8) && 0xff);
> > +		sync_size = array->component_size * array->array.raid_disks;
> 
> At this point of code the following variables equal
> (I have created RAID10 volume of size z=10G):
> 
> array->array.layout = 0
> ncopies = 0
> array->component_size = 20971520
> array->array.raid_disks = 4
> sync_size = 83886080
> array->resync_start = 0
> 
> I will check why array->array.layout is equal 0.
> 

There is another, more serious, problem.
When we stop the array during initial resync (mdadm -Ss) 
and the function is_resync_complete() is entered for the last time, 
array->array.raid_disks already equals 0, because it is zero'ed by manager:
        a->info.array.raid_disks = mdstat->raid_disks;
at managemon.c:454.
As a result sync_size equals 0 and is_resync_complete() incorrectly returns 1 and resync finishes...

It seems to be a race condition between monitor and manager - manager changes value of array.raid_disks too fast.

Regards,
Lukasz

> 
> > +		sync_size /= ncopies;
> > +		break;
> > +	}
> > +	return array->resync_start >= sync_size;
> >  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
