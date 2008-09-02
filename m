From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST md] Fixes for two recent regression
Date: Tue, 2 Sep 2008 10:25:19 +1000
Message-ID: <18620.34799.712728.280652@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
List-Id: linux-raid.ids


These patches fix two recent regressions, though I'm still not sure
exactly how the first one (do_md_stop) ever worked in the particular
situation where it started to fail.  Still, I'm sure the fix is
correct, and it does make the problem go away.

Thanks,
NeilBrown


The following changes since commit bef69ea0dcce574a425feb0a5aa4c63dd108b9a6:
  Linus Torvalds (1):
        Resource handling: add 'insert_resource_expand_to_fit()' function

are available in the git repository at:

  git://neil.brown.name/md for-linus

NeilBrown (2):
      Remove invalidate_partition call from do_md_stop.
      Fix problem with waiting while holding rcu read lock in md/bitmap.c

 drivers/md/bitmap.c |   45 ++++++++++++++++++++++++++++++++++++++-------
 drivers/md/md.c     |    2 --
 2 files changed, 38 insertions(+), 9 deletions(-)
