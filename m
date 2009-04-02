From: Neil Brown <neilb@suse.de>
Subject: PULL REQUEST: md patches for 2.6.30 merge window
Date: Fri, 3 Apr 2009 10:51:59 +1100
Message-ID: <18901.20383.185576.306972@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Andre Noll <maan@systemlinux.org>, Atsushi SAKAI <sakaia@jp.fujitsu.com>, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: linux-raid.ids


Hi Linus,
 please pull my md development tree as described below.

 Highlights (for me) are:
   moving .h file from include/linux to driver/md from Christoph.
     I'm already loving the fact that e.g. raid5.h is in the same
     directory as raid5.c :-)
   more options for reshaping arrays including raid5->raid6 and back,
     reducing the number of drives in an array and changing the chunksize.   

  There is lots of other stuff, bug fixes and other feature
  enhancements.
  A small change to md/Makefile touches 'dm' as well, hence Cc to
  Alasdair.

Thanks,
NeilBrown
   


The following changes since commit 8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84:
  Linus Torvalds (1):
        Linux 2.6.29

are available in the git repository at:

  git://neil.brown.name/md for-linus

Andre Noll (3):
      md: Make mddev->size sector-based.
      md: Represent raid device size in sectors.
      md: raid5 run(): Fix max_degraded for raid level 4.

Atsushi SAKAI (1):
      md: fix typo in FSF address

Christoph Hellwig (3):
      md: stop defining MAJOR_NR
      cleanup drivers/md/Makefile
      md: move headers out of include/linux/raid/

Dan Williams (4):
      md: add 'size' as a personality method
      md: centralize ->array_sectors modifications
      md: 'array_size' sysfs attribute
      md/raid6: move raid6 data processing to raid6_pq.ko

Martin K. Petersen (1):
      MD data integrity support

NeilBrown (41):
      md: Fix is_mddev_idle test (again).
      md: Allow write-intent bitmaps to have chunksize < PAGE_SIZE
      md: never clear bit from the write-intent bitmap when the array is degraded.
      md: write bitmap information to devices that are undergoing recovery.
      md: move LEVEL_* definition from md_k.h to md_u.h
      md: move most content from md.h to md_k.h
      md: move lots of #include lines out of .h files and into .c
      md: move md_k.h from include/linux/raid/ to drivers/md/
      md: occasionally checkpoint drive recovery to reduce duplicate effort after a crash
      md: be more consistent about setting WriteMostly flag when adding a drive to an array
      md/raid5: simplify interface for init_stripe and get_active_stripe
      md/raid5: change raid5_compute_sector and stripe_to_pdidx to take a 'previous' argument
      md/raid6: remove expectation that Q device is immediately after P device.
      md/raid5: simplify raid5_compute_sector interface
      md/raid5: Add support for new layouts for raid5 and raid6.
      md/raid5: finish support for DDF/raid6
      md: make sure new_level, new_chunksize, new_layout always have sensible values.
      md/raid5: refactor raid5 "run"
      md: md_unregister_thread should cope with being passed NULL
      md: enable suspend/resume of md devices.
      md: add ->takeover method to support changing the personality managing an array
      md: add ->takeover method for raid5 to be able to take over raid1
      md/raid5: allow layout/chunksize to be changed on an active 2-drive raid5.
      md: add takeover support for raid4 -> raid5 conversion.
      md: add takeover support for converting raid6 back into raid5
      md/raid5: drop qd_idx from r6_state
      md/raid5: enhance raid5_size to work correctly with negative delta_disks
      md: add explicit method to signal the end of a reshape.
      md/raid5: change reshape-progress measurement to cope with reshaping backwards.
      md: allow number of drives in raid5 to be reduced
      Documentation/md.txt update
      md/raid5: clearly differentiate 'before' and 'after' stripes during reshape.
      md/raid5: prepare for allowing reshape to change chunksize.
      md/raid5: prepare for allowing reshape to change layout
      md/raid5: reshape using largest of old and new chunk size
      md/raid5: allow layout and chunksize to be changed on active array.
      md: don't display meaningless values in sysfs files resync_start and sync_speed
      md/raid5: be more careful about write ordering when reshaping.
      md: remove CONFIG_MD_RAID_RESHAPE config option.
      md/raid5: minor code cleanups in make_request.
      md/raid5 revise rules for when to update metadata during reshape

 Documentation/md.txt                           |   37 +-
 crypto/xor.c                                   |    2 +-
 drivers/md/Kconfig                             |   31 +-
 drivers/md/Makefile                            |   16 +-
 drivers/md/bitmap.c                            |   49 +-
 {include/linux/raid => drivers/md}/bitmap.h    |    0
 drivers/md/faulty.c                            |   19 +-
 drivers/md/linear.c                            |   25 +-
 {include/linux/raid => drivers/md}/linear.h    |    2 -
 drivers/md/md.c                                |  615 ++++++++---
 include/linux/raid/md_k.h => drivers/md/md.h   |   66 +-
 drivers/md/mktables.c                          |   14 +-
 drivers/md/multipath.c                         |   17 +-
 {include/linux/raid => drivers/md}/multipath.h |    2 -
 drivers/md/raid0.c                             |   66 +-
 {include/linux/raid => drivers/md}/raid0.h     |    2 -
 drivers/md/raid1.c                             |   35 +-
 {include/linux/raid => drivers/md}/raid1.h     |    2 -
 drivers/md/raid10.c                            |   42 +-
 {include/linux/raid => drivers/md}/raid10.h    |    2 -
 drivers/md/raid5.c                             | 1494 +++++++++++++++++-------
 {include/linux/raid => drivers/md}/raid5.h     |  110 ++-
 drivers/md/raid6algos.c                        |   21 +-
 drivers/md/raid6altivec.uc                     |    4 +-
 drivers/md/raid6int.uc                         |    4 +-
 drivers/md/raid6mmx.c                          |    4 +-
 drivers/md/raid6recov.c                        |   13 +-
 drivers/md/raid6sse1.c                         |    4 +-
 drivers/md/raid6sse2.c                         |    4 +-
 drivers/md/raid6test/Makefile                  |    2 +-
 drivers/md/raid6test/test.c                    |    2 +-
 drivers/md/raid6x86.h                          |    2 +-
 fs/compat_ioctl.c                              |    2 +-
 include/linux/raid/md.h                        |   81 --
 include/linux/raid/md_u.h                      |   35 +
 drivers/md/raid6.h => include/linux/raid/pq.h  |   28 +-
 include/linux/raid/xor.h                       |    2 -
 init/do_mounts.h                               |    1 +
 init/do_mounts_md.c                            |    5 +-
 39 files changed, 2002 insertions(+), 860 deletions(-)
 rename {include/linux/raid => drivers/md}/bitmap.h (100%)
 rename {include/linux/raid => drivers/md}/linear.h (95%)
 rename include/linux/raid/md_k.h => drivers/md/md.h (83%)
 rename {include/linux/raid => drivers/md}/multipath.h (96%)
 rename {include/linux/raid => drivers/md}/raid0.h (96%)
 rename {include/linux/raid => drivers/md}/raid1.h (99%)
 rename {include/linux/raid => drivers/md}/raid10.h (99%)
 rename {include/linux/raid => drivers/md}/raid5.h (81%)
 delete mode 100644 include/linux/raid/md.h
 rename drivers/md/raid6.h => include/linux/raid/pq.h (86%)
