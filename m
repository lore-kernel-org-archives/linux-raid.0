From: Neil Brown <neilb@suse.de>
Subject: PULL REQUEST for md in 2.6.31 - one more fix
Date: Tue, 18 Aug 2009 11:08:51 +1000
Message-ID: <19081.65315.214890.259027@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,
 it turns out there was a little bug in a recent patch.
This fixes it.

Thanks,
NeilBrown



The following changes since commit 894ef820b10d77e2d6d717342fc408bdd9825139:
  Randy Dunlap (1):
        dm-log-userspace: fix printk format warning

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

NeilBrown (1):
      Fix new incorrect error return from do_md_stop.

 drivers/md/md.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
