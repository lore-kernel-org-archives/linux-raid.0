From: NeilBrown <neilb@suse.com>
Subject: [GIT PULL REQUEST] md updates for 4.2
Date: Mon, 29 Jun 2015 11:19:25 +1000
Message-ID: <20150629111925.1507f4de@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, XiaoNi <xni@redhat.com>, Nate Clark <nate@neworld.us>, Firo Yang <firogm@gmail.com>, Shaohua Li <shli@fb.com>, Yuanhan Liu <yuanhan.liu@linux.intel.com>, Alexey Dobriyan <adobriyan@gmail.com>, Kent Overstreet <kent.overstreet@gmail.com>, Christoph Hellwig <hch@infradead.org>, Dongsu Park <dpark@posteo.net>, Ming Lin <mlin@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>
List-Id: linux-raid.ids

The following changes since commit
0f57d86787d8b1076ea8f9cbdddda2a46d534a27:

  Linux 4.1-rc8 (2015-06-14 15:51:10 -1000)

are available in the git repository at:

  git://neil.brown.name/md/ tags/md/4.2

for you to fetch changes up to ab16bfc732c436658d13455f28b0b4a2608a7476:

  md: clear Blocked flag on failed devices when array is read-only.
  (2015-06-25 17:16:49 +1000)

----------------------------------------------------------------
md updates for 4.2

A mixed bag
 - a few bug fixes
 - some performance improvement that decrease lock contention
 - some clean-up

Nothing major.

----------------------------------------------------------------
Alexey Dobriyan (1):
      md: convert to kstrto*()

Firo Yang (1):
      md: fix a build warning

Kent Overstreet (1):
      md/raid10: make sync_request_write() call bio_copy_data()

Neil Brown (1):
      md: clear Blocked flag on failed devices when array is read-only.

NeilBrown (2):
      md: clear mddev->private when it has been freed.
      md: unlock mddev_lock on an error path.

Shaohua Li (1):
      md/raid5: ignore released_stripes check

Yuanhan Liu (3):
      wait: introduce wait_event_exclusive_cmd
      md/raid5: split wait_for_stripe and introduce wait_for_quiescent
      md/raid5: per hash value and exclusive wait_for_stripe

 drivers/md/md.c      | 167 ++++++++++++++++++++++++++++++---------------------
 drivers/md/raid10.c  |  18 ++----
 drivers/md/raid5.c   |  46 +++++++++-----
 drivers/md/raid5.h   |   3 +-
 include/linux/wait.h |  13 ++++
 5 files changed, 146 insertions(+), 101 deletions(-)
