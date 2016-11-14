From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 0/4] Improve blktrace tracing of md.
Date: Mon, 14 Nov 2016 16:30:20 +1100
Message-ID: <147910131504.27168.6566119701315109161.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

blktrace on md devices reports when a request is queued and when it is
split, but request completion and the mapping to subordinate devices
is not reported.
So add that, as well some some events when IO is delayed for one
reason or another (eg. bitmap updates etc).

---

NeilBrown (4):
      md: add block tracing for bio_remapping
      md: add bio completion tracing for raid1/raid10
      md/bitmap: add blktrace event for writes to the bitmap.
      md/raid1,raid10: add blktrace records when IO is delayed.


 drivers/md/bitmap.c |   11 ++++++++++-
 drivers/md/linear.c |    8 +++++++-
 drivers/md/raid0.c  |    8 +++++++-
 drivers/md/raid1.c  |   42 +++++++++++++++++++++++++++++++++++++++---
 drivers/md/raid10.c |   38 ++++++++++++++++++++++++++++++++++++--
 5 files changed, 99 insertions(+), 8 deletions(-)

--
Signature

