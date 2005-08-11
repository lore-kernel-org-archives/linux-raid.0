From: djani22@dynamicweb.hu
Subject: RAID5 spare change
Date: Thu, 11 Aug 2005 10:51:34 +0200
Message-ID: <010201c59e52$460d22a0$0400a8c0@LocalHost>
References: <20050811171720.10115.patches@notabene> <E1E37OV-0002jQ-5u@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,

It is possible, to chage (swap) the spare drive and another one drive on the
working raid5 array without failing any device?
I have an good, but slow drive in the array, and I want to swap it with the
spare, because it is faster.
I know, when I mark the slow drive to failed-device, the system does it
automatically, but when the resync is happening, the whole system slows down
too much.

It is possible to mirror only one drive, and after it is synced, remove the
old, or similar?

Any idea?

Thanks!

Janos


----- Original Message -----
From: "NeilBrown" <neilb@cse.unsw.edu.au>
To: "Andrew Morton" <akpm@osdl.org>
Cc: <linux-raid@vger.kernel.org>
Sent: Thursday, August 11, 2005 9:22 AM
Subject: [PATCH md 005 of 6] Support write-mostly device in raid1


>
> This allows a device in a raid1 to be marked as "write mostly".
> Read requests will only be sent if there is no other option.
>
> Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>
>
> ### Diffstat output
>  ./drivers/md/md.c           |   18 ++++++++++
>  ./drivers/md/raid1.c        |   76
++++++++++++++++++++++++++++++--------------
>  ./include/linux/raid/md_k.h |    3 +
>  ./include/linux/raid/md_p.h |   11 +++++-
>  4 files changed, 82 insertions(+), 26 deletions(-)
>
> diff ./drivers/md/md.c~current~ ./drivers/md/md.c
> --- ./drivers/md/md.c~current~ 2005-08-11 15:35:33.000000000 +1000
> +++ ./drivers/md/md.c 2005-08-11 16:03:03.000000000 +1000
> @@ -671,6 +671,7 @@ static int super_90_validate(mddev_t *md
>
>   if (mddev->level != LEVEL_MULTIPATH) {
>   rdev->faulty = 0;
> + rdev->flags = 0;
>   desc = sb->disks + rdev->desc_nr;
>
>   if (desc->state & (1<<MD_DISK_FAULTY))
> @@ -680,6 +681,8 @@ static int super_90_validate(mddev_t *md
>   rdev->in_sync = 1;
>   rdev->raid_disk = desc->raid_disk;
>   }
> + if (desc->state & (1<<MD_DISK_WRITEMOSTLY))
> + set_bit(WriteMostly, &rdev->flags);
>   } else /* MULTIPATH are always insync */
>   rdev->in_sync = 1;
>   return 0;
> @@ -778,6 +781,8 @@ static void super_90_sync(mddev_t *mddev
>   spare++;
>   working++;
>   }
> + if (test_bit(WriteMostly, &rdev2->flags))
> + d->state |= (1<<MD_DISK_WRITEMOSTLY);
>   }
>
>   /* now set the "removed" and "faulty" bits on any missing devices */
> @@ -991,6 +996,9 @@ static int super_1_validate(mddev_t *mdd
>   rdev->raid_disk = role;
>   break;
>   }
> + rdev->flags = 0;
> + if (sb->devflags & WriteMostly1)
> + set_bit(WriteMostly, &rdev->flags);
>   } else /* MULTIPATH are always insync */
>   rdev->in_sync = 1;
>
> @@ -2151,6 +2159,8 @@ static int get_disk_info(mddev_t * mddev
>   info.state |= (1<<MD_DISK_ACTIVE);
>   info.state |= (1<<MD_DISK_SYNC);
>   }
> + if (test_bit(WriteMostly, &rdev->flags))
> + info.state |= (1<<MD_DISK_WRITEMOSTLY);
>   } else {
>   info.major = info.minor = 0;
>   info.raid_disk = -1;
> @@ -2236,6 +2246,9 @@ static int add_new_disk(mddev_t * mddev,
>   rdev->saved_raid_disk = rdev->raid_disk;
>
>   rdev->in_sync = 0; /* just to be sure */
> + if (info->state & (1<<MD_DISK_WRITEMOSTLY))
> + set_bit(WriteMostly, &rdev->flags);
> +
>   rdev->raid_disk = -1;
>   err = bind_rdev_to_array(rdev, mddev);
>   if (err)
> @@ -2277,6 +2290,9 @@ static int add_new_disk(mddev_t * mddev,
>   else
>   rdev->in_sync = 0;
>
> + if (info->state & (1<<MD_DISK_WRITEMOSTLY))
> + set_bit(WriteMostly, &rdev->flags);
> +
>   err = bind_rdev_to_array(rdev, mddev);
>   if (err) {
>   export_rdev(rdev);
> @@ -3329,6 +3345,8 @@ static int md_seq_show(struct seq_file *
>   char b[BDEVNAME_SIZE];
>   seq_printf(seq, " %s[%d]",
>   bdevname(rdev->bdev,b), rdev->desc_nr);
> + if (test_bit(WriteMostly, &rdev->flags))
> + seq_printf(seq, "(W)");
>   if (rdev->faulty) {
>   seq_printf(seq, "(F)");
>   continue;
>
> diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
> --- ./drivers/md/raid1.c~current~ 2005-08-11 15:14:05.000000000 +1000
> +++ ./drivers/md/raid1.c 2005-08-11 16:03:03.000000000 +1000
> @@ -360,13 +360,14 @@ static int read_balance(conf_t *conf, r1
>  {
>   const unsigned long this_sector = r1_bio->sector;
>   int new_disk = conf->last_used, disk = new_disk;
> + int wonly_disk = -1;
>   const int sectors = r1_bio->sectors;
>   sector_t new_distance, current_distance;
> - mdk_rdev_t *new_rdev, *rdev;
> + mdk_rdev_t *rdev;
>
>   rcu_read_lock();
>   /*
> - * Check if it if we can balance. We can balance on the whole
> + * Check if we can balance. We can balance on the whole
>   * device if no resync is going on, or below the resync window.
>   * We take the first readable disk when above the resync window.
>   */
> @@ -376,11 +377,16 @@ static int read_balance(conf_t *conf, r1
>   /* Choose the first operation device, for consistancy */
>   new_disk = 0;
>
> - while ((new_rdev=conf->mirrors[new_disk].rdev) == NULL ||
> -        !new_rdev->in_sync) {
> - new_disk++;
> - if (new_disk == conf->raid_disks) {
> - new_disk = -1;
> + for (rdev = conf->mirrors[new_disk].rdev;
> +      !rdev || !rdev->in_sync
> +      || test_bit(WriteMostly, &rdev->flags);
> +      rdev = conf->mirrors[++new_disk].rdev) {
> +
> + if (rdev && rdev->in_sync)
> + wonly_disk = new_disk;
> +
> + if (new_disk == conf->raid_disks - 1) {
> + new_disk = wonly_disk;
>   break;
>   }
>   }
> @@ -389,16 +395,26 @@ static int read_balance(conf_t *conf, r1
>
>
>   /* make sure the disk is operational */
> - while ((new_rdev=conf->mirrors[new_disk].rdev) == NULL ||
> -        !new_rdev->in_sync) {
> + for (rdev = conf->mirrors[new_disk].rdev;
> +      !rdev || !rdev->in_sync ||
> +      test_bit(WriteMostly, &rdev->flags);
> +      rdev = conf->mirrors[new_disk].rdev) {
> +
> + if (rdev && rdev->in_sync)
> + wonly_disk = new_disk;
> +
>   if (new_disk <= 0)
>   new_disk = conf->raid_disks;
>   new_disk--;
>   if (new_disk == disk) {
> - new_disk = -1;
> - goto rb_out;
> + new_disk = wonly_disk;
> + break;
>   }
>   }
> +
> + if (new_disk < 0)
> + goto rb_out;
> +
>   disk = new_disk;
>   /* now disk == new_disk == starting point for search */
>
> @@ -419,37 +435,41 @@ static int read_balance(conf_t *conf, r1
>   disk = conf->raid_disks;
>   disk--;
>
> - if ((rdev=conf->mirrors[disk].rdev) == NULL ||
> -     !rdev->in_sync)
> + rdev = conf->mirrors[disk].rdev;
> +
> + if (!rdev ||
> +     !rdev->in_sync ||
> +     test_bit(WriteMostly, &rdev->flags))
>   continue;
>
>   if (!atomic_read(&rdev->nr_pending)) {
>   new_disk = disk;
> - new_rdev = rdev;
>   break;
>   }
>   new_distance = abs(this_sector - conf->mirrors[disk].head_position);
>   if (new_distance < current_distance) {
>   current_distance = new_distance;
>   new_disk = disk;
> - new_rdev = rdev;
>   }
>   } while (disk != conf->last_used);
>
> -rb_out:
> + rb_out:
>
>
>   if (new_disk >= 0) {
> - conf->next_seq_sect = this_sector + sectors;
> - conf->last_used = new_disk;
> - atomic_inc(&new_rdev->nr_pending);
> - if (!new_rdev->in_sync) {
> + rdev = conf->mirrors[new_disk].rdev;
> + if (!rdev)
> + goto retry;
> + atomic_inc(&rdev->nr_pending);
> + if (!rdev->in_sync) {
>   /* cannot risk returning a device that failed
>   * before we inc'ed nr_pending
>   */
> - atomic_dec(&new_rdev->nr_pending);
> + atomic_dec(&rdev->nr_pending);
>   goto retry;
>   }
> + conf->next_seq_sect = this_sector + sectors;
> + conf->last_used = new_disk;
>   }
>   rcu_read_unlock();
>
> @@ -1109,6 +1129,7 @@ static sector_t sync_request(mddev_t *md
>   sector_t max_sector, nr_sectors;
>   int disk;
>   int i;
> + int wonly;
>   int write_targets = 0;
>   int sync_blocks;
>   int still_degraded = 0;
> @@ -1164,14 +1185,21 @@ static sector_t sync_request(mddev_t *md
>   */
>   disk = conf->last_used;
>   /* make sure disk is operational */
> -
> + wonly = disk;
>   while (conf->mirrors[disk].rdev == NULL ||
> -        !conf->mirrors[disk].rdev->in_sync) {
> +        !conf->mirrors[disk].rdev->in_sync ||
> +        test_bit(WriteMostly, &conf->mirrors[disk].rdev->flags)
> + ) {
> + if (conf->mirrors[disk].rdev  &&
> +     conf->mirrors[disk].rdev->in_sync)
> + wonly = disk;
>   if (disk <= 0)
>   disk = conf->raid_disks;
>   disk--;
> - if (disk == conf->last_used)
> + if (disk == conf->last_used) {
> + disk = wonly;
>   break;
> + }
>   }
>   conf->last_used = disk;
>   atomic_inc(&conf->mirrors[disk].rdev->nr_pending);
>
> diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
> --- ./include/linux/raid/md_k.h~current~ 2005-08-11 15:28:56.000000000
+1000
> +++ ./include/linux/raid/md_k.h 2005-08-11 16:03:03.000000000 +1000
> @@ -181,6 +181,9 @@ struct mdk_rdev_s
>   int faulty; /* if faulty do not issue IO requests */
>   int in_sync; /* device is a full member of the array */
>
> + unsigned long flags; /* Should include faulty and in_sync here. */
> +#define WriteMostly 4 /* Avoid reading if at all possible */
> +
>   int desc_nr; /* descriptor index in the superblock */
>   int raid_disk; /* role of device in array */
>   int saved_raid_disk; /* role that device used to have in the
>
> diff ./include/linux/raid/md_p.h~current~ ./include/linux/raid/md_p.h
> --- ./include/linux/raid/md_p.h~current~ 2005-08-11 16:03:03.000000000
+1000
> +++ ./include/linux/raid/md_p.h 2005-08-11 16:03:03.000000000 +1000
> @@ -79,6 +79,11 @@
>  #define MD_DISK_SYNC 2 /* disk is in sync with the raid set */
>  #define MD_DISK_REMOVED 3 /* disk is in sync with the raid set */
>
> +#define MD_DISK_WRITEMOSTLY 9 /* disk is "write-mostly" is RAID1 config.
> +    * read requests will only be sent here in
> +    * dire need
> +    */
> +
>  typedef struct mdp_device_descriptor_s {
>   __u32 number; /* 0 Device number in the entire set       */
>   __u32 major; /* 1 Device major number       */
> @@ -193,7 +198,7 @@ struct mdp_superblock_1 {
>
>   __u64 ctime; /* lo 40 bits are seconds, top 24 are microseconds or 0*/
>   __u32 level; /* -4 (multipath), -1 (linear), 0,1,4,5 */
> - __u32 layout; /* only for raid5 currently */
> + __u32 layout; /* only for raid5 and raid10 currently */
>   __u64 size; /* used size of component devices, in 512byte sectors */
>
>   __u32 chunksize; /* in 512byte sectors */
> @@ -212,7 +217,9 @@ struct mdp_superblock_1 {
>   __u32 dev_number; /* permanent identifier of this  device - not role in
raid */
>   __u32 cnt_corrected_read; /* number of read errors that were corrected
by re-writing */
>   __u8 device_uuid[16]; /* user-space setable, ignored by kernel */
> - __u8 pad2[64-56]; /* set to 0 when writing */
> + __u8 devflags; /* per-device flags.  Only one defined...*/
> +#define WriteMostly1 1 /* mask for writemostly flag in above */
> + __u8 pad2[64-57]; /* set to 0 when writing */
>
>   /* array state information - 64 bytes */
>   __u64 utime; /* 40 bits second, 24 btes microseconds */
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

