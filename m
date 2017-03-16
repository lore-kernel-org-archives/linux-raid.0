From: Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH v3 00/14]  md: cleanup on direct access to bvec table
Date: Fri, 17 Mar 2017 00:12:21 +0800
Message-ID: <20170316161235.27110-1-tom.leiming@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>
List-Id: linux-raid.ids

In MD's resync I/O path, there are lots of direct access to bio's
bvec table. This patchset kills almost all, and the conversion
is quite straightforward. One root cause of direct access to bvec
table is that resync I/O uses the bio's bvec to manage pages.
In V1, as suggested by Shaohua, a new approach is used to manage
these pages for resync I/O, turns out code becomes more clean
and readable.

Once direct access to bvec table in MD is cleaned up, we may make
multipage bvec moving on.

V3:
	- improve pages allocation & bio clone for write behind(10/14)
	- retrieve pages from preallocated page array, and avoid to user
	bio helpers(14/14)
	- change on helpers about managing resync io pages(03/14)

V2:
	- remove the patch for introducing/applying bio_remove_last_page()

V1:
	- allocate page array to manage resync pages

Thanks,
Ming

Ming Lei (14):
  md: raid1/raid10: don't handle failure of bio_add_page()
  md: move two macros into md.h
  md: prepare for managing resync I/O pages in clean way
  md: raid1: simplify r1buf_pool_free()
  md: raid1: don't use bio's vec table to manage resync pages
  md: raid1: retrieve page from pre-allocated resync page array
  md: raid1: use bio helper in process_checks()
  block: introduce bio_copy_data_partial
  md: raid1: move 'offset' out of loop
  md: raid1: improve write behind
  md: raid10: refactor code of read reshape's .bi_end_io
  md: raid10: don't use bio's vec table to manage resync pages
  md: raid10: retrieve page from preallocated resync page array
  md: raid10: avoid direct access to bvec table in
    handle_reshape_read_error

 block/bio.c         |  60 +++++++++---
 drivers/md/md.h     |  55 +++++++++++
 drivers/md/raid1.c  | 267 ++++++++++++++++++++++++++++------------------------
 drivers/md/raid1.h  |  10 +-
 drivers/md/raid10.c | 224 +++++++++++++++++++++++--------------------
 include/linux/bio.h |   2 +
 6 files changed, 376 insertions(+), 242 deletions(-)

-- 
2.9.3

