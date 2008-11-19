From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: use list_for_each_entry macro directly
Date: Thu, 20 Nov 2008 08:59:07 +1100
Message-ID: <18724.35883.965389.413506@notabene.brown>
References: <1226860289-15478-1-git-send-email-crquan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from crquan@gmail.com on Monday November 17
Sender: linux-raid-owner@vger.kernel.org
To: crquan@gmail.com
Cc: Dan Williams <dan.j.williams@gmail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Monday November 17, crquan@gmail.com wrote:
> From: Cheng Renquan <crquan@gmail.com>
> 
> The rdev_for_each macro defined in <linux/raid/md_k.h> is identical to
> list_for_each_entry_safe, from <linux/list.h>, it should be defined to
> use list_for_each_entry_safe, instead of reinventing the wheel.
> 
> But some calls to each_entry_safe don't really need a safe version,
> just a direct list_for_each_entry is enough, this could save a temp
> variable (tmp) in every function that used rdev_for_each.
> 
> In this patch, most rdev_for_each loops are replaced by list_for_each_entry,
> totally save many tmp vars; and only in the other situations that will call
> list_del to delete an entry, the safe version is used.

Thanks Cheng.
I have included this in my "for-next" tree and it should go in to
2.6.29.

NeilBrown


> 
> Signed-off-by: Cheng Renquan <crquan@gmail.com>
> ---
> This is a reimplementation of the previous:
> 
> Subject: md: make use of list_for_each_entry_safe
> 	http://marc.info/?l=linux-raid&m=122672921822724&w=2
> 
> please ignore that silently.
> 
>  drivers/md/bitmap.c       |    3 +-
>  drivers/md/faulty.c       |    3 +-
>  drivers/md/linear.c       |    3 +-
>  drivers/md/md.c           |  109 ++++++++++++++++++---------------------------
>  drivers/md/multipath.c    |    3 +-
>  drivers/md/raid0.c        |   10 ++---
>  drivers/md/raid1.c        |    3 +-
>  drivers/md/raid10.c       |    3 +-
>  drivers/md/raid5.c        |    8 +--
>  include/linux/raid/md_k.h |   11 ++---
>  10 files changed, 61 insertions(+), 95 deletions(-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index ac89a5d..abcef18 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -213,14 +213,13 @@ static struct page *read_sb_page(mddev_t *mddev, long offset, unsigned long inde
>  	/* choose a good rdev and read the page from there */
>  
>  	mdk_rdev_t *rdev;
> -	struct list_head *tmp;
>  	struct page *page = alloc_page(GFP_KERNEL);
>  	sector_t target;
>  
>  	if (!page)
>  		return ERR_PTR(-ENOMEM);
>  
> -	rdev_for_each(rdev, tmp, mddev) {
> +	list_for_each_entry(rdev, &mddev->disks, same_set) {
>  		if (! test_bit(In_sync, &rdev->flags)
>  		    || test_bit(Faulty, &rdev->flags))
>  			continue;
> diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
> index f26c1f9..86d9adf 100644
> --- a/drivers/md/faulty.c
> +++ b/drivers/md/faulty.c
> @@ -283,7 +283,6 @@ static int reconfig(mddev_t *mddev, int layout, int chunk_size)
>  static int run(mddev_t *mddev)
>  {
>  	mdk_rdev_t *rdev;
> -	struct list_head *tmp;
>  	int i;
>  
>  	conf_t *conf = kmalloc(sizeof(*conf), GFP_KERNEL);
> @@ -296,7 +295,7 @@ static int run(mddev_t *mddev)
>  	}
>  	conf->nfaults = 0;
>  
> -	rdev_for_each(rdev, tmp, mddev)
> +	list_for_each_entry(rdev, &mddev->disks, same_set)
>  		conf->rdev = rdev;
>  
>  	mddev->array_sectors = mddev->size * 2;
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index 3b90c5c..1e3aea9 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -105,7 +105,6 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
>  	int i, nb_zone, cnt;
>  	sector_t min_sectors;
>  	sector_t curr_sector;
> -	struct list_head *tmp;
>  
>  	conf = kzalloc (sizeof (*conf) + raid_disks*sizeof(dev_info_t),
>  			GFP_KERNEL);
> @@ -115,7 +114,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
>  	cnt = 0;
>  	conf->array_sectors = 0;
>  
> -	rdev_for_each(rdev, tmp, mddev) {
> +	list_for_each_entry(rdev, &mddev->disks, same_set) {
>  		int j = rdev->raid_disk;
>  		dev_info_t *disk = conf->disks + j;
>  
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 1b1d326..adb3335 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -307,25 +307,23 @@ static inline void mddev_unlock(mddev_t * mddev)
>  
>  static mdk_rdev_t * find_rdev_nr(mddev_t *mddev, int nr)
>  {
> -	mdk_rdev_t * rdev;
> -	struct list_head *tmp;
> +	mdk_rdev_t *rdev;
>  
> -	rdev_for_each(rdev, tmp, mddev) {
> +	list_for_each_entry(rdev, &mddev->disks, same_set)
>  		if (rdev->desc_nr == nr)
>  			return rdev;
> -	}
> +
>  	return NULL;
>  }
>  
>  static mdk_rdev_t * find_rdev(mddev_t * mddev, dev_t dev)
>  {
> -	struct list_head *tmp;
>  	mdk_rdev_t *rdev;
>  
> -	rdev_for_each(rdev, tmp, mddev) {
> +	list_for_each_entry(rdev, &mddev->disks, same_set)
>  		if (rdev->bdev->bd_dev == dev)
>  			return rdev;
> -	}
> +
>  	return NULL;
>  }
>  
> @@ -861,7 +859,6 @@ static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
>  static void super_90_sync(mddev_t *mddev, mdk_rdev_t *rdev)
>  {
>  	mdp_super_t *sb;
> -	struct list_head *tmp;
>  	mdk_rdev_t *rdev2;
>  	int next_spare = mddev->raid_disks;
>  
> @@ -933,7 +930,7 @@ static void super_90_sync(mddev_t *mddev, mdk_rdev_t *rdev)
>  		sb->state |= (1<<MD_SB_BITMAP_PRESENT);
>  
>  	sb->disks[0].state = (1<<MD_DISK_REMOVED);
> -	rdev_for_each(rdev2, tmp, mddev) {
> +	list_for_each_entry(rdev2, &mddev->disks, same_set) {
>  		mdp_disk_t *d;
>  		int desc_nr;
>  		if (rdev2->raid_disk >= 0 && test_bit(In_sync, &rdev2->flags)
> @@ -1259,7 +1256,6 @@ static int super_1_validate(mddev_t *mddev, mdk_rdev_t *rdev)
>  static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
>  {
>  	struct mdp_superblock_1 *sb;
> -	struct list_head *tmp;
>  	mdk_rdev_t *rdev2;
>  	int max_dev, i;
>  	/* make rdev->sb match mddev and rdev data. */
> @@ -1307,7 +1303,7 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
>  	}
>  
>  	max_dev = 0;
> -	rdev_for_each(rdev2, tmp, mddev)
> +	list_for_each_entry(rdev2, &mddev->disks, same_set)
>  		if (rdev2->desc_nr+1 > max_dev)
>  			max_dev = rdev2->desc_nr+1;
>  
> @@ -1316,7 +1312,7 @@ static void super_1_sync(mddev_t *mddev, mdk_rdev_t *rdev)
>  	for (i=0; i<max_dev;i++)
>  		sb->dev_roles[i] = cpu_to_le16(0xfffe);
>  	
> -	rdev_for_each(rdev2, tmp, mddev) {
> +	list_for_each_entry(rdev2, &mddev->disks, same_set) {
>  		i = rdev2->desc_nr;
>  		if (test_bit(Faulty, &rdev2->flags))
>  			sb->dev_roles[i] = cpu_to_le16(0xfffe);
> @@ -1571,8 +1567,7 @@ static void kick_rdev_from_array(mdk_rdev_t * rdev)
>  
>  static void export_array(mddev_t *mddev)
>  {
> -	struct list_head *tmp;
> -	mdk_rdev_t *rdev;
> +	mdk_rdev_t *rdev, *tmp;
>  
>  	rdev_for_each(rdev, tmp, mddev) {
>  		if (!rdev->mddev) {
> @@ -1643,7 +1638,7 @@ static void print_rdev(mdk_rdev_t *rdev)
>  
>  static void md_print_devices(void)
>  {
> -	struct list_head *tmp, *tmp2;
> +	struct list_head *tmp;
>  	mdk_rdev_t *rdev;
>  	mddev_t *mddev;
>  	char b[BDEVNAME_SIZE];
> @@ -1658,11 +1653,11 @@ static void md_print_devices(void)
>  			bitmap_print_sb(mddev->bitmap);
>  		else
>  			printk("%s: ", mdname(mddev));
> -		rdev_for_each(rdev, tmp2, mddev)
> +		list_for_each_entry(rdev, &mddev->disks, same_set)
>  			printk("<%s>", bdevname(rdev->bdev,b));
>  		printk("\n");
>  
> -		rdev_for_each(rdev, tmp2, mddev)
> +		list_for_each_entry(rdev, &mddev->disks, same_set)
>  			print_rdev(rdev);
>  	}
>  	printk("md:	**********************************\n");
> @@ -1679,9 +1674,8 @@ static void sync_sbs(mddev_t * mddev, int nospares)
>  	 * with the rest of the array)
>  	 */
>  	mdk_rdev_t *rdev;
> -	struct list_head *tmp;
>  
> -	rdev_for_each(rdev, tmp, mddev) {
> +	list_for_each_entry(rdev, &mddev->disks, same_set) {
>  		if (rdev->sb_events == mddev->events ||
>  		    (nospares &&
>  		     rdev->raid_disk < 0 &&
> @@ -1699,7 +1693,6 @@ static void sync_sbs(mddev_t * mddev, int nospares)
>  
>  static void md_update_sb(mddev_t * mddev, int force_change)
>  {
> -	struct list_head *tmp;
>  	mdk_rdev_t *rdev;
>  	int sync_req;
>  	int nospares = 0;
> @@ -1790,7 +1783,7 @@ repeat:
>  		mdname(mddev),mddev->in_sync);
>  
>  	bitmap_update_sb(mddev->bitmap);
> -	rdev_for_each(rdev, tmp, mddev) {
> +	list_for_each_entry(rdev, &mddev->disks, same_set) {
>  		char b[BDEVNAME_SIZE];
>  		dprintk(KERN_INFO "md: ");
>  		if (rdev->sb_loaded != 1)
> @@ -1999,7 +1992,6 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
>  		md_wakeup_thread(rdev->mddev->thread);
>  	} else if (rdev->mddev->pers) {
>  		mdk_rdev_t *rdev2;
> -		struct list_head *tmp;
>  		/* Activating a spare .. or possibly reactivating
>  		 * if we every get bitmaps working here.
>  		 */
> @@ -2010,7 +2002,7 @@ slot_store(mdk_rdev_t *rdev, const char *buf, size_t len)
>  		if (rdev->mddev->pers->hot_add_disk == NULL)
>  			return -EINVAL;
>  
> -		rdev_for_each(rdev2, tmp, rdev->mddev)
> +		list_for_each_entry(rdev2, &rdev->mddev->disks, same_set)
>  			if (rdev2->raid_disk == slot)
>  				return -EEXIST;
>  
> @@ -2125,14 +2117,14 @@ rdev_size_store(mdk_rdev_t *rdev, const char *buf, size_t len)
>  		 */
>  		mddev_t *mddev;
>  		int overlap = 0;
> -		struct list_head *tmp, *tmp2;
> +		struct list_head *tmp;
>  
>  		mddev_unlock(my_mddev);
>  		for_each_mddev(mddev, tmp) {
>  			mdk_rdev_t *rdev2;
>  
>  			mddev_lock(mddev);
> -			rdev_for_each(rdev2, tmp2, mddev)
> +			list_for_each_entry(rdev2, &mddev->disks, same_set)
>  				if (test_bit(AllReserved, &rdev2->flags) ||
>  				    (rdev->bdev == rdev2->bdev &&
>  				     rdev != rdev2 &&
> @@ -2328,12 +2320,11 @@ abort_free:
>  static void analyze_sbs(mddev_t * mddev)
>  {
>  	int i;
> -	struct list_head *tmp;
>  	mdk_rdev_t *rdev, *freshest;
>  	char b[BDEVNAME_SIZE];
>  
>  	freshest = NULL;
> -	rdev_for_each(rdev, tmp, mddev)
> +	list_for_each_entry(rdev, &mddev->disks, same_set)
>  		switch (super_types[mddev->major_version].
>  			load_super(rdev, freshest, mddev->minor_version)) {
>  		case 1:
> @@ -2354,7 +2345,7 @@ static void analyze_sbs(mddev_t * mddev)
>  		validate_super(mddev, freshest);
>  
>  	i = 0;
> -	rdev_for_each(rdev, tmp, mddev) {
> +	list_for_each_entry(rdev, &mddev->disks, same_set) {
>  		if (rdev != freshest)
>  			if (super_types[mddev->major_version].
>  			    validate_super(mddev, rdev)) {
> @@ -3501,7 +3492,6 @@ static int do_md_run(mddev_t * mddev)
>  {
>  	int err;
>  	int chunk_size;
> -	struct list_head *tmp;
>  	mdk_rdev_t *rdev;
>  	struct gendisk *disk;
>  	struct mdk_personality *pers;
> @@ -3540,7 +3530,7 @@ static int do_md_run(mddev_t * mddev)
>  		}
>  
>  		/* devices must have minimum size of one chunk */
> -		rdev_for_each(rdev, tmp, mddev) {
> +		list_for_each_entry(rdev, &mddev->disks, same_set) {
>  			if (test_bit(Faulty, &rdev->flags))
>  				continue;
>  			if (rdev->size < chunk_size / 1024) {
> @@ -3565,7 +3555,7 @@ static int do_md_run(mddev_t * mddev)
>  	 * the only valid external interface is through the md
>  	 * device.
>  	 */
> -	rdev_for_each(rdev, tmp, mddev) {
> +	list_for_each_entry(rdev, &mddev->disks, same_set) {
>  		if (test_bit(Faulty, &rdev->flags))
>  			continue;
>  		sync_blockdev(rdev->bdev);
> @@ -3630,10 +3620,10 @@ static int do_md_run(mddev_t * mddev)
>  		 */
>  		char b[BDEVNAME_SIZE], b2[BDEVNAME_SIZE];
>  		mdk_rdev_t *rdev2;
> -		struct list_head *tmp2;
>  		int warned = 0;
> -		rdev_for_each(rdev, tmp, mddev) {
> -			rdev_for_each(rdev2, tmp2, mddev) {
> +
> +		list_for_each_entry(rdev, &mddev->disks, same_set)
> +			list_for_each_entry(rdev2, &mddev->disks, same_set) {
>  				if (rdev < rdev2 &&
>  				    rdev->bdev->bd_contains ==
>  				    rdev2->bdev->bd_contains) {
> @@ -3647,7 +3637,7 @@ static int do_md_run(mddev_t * mddev)
>  					warned = 1;
>  				}
>  			}
> -		}
> +
>  		if (warned)
>  			printk(KERN_WARNING
>  			       "True protection against single-disk"
> @@ -3694,7 +3684,7 @@ static int do_md_run(mddev_t * mddev)
>  	mddev->safemode_delay = (200 * HZ)/1000 +1; /* 200 msec delay */
>  	mddev->in_sync = 1;
>  
> -	rdev_for_each(rdev, tmp, mddev)
> +	list_for_each_entry(rdev, &mddev->disks, same_set)
>  		if (rdev->raid_disk >= 0) {
>  			char nm[20];
>  			sprintf(nm, "rd%d", rdev->raid_disk);
> @@ -3725,9 +3715,8 @@ static int do_md_run(mddev_t * mddev)
>  	 * it will remove the drives and not do the right thing
>  	 */
>  	if (mddev->degraded && !mddev->sync_thread) {
> -		struct list_head *rtmp;
>  		int spares = 0;
> -		rdev_for_each(rdev, rtmp, mddev)
> +		list_for_each_entry(rdev, &mddev->disks, same_set)
>  			if (rdev->raid_disk >= 0 &&
>  			    !test_bit(In_sync, &rdev->flags) &&
>  			    !test_bit(Faulty, &rdev->flags))
> @@ -3883,7 +3872,6 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
>  	 */
>  	if (mode == 0) {
>  		mdk_rdev_t *rdev;
> -		struct list_head *tmp;
>  
>  		printk(KERN_INFO "md: %s stopped.\n", mdname(mddev));
>  
> @@ -3895,7 +3883,7 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
>  		}
>  		mddev->bitmap_offset = 0;
>  
> -		rdev_for_each(rdev, tmp, mddev)
> +		list_for_each_entry(rdev, &mddev->disks, same_set)
>  			if (rdev->raid_disk >= 0) {
>  				char nm[20];
>  				sprintf(nm, "rd%d", rdev->raid_disk);
> @@ -3956,7 +3944,6 @@ out:
>  static void autorun_array(mddev_t *mddev)
>  {
>  	mdk_rdev_t *rdev;
> -	struct list_head *tmp;
>  	int err;
>  
>  	if (list_empty(&mddev->disks))
> @@ -3964,7 +3951,7 @@ static void autorun_array(mddev_t *mddev)
>  
>  	printk(KERN_INFO "md: running: ");
>  
> -	rdev_for_each(rdev, tmp, mddev) {
> +	list_for_each_entry(rdev, &mddev->disks, same_set) {
>  		char b[BDEVNAME_SIZE];
>  		printk("<%s>", bdevname(rdev->bdev,b));
>  	}
> @@ -3991,8 +3978,7 @@ static void autorun_array(mddev_t *mddev)
>   */
>  static void autorun_devices(int part)
>  {
> -	struct list_head *tmp;
> -	mdk_rdev_t *rdev0, *rdev;
> +	mdk_rdev_t *rdev0, *rdev, *tmp;
>  	mddev_t *mddev;
>  	char b[BDEVNAME_SIZE];
>  
> @@ -4007,7 +3993,7 @@ static void autorun_devices(int part)
>  		printk(KERN_INFO "md: considering %s ...\n",
>  			bdevname(rdev0->bdev,b));
>  		INIT_LIST_HEAD(&candidates);
> -		rdev_for_each_list(rdev, tmp, pending_raid_disks)
> +		rdev_for_each_list(rdev, tmp, &pending_raid_disks)
>  			if (super_90_load(rdev, rdev0, 0) >= 0) {
>  				printk(KERN_INFO "md:  adding %s ...\n",
>  					bdevname(rdev->bdev,b));
> @@ -4053,7 +4039,7 @@ static void autorun_devices(int part)
>  		} else {
>  			printk(KERN_INFO "md: created %s\n", mdname(mddev));
>  			mddev->persistent = 1;
> -			rdev_for_each_list(rdev, tmp, candidates) {
> +			rdev_for_each_list(rdev, tmp, &candidates) {
>  				list_del_init(&rdev->same_set);
>  				if (bind_rdev_to_array(rdev, mddev))
>  					export_rdev(rdev);
> @@ -4064,7 +4050,7 @@ static void autorun_devices(int part)
>  		/* on success, candidates will be empty, on error
>  		 * it won't...
>  		 */
> -		rdev_for_each_list(rdev, tmp, candidates) {
> +		rdev_for_each_list(rdev, tmp, &candidates) {
>  			list_del_init(&rdev->same_set);
>  			export_rdev(rdev);
>  		}
> @@ -4093,10 +4079,9 @@ static int get_array_info(mddev_t * mddev, void __user * arg)
>  	mdu_array_info_t info;
>  	int nr,working,active,failed,spare;
>  	mdk_rdev_t *rdev;
> -	struct list_head *tmp;
>  
>  	nr=working=active=failed=spare=0;
> -	rdev_for_each(rdev, tmp, mddev) {
> +	list_for_each_entry(rdev, &mddev->disks, same_set) {
>  		nr++;
>  		if (test_bit(Faulty, &rdev->flags))
>  			failed++;
> @@ -4614,9 +4599,8 @@ static int set_array_info(mddev_t * mddev, mdu_array_info_t *info)
>  
>  static int update_size(mddev_t *mddev, sector_t num_sectors)
>  {
> -	mdk_rdev_t * rdev;
> +	mdk_rdev_t *rdev;
>  	int rv;
> -	struct list_head *tmp;
>  	int fit = (num_sectors == 0);
>  
>  	if (mddev->pers->resize == NULL)
> @@ -4638,7 +4622,7 @@ static int update_size(mddev_t *mddev, sector_t num_sectors)
>  		 * grow, and re-add.
>  		 */
>  		return -EBUSY;
> -	rdev_for_each(rdev, tmp, mddev) {
> +	list_for_each_entry(rdev, &mddev->disks, same_set) {
>  		sector_t avail;
>  		avail = rdev->size * 2;
>  
> @@ -5187,11 +5171,10 @@ static void status_unused(struct seq_file *seq)
>  {
>  	int i = 0;
>  	mdk_rdev_t *rdev;
> -	struct list_head *tmp;
>  
>  	seq_printf(seq, "unused devices: ");
>  
> -	rdev_for_each_list(rdev, tmp, pending_raid_disks) {
> +	list_for_each_entry(rdev, &pending_raid_disks, same_set) {
>  		char b[BDEVNAME_SIZE];
>  		i++;
>  		seq_printf(seq, "%s ",
> @@ -5350,7 +5333,6 @@ static int md_seq_show(struct seq_file *seq, void *v)
>  {
>  	mddev_t *mddev = v;
>  	sector_t size;
> -	struct list_head *tmp2;
>  	mdk_rdev_t *rdev;
>  	struct mdstat_info *mi = seq->private;
>  	struct bitmap *bitmap;
> @@ -5387,7 +5369,7 @@ static int md_seq_show(struct seq_file *seq, void *v)
>  		}
>  
>  		size = 0;
> -		rdev_for_each(rdev, tmp2, mddev) {
> +		list_for_each_entry(rdev, &mddev->disks, same_set) {
>  			char b[BDEVNAME_SIZE];
>  			seq_printf(seq, " %s[%d]",
>  				bdevname(rdev->bdev,b), rdev->desc_nr);
> @@ -5694,7 +5676,6 @@ void md_do_sync(mddev_t *mddev)
>  	struct list_head *tmp;
>  	sector_t last_check;
>  	int skipped = 0;
> -	struct list_head *rtmp;
>  	mdk_rdev_t *rdev;
>  	char *desc;
>  
> @@ -5799,7 +5780,7 @@ void md_do_sync(mddev_t *mddev)
>  		/* recovery follows the physical size of devices */
>  		max_sectors = mddev->size << 1;
>  		j = MaxSector;
> -		rdev_for_each(rdev, rtmp, mddev)
> +		list_for_each_entry(rdev, &mddev->disks, same_set)
>  			if (rdev->raid_disk >= 0 &&
>  			    !test_bit(Faulty, &rdev->flags) &&
>  			    !test_bit(In_sync, &rdev->flags) &&
> @@ -5949,7 +5930,7 @@ void md_do_sync(mddev_t *mddev)
>  		} else {
>  			if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>  				mddev->curr_resync = MaxSector;
> -			rdev_for_each(rdev, rtmp, mddev)
> +			list_for_each_entry(rdev, &mddev->disks, same_set)
>  				if (rdev->raid_disk >= 0 &&
>  				    !test_bit(Faulty, &rdev->flags) &&
>  				    !test_bit(In_sync, &rdev->flags) &&
> @@ -5985,10 +5966,9 @@ EXPORT_SYMBOL_GPL(md_do_sync);
>  static int remove_and_add_spares(mddev_t *mddev)
>  {
>  	mdk_rdev_t *rdev;
> -	struct list_head *rtmp;
>  	int spares = 0;
>  
> -	rdev_for_each(rdev, rtmp, mddev)
> +	list_for_each_entry(rdev, &mddev->disks, same_set)
>  		if (rdev->raid_disk >= 0 &&
>  		    !test_bit(Blocked, &rdev->flags) &&
>  		    (test_bit(Faulty, &rdev->flags) ||
> @@ -6004,7 +5984,7 @@ static int remove_and_add_spares(mddev_t *mddev)
>  		}
>  
>  	if (mddev->degraded && ! mddev->ro) {
> -		rdev_for_each(rdev, rtmp, mddev) {
> +		list_for_each_entry(rdev, &mddev->disks, same_set) {
>  			if (rdev->raid_disk >= 0 &&
>  			    !test_bit(In_sync, &rdev->flags) &&
>  			    !test_bit(Blocked, &rdev->flags))
> @@ -6056,7 +6036,6 @@ static int remove_and_add_spares(mddev_t *mddev)
>  void md_check_recovery(mddev_t *mddev)
>  {
>  	mdk_rdev_t *rdev;
> -	struct list_head *rtmp;
>  
>  
>  	if (mddev->bitmap)
> @@ -6120,7 +6099,7 @@ void md_check_recovery(mddev_t *mddev)
>  		if (mddev->flags)
>  			md_update_sb(mddev, 0);
>  
> -		rdev_for_each(rdev, rtmp, mddev)
> +		list_for_each_entry(rdev, &mddev->disks, same_set)
>  			if (test_and_clear_bit(StateChanged, &rdev->flags))
>  				sysfs_notify_dirent(rdev->sysfs_state);
>  
> @@ -6149,7 +6128,7 @@ void md_check_recovery(mddev_t *mddev)
>  			 * information must be scrapped
>  			 */
>  			if (!mddev->degraded)
> -				rdev_for_each(rdev, rtmp, mddev)
> +				list_for_each_entry(rdev, &mddev->disks, same_set)
>  					rdev->saved_raid_disk = -1;
>  
>  			mddev->recovery = 0;
> diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
> index d4ac47d..f6d08f2 100644
> --- a/drivers/md/multipath.c
> +++ b/drivers/md/multipath.c
> @@ -408,7 +408,6 @@ static int multipath_run (mddev_t *mddev)
>  	int disk_idx;
>  	struct multipath_info *disk;
>  	mdk_rdev_t *rdev;
> -	struct list_head *tmp;
>  
>  	if (mddev->level != LEVEL_MULTIPATH) {
>  		printk("multipath: %s: raid level not set to multipath IO (%d)\n",
> @@ -441,7 +440,7 @@ static int multipath_run (mddev_t *mddev)
>  	}
>  
>  	conf->working_disks = 0;
> -	rdev_for_each(rdev, tmp, mddev) {
> +	list_for_each_entry(rdev, &mddev->disks, same_set) {
>  		disk_idx = rdev->raid_disk;
>  		if (disk_idx < 0 ||
>  		    disk_idx >= mddev->raid_disks)
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 8ac6488..37293d1 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -57,7 +57,6 @@ static int create_strip_zones (mddev_t *mddev)
>  	sector_t min_spacing;
>  	raid0_conf_t *conf = mddev_to_conf(mddev);
>  	mdk_rdev_t *smallest, *rdev1, *rdev2, *rdev;
> -	struct list_head *tmp1, *tmp2;
>  	struct strip_zone *zone;
>  	int cnt;
>  	char b[BDEVNAME_SIZE];
> @@ -67,11 +66,11 @@ static int create_strip_zones (mddev_t *mddev)
>  	 */
>  	conf->nr_strip_zones = 0;
>   
> -	rdev_for_each(rdev1, tmp1, mddev) {
> +	list_for_each_entry(rdev1, &mddev->disks, same_set) {
>  		printk("raid0: looking at %s\n",
>  			bdevname(rdev1->bdev,b));
>  		c = 0;
> -		rdev_for_each(rdev2, tmp2, mddev) {
> +		list_for_each_entry(rdev2, &mddev->disks, same_set) {
>  			printk("raid0:   comparing %s(%llu)",
>  			       bdevname(rdev1->bdev,b),
>  			       (unsigned long long)rdev1->size);
> @@ -119,7 +118,7 @@ static int create_strip_zones (mddev_t *mddev)
>  	cnt = 0;
>  	smallest = NULL;
>  	zone->dev = conf->devlist;
> -	rdev_for_each(rdev1, tmp1, mddev) {
> +	list_for_each_entry(rdev1, &mddev->disks, same_set) {
>  		int j = rdev1->raid_disk;
>  
>  		if (j < 0 || j >= mddev->raid_disks) {
> @@ -265,7 +264,6 @@ static int raid0_run (mddev_t *mddev)
>  	s64 size;
>  	raid0_conf_t *conf;
>  	mdk_rdev_t *rdev;
> -	struct list_head *tmp;
>  
>  	if (mddev->chunk_size == 0) {
>  		printk(KERN_ERR "md/raid0: non-zero chunk size required.\n");
> @@ -291,7 +289,7 @@ static int raid0_run (mddev_t *mddev)
>  
>  	/* calculate array device size */
>  	mddev->array_sectors = 0;
> -	rdev_for_each(rdev, tmp, mddev)
> +	list_for_each_entry(rdev, &mddev->disks, same_set)
>  		mddev->array_sectors += rdev->size * 2;
>  
>  	printk("raid0 : md_size is %llu blocks.\n", 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 9c788e2..c165b1e 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1919,7 +1919,6 @@ static int run(mddev_t *mddev)
>  	int i, j, disk_idx;
>  	mirror_info_t *disk;
>  	mdk_rdev_t *rdev;
> -	struct list_head *tmp;
>  
>  	if (mddev->level != 1) {
>  		printk("raid1: %s: raid level not set to mirroring (%d)\n",
> @@ -1964,7 +1963,7 @@ static int run(mddev_t *mddev)
>  	spin_lock_init(&conf->device_lock);
>  	mddev->queue->queue_lock = &conf->device_lock;
>  
> -	rdev_for_each(rdev, tmp, mddev) {
> +	list_for_each_entry(rdev, &mddev->disks, same_set) {
>  		disk_idx = rdev->raid_disk;
>  		if (disk_idx >= mddev->raid_disks
>  		    || disk_idx < 0)
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 970a96e..6736d6d 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2025,7 +2025,6 @@ static int run(mddev_t *mddev)
>  	int i, disk_idx;
>  	mirror_info_t *disk;
>  	mdk_rdev_t *rdev;
> -	struct list_head *tmp;
>  	int nc, fc, fo;
>  	sector_t stride, size;
>  
> @@ -2108,7 +2107,7 @@ static int run(mddev_t *mddev)
>  	spin_lock_init(&conf->device_lock);
>  	mddev->queue->queue_lock = &conf->device_lock;
>  
> -	rdev_for_each(rdev, tmp, mddev) {
> +	list_for_each_entry(rdev, &mddev->disks, same_set) {
>  		disk_idx = rdev->raid_disk;
>  		if (disk_idx >= mddev->raid_disks
>  		    || disk_idx < 0)
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index a36a743..a5ba080 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3998,7 +3998,6 @@ static int run(mddev_t *mddev)
>  	int raid_disk, memory;
>  	mdk_rdev_t *rdev;
>  	struct disk_info *disk;
> -	struct list_head *tmp;
>  	int working_disks = 0;
>  
>  	if (mddev->level != 5 && mddev->level != 4 && mddev->level != 6) {
> @@ -4108,7 +4107,7 @@ static int run(mddev_t *mddev)
>  
>  	pr_debug("raid5: run(%s) called.\n", mdname(mddev));
>  
> -	rdev_for_each(rdev, tmp, mddev) {
> +	list_for_each_entry(rdev, &mddev->disks, same_set) {
>  		raid_disk = rdev->raid_disk;
>  		if (raid_disk >= conf->raid_disks
>  		    || raid_disk < 0)
> @@ -4533,7 +4532,6 @@ static int raid5_start_reshape(mddev_t *mddev)
>  {
>  	raid5_conf_t *conf = mddev_to_conf(mddev);
>  	mdk_rdev_t *rdev;
> -	struct list_head *rtmp;
>  	int spares = 0;
>  	int added_devices = 0;
>  	unsigned long flags;
> @@ -4541,7 +4539,7 @@ static int raid5_start_reshape(mddev_t *mddev)
>  	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
>  		return -EBUSY;
>  
> -	rdev_for_each(rdev, rtmp, mddev)
> +	list_for_each_entry(rdev, &mddev->disks, same_set)
>  		if (rdev->raid_disk < 0 &&
>  		    !test_bit(Faulty, &rdev->flags))
>  			spares++;
> @@ -4563,7 +4561,7 @@ static int raid5_start_reshape(mddev_t *mddev)
>  	/* Add some new drives, as many as will fit.
>  	 * We know there are enough to make the newly sized array work.
>  	 */
> -	rdev_for_each(rdev, rtmp, mddev)
> +	list_for_each_entry(rdev, &mddev->disks, same_set)
>  		if (rdev->raid_disk < 0 &&
>  		    !test_bit(Faulty, &rdev->flags)) {
>  			if (raid5_add_disk(mddev, rdev) == 0) {
> diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
> index 8fc909e..2a29d3c 100644
> --- a/include/linux/raid/md_k.h
> +++ b/include/linux/raid/md_k.h
> @@ -334,17 +334,14 @@ static inline char * mdname (mddev_t * mddev)
>   * iterates through some rdev ringlist. It's safe to remove the
>   * current 'rdev'. Dont touch 'tmp' though.
>   */
> -#define rdev_for_each_list(rdev, tmp, list)				\
> -									\
> -	for ((tmp) = (list).next;					\
> -		(rdev) = (list_entry((tmp), mdk_rdev_t, same_set)),	\
> -			(tmp) = (tmp)->next, (tmp)->prev != &(list)	\
> -		; )
> +#define rdev_for_each_list(rdev, tmp, head)				\
> +	list_for_each_entry_safe(rdev, tmp, head, same_set)
> +
>  /*
>   * iterates through the 'same array disks' ringlist
>   */
>  #define rdev_for_each(rdev, tmp, mddev)				\
> -	rdev_for_each_list(rdev, tmp, (mddev)->disks)
> +	list_for_each_entry_safe(rdev, tmp, &((mddev)->disks), same_set)
>  
>  #define rdev_for_each_rcu(rdev, mddev)				\
>  	list_for_each_entry_rcu(rdev, &((mddev)->disks), same_set)
> -- 
> 1.6.0.2
