From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] md bug fix relating to merge_bvec_fn
Date: Tue, 16 Mar 2010 17:11:26 +1100
Message-ID: <19359.8462.660720.717447@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When an md device stacks on top of a device which defines a
merge_bvec_fn, the md device must either call that function to check
that bios aren't created which are 'too big' (often a difficult thing
to do) or must ensure the bios never have more than a single page.

It came up in a recent discussion on dm-devel that the current
approach of limiting a request to PAGE_SIZE is not sufficient as you
could have several sub-page buffers.

So this patch changes to the use max_segments and
segment_boundary_mask to ensure there is only a single page - or part
there of - in a bio if an underlying device has a merge_bvec_fn.

This can affect 'xen' installations particularly.

This patch is tagged for -stable.

Thanks,
NeilBrown


The following changes since commit 25cf84cf377c0aae5dbcf937ea89bc7893db5176:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../amit/virtio-console

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

NeilBrown (1):
      md: deal with merge_bvec_fn in component devices better.

 drivers/md/linear.c    |   12 +++++++-----
 drivers/md/multipath.c |   20 ++++++++++++--------
 drivers/md/raid0.c     |   13 +++++++------
 drivers/md/raid1.c     |   28 +++++++++++++++++-----------
 drivers/md/raid10.c    |   28 +++++++++++++++++-----------
 5 files changed, 60 insertions(+), 41 deletions(-)
