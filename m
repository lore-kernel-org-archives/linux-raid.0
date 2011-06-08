From: Adam Kwolek <adam.kwolek@intel.com>
Subject: [PATCH 21/21] MAN: Man update for check-pointing
Date: Wed, 08 Jun 2011 18:12:22 +0200
Message-ID: <20110608161222.24327.36035.stgit@gklab-128-013.igk.intel.com>
References: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608160222.24327.71439.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, dan.j.williams@intel.com, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
---

 mdadm.8.in |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/mdadm.8.in b/mdadm.8.in
index e1d5651..f549dbf 100644
--- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -2225,8 +2225,8 @@ succeed.
 This is for the following reasons:
 
 .IP 1.
-Intel's native IMSM check-pointing is not fully implemented yet.
-This causes IMSM incompatibility during the grow process: an array
+Intel's native IMSM check-pointing is not fully tested yet.
+This can causes IMSM incompatibility during the grow process: an array
 which is growing cannot roam between Microsoft Windows(R) and Linux
 systems.
 
@@ -2234,6 +2234,11 @@ systems.
 Interrupting a grow operation is not recommended, because it
 has not been fully tested for Intel's IMSM container format yet.
 
+.PP
+Note: Intel's native checkpointing doesn't use
+.B --backup-file
+option and it is transparent for assembly feature.
+
 .SS SIZE CHANGES
 Normally when an array is built the "size" is taken from the smallest
 of the drives.  If all the small drives in an arrays are, one at a

