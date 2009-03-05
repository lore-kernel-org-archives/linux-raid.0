From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] md: move headers out of include/linux/raid/
Date: Thu, 5 Mar 2009 06:57:35 -0500
Message-ID: <20090305115735.GA24504@infradead.org>
References: <20090303183016.GA28645@lst.de> <18863.15699.843356.342040@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18863.15699.843356.342040@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 05, 2009 at 01:47:47PM +1100, Neil Brown wrote:
> On Tuesday March 3, hch@lst.de wrote:
> > Move the headers with the local structures for the disciplines and
> > bitmap.h into drivers/md/ so that they are more easily grepable for
> > hacking and not far away.  md.h is left where it is for now as there
> > are some uses from the outside.
> > 
> 
> I really like this, thanks.  I much prefer having the includes with
> the C files where they are truly local.
> 
> I've added a few patches to move md_k.h into drivers/md as well.
> I'll include them below for reference.

Btw, I think md_k.h should just be named md.h after that move, and the
old md.h in include/linux/raid/ should just go away once all the
function declarations & co are moved out.

> 
> Thanks,
> NeilBrown
> 
> 
> >From d87d4c82e921ed4aa7d458027bac66a9e18cd48f Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Thu, 5 Mar 2009 13:15:51 +1100
> Subject: [PATCH 1/4] md: move LEVEL_* definition from md_k.h to md_u.h
> 
> .. as they are part of the user-space interface.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  include/linux/raid/md_k.h |   10 ----------
>  include/linux/raid/md_u.h |   11 +++++++++++
>  2 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
> index 4aedb9f..758ec28 100644
> --- a/include/linux/raid/md_k.h
> +++ b/include/linux/raid/md_k.h
> @@ -20,16 +20,6 @@
>  
>  #ifdef CONFIG_BLOCK
>  
> -#define	LEVEL_MULTIPATH		(-4)
> -#define	LEVEL_LINEAR		(-1)
> -#define	LEVEL_FAULTY		(-5)
> -
> -/* we need a value for 'no level specified' and 0
> - * means 'raid0', so we need something else.  This is
> - * for internal use only
> - */
> -#define	LEVEL_NONE		(-1000000)
> -
>  #define MaxSector (~(sector_t)0)
>  
>  typedef struct mddev_s mddev_t;
> diff --git a/include/linux/raid/md_u.h b/include/linux/raid/md_u.h
> index 7192035..80708db 100644
> --- a/include/linux/raid/md_u.h
> +++ b/include/linux/raid/md_u.h
> @@ -85,6 +85,17 @@ typedef struct mdu_array_info_s {
>  
>  } mdu_array_info_t;
>  
> +/* non-obvious values for 'level' */
> +#define	LEVEL_MULTIPATH		(-4)
> +#define	LEVEL_LINEAR		(-1)
> +#define	LEVEL_FAULTY		(-5)
> +
> +/* we need a value for 'no level specified' and 0
> + * means 'raid0', so we need something else.  This is
> + * for internal use only
> + */
> +#define	LEVEL_NONE		(-1000000)
> +
>  typedef struct mdu_disk_info_s {
>  	/*
>  	 * configuration/status of one particular disk
> -- 
> 1.6.1.3
> 
> 
> >From 41dccc10f5bf63984379562c3b84e56c33003c71 Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Thu, 5 Mar 2009 13:16:39 +1100
> Subject: [PATCH 2/4] md: move extern function definition from md.h to md_k.h
> 
> because they really are kernel-internal definition.
> This will make it possible to move md_k.h into drivers/md/
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  include/linux/raid/md.h   |   22 ----------------------
>  include/linux/raid/md_k.h |   22 ++++++++++++++++++++++
>  2 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/raid/md.h b/include/linux/raid/md.h
> index 82bea14..eb0e9f0 100644
> --- a/include/linux/raid/md.h
> +++ b/include/linux/raid/md.h
> @@ -54,28 +54,6 @@
>  
>  extern int mdp_major;
>  
> -extern int register_md_personality(struct mdk_personality *p);
> -extern int unregister_md_personality(struct mdk_personality *p);
> -extern mdk_thread_t * md_register_thread(void (*run) (mddev_t *mddev),
> -				mddev_t *mddev, const char *name);
> -extern void md_unregister_thread(mdk_thread_t *thread);
> -extern void md_wakeup_thread(mdk_thread_t *thread);
> -extern void md_check_recovery(mddev_t *mddev);
> -extern void md_write_start(mddev_t *mddev, struct bio *bi);
> -extern void md_write_end(mddev_t *mddev);
> -extern void md_done_sync(mddev_t *mddev, int blocks, int ok);
> -extern void md_error(mddev_t *mddev, mdk_rdev_t *rdev);
> -
> -extern void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
> -			   sector_t sector, int size, struct page *page);
> -extern void md_super_wait(mddev_t *mddev);
> -extern int sync_page_io(struct block_device *bdev, sector_t sector, int size,
> -			struct page *page, int rw);
> -extern void md_do_sync(mddev_t *mddev);
> -extern void md_new_event(mddev_t *mddev);
> -extern int md_allow_write(mddev_t *mddev);
> -extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
> -
>  #endif /* CONFIG_MD */
>  #endif 
>  
> diff --git a/include/linux/raid/md_k.h b/include/linux/raid/md_k.h
> index 758ec28..4c5e2d0 100644
> --- a/include/linux/raid/md_k.h
> +++ b/include/linux/raid/md_k.h
> @@ -390,3 +390,25 @@ static inline void safe_put_page(struct page *p)
>  #endif /* CONFIG_BLOCK */
>  #endif
>  
> +
> +extern int register_md_personality(struct mdk_personality *p);
> +extern int unregister_md_personality(struct mdk_personality *p);
> +extern mdk_thread_t * md_register_thread(void (*run) (mddev_t *mddev),
> +				mddev_t *mddev, const char *name);
> +extern void md_unregister_thread(mdk_thread_t *thread);
> +extern void md_wakeup_thread(mdk_thread_t *thread);
> +extern void md_check_recovery(mddev_t *mddev);
> +extern void md_write_start(mddev_t *mddev, struct bio *bi);
> +extern void md_write_end(mddev_t *mddev);
> +extern void md_done_sync(mddev_t *mddev, int blocks, int ok);
> +extern void md_error(mddev_t *mddev, mdk_rdev_t *rdev);
> +
> +extern void md_super_write(mddev_t *mddev, mdk_rdev_t *rdev,
> +			   sector_t sector, int size, struct page *page);
> +extern void md_super_wait(mddev_t *mddev);
> +extern int sync_page_io(struct block_device *bdev, sector_t sector, int size,
> +			struct page *page, int rw);
> +extern void md_do_sync(mddev_t *mddev);
> +extern void md_new_event(mddev_t *mddev);
> +extern int md_allow_write(mddev_t *mddev);
> +extern void md_wait_for_blocked_rdev(mdk_rdev_t *rdev, mddev_t *mddev);
> -- 
> 1.6.1.3
> 
> 
> >From c8ef31f0afb1933a3c6a1d185b12e6809c42ce43 Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Thu, 5 Mar 2009 13:34:23 +1100
> Subject: [PATCH 3/4] md: move lots of #include lines out of .h files and into .c
> 
> This makes the includes more explicit, and is preparation for moving
> md_k.h to drivers/md/
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  drivers/md/bitmap.c     |    2 ++
>  drivers/md/faulty.c     |    3 +++
>  drivers/md/linear.c     |    4 ++++
>  drivers/md/linear.h     |    2 --
>  drivers/md/md.c         |    5 +++++
>  drivers/md/multipath.c  |    4 ++++
>  drivers/md/multipath.h  |    2 --
>  drivers/md/raid0.c      |    4 ++++
>  drivers/md/raid0.h      |    2 --
>  drivers/md/raid1.c      |    5 ++++-
>  drivers/md/raid1.h      |    2 --
>  drivers/md/raid10.c     |    6 ++++--
>  drivers/md/raid10.h     |    2 --
>  drivers/md/raid5.c      |    4 ++++
>  drivers/md/raid5.h      |    1 -
>  drivers/md/raid6.h      |    3 ++-
>  include/linux/raid/md.h |    4 ----
>  init/do_mounts.h        |    1 +
>  18 files changed, 37 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 7666117..1399040 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -16,6 +16,7 @@
>   * wait if count gets too high, wake when it drops to half.
>   */
>  
> +#include <linux/blkdev.h>
>  #include <linux/module.h>
>  #include <linux/errno.h>
>  #include <linux/slab.h>
> @@ -27,6 +28,7 @@
>  #include <linux/mount.h>
>  #include <linux/buffer_head.h>
>  #include <linux/raid/md.h>
> +#include <linux/raid/md_k.h>
>  #include "bitmap.h"
>  
>  /* debug macros */
> diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
> index 86d9adf..b039532 100644
> --- a/drivers/md/faulty.c
> +++ b/drivers/md/faulty.c
> @@ -62,7 +62,10 @@
>  #define	ModeShift	5
>  
>  #define MaxFault	50
> +#include <linux/blkdev.h>
>  #include <linux/raid/md.h>
> +#include <linux/raid/md_k.h>
> +#include <linux/seq_file.h>
>  
>  
>  static void faulty_fail(struct bio *bio, int error)
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index 3603ffa..db6aad5 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -16,6 +16,10 @@
>     Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  
>  */
>  
> +#include <linux/blkdev.h>
> +#include <linux/raid/md.h>
> +#include <linux/raid/md_k.h>
> +#include <linux/seq_file.h>
>  #include "linear.h"
>  
>  /*
> diff --git a/drivers/md/linear.h b/drivers/md/linear.h
> index f38b9c5..bf81795 100644
> --- a/drivers/md/linear.h
> +++ b/drivers/md/linear.h
> @@ -1,8 +1,6 @@
>  #ifndef _LINEAR_H
>  #define _LINEAR_H
>  
> -#include <linux/raid/md.h>
> -
>  struct dev_info {
>  	mdk_rdev_t	*rdev;
>  	sector_t	num_sectors;
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9a3214c..e74c9d3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -33,8 +33,10 @@
>  */
>  
>  #include <linux/kthread.h>
> +#include <linux/blkdev.h>
>  #include <linux/raid/md.h>
>  #include <linux/sysctl.h>
> +#include <linux/seq_file.h>
>  #include <linux/buffer_head.h> /* for invalidate_bdev */
>  #include <linux/poll.h>
>  #include <linux/ctype.h>
> @@ -44,6 +46,9 @@
>  #include <linux/reboot.h>
>  #include <linux/file.h>
>  #include <linux/delay.h>
> +#include <linux/raid/md_k.h>
> +#include <linux/raid/md_p.h>
> +#include <linux/raid/md_u.h>
>  #include "bitmap.h"
>  
>  /* 63 partitions with the alternate major number (mdp) */
> diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
> index 547df09..b88d9ee 100644
> --- a/drivers/md/multipath.c
> +++ b/drivers/md/multipath.c
> @@ -19,6 +19,10 @@
>   * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> +#include <linux/blkdev.h>
> +#include <linux/raid/md.h>
> +#include <linux/raid/md_k.h>
> +#include <linux/seq_file.h>
>  #include "multipath.h"
>  
>  #define MAX_WORK_PER_DISK 128
> diff --git a/drivers/md/multipath.h b/drivers/md/multipath.h
> index 6f53fc1..6fa70b4 100644
> --- a/drivers/md/multipath.h
> +++ b/drivers/md/multipath.h
> @@ -1,8 +1,6 @@
>  #ifndef _MULTIPATH_H
>  #define _MULTIPATH_H
>  
> -#include <linux/raid/md.h>
> -
>  struct multipath_info {
>  	mdk_rdev_t	*rdev;
>  };
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index ef09ed0..650ce08 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -18,6 +18,10 @@
>     Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  
>  */
>  
> +#include <linux/blkdev.h>
> +#include <linux/raid/md.h>
> +#include <linux/raid/md_k.h>
> +#include <linux/seq_file.h>
>  #include "raid0.h"
>  
>  static void raid0_unplug(struct request_queue *q)
> diff --git a/drivers/md/raid0.h b/drivers/md/raid0.h
> index fd42aa8..824b12e 100644
> --- a/drivers/md/raid0.h
> +++ b/drivers/md/raid0.h
> @@ -1,8 +1,6 @@
>  #ifndef _RAID0_H
>  #define _RAID0_H
>  
> -#include <linux/raid/md.h>
> -
>  struct strip_zone
>  {
>  	sector_t zone_start;	/* Zone offset in md_dev (in sectors) */
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index bff3228..4a6cf77 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -31,8 +31,11 @@
>   * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> -#include "dm-bio-list.h"
>  #include <linux/delay.h>
> +#include <linux/blkdev.h>
> +#include <linux/raid/md.h>
> +#include <linux/raid/md_k.h>
> +#include <linux/seq_file.h>
>  #include "raid1.h"
>  #include "bitmap.h"
>  
> diff --git a/drivers/md/raid1.h b/drivers/md/raid1.h
> index 0a9ba7c..1620eea 100644
> --- a/drivers/md/raid1.h
> +++ b/drivers/md/raid1.h
> @@ -1,8 +1,6 @@
>  #ifndef _RAID1_H
>  #define _RAID1_H
>  
> -#include <linux/raid/md.h>
> -
>  typedef struct mirror_info mirror_info_t;
>  
>  struct mirror_info {
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index f03dd70..6e6ad03 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -18,8 +18,10 @@
>   * Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>   */
>  
> -#include "dm-bio-list.h"
> -#include <linux/delay.h>
> +#include <linux/blkdev.h>
> +#include <linux/raid/md.h>
> +#include <linux/raid/md_k.h>
> +#include <linux/seq_file.h>
>  #include "raid10.h"
>  #include "bitmap.h"
>  
> diff --git a/drivers/md/raid10.h b/drivers/md/raid10.h
> index e9091cf..244dbe5 100644
> --- a/drivers/md/raid10.h
> +++ b/drivers/md/raid10.h
> @@ -1,8 +1,6 @@
>  #ifndef _RAID10_H
>  #define _RAID10_H
>  
> -#include <linux/raid/md.h>
> -
>  typedef struct mirror_info mirror_info_t;
>  
>  struct mirror_info {
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index f75698b..0028c20 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -43,8 +43,12 @@
>   * miss any bits.
>   */
>  
> +#include <linux/blkdev.h>
> +#include <linux/raid/md.h>
> +#include <linux/raid/md_k.h>
>  #include <linux/kthread.h>
>  #include <linux/async_tx.h>
> +#include <linux/seq_file.h>
>  #include "raid6.h"
>  #include "bitmap.h"
>  
> diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
> index 40f1d03..0ed22df 100644
> --- a/drivers/md/raid5.h
> +++ b/drivers/md/raid5.h
> @@ -1,7 +1,6 @@
>  #ifndef _RAID5_H
>  #define _RAID5_H
>  
> -#include <linux/raid/md.h>
>  #include <linux/raid/xor.h>
>  
>  /*
> diff --git a/drivers/md/raid6.h b/drivers/md/raid6.h
> index f6c13af..4c9010e 100644
> --- a/drivers/md/raid6.h
> +++ b/drivers/md/raid6.h
> @@ -17,8 +17,9 @@
>  
>  /* Set to 1 to use kernel-wide empty_zero_page */
>  #define RAID6_USE_EMPTY_ZERO_PAGE 0
> -
> +#include <linux/blkdev.h>
>  #include <linux/raid/md.h>
> +#include <linux/raid/md_k.h>
>  #include "raid5.h"
>  
>  typedef raid5_conf_t raid6_conf_t; /* Same configuration */
> diff --git a/include/linux/raid/md.h b/include/linux/raid/md.h
> index eb0e9f0..62adecd 100644
> --- a/include/linux/raid/md.h
> +++ b/include/linux/raid/md.h
> @@ -18,9 +18,6 @@
>  #ifndef _MD_H
>  #define _MD_H
>  
> -#include <linux/blkdev.h>
> -#include <linux/seq_file.h>
> -
>  /*
>   * 'md_p.h' holds the 'physical' layout of RAID devices
>   * 'md_u.h' holds the user <=> kernel API
> @@ -30,7 +27,6 @@
>  
>  #include <linux/raid/md_p.h>
>  #include <linux/raid/md_u.h>
> -#include <linux/raid/md_k.h>
>  
>  #ifdef CONFIG_MD
>  
> diff --git a/init/do_mounts.h b/init/do_mounts.h
> index 9aa968d..f5b978a 100644
> --- a/init/do_mounts.h
> +++ b/init/do_mounts.h
> @@ -1,4 +1,5 @@
>  #include <linux/kernel.h>
> +#include <linux/blkdev.h>
>  #include <linux/init.h>
>  #include <linux/syscalls.h>
>  #include <linux/unistd.h>
> -- 
> 1.6.1.3
> 
> 
> >From cf43f54136ccb85de844243b5c6ef1ef1c7ad196 Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Thu, 5 Mar 2009 13:38:47 +1100
> Subject: [PATCH 4/4] md: move md_k.h from include/linux/raid/ to drivers/md/
> 
> It really is nicer to keep related code together..
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---
>  drivers/md/bitmap.c                       |    2 +-
>  drivers/md/faulty.c                       |    2 +-
>  drivers/md/linear.c                       |    2 +-
>  drivers/md/md.c                           |    2 +-
>  {include/linux/raid => drivers/md}/md_k.h |    0
>  drivers/md/multipath.c                    |    2 +-
>  drivers/md/raid0.c                        |    2 +-
>  drivers/md/raid1.c                        |    2 +-
>  drivers/md/raid10.c                       |    2 +-
>  drivers/md/raid5.c                        |    2 +-
>  drivers/md/raid6.h                        |    2 +-
>  11 files changed, 10 insertions(+), 10 deletions(-)
>  rename {include/linux/raid => drivers/md}/md_k.h (100%)
> 
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index 1399040..7ce50c3 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -28,7 +28,7 @@
>  #include <linux/mount.h>
>  #include <linux/buffer_head.h>
>  #include <linux/raid/md.h>
> -#include <linux/raid/md_k.h>
> +#include "md_k.h"
>  #include "bitmap.h"
>  
>  /* debug macros */
> diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
> index b039532..c1974ea 100644
> --- a/drivers/md/faulty.c
> +++ b/drivers/md/faulty.c
> @@ -64,7 +64,7 @@
>  #define MaxFault	50
>  #include <linux/blkdev.h>
>  #include <linux/raid/md.h>
> -#include <linux/raid/md_k.h>
> +#include "md_k.h"
>  #include <linux/seq_file.h>
>  
>  
> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> index db6aad5..c42b25e 100644
> --- a/drivers/md/linear.c
> +++ b/drivers/md/linear.c
> @@ -18,8 +18,8 @@
>  
>  #include <linux/blkdev.h>
>  #include <linux/raid/md.h>
> -#include <linux/raid/md_k.h>
>  #include <linux/seq_file.h>
> +#include "md_k.h"
>  #include "linear.h"
>  
>  /*
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e74c9d3..5729a67 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -46,9 +46,9 @@
>  #include <linux/reboot.h>
>  #include <linux/file.h>
>  #include <linux/delay.h>
> -#include <linux/raid/md_k.h>
>  #include <linux/raid/md_p.h>
>  #include <linux/raid/md_u.h>
> +#include "md_k.h"
>  #include "bitmap.h"
>  
>  /* 63 partitions with the alternate major number (mdp) */
> diff --git a/include/linux/raid/md_k.h b/drivers/md/md_k.h
> similarity index 100%
> rename from include/linux/raid/md_k.h
> rename to drivers/md/md_k.h
> diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
> index b88d9ee..fc058ac 100644
> --- a/drivers/md/multipath.c
> +++ b/drivers/md/multipath.c
> @@ -21,8 +21,8 @@
>  
>  #include <linux/blkdev.h>
>  #include <linux/raid/md.h>
> -#include <linux/raid/md_k.h>
>  #include <linux/seq_file.h>
> +#include "md_k.h"
>  #include "multipath.h"
>  
>  #define MAX_WORK_PER_DISK 128
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 650ce08..92540e8 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -20,8 +20,8 @@
>  
>  #include <linux/blkdev.h>
>  #include <linux/raid/md.h>
> -#include <linux/raid/md_k.h>
>  #include <linux/seq_file.h>
> +#include "md_k.h"
>  #include "raid0.h"
>  
>  static void raid0_unplug(struct request_queue *q)
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 4a6cf77..2f6fb51 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -34,8 +34,8 @@
>  #include <linux/delay.h>
>  #include <linux/blkdev.h>
>  #include <linux/raid/md.h>
> -#include <linux/raid/md_k.h>
>  #include <linux/seq_file.h>
> +#include "md_k.h"
>  #include "raid1.h"
>  #include "bitmap.h"
>  
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 6e6ad03..d3a28ea 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -20,8 +20,8 @@
>  
>  #include <linux/blkdev.h>
>  #include <linux/raid/md.h>
> -#include <linux/raid/md_k.h>
>  #include <linux/seq_file.h>
> +#include "md_k.h"
>  #include "raid10.h"
>  #include "bitmap.h"
>  
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 0028c20..19f01da 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -45,10 +45,10 @@
>  
>  #include <linux/blkdev.h>
>  #include <linux/raid/md.h>
> -#include <linux/raid/md_k.h>
>  #include <linux/kthread.h>
>  #include <linux/async_tx.h>
>  #include <linux/seq_file.h>
> +#include "md_k.h"
>  #include "raid6.h"
>  #include "bitmap.h"
>  
> diff --git a/drivers/md/raid6.h b/drivers/md/raid6.h
> index 4c9010e..cee632e 100644
> --- a/drivers/md/raid6.h
> +++ b/drivers/md/raid6.h
> @@ -19,7 +19,7 @@
>  #define RAID6_USE_EMPTY_ZERO_PAGE 0
>  #include <linux/blkdev.h>
>  #include <linux/raid/md.h>
> -#include <linux/raid/md_k.h>
> +#include "md_k.h"
>  #include "raid5.h"
>  
>  typedef raid5_conf_t raid6_conf_t; /* Same configuration */
> -- 
> 1.6.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
