From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 0/8] Assort md updates for 2.6.31
Date: Mon, 03 Aug 2009 07:58:17 +1000
Message-ID: <20090802215444.4198.83094.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Following are a small assortment of md fixes/improvements that I will
be pushing to Linus for 2.6.31.
Review always appreciated.

NeilBrown



---

Andre Noll (1):
      md: Push down data integrity code to personalities.

Dan Williams (1):
      md/raid6: release spare page at ->stop()

NeilBrown (6):
      md: Use revalidate_disk to effect changes in size of device.
      md: allow raid5_quiesce to work properly when reshape is happening.
      md/raid5: set reshape_position correctly when reshape starts.
      md: Handle growth of v1.x metadata correctly.
      md: avoid array overflow with bad v1.x metadata
      md: when a level change reduces the number of devices, remove the excess.


 drivers/md/linear.c    |    2 +
 drivers/md/md.c        |  143 ++++++++++++++++++++++++++++++------------------
 drivers/md/md.h        |    2 +
 drivers/md/multipath.c |    5 +-
 drivers/md/raid0.c     |    1 
 drivers/md/raid1.c     |    7 ++
 drivers/md/raid10.c    |    4 +
 drivers/md/raid5.c     |   51 ++++++++---------
 8 files changed, 131 insertions(+), 84 deletions(-)

-- 

