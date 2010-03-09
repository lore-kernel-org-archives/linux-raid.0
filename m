From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] minor md updates for 2.6.34
Date: Wed, 10 Mar 2010 09:52:02 +1100
Message-ID: <19350.53522.385933.467438@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,

Yes, I know I missed the boat, and I won't lose any sleep if this
doesn't get accepted, but here are a few minor improvements that I
would rather were in than not.

I have another bugfix coming (relating to merge_bvec_fn handling) but
I'm not confident I have that right yet so it'll some later as a
separate 'bugfix'.

Thanks,
NeilBrown


The following changes since commit 25cf84cf377c0aae5dbcf937ea89bc7893db5176:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../amit/virtio-console

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

H Hartley Sweeten (1):
      drivers/md: Remove unnecessary casts of void *

NeilBrown (1):
      md: remove some dead fields from mddev_s

Paul Clements (1):
      md: expose max value of behind writes counter

 drivers/md/bitmap.c    |   37 ++++++++++++++++++++++++++++++++-----
 drivers/md/bitmap.h    |    1 +
 drivers/md/faulty.c    |    6 +++---
 drivers/md/md.h        |    3 ---
 drivers/md/multipath.c |    2 +-
 drivers/md/raid1.c     |    8 ++++----
 drivers/md/raid10.c    |    8 ++++----
 drivers/md/raid5.c     |   10 +++++-----
 8 files changed, 50 insertions(+), 25 deletions(-)
