From: NeilBrown <neilb@suse.de>
Subject: Re: Something wrong with __prep_thunderdome in super-intel.c
Date: Mon, 28 Mar 2011 12:35:09 +1100
Message-ID: <20110328123509.043555e7@notabene.brown>
References: <20110314140052.20478.45664.stgit@gklab-128-013.igk.intel.com>
	<20110315085346.3bf9feb7@notabene.brown>
	<905EDD02F158D948B186911EB64DB3D17A9910DD@irsmsx503.ger.corp.intel.com>
	<20110322132307.34e9bb3b@notabene.brown>
	<1301020846.15264.12.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1301020846.15264.12.camel@dwillia2-linux>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Kwolek, Adam" <adam.kwolek@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>
List-Id: linux-raid.ids

On Thu, 24 Mar 2011 19:40:46 -0700 Dan Williams <dan.j.williams@intel.com>
wrote:

> 
> hmm...
> 
> <context switch out of isci driver review mode>

:-)

> 
> > 
> > You can easily reproduce with
> > 
> >   ./mdadm -CR /dev/md/imsm -e imsm -n 2 /dev/loop[01]
> >   ./mdadm -CR /dev/md/r1 -l1 -n2 /dev/md/imsm
> >   ./mdadm /dev/md/r1 -f /dev/loop1
> >   ./mdadm -E /dev/md/imsm
> > 
> > and notice that nothing gets printed.
> > If you fail loop0 instead, it works properly.
> 
> The first thought is that the generation number on the good device
> should be ahead of the bad, but lo and behold it isn't.  We should stop
> advancing the generation number on failed devices.  The regression that
> Krzysztof's patch somewhat addresses is that thunderdome expects that
> failed devices should at least be able to look themselves up in their
> own mpb.  Fixing up the serial number so that other devices see the
> other disk as out of date is the expectation.
> 
> Stopping metadata write outs to failed devices fixes both problems.
> Krzysztof care to try the following with your recent change reverted?  I
> verified it addresses the problem above, but I have not had a chance to
> double check the orom compatibility (although I suspect it will be ok).
> This also simplifies the calling convention to mark_missing and
> mark_failure.

Thanks for looking at this Dan.

I tried your patch, however ...

> 
> diff --git a/super-intel.c b/super-intel.c
> index 2b41e08..6a6f738 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -5213,13 +5213,14 @@ static int is_resyncing(struct imsm_dev *dev)
>  }
>  
>  /* return true if we recorded new information */
> -static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
> +static int mark_failure(struct imsm_dev *dev, struct dl *dl)
>  {
>  	__u32 ord;
>  	int slot;
>  	struct imsm_map *map;
>  	char buf[MAX_RAID_SERIAL_LEN+3];
> -	unsigned int len, shift = 0;
> +	struct imsm_disk *disk = &dl->disk;
> +	unsigned int len, shift = 0, idx = dl->index;
>  
>  	/* new failures are always set in map[0] */
>  	map = get_imsm_map(dev, 0);
> @@ -5232,6 +5233,7 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
>  	if (is_failed(disk) && (ord & IMSM_ORD_REBUILD))
>  		return 0;
>  
> +	dl->index = -2;
>  	sprintf(buf, "%s:0", disk->serial);
>  	if ((len = strlen(buf)) >= MAX_RAID_SERIAL_LEN)
>  		shift = len - MAX_RAID_SERIAL_LEN + 1;
> @@ -5244,9 +5246,11 @@ static int mark_failure(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
>  	return 1;
>  }
>  
> -static void mark_missing(struct imsm_dev *dev, struct imsm_disk *disk, int idx)
> +static void mark_missing(struct imsm_dev *dev, struct dl *dl)
>  {
> -	mark_failure(dev, disk, idx);
> +	struct imsm_disk *disk = &dl->disk;
> +
> +	mark_failure(dev, dl);
>  
>  	if (disk->scsi_id == __cpu_to_le32(~(__u32)0))
>  		return;
> @@ -5269,7 +5273,7 @@ static void handle_missing(struct intel_super *super, struct imsm_dev *dev)
>  	dprintf("imsm: mark missing\n");
>  	end_migration(dev, map_state);
>  	for (dl = super->missing; dl; dl = dl->next)
> -		mark_missing(dev, &dl->disk, dl->index);
> +		mark_missing(dev, dl);
>  	super->updates_pending++;
>  }
>  
> @@ -5497,7 +5501,7 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
>  	struct intel_super *super = a->container->sb;
>  	struct imsm_dev *dev = get_imsm_dev(super, inst);
>  	struct imsm_map *map = get_imsm_map(dev, 0);
> -	struct imsm_disk *disk;
> +	struct dl *dl;
>  	int failed;
>  	__u32 ord;
>  	__u8 map_state;
> @@ -5512,11 +5516,11 @@ static void imsm_set_disk(struct active_array *a, int n, int state)
>  	dprintf("imsm: set_disk %d:%x\n", n, state);
>  
>  	ord = get_imsm_ord_tbl_ent(dev, n, -1);
> -	disk = get_imsm_disk(super, ord_to_idx(ord));
> +	dl = get_imsm_dl_disk(super, ord_to_idx(ord));

This sometimes return NULL, leading to bad stuff and mdmon crashing....

So there is more to this than meets the eye...

I'll stop trying this patch.

Thanks,

NeilBrown



>  
>  	/* check for new failures */
>  	if (state & DS_FAULTY) {
> -		if (mark_failure(dev, disk, ord_to_idx(ord)))
> +		if (mark_failure(dev, dl))
>  			super->updates_pending++;
>  	}
>  
> @@ -6265,7 +6269,7 @@ static int apply_takeover_update(struct imsm_update_takeover *u,
>  	for (du = super->missing; du; du = du->next)
>  		if (du->index >= 0) {
>  			set_imsm_ord_tbl_ent(map, du->index, du->index);
> -			mark_missing(dev_new, &du->disk, du->index);
> +			mark_missing(dev_new, du);
>  		}
>  
>  	return 1;
> 

