From: NeilBrown <neilb@suse.de>
Subject: [PATCH md] 6 Little md patches for 2.6.27 for review
Date: Tue,  5 Aug 2008 16:17:28 +1000
Message-ID: <1217917054-1725-1-git-send-email-neilb@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi,
 The following 6 patches are in my for-next tree and will probably
 be sent to Linus shortly.

 Any review always appreciated.

Thanks.

  git://neil.brown.name/md for-next


NeilBrown (6):
  Make writes to md/safe_mode_delay immediately effective.
  Restore force switch of md array to readonly at reboot time.
  Fail safely when trying to grow an array with a write-intent bitmap.
  Don't let a blocked_rdev interfere with read request in raid5/6
  Allow faulty devices to be removed from a readonly array.
  Allow raid10 resync to happening in larger chunks.

 drivers/md/md.c     |   29 +++++++++++++++++++++++++++--
 drivers/md/raid10.c |    9 +++++----
 drivers/md/raid5.c  |   32 ++++++++++++++++++++++++--------
 3 files changed, 56 insertions(+), 14 deletions(-)

