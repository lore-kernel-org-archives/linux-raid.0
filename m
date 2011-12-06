From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: RE: [PATCH] imsm: do not fail load_container when first 2 disks are
 missing
Date: Tue, 6 Dec 2011 08:36:20 +0000
Message-ID: <3F8F31A3BFD1664EAB894D1BD6AF32B9054D76@IRSMSX102.ger.corp.intel.com>
References: <3F8F31A3BFD1664EAB894D1BD6AF32B9053871@IRSMSX102.ger.corp.intel.com>
 <20111206110809.00828921@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111206110809.00828921@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

This causes problem in scenario like this:
1. create raid 0 on sd[ab]
2. add 2 spares sd[cd]
3. change level to 10 and wait for resync
4. fail sda and sdb

sda and sdb contained the whole set of data and still are in front of sdc and sdd in metadata
remaining disks sdc and sdd after resync contain all the data but raid cannot be assembled

> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Tuesday, December 06, 2011 1:08 AM
> To: Czarnowska, Anna
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Labun, Marcin;
> Ciechanowski, Ed
> Subject: Re: [PATCH] imsm: do not fail load_container when first 2
> disks are missing
> 
> On Thu, 24 Nov 2011 11:24:16 +0000 "Czarnowska, Anna"
> <anna.czarnowska@intel.com> wrote:
> 
> > Failure to find migration record should not fail the whole
> load_container.
> > It causes that degraded raid10 with first 2 disks missing cannot be
> assembled.
> >
> > Signed-off-by: Anna Czarnowska <anna.czarnowska@intel.com>
> > ---
> >  super-intel.c |   10 ++--------
> >  1 files changed, 2 insertions(+), 8 deletions(-)
> >
> > diff --git a/super-intel.c b/super-intel.c
> > index a0672bf..21147c2 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -3953,15 +3953,9 @@ static int load_super_imsm_all(struct
> supertype *st, int fd, void **sbp,
> >  		goto error;
> >  	}
> >
> > -	/* load migration record */
> > -	err = load_imsm_migr_rec(super, NULL);
> > -	if (err) {
> > -		err = 4;
> > -		goto error;
> > -	}
> > -
> >  	/* Check migration compatibility */
> > -	if (check_mpb_migr_compatibility(super) != 0) {
> > +	if (load_imsm_migr_rec(super, NULL) == 0 &&
> > +	    check_mpb_migr_compatibility(super) != 0) {
> >  		fprintf(stderr, Name ": Unsupported migration detected");
> >  		if (devname)
> >  			fprintf(stderr, " on %s\n", devname);
> 
> Sorry for the long delay in replying.  The last two weeks have held
> lots of
> interruptions and distractions.
> 
> There are two things about this that don't make sense to me.  Perhaps
> you can
> clarify.
> 
> Firstly, imsm raid10 only supports a 4-device layout with the first two
> devices effectively mirrors, same for the second two, and data striped
> over
> the 2 pairs.  i.e. an 'n2' layout on 4 devices.
> So if the first 2 disks are missing, then you have lost half your data
> and it
> would be wrong to successfully assemble the array.
> 
> Secondly, if the migration record is missing, then presumably you do
> not know
> the full state of the array so again - assembling the array would be
> wrong.
> 
> So I cannot see how this patch can be correct.  If it is, please
> explain.
> 
> Thanks,
> NeilBrown
