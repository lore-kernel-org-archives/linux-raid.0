From: bingjingc <bingjingc@synology.com>
Subject: [PATCH] mdadm: prevent out-of-date reshaping devices from force
 assemble
Date: Tue, 06 Feb 2018 17:09:47 +0800
Message-ID: <e04a8ec7b4b5f8e8cefac05997c781c1@synology.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


With "--force", we can assemble the array even if some superblocks
appear out-of-date. But their data layout is regarded to make sense.
In reshape cases, if two devices claims different reshape progresses,
we cannot forcely assemble them back to array. Kernel will treat only
one of them as reshape progress. However, their data is still laid on
different layouts. It may lead to disaster if reshape goes on.

Reproducible Steps:
mdadm -C /dev/md0 --assume-clean -l5 -n3 /dev/loop[012]
mdadm -a /dev/md0 /dev/loop3
mdadm -G /dev/md0 -n4
mdadm -f /dev/md0 /dev/loop0 # after a period
mdadm -S /dev/md0 # after another period
mdadm -E /dev/loop[01] # make sure that they claims different ones

mdadm -Af -R /dev/md0 /dev/loop[023] # give no enough devices for
force_array() to pick non-fresh devices
cat /sys/block/md0/md/reshape_position # You can see that Kernel resume
reshape the from any progress of them.

Note: The unit of mdadm -E is KB, but reshape_position's is sector.

In order to prevent disaster, we add logics to prevent devices with
different reshape progress from being added into the array.

Reported-by: Allen Peng <allenpeng@synology.com>
Reviewed-by: Alex Wu <alexwu@synology.com>
Signed-off-by: BingJing Chang <bingjingc@synology.com>
---
  Assemble.c | 22 ++++++++++++++++++++--
  1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/Assemble.c b/Assemble.c
index 9e19246..9f33c61 100644
--- a/Assemble.c
+++ b/Assemble.c
@@ -846,7 +846,19 @@ static int force_array(struct mdinfo *content,
  					/* OK */;
  				else
  					continue;
-			}
+			} else if (devices[j].i.reshape_active !=
+			    content->reshape_active ||
+			    (devices[j].i.reshape_active &&
+			    devices[j].i.reshape_progress !=
+			    content->reshape_progress))
+				/* Here, it may be a source of data. If two
+				 * devices claim different progresses, it
+				 * means that reshape boundaries differ for
+				 * their own devices. Kernel will only treat
+				 * the first one as reshape progress and
+				 * go on. It may cause disaster, so avoid it.
+				 */
+				continue;
  			if (chosen_drive < 0 ||
  			     devices[j].i.events
  			    > devices[chosen_drive].i.events)
@@ -908,7 +920,13 @@ static int force_array(struct mdinfo *content,
  			if (j >= 0 &&
  			    !devices[j].uptodate &&
  			    devices[j].i.recovery_start == MaxSector &&
-			    devices[j].i.events == current_events) {
+			    devices[j].i.events == current_events &&
+			    ((!devices[j].i.reshape_active &&
+			    !content->reshape_active) ||
+			    (devices[j].i.reshape_active ==
+			    content->reshape_active &&
+			    devices[j].i.reshape_progress ==
+			    content->reshape_progress))) {
  				chosen_drive = j;
  				goto add_another;
  			}
-- 
2.7.4

