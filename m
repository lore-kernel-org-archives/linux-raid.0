From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 0/3] md: three misc changes
Date: Fri, 14 Jul 2017 16:14:41 +0800
Message-ID: <20170714081444.32645-1-ming.lei@redhat.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-raid.ids

This 1st patch fixes one issue introduced in the following two
commits:
	Fixes: f0250618361d(md: raid10: don't use bio's vec table to manage resync pages)
	Fixes: 98d30c5812c3(md: raid1: don't use bio's vec table to manage resync pages)

The 2nd one initializes bvec table of bio via bio_add_page() after bio_reset().

The 3rd one moves the common definitation and helpers into raid1-10.c. 

V2:
	- fix 'page_idx' increasement in patch 1
	- move raid1/raid10 common code to raid1-raid10.c, as suggested by Neil

Ming Lei (3):
  md: remove 'idx' from 'struct resync_pages'
  md: raid1/raid10: initialize bvec table via bio_add_page()
  md: raid1-10: move raid1/raid10 common code into raid1-10.c

 drivers/md/md.h       | 54 ----------------------------------
 drivers/md/raid1-10.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/raid1.c    | 31 ++++----------------
 drivers/md/raid10.c   | 19 ++++--------
 4 files changed, 93 insertions(+), 92 deletions(-)
 create mode 100644 drivers/md/raid1-10.c

-- 
2.9.4

