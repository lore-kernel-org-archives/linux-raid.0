From: Neil Brown <neilb@suse.de>
Subject: PULL REQUEST - md fixes for 2.6.31
Date: Mon, 3 Aug 2009 08:07:27 +1000
Message-ID: <19062.3615.711449.258305@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932070AbZHBWHd@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,
 Sorry that these are a little late, but I've had a few
 distractions...

 Anyway, please pull the 8 small updates for drivers/md in 2.6.31.
 Most are straight bug fixes (Some tagged for -stable).
 A couple ('Push down data integrity' and 'Use revalidate disk') are
 code cleanups that make the code more obviously correct.

Thanks,
NeilBrown


The following changes since commit 7d3e91b8a1f5179d56a7412d4b499f2d5fc6b25d:
  Linus Torvalds (1):
        Merge branch 'hwmon-for-linus' of git://git.kernel.org/.../jdelvare/staging

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

Andre Noll (1):
      md: Push down data integrity code to personalities.

Dan Williams (1):
      md/raid6: release spare page at ->stop()

NeilBrown (6):
      md: when a level change reduces the number of devices, remove the excess.
      md: avoid array overflow with bad v1.x metadata
      md: Handle growth of v1.x metadata correctly.
      md/raid5: set reshape_position correctly when reshape starts.
      md: allow raid5_quiesce to work properly when reshape is happening.
      md: Use revalidate_disk to effect changes in size of device.

 drivers/md/linear.c    |    2 +
 drivers/md/md.c        |  143 +++++++++++++++++++++++++++++------------------
 drivers/md/md.h        |    2 +
 drivers/md/multipath.c |    5 +-
 drivers/md/raid0.c     |    1 +
 drivers/md/raid1.c     |    7 ++-
 drivers/md/raid10.c    |    4 +
 drivers/md/raid5.c     |   51 ++++++++---------
 8 files changed, 131 insertions(+), 84 deletions(-)
