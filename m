From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2 0/9] Asynchronous raid6 acceleration (part 3 of 3)
Date: Mon, 31 Aug 2009 09:41:04 -0700
Message-ID: <20090831163914.1696.55782.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Modify the raid6 driver to offload stripe operations to the async_tx api.

   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git raid6

The changes since v1 are:
1/ Use a percpu scribble buffer for passing the address lists and a
   raid6 spare page to the async_tx api.
2/ Fixed a potential assertion in handle_parity_checks6()
3/ An experimental multicore raid456 option.  Given the new percpu
   scheme it is a straightforward conversion to have raid5d issue 
   work to the async thread pool.

As before let me know if it is suitable to take this into linux-next via
async_tx.git/next, or if you would rather it go through md.git/for-next.

Thanks,
Dan

---

Dan Williams (4):
      md/raid456: distribute raid processing over multiple cores
      md/raid6: asynchronous handle_parity_check6
      md/raid6: asynchronous raid6 operations
      md/raid5: factor out mark_uptodate from ops_complete_compute5

Yuri Tikhonov (5):
      md/raid6: remove synchronous infrastructure
      md/raid6: asynchronous handle_stripe6
      md/raid6: asynchronous handle_stripe_dirtying6
      md/raid6: asynchronous handle_stripe_fill6
      md/raid5,6: common schedule_reconstruction for raid5/6


 drivers/md/Kconfig |   13 +
 drivers/md/raid5.c | 1246 ++++++++++++++++++++++++++++++----------------------
 drivers/md/raid5.h |    8 
 3 files changed, 728 insertions(+), 539 deletions(-)
