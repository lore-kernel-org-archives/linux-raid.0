From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 0/2] md: two patches
Date: Wed, 12 Jul 2017 16:28:09 +0800
Message-ID: <20170712082809.369-1-ming.lei@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-raid.ids

This 1st patch fixes one issue introduced in the following two
commits:
	Fixes: f0250618361d(md: raid10: don't use bio's vec table to manage resync pages)
	Fixes: 98d30c5812c3(md: raid1: don't use bio's vec table to manage resync pages)

The 2nd one initializes bvec table of bio via bio_add_page() after bio_reset().


Ming Lei (2):
  md: remove 'idx' from 'struct resync_pages'
  md: raid1/raid10: initialize bvec table via bio_add_page()

 drivers/md/md.c     | 21 +++++++++++++++++++++
 drivers/md/md.h     |  4 +++-
 drivers/md/raid1.c  | 22 +++++-----------------
 drivers/md/raid10.c | 10 +++++-----
 4 files changed, 34 insertions(+), 23 deletions(-)

-- 
2.9.4
