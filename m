From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: [PATCH v3] raid1: prefer disk without bad blocks
Date: Fri, 12 May 2017 14:26:10 +0200
Message-ID: <1494591970-5610-1-git-send-email-tomasz.majchrzak@intel.com>
References: <20170512122358.GA5359@proton.igk.intel.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170512122358.GA5359@proton.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@kernel.org, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
List-Id: linux-raid.ids

If an array consists of two drives and the first drive has the bad
block, the read request to the region overlapping the bad block chooses
the same disk (with bad block) as device to read from over and over and
the request gets stuck. If the first disk only partially overlaps with
bad block, it becomes a candidate ("best disk") for shorter range of
sectors. The second disk is capable of reading the entire requested
range and it is updated accordingly, however it is not recorded as a
best device for the request. In the end the request is sent to the first
disk to read entire range of sectors. It fails and is re-tried in a
moment but with the same outcome.

Actually it is quite likely scenario but it had little exposure in my
test until commit 715d40b93b10 ("md/raid1: add failfast handling for
reads.") removed preference for idle disk. Such scenario had been
passing as second disk was always chosen when idle.

Reset a candidate ("best disk") to read from if disk can read entire
range. Do it only if other disk has already been chosen as a candidate
for a smaller range. The head position / disk type logic will select
the best disk to read from - it is fine as disk with bad block won't be
considered for it.

Signed-off-by: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
---
 drivers/md/raid1.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 7c1f733..c5b32aa 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -666,8 +666,11 @@ static int read_balance(struct r1conf *conf, struct r1bio *r1_bio, int *max_sect
 					break;
 			}
 			continue;
-		} else
+		} else {
+			if ((sectors > best_good_sectors) && (best_disk >= 0))
+				best_disk = -1;
 			best_good_sectors = sectors;
+		}
 
 		if (best_disk >= 0)
 			/* At least two disks to choose from so failfast is OK */
-- 
1.8.3.1

