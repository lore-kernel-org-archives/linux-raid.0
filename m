From: "Kwolek, Adam" <adam.kwolek@intel.com>
Subject: RE: [PATCH 2/2] imsm: FIX: Use first map only in migration record
 disk operations
Date: Tue, 13 Dec 2011 07:54:53 +0000
Message-ID: <79556383A0E1384DB3A3903742AAC04A05E842@IRSMSX101.ger.corp.intel.com>
References: <20111212110745.8849.76773.stgit@gklab-128-013.igk.intel.com>
	<20111212110753.8849.40342.stgit@gklab-128-013.igk.intel.com>
 <20111213132632.39bfe8aa@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111213132632.39bfe8aa@notabene.brown>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
List-Id: linux-raid.ids



> -----Original Message-----
> From: NeilBrown [mailto:neilb@suse.de]
> Sent: Tuesday, December 13, 2011 3:27 AM
> To: Kwolek, Adam
> Cc: linux-raid@vger.kernel.org; Ciechanowski, Ed; Labun, Marcin; Williams,
> Dan J
> Subject: Re: [PATCH 2/2] imsm: FIX: Use first map only in migration record
> disk operations
> 
> On Mon, 12 Dec 2011 12:07:53 +0100 Adam Kwolek
> <adam.kwolek@intel.com> wrote:
> 
> > This patch is addition to patch:
> >     "imsm: FIX: Limit migration record operation by disk slot not by index"
> > Location of migration record (2 first slots) should be taken on up to
> > date information. It is in first map.
> > Change slot verification to use first map only.
> >
> > Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> 
> Thanks.
> 
> I've applied this and the others, including the "make everything" fix that I
> somehow missed before.
> I've pushed it all out to the git tree.  Could you please check that I haven't
> missed anything.
> 
> Thanks,
> 
> NeilBrown

Thank you for adding patches. All looks ok :)

BR
Adam

> 
> 
> > ---
> >
> >  super-intel.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/super-intel.c b/super-intel.c index d90d96b..bfbaf10
> > 100644
> > --- a/super-intel.c
> > +++ b/super-intel.c
> > @@ -1178,8 +1178,8 @@ void examine_migr_rec_imsm(struct intel_super
> > *super)
> >
> >  		printf("\nMigration Record Information:");
> >
> > -		/* map under migration */
> > -		map = get_imsm_map(dev, MAP_1);
> > +		/* first map under migration */
> > +		map = get_imsm_map(dev, MAP_0);
> >  		if (map)
> >  			slot = get_imsm_disk_slot(map, super->disks-
> >index);
> >  		if ((map == NULL) || (slot > 1) || (slot < 0)) { @@ -2131,7
> +2131,7
> > @@ static int load_imsm_migr_rec(struct intel_super *super, struct
> mdinfo *info)
> >  	*/
> >  	if (dev == NULL)
> >  		return 0;
> > -	map = get_imsm_map(dev, MAP_1);
> > +	map = get_imsm_map(dev, MAP_0);
> >
> >  	if (info) {
> >  		for (sd = info->devs ; sd ; sd = sd->next) { @@ -2257,7
> +2257,7 @@
> > static int write_imsm_migr_rec(struct supertype *st)
> >  		dev = get_imsm_dev(super, super->current_vol < 0 ? 0 :
> >  					  super->current_vol);
> >
> > -	map = get_imsm_map(dev, MAP_X);
> > +	map = get_imsm_map(dev, MAP_0);
> >
> >  	for (sd = super->disks ; sd ; sd = sd->next) {
> >  		int slot;
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > in the body of a message to majordomo@vger.kernel.org More
> majordomo
> > info at  http://vger.kernel.org/majordomo-info.html

