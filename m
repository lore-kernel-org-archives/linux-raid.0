From: Dan Williams <dan.j.williams@intel.com>
Subject: [md PATCH 0/4] fix ddf asynchronous raid6 recovery
Date: Tue, 20 Oct 2009 00:11:18 -0700
Message-ID: <20091020070627.6489.4006.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

The layout test from mdadm.git caught two cases where invalid operations
were being passed to offload drivers, fixed in patch4.  The other
patches are just some minor cleanups on top of your for-next branch.
They are also available on my 'for-neil' branch.

   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/md.git for-neil

Thanks,
Dan

---

Dan Williams (4):
      md/raid6: kill a gcc-4.0.1 'uninitialized variable' warning
      async_pq: kill a stray dma_map() call and other cleanups
      async_pq: rename scribble page
      async_tx: fix asynchronous raid6 recovery for ddf layouts

 crypto/async_tx/async_pq.c          |   30 ++++++-----
 crypto/async_tx/async_raid6_recov.c |   98 ++++++++++++++++++++++++++++-------
 crypto/async_tx/raid6test.c         |    6 +-
 drivers/md/raid5.c                  |   12 +++-
 include/linux/async_tx.h            |    6 +-
 5 files changed, 108 insertions(+), 44 deletions(-)
