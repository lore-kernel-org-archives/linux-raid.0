From: Neil Brown <neilb@suse.de>
Subject: [PULL-REQUEST]  3 md fixes suitable for 2.6.29 and -stable
Date: Wed, 25 Feb 2009 13:30:06 +1100
Message-ID: <18852.44334.513936.123107@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus, 
 Recently discovered bugs, mostly affecting raid10 (though with a
 raid1 connection).
 Can cause Oops or data corruption.

Thanks,
NeilBrown



The following changes since commit 2ec77fc93ca8731368fbe8e71f805c0569d4bcee:
  Linus Torvalds (1):
        Merge branch 'drm-fixes' of git://git.kernel.org/.../airlied/drm-2.6

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

NeilBrown (3):
      md/raid10:  Don't skip more than 1 bitmap-chunk at a time during recovery.
      md/raid10:  Don't call bitmap_cond_end_sync when we are doing recovery.
      md: avoid races when stopping resync.

 drivers/md/raid1.c  |    3 ++-
 drivers/md/raid10.c |   19 ++++++++++---------
 2 files changed, 12 insertions(+), 10 deletions(-)
