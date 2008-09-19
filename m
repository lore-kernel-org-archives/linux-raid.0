From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] softlockup can trigger a false-positive inside md.
Date: Fri, 19 Sep 2008 13:56:55 +1000
Message-ID: <18643.8967.525563.973752@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,
 I think this is probably suitable for 2.6.27 as it fixes a
 regression.
 The change to softlockup in 2.6.25 to report on processes that seem
 to get stuck in TASK_UNINTERRUPTIBLE waits causes a warning when an
 md array wants to resync but has to wait for some other array one the
 same devices to finish its resync.

 This patch converts the wait to TASK_INTERRUPTIBLE to avoid the
 warning.

Thanks,
NeilBrown


The following changes since commit 45e9c0de2e86485f8b6633fd64ab19cfbff167f6:
  Arjan van de Ven (1):
        warn: Turn the netdev timeout WARN_ON() into a WARN()

are available in the git repository at:

  git://neil.brown.name/md for-linus

NeilBrown (1):
      md: Don't wait UNINTERRUPTIBLE for other resync to finish

 drivers/md/md.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)
