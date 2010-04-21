From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] fix for v.large RAID5 with v.small chunks
Date: Wed, 21 Apr 2010 15:17:21 +1000
Message-ID: <19406.35425.223934.477541@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,
 I wonder if you would pull this fix for 2.6.33.
 If you have a very large RAID5 - say 8TB, quite easy these days -
 with very small chunks - say 4K, not common but quite possible -
 then you can get more than 2^31 chunks so storing the number of
 chunks in an 'int' doesn't really work.

Thanks,
NeilBrown

The following changes since commit 85341c61361cc45a9cc0e11c01e8f4479ef460ac:
  Linus Torvalds (1):
        Merge branch 'core-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

NeilBrown (1):
      md/raid5: allow for more than 2^31 chunks.

 drivers/md/raid5.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)
