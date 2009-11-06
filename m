From: Neil Brown <nfbrown@novell.com>
Subject: [PULL REQUEST] two more important md fixes for 2.6.32
Date: Fri, 6 Nov 2009 15:05:06 +1100
Message-ID: <19187.41074.873808.735683@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids


Hi Linus,
 please pull these two fixes.  They are needed for reliable
RAID5->RAID6 reshape in a couple of less common scenarios (e.g. device
failure during reshape).
Both are suitable for 2.6.31.y stable too.

Thanks,
NeilBrown


The following changes since commit b6727b12dd2ffb4a890eb5b13a298230c29ba45d:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/staging-2.6

are available in the git repository at:

  git://neil.brown.name/md for-linus

NeilBrown (2):
      md: don't clear endpoint for resync when resync is interrupted.
      md/raid5: make sure curr_sync_completes is uptodate when reshape starts

 drivers/md/md.c    |    5 +++--
 drivers/md/raid5.c |    2 ++
 2 files changed, 5 insertions(+), 2 deletions(-)
