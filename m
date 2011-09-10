From: NeilBrown <neilb@suse.de>
Subject: [PULL REQUEST] more md fixes for 3.1
Date: Sat, 10 Sep 2011 17:33:20 +1000
Message-ID: <20110910173320.3e62bea0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux RAID <linux-raid@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Pim Zandbergen <P.Zandbergen@macroscoop.nl>, Bruno Wolff III <bruno@wolff.to>, Wu Fengguang <fengguang.wu@intel.com>, Christoph Hellwig <hch@lst.de>, Hugh Dickins <hughd@google.com>
List-Id: linux-raid.ids


Hi Linus, 
 a few more little fixes for md for 3.1
 One is not in md code but is triggered by md.
 one is a minor fix needed to prepare for the next
 one fixed a bug introduced in 3.1
 last is a longer standing bug which is cc:ed to stable.

Thanks,
NeilBrown



The following changes since commit ddf28352b80c86754a6424e3a61e8bdf9213b3c7:

  Linux 3.1-rc5 (2011-09-04 15:45:10 -0700)

are available in the git repository at:
  git://neil.brown.name/md for-linus

NeilBrown (4):
      Avoid dereferencing a 'request_queue' after last close.
      md/raid10: unify handling of write completion.
      md/raid1,10: Remove use-after-free bug in make_request.
      md: Fix handling for devices from 2TB to 4TB in 0.90 metadata.

 drivers/md/md.c     |   12 ++++++++++--
 drivers/md/raid1.c  |   14 +++++++++-----
 drivers/md/raid10.c |   47 ++++++++++++++++++++++++-----------------------
 fs/block_dev.c      |    7 +++++--
 4 files changed, 48 insertions(+), 32 deletions(-)
