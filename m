From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 1/4] Add raid10 -> raid0 takeover support
Date: Thu, 27 Jan 2011 13:23:07 +1000
Message-ID: <20110127132307.719bee92@nbeee.brown>
References: <20110117153908.25096.42697.stgit@gklab-128-111.igk.intel.com>
	<20110117154243.25096.6278.stgit@gklab-128-111.igk.intel.com>
	<20110126105857.243e0919@nbeee.brown>
	<BE2BFE91933D1B4089447C644860408066FF058E@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BE2BFE91933D1B4089447C644860408066FF058E@irsmsx503.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Wed, 26 Jan 2011 11:34:08 +0000
"Wojcik, Krzysztof" <krzysztof.wojcik@intel.com> wrote:

> 
> 
> > -----Original Message-----
> > From: Neil Brown [mailto:neilb@suse.de]
> > Sent: Wednesday, January 26, 2011 1:59 AM
> > To: Wojcik, Krzysztof
> > Cc: linux-raid@vger.kernel.org; Neubauer, Wojciech; Kwolek, Adam;
> > Williams, Dan J; Ciechanowski, Ed
> > Subject: Re: [PATCH 1/4] Add raid10 -> raid0 takeover support
> > 
> > On Mon, 17 Jan 2011 16:42:43 +0100
> > Krzysztof Wojcik <krzysztof.wojcik@intel.com> wrote:
> > 
> > > The patch introduces takeover form level 10 to level 0 for imsm
> > > metadata. This patch contains procedures connected with preparing
> > > and applying metadata update during 10 -> 0 takeover.
> > > When performing takeover 10->0 mdmon should update the external
> > > metadata (due to disk slot and level changes).
> > > To achieve that mdadm calls reshape_super() and prepare
> > > the "update_takeover" metadata update type.
> > > Prepared update is processed by mdmon in process_update().
> > 
> > I've applied this, but I'm not sure that I like it.
> > 
> > I don't think mdadm needs to send a metadata update for 10->0
> > conversion.
> > It should:
> >  - fail all the devices that aren't wanted
> >  - remove them
> >  - mdmon notices and updates the metadata
> >  - mdadm changes the level to RAID0
> >  - mdmon notices and updates the metadata.
> > 
> > Currently mdmon doesn't monitor 'level', but it could and probably
> > should.
> > However in the interest of forward progress I won't insist on that
> > for now.
> Ok. Thanks for patch applying.
> In the future we can consider to change
> > 
> > Other problems:
> > 
> > >
> > > Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
> > > ---
> > >  Grow.c        |    1 +
> > >  super-intel.c |   98
> > > ++++++++++++++++++++++++++++++++++++++++++++++++++++++++- 2 files
> > > changed, 98 insertions(+), 1 deletions(-)
> > >
> > > diff --git a/Grow.c b/Grow.c
> > > index ad13d6e..c4125ea 100644
> > > --- a/Grow.c
> > > +++ b/Grow.c
> > > @@ -1463,6 +1463,7 @@ int Grow_reshape(char *devname, int fd, int
> > > quiet, char *backup_file, rv = 1;
> > >  			goto release;
> > >  		}
> > > +		ping_monitor(container);
> > 
> > Why is this here??? EVERY change should be justified in the notes at
> > the top!!!!!!!
> > 
> > 
> > >  	}
> > >
> > >  	info.array = array;
> > > diff --git a/super-intel.c b/super-intel.c
> > > index 334e0f4..86b365d 100644
> > > --- a/super-intel.c
> > > +++ b/super-intel.c
> > > @@ -299,6 +299,7 @@ enum imsm_update_type {
> > >  	update_rename_array,
> > >  	update_add_remove_disk,
> > >  	update_reshape_container_disks,
> > > +	update_takeover
> > >  };
> > >
> > >  struct imsm_update_activate_spare {
> > > @@ -319,6 +320,15 @@ struct geo_params {
> > >  	int raid_disks;
> > >  };
> > >
> > > +enum takeover_direction {
> > > +	R10_TO_R0,
> > > +	R0_TO_R10
> > > +};
> > > +struct imsm_update_takeover {
> > > +	enum imsm_update_type type;
> > > +	int subarray;
> > > +	enum takeover_direction direction;
> > > +};
> > >
> > >  struct imsm_update_reshape {
> > >  	enum imsm_update_type type;
> > > @@ -5802,6 +5812,56 @@ update_reshape_exit:
> > >  	return ret_val;
> > >  }
> > >
> > > +static int apply_takeover_update(struct imsm_update_takeover *u,
> > > +				struct intel_super *super)
> > > +{
> > > +	struct imsm_dev *dev = NULL;
> > > +	struct imsm_map *map;
> > > +	struct dl *dm, *du;
> > > +	struct intel_dev *dv;
> > > +
> > > +	for (dv = super->devlist; dv; dv = dv->next)
> > > +		if (dv->index == (unsigned int)u->subarray) {
> > > +			dev = dv->dev;
> > > +			break;
> > > +	}
> > > +
> > > +	if (dev == NULL)
> > > +		return 0;
> > > +
> > > +	map = get_imsm_map(dev, 0);
> > > +
> > > +	if (u->direction == R10_TO_R0) {
> > > +		/* iterate through devices to mark removed disks
> > > as spare */
> > > +		for (dm = super->disks; dm; dm = dm->next) {
> > > +			if (dm->disk.status & FAILED_DISK) {
> > > +				int idx = dm->index;
> > > +				/* update indexes on the disk
> > > list */
> > > +				for (du = super->disks; du; du =
> > > du->next)
> > > +					if (du->index > idx)
> > > +						du->index--;
> > > +				/* mark as spare disk */
> > > +				dm->disk.status = SPARE_DISK;
> > > +				dm->index = -1;
> > 
> > This looks like it is probably wrong, but I'm not exactly sure what
> > it is trying to do so I cannot be sure.
> > In particular the changes to 'index' seem to be based on some
> > assumption that are not necessarily true.
> > Could you please explain exactly what this is trying to achieve?
> When we remove disks from array, indexes of existing disks have to be
> updated to remove gaps between disks- if greater than removed disk
> index it should be decreased Example: 1. Raid10:
> Disk 1: index 0
> Disk 2: index 1
> Disk 3: index 2
> Disk 4: index 3
> 2. Disk 2 and 4 have been removed
> RAID10:
> Disk 1: index 0
> Disk 2(removed): index 1
> Disk 3: index 2
> Disk 4(removed): index 3
> 3. Level has been changed to "0"
> RAID0:
> Disk 1: index 0
> Disk 2: index -1
> Disk 3: index 1
> Disk 4: index -1
> 4. At the end we have following layout:
> RAID0:
> Disk 1: index 0
> Disk 2: index 1

And does this work if the devices are in a different order, or if some
are missing?
It would make more sense to divide-by-2 the indexes of the devices that
you want to keep.


> 
> 
> > 
> > > +			}
> > > +		}
> > > +
> > > +		/* update map */
> > > +		map->num_members = map->num_members / 2;
> > > +		map->map_state = IMSM_T_STATE_NORMAL;
> > > +		map->num_domains = 1;
> > 
> > I'm confused by this 'num_domains' thing.  Could you please explain
> > it for me.  The term "parity domains" is meaningless to me in this
> > context.
> "num_domains" is used to distinguish level 10 and level 1:
> For level 1:
> 	Level= 1
> 	Num_domains= 1
> For level 10:
> 	Level= 1
> 	Num_domains= 2
> 
> For other levels (0, 5) num_domains= 1.

It would be great if you could include that in the code somewhere as a
comment, as the numbers seem to be entirely arbitrary and not follow
any clear pattern.

Thanks.
NeilBrown


> 
> > 
> > Thanks,
> > NeilBrown
> > 
> > 
> > 
> > > +		map->raid_level = 0;
> > > +		map->failed_disk_num = -1;
> > > +	}
> > > +
> > > +	/* update disk order table */
> > > +	for (du = super->disks; du; du = du->next)
> > > +		if (du->index >= 0)
> > > +			set_imsm_ord_tbl_ent(map, du->index,
> > > du->index); +
> > > +	return 1;
> > > +}
> > > +
> > >  static void imsm_process_update(struct supertype *st,
> > >  			        struct metadata_update *update)
> > >  {
> > > @@ -5844,6 +5904,13 @@ static void imsm_process_update(struct
> > > supertype *st, mpb = super->anchor;
> > >
> > >  	switch (type) {
> > > +	case update_takeover: {
> > > +		struct imsm_update_takeover *u = (void
> > > *)update->buf;
> > > +		if (apply_takeover_update(u, super))
> > > +			super->updates_pending++;
> > > +		break;
> > > +	}
> > > +
> > >  	case update_reshape_container_disks: {
> > >  		struct imsm_update_reshape *u = (void
> > > *)update->buf; if (apply_reshape_container_disks_update(
> > > @@ -6691,6 +6758,35 @@ analyse_change_exit:
> > >  	return change;
> > >  }
> > >
> > > +int imsm_takeover(struct supertype *st, struct geo_params *geo)
> > > +{
> > > +	struct intel_super *super = st->sb;
> > > +	struct imsm_update_takeover *u;
> > > +
> > > +	u = malloc(sizeof(struct imsm_update_takeover));
> > > +	if (u == NULL)
> > > +		return 1;
> > > +
> > > +	u->type = update_takeover;
> > > +	u->subarray = super->current_vol;
> > > +
> > > +	/* 10->0 transition */
> > > +	if (geo->level == 0)
> > > +		u->direction = R10_TO_R0;
> > > +
> > > +	/* update metadata locally */
> > > +	imsm_update_metadata_locally(st, u,
> > > +					sizeof(struct
> > > imsm_update_takeover));
> > > +	/* and possibly remotely */
> > > +	if (st->update_tail)
> > > +		append_metadata_update(st, u,
> > > +					sizeof(struct
> > > imsm_update_takeover));
> > > +	else
> > > +		free(u);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > >  static int imsm_reshape_super(struct supertype *st, long long
> > > size, int level, int layout, int chunksize, int raid_disks,
> > >  			      char *backup, char *dev, int
> > > verbose) @@ -6772,7 +6868,7 @@ static int
> > > imsm_reshape_super(struct supertype *st, long long size, int
> > > level, change = imsm_analyze_change(st, &geo); switch (change) {
> > >  			case CH_TAKEOVER:
> > > -				ret_val = 0;
> > > +				ret_val = imsm_takeover(st,
> > > &geo); break;
> > >  			case CH_CHUNK_MIGR:
> > >  				ret_val = 0;

