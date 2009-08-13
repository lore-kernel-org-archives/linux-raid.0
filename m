From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] a few more md fixes for 2.6.31
Date: Thu, 13 Aug 2009 11:02:17 +1000
Message-ID: <19075.26137.683216.283090@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>, Mike Snitzer <snitzer@redhat.com>
List-Id: linux-raid.ids


Hi Linus, 
 please pull as follows.
 The first listed patch fixes a recent regression.
    http://bugzilla.kernel.org/show_bug.cgi?id=13944
 The remainder are some small fixes, particularly relating to
 restarting an reshape (e.g. raid5->raid6 migration) which was
 aborted in the middle.

Thanks,
NeilBrown


The following changes since commit 7b2aa037e878c939676675969983284a02958ae3:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/usb-2.6

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

NeilBrown (6):
      Remove deadlock potential in md_open
      md: never advance 'events' counter by more than 1.
      md/raid5: allow new reshape modes to be restarted in the middle.
      md/raid5: make sure a reshape restarts at the correct address.
      md/raid5: Properly remove excess drives after shrinking a raid5/6
      md: allow upper limit for resync/reshape to be set when array is read-only

 drivers/md/md.c    |   32 ++++++++++++++++----------------
 drivers/md/md.h    |   10 ++++++++++
 drivers/md/raid5.c |   34 ++++++++++++++++++++++++++++++----
 3 files changed, 56 insertions(+), 20 deletions(-)
