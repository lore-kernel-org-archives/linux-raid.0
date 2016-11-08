From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 0/3] Three unrelated md patches.
Date: Wed, 09 Nov 2016 10:21:32 +1100
Message-ID: <147864718560.1076.2148299631932240330.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The first is a minor bug fix, the other to are just code improvements.
I have some patches to add "failfast" functionality, and I want to get
the small clean-ups out of the way first.

Thanks,
NeilBrown


---

NeilBrown (3):
      md/raid1: fix: IO can block resync indefinitely
      md: remove md_super_wait() call after bitmap_flush()
      md: define mddev flags, recovery flags and r1bio state bits using enums


 drivers/md/md.c    |    1 -
 drivers/md/md.h    |   76 +++++++++++++++++++++++++---------------------------
 drivers/md/raid1.c |    2 +
 drivers/md/raid1.h |   18 +++++++-----
 4 files changed, 47 insertions(+), 50 deletions(-)

--
Signature

