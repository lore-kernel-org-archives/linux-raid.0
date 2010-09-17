From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] 2 minor md patches for 2.6.36
Date: Fri, 17 Sep 2010 20:46:42 +1000
Message-ID: <19603.18194.416958.25070@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,
 a couple of patches for little bugs that has turned up in the last
 couple of week.

 There is also an issue where a recent change to rcu_dereference
 causes it to eval it arg twice, and md/raid1.c uses a pre-increment
 in the arg so that is badness.  The rcu guys are planning to fix
 rcu_dereference so I'm leaving md/raid1 as-is for now (I have a
 rewrite of that function queued for next window) but I could remove
 the pre-inc if it doesn't get resolved before -final....

Thanks,
NeilBrown


The following changes since commit 9c03f1622af051004416dd3e24d8a0fa31e34178:

  Merge ssh://master.kernel.org/home/hpa/tree/sec (2010-09-14 17:07:51 -0700)

are available in the git repository at:

  git://neil.brown.name/md for-linus

NeilBrown (2):
      md: call md_update_sb even for 'external' metadata arrays.
      md: fix v1.x metadata update when a disk is missing.

 drivers/md/md.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)
