From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] md updates for 2.6.31-rc
Date: Wed, 1 Jul 2009 13:20:47 +1000
Message-ID: <19018.54799.551738.530964@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jiri Slaby <jirislaby@gmail.com>
List-Id: linux-raid.ids


Hi Linus,
 please pull these md updates:  They add the appropriate call for the
 new 'topology' numbers, and fix a small assortment of bugs.

Thanks,
NeilBrown


The following changes since commit 5a4f13fad1ab5bd08dea78fc55321e429d83cddf:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/ide-2.6

are available in the git repository at:

  git://neil.brown.name/md for-linus

Martin K. Petersen (1):
      md: Use new topology calls to indicate alignment and I/O sizes

NeilBrown (5):
      md: avoid dereferencing NULL pointer when accessing suspend_* sysfs attributes.
      md: fix error path when duplicate name is found on md device creation.
      md: tidy up error paths in md_alloc
      md/raid5: suspend shouldn't affect read requests.
      md: use interruptible wait when duration is controlled by userspace.

 drivers/md/linear.c    |    4 +-
 drivers/md/md.c        |   56 +++++++++++++++++++++++++++--------------------
 drivers/md/multipath.c |    7 +++--
 drivers/md/raid0.c     |    9 ++++++-
 drivers/md/raid1.c     |    9 +++----
 drivers/md/raid10.c    |   19 +++++++++++-----
 drivers/md/raid5.c     |   28 ++++++++++++++++++-----
 7 files changed, 84 insertions(+), 48 deletions(-)
