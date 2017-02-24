From: Shaohua Li <shli@kernel.org>
Subject: Re: [GIT PULL] MD update for 4.11
Date: Fri, 24 Feb 2017 10:36:02 -0800
Message-ID: <20170224183602.st2ubzmbgt4t3bsm@kernel.org>
References: <20170224155206.tu7ub3rp7wv4faoq@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170224155206.tu7ub3rp7wv4faoq@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

On Fri, Feb 24, 2017 at 07:52:06AM -0800, Shaohua Li wrote:
> Hi,
> 
> please pull MD update for 4.11, this pull mainly fixes bugs and improves
> performance:
> - Improve scalability for raid1 from Coly
> - Improve raid5-cache read performance, disk efficiency and IO pattern from
>   Song and me
> - Fix a race condition of disk hotplug for linear from Coly
> - A few cleanup patches from Ming and Byungchul
> - Fix a memory leak from Neil
> - Fix WRITE SAME IO failure from me
> - Add doc for raid5-cache from me

I forgot to mention there is a merge conflict because of a last minute fix.
Below is the fix. Sorry about this.

Thanks,
Shaohua


diff --cc drivers/md/raid1.c
index 830ff2b,d4e8796..0000000
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@@ -1385,8 -1515,7 +1512,8 @@@ static void raid1_write_request(struct 
  				   conf->mirrors[i].rdev->data_offset);
  		mbio->bi_bdev = conf->mirrors[i].rdev->bdev;
  		mbio->bi_end_io	= raid1_end_write_request;
 -		bio_set_op_attrs(mbio, op, do_fua | do_sync);
 +		mbio->bi_opf = bio_op(bio) |
- 			(bio->bi_opf & (REQ_SYNC | REQ_PREFLUSH | REQ_FUA));
++			(bio->bi_opf & (REQ_SYNC | REQ_FUA));
  		if (test_bit(FailFast, &conf->mirrors[i].rdev->flags) &&
  		    !test_bit(WriteMostly, &conf->mirrors[i].rdev->flags) &&
  		    conf->raid_disks - mddev->degraded > 1)

> 
> Thanks,
> Shaohua
> 
> The following changes since commit 7089db84e356562f8ba737c29e472cc42d530dbc:
> 
>   Linux 4.10-rc8 (2017-02-12 13:03:20 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git for-next
> 
> for you to fetch changes up to 1ec492232ed659acde8cc00b9ecc7529778e03e1:
> 
>   md/raid1: fix write behind issues introduced by bio_clone_bioset_partial (2017-02-23 11:59:44 -0800)
> 
> ----------------------------------------------------------------
> Byungchul Park (1):
>       md/raid5: Don't reinvent the wheel but use existing llist API
> 
> Ming Lei (5):
>       block: introduce bio_clone_bioset_partial()
>       md: fail if mddev->bio_set can't be created
>       md/raid1: use bio_clone_bioset_partial() in case of write behind
>       md: remove unnecessary check on mddev
>       md: fast clone bio in bio_clone_mddev()
> 
> NeilBrown (1):
>       md: ensure md devices are freed before module is unloaded.
> 
> Shaohua Li (10):
>       raid5: only dispatch IO from raid5d for harddisk raid
>       Documentation: move MD related doc into a separate dir
>       MD: add doc for raid5-cache
>       md/raid5-cache: stripe reclaim only counts valid stripes
>       md/raid5-cache: exclude reclaiming stripes in reclaim check
>       md: disable WRITE SAME if it fails in underlayer disks
>       md/raid1: fix a use-after-free bug
>       md/linear: shutup lockdep warnning
>       md/raid1: handle flush request correctly
>       md/raid1: fix write behind issues introduced by bio_clone_bioset_partial
> 
> Song Liu (3):
>       EXPORT_SYMBOL radix_tree_replace_slot
>       md/r5cache: enable chunk_aligned_read with write back cache
>       md/r5cache: improve journal device efficiency
> 
> colyli@suse.de (3):
>       md linear: fix a race between linear_add() and linear_congested()
>       RAID1: a new I/O barrier implementation to remove resync window
>       RAID1: avoid unnecessary spin locks in I/O barrier code
> 
>  Documentation/00-INDEX                |   4 +-
>  Documentation/admin-guide/md.rst      |   5 +
>  Documentation/{ => md}/md-cluster.txt |   0
>  Documentation/md/raid5-cache.txt      | 109 +++++++
>  block/bio.c                           |  61 +++-
>  drivers/md/faulty.c                   |   2 +-
>  drivers/md/linear.c                   |  41 ++-
>  drivers/md/linear.h                   |   1 +
>  drivers/md/md.c                       |  22 +-
>  drivers/md/md.h                       |   9 +-
>  drivers/md/multipath.c                |   1 +
>  drivers/md/raid0.c                    |   1 +
>  drivers/md/raid1.c                    | 598 +++++++++++++++++++++-------------
>  drivers/md/raid1.h                    |  58 ++--
>  drivers/md/raid10.c                   |  11 +-
>  drivers/md/raid5-cache.c              | 225 +++++++++++--
>  drivers/md/raid5.c                    | 129 ++++++--
>  drivers/md/raid5.h                    |   7 +
>  include/linux/bio.h                   |  11 +-
>  lib/radix-tree.c                      |   1 +
>  20 files changed, 943 insertions(+), 353 deletions(-)
>  rename Documentation/{ => md}/md-cluster.txt (100%)
>  create mode 100644 Documentation/md/raid5-cache.txt
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
