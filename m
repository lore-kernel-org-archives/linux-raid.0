From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 2/3] imsm: FIX: 'UT 09imsm-assemble' fails
Date: Thu, 15 Dec 2011 10:28:08 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A060FAC@IRSMSX101.ger.corp.intel.com>
References: <20111214150448.21483.16231.stgit@gklab-128-013.igk.intel.com>
	<20111214150712.21483.48715.stgit@gklab-128-013.igk.intel.com>
 <20111215150114.68ee8522@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111215150114.68ee8522@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Thursday, December 15, 2011 5:01 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin; Williams,
> Dan J
> Subject: Re: [PATCH 2/3] imsm: FIX: 'UT 09imsm-assemble' fails
> 
> On Wed, 14 Dec 2011 16:07:12 +0100 Adam Kwolek
> <adam.kwolek@intel.com> wrote:
> 
> > Problem was introduced by patch (2011-06-08):
> >    getinfo_super now clears the 'info' structure before filling it in.
> >
> > Field update private is not managed here and pointer associated
> > outside is cleaned up.
> > Add code for field update_private cleaning preservation.
> > In places where in patch
> >   'getinfo_super now clears the 'info' structure before filling it in.'
> > cleaning structure was removed, cleaning update_private field was
> > added as getinfo_super() cannot be responsible for this pointer
> management.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> > ---
> >
> >  Assemble.c    |    2 ++
> >  Incremental.c |    3 +++
> >  super-intel.c |    9 +++++++++
> >  3 files changed, 14 insertions(+), 0 deletions(-)
> >
> > diff --git a/Assemble.c b/Assemble.c
> > index fac2bad..c8b538f 100644
> > --- a/Assemble.c
> > +++ b/Assemble.c
> > @@ -422,6 +422,7 @@ int Assemble(struct supertype *st, char *mddev,
> >  					int uuid[4];
> >
> >  					content = &info;
> > +					info.update_private = NULL
> >  					tst->ss->getinfo_super(tst, content,
> NULL);
> >
> >  					if (!parse_uuid(ident->container,
> uuid) || @@ -485,6 +486,7 @@
> > int Assemble(struct supertype *st, char *mddev,
> >  		} else {
> >
> >  			content = &info;
> > +			info.update_private = NULL
> >  			tst->ss->getinfo_super(tst, content, NULL);
> >
> >  			if (!ident_matches(ident, content, tst, diff --git
> a/Incremental.c
> > b/Incremental.c index d3724a4..112a1ec 100644
> > --- a/Incremental.c
> > +++ b/Incremental.c
> > @@ -205,6 +205,7 @@ int Incremental(char *devname, int verbose, int
> runstop,
> >  	}
> >  	close (dfd); dfd = -1;
> >
> > +	info.update_private = NULL
> >  	st->ss->getinfo_super(st, &info, NULL);
> >
> >  	/* 3/ Check if there is a match in mdadm.conf */ @@ -404,6 +405,7
> @@
> > int Incremental(char *devname, int verbose, int runstop,
> >  				goto out_unlock;
> >  			}
> >  			close(dfd2);
> > +			info.update_private = NULL
> >  			st2->ss->getinfo_super(st2, &info2, NULL);
> >  			st2->ss->free_super(st2);
> >  			if (info.array.level != info2.array.level || @@ -1382,6
> +1384,7 @@
> > static int Incremental_container(struct supertype *st, char *devname,
> >  	int ra_blocked = 0;
> >  	int ra_all = 0;
> >
> > +	info.update_private = NULL
> >  	st->ss->getinfo_super(st, &info, NULL);
> >
> >  	if ((runstop > 0 && info.container_enough >= 0) || diff --git
> > a/super-intel.c b/super-intel.c index e1073ef..5e1d278 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -2365,8 +2365,13 @@ static void getinfo_super_imsm_volume(struct
> supertype *st, struct mdinfo *info,
> >  	char *devname;
> >  	unsigned int component_size_alligment;
> >  	int map_disks = info->array.raid_disks;
> > +	void *update_private_saver = info->update_private;
> >
> >  	memset(info, 0, sizeof(*info));
> > +	/* preserve pointer cleanup, as someone elese is pointer owner
> > +	 */
> > +	info->update_private = update_private_saver;
> > +
> >  	if (prev_map)
> >  		map_to_analyse = prev_map;
> >
> > @@ -2601,12 +2606,16 @@ static void getinfo_super_imsm(struct
> supertype *st, struct mdinfo *info, char *
> >  	int max_enough = -1;
> >  	int i;
> >  	struct imsm_super *mpb;
> > +	void *update_private_saver = info->update_private;
> >
> >  	if (super->current_vol >= 0) {
> >  		getinfo_super_imsm_volume(st, info, map);
> >  		return;
> >  	}
> >  	memset(info, 0, sizeof(*info));
> > +	/* preserve pointer cleanup, as someone elese is pointer owner
> > +	 */
> > +	info->update_private = update_private_saver;
> >
> >  	/* Set raid_disks to zero so that Assemble will always pull in valid
> >  	 * spares
> >
> 
> You didn't really think I'd let that through, did you :-)
> 
> I've written an alternate which gets rid of update_private.
> 
> Could you and Dan please review and check it performs as required.
> 
> Thanks,
> NeilBrown



Don't you think that condition should set rv variable in opposite way? E.g.:
 +		} else {
 +			if (info->uuid[0] != info->uuid[1] ||
 +			    info->uuid[1] != info->uuid[2] ||
 +			    info->uuid[2] != info->uuid[3])
 +				rv = 0;
 +			else
 +				rv = -1;
  		}

I think that when condition is true, this means "random" value and update should be performed.

BR
Adam


> 
> 
> commit 8606be19835abaf888d0fbd1729dcda82a8b2815
> Author: NeilBrown <neilb@suse.de>
> Date:   Thu Dec 15 14:59:12 2011 +1100
> 
>     Remove update_private
> 
>     This fields doesn't work any more as ->getinfo_super clears the info
>     structure at an awkward time.  So get rid of it and do it differently.
> 
>     The issue is that the metadata handler cannot tell if the uuid it has
>     was randomly generated or explicitly requested, except on the first
>     call.
>     And we don't want to accept explicit requests for IMSM.
>     So when it was auto-generated, make it look distinctive by having the
>     same int copied in all 4 positions.  If someone requests a uuid like
>     that, I guess they get away with it.
> 
>     Reported-by: Adam Kwolek <adam.kwolek@intel.com>
>     Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/Assemble.c b/Assemble.c
> index fac2bad..74fb6a3 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -706,7 +706,6 @@ int Assemble(struct supertype *st, char *mddev,
>  	bitmap_done = 0;
>  #endif
>  	/* Ok, no bad inconsistancy, we can try updating etc */
> -	content->update_private = NULL;
>  	devices = malloc(num_devs * sizeof(*devices));
>  	devmap = calloc(num_devs * content->array.raid_disks, 1);
>  	for (tmpdev = devlist; tmpdev; tmpdev=tmpdev->next) if (tmpdev-
> >used == 1) { @@ -891,8 +890,6 @@ int Assemble(struct supertype *st, char
> *mddev,
>  		}
>  		devcnt++;
>  	}
> -	free(content->update_private);
> -	content->update_private = NULL;
> 
>  	if (devcnt == 0) {
>  		fprintf(stderr, Name ": no devices found for %s\n", diff --git
> a/mdadm.h b/mdadm.h index 1351d42..4f3533f 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -217,11 +217,6 @@ struct mdinfo {
>  	unsigned long		cache_size; /* size of raid456 stripe cache*/
>  	int			mismatch_cnt;
>  	char			text_version[50];
> -	void 			*update_private; /* for passing metadata-
> format
> -						  * specific update data
> -						  * between successive calls
> to
> -						  * update_super()
> -						  */
> 
>  	int container_member; /* for assembling external-metatdata arrays
>  			       * This is to be used internally by metadata diff --
> git a/super-intel.c b/super-intel.c index e1073ef..78781c7 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -2791,25 +2791,30 @@ static int update_super_imsm(struct supertype
> *st, struct mdinfo *info,
> 
>  	mpb = super->anchor;
> 
> -	if (strcmp(update, "uuid") == 0 && uuid_set && !info-
> >update_private)
> -		rv = -1;
> -	else if (strcmp(update, "uuid") == 0 && uuid_set && info-
> >update_private) {
> -		mpb->orig_family_num = *((__u32 *) info-
> >update_private);
> -		rv = 0;
> -	} else if (strcmp(update, "uuid") == 0) {
> -		__u32 *new_family = malloc(sizeof(*new_family));
> -
> -		/* update orig_family_number with the incoming random
> -		 * data, report the new effective uuid, and store the
> -		 * new orig_family_num for future updates.
> +	if (strcmp(update, "uuid") == 0) {
> +		/* We take this to mean that the family_num should be
> updated.
> +		 * However that is much smaller than the uuid so we cannot
> really
> +		 * allow an explicit uuid to be given.  And it is hard to reliably
> +		 * know if one was.
> +		 * So if !uuid_set we know the current uuid is random and
> just used
> +		 * the first 'int' and copy it to the other 3 positions.
> +		 * Otherwise we require the 4 'int's to be the same as would
> be the
> +		 * case if we are using a random uuid.  So an explicit uuid will
> be
> +		 * accepted as long as all for ints are the same... which
> shouldn't
> +hurt
>  		 */
> -		if (new_family) {
> -			memcpy(&mpb->orig_family_num, info->uuid,
> sizeof(__u32));
> -			uuid_from_super_imsm(st, info->uuid);
> -			*new_family = mpb->orig_family_num;
> -			info->update_private = new_family;
> +		if (uuid_set) {
> +			info->uuid[1] = info->uuid[2] = info->uuid[3] = info-
> >uuid[0];
>  			rv = 0;
> +		} else {
> +			if (info->uuid[0] != info->uuid[1] ||
> +			    info->uuid[1] != info->uuid[2] ||
> +			    info->uuid[2] != info->uuid[3])
> +				rv = -1;
> +			else
> +				rv = 0;
>  		}
> +		if (rv == 0)
> +			mpb->orig_family_num = info->uuid[0];
>  	} else if (strcmp(update, "assemble") == 0)
>  		rv = 0;
>  	else
