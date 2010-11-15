From: Neil Brown <neilb@suse.de>
Subject: Re: [RFC][PATCH] md: force full sync when adding the wrong device
 to a mirror
Date: Tue, 16 Nov 2010 10:30:22 +1100
Message-ID: <20101116103022.79236c47@notabene.brown>
References: <1289853590.25762.1405436033@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1289853590.25762.1405436033@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nate Dailey <nate.dailey@stratus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 15 Nov 2010 15:39:50 -0500
"Nate Dailey" <nate.dailey@stratus.com> wrote:

> I've got a patch (against kernel 2.6.36) to address the following scenario: the "wrong" disk with the correct UUID is added to a degraded mirror, and a fast resync is done instead of a full resync.
> 
> I posted about a similar situation a few months ago (http://www.spinics.net/lists/raid/msg29324.html). In that case I was concerned with two disks in a mirror, each disk having been assembled on its own without the other. It was suggested that I look at each superblock, and see if each device thinks that the other is failed/removed. This did indeed work.
> 
> Now, I've got something a bit different:
> 
> - one disk from a raid1 (with internal bitmap) is set aside as a backup
> - remaining disk is re-mirrored with a new partner
> - at some later time, the system is booted from the backup disk
> - one of the more-recent disks is then paired with the backup disk
> - we get an incomplete resync, using the bitmap on the backup disk
> 
> In this case, neither disk thinks that the other is failed.

When you boot from the backup disk, md will assemble the raid1 from one one
device, so it should record in the superblock that the other device is
missing.  So it will think "the other is failed".

Presumably when the more recent disk is added, you want the data on it to be
completely ignored.
If the 'more recent' disk has a newer event count that the old disk it should
be possible to trigger off that to force a full resync.  But that isn't a
complete solution as the 'backup disk' could easily get a higher event count
before the 'more recent' disk is added.

We could possibly look at the two event counts in the bitmap - for
internal-bitmap cases - and make a decision based on that....

For v1.x metadata this should be a bit easier as the device number is
distinct from its role in the array, so in the scenario you describe each
disk should think that the other is failed (or missing).

> 
> Another possible scenario is cloning a mirror to create a boot disk for a different system. Now we have two different mirrors in two different systems, each with the same MD UUID. Moving a disk from one system to the other (to replace a failed disk, for example) leads to an incorrect bitmap resync.

I would say this is a configuration error.  If you have two live arrays, you
should have two different uuids.  Otherwise confusion is too possible.  It
isn't hard to update the uuid on first boot of the cloned system.

(i.e. it is meant to be universally unique, and if you deliberately make it
not unique, that is your problem).


> 
> To deal with this, I've added a resync signature to the superblock. A new signature is generated when resync begins. If a disk with the wrong signature is added to an array, a full sync is performed.

I don't really like this.  It seems to be a very specific response to a
specific problem and I'm not sure it would generalise properly.
e.g. if I have a 3 drive raid1, remove two drives, then add them back one at
a time, I think your scheme would do a full sync on the second add, which
would be wrong.

Also I am not very keen on enhancing the v0.90 metadata format.  If we need
new functionality it should be done in the 1.x metadata.  If it then fits
acceptably into 0.90 as well - fine.  But the focus should be 1.x.

As I said, v1.x should already be able to handle this as the backup disk and
the newly added disk should get different 'dev_number' values.  If they are
different, the confusion shouldn't happen.  If they are the same - we should
fix that.


NeilBrown


> 
> Comments?
> 
> Thanks,
> 
> Nate Dailey
> Stratus Technologies
> 
> Signed-off-by: Nate Dailey <Nate.Dailey@stratus.com>
> 
> diff -uprN -X linux-2.6.36-vanilla/Documentation/dontdiff linux-2.6.36-vanilla/drivers/md/md.c linux-2.6.36/drivers/md/md.c
> --- linux-2.6.36-vanilla/drivers/md/md.c	2010-11-15 10:47:58.000000000 -0500
> +++ linux-2.6.36/drivers/md/md.c	2010-11-15 12:47:41.000000000 -0500
> @@ -653,6 +653,23 @@ static inline sector_t calc_dev_sboffset
>  	return MD_NEW_SIZE_SECTORS(num_sectors);
>  }
>  
> +#define MD_ZERO_SIGNATURE "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"
> +
> +static int md_has_zero_signature(mddev_t *mddev)
> +{
> +	return !memcmp(mddev->signature, MD_ZERO_SIGNATURE, MD_SIGNATURE_LEN);
> +}
> +
> +static void md_new_signature(mddev_t *mddev)
> +{
> +	do {
> +		get_random_bytes(mddev->signature, MD_SIGNATURE_LEN);
> +	} while (md_has_zero_signature(mddev));
> +
> +	/* Make sure the new signature is written to all disks. */
> +	set_bit(MD_CHANGE_CLEAN, &mddev->flags);
> +}
> +
>  static int alloc_disk_sb(mdk_rdev_t * rdev)
>  {
>  	if (rdev->sb_page)
> @@ -1125,6 +1142,8 @@ static int super_90_validate(mddev_t *md
>  			mddev->bitmap_info.offset =
>  				mddev->bitmap_info.default_offset;
>  
> +		memcpy(mddev->signature, sb->signature, MD_SIGNATURE_LEN);
> +
>  	} else if (mddev->pers == NULL) {
>  		/* Insist on good event counter while assembling, except
>  		 * for spares (which don't need an event count) */
> @@ -1145,6 +1164,14 @@ static int super_90_validate(mddev_t *md
>  			return 0;
>  	}
>  
> +	/* Full sync for mismatched signatures. */
> +	if (memcmp(mddev->signature, sb->signature, MD_SIGNATURE_LEN)) {
> +		char b[BDEVNAME_SIZE];
> +		printk(KERN_WARNING "md: %s mismatched signature on %s\n",
> +		       mdname(mddev), bdevname(rdev->bdev, b));
> +		return 0;
> +	}
> +
>  	if (mddev->level != LEVEL_MULTIPATH) {
>  		desc = sb->disks + rdev->desc_nr;
>  
> @@ -1310,6 +1337,9 @@ static void super_90_sync(mddev_t *mddev
>  	sb->spare_disks = spare;
>  
>  	sb->this_disk = sb->disks[rdev->desc_nr];
> +
> +	memcpy(sb->signature, mddev->signature, MD_SB_SIGNATURE_LEN);
> +
>  	sb->sb_csum = calc_sb_csum(sb);
>  }
>  
> @@ -1527,6 +1557,8 @@ static int super_1_validate(mddev_t *mdd
>  			mddev->new_chunk_sectors = mddev->chunk_sectors;
>  		}
>  
> +		memcpy(mddev->signature, sb->signature, MD_SIGNATURE_LEN);
> +
>  	} else if (mddev->pers == NULL) {
>  		/* Insist of good event counter while assembling, except for
>  		 * spares (which don't need an event count) */
> @@ -1547,6 +1579,15 @@ static int super_1_validate(mddev_t *mdd
>  			/* just a hot-add of a new device, leave raid_disk at -1 */
>  			return 0;
>  	}
> +
> +	/* Full sync for mismatched signatures. */
> +	if (memcmp(mddev->signature, sb->signature, MD_SIGNATURE_LEN)) {
> +		char b[BDEVNAME_SIZE];
> +		printk(KERN_WARNING "md: %s mismatched signature on %s\n",
> +		       mdname(mddev), bdevname(rdev->bdev, b));
> +		return 0;
> +	}
> +
>  	if (mddev->level != LEVEL_MULTIPATH) {
>  		int role;
>  		if (rdev->desc_nr < 0 ||
> @@ -1661,6 +1702,8 @@ static void super_1_sync(mddev_t *mddev,
>  			sb->dev_roles[i] = cpu_to_le16(0xffff);
>  	}
>  
> +	memcpy(sb->signature, mddev->signature, MD_SB_SIGNATURE_LEN);
> +
>  	sb->sb_csum = calc_sb_1_csum(sb);
>  }
>  
> @@ -4403,6 +4446,12 @@ int md_run(mddev_t *mddev)
>  		analyze_sbs(mddev);
>  	}
>  
> +	/* Generate a new signature for a zero-signature array, which means
> +	   the array was last assembled on a non-signature-aware kernel. */
> +	if (md_has_zero_signature(mddev)) {
> +		md_new_signature(mddev);
> +	}
> +
>  	if (mddev->level != LEVEL_NONE)
>  		request_module("md-level-%d", mddev->level);
>  	else if (mddev->clevel[0])
> @@ -6804,6 +6853,12 @@ void md_do_sync(mddev_t *mddev)
>  	}
>  	mddev->curr_resync_completed = mddev->curr_resync;
>  
> +	/* Generate a new signature at the start of resync; after this point
> +	   we don't want to allow a different disk to be added to the array. */
> +	if (!test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
> +		md_new_signature(mddev);
> +	}
> +
>  	while (j < max_sectors) {
>  		sector_t sectors;
>  
> diff -uprN -X linux-2.6.36-vanilla/Documentation/dontdiff linux-2.6.36-vanilla/drivers/md/md.h linux-2.6.36/drivers/md/md.h
> --- linux-2.6.36-vanilla/drivers/md/md.h	2010-11-15 10:47:58.000000000 -0500
> +++ linux-2.6.36/drivers/md/md.h	2010-11-15 12:01:08.000000000 -0500
> @@ -350,6 +350,9 @@ struct mddev_s
>  	atomic_t flush_pending;
>  	struct work_struct barrier_work;
>  	struct work_struct event_work;	/* used by dm to report failure event */
> +
> +#define MD_SIGNATURE_LEN 16
> +	char				signature[MD_SIGNATURE_LEN];
>  };
>  
>  
> diff -uprN -X linux-2.6.36-vanilla/Documentation/dontdiff linux-2.6.36-vanilla/include/linux/raid/md_p.h linux-2.6.36/include/linux/raid/md_p.h
> --- linux-2.6.36-vanilla/include/linux/raid/md_p.h	2010-11-15 10:47:58.000000000 -0500
> +++ linux-2.6.36/include/linux/raid/md_p.h	2010-11-15 12:29:08.000000000 -0500
> @@ -61,6 +61,7 @@
>  #define MD_SB_DESCRIPTOR_OFFSET		992
>  
>  #define MD_SB_GENERIC_CONSTANT_WORDS	32
> +#define MD_SB_SIGNATURE_LEN		16
>  #define MD_SB_GENERIC_STATE_WORDS	32
>  #define MD_SB_GENERIC_WORDS		(MD_SB_GENERIC_CONSTANT_WORDS + MD_SB_GENERIC_STATE_WORDS)
>  #define MD_SB_PERSONALITY_WORDS		64
> @@ -163,7 +164,8 @@ typedef struct mdp_superblock_s {
>  	__u32 delta_disks;	/* 15 change in number of raid_disks	      */
>  	__u32 new_layout;	/* 16 new layout			      */
>  	__u32 new_chunk;	/* 17 new chunk size (bytes)		      */
> -	__u32 gstate_sreserved[MD_SB_GENERIC_STATE_WORDS - 18];
> +	__u8 signature[MD_SB_SIGNATURE_LEN];	/* 18-21 sync signature	      */
> +	__u32 gstate_sreserved[MD_SB_GENERIC_STATE_WORDS - 22];
>  
>  	/*
>  	 * Personality information
> @@ -253,7 +255,8 @@ struct mdp_superblock_1 {
>  	__le64	resync_offset;	/* data before this offset (from data_offset) known to be in sync */
>  	__le32	sb_csum;	/* checksum upto devs[max_dev] */
>  	__le32	max_dev;	/* size of devs[] array to consider */
> -	__u8	pad3[64-32];	/* set to 0 when writing */
> +	__u8	signature[MD_SB_SIGNATURE_LEN];	/* sync signature */
> +	__u8	pad3[64-48];	/* set to 0 when writing */
>  
>  	/* device state information. Indexed by dev_number.
>  	 * 2 bytes per device

