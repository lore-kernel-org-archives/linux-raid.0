From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 0/2] Fix problems with reshape on degraded raid5/6
Date: Tue, 17 Oct 2017 16:18:36 +1100
Message-ID: <150821741376.9754.10397416458024667409.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Reshape on a degraded array is supposed to work, but it
obviously hasn't been tested.
These two patches make at least one test case (reported by
Curt <lightspd@gmail.com>) to work.

Thanks,
NeilBrown


---

NeilBrown (2):
      raid5: Set R5_Expanded on parity devices as well as data.
      md: be cautious about using ->curr_resync_completed for ->recovery_offset


 drivers/md/md.c    |   32 +++++++++++++++++++++-----------
 drivers/md/raid5.c |   23 ++++++++++++++++++++++-
 2 files changed, 43 insertions(+), 12 deletions(-)

--
Signature

