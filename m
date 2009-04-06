From: Neil Brown <neilb@suse.de>
Subject: PULL-REQUEST bug fix for md/raid1
Date: Mon, 6 Apr 2009 14:52:22 +1000
Message-ID: <18905.35462.257286.420192@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,
 it looks like a bug slipped into 2.6.29 that causes an Oops if we get
 low on memory when resyncing a raid1.  Please pull this fix, which is
 tagged to go to stable.

Thanks,
NeilBrown

The following changes since commit 6bb597507f9839b13498781e481f5458aea33620:
  Linus Torvalds (1):
        Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

NeilBrown (1):
      md/raid1 - don't assume newly allocated bvecs are initialised.

 drivers/md/raid1.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)
