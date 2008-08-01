From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] md bug fixes and minor improvements
Date: Fri, 1 Aug 2008 13:02:12 +1000
Message-ID: <18578.31924.259887.735206@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arthur Jones <ajones@riverbed.com>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,
 please pull the following bugfixes for drivers/md.

Thanks,
NeilBrown



The following changes since commit 6e86841d05f371b5b9b86ce76c02aaee83352298:
  Linus Torvalds (1):
        Linux 2.6.27-rc1

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

Arthur Jones (1):
      md: raid10: wake up frozen array

Dan Williams (5):
      md: move async_tx_issue_pending_all outside spin_lock_irq
      md: fix merge error
      md: delay notification of 'active_idle' to the recovery thread
      md: do not progress the resync process if the stripe was blocked
      md: do not count blocked devices as spares

 drivers/md/md.c           |    8 ++++++--
 drivers/md/raid10.c       |    3 +++
 drivers/md/raid5.c        |   29 ++++++++++++++++++-----------
 include/linux/raid/md_k.h |    1 +
 4 files changed, 28 insertions(+), 13 deletions(-)
