From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] md updates for 2.6.30
Date: Thu, 7 May 2009 15:12:06 +1000
Message-ID: <18946.28070.563110.755463@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752592AbZEGFMW@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Hi,
  a few more fixes for md.  A couple relate to v.large raid10 arrays.
  several are tagged for -stable.

Thanks,
NeilBrown

 

The following changes since commit b4348f32dae3cb6eb4bc21c7ed8f76c0b11e9d6a:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://oss.sgi.com/xfs/xfs

are available in the git repository at:

  git://neil.brown.name/md for-linus

Jan Engelhardt (1):
      md: constify VFTs

NeilBrown (6):
      md: fix loading of out-of-date bitmap.
      md/raid10: don't clear bitmap during recovery if array will still be degraded.
      md: fix some (more) errors with bitmaps on devices larger than 2TB.
      md: tidy up status_resync to handle large arrays.
      md: remove ability to explicit set an inactive array to 'clean'.
      md: remove rd%d links immediately after stopping an array.

 drivers/md/bitmap.c |   29 +++++++++++----------
 drivers/md/md.c     |   70 ++++++++++++++++++++++++++++----------------------
 drivers/md/raid10.c |   12 ++++----
 3 files changed, 60 insertions(+), 51 deletions(-)
