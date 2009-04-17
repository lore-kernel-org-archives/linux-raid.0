From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 0/4] A few more MD patches for 2.6.30
Date: Fri, 17 Apr 2009 12:14:53 +1000
Message-ID: <20090417020953.13390.5371.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Following are 4 more md patches that I'll be asking Linus to pull
shortly (they are in my for-linus branch already).  The three from me
finish off the raid5 reshape enhancements by making sure that I have
accurate sysfs access to some important internals.

Any review is, of course, most welcome.

NeilBrown


---

Christoph Hellwig (1):
      md: tiny md.h cleanups

NeilBrown (3):
      md: update sync_completed and reshape_position even more often.
      md: improve usefulness and accuracy of sysfs file md/sync_completed.
      md: allow setting newly added device to 'in_sync' via sysfs.


 drivers/md/bitmap.c |    1 +
 drivers/md/md.c     |   41 ++++++++++++++++++++++++++++-------------
 drivers/md/md.h     |   21 +++++++++++++--------
 drivers/md/raid5.c  |    7 ++++++-
 4 files changed, 48 insertions(+), 22 deletions(-)

-- 
Signature

