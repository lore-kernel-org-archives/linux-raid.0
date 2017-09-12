From: NeilBrown <neilb@suse.com>
Subject: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata
 without
Date: Tue, 12 Sep 2017 11:49:12 +1000
Message-ID: <150518076229.32691.13542756562323866921.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
 I looked again at the previous patch I posted which tried to mak
 md_update_sb() safe without taking reconfig_mutex, and realized that
 it had serious problems, particularly around devices being added or
 removed while the update was happening.

 So I decided to try a different approach, which is embodied in these
 patches.  The md thread is now explicitly allowed to call
 md_update_sb() while some other thread holds the lock and
 waits for mddev_suspend() to complete.

 Please test these and confirm that they still address the problem you
 found.

Thanks,
NeilBrown

---

NeilBrown (4):
      md: always hold reconfig_mutex when calling mddev_suspend()
      md: don't call bitmap_create() while array is quiesced.
      md: use mddev_suspend/resume instead of ->quiesce()
      md: allow metadata update while suspending.


 drivers/md/dm-raid.c     |    5 ++++-
 drivers/md/md.c          |   45 ++++++++++++++++++++++++++++++++-------------
 drivers/md/md.h          |    6 ++++++
 drivers/md/raid5-cache.c |    2 ++
 4 files changed, 44 insertions(+), 14 deletions(-)

--
Signature

