From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 0/4] Assorted minor improvements.
Date: Fri, 04 Nov 2016 16:46:02 +1100
Message-ID: <147823807607.6764.8460942745584467311.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

There is no real pattern to these patches except that they are fairly
boring but occasionally useful.

The first allows --add and --remove commands to succeed without
waiting for a metadata write, which is just wasted time.  This can be
useful when adding/removes hundreds of devices on a large RAID10
array.

The next two abort some writes which have become pointless.  If a
device fails in a way that causes long retries, this can reduce the
total time  for recovery

The last is a small correctness fix bitmap_daemon_work() doesn't wait
for writes to complete, so they might still be pending when the next
writes is sent, and two writes to the same location might not be
handled properly.  So we insert waits in the rare case that they are
needed.

Thanks,
NeilBrown

---

NeilBrown (4):
      md: perform async updates for metadata where possible.
      md/raid1: abort delayed writes when device fails.
      md/raid10: abort delayed writes when device fails.
      md/bitmap: Don't write bitmap while earlier writes might be in-flight


 drivers/md/bitmap.c |   27 ++++++++++++++++++++++-----
 drivers/md/md.c     |   16 ++++++++++++----
 drivers/md/raid1.c  |   20 +++++++++++++++-----
 drivers/md/raid10.c |   22 ++++++++++++++++------
 4 files changed, 65 insertions(+), 20 deletions(-)

--
Signature

