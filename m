From: Shaohua Li <shli@kernel.org>
Subject: [GIT PULL] MD update for 4.14-rc1
Date: Wed, 6 Sep 2017 14:26:19 -0700
Message-ID: <20170906212619.fxmyukyaqcqjn2yi@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
Please pull MD update for 4.14. The update mainly fixes bugs:
- Make raid5 ppl support several ppl from Pawel
- Several raid5-cache bug fixes from Song
- Bitmap fixes from Neil and Me
- One raid1/10 regression fix since 4.12 from Me
- Other small fixes and cleanup

Note, this pull has conflict with block tree, which can be resolved as below:

diff --cc drivers/md/raid5-ppl.c
index 1e237c4,a98ef17..cd026c8
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@@ -451,12 -456,25 +456,25 @@@ static void ppl_submit_iounit(struct pp
  	pplhdr->entries_count = cpu_to_le32(io->entries_count);
  	pplhdr->checksum = cpu_to_le32(~crc32c_le(~0, pplhdr, PPL_HEADER_SIZE));
  
+ 	/* Rewind the buffer if current PPL is larger then remaining space */
+ 	if (log->use_multippl &&
+ 	    log->rdev->ppl.sector + log->rdev->ppl.size - log->next_io_sector <
+ 	    (PPL_HEADER_SIZE + io->pp_size) >> 9)
+ 		log->next_io_sector = log->rdev->ppl.sector;
+ 
+ 
  	bio->bi_end_io = ppl_log_endio;
  	bio->bi_opf = REQ_OP_WRITE | REQ_FUA;
 -	bio->bi_bdev = log->rdev->bdev;
 +	bio_set_dev(bio, log->rdev->bdev);
- 	bio->bi_iter.bi_sector = log->rdev->ppl.sector;
+ 	bio->bi_iter.bi_sector = log->next_io_sector;
  	bio_add_page(bio, io->header_page, PAGE_SIZE, 0);
  
+ 	pr_debug("%s: log->current_io_sector: %llu\n", __func__,
+ 	    (unsigned long long)log->next_io_sector);
+ 
+ 	if (log->use_multippl)
+ 		log->next_io_sector += (PPL_HEADER_SIZE + io->pp_size) >> 9;
+ 
  	list_for_each_entry(sh, &io->stripe_list, log_list) {
  		/* entries for full stripe writes have no partial parity */
  		if (test_bit(STRIPE_FULL_WRITE, &sh->state))

Thanks,
Shaohua

The following changes since commit 143c97cc652949893c8056c679012f0aeccb80e5:

  Revert "pty: fix the cached path of the pty slave file descriptor in the master" (2017-08-23 18:16:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/shli/md.git tags/md/4.14-rc1

for you to fetch changes up to e8a27f836f165c26f867ece7f31eb5c811692319:

  md/bitmap: disable bitmap_resize for file-backed bitmaps. (2017-08-31 22:57:03 -0700)

----------------------------------------------------------------
Alexey Obitotskiy (1):
      md: notify about new spare disk in the container

Cihangir Akturk (1):
      md: replace seq_release_private with seq_release

Denys Vlasenko (1):
      lib/raid6: align AVX512 constants to 512 bits, not bytes

Guoqing Jiang (1):
      raid5: remove raid5_build_block

NeilBrown (1):
      md/bitmap: disable bitmap_resize for file-backed bitmaps.

Pawel Baldysiak (2):
      md: Runtime support for multiple ppls
      raid5-ppl: Recovery support for multiple partial parity logs

Shaohua Li (3):
      md/bitmap: copy correct data for bitmap super
      md/raid1/10: reset bio allocated from mempool
      md/raid0: attach correct cgroup info in bio

Song Liu (2):
      md/raid5: release/flush io in raid5_do_work()
      md/r5cache: call mddev_lock/unlock() in r5c_journal_mode_show

 block/bio.c                    |   2 +-
 drivers/md/bitmap.c            |   9 ++-
 drivers/md/md.c                |  20 ++++-
 drivers/md/md.h                |   1 +
 drivers/md/raid0.c             |   4 +-
 drivers/md/raid1.c             |  22 +++++-
 drivers/md/raid10.c            |  35 ++++++++-
 drivers/md/raid5-cache.c       |  12 ++-
 drivers/md/raid5-ppl.c         | 171 +++++++++++++++++++++++++++++++----------
 drivers/md/raid5.c             |  16 ++--
 include/uapi/linux/raid/md_p.h |   4 +-
 lib/raid6/avx512.c             |   2 +-
 12 files changed, 230 insertions(+), 68 deletions(-)
