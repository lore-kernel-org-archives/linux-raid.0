From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 2/6] UT FIX: imsm container can have different blocks number
Date: Tue, 08 Feb 2011 14:30:45 +0100
Message-ID: <20110208133045.8787.69711.stgit@gklab-128-013.igk.intel.com>
References: <20110208131046.8787.1777.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110208131046.8787.1777.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

When imsm container is created it have different blocks number
in /proc/mdstat depending on containing array raid level (raid0/raid5).
raid5 case:
md127 : inactive sdd[3](S) sde[2](S) sdc[1](S) sdb[0](S)
      2884 blocks super external:imsm

raid0 case:
md127 : inactive sdd[3](S) sde[2](S) sdc[1](S) sdb[0](S)
      836 blocks super external:imsm

Due to this, it cannot be compared to one value for both cases.

Test imsm container existence before unit test run only.

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 tests/env-imsm-template |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tests/env-imsm-template b/tests/env-imsm-template
index 74c43c6..7a2890c 100644
--- a/tests/env-imsm-template
+++ b/tests/env-imsm-template
@@ -2,7 +2,7 @@ imsm_check() {
     udevadm settle
     case $1 in
     container )
-        grep -s "$(((418 * $2) / 2)) blocks super external:imsm" /proc/mdstat > /dev/null || {
+        grep -s "blocks super external:imsm" /proc/mdstat > /dev/null || {
             echo >&2 "**Fatal** Correctly formed container not found"; cat /proc/mdstat; exit 1; }
         ;;
     member )

