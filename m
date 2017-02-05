From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 0/4] md: use bio_clone_fast()
Date: Sun,  5 Feb 2017 14:22:09 +0800
Message-ID: <1486275733-7268-1-git-send-email-tom.leiming@gmail.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, NeilBrown <neilb@suse.com>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

Hi,

This patches replaces bio_clone() with bio_fast_clone() in
bio_clone_mddev() because:

1) bio_clone_mddev() is used in raid normal I/O and isn't in
resync I/O path, and all the direct access to bvec table in
raid happens on resync I/O only except for write behind of raid1.
Write behind is treated specially, so the replacement is safe.

2) for write behind, bio_clone() is kept, but this patchset
introduces bio_clone_bioset_partial() to just clone one specific 
bvecs range instead of whole table. Then write behind is improved
too.


Thanks,
Ming

Ming Lei (4):
  block: introduce bio_clone_bioset_partial()
  md: introduce bio_clone_slow_mddev_partial()
  md/raid1: use bio_clone_slow_mddev_partial in case of write behind
  md: fast clone bio in bio_clone_mddev()

 block/bio.c         | 61 +++++++++++++++++++++++++++++++++++++++++------------
 drivers/md/md.c     | 24 +++++++++++++++++++--
 drivers/md/md.h     |  3 +++
 drivers/md/raid1.c  | 21 +++++++++++++-----
 include/linux/bio.h | 11 ++++++++--
 5 files changed, 98 insertions(+), 22 deletions(-)

-- 
2.7.4
