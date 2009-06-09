From: Neil Brown <neilb@suse.de>
Subject: [PULL REQUEST] md: a few more reshape fixes for 2.6.30
Date: Tue, 9 Jun 2009 16:46:57 +1000
Message-ID: <18990.1377.176969.705222@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1756800AbZFIGqj@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Hi Linus,
 more testing, more bugs...
 I'm now in a position to easily test more of the various
 possibilities with the enhances raid5/6 reshape code and consequently
 have found a few bugs.

 Hopefully these three can still squeeze in to 2.6.30 ??

Thanks,
NeilBrown


The following changes since commit ccc0d38ec13d4649d4168c1db590137df53ad783:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

  git://neil.brown.name/md for-linus

NeilBrown (3):
      md/raid5: use conf->raid_disks in preference to mddev->raid_disk
      md/raid5 - avoid deadlocks in get_active_stripe during reshape
      md/raid5: fix bug in reshape code when chunk_size decreases.

 drivers/md/raid5.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)
