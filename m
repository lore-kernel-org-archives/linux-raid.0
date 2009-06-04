From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/8] Asynchronous raid6 acceleration (part 3 of 3)
Date: Wed, 03 Jun 2009 18:28:58 -0700
Message-ID: <20090604012709.11507.15528.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, yur@emcraft.com
List-Id: linux-raid.ids

This series covers the changes to md/raid6 to use the new offload
capabilities of async_tx.  Part 1 [1] covered the changes to async_tx
for asynchronous raid6 parity generation and recovery.  Part 2 [2]
covered the updates to the iop-adma driver to enable raid6.

A merge of these 3 topic series is available via the raid6 branch of
async_tx.git:

	git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git raid6

The basic implementation of these patches have not changed much from
Yuri's previous release [3].  Instead this series has been rebased to
incorporate the modified async_tx/raid6 apis.  Note that the rework of
md/raid456 to move its async_tx parameter allocations from the stack to
the heap was included in commit 'md/raid5: add scribble region for
buffer lists' of Part 1 [4].  Current testing in the lab is passing, and
the code is ready for wider testing.

The 'raid6' branch will be placed in linux-next and if all goes well a
pull request may be sent towards the end of the 2.6.31 merge window.

Please review.

Thanks,
Dan

[1]: http://marc.info/?l=linux-raid&m=124269482227272&w=2
[2]: http://marc.info/?l=linux-raid&m=124293271625675&w=2
[3]: http://thread.gmane.org/gmane.linux.raid/21286
[4]: http://marc.info/?l=linux-raid&m=124269482227284&w=2

---

Dan Williams (3):
      md/raid6: asynchronous handle_parity_check6
      md/raid6: asynchronous raid6 operations
      md/raid5: factor out mark_uptodate from ops_complete_compute5

Yuri Tikhonov (5):
      md/raid6: remove synchronous infrastructure
      md/raid6: asynchronous handle_stripe6
      md/raid6: asynchronous handle_stripe_dirtying6
      md/raid6: asynchronous handle_stripe_fill6
      md/raid5,6: common schedule_reconstruction for raid5/6


 drivers/md/Kconfig |    2 
 drivers/md/raid5.c | 1139 +++++++++++++++++++++++++++++-----------------------
 drivers/md/raid5.h |    8 
 3 files changed, 645 insertions(+), 504 deletions(-)
