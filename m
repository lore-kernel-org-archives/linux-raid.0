From: "Czarnowska, Anna" <anna.czarnowska@intel.com>
Subject: RE: [PATCH 2/3] Assemble imsm spares in matching domain only
Date: Tue, 4 Jan 2011 14:04:13 +0000
Message-ID: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E759F48@irsmsx504.ger.corp.intel.com>
References: <A9DE54D0CD747C4CB06DCE5B6FA2246F010E5CFBA0@irsmsx504.ger.corp.intel.com>
 <20101226222252.1255c6a9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101226222252.1255c6a9@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de]
> Sent: Sunday, December 26, 2010 12:23 PM
> To: Czarnowska, Anna
> Cc: linux-raid@vger.kernel.org; Williams, Dan J; Ciechanowski, Ed;
> Hawrylewicz Czarnowski, Przemyslaw; Labun, Marcin; Neubauer, Wojciech
> Subject: Re: [PATCH 2/3] Assemble imsm spares in matching domain only
> 
> 
> Thanks for these three.
> 
> I have applied the first,
> applied the seconds with a couple of changes as mentioned below,
> but I haven't applied the first.  I don't like the fact that knowledge
> about
> imsm is explicitly hard-coded into mdadm.c  All explicit knowledge
> about imsm
> should be in super-intel.c...
> 
> I think you can make this work by adding some code in to Assemble()
> just near:
> 	/* Now reject spares that don't match domains of identified
> members */
> 
> at that point, if (!st  || !st->sb), then we could include all those
> spares
> which have ->used == 3.
> i.e. when there are now more arrays to be found, all the spares get
> included
> into one last array.

I have implemented it this way but:
(!st || !st->sb) does not necessarily mean we are assembling "last" array.
This also happens when we find no devices for an array from config file.
So if the first array is missing we take all spares into spare-container
and they don't have a chance to be matched with other arrays.
Should we ignore this case as a bad config?

With auto assembly if we have this condition it means we can take all spares
that did not match anything before.
This is what we want but there is another problem: we do not attempt auto assembly
if we manage to assemble anything from config file. 
This means that when there is a good config file then
only the spares matching some array will be assembled.
We will not come back for the remaining ones.

If mdadm.c is a bad place to force spares assembly then maybe it makes sense
to add an ARRAY line with uuid=0 as last array in config?
This would take care of spares that have different domains than all arrays. 

> It might make sense to have an new super_switch field which gives the
> name of
> the array-of-spares as there is no name stored in the spares to use ...
> just
> a thought though, you might not need that.

Monitor doesn't need to know the name of the array-of-spares. It always checks all.

> 
> Could you try that and see if you can make it work?
> 
> The issues I fixed with this second patch are:
> 
> 
> > @@ -78,7 +78,8 @@ static int ident_matches(struct mddev_ident *ident,
> >  {
> >
> >  	if (ident->uuid_set && (!update || strcmp(update, "uuid")!= 0) &&
> > -	    same_uuid(content->uuid, ident->uuid, tst->ss->swapuuid)==0)
> {
> > +	    same_uuid(content->uuid, ident->uuid, tst->ss->swapuuid)==0
> &&
> > +	    memcmp(content->uuid, uuid_zero, sizeof(int[4]))) {
> >  		if (devname)
> >  			fprintf(stderr, Name ": %s has wrong uuid.\n",
> >  				devname);
> 
> I really really don't like that way of testing the return value of
> memcmp (or
> strcmp).  It make it very hard to read - for me at least.
> I *always* want to see one a comparison with zero with memcmp or
> strcmp.
> 
> So:
>    memcmp() == 0
> means the values are equal,
>    memcmp() > 0
> means the first is greater than the second
> etc.  So the comparison operator just has to be moved in my thoughts
> in between the two values and I can see clearly what is intended.
> 
> > @@ -350,6 +352,7 @@ int Assemble(struct supertype *st, char *mddev,
> >  			} else
> >  				found_container = 1;
> >  		} else {
> > +			pol = devnum_policy(stb.st_rdev);
> >  			if (!tst && (tst = guess_super(dfd)) == NULL) {
> >  				if (report_missmatch)
> >  					fprintf(stderr, Name ": no recogniseable
> superblock on %s\n",
> > @@ -366,7 +369,7 @@ int Assemble(struct supertype *st, char *mddev,
> >  						tst->ss->name, devname);
> >  				tmpdev->used = 2;
> >  			} else if (auto_assem && st == NULL &&
> > -				   !conf_test_metadata(tst->ss->name, (pol =
> devnum_policy(stb.st_rdev)),
> > +				   !conf_test_metadata(tst->ss->name, pol,
> >  						       tst->ss->match_home(tst,
> homehost) == 1)) {
> >  				if (report_missmatch)
> >  					fprintf(stderr, Name ": %s has metadata
> type %s for which "
> 
> I have reverted this change.  I only want the devnum_policy to be
> computed if
> it is needed.

It was needed to build array domain. I add it later on devices with used=1 only.

> Thanks,
> NeilBrown

Regards
Anna
